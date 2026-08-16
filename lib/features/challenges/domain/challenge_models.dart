/// Lifecycle of a friend challenge, mirroring the `status` column of the
/// `friend_challenges` table. Keeping the raw strings in one place prevents
/// drift between the repository and UI.
enum ChallengeStatus {
  pending('pending'),
  active('active'),
  completed('completed'),
  expired('expired');

  const ChallengeStatus(this.dbValue);

  /// Value as persisted in the `friend_challenges.status` column.
  final String dbValue;

  static ChallengeStatus fromDb(String value) => values.firstWhere(
        (s) => s.dbValue == value,
        orElse: () => ChallengeStatus.pending,
      );

  /// A challenge that is currently winnable.
  bool get isActive => this == ChallengeStatus.active;

  /// Terminal states: no longer resolvable.
  bool get isFinished =>
      this == ChallengeStatus.completed || this == ChallengeStatus.expired;
}

/// Outcome of resolving a challenge: who won and the final scores.
/// Produced by the repository's `resolve` and consumed by the UI to decide
/// the win/loss messaging and bonus XP award.
class ChallengeResolution {
  final String winnerId;
  final bool challengerWon;
  final int challengerScore;
  final int opponentScore;

  const ChallengeResolution({
    required this.winnerId,
    required this.challengerWon,
    required this.challengerScore,
    required this.opponentScore,
  });
}