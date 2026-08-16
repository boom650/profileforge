import 'package:drift/drift.dart';
import 'package:profileforge/core/data/app_database.dart';
import 'package:profileforge/features/goals/domain/goal_models.dart';

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
      secondaryGoals: Value(UserGoal.encodeSecondary(goals)),
    ));
  }

  /// The user's goal preferences as a domain [UserGoal], or null when the
  /// profile has never configured goals.
  Future<UserGoal?> get(String profileId) async {
    final row = await (_db.select(_db.userGoals)
          ..where((t) => t.profileId.equals(profileId)))
        .getSingleOrNull();
    if (row == null) return null;
    return UserGoal(
      primaryGoal: row.primaryGoal,
      secondaryGoals: UserGoal.decodeSecondary(row.secondaryGoals),
    );
  }

  Future<String> getPrimaryGoal(String profileId) async {
    final row = await (_db.select(_db.userGoals)
          ..where((t) => t.profileId.equals(profileId)))
        .getSingleOrNull();
    return GoalOption.byId(row?.primaryGoal ?? 'general').id;
  }
}