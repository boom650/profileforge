import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:profileforge/core/data/app_database.dart';
import 'package:profileforge/core/data/app_database_provider.dart';
import 'package:drift/drift.dart' as drift;

final xpDebtProvider = Provider<XpDebtRepository>((ref) {
  final db = ref.read(appDatabaseProvider);
  return XpDebtRepository(db);
});

class XpDebtRepository {
  final AppDatabase db;
  XpDebtRepository(this.db);

  Future<void> addDebt(String profileId, int amount, String reason) async {
    await db.into(db.xpDebt).insert(XpDebtCompanion(
      profileId: drift.Value(profileId),
      amount: drift.Value(amount),
      reason: drift.Value(reason),
    ));
  }

  Stream<List<XpDebtRow>> watchDebts(String profileId) {
    return (db.select(db.xpDebt)..where((t) => t.profileId.equals(profileId) & t.isPaid.equals(false)))
        .watch();
  }

  Future<void> payDebt(int id) async {
    await (db.update(db.xpDebt)..where((t) => t.id.equals(id))).write(const XpDebtCompanion(isPaid: drift.Value(true)));
  }
}
