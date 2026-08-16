import 'package:profileforge/core/data/app_database.dart';
import 'package:profileforge/features/skins/domain/skin_definitions.dart';
import 'package:profileforge/features/wallet/domain/wallet_models.dart';

/// Soft-currency (gems) ledger. Read/modify per profile.
///
/// Every mutation is modeled as a [GemTransaction] so earn and spend paths
/// share one clamped, idempotent write path.
class WalletRepository {
  final AppDatabase db;
  const WalletRepository(this.db);

  Future<int> get(String profileId) async {
    final row = await (db.select(db.wallets)
          ..where((t) => t.profileId.equals(profileId)))
        .getSingleOrNull();
    return row?.gems ?? 0;
  }

  /// Current balance as a domain [GemWallet].
  Future<GemWallet> loadWallet(String profileId) async {
    return GemWallet(profileId: profileId, gems: await get(profileId));
  }

  /// Apply a gem mutation as a real ledger transaction.
  /// Positive [amount] earns, negative spends; balance clamps to [0, 9999999].
  Future<GemTransaction> transact(String profileId, int amount) async {
    final current = await get(profileId);
    final next = (current + amount).clamp(0, 9999999);
    await db.into(db.wallets).insertOnConflictUpdate(
          WalletRow(profileId: profileId, gems: next),
        );
    return GemTransaction(amount: amount, balanceAfter: next, at: DateTime.now());
  }

  Future<int> add(String profileId, int amount) async {
    return (await transact(profileId, amount)).balanceAfter;
  }

  Future<bool> spend(String profileId, int cost) async {
    final current = await get(profileId);
    if (current < cost) return false;
    await transact(profileId, -cost);
    return true;
  }

  /// Real gems spent: the sum of shop prices of every owned skin with a
  /// gem cost (free skins and XP-unlocked claims cost nothing).
  Future<int> gemsSpentOnSkins(String profileId) async {
    final unlocks = await (db.select(db.skinUnlocks)
          ..where((t) => t.profileId.equals(profileId)))
        .get();
    var spent = 0;
    for (final unlock in unlocks) {
      spent += kSkinGemCost[unlock.skinId] ?? 0;
    }
    return spent;
  }
}
