import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:profileforge/core/data/app_database_provider.dart';
import 'package:profileforge/features/wallet/data/wallet_repository.dart';
import 'package:profileforge/features/wallet/domain/wallet_models.dart';

final walletRepositoryProvider = Provider<WalletRepository>((ref) {
  return WalletRepository(ref.watch(appDatabaseProvider));
});

/// Current gem balance.
final gemsProvider =
    FutureProvider.family<int, String>((ref, profileId) async {
  return ref.watch(walletRepositoryProvider).get(profileId);
});

/// Current wallet as a domain [GemWallet] (balance + profile id).
final walletProvider = FutureProvider.family<GemWallet, String>((ref, profileId) {
  return ref.watch(walletRepositoryProvider).loadWallet(profileId);
});

/// Gems genuinely spent in the shop (from real owned-skin data).
final gemsSpentOnSkinsProvider =
    FutureProvider.family<int, String>((ref, profileId) async {
  return ref.watch(walletRepositoryProvider).gemsSpentOnSkins(profileId);
});

/// Add gems (called when missions/streaks award currency). Awaitable.
final addGemsProvider =
    FutureProvider.family<void, ({String profileId, int amount})>((ref, args) async {
  await ref.watch(walletRepositoryProvider).add(args.profileId, args.amount);
  ref.invalidate(gemsProvider(args.profileId));
  ref.invalidate(walletProvider(args.profileId));
});

/// Attempt to spend gems; returns success (awaitable).
final spendGemsProvider =
    FutureProvider.family<bool, ({String profileId, int cost})>((ref, args) async {
  final ok = await ref.watch(walletRepositoryProvider).spend(args.profileId, args.cost);
  ref.invalidate(gemsProvider(args.profileId));
  ref.invalidate(walletProvider(args.profileId));
  return ok;
});
