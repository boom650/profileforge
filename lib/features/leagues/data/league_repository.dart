import 'package:drift/drift.dart';
import 'package:profileforge/core/data/app_database.dart';
import 'package:profileforge/features/leagues/domain/league_definitions.dart';

class LeagueRepository {
  LeagueRepository(this._db);
  final AppDatabase _db;

  /// Accumulate XP for a member this season. Creates membership on first
  /// award; preserves the tier of an existing row.
  Future<void> recordXp(String profileId, String seasonId, LeagueTier tier, int xp) async {
    final existing = await (_db.select(_db.leagueMemberships)
          ..where((t) => t.profileId.equals(profileId) & t.cohortId.equals(seasonId)))
        .getSingleOrNull();
    if (existing != null) {
      await (_db.update(_db.leagueMemberships)
            ..where((t) => t.id.equals(existing.id)))
          .write(LeagueMembershipsCompanion(
        weeklyXp: Value(existing.weeklyXp + xp),
        tier: Value(existing.tier),
      ));
      return;
    }
    await _db.into(_db.leagueMemberships).insert(LeagueMembershipsCompanion(
      profileId: Value(profileId),
      cohortId: Value(seasonId),
      tier: Value(tier.name),
      weeklyXp: Value(xp),
      seasonStart: Value(DateTime.now()),
    ));
  }

  Future<List<LeagueMembership>> cohort(String seasonId, LeagueTier tier) async {
    return (_db.select(_db.leagueMemberships)
          ..where((t) =>
              t.cohortId.equals(seasonId) & t.tier.equals(tier.name)))
        .get();
  }

  Future<LeagueMembership?> mine(String profileId, String seasonId) async {
    return (_db.select(_db.leagueMemberships)
          ..where((t) =>
              t.profileId.equals(profileId) & t.cohortId.equals(seasonId)))
        .getSingleOrNull();
  }

  Future<void> setTier(String profileId, String seasonId, LeagueTier tier) async {
    await (_db.update(_db.leagueMemberships)
          ..where((t) =>
              t.profileId.equals(profileId) & t.cohortId.equals(seasonId)))
        .write(LeagueMembershipsCompanion(tier: Value(tier.name)));
  }

  Future<void> resetWeeklyXp(String seasonId) async {
    await (_db.update(_db.leagueMemberships)
          ..where((t) => t.cohortId.equals(seasonId)))
        .write(const LeagueMembershipsCompanion(weeklyXp: Value(0)));
  }
}
