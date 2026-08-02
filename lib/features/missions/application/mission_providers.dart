import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:profileforge/core/data/app_database.dart';
import 'package:profileforge/core/data/app_database_provider.dart';
import 'package:profileforge/features/missions/data/mission_repository.dart';
import 'package:profileforge/features/missions/domain/mission_models.dart';
import 'package:profileforge/features/missions/domain/mission_generator.dart';
import 'package:profileforge/features/onboarding/application/onboarding_providers.dart';
import 'package:profileforge/features/xp/application/xp_providers.dart';
import 'package:profileforge/features/wallet/application/wallet_providers.dart';

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

final monthlyMissionsProvider =
    FutureProvider.family<List<MissionRow>, String>((ref, profileId) async {
  final rows =
      await ref.watch(missionRepositoryProvider).listDue(profileId, DateTime.now());
  return rows
      .where((r) => r.cadence == MissionCadence.monthly.name)
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
  ref.invalidate(todaysMissionsProvider(args.profileId));
  ref.invalidate(weeklyMissionsProvider(args.profileId));
  ref.invalidate(monthlyMissionsProvider(args.profileId));
  ref.invalidate(totalXpProvider(args.profileId));
  ref.invalidate(gemsProvider(args.profileId));
});

/// Regenerates all missions (daily + weekly + monthly).
final generateMissionsProvider = FutureProvider.family<void, String>((ref, profileId) async {
  final onboarding =
      ref.read(onboardingProvider(profileId)).valueOrNull;

  final engine = MissionEngine();

  // Generate all mission types.
  final allMissions = <Mission>[];

  // Daily missions — personalized if possible.
  if (onboarding != null) {
    final gen = MissionGenerator();
    final personalized = gen.generateDaily(onboarding, profileId);
    allMissions.addAll(personalized.map((m) => Mission(
          id: m.id,
          profileId: profileId,
          title: m.title,
          description: 'Complete this mission to earn XP and gems.',
          cadence: MissionCadence.daily,
          pillar: _pillar(m.pillar),
          xpReward: m.xp,
          gemReward: (m.xp / 5).ceil().clamp(2, 10),
          dueAt: DateTime.now().add(const Duration(days: 1)),
          completed: false,
        )));
  } else {
    allMissions.addAll(engine.generateDaily(profileId));
  }

  // Weekly missions.
  allMissions.addAll(engine.generateWeekly(profileId));

  // Monthly missions.
  allMissions.addAll(engine.generateMonthly(profileId));

  await ref.read(missionRepositoryProvider).upsertGenerated(allMissions);
  ref.invalidate(todaysMissionsProvider(profileId));
  ref.invalidate(weeklyMissionsProvider(profileId));
  ref.invalidate(monthlyMissionsProvider(profileId));
});

MissionPillar _pillar(String s) {
  for (final p in MissionPillar.values) {
    if (p.name.toLowerCase() == s.toLowerCase()) return p;
  }
  return MissionPillar.academics;
}
