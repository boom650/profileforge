/// A single day-tier on the 7-day login-reward wheel. Pure domain data —
/// the gems table used by the repository and the UI wheel.
class DailyRewardTier {
  final int day;
  final int gems;

  const DailyRewardTier({required this.day, required this.gems});

  static const List<DailyRewardTier> tiers = [
    DailyRewardTier(day: 1, gems: 20),
    DailyRewardTier(day: 2, gems: 30),
    DailyRewardTier(day: 3, gems: 40),
    DailyRewardTier(day: 4, gems: 50),
    DailyRewardTier(day: 5, gems: 60),
    DailyRewardTier(day: 6, gems: 80),
    DailyRewardTier(day: 7, gems: 150),
  ];

  /// Gems awarded for a given wheel [day]. Days outside the wheel (e.g. 0
  /// before the first claim) fall back to the day-1 reward.
  static int gemsFor(int day) {
    for (final tier in tiers) {
      if (tier.day == day) return tier.gems;
    }
    return tiers.first.gems;
  }

  static DailyRewardTier? forDay(int day) {
    for (final tier in tiers) {
      if (tier.day == day) return tier;
    }
    return null;
  }
}

/// Wheel state returned by the repository: current day, whether today's
/// reward can be claimed, and the last claimed day (0 if never).
typedef DailyRewardStatus = ({int day, bool canClaim, int lastDay});