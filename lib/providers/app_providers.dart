import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meta/meta.dart';
import '../models/student_profile.dart';
import '../models/gamification/skins.dart';
import '../models/gamification/streak.dart';
import '../models/gamification/xp.dart';
import '../models/gamification/missions.dart';
import '../models/gamification/admissions_pillar.dart';
import '../services/admissions_probability/admissions_engine.dart';
import '../services/spike_framework.dart';
import '../services/gamification/gamification_service.dart';
import '../services/service_providers.dart';

// ═══════════════════════════════════════════════════════════════════════════
// ONBOARDING STATE
// ═══════════════════════════════════════════════════════════════════════════

final onboardingCompletedProvider = FutureProvider<bool>((ref) async {
  // Default to not onboarded; actual persistence handled later
  return false;
});

final setOnboardingCompletedProvider =
    Provider<Future<void> Function(bool)>((ref) {
  return (bool completed) async {
    // Persistence placeholder
  };
});

// ═══════════════════════════════════════════════════════════════════════════
// STUDENT PROFILE STATE
// ═══════════════════════════════════════════════════════════════════════════

final studentProfileProvider =
    StateNotifierProvider<StudentProfileNotifier, StudentProfile?>((ref) {
  return StudentProfileNotifier();
});

class StudentProfileNotifier extends StateNotifier<StudentProfile?> {
  StudentProfileNotifier() : super(null);

  void setProfile(StudentProfile profile) {
    state = profile;
  }

  void updateProfile(StudentProfile Function(StudentProfile) updater) {
    if (state != null) {
      state = updater(state!);
    }
  }

  void clearProfile() {
    state = null;
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// SPIKE FRAMEWORK
// ═══════════════════════════════════════════════════════════════════════════

/// Analyzes the student's activities and returns detected spikes.
final spikesProvider = Provider<List<Spike>>((ref) {
  final profile = ref.watch(studentProfileProvider);
  if (profile == null || profile.activities.isEmpty) return [];
  return analyzeSpikes(profile.activities);
});

/// Returns the top N spikes sorted by impact score.
final topSpikesProvider = Provider.family<List<Spike>, int>((ref, count) {
  final spikes = ref.watch(spikesProvider);
  return spikes.take(count).toList();
});

// ═══════════════════════════════════════════════════════════════════════════
// GAMIFICATION STATE — backed by GamificationService
// ═══════════════════════════════════════════════════════════════════════════

// ─── XP State ─────────────────────────────────────────────────────────────

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

// ─── Streak State ─────────────────────────────────────────────────────────

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

// ─── Skin State ───────────────────────────────────────────────────────────

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

// ─── Missions State ───────────────────────────────────────────────────────

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

/// Claim the weekly mission set bonus (if all weekly missions completed).
final claimWeeklyBonusProvider = Provider<Future<void> Function()>((ref) {
  return () async {
    final service = ref.read(gamificationServiceProvider);
    await service.claimWeeklyBonus();
    ref.read(xpStateProvider.notifier).syncFromService();
  };
});

// ═══════════════════════════════════════════════════════════════════════════
// ADMISSIONS PROBABILITY
// ═══════════════════════════════════════════════════════════════════════════

@immutable
class AdmissionsProbabilityData {
  final String university;
  final String country;
  final String major;
  final double currentProbability;
  final double targetProbability;
  final List<String> keyLevers;
  final Map<String, double> sensitivity;
  final MonteCarloResult? monteCarloResult;
  final AdmissionsFactorBreakdown? factorBreakdown;

  const AdmissionsProbabilityData({
    required this.university,
    required this.country,
    required this.major,
    required this.currentProbability,
    required this.targetProbability,
    required this.keyLevers,
    required this.sensitivity,
    this.monteCarloResult,
    this.factorBreakdown,
  });
}

final admissionsProbabilityProvider = StateNotifierProvider<
    AdmissionsProbabilityNotifier, Map<String, AdmissionsProbabilityData>>((ref) {
  return AdmissionsProbabilityNotifier();
});

class AdmissionsProbabilityNotifier
    extends StateNotifier<Map<String, AdmissionsProbabilityData>> {
  AdmissionsProbabilityNotifier() : super({});

  void updateProbability(
      String universityKey, AdmissionsProbabilityData probability) {
    state = {...state, universityKey: probability};
  }

  void clearAll() {
    state = {};
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// ADMISSIONS ENGINE INTEGRATION
// ═══════════════════════════════════════════════════════════════════════════

/// Provider for the admissions engine
final admissionsEngineProvider = Provider<AdmissionsEngine>((ref) {
  return AdmissionsEngine();
});

/// Provider for calculating factor breakdown from student profile
final factorBreakdownProvider = Provider<AdmissionsFactorBreakdown?>((ref) {
  final profile = ref.watch(studentProfileProvider);
  if (profile == null) return null;

  final engine = ref.watch(admissionsEngineProvider);
  return engine.calculateFactorBreakdown(profile);
});

/// Provider for calculating probability for a specific university
final universityProbabilityProvider =
    FutureProvider.family<MonteCarloResult, UniversityInfo>((ref, university) async {
  final profile = ref.watch(studentProfileProvider);
  if (profile == null) {
    return const MonteCarloResult(
      mean: 0,
      median: 0,
      p25: 0,
      p75: 0,
      p10: 0,
      p90: 0,
      standardDeviation: 0,
      classification: ApplicationClassification.dream,
      safetyPercentage: 0,
      targetPercentage: 0,
      reachPercentage: 0,
      dreamPercentage: 100,
    );
  }

  final engine = ref.watch(admissionsEngineProvider);
  return engine.runMonteCarloSimulation(
    profile: profile,
    university: university,
  );
});

/// Provider for all university probabilities
final allUniversityProbabilitiesProvider =
    Provider<Map<String, ({MonteCarloResult result, UniversityInfo university})>>((ref) {
  final profile = ref.watch(studentProfileProvider);
  if (profile == null) return {};

  final engine = ref.watch(admissionsEngineProvider);
  final Map<String, ({MonteCarloResult result, UniversityInfo university})>
      results = {};

  for (final university in UniversityDatabase.universities) {
    final result = engine.runMonteCarloSimulation(
      profile: profile,
      university: university,
    );
    results[university.name] = (result: result, university: university);
  }

  return results;
});

/// Provider for getting university by name
final universityByNameProvider =
    Provider.family<UniversityInfo?, String>((ref, name) {
  try {
    return UniversityDatabase.universities.firstWhere((u) => u.name == name);
  } catch (_) {
    return null;
  }
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
