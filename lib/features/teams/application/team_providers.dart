import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:profileforge/core/data/app_database_provider.dart';
import 'package:profileforge/features/teams/data/team_repository.dart';

final teamRepositoryProvider = Provider<TeamRepository>((ref) {
  return TeamRepository(ref.watch(appDatabaseProvider));
});

final myTeamsProvider =
    FutureProvider.family<List<TeamMember>, String>((ref, profileId) async {
  return (_db(ref).select(_db(ref).teams)).get() as Future<List<TeamMember>>;
});

final teamLeaderboardProvider =
    FutureProvider.family<List<String>, String>((ref, teamId) async {
  final members = await ref.watch(teamRepositoryProvider).members(teamId);
  final engine = TeamEngine();
  return engine.leaderboard({for (final m in members) m.profileId: 0});
});

final createTeamProvider =
    Provider.family<void, ({String id, String name, String owner})>((ref, args) {
  ref.watch(teamRepositoryProvider).createTeam(args.id, args.name, args.owner);
});

final joinTeamProvider =
    Provider.family<void, ({String teamId, String profileId})>((ref, args) {
  ref.watch(teamRepositoryProvider).joinTeam(args.teamId, args.profileId);
});

AppDatabase _db(WidgetRef ref) => ref.watch(appDatabaseProvider);
