import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:profileforge/core/data/app_database_provider.dart';
import 'package:profileforge/features/skins/data/skin_repository.dart';
import 'package:profileforge/features/skins/domain/skin_definitions.dart';
import 'package:profileforge/features/wallet/application/wallet_providers.dart';
import 'package:profileforge/features/xp/application/xp_providers.dart';

final skinRepositoryProvider = Provider<SkinRepository>((ref) {
  return SkinRepository(ref.watch(appDatabaseProvider));
});

/// Computes the set of unlocked skin ids for a profile based on total XP.
final unlockedSkinsProvider = FutureProvider.family<List<Skin>, String>((ref, profileId) async {
  final repo = ref.watch(skinRepositoryProvider);
  final totalXp = await ref.watch(totalXpProvider(profileId).future);
  final unlocked = <Skin>[];
  for (final skin in kSkins) {
    if (skin.isUnlockedAt(totalXp)) {
      unlocked.add(skin);
      await repo.unlock(profileId, skin.id);
    }
  }
  return unlocked;
});

/// The currently equipped skin, resolved from persistence (defaults to 'scholar').
final equippedSkinProvider = FutureProvider.family<Skin, String>((ref, profileId) async {
  final repo = ref.watch(skinRepositoryProvider);
  final id = await repo.equippedId(profileId) ?? 'scholar';
  return skinById(id);
});

/// Equip a skin (UI action).
final equipSkinProvider =
    Provider.family<void, ({String profileId, String skinId})>((ref, args) {
  ref.watch(skinRepositoryProvider).equip(args.profileId, args.skinId);
  ref.invalidate(equippedSkinProvider(args.profileId));
});

/// Buy a skin with gems (unlocks it regardless of XP). Returns true if bought.
final purchaseSkinProvider =
    FutureProvider.family<bool, ({String profileId, String skinId})>((ref, args) async {
  final cost = kSkinGemCost[args.skinId] ?? 0;
  if (cost <= 0) {
    ref.read(skinRepositoryProvider).unlock(args.profileId, args.skinId);
    ref.invalidate(unlockedSkinsProvider(args.profileId));
    return true;
  }
  final ok = await ref
      .watch(spendGemsProvider((profileId: args.profileId, cost: cost)))
      .future;
  if (ok) {
    ref.read(skinRepositoryProvider).unlock(args.profileId, args.skinId);
    ref.invalidate(unlockedSkinsProvider(args.profileId));
  }
  return ok;
});
