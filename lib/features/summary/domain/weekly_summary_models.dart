/// Weekly aggregates for the weekly summary screen — computed from real
/// ledger data (XP events, streaks, focus sessions, achievement unlocks).
class WeeklySummary {
  /// XP earned in the last 7 days.
  final int weeklyXp;

  /// Lifetime XP (latest balanceAfter in the XP ledger).
  final int totalXp;

  /// Current day streak.
  final int dayStreak;

  /// Total completed focus minutes.
  final int focusMinutes;

  /// Number of completed focus sessions.
  final int focusSessions;

  /// Number of unlocked achievements (badges).
  final int badges;

  const WeeklySummary({
    required this.weeklyXp,
    required this.totalXp,
    required this.dayStreak,
    required this.focusMinutes,
    required this.focusSessions,
    required this.badges,
  });
}