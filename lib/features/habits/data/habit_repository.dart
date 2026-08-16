import 'package:drift/drift.dart' as drift;
import 'package:profileforge/core/data/app_database.dart';
import 'package:profileforge/features/habits/domain/habit_models.dart';

/// Persists and loads XP debt (broken-streak / early-stop penalties) in the
/// same [XpDebt] table the XP ledger uses — one source of truth.
class HabitRepository {
  final AppDatabase db;
  const HabitRepository(this.db);

  Future<void> addDebt(String profileId, int amount, String reason) async {
    await db.into(db.xpDebt).insert(XpDebtCompanion(
          profileId: drift.Value(profileId),
          amount: drift.Value(amount),
          reason: drift.Value(reason),
        ));
  }

  /// Live stream of unpaid debts for a profile.
  Stream<List<HabitDebt>> watchUnpaidDebts(String profileId) {
    return (db.select(db.xpDebt)
          ..where((t) => t.profileId.equals(profileId) & t.isPaid.equals(false)))
        .watch()
        .map((rows) => [
              for (final r in rows)
                HabitDebt(
                  id: r.id,
                  profileId: r.profileId,
                  amount: r.amount,
                  reason: r.reason,
                  createdAt: r.createdAt,
                  isPaid: r.isPaid,
                ),
            ]);
  }

  Future<void> payDebt(int id) async {
    await (db.update(db.xpDebt)..where((t) => t.id.equals(id)))
        .write(const XpDebtCompanion(isPaid: drift.Value(true)));
  }
}