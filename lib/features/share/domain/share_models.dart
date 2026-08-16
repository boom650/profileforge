/// Snapshot of the user's progress used to build share content.
/// Values come from real app data (XP ledger, streaks, focus sessions,
/// achievements) — never fabricated.
class ShareSnapshot {
  final int xp;
  final int streak;
  final int badges;
  final int focusMinutes;

  const ShareSnapshot({
    required this.xp,
    required this.streak,
    required this.badges,
    required this.focusMinutes,
  });

  /// The share text users copy to the clipboard.
  String buildShareText() {
    return 'My ProfileForge Progress:\n'
        'XP: $xp\n'
        'Streak: $streak days\n'
        'Badges: $badges\n'
        'Focus: $focusMinutes min\n'
        'Download ProfileForge and build YOUR future!';
  }
}