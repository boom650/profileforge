import 'package:drift/drift.dart';
import 'package:profileforge/core/data/app_database.dart';

class TeamRepository {
  TeamRepository(this._db);
  final AppDatabase _db;

  Future<void> createTeam(String id, String name, String owner) async {
    await _db.into(_db.teams).insert(TeamsCompanion(
      id: Value(id),
      name: Value(name),
      ownerProfileId: Value(owner),
    ));
    await _db.into(_db.teamMembers).insert(TeamMembersCompanion(
      teamId: Value(id),
      profileId: Value(owner),
      role: const Value('owner'),
    ));
  }

  Future<void> joinTeam(String teamId, String profileId) async {
    await _db.into(_db.teamMembers).insertOnConflictUpdate(TeamMembersCompanion(
      teamId: Value(teamId),
      profileId: Value(profileId),
    ));
  }

  Future<List<TeamMember>> members(String teamId) async {
    return (_db.select(_db.teamMembers)
          ..where((t) => t.teamId.equals(teamId)))
        .get();
  }

  Future<void> postChallengeProgress(String challengeId, int xp) async {
    final row = await (_db.select(_db.teamChallenges)
          ..where((t) => t.id.equals(challengeId)))
        .getSingleOrNull();
    if (row != null) {
      await (_db.update(_db.teamChallenges)
            ..where((t) => t.id.equals(challengeId)))
          .write(TeamChallengesCompanion(currentXp: Value(row.currentXp + xp)));
    }
  }

  Future<List<TeamChallenge>> challenges(String teamId) async {
    return (_db.select(_db.teamChallenges)
          ..where((t) => t.teamId.equals(teamId)))
        .get();
  }
}
