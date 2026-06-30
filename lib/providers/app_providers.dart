import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'models/student_profile.dart';
import 'models/gamification/skins.dart';
import 'models/gamification/streak.dart';
import 'models/gamification/xp.dart';
import 'models/gamification/missions.dart';
import 'services/gamification/gamification_service.dart';

// Onboarding state
final onboardingCompletedProvider = FutureProvider<bool>((ref) async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getBool('onboarding_completed') ?? false;
});

final setOnboardingCompletedProvider = Provider<Future<void> Function(bool)>((ref) {
  return (bool completed) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboarding_completed', completed);
    ref.invalidate(onboardingCompletedProvider);
  };
});

// Student Profile State
final studentProfileProvider = StateNotifierProvider<StudentProfileNotifier, StudentProfile?>((ref) {
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

// ========== GAMIFICATION PROVIDERS ==========

// Main Gamification Service
final gamificationServiceProvider = gamificationServiceProvider;

// Skin State
final currentSkinProvider = Provider<Skin>((ref) {
  final service = ref.watch(gamificationServiceProvider).value;
  return service?.getCurrentSkin() ?? SkinCatalog.getConfig(SkinTier.explorer()).toSkin(unlocked: true);
});

final unlockedSkinsProvider = Provider<List<Skin>>((ref) {
  final service = ref.watch(gamificationServiceProvider).value;
  return service?.getUnlockedSkins() ?? [];
});

final lockedSkinsProvider = Provider<List<Skin>>((ref) {
  final service = ref.watch(gamificationServiceProvider).value;
  return service?.getLockedSkins() ?? [];
});

final nextSkinToUnlockProvider = Provider<Skin?>((ref) {
  final service = ref.watch(gamificationServiceProvider).value;
  return service?.getNextSkinToUnlock();
});

// Streak State
final streakProvider = Provider<Streak>((ref) {
  final service = ref.watch(gamificationServiceProvider).value;
  return service?.getCurrentStreak() ?? Streak.initial();
});

final streakActionProvider = Provider.future((ref) async {
  final service = ref.watch(gamificationServiceProvider).value;
  return service?.markDailyActive();
});

// XP State
final xpStateProvider = Provider<XPState>((ref) {
  final service = ref.watch(gamificationServiceProvider).value;
  return service?.getXPState() ?? XPState.initial();
});

final totalXPProvider = Provider<int>((ref) {
  return ref.watch(xpStateProvider).totalXP;
});

final pillarXPProvider = Provider<Map<AdmissionsPillar, int>>((ref) {
  return ref.watch(xpStateProvider).pillarXP;
});

final currentLevelProvider = Provider<int>((ref) {
  return ref.watch(xpStateProvider).currentLevel;
});

final xpToNextLevelProvider = Provider<int>((ref) {
  return ref.watch(xpStateProvider).xpToNextLevel;
});

// Missions State
final missionsProvider = Provider<List<Mission>>((ref) {
  final service = ref.watch(gamificationServiceProvider).value;
  return service?.getActiveMissions() ?? [];
});

final completedMissionsProvider = Provider<List<Mission>>((ref) {
  final service = ref.watch(gamificationServiceProvider).value;
  return service?.getCompletedMissions() ?? [];
});

final dailyMissionsProvider = Provider<List<Mission>>((ref) {
  final missions = ref.watch(missionsProvider);
  return missions.where((m) => m.type == MissionType.daily).toList();
});

final weeklyMissionsProvider = Provider<List<Mission>>((ref) {
  final missions = ref.watch(missionsProvider);
  return missions.where((m) => m.type == MissionType.weekly).toList();
});

final milestoneMissionsProvider = Provider<List<Mission>>((ref) {
  final missions = ref.watch(missionsProvider);
  return missions.where((m) => m.type == MissionType.milestone).toList();
});

final weeklyMissionSetProvider = Provider<WeeklyMissionSet?>((ref) {
  final service = ref.watch(gamificationServiceProvider).value;
  return service?.getWeeklyMissions();
});

// Notifiers for UI events
final skinUnlockNotifierProvider = skinUnlockNotifierProvider;
final levelUpNotifierProvider = levelUpNotifierProvider;
final missionCompleteNotifierProvider = missionCompleteNotifierProvider;

// Gamification Actions
final markDailyActiveProvider = Provider<Future<StreakActionResult> Function({GraceDayReason? graceDayReason})>((ref) {
  return ({GraceDayReason? graceDayReason}) async {
    final service = ref.read(gamificationServiceProvider).value!;
    return service.markDailyActive(graceDayReason: graceDayReason);
  };
});

final equipSkinProvider = Provider<Future<void> Function(SkinTier)>((ref) {
  return (SkinTier tier) async {
    final service = ref.read(gamificationServiceProvider).value!;
    await service.equipSkin(tier);
  };
});

final claimMissionRewardProvider = Provider<Future<void> Function(String)>((ref) {
  return (String missionId) async {
    // Implementation in service
  };
});

final claimWeeklyBonusProvider = Provider<Future<void> Function()>((ref) {
  return () async {
    final service = ref.read(gamificationServiceProvider).value!;
    await service.claimWeeklyBonus();
  };
});

// Admissions Probability State
final admissionsProbabilityProvider = StateNotifierProvider<AdmissionsProbabilityNotifier, Map<String, AdmissionsProbability>>((ref) {
  return AdmissionsProbabilityNotifier();
});

@immutable
class AdmissionsProbability {
  final String university;
  final String country;
  final String major;
  final double currentProbability;
  final double targetProbability;
  final List<String> keyLevers;
  final Map<String, double> sensitivity;

  const AdmissionsProbability({
    required this.university,
    required this.country,
    required this.major,
    required this.currentProbability,
    required this.targetProbability,
    required this.keyLevers,
    required this.sensitivity,
  });
}

class AdmissionsProbabilityNotifier extends StateNotifier<Map<String, AdmissionsProbability>> {
  AdmissionsProbabilityNotifier() : super({});

  void updateProbability(String universityKey, AdmissionsProbability probability) {
    state = {...state, universityKey: probability};
  }

  void setAll(Map<String, AdmissionsProbability> probabilities) {
    state = probabilities;
  }
}

// Legacy providers for backwards compatibility
final legacyStreakProvider = StateNotifierProvider<LegacyStreakNotifier, LegacyStreakState>((ref) {
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

    if (diff == 0) {
      return;
    } else if (diff == 1) {
      final newStreak = state.currentStreak + 1;
      state = state.copyWith(
        currentStreak: newStreak,
        longestStreak: newStreak > state.longestStreak ? newStreak : state.longestStreak,
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
        state = state.copyWith(
          currentStreak: 1,
          lastActiveDate: todayDate,
        );
      }
    }
  }

  void addFreezeToken() {
    state = state.copyWith(freezeTokens: state.freezeTokens + 1);
  }

  void useGraceDay(DateTime date) {
    final dateOnly = DateTime(date.year, date.month, date.day);
    if (!state.graceDaysUsed.contains(dateOnly)) {
      state = state.copyWith(
        graceDaysUsed: [...state.graceDaysUsed, dateOnly],
      );
    }
  }

  void loadFromStorage(LegacyStreakState stored) {
    state = stored;
  }
}

final legacyXPProvider = StateNotifierProvider<LegacyXPNotifier, int>((ref) {
  return LegacyXPNotifier();
});

class LegacyXPNotifier extends StateNotifier<int> {
  LegacyXPNotifier() : super(0);

  void addXP(int amount) {
    state += amount;
  }

  void setXP(int xp) {
    state = xp;
  }
}

@immutable
class LegacyMission {
  final String id;
  final String title;
  final String description;
  final MissionType type;
  final int xpReward;
  final bool isCompleted;
  final DateTime? completedAt;
  final Map<String, dynamic>? metadata;

  const LegacyMission({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    required this.xpReward,
    this.isCompleted = false,
    this.completedAt,
    this.metadata,
  });

  LegacyMission copyWith({
    String? id,
    String? title,
    String? description,
    MissionType? type,
    int? xpReward,
    bool? isCompleted,
    DateTime? completedAt,
    Map<String, dynamic>? metadata,
  }) {
    return LegacyMission(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      type: type ?? this.type,
      xpReward: xpReward ?? this.xpReward,
      isCompleted: isCompleted ?? this.isCompleted,
      completedAt: completedAt ?? this.completedAt,
      metadata: metadata ?? this.metadata,
    );
  }
}

final legacyMissionsProvider = StateNotifierProvider<LegacyMissionsNotifier, List<LegacyMission>>((ref) {
  return LegacyMissionsNotifier();
});

class LegacyMissionsNotifier extends StateNotifier<List<LegacyMission>> {
  LegacyMissionsNotifier() : super([]);

  void addMission(LegacyMission mission) {
    state = [...state, mission];
  }

  void completeMission(String missionId) {
    state = state.map((m) {
      if (m.id == missionId) {
        return m.copyWith(isCompleted: true, completedAt: DateTime.now());
      }
      return m;
    }).toList();
  }

  void setMissions(List<LegacyMission> missions) {
    state = missions;
  }

  void clearCompleted() {
    state = state.where((m) => !m.isCompleted).toList();
  }

  List<LegacyMission> get activeMissions => state.where((m) => !m.isCompleted).toList();
  List<LegacyMission> get completedMissions => state.where((m) => m.isCompleted).toList();
  List<LegacyMission> get dailyMissions => state.where((m) => m.type == MissionType.daily && !m.isCompleted).toList();
  List<LegacyMission> get weeklyMissions => state.where((m) => m.type == MissionType.weekly && !m.isCompleted).toList();
}