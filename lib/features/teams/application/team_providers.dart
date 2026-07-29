import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:profileforge/core/data/app_database.dart';
import 'package:profileforge/core/data/app_database_provider.dart';
import 'package:profileforge/features/teams/data/team_repository.dart';
import 'package:profileforge/features/teams/domain/team_models.dart';

final teamRepositoryProvider = Provider<TeamRepository>((ref) {
  return TeamRepository(ref.watch(appDatabaseProvider));
});

final myTeamsProvider =
    FutureProvider.family<List<TeamRow>, String>((ref, profileId) async {
  final db = ref.watch(appDatabaseProvider);
  return (db.select(db.teams)
        ..where((t) => t.ownerProfileId.equals(profileId)))
      .get();
});

final teamMembersProvider =
    FutureProvider.family<List<TeamMemberRow>, String>((ref, teamId) async {
  return ref.watch(teamRepositoryProvider).members(teamId);
});

final teamLeaderboardProvider =
    FutureProvider.family<List<String>, String>((ref, teamId) async {
  final members = await ref.watch(teamRepositoryProvider).members(teamId);
  final engine = TeamEngine();
  return engine.leaderboard({for (final m in members) m.profileId: 0});
});

final createTeamProvider =
    Provider.family<void, ({String id, String name, String owner})>((ref, args) {
  ref.read(teamRepositoryProvider).createTeam(args.id, args.name, args.owner);
});

final joinTeamProvider =
    Provider.family<void, ({String teamId, String profileId})>((ref, args) {
  ref.read(teamRepositoryProvider).joinTeam(args.teamId, args.profileId);
});
