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
    // Count missions completed today for this profile
    final rows = await (_db.select(_db.missions)
          ..where((t) => t.profileId.equals(profileId) & t.done.equals(true)))
        .get();
    return rows.length;
  }

  Future<int> totalQuestsCompleted(String profileId) async {
    final rows = await (_db.select(_db.dailyQuests)
          ..where((t) => t.profileId.equals(profileId) & t.done.equals(true)))
        .get();
    return rows.length;
  }

  Future<int> totalLoginClaims(String profileId) async {
    final todayStr = DateTime.now().toIso8601String().substring(0, 10);
    final count = await _db.customSelect(
      'SELECT COUNT(*) as c FROM daily_rewards WHERE profile_id = ? AND day = ?',
      variables: [Variable.withString(profileId), Variable.withString(todayStr)],
    ).getSingle();
    return count.data['c'] as int;
  }

  Future<int> totalSkinsUnlocked(String profileId) async {
    final rows = await (_db.select(_db.skinStates)
          ..where((t) => t.id.equals(profileId) & t.unlocked.equals(true)))
        .get();
    return rows.length;
  }
}
