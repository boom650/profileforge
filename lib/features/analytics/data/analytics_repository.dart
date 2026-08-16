import 'package:drift/drift.dart';
import 'package:profileforge/core/data/app_database.dart';
import 'package:profileforge/features/analytics/domain/analytics_models.dart';

/// Computes the analytics [AnalyticsSnapshot] straight from the app's ledger
/// tables — xp_events (XP totals), focus_sessions (focus minutes / sessions
/// / tag breakdown) and streaks (current streak). No synthetic data.
class AnalyticsRepository {
  AnalyticsRepository(this._db);
  final AppDatabase _db;

  Future<AnalyticsSnapshot> snapshot(String profileId) async {
    final totalXp = await _totalXp(profileId);
    final weeklyXp = await _weeklyXp(profileId);
    final streakDays = await _streakDays(profileId);
    final focusMinutes = await _focusMinutes(profileId);
    final sessions = await _sessions(profileId);
    final tagFocus = await _focusMinutesByTag(profileId);
    return AnalyticsSnapshot.fromXp(
      totalXp: totalXp,
      weeklyXp: weeklyXp,
      streakDays: streakDays,
      focusMinutes: focusMinutes,
      sessions: sessions,
      tagFocus: tagFocus,
    );
  }

  /// Running balance: the latest `balanceAfter` in the XP ledger.
  Future<int> _totalXp(String profileId) async {
    final row = await (_db.select(_db.xpEvents)
          ..where((t) => t.profileId.equals(profileId))
          ..orderBy([(t) => OrderingTerm.desc(t.at)])
          ..limit(1))
        .getSingleOrNull();
    return row?.balanceAfter ?? 0;
  }

  /// Sum of XP earned over the last 7 days.
  Future<int> _weeklyXp(String profileId) async {
    final since = DateTime.now().subtract(const Duration(days: 7));
    final rows = await (_db.select(_db.xpEvents)
          ..where((t) => t.profileId.equals(profileId) & t.at.isBiggerThanValue(since)))
        .get();
    var total = 0;
    for (final r in rows) {
      total += r.amount;
    }
    return total;
  }

  /// Current humane streak from the streaks table.
  Future<int> _streakDays(String profileId) async {
    final row = await (_db.select(_db.streaks)
          ..where((t) => t.profileId.equals(profileId)))
        .getSingleOrNull();
    return row?.current ?? 0;
  }

  Future<int> _focusMinutes(String profileId) async {
    final result = await _db.customSelect(
      'SELECT COALESCE(SUM(duration_minutes), 0) as t FROM focus_sessions WHERE profile_id = ? AND completed = 1',
      variables: [Variable.withString(profileId)],
    ).getSingle();
    return (result.data['t'] as num).toInt();
  }

  Future<int> _sessions(String profileId) async {
    final result = await _db.customSelect(
      'SELECT COUNT(*) as c FROM focus_sessions WHERE profile_id = ? AND completed = 1',
      variables: [Variable.withString(profileId)],
    ).getSingle();
    return (result.data['c'] as num).toInt();
  }

  /// Focus minutes grouped by tag, most-focused first.
  Future<Map<String, int>> _focusMinutesByTag(String profileId) async {
    final rows = await _db.customSelect(
      'SELECT tag, SUM(duration_minutes) as t FROM focus_sessions WHERE profile_id = ? AND completed = 1 AND tag != \'\' GROUP BY tag ORDER BY t DESC',
      variables: [Variable.withString(profileId)],
    ).get();
    final map = <String, int>{};
    for (final r in rows) {
      final tag = r.data['tag'] as String;
      final mins = (r.data['t'] as num).toInt();
      if (tag.isNotEmpty) map[tag] = mins;
    }
    return map;
  }
}