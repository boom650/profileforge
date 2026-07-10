import 'dart:async';
import 'package:flutter/foundation.dart';
import '../../models/gamification/skins.dart';
import '../../models/gamification/streak.dart';
import '../../models/gamification/xp.dart';
import '../../models/gamification/missions.dart';
import '../../models/gamification/admissions_pillar.dart';

part '_xp_service.dart';
part '_streak_service.dart';
part '_skin_service.dart';
part '_mission_service.dart';
part '_persistence_service.dart';

/// XP add result — returned whenever XP is awarded.
@immutable
class XPAddResult {
  final int totalXP;
  final int pillarXP;
  final bool leveledUp;
  final int newLevel;
  final SkinTier? newSkinUnlocked;
  final int xpToNextLevel;
  final int xpToNextSkin;

  const XPAddResult({
    required this.totalXP,
    required this.pillarXP,
    required this.leveledUp,
    required this.newLevel,
    this.newSkinUnlocked,
    required this.xpToNextLevel,
    required this.xpToNextSkin,
  });
}

class GamificationService
    with
        XPService,
        StreakService,
        SkinService,
        MissionService,
        PersistenceService {
  GamificationService() {
    loadFromPrefs();
  }

  // ─── Internal state ───────────────────────────────────────────────────
  XPState xpState = XPState.initial();
  Streak streak = Streak.initial();
  final List<Mission> missions = [];
  WeeklyMissionSet? weeklyMissionSet;
  StreakConfig streakConfig = StreakConfig.defaultConfig();

  // Skin collection (starts with explorer unlocked)
  final Map<SkinTier, Skin> ownedSkins = {
    SkinTier.explorer:
        SkinCatalog.getConfig(SkinTier.explorer).toSkin(unlocked: true),
  };
  SkinTier equippedSkinTier = SkinTier.explorer;
  String equippedFrameId = 'frame_default';
  final List<String> equippedBadges = [];

  // Activity rate-limiting counters (reset daily / weekly)
  final Map<String, int> dailyActivityCounts = {};
  final Map<String, int> weeklyActivityCounts = {};
  DateTime lastDayReset = _today();
  DateTime lastWeekReset = _startOfWeek(DateTime.now());

  // ─── Stream controllers ───────────────────────────────────────────────
  final skinUnlockController = StreamController<Skin>.broadcast();
  final levelUpController = StreamController<int>.broadcast();
  final missionCompleteController = StreamController<Mission>.broadcast();

  // ─── Public streams ───────────────────────────────────────────────────
  Stream<Skin> get skinUnlockStream => skinUnlockController.stream;
  Stream<int> get levelUpStream => levelUpController.stream;
  Stream<Mission> get missionCompleteStream =>
      missionCompleteController.stream;

  // ─── Getters ──────────────────────────────────────────────────────────

  int get totalXP => xpState.totalXP;
  int get currentLevel => xpState.currentLevel;
  int get xpToNextLevel => XPUtils.xpToNextLevel(xpState.totalXP);
  SkinTier get currentSkinTier => equippedSkinTier;
  String get equippedSkinId => equippedSkinTier.name;
  List<String> get equippedBadgesList => List.unmodifiable(equippedBadges);

  Map<String, int> get pillarXP =>
      xpState.pillarXP.map((k, v) => MapEntry(k.name, v));

  Skin? get currentSkin => ownedSkins[equippedSkinTier];

  List<Skin> get unlockedSkins =>
      ownedSkins.values.toList()..sort((a, b) => a.tierOrder.compareTo(b.tierOrder));

  List<Skin> get lockedSkins {
    final locked = <Skin>[];
    for (final tier in SkinTier.values) {
      if (!ownedSkins.containsKey(tier)) {
        locked.add(SkinCatalog.getConfig(tier).toSkin(unlocked: false));
      }
    }
    return locked..sort((a, b) => a.tierOrder.compareTo(b.tierOrder));
  }

  Streak get currentStreak => streak;
  int get freezeTokens => streak.freezeTokens;
  List<DateTime> get graceDaysUsed =>
      streak.graceDayHistory.map((g) => g.dateUsed).toList();

  List<Mission> get activeMissions =>
      missions.where((m) => !m.isCompleted).toList();
  List<Mission> get completedMissions =>
      missions.where((m) => m.isCompleted).toList();
  List<Mission> get dailyMissions =>
      missions.where((m) => m.type == MissionType.daily).toList();
  List<Mission> get weeklyMissions =>
      missions.where((m) => m.type == MissionType.weekly).toList();
  List<Mission> get milestoneMissions =>
      missions.where((m) => m.type == MissionType.milestone).toList();
  WeeklyMissionSet? get weeklyMissionsSet => weeklyMissionSet;

  /// Get the player's pillar XP breakdown.
  Map<AdmissionsPillar, int> get pillarXPMap =>
      Map.unmodifiable(xpState.pillarXP);

  bool get isWeeklySetComplete {
    if (weeklyMissionSet == null) return false;
    return weeklyMissionSet!.missions.every((m) => m.isCompleted);
  }

  // ─── Admissions Pillar Scoring ────────────────────────────────────────

  /// Map an activity category string to an admissions pillar.
  AdmissionsPillar mapCategoryToPillar(String category) {
    switch (category.toLowerCase()) {
      case 'academics':
      case 'study':
      case 'grades':
      case 'test_prep':
        return AdmissionsPillar.academics;
      case 'evidence':
      case 'activities':
      case 'documentation':
        return AdmissionsPillar.evidence;
      case 'consistency':
      case 'streak':
      case 'checkin':
      case 'daily':
        return AdmissionsPillar.consistency;
      case 'research':
      case 'academic_research':
        return AdmissionsPillar.research;
      case 'leadership':
      case 'mentor':
      case 'team':
        return AdmissionsPillar.leadership;
      case 'creativity':
      case 'art':
      case 'writing':
      case 'portfolio':
        return AdmissionsPillar.creativity;
      case 'community':
      case 'impact':
      case 'volunteer':
      case 'service':
        return AdmissionsPillar.communityImpact;
      default:
        return AdmissionsPillar.consistency;
    }
  }

  /// Calculate an overall admissions readiness score (0.0 – 1.0).
  ///
  /// This is a heuristic that weighs how well the student's XP is
  /// distributed across all 7 pillars. Balanced profiles score higher.
  double calculateAdmissionsReadiness() {
    final xp = xpState.pillarXP;
    final total = xpState.totalXP;
    if (total == 0) return 0.0;

    // Weight each pillar based on importance (from the SkinCatalog tiers)
    const weights = {
      AdmissionsPillar.academics: 0.20,
      AdmissionsPillar.evidence: 0.15,
      AdmissionsPillar.consistency: 0.15,
      AdmissionsPillar.research: 0.15,
      AdmissionsPillar.leadership: 0.15,
      AdmissionsPillar.creativity: 0.10,
      AdmissionsPillar.communityImpact: 0.10,
    };

    double score = 0.0;
    for (final entry in weights.entries) {
      final pillarXP = xp[entry.key] ?? 0;
      // Normalise against a target of 3000 per pillar (expert level)
      final normalised = (pillarXP / 3000.0).clamp(0.0, 1.0);
      score += normalised * entry.value;
    }

    // Bonus for balance (low variance across pillars)
    final values = xp.values.toList();
    if (values.isNotEmpty) {
      final mean = values.fold<int>(0, (a, b) => a + b) / values.length;
      final variance =
          values.fold<double>(0, (a, b) => a + (b - mean) * (b - mean)) /
              values.length;
      final stddev = variance > 0 ? _sqrt(variance) : 0;
      final cv = mean > 0 ? stddev / mean : 1.0; // coefficient of variation
      final balanceBonus = (1.0 - cv).clamp(0.0, 0.2); // up to 20 %
      score += balanceBonus;
    }

    return score.clamp(0.0, 1.0);
  }

  // ─── Dispose ──────────────────────────────────────────────────────────

  void dispose() {
    skinUnlockController.close();
    levelUpController.close();
    missionCompleteController.close();
  }

  // ── Simple integer sqrt (avoid dart:math dependency) ──────────────────
  static double _sqrt(double x) {
    if (x <= 0) return 0;
    double guess = x / 2;
    for (int i = 0; i < 20; i++) {
      guess = (guess + x / guess) / 2;
    }
    return guess;
  }

  // ── Date helpers ──────────────────────────────────────────────────────

  static DateTime _today() {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day);
  }

  bool _isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  static DateTime _startOfWeek(DateTime date) {
    // Monday = 1
    final weekday = date.weekday;
    return DateTime(date.year, date.month, date.day)
        .subtract(Duration(days: weekday - 1));
  }
}
