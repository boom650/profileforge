import 'package:drift/drift.dart';
import 'package:profileforge/core/data/app_database.dart';
import 'package:profileforge/core/rate_app/rate_app_service.dart';
import 'package:profileforge/features/stats/domain/stats_models.dart';

/// Real DB aggregations over the XP ledger, streaks and focus sessions.
class StatsRepository {
  StatsRepository(this._db);
  final AppDatabase _db;

  /// Current day streak from the streaks table.
  Future<int> dayStreak(String profileId) async {
    final row = await (_db.select(_db.streaks)
          ..where((t) => t.profileId.equals(profileId)))
        .getSingleOrNull();
    return row?.current ?? 0;
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

  /// XP earned by source from the XP ledger.
  Future<Map<String, int>> xpBySource(String profileId) async {
    final rows = await (_db.select(_db.xpEvents)
          ..where((t) => t.profileId.equals(profileId)))
        .get();
    final bySource = <String, int>{};
    for (final e in rows) {
      bySource[e.source] = (bySource[e.source] ?? 0) + e.amount;
    }
    return bySource;
  }

  /// Total AI chat conversations (real counter from the rate-app service).
  Future<int> aiChats() => RateAppService.instance.chatCount();

  /// Full aggregate snapshot powering the stats overview screen.
  Future<StatsOverview> overview(String profileId) async {
    final results = await Future.wait([
      dayStreak(profileId),
      totalXp(profileId),
      xpBySource(profileId),
      aiChats(),
    ]);
    return StatsOverview(
      dayStreak: results[0] as int,
      totalXp: results[1] as int,
      xpBySource: results[2] as Map<String, int>,
      aiChats: results[3] as int,
    );
  }
}