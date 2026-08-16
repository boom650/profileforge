import 'package:drift/drift.dart';
import 'package:profileforge/core/data/app_database.dart';
import 'package:profileforge/features/share/domain/share_models.dart';

/// Builds a [ShareSnapshot] from real app data — the same numbers the
/// progress card displays, queried directly from the database.
class ShareRepository {
  ShareRepository(this._db);
  final AppDatabase _db;

  /// Lifetime XP — the running balance is the latest `balanceAfter`.
  Future<int> totalXp(String profileId) async {
    final row = await (_db.select(_db.xpEvents)
          ..where((t) => t.profileId.equals(profileId))
          ..orderBy([(t) => OrderingTerm.desc(t.at)])
          ..limit(1))
        .getSingleOrNull();
    return row?.balanceAfter ?? 0;
  }

  /// Current day streak from the streaks table.
  Future<int> dayStreak(String profileId) async {
    final row = await (_db.select(_db.streaks)
          ..where((t) => t.profileId.equals(profileId)))
        .getSingleOrNull();
    return row?.current ?? 0;
  }

  /// Number of unlocked achievements (badges).
  Future<int> badgeCount(String profileId) async {
    final rows = await (_db.select(_db.achievementUnlocks)
          ..where((t) => t.profileId.equals(profileId)))
        .get();
    return rows.length;
  }

  /// Total completed focus minutes.
  Future<int> focusMinutes(String profileId) async {
    final result = await _db.customSelect(
      'SELECT COALESCE(SUM(duration_minutes), 0) as t FROM focus_sessions WHERE profile_id = ? AND completed = 1',
      variables: [Variable.withString(profileId)],
    ).getSingle();
    return (result.data['t'] as num).toInt();
  }

  /// Full share snapshot for a profile.
  Future<ShareSnapshot> snapshot(String profileId) async {
    final results = await Future.wait<Object>([
      totalXp(profileId),
      dayStreak(profileId),
      badgeCount(profileId),
      focusMinutes(profileId),
    ]);
    return ShareSnapshot(
      xp: results[0] as int,
      streak: results[1] as int,
      badges: results[2] as int,
      focusMinutes: results[3] as int,
    );
  }
}