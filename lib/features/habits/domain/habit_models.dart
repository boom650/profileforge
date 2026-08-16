/// XP debt concept — penalties incurred by broken streaks / early timer stops.
///
/// A debt is owed XP that must be earned back; unpaid debts are watched by
/// the UI so the user always sees the outstanding amount.
class HabitDebt {
  final int id;
  final String profileId;
  final int amount;
  final String reason;
  final DateTime createdAt;
  final bool isPaid;

  const HabitDebt({
    required this.id,
    required this.profileId,
    required this.amount,
    required this.reason,
    required this.createdAt,
    required this.isPaid,
  });

  /// Outstanding (unpaid) debts only.
  bool get isOutstanding => !isPaid;
}