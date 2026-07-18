import 'package:drift/drift.dart';
import 'package:profileforge/core/data/app_database.dart';

/// XP ledger access. The running balance is the latest `balanceAfter` per profile.
class XpRepository {
  XpRepository(this._db);
  final AppDatabase _db;

  Future<int> totalXp(String profileId) async {
    final row = await (_db.select(_db.xpEvents)
          ..where((t) => t.profileId.equals(profileId))
          ..orderBy([(t) => Ordering.desc(t.id)])
          ..limit(1))
        .getSingleOrNull();
    return row?.balanceAfter ?? 0;
  }

  Future<void> award({
    required String profileId,
    required int amount,
    required String source,
  }) async {
    final current = await totalXp(profileId);
    final balance = current + amount;
    await _db.into(_db.xpEvents).insert(XpEventsCompanion(
      profileId: Value(profileId),
      amount: Value(amount),
      source: Value(source),
      balanceAfter: Value(balance),
    ));
  }

  Future<List<XpEventRow>> history(String profileId) async {
    return (_db.select(_db.xpEvents)
          ..where((t) => t.profileId.equals(profileId))
          ..orderBy([(t) => t.at.desc()]))
        .get();
  }
}
