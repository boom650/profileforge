/// Gamification providers: XP, streak, skins, missions, and action providers.
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/gamification/skins.dart';
import '../models/gamification/streak.dart';
import '../models/gamification/xp.dart';
import '../models/gamification/missions.dart';
import '../models/gamification/admissions_pillar.dart';
import '../services/gamification/gamification_service.dart';
import '../services/service_providers.dart';

// ═══════════════════════════════════════════════════════════════════════════
// XP STATE
// ═══════════════════════════════════════════════════════════════════════════

final xpStateProvider =
    StateNotifierProvider<XPStateNotifier, XPState>((ref) {
  final service = ref.read(gamificationServiceProvider);
  return XPStateNotifier(service);
});

class XPStateNotifier extends StateNotifier<XPState> {
  XPStateNotifier(this._service) : super(_service.xpState);

  final GamificationService _service;

  /// Refresh state from the underlying service after a mutation.
  void syncFromService() {
    state = _service.xpState;
  }

  /// Convenience: add XP via the service and sync.
  Future<void> addXP({
    required int amount,
    required AdmissionsPillar pillar,
    String? source,
    String? missionId,
  }) async {
    await _service.addXP(
      amount: amount,
      pillar: pillar,
      source: source,
      missionId: missionId,
    );
    syncFromService();
  }
}

final totalXPProvider = Provider<int>((ref) {
  return ref.watch(xpStateProvider).totalXP;
});

final currentLevelProvider = Provider<int>((ref) {
  return ref.watch(xpStateProvider).currentLevel;
});

// ═══════════════════════════════════════════════════════════════════════════
// STREAK STATE
// ═══════════════════════════════════════════════════════════════════════════

final streakStateProvider =
    StateNotifierProvider<StreakStateNotifier, Streak>((ref) {
  final service = ref.read(gamificationServiceProvider);
  return StreakStateNotifier(service);
});

class StreakStateNotifier extends StateNotifier<Streak> {
  StreakStateNotifier(this._service) : super(_service.currentStreak);

  final GamificationService _service;

  /// Refresh state from the underlying service after a mutation.
  void syncFromService() {
    state = _service.currentStreak;
  }

  void updateStreak(Streak streak) {
    state = streak;
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// SKIN STATE
// ═══════════════════════════════════════════════════════════════════════════

final currentSkinProvider = Provider<Skin>((ref) {
  final service = ref.read(gamificationServiceProvider);
  return service.currentSkin ??
      SkinCatalog.getConfig(SkinTier.explorer).toSkin(unlocked: true);
});

final unlockedSkinsProvider = Provider<List<Skin>>((ref) {
  final service = ref.read(gamificationServiceProvider);
  return service.unlockedSkins;
});

final lockedSkinsProvider = Provider<List<Skin>>((ref) {
  final service = ref.read(gamificationServiceProvider);
  return service.lockedSkins;
});

// ═══════════════════════════════════════════════════════════════════════════
// MISSIONS STATE
// ═══════════════════════════════════════════════════════════════════════════

final missionsProvider = Provider<List<Mission>>((ref) {
  final service = ref.read(gamificationServiceProvider);
  return service.activeMissions;
});

final completedMissionsProvider = Provider<List<Mission>>((ref) {
  final service = ref.read(gamificationServiceProvider);
  return service.completedMissions;
});

final dailyMissionsProvider = Provider<List<Mission>>((ref) {
  final service = ref.read(gamificationServiceProvider);
  return service.dailyMissions;
});

final weeklyMissionsProvider = Provider<List<Mission>>((ref) {
  final service = ref.read(gamificationServiceProvider);
  return service.weeklyMissions;
});

final weeklyMissionSetProvider = Provider<WeeklyMissionSet?>((ref) {
  final service = ref.read(gamificationServiceProvider);
  return service.weeklyMissionsSet;
});

// ═══════════════════════════════════════════════════════════════════════════
// EVENT NOTIFIERS (re-emitted after service mutations)
// ═══════════════════════════════════════════════════════════════════════════

final streakChangedProvider = StateProvider<int>((ref) => 0);
final levelUpProvider = StateProvider<int>((ref) => 0);
final missionCompletedProvider = StateProvider<String?>((ref) => null);

// ═══════════════════════════════════════════════════════════════════════════
// GAMIFICATION ACTIONS — delegate to GamificationService
// ═══════════════════════════════════════════════════════════════════════════

/// Mark today as active. Returns a [StreakActionResult] and syncs providers.
final markDailyActiveProvider = Provider<
    Future<StreakActionResult> Function({GraceDayReason? graceDayReason})>((ref) {
  return ({GraceDayReason? graceDayReason}) async {
    final service = ref.read(gamificationServiceProvider);
    final result =
        await service.markDailyActive(graceDayReason: graceDayReason);

    // Sync all affected state back to the Riverpod providers
    ref.read(streakStateProvider.notifier).syncFromService();
    ref.read(xpStateProvider.notifier).syncFromService();

    // Emit event notifiers so UI can react
    result.when(
      success: (newStreak, _, xpEarned, __, ___, ____) {
        ref.read(streakChangedProvider.notifier).state =
            newStreak.currentStreak;
      },
      graceDayUsed: (_, __, ___) {},
      freezeTokenUsed: (_, __, ___) {},
      streakBroken: (_, __, ___, ____) {},
      alreadyMarked: (_, __) {},
    );

    return result;
  };
});

/// Equip a skin by tier.
final equipSkinProvider = Provider<Future<void> Function(SkinTier)>((ref) {
  return (SkinTier tier) async {
    final service = ref.read(gamificationServiceProvider);
    await service.equipSkin(tier);
  };
});

/// Claim the XP reward for a completed mission.
final claimMissionRewardProvider =
    Provider<Future<void> Function(String)>((ref) {
  return (String missionId) async {
    final service = ref.read(gamificationServiceProvider);
    await service.claimMissionReward(missionId);
    ref.read(xpStateProvider.notifier).syncFromService();
  };
});

/// Update progress on a mission. When progress reaches the target,
/// the mission is marked as completed.
final updateMissionProgressProvider =
    Provider<Future<void> Function(String, int)>((ref) {
  return (String missionId, int increment) async {
    final service = ref.read(gamificationServiceProvider);
    await service.updateMissionProgress(missionId, increment);
  };
});

/// Claim the weekly mission set bonus (if all weekly missions completed).
final claimWeeklyBonusProvider = Provider<Future<void> Function()>((ref) {
  return () async {
    final service = ref.read(gamificationServiceProvider);
    await service.claimWeeklyBonus();
    ref.read(xpStateProvider.notifier).syncFromService();
  };
});

// ═══════════════════════════════════════════════════════════════════════════
// LEGACY PROVIDERS (for backwards compatibility) — REMOVED
// ═══════════════════════════════════════════════════════════════════════════
// Legacy providers have been removed. Use the modern providers:
// - streakStateProvider, xpStateProvider, missionStateProvider
// - markDailyActiveProvider, claimMissionRewardProvider, etc.