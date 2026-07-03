import 'dart:async';
import 'package:flutter/foundation.dart';
import '../../models/gamification/skins.dart';
import '../../models/gamification/streak.dart';
import '../../models/gamification/xp.dart';
import '../../models/gamification/missions.dart';
import '../../models/gamification/admissions_pillar.dart';

/// GamificationService - stub implementation
class GamificationService {
  GamificationService();

  Stream<Skin> get skinUnlockStream => const Stream.empty();
  Stream<int> get levelUpStream => const Stream.empty();
  Stream<Mission> get missionCompleteStream => const Stream.empty();

  int get totalXP => 0;
  int get currentLevel => 1;
  int get xpToNextLevel => 100;
  SkinTier get currentSkinTier => SkinTier.explorer;
  String get equippedSkinId => 'explorer';
  String get equippedFrameId => 'frame_default';
  List<String> get equippedBadges => const [];
  Map<String, int> get pillarXP => const {};
  int get xpToNextSkin => 0;
  Skin? get currentSkin => null;
  List<Skin> get unlockedSkins => const [];
  List<Skin> get lockedSkins => const [];
  Skin? get nextSkinToUnlock => null;
  Streak get currentStreak => Streak.initial();
  int get freezeTokens => 3;
  List<DateTime> get graceDaysUsed => const [];
  List<Mission> get activeMissions => const [];
  List<Mission> get completedMissions => const [];
  List<Mission> get dailyMissions => const [];
  List<Mission> get weeklyMissions => const [];
  List<Mission> get milestoneMissions => const [];
  WeeklyMissionSet? get weeklyMissionsSet => null;

  Future<XPAddResult> addXP({
    required int amount,
    required AdmissionsPillar pillar,
    String? source,
    String? missionId,
  }) async => XPAddResult(
        totalXP: amount,
        pillarXP: amount,
        leveledUp: false,
        newLevel: 1,
        newSkinUnlocked: null,
        xpToNextLevel: 100,
        xpToNextSkin: 0,
      );

  Future<StreakActionResult> markDailyActive({
    GraceDayReason? graceDayReason,
  }) async => StreakActionResult(
        success: true,
        message: 'Stub: marked active',
        streak: Streak.initial(),
        xpGained: 0,
      );

  void addFreezeToken() {}
  void useGraceDay(GraceDayReason reason) {}

  Future<void> updateMissionProgress(String missionId, int xpGained) async {}
  Future<void> claimWeeklyBonus() async {}
  Future<void> claimMissionReward(String missionId) async {}

  Future<void> equipSkin(SkinTier tier) async {}
  Future<void> equipFrame(String frameId) async {}
  Future<void> addEquippedBadge(String badgeId) async {}
  Future<void> removeEquippedBadge(String badgeId) async {}

  void dispose() {}
}

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

@immutable
class StreakActionResult {
  final bool success;
  final String message;
  final Streak streak;
  final int xpGained;

  const StreakActionResult({
    required this.success,
    required this.message,
    required this.streak,
    required this.xpGained,
  });
}
