import 'package:drift/drift.dart';
import 'package:profileforge/core/data/app_database.dart';
import 'package:profileforge/features/activity/domain/activity_models.dart';

/// Builds the activity timeline from the XP ledger — the single source of
/// truth. Every XP event (mission, quest, focus session, login) becomes an
/// activity entry. Nothing is fabricated.
class ActivityRepository {
  ActivityRepository(this._db);
  final AppDatabase _db;

  /// Latest activity entries for a profile (newest first).
  Future<List<ActivityEntry>> history(String profileId) async {
    final events = (_db.select(_db.xpEvents)
          ..where((t) => t.profileId.equals(profileId))
          ..orderBy([(t) => OrderingTerm.desc(t.at)]))
        .get();
    final activities = (await events)
        .map((e) => ActivityEntry(
              type: ActivityEntry.typeForSource(e.source),
              title: ActivityEntry.titleForSource(e.source),
              description: '+${e.amount} XP · balance ${e.balanceAfter}',
              timestamp: e.at,
              icon: ActivityEntry.visualsForSource(e.source).icon,
              color: ActivityEntry.visualsForSource(e.source).color,
            ))
        .toList()
      ..sort((a, b) => b.timestamp.compareTo(a.timestamp));
    return activities;
  }
}