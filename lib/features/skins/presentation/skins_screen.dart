import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:profileforge/core/audio/sound_service.dart';
import 'package:profileforge/core/celebration/celebrate.dart';
import 'package:profileforge/core/theme/app_theme.dart';
import 'package:profileforge/core/widgets/poppy.dart';
import 'package:profileforge/features/skins/application/skin_providers.dart';
import 'package:profileforge/features/skins/domain/skin_definitions.dart';
import 'package:profileforge/features/wallet/application/wallet_providers.dart';
import 'package:profileforge/features/xp/application/xp_providers.dart';

class SkinsScreen extends ConsumerWidget {
  const SkinsScreen({super.key, required this.profileId});
  final String profileId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final totalXp = ref.watch(totalXpProvider(profileId)).valueOrNull ?? 0;
    final unlocked = ref.watch(unlockedSkinsProvider(profileId)).valueOrNull ?? [];
    final equipped = ref.watch(equippedSkinProvider(profileId)).valueOrNull;
    final gems = ref.watch(gemsProvider(profileId)).valueOrNull ?? 0;
    final unlockedIds = unlocked.map((s) => s.id).toSet();

    return Scaffold(
      appBar: AppBar(title: const Text('Skins & Shop')),
      bottomNavigationBar: appBottomNav(context, '/skins'),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          GradientBanner(
            from: Palette.green,
            to: Palette.yellow,
            child: Row(
              children: [
                const Text('💎', style: TextStyle(fontSize: 30)),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Your collection',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w900)),
                      Text('$gems gems • ${unlocked.length}/${kSkins.length} unlocked',
                          style: const TextStyle(
                              color: Colors.white, fontSize: 13)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          SectionTitle('Skins'),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 0.78,
            children: kSkins.map((skin) {
              final isUnlocked = unlockedIds.contains(skin.id);
              final isEquipped = equipped?.id == skin.id;
              final cost = kSkinGemCost[skin.id] ?? 0;
              final canAfford = gems >= cost;
              return Container(
                decoration: BoxDecoration(
                  color: theme.cardColor,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: isEquipped ? Palette.green : rarityColor(skin.rarity.name),
                    width: isEquipped ? 3 : 1.5,
                  ),
                ),
                padding: const EdgeInsets.all(12),
                child: Column(
                  children: [
                    // Preview orb.
                    Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(colors: [
                          Color(skin.seedColor),
                          Color(skin.accentColor),
                        ]),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(skin.name,
                        style: const TextStyle(fontWeight: FontWeight.w900)),
                    RarityBadge(skin.rarity.name),
                    const SizedBox(height: 4),
                    Text('×${skin.xpMultiplier} XP',
                        style: TextStyle(
                            color: rarityColor(skin.rarity.name),
                            fontWeight: FontWeight.w800,
                            fontSize: 12)),
                    const Spacer(),
                    if (isEquipped)
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: Palette.green,
                          borderRadius: BorderRadius.circular(10)),
                        child: const Text('Equipped',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w900,
                                fontSize: 12)),
                      )
                    else if (isUnlocked)
                      OutlinedButton(
                        onPressed: () {
                          ref.read(equipSkinProvider((
                            profileId: profileId,
                            skinId: skin.id,
                          )));
                          SoundService.instance.tap();
                        },
                        child: const Text('Equip'),
                      )
                    else if (cost == 0)
                      OutlinedButton(
                        onPressed: () async {
                          await ref.read(purchaseSkinProvider((
                            profileId: profileId,
                            skinId: skin.id,
                          )));
                          SoundService.instance.unlock();
                          celebrate(context, message: 'Unlocked!');
                        },
                        child: const Text('Claim'),
                      )
                    else
                      FilledButton.icon(
                        onPressed: canAfford
                            ? () async {
                                final ok = await ref
                                    .read(purchaseSkinProvider((
                                  profileId: profileId,
                                  skinId: skin.id,
                                )).future);
                                if (ok) {
                                  SoundService.instance.unlock();
                                  celebrate(context, message: 'Bought! 💎');
                                }
                              }
                            : null,
                        icon: const Icon(Icons.diamond, size: 14),
                        label: Text('$cost'),
                      ),
                  ],
                ),
              ).animate().fadeIn().scale(begin: const Offset(0.9, 0.9));
            }).toList(),
          ),
          const SizedBox(height: 16),
          Text('Earn gems from missions & daily rewards. Skins boost XP and show off your pillars.',
              style: theme.textTheme.bodySmall),
        ],
      ),
    );
  }
}
