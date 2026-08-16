import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:profileforge/core/data/app_database_provider.dart';
import 'package:profileforge/features/rewards/data/daily_reward_repository.dart';
import 'package:profileforge/features/rewards/domain/daily_reward_models.dart';
import 'package:profileforge/features/wallet/application/wallet_providers.dart';

final dailyRewardRepositoryProvider =
    Provider<DailyRewardRepository>((ref) {
  return DailyRewardRepository(ref.watch(appDatabaseProvider));
});

/// Current wheel status for a profile.
final dailyRewardProvider =
    FutureProvider.family<DailyRewardStatus, String>(
        (ref, profileId) async {
  return ref.watch(dailyRewardRepositoryProvider).status(profileId);
});

/// Claim today's reward (awards gems via the wallet). Awaitable.
final claimDailyRewardProvider =
    FutureProvider.family<int, String>((ref, profileId) async {
  final repo = ref.watch(dailyRewardRepositoryProvider);
  final gems = await repo.claim(profileId);
  // Award gems to the wallet
  if (gems > 0) {
    await ref.watch(walletRepositoryProvider).add(profileId, gems);
  }
  ref.invalidate(dailyRewardProvider(profileId));
  ref.invalidate(gemsProvider(profileId));
  return gems;
});
