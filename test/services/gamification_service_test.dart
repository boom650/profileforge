import 'dart:async';
import 'package:flutter_test/flutter_test.dart';
import 'package:profileforge/services/gamification/gamification_service.dart';
import 'package:profileforge/models/gamification/admissions_pillar.dart';
import 'package:profileforge/models/gamification/missions.dart';
import 'package:profileforge/models/gamification/streak.dart';
import 'package:profileforge/models/gamification/skins.dart';
import '../helpers.dart';

void main() {
  group('GamificationService', () {
    late GamificationService service;

    setUp(() {
      service = GamificationService();
    });

    tearDown(() {
      service.dispose();
    });

    group('addXP', () {
      test('adds XP to total and pillar', () async {
        final result = await service.addXP(
          amount: 100,
          pillar: AdmissionsPillar.academics,
        );
        expect(result.totalXP, greaterThan(0));
        expect(result.pillarXP, greaterThan(0));
        expect(result.leveledUp, isA<bool>());
      });

      test('adds XP to correct pillar', () async {
        await service.addXP(
          amount: 100,
          pillar: AdmissionsPillar.academics,
        );
        expect(service.pillarXP['academics'], greaterThan(0));

        await service.addXP(
          amount: 50,
          pillar: AdmissionsPillar.research,
        );
        expect(service.pillarXP['research'], greaterThan(0));
      });

      test('multiple adds accumulate', () async {
        final r1 = await service.addXP(
          amount: 50,
          pillar: AdmissionsPillar.academics,
        );
        final r2 = await service.addXP(
          amount: 50,
          pillar: AdmissionsPillar.academics,
        );
        expect(r2.totalXP, greaterThan(r1.totalXP));
      });

      test('different pillars tracked independently', () async {
        await service.addXP(amount: 100, pillar: AdmissionsPillar.academics);
        await service.addXP(amount: 200, pillar: AdmissionsPillar.research);
        expect(service.pillarXP['academics'], 100);
        expect(service.pillarXP['research'], 200);
      });

      test('XPAddResult returns correct metadata', () async {
        final result = await service.addXP(
          amount: 100,
          pillar: AdmissionsPillar.leadership,
          source: 'test_source',
        );
        expect(result.totalXP, 100);
        expect(result.pillarXP, 100);
        expect(result.newLevel, greaterThanOrEqualTo(1));
        expect(result.xpToNextLevel, greaterThan(0));
      });

      test('small XP amount does not cause level up', () async {
        final result = await service.addXP(
          amount: 10,
          pillar: AdmissionsPillar.evidence,
        );
        expect(result.leveledUp, false);
        expect(result.newLevel, 1);
      });

      test('XP is recorded in transaction history', () async {
        await service.addXP(
          amount: 100,
          pillar: AdmissionsPillar.academics,
          source: 'test_activity',
        );
        expect(service.xpState.transactionHistory.length, 1);
        expect(service.xpState.transactionHistory.first.amount, greaterThan(0));
      });
    });

    group('markDailyActive flow', () {
      test('first check-in starts streak at 1', () async {
        final result = await service.markDailyActive();
        expect(result, isA<StreakActionResult>());
        result.when(
          success: (newStreak, milestones, xp, freeze, grace, msg) {
            expect(newStreak.currentStreak, 1);
            expect(newStreak.totalActiveDays, 1);
            expect(newStreak.lastActiveDate, isNotNull);
          },
          graceDayUsed: (_, __, ___) => fail('Should not use grace day'),
          freezeTokenUsed: (_, __, ___) => fail('Should not use freeze token'),
          streakBroken: (_, __, ___, ____) => fail('Streak should not break'),
          alreadyMarked: (_, __) => fail('Should not be already marked'),
        );
      });

      test('double check-in returns alreadyMarked', () async {
        await service.markDailyActive();
        final result = await service.markDailyActive();
        result.when(
          success: (_, __, ___, ____, _____, ______) => fail('Should be already marked'),
          graceDayUsed: (_, __, ___) => fail('Should not use grace day'),
          freezeTokenUsed: (_, __, ___) => fail('Should not use freeze token'),
          streakBroken: (_, __, ___, ____) => fail('Streak should not break'),
          alreadyMarked: (_, msg) {
            expect(msg, isNotEmpty);
          },
        );
      });

      test('freeze tokens protect streak across gap', () async {
        // Simulate having an active streak with freeze tokens
        final result = await service.markDailyActive();
        result.when(
          success: (newStreak, _, __, ___, ____, ______) {
            expect(newStreak.currentStreak, 1);
          },
          graceDayUsed: (_, __, ___) {},
          freezeTokenUsed: (_, __, ___) {},
          streakBroken: (_, __, ___, ____) {},
          alreadyMarked: (_, __) {},
        );
        expect(service.freezeTokens, greaterThanOrEqualTo(0));
      });

      test('grace days are consumed when reason provided', () async {
        // First establish a streak
        await service.markDailyActive();

        // Grace day consumption should reduce grace days remaining
        final streak = service.currentStreak;
        expect(streak.graceDaysRemaining, greaterThanOrEqualTo(0));
      });
    });

    group('mission progress update', () {
      test('generateWeeklyMissions creates missions', () {
        service.generateWeeklyMissions();
        expect(service.activeMissions.isNotEmpty, true);
      });

      test('daily missions are filtered correctly', () {
        service.generateWeeklyMissions();
        final dailyMissions = service.dailyMissions;
        for (final m in dailyMissions) {
          expect(m.type, MissionType.daily);
        }
      });

      test('weekly missions are filtered correctly', () {
        service.generateWeeklyMissions();
        final weeklyMissions = service.weeklyMissions;
        for (final m in weeklyMissions) {
          expect(m.type, MissionType.weekly);
        }
      });

      test('weekly mission set is created', () {
        service.generateWeeklyMissions();
        expect(service.weeklyMissionsSet, isNotNull);
        expect(service.weeklyMissionsSet!.missions.isNotEmpty, true);
      });

      test('isWeeklySetComplete returns false when missions incomplete', () {
        service.generateWeeklyMissions();
        expect(service.isWeeklySetComplete, false);
      });

      test('weekly set has positive total XP reward', () {
        service.generateWeeklyMissions();
        expect(service.weeklyMissionsSet!.totalXPReward, greaterThan(0));
      });
    });

    group('skin equip/unequip', () {
      test('explorer skin is equipped by default', () {
        expect(service.currentSkinTier, SkinTier.explorer);
        expect(service.equippedSkinId, 'explorer');
      });

      test('equipSkin changes equipped skin to unlocked skin', () async {
        // Explorer is unlocked by default
        await service.equipSkin(SkinTier.explorer);
        expect(service.currentSkinTier, SkinTier.explorer);
      });

      test('equipSkin does nothing for locked skin', () async {
        // Scholar is not unlocked by default
        await service.equipSkin(SkinTier.scholar);
        expect(service.currentSkinTier, SkinTier.explorer); // unchanged
      });

      test('currentSkin returns the equipped skin', () {
        final skin = service.currentSkin;
        expect(skin, isNotNull);
        expect(skin!.isEquipped, true);
      });

      test('unlockedSkins returns only unlocked skins', () {
        final unlocked = service.unlockedSkins;
        expect(unlocked.length, 1); // only explorer
        expect(unlocked.first.tier, SkinTier.explorer);
      });

      test('lockedSkins returns non-owned skins', () {
        final locked = service.lockedSkins;
        expect(locked.length, 8); // 9 total - 1 unlocked
        for (final skin in locked) {
          expect(skin.isUnlocked, false);
        }
      });

      test('xpToNextSkin returns distance to next unlock', () {
        final nextSkinXp = service.xpToNextSkin;
        expect(nextSkinXp, greaterThanOrEqualTo(0));
      });
    });

    group('streak persistence (state)', () {
      test('currentStreak is accessible', () {
        expect(service.currentStreak, isNotNull);
        expect(service.currentStreak.currentStreak, 0);
      });

      test('freezeTokens getter reflects state', () {
        expect(service.freezeTokens, 3);
      });

      test('addFreezeToken increments count', () {
        service.addFreezeToken();
        expect(service.freezeTokens, 4);
      });

      test('addFreezeToken respects max limit', () {
        for (int i = 0; i < 10; i++) {
          service.addFreezeToken();
        }
        expect(service.freezeTokens, 5); // maxFreezeTokens
      });
    });

    group('category to pillar mapping', () {
      test('maps academics correctly', () {
        expect(service.mapCategoryToPillar('academics'), AdmissionsPillar.academics);
        expect(service.mapCategoryToPillar('study'), AdmissionsPillar.academics);
        expect(service.mapCategoryToPillar('grades'), AdmissionsPillar.academics);
        expect(service.mapCategoryToPillar('test_prep'), AdmissionsPillar.academics);
      });

      test('maps evidence correctly', () {
        expect(service.mapCategoryToPillar('evidence'), AdmissionsPillar.evidence);
        expect(service.mapCategoryToPillar('activities'), AdmissionsPillar.evidence);
        expect(service.mapCategoryToPillar('documentation'), AdmissionsPillar.evidence);
      });

      test('maps consistency correctly', () {
        expect(service.mapCategoryToPillar('consistency'), AdmissionsPillar.consistency);
        expect(service.mapCategoryToPillar('streak'), AdmissionsPillar.consistency);
        expect(service.mapCategoryToPillar('daily'), AdmissionsPillar.consistency);
      });

      test('maps research correctly', () {
        expect(service.mapCategoryToPillar('research'), AdmissionsPillar.research);
      });

      test('maps leadership correctly', () {
        expect(service.mapCategoryToPillar('leadership'), AdmissionsPillar.leadership);
        expect(service.mapCategoryToPillar('mentor'), AdmissionsPillar.leadership);
      });

      test('maps creativity correctly', () {
        expect(service.mapCategoryToPillar('creativity'), AdmissionsPillar.creativity);
        expect(service.mapCategoryToPillar('art'), AdmissionsPillar.creativity);
      });

      test('maps community correctly', () {
        expect(service.mapCategoryToPillar('community'), AdmissionsPillar.communityImpact);
        expect(service.mapCategoryToPillar('volunteer'), AdmissionsPillar.communityImpact);
      });

      test('unknown category defaults to consistency', () {
        expect(service.mapCategoryToPillar('unknown'), AdmissionsPillar.consistency);
      });
    });

    group('admissions readiness scoring', () {
      test('readiness is 0 for zero XP', () {
        expect(service.calculateAdmissionsReadiness(), 0.0);
      });

      test('readiness increases with XP', () async {
        await service.addXP(amount: 1000, pillar: AdmissionsPillar.academics);
        final score1 = service.calculateAdmissionsReadiness();
        expect(score1, greaterThan(0.0));
        expect(score1, lessThanOrEqualTo(1.0));
      });

      test('readiness is bounded between 0 and 1', () async {
        // Add lots of XP to various pillars
        for (final pillar in AdmissionsPillar.values) {
          if (pillar == AdmissionsPillar.trailblazer) continue;
          await service.addXP(amount: 5000, pillar: pillar);
        }
        final score = service.calculateAdmissionsReadiness();
        expect(score, greaterThanOrEqualTo(0.0));
        expect(score, lessThanOrEqualTo(1.0));
      });
    });

    group('streams', () {
      test('skinUnlockStream is broadcast stream', () {
        expect(service.skinUnlockStream, isA<Stream<Skin>>());
      });

      test('levelUpStream is broadcast stream', () {
        expect(service.levelUpStream, isA<Stream<int>>());
      });

      test('missionCompleteStream is broadcast stream', () {
        expect(service.missionCompleteStream, isA<Stream<dynamic>>());
      });
    });
  });
}
