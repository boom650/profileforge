import 'package:drift/drift.dart';
import 'package:profileforge/core/data/app_database.dart';
import 'package:profileforge/core/data/tables.dart';

class GoalRepository {
  final AppDatabase _db;
  GoalRepository(this._db);

  Future<void> setPrimaryGoal(String profileId, String primaryGoal) async {
    await _db.into(_db.userGoals).insertOnConflictUpdate(UserGoalsCompanion(
      profileId: Value(profileId),
      primaryGoal: Value(primaryGoal),
    ));
  }

  Future<void> setSecondaryGoals(String profileId, List<String> goals) async {
    await _db.into(_db.userGoals).insertOnConflictUpdate(UserGoalsCompanion(
      profileId: Value(profileId),
      secondaryGoals: Value(goals.join(',')),
    ));
  }

  Future<UserGoalRow?> get(String profileId) async {
    return (_db.select(_db.userGoals)
          ..where((t) => t.profileId.equals(profileId)))
        .getSingleOrNull();
  }

  Future<String> getPrimaryGoal(String profileId) async {
    final row = await get(profileId);
    return row?.primaryGoal ?? 'general';
  }
}
