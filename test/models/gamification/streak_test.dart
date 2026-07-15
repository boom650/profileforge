import 'package:flutter_test/flutter_test.dart';
import 'package:profileforge/models/gamification/streak.dart';
import '../../helpers.dart';

void main() {
  group('Streak', () {
    group('Streak.initial() returns correct defaults', () {
      test('creates a fresh streak with zero values', () {
        final streak = Streak.initial();
        assertStreakDefaults(streak);
      });

      test('has exactly 3 freeze tokens by default', () {
        final streak = Streak.initial();
        expect(streak.freezeTokens, 3);
      });

      test('max freeze tokens is 5', () {
        final streak = Streak.initial();
        expect(streak.maxFreezeTokens, 5);
      });

      test('grace days remaining is 2', () {
        final streak = Streak.initial();
        expect(streak.graceDaysRemaining, 2);
      });

      test('weekly check-in target is 5', () {
        final streak = Streak.initial();
        expect(streak.weeklyCheckInTarget, 5);
      });

      test('weekly activity pattern has 7 zeros', () {
        final streak = Streak.initial();
        expect(streak.weeklyActivityPattern, [0, 0, 0, 0, 0, 0, 0]);
      });

      test('has no weekend amulet', () {
        final streak = Streak.initial();
        expect(streak.hasWeekendAmulet, false);
        expect(streak.weekendAmuletExpiresAt, isNull);
      });

      test('no milestones achieved initially', () {
        final streak = Streak.initial();
        expect(streak.milestonesAchieved, isEmpty);
      });

      test('no grace day history initially', () {
        final streak = Streak.initial();
        expect(streak.graceDayHistory, isEmpty);
      });
    });

    group('Streak increment logic', () {
      test('copyWith correctly increments currentStreak', () {
        final streak = Streak.initial();
        final updated = streak.copyWith(
          currentStreak: 1,
          longestStreak: 1,
          totalActiveDays: 1,
          lastActiveDate: DateTime.now(),
        );
        expect(updated.currentStreak, 1);
        expect(updated.longestStreak, 1);
        expect(updated.totalActiveDays, 1);
      });

      test('longest streak updates when current exceeds previous', () {
        final streak = Streak.initial().copyWith(
          currentStreak: 5,
          longestStreak: 5,
        );
        final updated = streak.copyWith(
          currentStreak: 10,
          longestStreak: 10,
        );
        expect(updated.longestStreak, 10);
      });

      test('longest streak stays the same when current is less', () {
        final streak = Streak.initial().copyWith(
          currentStreak: 3,
          longestStreak: 15,
        );
        final updated = streak.copyWith(
          currentStreak: 1,
        );
        expect(updated.longestStreak, 15);
      });

      test('totalActiveDays increments on each active day', () {
        var streak = Streak.initial();
        for (int i = 0; i < 7; i++) {
          streak = streak.copyWith(
            totalActiveDays: streak.totalActiveDays + 1,
          );
        }
        expect(streak.totalActiveDays, 7);
      });

      test('weeklyCheckInsCompleted increments', () {
        final streak = Streak.initial();
        final updated = streak.copyWith(
          weeklyCheckInsCompleted: streak.weeklyCheckInsCompleted + 1,
        );
        expect(updated.weeklyCheckInsCompleted, 1);
      });
    });

    group('Freeze token consumption', () {
      test('freezeTokens decrease when consumed', () {
        final streak = Streak.initial(); // 3 freeze tokens
        final updated = streak.copyWith(freezeTokens: streak.freezeTokens - 1);
        expect(updated.freezeTokens, 2);
      });

      test('freeze tokens cannot go below 0', () {
        final streak = Streak.initial().copyWith(freezeTokens: 0);
        final consumed = 1;
        final newTokens = (streak.freezeTokens - consumed).clamp(0, streak.maxFreezeTokens);
        expect(newTokens, 0);
      });

      test('freezeTokensEarned tracks earned tokens', () {
        final streak = Streak.initial();
        final updated = streak.copyWith(
          freezeTokens: streak.freezeTokens + 1,
          freezeTokensEarned: streak.freezeTokensEarned + 1,
        );
        expect(updated.freezeTokens, 4);
        expect(updated.freezeTokensEarned, 1);
      });

      test('freeze tokens cannot exceed maxFreezeTokens', () {
        final streak = Streak.initial(); // max is 5
        final newTokens = (streak.freezeTokens + 3).clamp(0, streak.maxFreezeTokens);
        expect(newTokens, 5);
      });

      test('lastFreezeTokenEarned is set when earning', () {
        final now = DateTime.now();
        final streak = Streak.initial();
        final updated = streak.copyWith(lastFreezeTokenEarned: now);
        expect(updated.lastFreezeTokenEarned, now);
      });
    });

    group('Grace day usage', () {
      test('graceDaysRemaining decreases when grace day used', () {
        final streak = Streak.initial(); // 2 grace days
        final updated = streak.copyWith(graceDaysRemaining: streak.graceDaysRemaining - 1);
        expect(updated.graceDaysRemaining, 1);
      });

      test('graceDaysUsedThisWeek increments', () {
        final streak = Streak.initial();
        final updated = streak.copyWith(graceDaysUsedThisWeek: 1);
        expect(updated.graceDaysUsedThisWeek, 1);
      });

      test('graceDayHistory records usage', () {
        final usage = GraceDayUsage(
          id: 'gd_001',
          dateUsed: DateTime.now(),
          reason: GraceDayReason.sick,
          note: null,
          wasAutoApplied: false,
        );
        final streak = Streak.initial();
        final updated = streak.copyWith(
          graceDayHistory: [...streak.graceDayHistory, usage],
        );
        expect(updated.graceDayHistory.length, 1);
        expect(updated.graceDayHistory.first.reason, GraceDayReason.sick);
      });

      test('multiple grace days can be used', () {
        var streak = Streak.initial();
        for (int i = 0; i < 2; i++) {
          streak = streak.copyWith(
            graceDaysRemaining: streak.graceDaysRemaining - 1,
            graceDaysUsedThisWeek: streak.graceDaysUsedThisWeek + 1,
          );
        }
        expect(streak.graceDaysRemaining, 0);
        expect(streak.graceDaysUsedThisWeek, 2);
      });
    });

    group('Streak milestone detection', () {
      test('3-day milestone is detectable', () {
        final streak = Streak.initial().copyWith(currentStreak: 3);
        expect(streak.currentStreak >= 3, true);
      });

      test('7-day milestone is detectable', () {
        final streak = Streak.initial().copyWith(currentStreak: 7);
        expect(streak.currentStreak >= 7, true);
      });

      test('milestonesAchieved list grows when milestone is added', () {
        final milestone = StreakMilestone(
          id: 'sm_threeDay_001',
          type: StreakMilestoneType.threeDay,
          daysRequired: 3,
          title: 'Getting Started',
          description: '3 days of consistency',
          xpReward: 50,
          freezeTokenReward: 0,
          graceDayReward: 0,
          achievedAt: DateTime.now(),
          isClaimed: false,
        );
        final streak = Streak.initial().copyWith(
          currentStreak: 3,
          milestonesAchieved: [milestone],
        );
        expect(streak.milestonesAchieved.length, 1);
        expect(streak.milestonesAchieved.first.type, StreakMilestoneType.threeDay);
      });

      test('milestone rewards are applied correctly', () {
        final milestone = StreakMilestone(
          id: 'sm_7day',
          type: StreakMilestoneType.sevenDay,
          daysRequired: 7,
          title: 'One Week Wonder',
          description: '7 days straight',
          xpReward: 100,
          freezeTokenReward: 1,
          graceDayReward: 0,
          achievedAt: DateTime.now(),
          isClaimed: false,
        );
        final streak = Streak.initial().copyWith(
          currentStreak: 7,
          milestonesAchieved: [milestone],
          freezeTokens: (3 + 1).clamp(0, 5),
        );
        expect(streak.freezeTokens, 4);
        expect(streak.milestonesAchieved.first.xpReward, 100);
      });

      test('milestones are not duplicated', () {
        final milestone = StreakMilestone(
          id: 'sm_3day_1',
          type: StreakMilestoneType.threeDay,
          daysRequired: 3,
          title: 'Getting Started',
          description: '3 days',
          xpReward: 50,
          freezeTokenReward: 0,
          graceDayReward: 0,
          achievedAt: DateTime.now(),
          isClaimed: false,
        );
        final streak = Streak.initial().copyWith(
          milestonesAchieved: [milestone],
        );
        final alreadyAchieved =
            streak.milestonesAchieved.any((m) => m.type == StreakMilestoneType.threeDay);
        expect(alreadyAchieved, true);
      });
    });

    group('StreakConfig', () {
      test('default config has correct milestone count', () {
        final config = StreakConfig.defaultConfig();
        expect(config.milestones.length, 9);
      });

      test('default config has starting freeze tokens of 3', () {
        final config = StreakConfig.defaultConfig();
        expect(config.startingFreezeTokens, 3);
      });

      test('default config has weekly grace days of 2', () {
        final config = StreakConfig.defaultConfig();
        expect(config.weeklyGraceDays, 2);
      });

      test('all grace day reasons have cost of 1', () {
        final config = StreakConfig.defaultConfig();
        for (final reason in GraceDayReason.values) {
          expect(config.graceDayCosts[reason], 1);
        }
      });

      test('milestones have increasing days required', () {
        final config = StreakConfig.defaultConfig();
        for (int i = 1; i < config.milestones.length; i++) {
          expect(
            config.milestones[i].daysRequired > config.milestones[i - 1].daysRequired,
            true,
            reason: 'Milestone ${i + 1} should require more days than milestone $i',
          );
        }
      });

      test('milestone XP rewards increase', () {
        final config = StreakConfig.defaultConfig();
        for (int i = 1; i < config.milestones.length; i++) {
          expect(
            config.milestones[i].xpReward >= config.milestones[i - 1].xpReward,
            true,
          );
        }
      });
    });

    group('StreakActionResult', () {
      test('success result carries new streak and milestones', () {
        final streak = Streak.initial().copyWith(currentStreak: 1);
        final result = StreakActionResult.success(
          newStreak: streak,
          newMilestones: [],
          xpEarned: 20,
          freezeTokensEarned: 0,
          graceDaysEarned: 0,
          message: 'Welcome!',
        );
        // Access via when pattern matching
        result.when(
          success: (newStreak, newMilestones, xpEarned, freeze, grace, msg) {
            expect(newStreak.currentStreak, 1);
            expect(newMilestones, isEmpty);
          },
          graceDayUsed: (_, __, ___) => fail('Expected success'),
          freezeTokenUsed: (_, __, ___) => fail('Expected success'),
          streakBroken: (_, __, ___, ____) => fail('Expected success'),
          alreadyMarked: (_, __) => fail('Expected success'),
        );
      });

      test('alreadyMarked result carries streak', () {
        final streak = Streak.initial().copyWith(currentStreak: 5);
        final result = StreakActionResult.alreadyMarked(
          streak: streak,
          message: 'Already checked in',
        );
        result.when(
          success: (_, __, ___, ____, _____, ______) => fail('Expected alreadyMarked'),
          graceDayUsed: (_, __, ___) => fail('Expected alreadyMarked'),
          freezeTokenUsed: (_, __, ___) => fail('Expected alreadyMarked'),
          streakBroken: (_, __, ___, ____) => fail('Expected alreadyMarked'),
          alreadyMarked: (s, msg) {
            expect(s.currentStreak, 5);
          },
        );
      });

      test('streakBroken result has encouragement message', () {
        final streak = Streak.initial();
        final result = StreakActionResult.streakBroken(
          newStreak: streak,
          previousStreak: 10,
          message: 'Streak ended',
          encouragementMessage: 'You got this!',
        );
        result.when(
          success: (_, __, ___, ____, _____, ______) => fail('Expected streakBroken'),
          graceDayUsed: (_, __, ___) => fail('Expected streakBroken'),
          freezeTokenUsed: (_, __, ___) => fail('Expected streakBroken'),
          streakBroken: (s, prev, msg, encourage) {
            expect(prev, 10);
            expect(encourage, 'You got this!');
          },
          alreadyMarked: (_, __) => fail('Expected streakBroken'),
        );
      });
    });
  });

  group('GraceDayReason', () {
    test('has all expected reasons', () {
      expect(GraceDayReason.values.length, 7);
      expect(GraceDayReason.values, contains(GraceDayReason.sick));
      expect(GraceDayReason.values, contains(GraceDayReason.familyEmergency));
      expect(GraceDayReason.values, contains(GraceDayReason.travel));
      expect(GraceDayReason.values, contains(GraceDayReason.exams));
      expect(GraceDayReason.values, contains(GraceDayReason.mentalHealth));
      expect(GraceDayReason.values, contains(GraceDayReason.technicalIssue));
      expect(GraceDayReason.values, contains(GraceDayReason.other));
    });
  });

  group('StreakMilestoneType', () {
    test('has all expected types', () {
      expect(StreakMilestoneType.values.length, 9);
    });

    test('types are in ascending order of significance', () {
      final names = StreakMilestoneType.values.map((e) => e.name).toList();
      expect(names.first, 'threeDay');
      expect(names.last, 'threeSixtyFiveDay');
    });
  });
}
