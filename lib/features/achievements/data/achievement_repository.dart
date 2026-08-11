import 'package:drift/drift.dart';
import 'package:profileforge/core/data/app_database.dart';

class AchievementRepository {
  final AppDatabase _db;
  AchievementRepository(this._db);

  Future<void> seedDefinitions(List<AchievementDefinitionsCompanion> defs) async {
    for (final d in defs) {
      await _db.into(_db.achievementDefinitions).insertOnConflictUpdate(d);
    }
  }

  Future<Set<String>> unlockedIds(String profileId) async {
    final rows = await (_db.select(_db.achievementUnlocks)
          ..where((t) => t.profileId.equals(profileId)))
        .get();
    return rows.map((r) => r.achievementId).toSet();
  }

  Future<List<AchievementUnlockRow>> unlocked(String profileId) async {
    return (_db.select(_db.achievementUnlocks)
          ..where((t) => t.profileId.equals(profileId)))
        .get();
  }

  Future<void> unlock(String profileId, String badgeId) async {
    await _db.into(_db.achievementUnlocks).insert(AchievementUnlocksCompanion(
      profileId: Value(profileId),
      achievementId: Value(badgeId),
      unlockedAt: Value(DateTime.now()),
    ), mode: InsertMode.insertOrIgnore);
  }

  Future<int> totalMissionsCompleted(String profileId) async {
    // COUNT, not a full row scan — checkAll runs on every mission completion.
    final count = await _db.customSelect(
      'SELECT COUNT(*) as c FROM missions WHERE profile_id = ? AND done = 1',
      variables: [Variable.withString(profileId)],
    ).getSingle();
    return count.data['c'] as int;
  }

  Future<int> totalQuestsCompleted(String profileId) async {
    final count = await _db.customSelect(
      'SELECT COUNT(*) as c FROM daily_quests WHERE profile_id = ? AND done = 1',
      variables: [Variable.withString(profileId)],
    ).getSingle();
    return count.data['c'] as int;
  }

  Future<int> totalLoginClaims(String profileId) async {
    // Lifetime claim counter — a REAL count of wheel claims. (The old
    // version compared an Int day-slot against a date string AND the table
    // holds one row per profile → count was always 0, so the daily-login
    // badges could never unlock.)
    final row = await (_db.select(_db.dailyRewards)
          ..where((t) => t.profileId.equals(profileId)))
        .getSingleOrNull();
    return row?.totalClaims ?? 0;
  }

  Future<int> totalSkinsUnlocked(String profileId) async {
    final rows = await (_db.select(_db.skinStates)
          ..where((t) => t.id.equals(profileId) & t.unlocked.equals(true)))
        .get();
    return rows.length;
  }
}
