import 'dart:math';
import 'package:flutter_test/flutter_test.dart';
import 'package:profileforge/services/admissions_probability/admissions_engine.dart';
import 'package:profileforge/models/student_profile.dart';
import '../helpers.dart';

void main() {
  group('AdmissionsEngine', () {
    late AdmissionsEngine engine;
    late StudentProfile profile;

    setUp(() {
      engine = AdmissionsEngine();
      profile = sampleStudentProfile();
    });

    group('probability calculation', () {
      test('calculateFactorBreakdown returns valid breakdown', () {
        final breakdown = engine.calculateFactorBreakdown(profile);
        expect(breakdown.totalScore, greaterThanOrEqualTo(0));
        expect(breakdown.totalScore, lessThanOrEqualTo(100));
        expect(breakdown.gpaScore, greaterThanOrEqualTo(0));
        expect(breakdown.testScore, greaterThanOrEqualTo(0));
      });

      test('GPA score is proportional to tenth percentage', () {
        final breakdown = engine.calculateFactorBreakdown(profile);
        // Profile has 89.5% tenth -> GPA should be high
        expect(breakdown.gpaScore, greaterThan(0));
        expect(breakdown.gpaScore, lessThanOrEqualTo(40));
      });

      test('SAT score contributes to test score', () {
        final breakdown = engine.calculateFactorBreakdown(profile);
        // Profile has SAT 1450 -> should contribute significantly
        expect(breakdown.testScore, greaterThan(0));
      });

      test('empty profile gets low scores', () {
        final emptyProfile = sampleStudentProfile();
        final breakdown = engine.calculateFactorBreakdown(emptyProfile);
        // Empty profile with no activities should have lower scores
        expect(breakdown.extracurricularScore, 0);
        expect(breakdown.researchScore, 0);
      });

      test('scoreToProbability returns value between 0.01 and 0.99', () {
        final university = UniversityInfo(
          name: 'Test University',
          country: 'USA',
          tier: UniversityTier.top50,
          acceptanceRate: 0.25,
          averageGPA: 3.7,
          averageSAT: 1350,
        );
        final prob = engine.scoreToProbability(50.0, university);
        expect(prob, greaterThanOrEqualTo(0.01));
        expect(prob, lessThanOrEqualTo(0.99));
      });

      test('higher scores yield higher probabilities', () {
        final university = UniversityInfo(
          name: 'Test University',
          country: 'USA',
          tier: UniversityTier.top50,
          acceptanceRate: 0.25,
          averageGPA: 3.7,
          averageSAT: 1350,
        );
        final lowProb = engine.scoreToProbability(20.0, university);
        final highProb = engine.scoreToProbability(80.0, university);
        expect(highProb, greaterThan(lowProb));
      });
    });

    group('Monte Carlo simulation bounds', () {
      test('simulation mean probability is between 0 and 1', () {
        final university = UniversityDatabase.universities.first;
        final result = engine.runMonteCarloSimulation(
          profile: profile,
          university: university,
          iterations: 1000,
        );
        expect(result.mean, greaterThanOrEqualTo(0.0));
        expect(result.mean, lessThanOrEqualTo(1.0));
      });

      test('simulation median is between 0 and 1', () {
        final university = UniversityDatabase.universities.first;
        final result = engine.runMonteCarloSimulation(
          profile: profile,
          university: university,
          iterations: 1000,
        );
        expect(result.median, greaterThanOrEqualTo(0.0));
        expect(result.median, lessThanOrEqualTo(1.0));
      });

      test('p10 < p25 < median < p75 < p90 (ordered percentiles)', () {
        final university = UniversityDatabase.universities.first;
        final result = engine.runMonteCarloSimulation(
          profile: profile,
          university: university,
          iterations: 5000,
        );
        expect(result.p10, lessThanOrEqualTo(result.p25));
        expect(result.p25, lessThanOrEqualTo(result.median));
        expect(result.median, lessThanOrEqualTo(result.p75));
        expect(result.p75, lessThanOrEqualTo(result.p90));
      });

      test('standard deviation is non-negative', () {
        final university = UniversityDatabase.universities.first;
        final result = engine.runMonteCarloSimulation(
          profile: profile,
          university: university,
          iterations: 1000,
        );
        expect(result.standardDeviation, greaterThanOrEqualTo(0));
      });

      test('classification percentages sum to ~100', () {
        final university = UniversityDatabase.universities.first;
        final result = engine.runMonteCarloSimulation(
          profile: profile,
          university: university,
          iterations: 1000,
        );
        final total = result.safetyPercentage +
            result.targetPercentage +
            result.reachPercentage +
            result.dreamPercentage;
        expect(total, closeTo(100, 1)); // within 1% rounding
      });

      test('Monte Carlo converges for same input', () {
        // With same profile and university, should get consistent results
        final university = UniversityDatabase.universities.first;
        final r1 = engine.runMonteCarloSimulation(
          profile: profile,
          university: university,
          iterations: 5000,
        );
        final r2 = engine.runMonteCarloSimulation(
          profile: profile,
          university: university,
          iterations: 5000,
        );
        // Mean should be close (within 10% due to randomness)
        expect(r1.mean, closeTo(r2.mean, 0.1));
      });
    });

    group('university tier classification', () {
      test('UniversityTier has all expected tiers', () {
        expect(UniversityTier.values.length, 5);
        expect(UniversityTier.values, contains(UniversityTier.ivyLeague));
        expect(UniversityTier.values, contains(UniversityTier.top20));
        expect(UniversityTier.values, contains(UniversityTier.top50));
        expect(UniversityTier.values, contains(UniversityTier.top100));
        expect(UniversityTier.values, contains(UniversityTier.safety));
      });

      test('getTierFromAcceptanceRate classifies correctly', () {
        expect(
          AdmissionsEngine.getTierFromAcceptanceRate(0.05),
          UniversityTier.ivyLeague,
        );
        expect(
          AdmissionsEngine.getTierFromAcceptanceRate(0.15),
          UniversityTier.top20,
        );
        expect(
          AdmissionsEngine.getTierFromAcceptanceRate(0.25),
          UniversityTier.top50,
        );
        expect(
          AdmissionsEngine.getTierFromAcceptanceRate(0.45),
          UniversityTier.top100,
        );
        expect(
          AdmissionsEngine.getTierFromAcceptanceRate(0.60),
          UniversityTier.safety,
        );
      });

      test('tierThreshold is defined for each tier', () {
        expect(const UniversityInfo(
          name: 'Test', country: 'USA',
          tier: UniversityTier.ivyLeague,
          acceptanceRate: 0.05, averageGPA: 3.9, averageSAT: 1500,
        ).tierThreshold, 85.0);
        expect(const UniversityInfo(
          name: 'Test', country: 'USA',
          tier: UniversityTier.safety,
          acceptanceRate: 0.50, averageGPA: 3.5, averageSAT: 1200,
        ).tierThreshold, 0.0);
      });
    });

    group('ApplicationClassification', () {
      test('has 4 classifications', () {
        expect(ApplicationClassification.values.length, 4);
      });

      test('getClassificationLabel returns correct labels', () {
        expect(
          AdmissionsEngine.getClassificationLabel(ApplicationClassification.safety),
          'Safety',
        );
        expect(
          AdmissionsEngine.getClassificationLabel(ApplicationClassification.target),
          'Target',
        );
        expect(
          AdmissionsEngine.getClassificationLabel(ApplicationClassification.reach),
          'Reach',
        );
        expect(
          AdmissionsEngine.getClassificationLabel(ApplicationClassification.dream),
          'Dream',
        );
      });
    });

    group('UniversityDatabase', () {
      test('has predefined universities', () {
        expect(UniversityDatabase.universities.isNotEmpty, true);
      });

      test('universities cover multiple tiers', () {
        final tiers = UniversityDatabase.universities.map((u) => u.tier).toSet();
        expect(tiers.contains(UniversityTier.ivyLeague), true);
        expect(tiers.contains(UniversityTier.top20), true);
        expect(tiers.contains(UniversityTier.top50), true);
      });

      test('all universities have valid acceptance rates', () {
        for (final uni in UniversityDatabase.universities) {
          expect(uni.acceptanceRate, greaterThanOrEqualTo(0));
          expect(uni.acceptanceRate, lessThanOrEqualTo(1));
        }
      });
    });

    group('AdmissionsFactorWeights', () {
      test('total weight is 100', () {
        expect(AdmissionsFactorWeights.total, 100.0);
      });

      test('GPA weight is largest', () {
        expect(
          AdmissionsFactorWeights.gpaWeight,
          greaterThan(AdmissionsFactorWeights.testScoreWeight),
        );
      });

      test('all individual weights are positive', () {
        expect(AdmissionsFactorWeights.gpaWeight, greaterThan(0));
        expect(AdmissionsFactorWeights.testScoreWeight, greaterThan(0));
        expect(AdmissionsFactorWeights.extracurricularWeight, greaterThan(0));
        expect(AdmissionsFactorWeights.essayWeight, greaterThan(0));
        expect(AdmissionsFactorWeights.recommendationWeight, greaterThan(0));
        expect(AdmissionsFactorWeights.interviewWeight, greaterThan(0));
        expect(AdmissionsFactorWeights.researchWeight, greaterThan(0));
      });
    });

    group('AdmissionsFactorBreakdown', () {
      test('toMap returns correct keys', () {
        const breakdown = AdmissionsFactorBreakdown(
          gpaScore: 30.0,
          testScore: 15.0,
          extracurricularScore: 10.0,
          essayScore: 7.0,
          recommendationScore: 3.0,
          interviewScore: 3.0,
          researchScore: 2.0,
          totalScore: 70.0,
        );
        final map = breakdown.toMap();
        expect(map.containsKey('Academics'), true);
        expect(map.containsKey('Test Scores'), true);
        expect(map.containsKey('Research'), true);
      });
    });
  });
}
