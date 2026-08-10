import 'package:flutter_test/flutter_test.dart';
import 'package:profileforge/core/ai/psychological_profile.dart';
import 'package:profileforge/features/missions/domain/mission_generator.dart';
import 'package:profileforge/features/onboarding/domain/onboarding_models.dart';

void main() {
  const gen = MissionGenerator();

  OnboardingProfile profile() => const OnboardingProfile(
        profileId: 'p1',
        grades: {'Math': '92%', 'Physics': '88%'},
        activities: ['Robotics club'],
        subjects: ['Math', 'Physics'],
        targetUniversities: ['MIT'],
        careerInterests: ['AI research'],
        availabilityHoursPerWeek: 12,
      );

  group('MissionGenerator psych-awareness (gauntlet R1 fix)', () {
    test('low self-efficacy scales XP down and scaffolds the first step', () {
      const psych = PsychologicalProfile(selfEfficacy: 0.2);
      final missions = gen.generateDaily(profile(), 'p1', psych);

      expect(missions, isNotEmpty);
      // XP must be below the un-adapted baseline for the weakest-subject task.
      final baseline = gen.generateDaily(profile(), 'p1');
      final adapted = missions.firstWhere((m) => m.pillar == 'academics');
      final base =
          baseline.firstWhere((m) => m.pillar == 'academics').xp;
      expect(adapted.xp, lessThan(base),
          reason: 'low efficacy must get gentler XP (competence via wins)');
      // Scaffolding prefix present.
      expect(
        missions.any((m) => m.title.startsWith('Start with 15 min: ')),
        isTrue,
        reason: 'low efficacy needs a small first step',
      );
    });

    test('high autonomy adds the open self-directed mission', () {
      const psych = PsychologicalProfile(autonomy: 0.8);
      final missions = gen.generateDaily(profile(), 'p1', psych);
      final baseline = gen.generateDaily(profile(), 'p1');

      expect(missions.length, greaterThan(baseline.length));
      expect(
        missions.any((m) => m.title.contains('your call')),
        isTrue,
        reason: 'SDT autonomy support: hand the wheel back',
      );
    });

    test('high relatedness adds the peer-study mission', () {
      const psych = PsychologicalProfile(relatedness: 0.8);
      final missions = gen.generateDaily(profile(), 'p1', psych);
      final baseline = gen.generateDaily(profile(), 'p1');

      expect(missions.length, greaterThan(baseline.length));
      expect(
        missions.any((m) => m.title.toLowerCase().contains('peer') ||
            m.title.toLowerCase().contains('friend')),
        isTrue,
        reason: 'SDT relatedness support: collaboration mission',
      );
    });

    test('no psych profile falls back to the standard set (backwards-compat)',
        () {
      final withPsych = gen.generateDaily(profile(), 'p1', null);
      final baseline = gen.generateDaily(profile(), 'p1');

      // Same titles, same size — null psych must not change behavior.
      expect(withPsych.length, baseline.length);
      expect(
        withPsych.map((m) => m.title).toList(),
        baseline.map((m) => m.title).toList(),
      );
    });
  });
}