import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:profileforge/core/data/app_database.dart';
import 'package:profileforge/core/data/app_database_provider.dart';
import 'package:profileforge/features/missions/data/mission_repository.dart';
import 'package:profileforge/features/missions/domain/mission_models.dart';
import 'package:profileforge/features/missions/domain/mission_generator.dart';
import 'package:profileforge/features/onboarding/application/onboarding_providers.dart';
import 'package:profileforge/features/xp/application/xp_providers.dart';
import 'package:profileforge/features/wallet/application/wallet_providers.dart';
import 'package:profileforge/features/streak/application/streak_providers.dart';
import 'package:profileforge/features/achievements/application/achievement_trigger.dart';

final missionRepositoryProvider = Provider<MissionRepository>((ref) {
  return MissionRepository(ref.watch(appDatabaseProvider));
});

final todaysMissionsProvider =
    FutureProvider.family<List<MissionRow>, String>((ref, profileId) async {
  final rows =
      await ref.watch(missionRepositoryProvider).listDue(profileId, DateTime.now());
  return rows
      .where((r) => r.cadence == MissionCadence.daily.name)
      .toList();
});

final weeklyMissionsProvider =
    FutureProvider.family<List<MissionRow>, String>((ref, profileId) async {
  final rows =
      await ref.watch(missionRepositoryProvider).listDue(profileId, DateTime.now());
  return rows
      .where((r) => r.cadence == MissionCadence.weekly.name)
      .toList();
});

final missionHistoryProvider =
    FutureProvider.family<List<MissionRow>, String>((ref, profileId) async {
  return ref.watch(missionRepositoryProvider).history(profileId);
});

/// Complete a mission: marks done, awards XP (×skin multiplier) + gems.
final completeMissionProvider = Provider.family<
    Future<void>,
    ({String profileId, String missionId, int xp, String pillar})>((ref, args) async {
  await ref.watch(missionRepositoryProvider).complete(args.missionId);
  // Award XP via the XP ledger (handles skin multiplier through provided xp).
  await ref.read(xpRepositoryProvider).add(
        args.profileId,
        args.xp,
        'mission:${args.missionId}',
      );
  // Award gems (1 gem per 5 XP, min 2).
  final gems = (args.xp / 5).ceil().clamp(2, 50);
  await ref.read(walletRepositoryProvider).add(args.profileId, gems);
  
  // Update streak
  try {
    await ref.read(streakProvider(args.profileId).notifier).recordToday();
  } catch (_) {}
  
  // Check achievements
  try {
    final trigger = ref.read(achievementTriggerProvider);
    final totalXp = await ref.read(xpRepositoryProvider).balance(args.profileId);
    final streak = ref.read(streakProvider(args.profileId)).valueOrNull?.current ?? 0;
    final history = await ref.read(missionHistoryProvider(args.profileId).future);
    final unlocked = await trigger.checkAfterMission(
      profileId: args.profileId,
      missionPillar: args.pillar,
      missionXp: args.xp,
      totalXp: totalXp,
      streak: streak,
      missionsCompleted: history.length,
    );
    if (unlocked.isNotEmpty) {
      // TODO: Show achievement unlock notification
    }
  } catch (_) {}
  
  ref.invalidate(todaysMissionsProvider(args.profileId));
  ref.invalidate(totalXpProvider(args.profileId));
  ref.invalidate(gemsProvider(args.profileId));
});

/// Regenerates today's missions, *personalized* from the onboarding profile.
final generateMissionsProvider = FutureProvider.family<void, String>((ref, profileId) async {
  final onboarding =
      ref.read(onboardingProvider(profileId)).valueOrNull;
  final gen = MissionGenerator();
  final generated = onboarding == null
      ? MissionEngine().generateDaily(profileId)
      : gen
          .generateDaily(onboarding, profileId)
          .map((m) => Mission(
                id: m.id,
                profileId: profileId,
                title: m.title,
                cadence: MissionCadence.daily,
                pillar: _pillar(m.pillar),
                xpReward: m.xp,
                dueAt: DateTime.now().add(const Duration(days: 1)),
                completed: false,
              ))
          .toList();
  await ref.read(missionRepositoryProvider).upsertGenerated(generated);
  ref.invalidate(todaysMissionsProvider(profileId));
});

MissionPillar _pillar(String s) {
  for (final p in MissionPillar.values) {
    if (p.name.toLowerCase() == s.toLowerCase()) return p;
  }
  return MissionPillar.academics;
}
