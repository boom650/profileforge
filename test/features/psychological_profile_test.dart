import 'package:flutter_test/flutter_test.dart';
import 'package:profileforge/core/ai/psychological_profile.dart';

void main() {
  group('PsychologicalProfile.classify', () {
    test('high extraversion + high agreeableness => enthusiastic', () {
      final p = PsychologicalProfile.classify(
        openness: 0.5,
        conscientiousness: 0.5,
        extraversion: 0.85,
        agreeableness: 0.75,
        neuroticism: 0.4,
        autonomy: 0.5,
        competence: 0.5,
        relatedness: 0.6,
        growthMindset: 0.5,
        selfEfficacy: 0.6,
      );
      expect(p.communicationStyle, CommunicationStyle.enthusiastic);
    });

    test('low extraversion + high agreeableness => gentle', () {
      final p = PsychologicalProfile.classify(
        openness: 0.5,
        conscientiousness: 0.5,
        extraversion: 0.2,
        agreeableness: 0.8,
        neuroticism: 0.4,
        autonomy: 0.5,
        competence: 0.5,
        relatedness: 0.6,
        growthMindset: 0.5,
        selfEfficacy: 0.6,
      );
      expect(p.communicationStyle, CommunicationStyle.gentle);
    });

    test('high autonomy => autonomy motivation frame', () {
      final p = PsychologicalProfile.classify(
        openness: 0.5,
        conscientiousness: 0.5,
        extraversion: 0.6,
        agreeableness: 0.6,
        neuroticism: 0.4,
        autonomy: 0.9,
        competence: 0.5,
        relatedness: 0.4,
        growthMindset: 0.5,
        selfEfficacy: 0.6,
      );
      expect(p.motivationFrame, MotivationFrame.autonomy);
    });

    test('low competence => mastery frame', () {
      final p = PsychologicalProfile.classify(
        openness: 0.5,
        conscientiousness: 0.5,
        extraversion: 0.6,
        agreeableness: 0.6,
        neuroticism: 0.4,
        autonomy: 0.3,
        competence: 0.2,
        relatedness: 0.4,
        growthMindset: 0.5,
        selfEfficacy: 0.3,
      );
      expect(p.motivationFrame, MotivationFrame.mastery);
    });

    test('high neuroticism + low self-efficacy => high support', () {
      final p = PsychologicalProfile.classify(
        openness: 0.5,
        conscientiousness: 0.5,
        extraversion: 0.5,
        agreeableness: 0.5,
        neuroticism: 0.85,
        autonomy: 0.5,
        competence: 0.5,
        relatedness: 0.5,
        growthMindset: 0.5,
        selfEfficacy: 0.2,
      );
      expect(p.supportLevel, SupportLevel.high);
    });

    test('high conscientiousness => detailed structure', () {
      final p = PsychologicalProfile.classify(
        openness: 0.5,
        conscientiousness: 0.9,
        extraversion: 0.5,
        agreeableness: 0.5,
        neuroticism: 0.4,
        autonomy: 0.5,
        competence: 0.5,
        relatedness: 0.5,
        growthMindset: 0.5,
        selfEfficacy: 0.6,
      );
      expect(p.structurePreference, StructurePreference.detailed);
    });
  });

  group('PsychologicalProfile.fromOnboardingAnswers', () {
    test('arts + solo work + calm stress => higher openness, planner consc',
        () {
      final p = PsychologicalProfile.fromOnboardingAnswers(
        funActivities: ['Reading', 'Writing', 'Art'],
        workPreference: 'Alone',
        stressResponse: 'breathe',
        planningStyle: 'I make detailed plans and lists',
      );
      // Planner & organised stress handling should raise conscientiousness.
      expect(p.conscientiousness, greaterThan(0.6));
      // Openness boosted by reading/writing/art.
      expect(p.openness, greaterThan(0.5));
    });

    test('defaults fielded (values stay in 0..1 and classify returns a model)',
        () {
      final p = PsychologicalProfile.fromOnboardingAnswers(
        funActivities: ['Sports'],
        workPreference: 'Team',
        stressResponse: 'solve it step by step',
        planningStyle: 'schedule',
      );
      expect(p.selfEfficacy, inInclusiveRange(0.0, 1.0));
      expect(p.communicationStyle, isNotNull);
      expect(p.motivationFrame, isNotNull);
    });
  });
}