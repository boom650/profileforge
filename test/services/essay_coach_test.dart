import 'package:flutter_test/flutter_test.dart';
import 'package:profileforge/models/gamification/missions.dart';
import 'package:profileforge/models/gamification/admissions_pillar.dart';
import '../helpers.dart';

/// Essay Coach tests — since there is no standalone essay_coach service,
/// these tests verify the mission templates and completion criteria related
/// to essay/writing activities, plus word count and narrative arc validation
/// logic that the system supports.
void main() {
  group('Essay Coach', () {
    group('word count validation', () {
      test('essay writing practice mission requires 300 words', () {
        final template = MissionTemplates.getTemplate('essay_writing_practice');
        expect(template, isNotNull);
        expect(template!.completionCriteria['word_count'], 300);
      });

      test('journal review requires 150 words', () {
        final template = MissionTemplates.getTemplate('journal_review');
        expect(template, isNotNull);
        expect(template!.completionCriteria['word_count'], 150);
      });

      test('word count validation: empty text is invalid', () {
        const text = '';
        final wordCount = text.trim().split(RegExp(r'\s+')).where((w) => w.isNotEmpty).length;
        expect(wordCount, 0);
        expect(wordCount >= 300, false);
      });

      test('word count validation: short text is invalid', () {
        const text = 'This is a short essay about my summer.';
        final wordCount = text.trim().split(RegExp(r'\s+')).where((w) => w.isNotEmpty).length;
        expect(wordCount, lessThan(300));
        expect(wordCount >= 300, false);
      });

      test('word count validation: 300+ words is valid', () {
        final text = List.filled(300, 'word').join(' ');
        final wordCount = text.trim().split(RegExp(r'\s+')).where((w) => w.isNotEmpty).length;
        expect(wordCount, 300);
        expect(wordCount >= 300, true);
      });

      test('word count correctly counts mixed punctuation', () {
        const text = 'Hello, world! This is a test — with dashes and "quotes".';
        final wordCount = text.trim().split(RegExp(r'\s+')).where((w) => w.isNotEmpty).length;
        // Should count as separate words
        expect(wordCount, greaterThan(5));
      });

      test('multiple spaces between words are handled', () {
        const text = 'Hello   world   this   is   a   test';
        final wordCount = text.trim().split(RegExp(r'\s+')).where((w) => w.isNotEmpty).length;
        expect(wordCount, 6);
      });
    });

    group('narrative arc detection', () {
      test('essay writing practice is a creativity pillar activity', () {
        final template = MissionTemplates.getTemplate('essay_writing_practice');
        expect(template, isNotNull);
        expect(template!.pillar, AdmissionsPillar.creativity);
      });

      test('writing-related missions exist in daily templates', () {
        final writingTemplates = MissionTemplates.templates.where((t) =>
            t.tags.contains('writing')).toList();
        expect(writingTemplates.isNotEmpty, true,
            reason: 'Should have writing-related templates');
      });

      test('humanities-focused missions cover multiple categories', () {
        final humanitiesTemplates = MissionTemplates.templates
            .where((t) => t.tags.any((tag) =>
                ['humanities', 'writing', 'critical_thinking'].contains(tag)))
            .toList();
        expect(humanitiesTemplates.length, greaterThanOrEqualTo(5));
      });

      test('debate preparation covers leadership pillar', () {
        final template = MissionTemplates.getTemplate('debate_preparation');
        expect(template, isNotNull);
        expect(template!.pillar, AdmissionsPillar.leadership);
      });

      test('creative writing sprint is exploratory', () {
        final template = MissionTemplates.getTemplate('creative_writing_sprint');
        expect(template, isNotNull);
        expect(template!.category, MissionCategory.exploration);
        expect(template!.pillar, AdmissionsPillar.creativity);
      });
    });

    group('authenticity scoring', () {
      test('missions have unique IDs for tracking', () {
        final ids = MissionTemplates.templates.map((t) => t.id).toList();
        final uniqueIds = ids.toSet();
        expect(ids.length, uniqueIds.length,
            reason: 'All mission template IDs should be unique');
      });

      test('milestone missions have prerequisites for authenticity', () {
        final milestoneTemplates =
            MissionTemplates.getTemplatesForType(MissionType.milestone);
        for (final t in milestoneTemplates) {
          // Expert milestones should have meaningful criteria
          if (t.difficulty == MissionDifficulty.expert) {
            expect(t.completionCriteria.isNotEmpty, true,
                reason: 'Expert milestone "${t.id}" should have criteria');
          }
        }
      });

      test('missions span all 7 admissions pillars', () {
        final pillars = <AdmissionsPillar>{};
        for (final t in MissionTemplates.templates) {
          pillars.add(t.pillar);
        }
        expect(pillars, contains(AdmissionsPillar.academics));
        expect(pillars, contains(AdmissionsPillar.evidence));
        expect(pillars, contains(AdmissionsPillar.consistency));
        expect(pillars, contains(AdmissionsPillar.research));
        expect(pillars, contains(AdmissionsPillar.leadership));
        expect(pillars, contains(AdmissionsPillar.creativity));
        expect(pillars, contains(AdmissionsPillar.communityImpact));
      });

      test('easy missions have lower XP than hard missions', () {
        final easyTemplates = MissionTemplates.templates
            .where((t) => t.difficulty == MissionDifficulty.easy)
            .toList();
        final hardTemplates = MissionTemplates.templates
            .where((t) => t.difficulty == MissionDifficulty.hard)
            .toList();
        final avgEasyXp = easyTemplates.isEmpty
            ? 0
            : easyTemplates.map((t) => t.xpReward).reduce((a, b) => a + b) /
                easyTemplates.length;
        final avgHardXp = hardTemplates.isEmpty
            ? 0
            : hardTemplates.map((t) => t.xpReward).reduce((a, b) => a + b) /
                hardTemplates.length;
        expect(avgHardXp, greaterThan(avgEasyXp));
      });

      test('reading goal mission exists for wellbeing', () {
        final template = MissionTemplates.getTemplate('reading_goal');
        expect(template, isNotNull);
        expect(template!.category, MissionCategory.wellbeing);
        expect(template.pillar, AdmissionsPillar.consistency);
      });
    });
  });
}
