import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:profileforge/core/data/app_database.dart';
import 'package:profileforge/core/data/app_database_provider.dart';
import 'package:profileforge/features/achievements/data/achievement_repository.dart';
import 'package:profileforge/features/achievements/domain/achievement_defs.dart';
import 'package:profileforge/features/xp/application/xp_providers.dart';
import 'package:profileforge/features/streak/application/streak_providers.dart';
import 'package:profileforge/features/timer/application/timer_providers.dart';

final achievementRepoProvider = Provider<AchievementRepository>((ref) {
  return AchievementRepository(ref.watch(appDatabaseProvider));
});

/// All achievement definitions (seeded once).
final achievementDefsProvider = FutureProvider<List<AchievementDef>>((ref) async {
  final repo = ref.read(achievementRepoProvider);
  final defs = AchievementDef.all;
  await repo.seedDefinitions(defs.map((d) => AchievementDefinitionsCompanion(
    id: Value(d.id),
    name: Value(d.name),
    description: Value(d.description),
    icon: Value(d.icon),
    criteriaType: Value(d.criteriaType),
    criteriaValue: Value(d.criteriaValue),
  )).toList());
  return defs;
});

/// Unlocked achievement IDs for a profile.
final unlockedAchievementIdsProvider = FutureProvider.family<Set<String>, String>((ref, profileId) async {
  final repo = ref.read(achievementRepoProvider);
  return repo.unlockedIds(profileId);
});

/// Full unlocked achievement list.
final unlockedAchievementsProvider = FutureProvider.family<List<AchievementUnlockRow>, String>((ref, profileId) async {
  final repo = ref.read(achievementRepoProvider);
  return repo.unlocked(profileId);
});

/// Get the count of unlocked achievements.
final achievementCountProvider = FutureProvider.family<int, String>((ref, profileId) async {
  final repo = ref.read(achievementRepoProvider);
  final unlocked = await repo.unlocked(profileId);
  return unlocked.length;
});

/// Check ALL achievements and unlock any that should be unlocked.
final achievementCheckerProvider = NotifierProvider<AchievementCheckerNotifier, void>(AchievementCheckerNotifier.new);

class AchievementCheckerNotifier extends Notifier<void> {
  @override
  void build() {}

  Future<void> checkAll(String profileId) async {
    final repo = ref.read(achievementRepoProvider);

    // Invalidate cached providers FIRST so evaluation reads FRESH data —
    // otherwise a just-completed mission/focus session never counts until
    // the NEXT event (off-by-one badge pops). Missions award XP before
    // calling checkAll; the invalidations here re-read the new totals.
    ref.invalidate(totalXpProvider(profileId));
    ref.invalidate(focusSessionCountProvider(profileId));
    ref.invalidate(totalFocusMinutesProvider(profileId));

    final unlocked = await repo.unlockedIds(profileId);
    final xp = await ref.read(totalXpProvider(profileId).future);
    final streak = await ref.read(streakRepositoryProvider).get(profileId);
    final streakCount = streak.current;
    final missionsDone = await repo.totalMissionsCompleted(profileId);
    final focusSessions = await ref.read(focusSessionCountProvider(profileId).future);
    final focusMinutes = await ref.read(totalFocusMinutesProvider(profileId).future);
    final questsDone = await repo.totalQuestsCompleted(profileId);
    final loginClaims = await repo.totalLoginClaims(profileId);
    final skinsUnlocked = await repo.totalSkinsUnlocked(profileId);

    for (final def in AchievementDef.all) {
      if (unlocked.contains(def.id)) continue;
      bool shouldUnlock = false;
      switch (def.criteriaType) {
        case 'streak':
          shouldUnlock = streakCount >= def.criteriaValue;
          break;
        case 'xp_total':
          shouldUnlock = xp >= def.criteriaValue;
          break;
        case 'missions_total':
          shouldUnlock = missionsDone >= def.criteriaValue;
          break;
        case 'focus_sessions':
          shouldUnlock = focusSessions >= def.criteriaValue;
          break;
        case 'focus_total':
          shouldUnlock = focusMinutes >= def.criteriaValue;
          break;
        case 'quests_total':
          shouldUnlock = questsDone >= def.criteriaValue;
          break;
        case 'daily_login':
          shouldUnlock = loginClaims >= def.criteriaValue;
          break;
        case 'skins_unlocked':
          shouldUnlock = skinsUnlocked >= def.criteriaValue;
          break;
      }
      if (shouldUnlock) {
        await repo.unlock(profileId, def.id);
        ref.invalidate(unlockedAchievementIdsProvider(profileId));
        ref.invalidate(unlockedAchievementsProvider(profileId));
        ref.invalidate(achievementCountProvider(profileId));
      }
    }
  }
}
