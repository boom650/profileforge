import 'package:drift/drift.dart';
import 'package:profileforge/core/data/app_database.dart';
import 'package:profileforge/features/streak/domain/streak_state.dart';

/// Data layer: maps the Drift [Streaks] table to the domain [StreakState].
class StreakRepository {
  final AppDatabase db;
  const StreakRepository(this.db);

  Future<StreakState> get(String profileId) async {
    try {
      final row = await (db.select(db.streaks)
            ..where((t) => t.profileId.equals(profileId)))
          .getSingleOrNull();
      if (row == null) return const StreakState(); // fresh, with default tokens
      return StreakState(
        current: row.current,
        longest: row.longest,
        lastActiveDate: row.lastActiveDate,
        graceDaysUsed: row.graceDaysUsed,
        freezeTokens: row.freezeTokens,
        weekendAmulets: row.weekendAmulets,
        recovered: row.recovered,
      );
    } catch (e, st) {
      // Degrade gracefully: a corrupt/locked DB should not crash the streak card.
      // TODO: report to crash analytics.
      return const StreakState();
    }
  }

  Future<void> save(String profileId, StreakState s) async {
    try {
      await db.into(db.streaks).insertOnConflictUpdate(
            StreaksCompanion(
              profileId: Value(profileId),
              current: Value(s.current),
              longest: Value(s.longest),
              lastActiveDate: Value(s.lastActiveDate),
              graceDaysUsed: Value(s.graceDaysUsed),
              freezeTokens: Value(s.freezeTokens),
              weekendAmulets: Value(s.weekendAmulets),
              recovered: Value(s.recovered),
            ),
          );
    } catch (e) {
      // TODO: enqueue to SyncOutbox retry rather than drop.
      rethrow;
    }
  }
}
