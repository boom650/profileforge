/// Gamification providers: XP, streak, skins, missions, and action providers.
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/gamification/skins.dart';
import '../models/gamification/streak.dart';
import '../models/gamification/xp.dart';
import '../models/gamification/missions.dart';
import '../models/gamification/admissions_pillar.dart';
import '../services/gamification/gamification_service.dart';
import 'service_providers.dart';

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
// LEGACY PROVIDERS (for backwards compatibility)
// ═══════════════════════════════════════════════════════════════════════════

final legacyStreakProvider =
    StateNotifierProvider<LegacyStreakNotifier, LegacyStreakState>((ref) {
  return LegacyStreakNotifier();
});

class LegacyStreakState {
  final int currentStreak;
  final int longestStreak;
  final int freezeTokens;
  final DateTime? lastActiveDate;
  final List<DateTime> graceDaysUsed;

  LegacyStreakState({
    this.currentStreak = 0,
    this.longestStreak = 0,
    this.freezeTokens = 3,
    this.lastActiveDate,
    this.graceDaysUsed = const [],
  });

  LegacyStreakState copyWith({
    int? currentStreak,
    int? longestStreak,
    int? freezeTokens,
    DateTime? lastActiveDate,
    List<DateTime>? graceDaysUsed,
  }) {
    return LegacyStreakState(
      currentStreak: currentStreak ?? this.currentStreak,
      longestStreak: longestStreak ?? this.longestStreak,
      freezeTokens: freezeTokens ?? this.freezeTokens,
      lastActiveDate: lastActiveDate ?? this.lastActiveDate,
      graceDaysUsed: graceDaysUsed ?? this.graceDaysUsed,
    );
  }
}

class LegacyStreakNotifier extends StateNotifier<LegacyStreakState> {
  LegacyStreakNotifier() : super(LegacyStreakState());

  void markActive() {
    final today = DateTime.now();
    final todayDate = DateTime(today.year, today.month, today.day);

    if (state.lastActiveDate == null) {
      state = state.copyWith(
        currentStreak: 1,
        longestStreak: 1,
        lastActiveDate: todayDate,
      );
      return;
    }

    final lastDate = state.lastActiveDate!;
    final diff = todayDate.difference(lastDate).inDays;

    if (diff == 0) return;

    if (diff == 1) {
      final newStreak = state.currentStreak + 1;
      state = state.copyWith(
        currentStreak: newStreak,
        longestStreak:
            newStreak > state.longestStreak ? newStreak : state.longestStreak,
        lastActiveDate: todayDate,
      );
    } else if (diff > 1) {
      final missedDays = diff - 1;
      if (state.freezeTokens >= missedDays) {
        state = state.copyWith(
          currentStreak: state.currentStreak + diff,
          longestStreak: (state.currentStreak + diff) > state.longestStreak
              ? state.currentStreak + diff
              : state.longestStreak,
          freezeTokens: state.freezeTokens - missedDays,
          lastActiveDate: todayDate,
        );
      } else {
        state = state.copyWith(currentStreak: 1, lastActiveDate: todayDate);
      }
    }
  }
}

final legacyXPProvider =
    StateNotifierProvider<LegacyXPNotifier, int>((ref) {
  return LegacyXPNotifier();
});

class LegacyXPNotifier extends StateNotifier<int> {
  LegacyXPNotifier() : super(0);
  void addXP(int amount) {
    state += amount;
  }
}

final legacyMissionsProvider =
    StateNotifierProvider<LegacyMissionsNotifier, List<LegacyMission>>((ref) {
  return LegacyMissionsNotifier();
});

class LegacyMission {
  final String id;
  final String title;
  final String description;
  final MissionType type;
  final int xpReward;
  final bool isCompleted;

  const LegacyMission({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    required this.xpReward,
    this.isCompleted = false,
  });

  LegacyMission copyWith({bool? isCompleted}) {
    return LegacyMission(
      id: id,
      title: title,
      description: description,
      type: type,
      xpReward: xpReward,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}

class LegacyMissionsNotifier extends StateNotifier<List<LegacyMission>> {
  LegacyMissionsNotifier() : super([]);
  void addMission(LegacyMission m) {
    state = [...state, m];
  }

  void completeMission(String id) {
    state = state
        .map((m) => m.id == id ? m.copyWith(isCompleted: true) : m)
        .toList();
  }
}