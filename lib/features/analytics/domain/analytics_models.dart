/// Immutable aggregate of a profile's performance stats, computed live from
/// the app's ledger tables (xp_events, focus_sessions, streaks).
class AnalyticsSnapshot {
  final int totalXp;
  final int weeklyXp;
  final int streakDays;
  final int focusMinutes;
  final int sessions;
  final Map<String, int> tagFocus;

  const AnalyticsSnapshot({
    required this.totalXp,
    required this.weeklyXp,
    required this.streakDays,
    required this.focusMinutes,
    required this.sessions,
    this.tagFocus = const {},
  });

  /// Builds a snapshot from raw ledger values.
  factory AnalyticsSnapshot.fromXp({
    required int totalXp,
    required int weeklyXp,
    required int streakDays,
    required int focusMinutes,
    required int sessions,
    Map<String, int> tagFocus = const {},
  }) =>
      AnalyticsSnapshot(
        totalXp: totalXp,
        weeklyXp: weeklyXp,
        streakDays: streakDays,
        focusMinutes: focusMinutes,
        sessions: sessions,
        tagFocus: tagFocus,
      );

  int get tagsCount => tagFocus.length;
}