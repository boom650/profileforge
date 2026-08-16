/// Aggregate statistics for the stats overview screen — computed from real
/// ledger data (XP events, streaks, focus sessions). Nothing is fabricated.
class StatsOverview {
  /// Current day streak (streaks table).
  final int dayStreak;

  /// Lifetime XP (latest balanceAfter in the XP ledger).
  final int totalXp;

  /// Total AI chat conversations recorded (pf_ai_chat_count counter).
  final int aiChats;

  /// XP earned per source (mission, streak, daily, ...) — drives the
  /// per-source breakdown.
  final Map<String, int> xpBySource;

  const StatsOverview({
    required this.dayStreak,
    required this.totalXp,
    required this.aiChats,
    required this.xpBySource,
  });
}