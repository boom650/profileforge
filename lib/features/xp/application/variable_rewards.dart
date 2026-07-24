import 'dart:math' as math;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:profileforge/features/xp/application/xp_providers.dart';
import 'package:profileforge/features/wallet/application/wallet_providers.dart';

/// ────────────────────────────────────────────────────────────────────────────
/// Variable‑ratio reward engine.
/// Based on psychological research (Skinner, 1957): random reinforcement
/// schedules produce the strongest habit formation and dopamine response.
/// Applies to XP drops, skin unlocks, gem bonuses, and streak protections.
/// ────────────────────────────────────────────────────────────────────────────

class VariableRewardEngine {
  final math.Random _rng;

  VariableRewardEngine([math.Random? rng]) : _rng = rng ?? math.Random();

  /// 1–3× XP bonus at random on completed sessions.
  int applyXpBonus(int baseXp) {
    final roll = _rng.nextDouble();
    if (roll < 0.05) return baseXp * 3;   // 5% → triple
    if (roll < 0.20) return baseXp * 2;   // 15% → double
    if (roll < 0.50) return (baseXp * 1.5).round(); // 30% → 1.5×
    return baseXp;                         // 50% → normal
  }

  /// Drop a gem bonus (0–3 extra gems).
  int bonusGems() {
    final roll = _rng.nextDouble();
    if (roll < 0.03) return 3;
    if (roll < 0.10) return 2;
    if (roll < 0.30) return 1;
    return 0;
  }

  /// Should the user get a random "lucky skin fragment"?
  bool get luckyFragmentDrop => _rng.nextDouble() < 0.08; // 8% chance

  /// Streak recovery luck — a chance to auto‑recover a broken streak.
  bool get streakRecoveryLuck => _rng.nextDouble() < 0.12; // 12% chance

  /// Variable delay before showing the reward animation (feels organic).
  Duration get rewardDelay => Duration(milliseconds: 300 + _rng.nextInt(700));
}

final variableRewardEngineProvider = Provider<VariableRewardEngine>((ref) {
  return VariableRewardEngine();
});

/// Notifier that applies variable rewards after a focus session.
final applyVariableRewardsProvider = FutureProvider.family<void, ApplyRewardsArgs>((ref, args) async {
  final engine = ref.read(variableRewardEngineProvider);
  final actualXp = engine.applyXpBonus(args.baseXp);
  final bonusGems = engine.bonusGems();

  // Log XP
  await ref.read(xpRepositoryProvider).add(args.profileId, actualXp, 'focus_session');

  // Log gems if any
  if (bonusGems > 0) {
    await ref.read(walletRepositoryProvider).add(args.profileId, bonusGems);
  }
});

class ApplyRewardsArgs {
  final String profileId;
  final int baseXp;
  const ApplyRewardsArgs({required this.profileId, required this.baseXp});
}
