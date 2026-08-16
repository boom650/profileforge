import 'package:drift/drift.dart';
import 'package:profileforge/core/data/app_database.dart';

class FocusSessionRepository {
  final AppDatabase _db;
  FocusSessionRepository(this._db);

  Future<void> saveSession(FocusSessionsCompanion session) async {
    await _db.into(_db.focusSessions).insert(session);
  }

  Future<List<FocusSessionRow>> recentSessions(String profileId) async {
    return (_db.select(_db.focusSessions)
          ..where((t) => t.profileId.equals(profileId))
          ..orderBy([(t) => OrderingTerm.desc(t.startedAt)])
          ..limit(20))
        .get();
  }

  Future<int> totalFocusMinutes(String profileId) async {
    final result = await _db.customSelect(
      'SELECT COALESCE(SUM(duration_minutes), 0) as t FROM focus_sessions WHERE profile_id = ? AND completed = 1',
      variables: [Variable.withString(profileId)],
    ).getSingle();
    return (result.data['t'] as num).toInt();
  }

  Future<int> totalFocusMinutesToday(String profileId) async {
    final todayStart = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
    final result = await _db.customSelect(
      'SELECT COALESCE(SUM(duration_minutes), 0) as t FROM focus_sessions WHERE profile_id = ? AND completed = 1 AND started_at >= ?',
      variables: [Variable.withString(profileId), Variable.withDateTime(todayStart)],
    ).getSingle();
    return (result.data['t'] as num).toInt();
  }

  Future<int> sessionCount(String profileId) async {
    final result = await _db.customSelect(
      'SELECT COUNT(*) as c FROM focus_sessions WHERE profile_id = ? AND completed = 1',
      variables: [Variable.withString(profileId)],
    ).getSingle();
    return (result.data['c'] as num).toInt();
  }

  Future<Map<String, int>> minutesByTag(String profileId) async {
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
