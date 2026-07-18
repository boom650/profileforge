import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:profileforge/core/data/app_database_provider.dart';
import 'package:profileforge/features/missions/data/mission_repository.dart';
import 'package:profileforge/features/missions/domain/mission_models.dart';

final missionRepositoryProvider = Provider<MissionRepository>((ref) {
  return MissionRepository(ref.watch(appDatabaseProvider));
});

final todaysMissionsProvider =
    FutureProvider.family<List<MissionRow>, String>((ref, profileId) async {
  final rows = await ref.watch(missionRepositoryProvider).listDue(profileId, DateTime.now());
  return rows.where((r) => r.cadence == MissionCadence.daily.name).toList();
});

final weeklyMissionsProvider =
    FutureProvider.family<List<MissionRow>, String>((ref, profileId) async {
  final rows = await ref.watch(missionRepositoryProvider).listDue(profileId, DateTime.now());
  return rows.where((r) => r.cadence == MissionCadence.weekly.name).toList();
});

final completeMissionProvider =
    Provider.family<void, ({String profileId, String missionId})>((ref, args) {
  ref.watch(missionRepositoryProvider).complete(args.missionId);
  ref.invalidate(todaysMissionsProvider(args.profileId));
});

/// Recomputes + persists the daily mission set via MissionEngine.
final generateMissionsProvider =
    Provider.family<void, String>((ref, profileId) {
  final engine = MissionEngine();
  final generated = engine.generateDaily(profileId);
  ref.watch(missionRepositoryProvider).upsertGenerated(generated);
  ref.invalidate(todaysMissionsProvider(profileId));
});
