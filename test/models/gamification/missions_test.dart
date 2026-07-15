import 'package:flutter_test/flutter_test.dart';
import 'package:profileforge/models/gamification/missions.dart';
import 'package:profileforge/models/gamification/admissions_pillar.dart';
import '../../helpers.dart';

void main() {
  group('Mission', () {
    group('mission creation', () {
      test('creates a valid daily mission', () {
        final mission = sampleDailyMission();
        expect(mission.id, 'mission_daily_001');
        expect(mission.title, 'Daily Check-in');
        expect(mission.type, MissionType.daily);
        expect(mission.difficulty, MissionDifficulty.easy);
        expect(mission.xpReward, 20);
        expect(mission.pillar, AdmissionsPillar.consistency);
        expect(mission.isCompleted, false);
        expect(mission.isClaimed, false);
        expect(mission.progressCurrent, 0);
        expect(mission.progressTarget, 1);
        expect(mission.isRepeatable, true);
        expect(mission.expiresAt, isNotNull);
      });

      test('creates a valid weekly mission', () {
        final mission = sampleWeeklyMission();
        expect(mission.type, MissionType.weekly);
        expect(mission.repeatCooldownDays, 7);
        expect(mission.pillar, AdmissionsPillar.consistency);
      });

      test('mission with progress tracking', () {
        final mission = sampleProgressMission(target: 5, current: 2);
        expect(mission.progressCurrent, 2);
        expect(mission.progressTarget, 5);
        expect(mission.isCompleted, false);
      });

      test('mission with all fields filled', () {
        final mission = Mission(
          id: 'm1',
          title: 'Test Mission',
          description: 'A test mission',
          type: MissionType.milestone,
          category: MissionCategory.exploration,
          difficulty: MissionDifficulty.hard,
          xpReward: 375,
          pillar: AdmissionsPillar.research,
          completionCriteria: {'action': 'research_milestone'},
          prerequisites: ['start_research'],
          isCompleted: false,
          isClaimed: false,
          completedAt: null,
          claimedAt: null,
          createdAt: DateTime.now(),
          expiresAt: null,
          metadata: {'custom': 'data'},
          progressCurrent: 0,
          progressTarget: 1,
          progressUnit: 'milestone',
          isRepeatable: true,
          repeatCooldownDays: 14,
          tags: ['research', 'academic'],
        );
        expect(mission.type, MissionType.milestone);
        expect(mission.prerequisites, ['start_research']);
        expect(mission.metadata, {'custom': 'data'});
      });
    });

    group('mission progress tracking', () {
      test('progress increments correctly', () {
        final mission = sampleProgressMission(target: 5);
        final newProgress = mission.progressCurrent + 2;
        expect(newProgress, 2);
      });

      test('progress clamps at target', () {
        final mission = sampleProgressMission(target: 3, current: 2);
        final newProgress = (mission.progressCurrent + 2)
            .clamp(0, mission.progressTarget);
        expect(newProgress, 3); // clamped at target
      });

      test('progress cannot go negative', () {
        final mission = sampleProgressMission(target: 3, current: 0);
        final newProgress = (mission.progressCurrent - 1)
            .clamp(0, mission.progressTarget);
        expect(newProgress, 0);
      });
    });

    group('mission completion detection', () {
      test('mission is complete when progress >= target', () {
        final mission = sampleProgressMission(target: 3, current: 3);
        expect(mission.progressCurrent >= mission.progressTarget, true);
      });

      test('mission is not complete when progress < target', () {
        final mission = sampleProgressMission(target: 3, current: 2);
        expect(mission.progressCurrent >= mission.progressTarget, false);
      });

      test('completion sets completedAt timestamp', () {
        final now = DateTime.now();
        final mission = sampleProgressMission(target: 1, current: 1).copyWith(
          isCompleted: true,
          completedAt: now,
        );
        expect(mission.isCompleted, true);
        expect(mission.completedAt, now);
      });

      test('claiming sets isClaimed and claimedAt', () {
        final now = DateTime.now();
        final mission = sampleProgressMission(target: 1, current: 1).copyWith(
          isCompleted: true,
          completedAt: now,
          isClaimed: true,
          claimedAt: now,
        );
        expect(mission.isClaimed, true);
        expect(mission.claimedAt, now);
      });
    });

    group('weekly mission set generation', () {
      test('MissionTemplates has templates for all mission types', () {
        final dailyTemplates = MissionTemplates.getTemplatesForType(MissionType.daily);
        final weeklyTemplates = MissionTemplates.getTemplatesForType(MissionType.weekly);
        final milestoneTemplates = MissionTemplates.getTemplatesForType(MissionType.milestone);
        final specialTemplates = MissionTemplates.getTemplatesForType(MissionType.special);
        expect(dailyTemplates.isNotEmpty, true, reason: 'Should have daily templates');
        expect(weeklyTemplates.isNotEmpty, true, reason: 'Should have weekly templates');
        expect(milestoneTemplates.isNotEmpty, true, reason: 'Should have milestone templates');
        expect(specialTemplates.isNotEmpty, true, reason: 'Should have special templates');
      });

      test('daily templates have 1-day cooldown', () {
        final dailyTemplates = MissionTemplates.getTemplatesForType(MissionType.daily);
        for (final t in dailyTemplates) {
          expect(t.repeatCooldownDays, 1);
        }
      });

      test('weekly templates have 7-day or 14-day cooldown', () {
        final weeklyTemplates = MissionTemplates.getTemplatesForType(MissionType.weekly);
        for (final t in weeklyTemplates) {
          expect(
            t.repeatCooldownDays == 7 || t.repeatCooldownDays == 14,
            true,
            reason: 'Weekly template "${t.id}" has unexpected cooldown: ${t.repeatCooldownDays}',
          );
        }
      });

      test('getTemplatesForCategory returns relevant templates', () {
        final wellbeingTemplates =
            MissionTemplates.getTemplatesForCategory(MissionCategory.wellbeing);
        expect(wellbeingTemplates.isNotEmpty, true);
        for (final t in wellbeingTemplates) {
          expect(t.category, MissionCategory.wellbeing);
        }
      });

      test('getTemplate returns template by ID', () {
        final template = MissionTemplates.getTemplate('daily_checkin');
        expect(template, isNotNull);
        expect(template!.title, 'Daily Check-in');
      });

      test('getTemplate returns null for unknown ID', () {
        expect(MissionTemplates.getTemplate('nonexistent'), isNull);
      });

      test('all templates have positive XP reward', () {
        for (final t in MissionTemplates.templates) {
          expect(t.xpReward, greaterThan(0),
              reason: 'Template "${t.id}" has zero XP');
        }
      });

      test('all templates have non-empty tags', () {
        for (final t in MissionTemplates.templates) {
          expect(t.tags.isNotEmpty, true,
              reason: 'Template "${t.id}" has no tags');
        }
      });

      test('all templates have non-empty completion criteria', () {
        for (final t in MissionTemplates.templates) {
          expect(t.completionCriteria.isNotEmpty, true,
              reason: 'Template "${t.id}" has no completion criteria');
        }
      });
    });
  });

  group('MissionType', () {
    test('has 8 types', () {
      expect(MissionType.values.length, 8);
    });

    test('MissionTypeExtension.name works', () {
      expect(MissionType.daily.name, 'daily');
      expect(MissionType.weekly.name, 'weekly');
      expect(MissionType.milestone.name, 'milestone');
    });
  });

  group('MissionDifficulty', () {
    test('has 4 difficulty levels', () {
      expect(MissionDifficulty.values.length, 4);
    });

    test('ordering is easy < medium < hard < expert', () {
      expect(MissionDifficulty.easy.index, lessThan(MissionDifficulty.medium.index));
      expect(MissionDifficulty.medium.index, lessThan(MissionDifficulty.hard.index));
      expect(MissionDifficulty.hard.index, lessThan(MissionDifficulty.expert.index));
    });
  });

  group('MissionGenerationConfig', () {
    test('default config generates expected counts', () {
      final config = MissionGenerationConfig.defaultConfig();
      expect(config.dailyMissionsCount, 3);
      expect(config.weeklyMissionsCount, 5);
      expect(config.ensureVariety, true);
      expect(config.maxRepeatInRow, 2);
    });

    test('category distribution covers all categories', () {
      final config = MissionGenerationConfig.defaultConfig();
      expect(config.categoryDistribution.length, 6);
    });

    test('difficulty distribution covers all difficulties', () {
      final config = MissionGenerationConfig.defaultConfig();
      expect(config.difficultyDistribution.length, 4);
    });
  });
}
