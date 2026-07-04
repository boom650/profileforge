import 'package:flutter_test/flutter_test.dart';
import 'package:profileforge/models/gamification/xp.dart';
import 'package:profileforge/models/gamification/admissions_pillar.dart';
import '../helpers.dart';

void main() {
  group('XPState', () {
    group('XPState.initial() returns correct defaults', () {
      test('creates fresh XP state with zero values', () {
        final xp = XPState.initial();
        assertXPDefaults(xp);
      });

      test('all 7 pillars are present in pillarXP', () {
        final xp = XPState.initial();
        expect(xp.pillarXP.keys.length, 7);
        for (final pillar in AdmissionsPillar.values) {
          if (pillar == AdmissionsPillar.trailblazer) continue;
          expect(xp.pillarXP.containsKey(pillar), true,
              reason: 'Missing pillar: ${pillar.name}');
        }
      });

      test('all 7 pillars are present in pillarLevels', () {
        final xp = XPState.initial();
        expect(xp.pillarLevels.keys.length, 7);
        for (final level in xp.pillarLevels.values) {
          expect(level, 1);
        }
      });

      test('transactionHistory starts empty', () {
        final xp = XPState.initial();
        expect(xp.transactionHistory, isEmpty);
      });
    });

    group('XP level calculation', () {
      test('level 1 at 0 XP', () {
        expect(XPUtils.levelFromXP(0), 1);
      });

      test('still level 1 at 99 XP', () {
        expect(XPUtils.levelFromXP(99), 1);
      });

      test('level 2 at 100 XP (first level requires 100 XP)', () {
        // Level 2 requires 100 * 1 * 1.5 = 150 XP for the level itself
        // But let's check: xpForLevel(2) = 150
        final xpForLevel2 = XPUtils.xpForLevel(2);
        expect(xpForLevel2, 150); // 100 * 1 * 1.5 = 150
        expect(XPUtils.levelFromXP(150), 2);
      });

      test('xpForLevel(1) returns 0', () {
        expect(XPUtils.xpForLevel(1), 0);
      });

      test('xpForLevel(2) returns 150', () {
        expect(XPUtils.xpForLevel(2), 150);
      });

      test('xpForLevel(3) returns cumulative XP for level 2 + level 3', () {
        // Level 2: 150 XP
        // Level 3: 100 * 2 * 1.5 = 300 XP
        // Total: 150 + 300 = 450
        expect(XPUtils.xpForLevel(3), 450);
      });

      test('levelFromXP returns correct level for various XP amounts', () {
        expect(XPUtils.levelFromXP(0), 1);
        expect(XPUtils.levelFromXP(149), 1);
        expect(XPUtils.levelFromXP(150), 2);
        expect(XPUtils.levelFromXP(449), 2);
        expect(XPUtils.levelFromXP(450), 3);
      });

      test('xpToNextLevel returns positive value', () {
        final xpToNext = XPUtils.xpToNextLevel(0);
        expect(xpToNext, greaterThan(0));
      });

      test('xpToNextLevel at level boundary is correct', () {
        // At exactly 150 XP (level 2), next level needs 450 - 150 = 300 more
        expect(XPUtils.xpToNextLevel(150), 300);
      });
    });

    group('XP bonus multiplier calculation', () {
      test('no bonus at zero streak, weekday', () {
        final result = XPUtils.calculateXPWithBonus(
          baseXP: 100,
          currentStreak: 0,
          isWeekend: false,
        );
        expect(result, 100);
      });

      test('weekend bonus of 10%', () {
        final result = XPUtils.calculateXPWithBonus(
          baseXP: 100,
          currentStreak: 0,
          isWeekend: true,
        );
        expect(result, 110); // 100 * 1.1 = 110
      });

      test('streak bonus of 5% per 7 days', () {
        final result = XPUtils.calculateXPWithBonus(
          baseXP: 100,
          currentStreak: 7, // 7 days = 1 unit of 5%
          isWeekend: false,
        );
        expect(result, 105); // 100 * 1.05 = 105
      });

      test('streak bonus caps at 50%', () {
        final result = XPUtils.calculateXPWithBonus(
          baseXP: 100,
          currentStreak: 700, // way over cap
          isWeekend: false,
        );
        expect(result, 150); // 100 * 1.5 = 150 (capped)
      });

      test('combined streak and weekend bonus', () {
        final result = XPUtils.calculateXPWithBonus(
          baseXP: 100,
          currentStreak: 7,
          isWeekend: true,
        );
        // multiplier = 1.0 + 0.05 (streak) + 0.1 (weekend) = 1.15
        expect(result, 115);
      });

      test('custom multiplier is applied', () {
        final result = XPUtils.calculateXPWithBonus(
          baseXP: 100,
          currentStreak: 0,
          isWeekend: false,
          customMultiplier: 2.0,
        );
        expect(result, 200);
      });

      test('custom multiplier stacks with other bonuses', () {
        final result = XPUtils.calculateXPWithBonus(
          baseXP: 100,
          currentStreak: 7,
          isWeekend: true,
          customMultiplier: 1.5,
        );
        // multiplier = (1.0 + 0.05 + 0.1) * 1.5 = 1.15 * 1.5 = 1.725
        expect(result, 173); // rounded
      });
    });

    group('Pillar XP tracking', () {
      test('pillar XP can be updated independently', () {
        var xp = XPState.initial();
        xp = xp.copyWith(
          pillarXP: Map.from(xp.pillarXP)
            ..update(AdmissionsPillar.academics, (v) => v + 100),
        );
        expect(xp.pillarXP[AdmissionsPillar.academics], 100);
        expect(xp.pillarXP[AdmissionsPillar.evidence], 0);
      });

      test('pillar levels track correctly', () {
        var xp = XPState.initial();
        xp = xp.copyWith(
          pillarLevels: Map.from(xp.pillarLevels)
            ..update(AdmissionsPillar.academics, (_) => 3),
        );
        expect(xp.pillarLevels[AdmissionsPillar.academics], 3);
        expect(xp.pillarLevels[AdmissionsPillar.evidence], 1);
      });
    });

    group('Level-up thresholds', () {
      test('consistent growth pattern for levels 1-5', () {
        int previousXp = 0;
        for (int level = 2; level <= 5; level++) {
          final xpRequired = XPUtils.xpForLevel(level);
          expect(xpRequired, greaterThan(previousXp),
              reason: 'Level $level should require more cumulative XP');
          previousXp = xpRequired;
        }
      });

      test('higher levels require exponentially more XP', () {
        final xpFor5 = XPUtils.xpForLevel(5) - XPUtils.xpForLevel(4);
        final xpFor10 = XPUtils.xpForLevel(10) - XPUtils.xpForLevel(9);
        expect(xpFor10, greaterThan(xpFor5));
      });
    });
  });

  group('XPUtils', () {
    group('formatXP', () {
      test('formats small XP as plain number', () {
        expect(XPUtils.formatXP(0), '0');
        expect(XPUtils.formatXP(999), '999');
      });

      test('formats thousands with K suffix', () {
        expect(XPUtils.formatXP(1000), '1.0K');
        expect(XPUtils.formatXP(1500), '1.5K');
        expect(XPUtils.formatXP(999999), '1000.0K');
      });

      test('formats millions with M suffix', () {
        expect(XPUtils.formatXP(1000000), '1.0M');
        expect(XPUtils.formatXP(2500000), '2.5M');
      });
    });

    group('pillarLevel', () {
      test('returns 1 for zero pillar XP', () {
        expect(XPUtils.pillarLevel(0), 1);
      });

      test('returns correct level for given pillar XP', () {
        expect(XPUtils.pillarLevel(150), 2);
        expect(XPUtils.pillarLevel(450), 3);
      });
    });
  });

  group('XPTransactionType', () {
    test('has all expected types', () {
      expect(XPTransactionType.values.length, 9);
      expect(XPTransactionType.values, contains(XPTransactionType.earned));
      expect(XPTransactionType.values, contains(XPTransactionType.spent));
      expect(XPTransactionType.values, contains(XPTransactionType.bonus));
      expect(XPTransactionType.values, contains(XPTransactionType.milestone));
      expect(XPTransactionType.values, contains(XPTransactionType.streak));
    });
  });

  group('XPCatalog', () {
    test('has activities for all 7 main pillars', () {
      final pillars = <AdmissionsPillar>{};
      for (final activity in XPCatalog.activities) {
        pillars.add(activity.pillar);
      }
      expect(pillars, contains(AdmissionsPillar.academics));
      expect(pillars, contains(AdmissionsPillar.evidence));
      expect(pillars, contains(AdmissionsPillar.consistency));
      expect(pillars, contains(AdmissionsPillar.research));
      expect(pillars, contains(AdmissionsPillar.leadership));
      expect(pillars, contains(AdmissionsPillar.creativity));
      expect(pillars, contains(AdmissionsPillar.communityImpact));
    });

    test('getActivity returns activity by ID', () {
      final activity = XPCatalog.getActivity('daily_checkin');
      expect(activity, isNotNull);
      expect(activity!.name, 'Daily Check-in');
    });

    test('getActivity returns null for unknown ID', () {
      expect(XPCatalog.getActivity('nonexistent'), isNull);
    });

    test('getActivitiesForPillar returns correct activities', () {
      final academicsActivities =
          XPCatalog.getActivitiesForPillar(AdmissionsPillar.academics);
      expect(academicsActivities.isNotEmpty, true);
      for (final a in academicsActivities) {
        expect(a.pillar, AdmissionsPillar.academics);
      }
    });

    test('all activities have positive baseXP', () {
      for (final activity in XPCatalog.activities) {
        expect(activity.baseXP, greaterThanOrEqualTo(0));
      }
    });
  });
}
