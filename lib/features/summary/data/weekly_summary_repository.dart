import 'package:drift/drift.dart';
import 'package:profileforge/core/data/app_database.dart';
import 'package:profileforge/features/summary/domain/weekly_summary_models.dart';

/// Real DB aggregations for the weekly summary — every number comes from a
/// query over the app tables, never hardcoded.
class WeeklySummaryRepository {
  WeeklySummaryRepository(this._db);
  final AppDatabase _db;

  /// XP earned per calendar day for the last [days] days (inclusive of today).
  Future<Map<DateTime, int>> xpByDay(String profileId, int days) async {
    final events = await (_db.select(_db.xpEvents)
          ..where((t) => t.profileId.equals(profileId)))
        .get();
    final today = DateTime.now();
    final dayOnly = (DateTime d) => DateTime(d.year, d.month, d.day);
    final byDay = <DateTime, int>{};
    for (var i = days - 1; i >= 0; i--) {
      byDay[dayOnly(today.subtract(Duration(days: i)))] = 0;
    }
    for (final e in events) {
      final d = dayOnly(e.at);
      if (byDay.containsKey(d)) byDay[d] = byDay[d]! + e.amount;
    }
    return byDay;
  }

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

  /// Total completed focus minutes.
  Future<int> focusMinutes(String profileId) async {
    final result = await _db.customSelect(
      'SELECT COALESCE(SUM(duration_minutes), 0) as t FROM focus_sessions WHERE profile_id = ? AND completed = 1',
      variables: [Variable.withString(profileId)],
    ).getSingle();
    return (result.data['t'] as num).toInt();
  }

  /// Number of completed focus sessions.
  Future<int> focusSessionCount(String profileId) async {
    final result = await _db.customSelect(
      'SELECT COUNT(*) as c FROM focus_sessions WHERE profile_id = ? AND completed = 1',
      variables: [Variable.withString(profileId)],
    ).getSingle();
    return (result.data['c'] as num).toInt();
  }

  /// Number of unlocked achievements (badges).
  Future<int> badgeCount(String profileId) async {
    final rows = await (_db.select(_db.achievementUnlocks)
          ..where((t) => t.profileId.equals(profileId)))
        .get();
    return rows.length;
  }

  /// Full weekly summary snapshot for a profile.
  Future<WeeklySummary> fetch(String profileId) async {
    final byDay = await xpByDay(profileId, 7);
    final results = await Future.wait<Object>([
      totalXp(profileId),
      dayStreak(profileId),
      focusMinutes(profileId),
      focusSessionCount(profileId),
      badgeCount(profileId),
    ]);
    return WeeklySummary(
      weeklyXp: byDay.values.fold<int>(0, (a, b) => a + b),
      totalXp: results[0] as int,
      dayStreak: results[1] as int,
      focusMinutes: results[2] as int,
      focusSessions: results[3] as int,
      badges: results[4] as int,
    );
  }
}