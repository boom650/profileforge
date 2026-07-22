import 'package:drift/drift.dart';
import 'package:profileforge/core/data/app_database.dart';

/// XP ledger access. The running balance is the latest `balanceAfter` per profile.
class XpRepository {
  XpRepository(this._db);
  final AppDatabase _db;

  Future<int> totalXp(String profileId) async {
    final row = await (_db.select(_db.xpEvents)
          ..where((t) => t.profileId.equals(profileId))
          ..orderBy([(t) => OrderingTerm.desc(t.at)])
          ..limit(1))
        .getSingleOrNull();
    return row?.balanceAfter ?? 0;
  }

  Future<void> add(String profileId, int amount, String source) async {
    final current = await totalXp(profileId);
    final balance = current + amount;
    await _db.into(_db.xpEvents).insert(XpEventsCompanion(
      profileId: Value(profileId),
      amount: Value(amount),
      source: Value(source),
      balanceAfter: Value(balance),
    ));
  }

  Future<int> xpSince(String profileId, DateTime since) async {
    final rows = await (_db.select(_db.xpEvents)
          ..where((t) => t.profileId.equals(profileId) & t.at.isBiggerThanValue(since)))
        .get();
    int total = 0;
    for (final r in rows) {
      total += r.amount;
    }
    return total;
  }

  Future<List<XpEventRow>> history(String profileId) async {
    return (_db.select(_db.xpEvents)
          ..where((t) => t.profileId.equals(profileId))
          ..orderBy([(t) => OrderingTerm.desc(t.at)]))
        .get();
  }
}
