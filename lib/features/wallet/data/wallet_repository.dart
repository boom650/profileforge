import 'package:drift/drift.dart';
import 'package:profileforge/core/data/app_database.dart';

/// Soft-currency (gems) ledger. Read/modify per profile.
class WalletRepository {
  final AppDatabase db;
  const WalletRepository(this.db);

  Future<int> get(String profileId) async {
    final row = await (db.select(db.wallets)
          ..where((t) => t.profileId.equals(profileId)))
        .getSingleOrNull();
    return row?.gems ?? 0;
  }

  Future<int> add(String profileId, int amount) async {
    final current = await get(profileId);
    final next = (current + amount).clamp(0, 9999999);
    await db.into(db.wallets).insertOnConflictUpdate(
          WalletRow(profileId: profileId, gems: next),
        );
    return next;
  }

  Future<bool> spend(String profileId, int cost) async {
    final current = await get(profileId);
    if (current < cost) return false;
    await add(profileId, -cost);
    return true;
  }
}
