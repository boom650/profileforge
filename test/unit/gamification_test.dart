import 'package:flutter_test/flutter_test.dart';
import 'package:profileforge/services/gamification/gamification_service.dart';
import 'package:profileforge/models/gamification/skins.dart';
import 'package:profileforge/models/gamification/xp.dart';
import 'package:profileforge/models/gamification/streak.dart';
import 'package:profileforge/models/gamification/missions.dart';
import 'package:profileforge/models/gamification/admissions_pillar.dart';

void main() {
  group('GamificationService', () {
    late GamificationService service;

    setUp(() {
      service = GamificationService();
    });

    test('initial state is correct', () {
      expect(service.totalXP, equals(0));
      expect(service.currentLevel, equals(1));
      expect(service.unlockedSkins.length, equals(1));
      expect(service.currentSkinTier, equals(SkinTier.explorer));
      expect(service.activeMissions, isEmpty);
      expect(service.currentStreak.currentStreak, equals(0));
    });

    test('addXP increases total XP', () async {
      final result = await service.addXP(
        amount: 100,
        pillar: AdmissionsPillar.academics,
        source: 'test',
      );
      expect(service.totalXP, equals(100));
      expect(result.totalXP, equals(100));
      expect(service.pillarXP[AdmissionsPillar.academics.name], equals(100));
    });

    test('mapCategoryToPillar maps correctly', () {
      expect(service.mapCategoryToPillar('academics'), equals(AdmissionsPillar.academics));
      expect(service.mapCategoryToPillar('study'), equals(AdmissionsPillar.academics));
      expect(service.mapCategoryToPillar('activities'), equals(AdmissionsPillar.evidence));
      expect(service.mapCategoryToPillar('consistency'), equals(AdmissionsPillar.consistency));
      expect(service.mapCategoryToPillar('leadership'), equals(AdmissionsPillar.leadership));
      expect(service.mapCategoryToPillar('unknown'), equals(AdmissionsPillar.consistency));
    });

    test('calculateAdmissionsReadiness returns 0 for no XP', () {
      expect(service.calculateAdmissionsReadiness(), equals(0.0));
    });

    test('addXP supports multiple pillars separately', () async {
      await service.addXP(amount: 50, pillar: AdmissionsPillar.academics, source: 'test');
      await service.addXP(amount: 30, pillar: AdmissionsPillar.creativity, source: 'test');
      expect(service.pillarXP[AdmissionsPillar.academics.name], equals(50));
      expect(service.pillarXP[AdmissionsPillar.creativity.name], equals(30));
      expect(service.totalXP, equals(80));
    });

    test('isWeekend returns correct day type', () {
      // Static helper - just verify it returns bool
      expect(service.isWeekend(), isA<bool>());
    });
  });
}
