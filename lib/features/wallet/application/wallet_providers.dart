import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:profileforge/core/data/app_database_provider.dart';
import 'package:profileforge/features/wallet/data/wallet_repository.dart';

final walletRepositoryProvider = Provider<WalletRepository>((ref) {
  return WalletRepository(ref.watch(appDatabaseProvider));
});

/// Current gem balance.
final gemsProvider =
    FutureProvider.family<int, String>((ref, profileId) async {
  return ref.watch(walletRepositoryProvider).get(profileId);
});

/// Add gems (called when missions/streaks award currency).
final addGemsProvider =
    Provider.family<void, ({String profileId, int amount})>((ref, args) {
  ref.watch(walletRepositoryProvider).add(args.profileId, args.amount);
  ref.invalidate(gemsProvider(args.profileId));
});

/// Attempt to spend gems; returns success (awaitable).
final spendGemsProvider =
    FutureProvider.family<bool, ({String profileId, int cost})>((ref, args) async {
  final ok = await ref.watch(walletRepositoryProvider).spend(args.profileId, args.cost);
  ref.invalidate(gemsProvider(args.profileId));
  return ok;
});
