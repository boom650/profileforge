import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meta/meta.dart';
import '../models/student_profile.dart';
import '../models/gamification/skins.dart';
import '../models/gamification/streak.dart';
import '../models/gamification/xp.dart';
import '../models/gamification/missions.dart';

// Onboarding state
final onboardingCompletedProvider = FutureProvider<bool>((ref) async {
  // Default to not onboarded; actual persistence handled later
  return false;
});

final setOnboardingCompletedProvider = Provider<Future<void> Function(bool)>((ref) {
  return (bool completed) async {
    // Persistence placeholder
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

// ========== GAMIFICATION STATE (in-memory) ==========

// Streak State
final streakStateProvider = StateNotifierProvider<StreakStateNotifier, Streak>((ref) {
  return StreakStateNotifier();
});

class StreakStateNotifier extends StateNotifier<Streak> {
  StreakStateNotifier() : super(Streak.initial());

  void updateStreak(Streak streak) {
    state = streak;
  }
}

// Skin State
final currentSkinProvider = Provider<Skin>((ref) {
  return SkinCatalog.getConfig(SkinTier.explorer).toSkin(unlocked: true);
});

final unlockedSkinsProvider = Provider<List<Skin>>((ref) {
  return [];
});

final lockedSkinsProvider = Provider<List<Skin>>((ref) {
  return SkinTier.values.map((tier) => SkinCatalog.getConfig(tier).toSkin(unlocked: false)).toList();
});

// XP State
final xpStateProvider = StateNotifierProvider<XPStateNotifier, XPState>((ref) {
  return XPStateNotifier();
});

class XPStateNotifier extends StateNotifier<XPState> {
  XPStateNotifier() : super(XPState.initial());

  void addXP(int amount) {
    state = state.copyWith(totalXP: state.totalXP + amount);
  }
}

final totalXPProvider = Provider<int>((ref) {
  return ref.watch(xpStateProvider).totalXP;
});

final currentLevelProvider = Provider<int>((ref) {
  return ref.watch(xpStateProvider).currentLevel;
});

// Missions State
final missionsProvider = Provider<List<Mission>>((ref) {
  return [];
});

final completedMissionsProvider = Provider<List<Mission>>((ref) {
  return [];
});

final dailyMissionsProvider = Provider<List<Mission>>((ref) {
  final missions = ref.watch(missionsProvider);
  return missions.where((m) => m.type == MissionType.daily).toList();
});

final weeklyMissionsProvider = Provider<List<Mission>>((ref) {
  final missions = ref.watch(missionsProvider);
  return missions.where((m) => m.type == MissionType.weekly).toList();
});

final weeklyMissionSetProvider = Provider<WeeklyMissionSet?>((ref) {
  return null;
});

// ========== NOTIFIERS ==========

final streakChangedProvider = StateProvider<int>((ref) => 0);
final levelUpProvider = StateProvider<int>((ref) => 0);
final missionCompletedProvider = StateProvider<String?>((ref) => null);

// ========== GAMIFICATION ACTIONS ==========

final markDailyActiveProvider = Provider<Future<StreakActionResult> Function({GraceDayReason? graceDayReason})>((ref) {
  return ({GraceDayReason? graceDayReason}) async {
    return StreakActionResult.success(
      newStreak: Streak.initial(),
      newMilestones: [],
      xpEarned: 10,
      freezeTokensEarned: 0,
      graceDaysEarned: 0,
      message: "Day marked active!",
    );
  };
});

final equipSkinProvider = Provider<Future<void> Function(SkinTier)>((ref) {
  return (SkinTier tier) async {};
});

final claimMissionRewardProvider = Provider<Future<void> Function(String)>((ref) {
  return (String missionId) async {};
});

final claimWeeklyBonusProvider = Provider<Future<void> Function()>((ref) {
  return () async {};
});

// ========== ADMISSIONS PROBABILITY ==========

@immutable
class AdmissionsProbabilityData {
  final String university;
  final String country;
  final String major;
  final double currentProbability;
  final double targetProbability;
  final List<String> keyLevers;
  final Map<String, double> sensitivity;

  const AdmissionsProbabilityData({
    required this.university,
    required this.country,
    required this.major,
    required this.currentProbability,
    required this.targetProbability,
    required this.keyLevers,
    required this.sensitivity,
  });
}

final admissionsProbabilityProvider = StateNotifierProvider<AdmissionsProbabilityNotifier, Map<String, AdmissionsProbabilityData>>((ref) {
  return AdmissionsProbabilityNotifier();
});

class AdmissionsProbabilityNotifier extends StateNotifier<Map<String, AdmissionsProbabilityData>> {
  AdmissionsProbabilityNotifier() : super({});

  void updateProbability(String universityKey, AdmissionsProbabilityData probability) {
    state = {...state, universityKey: probability};
  }
}

// ========== LEGACY PROVIDERS (for backwards compatibility) ==========

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

    if (diff == 0) return;

    if (diff == 1) {
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
        state = state.copyWith(currentStreak: 1, lastActiveDate: todayDate);
      }
    }
  }
}

final legacyXPProvider = StateNotifierProvider<LegacyXPNotifier, int>((ref) {
  return LegacyXPNotifier();
});

class LegacyXPNotifier extends StateNotifier<int> {
  LegacyXPNotifier() : super(0);
  void addXP(int amount) { state += amount; }
}

final legacyMissionsProvider = StateNotifierProvider<LegacyMissionsNotifier, List<LegacyMission>>((ref) {
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
      id: id, title: title, description: description,
      type: type, xpReward: xpReward,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}

class LegacyMissionsNotifier extends StateNotifier<List<LegacyMission>> {
  LegacyMissionsNotifier() : super([]);
  void addMission(LegacyMission m) { state = [...state, m]; }
  void completeMission(String id) {
    state = state.map((m) => m.id == id ? m.copyWith(isCompleted: true) : m).toList();
  }
}
