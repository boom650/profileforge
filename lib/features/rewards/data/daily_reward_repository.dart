import 'package:profileforge/core/data/app_database.dart';
import 'package:profileforge/features/rewards/domain/daily_reward_models.dart';

/// 7-day login-reward wheel state.
class DailyRewardRepository {
  final AppDatabase db;
  const DailyRewardRepository(this.db);

  /// Returns (day 1..7, canClaimToday, lastDayClaimed).
  Future<DailyRewardStatus> status(String profileId) async {
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
    final reward = DailyRewardTier.gemsFor(s.day);
    final existing = await (db.select(db.dailyRewards)
          ..where((t) => t.profileId.equals(profileId)))
        .getSingleOrNull();
    await db.into(db.dailyRewards).insertOnConflictUpdate(
          DailyRewardRow(
            profileId: profileId,
            day: s.day,
            totalClaims: (existing?.totalClaims ?? 0) + 1,
            lastClaimed: DateTime.now(),
          ),
        );
    return reward;
  }
}