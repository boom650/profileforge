import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:profileforge/core/data/app_database.dart';
import 'package:profileforge/core/data/app_database_provider.dart';
import 'package:profileforge/features/quests/data/quest_repository.dart';
import 'package:profileforge/features/xp/application/xp_providers.dart';
import 'package:profileforge/features/achievements/application/achievement_providers.dart';

final questRepoProvider = Provider<DailyQuestRepository>((ref) {
  return DailyQuestRepository(ref.watch(appDatabaseProvider));
});

/// Generate today's quests (if not already generated).
final generateQuestsProvider = FutureProvider.family<List<DailyQuestRow>, String>((ref, profileId) async {
  final repo = ref.read(questRepoProvider);
  return repo.generateToday(profileId);
});

/// Today's quests.
final todayQuestsProvider = FutureProvider.family<List<DailyQuestRow>, String>((ref, profileId) async {
  final repo = ref.read(questRepoProvider);
  return repo.todayQuests(profileId);
});

/// Complete a daily quest, award XP, check achievements.
final completeQuestProvider = FutureProvider.family<void, ({String profileId, String questId, int xp})>((ref, args) async {
  final repo = ref.read(questRepoProvider);
  await repo.complete(args.questId);
  // Award XP
  final xpRepo = ref.read(xpRepositoryProvider);
  await xpRepo.add(args.profileId, args.xp, 'daily_quest');
  // Invalidate
  ref.invalidate(todayQuestsProvider(args.profileId));
  // Check achievements — evaluation reads FRESH totals (checkAll
  // invalidates cached XP/focus providers itself); never blocks the flow.
  try {
    await ref.read(achievementCheckerProvider.notifier).checkAll(args.profileId);
  } catch (_) {/* reward flow must never be blocked by achievement eval */}
});
