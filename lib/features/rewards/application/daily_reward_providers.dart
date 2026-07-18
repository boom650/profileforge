import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:profileforge/core/data/app_database_provider.dart';
import 'package:profileforge/features/rewards/data/daily_reward_repository.dart';
import 'package:profileforge/features/wallet/application/wallet_providers.dart';

final dailyRewardRepositoryProvider =
    Provider<DailyRewardRepository>((ref) {
  return DailyRewardRepository(ref.watch(appDatabaseProvider));
});

/// Current wheel status for a profile.
final dailyRewardProvider =
    FutureProvider.family<({int day, bool canClaim, int lastDay}), String>(
        (ref, profileId) async {
  return ref.watch(dailyRewardRepositoryProvider).status(profileId);
});

/// Claim today's reward (awards gems via the wallet). Awaitable.
final claimDailyRewardProvider =
    FutureProvider.family<int, String>((ref, profileId) async {
  final gems = await ref.watch(dailyRewardRepositoryProvider).claim(profileId);
  ref.invalidate(dailyRewardProvider(profileId));
  ref.invalidate(gemsProvider(profileId));
  return gems;
});
