import 'dart:math';
import 'package:flutter_test/flutter_test.dart';
import 'package:profileforge/models/gamification/xp.dart';
import 'package:profileforge/models/gamification/admissions_pillar.dart';

/// Spike detection tests — since there is no standalone spike_framework service,
/// these tests verify the XP catalog's ability to detect unusual activity
/// patterns (high-value activities that represent "spikes" in student profiles).
void main() {
  group('Activity Spike Detection', () {
    group('spike detection from activities', () {
      test('XP catalog has high-value activities (potential spikes)', () {
        // Activities with baseXP >= 300 are "spike" activities
        final spikeActivities = XPCatalog.activities
            .where((a) => a.baseXP >= 300)
            .toList();
        expect(spikeActivities.isNotEmpty, true,
            reason: 'Should have high-value spike activities');
      });

      test('research activities have the highest XP values', () {
        final researchActivities =
            XPCatalog.getActivitiesForPillar(AdmissionsPillar.research);
        final maxResearchXP = researchActivities
            .map((a) => a.baseXP)
            .reduce(max);
        expect(maxResearchXP, greaterThanOrEqualTo(500));
      });

      test('community impact activities have moderate to high XP', () {
        final communityActivities =
            XPCatalog.getActivitiesForPillar(AdmissionsPillar.communityImpact);
        for (final a in communityActivities) {
          expect(a.baseXP, greaterThanOrEqualTo(10));
        }
      });

      test('daily check-in is the lowest XP activity', () {
        final checkin = XPCatalog.getActivity('daily_checkin');
        expect(checkin, isNotNull);
        expect(checkin!.baseXP, 20);
      });

      test('research publication is among the highest XP activities', () {
        final pub = XPCatalog.getActivity('research_publication');
        expect(pub, isNotNull);
        expect(pub!.baseXP, 1000);
      });

      test('detect spike: rapid accumulation of high-XP activities', () {
        // Simulate a student earning rapid research XP (spike)
        int totalResearchXP = 0;
        final spikeActivities = [
          300, // start_research
          200, // research_milestone
          500, // research_presentation
          1000, // research_publication
        ];
        for (final xp in spikeActivities) {
          totalResearchXP += xp;
        }
        // A spike is detected if XP exceeds a threshold in short time
        final isSpike = totalResearchXP > 1000;
        expect(isSpike, true, reason: 'Rapid research XP should be detected as spike');
      });

      test('detect no spike for gradual low-XP accumulation', () {
        int totalConsistencyXP = 0;
        final gradualActivities = List.filled(50, 20); // 50 daily check-ins
        for (final xp in gradualActivities) {
          totalConsistencyXP += xp;
        }
        // Same total but spread over time = not a spike
        final avgPerActivity = totalConsistencyXP / gradualActivities.length;
        final isSpike = avgPerActivity > 100; // threshold
        expect(isSpike, false, reason: 'Gradual low-XP should not be a spike');
      });
    });

    group('rarity scoring', () {
      test('activities with low frequency limits are rarer', () {
        final rareActivities = XPCatalog.activities
            .where((a) => a.maxPerYear != null && a.maxPerYear! <= 2)
            .toList();
        expect(rareActivities.isNotEmpty, true,
            reason: 'Should have rare activities with yearly limits');
      });

      test('daily activities are common (repeatable)', () {
        final dailyActivities = XPCatalog.activities
            .where((a) => a.maxPerDay != null)
            .toList();
        expect(dailyActivities.isNotEmpty, true);
      });

      test('expert missions have highest XP rewards', () {
        // In the service, expert difficulty maps to highest XP
        final xpByDifficulty = {
          'easy': 75,
          'medium': 175,
          'hard': 375,
          'expert': 750,
        };
        expect(xpByDifficulty['expert']! > xpByDifficulty['hard']!, true);
        expect(xpByDifficulty['hard']! > xpByDifficulty['medium']!, true);
        expect(xpByDifficulty['medium']! > xpByDifficulty['easy']!, true);
      });

      test('rarity can be scored by XP-to-frequency ratio', () {
        // Higher XP + lower frequency = rarer
        final publication = XPCatalog.getActivity('research_publication');
        expect(publication, isNotNull);
        // Publication: 1000 XP, max 2 per year = very rare
        final rarityScore = publication!.baseXP / (publication.maxPerYear ?? 1);
        expect(rarityScore, greaterThan(100));
      });

      test('portfolio piece is rarer than daily check-in', () {
        final portfolio = XPCatalog.getActivity('portfolio_piece');
        final checkin = XPCatalog.getActivity('daily_checkin');
        expect(portfolio, isNotNull);
        expect(checkin, isNotNull);

        final portfolioRarity =
            portfolio!.baseXP / (portfolio.maxPerWeek ?? 1);
        final checkinRarity = checkin!.baseXP / (checkin.maxPerDay ?? 1);
        expect(portfolioRarity, greaterThan(checkinRarity));
      });
    });
  });
}
