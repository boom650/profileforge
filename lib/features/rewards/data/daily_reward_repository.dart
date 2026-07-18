import 'package:drift/drift.dart';
import 'package:profileforge/core/data/app_database.dart';

/// 7-day login-reward wheel state.
class DailyRewardRepository {
  final AppDatabase db;
  const DailyRewardRepository(this.db);

  /// Returns (day 1..7, canClaimToday, lastDayClaimed).
  Future<({int day, bool canClaim, int lastDay})> status(
      String profileId) async {
    final row = await (db.select(db.dailyRewards)
          ..where((t) => t.profileId.equals(profileId)))
        .getSingleOrNull();
    final last = row?.lastClaimed;
    final lastDay = row?.day ?? 0;
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final sameDay = last != null &&
        last.year == today.year &&
        last.month == today.month &&
        last.day == today.day;
    // If last claim was yesterday-or-earlier, the wheel advances; if >7 days gap, reset to 1.
    int day;
    if (last == null) {
      day = 1;
    } else {
      final lastDate = DateTime(last.year, last.month, last.day);
      final gap = today.difference(lastDate).inDays;
      if (gap <= 0) {
        day = lastDay; // already claimed today
      } else if (gap == 1) {
        day = lastDay >= 7 ? 1 : lastDay + 1;
      } else {
        day = 1; // streak broken
      }
    }
    return (day: day, canClaim: !sameDay, lastDay: lastDay);
  }

  Future<int> claim(String profileId) async {
    final s = await status(profileId);
    if (!s.canClaim) return 0;
    final reward = rewardFor(s.day);
    await db.into(db.dailyRewards).insertOnConflictUpdate(
          DailyRewardRow(
            profileId: profileId,
            day: s.day,
            lastClaimed: DateTime.now(),
          ),
        );
    return reward;
  }

  /// Gems awarded for a given wheel day.
  static int rewardFor(int day) => switch (day) {
        1 => 20,
        2 => 30,
        3 => 40,
        4 => 50,
        5 => 60,
        6 => 80,
        7 => 150,
        _ => 20,
      };
}
