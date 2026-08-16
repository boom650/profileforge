/// Wallet domain models — the soft-currency (gems) ledger.
///
/// [GemWallet] is a profile's current balance, [GemTransaction] records a
/// single mutation applied to it (earn or spend).
class GemWallet {
  final String profileId;
  final int gems;

  const GemWallet({required this.profileId, required this.gems});
}

/// One applied ledger mutation: [amount] is positive for earnings and
/// negative for spend; [balanceAfter] is the clamped resulting balance.
class GemTransaction {
  final int amount;
  final int balanceAfter;
  final DateTime at;

  const GemTransaction({
    required this.amount,
    required this.balanceAfter,
    required this.at,
  });
}
