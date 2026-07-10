import '../../models/gamification/missions.dart';
import '../../models/gamification/admissions_pillar.dart';

mixin MissionService on GamificationService {
  /// Update progress on a mission. When the mission's progress reaches its
  /// target, the mission is marked as completed.
  Future<void> updateMissionProgress(String missionId, int increment) async {
    final idx = missions.indexWhere((m) => m.id == missionId);
    if (idx == -1) return;

    final mission = missions[idx];
    if (mission.isCompleted) return;

    // Check expiry
    if (mission.expiresAt != null && DateTime.now().isAfter(mission.expiresAt!)) {
      return;
    }

    final newProgress = mission.progressCurrent + increment;
    final clampedProgress =
        newProgress > mission.progressTarget ? mission.progressTarget : newProgress;

    final updated = mission.copyWith(
      progressCurrent: clampedProgress,
      isCompleted: clampedProgress >= mission.progressTarget,
      completedAt: clampedProgress >= mission.progressTarget
          ? DateTime.now()
          : null,
    );
    missions[idx] = updated;

    if (updated.isCompleted) {
      missionCompleteController.add(updated);
    }

    saveToPrefs();
  }

  /// Claim the XP reward for a completed mission.
  Future<void> claimMissionReward(String missionId) async {
    final idx = missions.indexWhere((m) => m.id == missionId);
    if (idx == -1) return;

    final mission = missions[idx];
    if (!mission.isCompleted || mission.isClaimed) return;

    missions[idx] = mission.copyWith(
      isClaimed: true,
      claimedAt: DateTime.now(),
    );

    await addXP(
      amount: mission.xpReward,
      pillar: mission.pillar,
      source: '${mission.type.name}_mission',
      missionId: mission.id,
    );

    saveToPrefs();
  }

  /// Claim the weekly mission set bonus (if all weekly missions completed).
  Future<void> claimWeeklyBonus() async {
    if (weeklyMissionSet == null) return;
    if (weeklyMissionSet!.isBonusClaimed) return;

    final allCompleted = weeklyMissionSet!.missions.every(
      (m) => m.isCompleted,
    );
    if (!allCompleted) return;

    weeklyMissionSet = weeklyMissionSet!.copyWith(
      isBonusClaimed: true,
      bonusClaimedAt: DateTime.now(),
    );

    await addXP(
      amount: weeklyMissionSet!.totalXPReward,
      pillar: AdmissionsPillar.consistency,
      source: 'weekly_bonus',
    );

    saveToPrefs();
  }

  // ─── Weekly Mission Generation ────────────────────────────────────────

  /// Generate a fresh set of missions for the current week.
  void generateWeeklyMissions() {
    weeklyMissionSet = null; // reset
    final config = MissionGenerationConfig.defaultConfig();
    final now = DateTime.now();
    final weekStart = _startOfWeek(now);
    final weekEnd = weekStart.add(const Duration(days: 7));

    final List<Mission> weekMissions = [];
    int totalXP = 0;

    // Generate daily missions (pick 3 from templates)
    final dailyTemplates = MissionTemplates.getTemplatesForType(MissionType.daily);
    final pickedDaily = pickRandom(dailyTemplates, config.dailyMissionsCount);
    for (final t in pickedDaily) {
      final m = missionFromTemplate(t, now);
      weekMissions.add(m);
      totalXP += t.xpReward;
    }

    // Generate weekly missions (pick 5)
    final weeklyTemplates = MissionTemplates.getTemplatesForType(MissionType.weekly);
    final pickedWeekly = pickRandom(weeklyTemplates, config.weeklyMissionsCount);
    for (final t in pickedWeekly) {
      final m = missionFromTemplate(t, now);
      weekMissions.add(m);
      totalXP += t.xpReward;
    }

    // Generate 1 milestone mission
    final milestoneTemplates = MissionTemplates.getTemplatesForType(MissionType.milestone);
    if (milestoneTemplates.isNotEmpty) {
      final picked = pickRandom(milestoneTemplates, 1);
      final m = missionFromTemplate(picked.first, now);
      weekMissions.add(m);
      totalXP += picked.first.xpReward;
    }

    missions
      ..removeWhere((m) => m.type == MissionType.milestone && !m.isCompleted)
      ..addAll(weekMissions);

    weeklyMissionSet = WeeklyMissionSet(
      id: 'wm_${weekStart.millisecondsSinceEpoch}',
      weekStart: weekStart,
      weekEnd: weekEnd,
      missions: weekMissions,
      totalXPReward: (totalXP * 0.5).round(), // bonus XP for completing all
      isBonusClaimed: false,
      bonusClaimedAt: null,
      categoryCompletion: {},
    );

    saveToPrefs();
  }

  // ── Mission helpers ───────────────────────────────────────────────────

  Mission missionFromTemplate(MissionTemplate t, DateTime now) {
    DateTime? expires;
    switch (t.type) {
      case MissionType.daily:
        expires = now.add(const Duration(days: 1));
        break;
      case MissionType.weekly:
      case MissionType.special:
        expires = now.add(const Duration(days: 7));
        break;
      default:
        break;
    }

    return Mission(
      id: '${t.id}_${now.millisecondsSinceEpoch}',
      title: t.title,
      description: t.description,
      type: t.type,
      category: t.category,
      difficulty: t.difficulty,
      xpReward: xpForDifficulty(t.difficulty),
      pillar: t.pillar,
      completionCriteria: t.completionCriteria,
      prerequisites: t.prerequisites,
      isCompleted: false,
      isClaimed: false,
      completedAt: null,
      claimedAt: null,
      createdAt: now,
      expiresAt: expires,
      metadata: null,
      progressCurrent: 0,
      progressTarget: t.progressTarget,
      progressUnit: t.progressUnit,
      isRepeatable: t.isRepeatable,
      repeatCooldownDays: t.repeatCooldownDays,
      tags: t.tags,
    );
  }

  /// Base XP for a mission based on difficulty.
  int xpForDifficulty(MissionDifficulty difficulty) {
    switch (difficulty) {
      case MissionDifficulty.easy:
        return 75;
      case MissionDifficulty.medium:
        return 175;
      case MissionDifficulty.hard:
        return 375;
      case MissionDifficulty.expert:
        return 750;
    }
  }

  /// Randomly pick [count] items from [list] (without replacement).
  List<T> pickRandom<T>(List<T> list, int count) {
    if (list.length <= count) return List.from(list);
    final shuffled = List<T>.from(list)..shuffle();
    return shuffled.sublist(0, count);
  }
}
