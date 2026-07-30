import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:profileforge/core/audio/sound_service.dart';
import 'package:profileforge/core/celebration/celebrate.dart';
import 'package:profileforge/core/theme/app_theme.dart';
import 'package:profileforge/core/widgets/poppy.dart';
import 'package:profileforge/core/widgets/premium_widgets.dart';
import 'package:profileforge/features/skins/application/skin_providers.dart';
import 'package:profileforge/features/skins/domain/skin_definitions.dart';
import 'package:profileforge/features/wallet/application/wallet_providers.dart';

class SkinsScreen extends ConsumerWidget {
  const SkinsScreen({super.key, required this.profileId});
  final String profileId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dark = isDark(context);
    final unlocked = ref.watch(unlockedSkinsProvider(profileId)).valueOrNull ?? [];
    final equipped = ref.watch(equippedSkinProvider(profileId)).valueOrNull;
    final gems = ref.watch(gemsProvider(profileId)).valueOrNull ?? 0;
    final unlockedIds = unlocked.map((s) => s.id).toSet();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Skins & Shop'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      bottomNavigationBar: appBottomNav(context, '/skins'),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Gem balance hero card
          GlassCard(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [
                        Palette.accentBlue,
                        Palette.accentViolet,
                      ],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Palette.accentViolet.withValues(alpha: 0.4),
                        blurRadius: 20,
                        spreadRadius: -4,
                      ),
                    ],
                  ),
                  child: const Center(
                    child: Text('💎', style: TextStyle(fontSize: 26)),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '$gems',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.w900,
                          color: Palette.textPrimary,
                          letterSpacing: -1,
                        ),
                      ),
                      Text(
                        'gems available · ${unlocked.length}/${kSkins.length} unlocked',
                        style: TextStyle(
                          fontSize: 13,
                          color: Palette.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ).animate().fadeIn().slideY(begin: 0.1),

          const SizedBox(height: 24),

          // Section header
          Text(
            'Collection',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: Palette.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Earn gems from missions & daily rewards',
            style: TextStyle(
              fontSize: 13,
              color: Palette.textSecondary,
            ),
          ),
          const SizedBox(height: 16),

          // Skin grid
          GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 0.72,
            ),
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: kSkins.length,
            itemBuilder: (context, index) {
              final skin = kSkins[index];
              final isUnlocked = unlockedIds.contains(skin.id);
              final isEquipped = equipped?.id == skin.id;
              final cost = kSkinGemCost[skin.id] ?? 0;
              final canAfford = gems >= cost;
              final rarity = rarityColor(skin.rarity.name);

              return _SkinCard(
                skin: skin,
                isUnlocked: isUnlocked,
                isEquipped: isEquipped,
                cost: cost,
                canAfford: canAfford,
                rarity: rarity,
                dark: dark,
                index: index,
                onEquip: () {
                  ref.read(equipSkinProvider((
                    profileId: profileId,
                    skinId: skin.id,
                  )));
                  SoundService.instance.tap();
                  HapticFeedback.lightImpact();
                },
                onClaim: () async {
                  await ref.read(purchaseSkinProvider((
                    profileId: profileId,
                    skinId: skin.id,
                  )));
                  SoundService.instance.unlock();
                  celebrate(context, message: 'Unlocked!');
                },
                onBuy: () async {
                  final ok = await ref.read(
                    purchaseSkinProvider((
                      profileId: profileId,
                      skinId: skin.id,
                    )).future,
                  );
                  if (ok) {
                    SoundService.instance.unlock();
                    HapticFeedback.mediumImpact();
                    celebrate(context, message: 'Bought! 💎');
                  }
                },
              );
            },
          ),

          const SizedBox(height: 24),

          // Bottom tip
          GlassCard(
            padding: const EdgeInsets.all(16),
            opacity: 0.05,
            child: Row(
              children: [
                Text('💡', style: TextStyle(fontSize: 20)),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Skins boost XP multiplier and show off your pillar progress to teammates.',
                    style: TextStyle(
                      fontSize: 13,
                      color: Palette.textSecondary,
                      height: 1.4,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

class _SkinCard extends StatelessWidget {
  final dynamic skin;
  final bool isUnlocked;
  final bool isEquipped;
  final int cost;
  final bool canAfford;
  final Color rarity;
  final bool dark;
  final int index;
  final VoidCallback onEquip;
  final VoidCallback onClaim;
  final VoidCallback onBuy;

  const _SkinCard({
    required this.skin,
    required this.isUnlocked,
    required this.isEquipped,
    required this.cost,
    required this.canAfford,
    required this.rarity,
    required this.dark,
    required this.index,
    required this.onEquip,
    required this.onClaim,
    required this.onBuy,
  });

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: const EdgeInsets.all(12),
      border: isEquipped
          ? Palette.accentViolet
          : rarity.withValues(alpha: 0.4),
      borderWidth: isEquipped ? 2 : 1,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Animated orb preview
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(skin.seedColor),
                  Color(skin.accentColor),
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: Color(skin.seedColor).withValues(alpha: 0.4),
                  blurRadius: 16,
                  spreadRadius: -2,
                ),
              ],
            ),
          ).animate(
            onPlay: (c) => c.repeat(reverse: true),
          ).scale(
            begin: const Offset(1, 1),
            end: const Offset(1.05, 1.05),
            duration: 2000.ms,
            curve: Curves.easeInOut,
          ),

          const SizedBox(height: 8),

          // Name
          Text(
            skin.name,
            style: TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: 13,
              color: Palette.textPrimary,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),

          const SizedBox(height: 2),

          // Rarity badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: rarity.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              skin.rarity.name.toUpperCase(),
              style: TextStyle(
                fontSize: 9,
                fontWeight: FontWeight.w800,
                color: rarity,
                letterSpacing: 0.5,
              ),
            ),
          ),

          const SizedBox(height: 2),

          // XP multiplier
          Text(
            '×${skin.xpMultiplier} XP',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: rarity,
            ),
          ),

          const Spacer(),

          // Action button
          if (isEquipped)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Palette.accentViolet, Palette.accentBlue],
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text(
                'Equipped',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                  fontSize: 11,
                ),
              ),
            )
          else if (isUnlocked)
            _ActionBtn(
              label: 'Equip',
              onTap: onEquip,
              dark: dark,
            )
          else if (cost == 0)
            _ActionBtn(
              label: 'Claim',
              onTap: onClaim,
              dark: dark,
              accent: true,
            )
          else
            _GemBtn(
              cost: cost,
              canAfford: canAfford,
              onTap: onBuy,
              dark: dark,
            ),
        ],
      ),
    ).animate().fadeIn(delay: (index * 60).ms).scale(
      begin: const Offset(0.9, 0.9),
      duration: 400.ms,
      curve: Curves.easeOutCubic,
    );
  }
}

class _ActionBtn extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  final bool dark;
  final bool accent;

  const _ActionBtn({
    required this.label,
    required this.onTap,
    required this.dark,
    this.accent = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: accent
              ? Palette.accentViolet.withValues(alpha: 0.2)
              Palette.surface1
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: accent
                ? Palette.accentViolet.withValues(alpha: 0.4)
                : Palette.border,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 11,
            color: accent ? Palette.accentViolet : Palette.textSecondary,
          ),
        ),
      ),
    );
  }
}

class _GemBtn extends StatelessWidget {
  final int cost;
  final bool canAfford;
  final VoidCallback onTap;
  final bool dark;

  const _GemBtn({
    required this.cost,
    required this.canAfford,
    required this.onTap,
    required this.dark,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: canAfford ? onTap : null,
      child: Opacity(
        opacity: canAfford ? 1 : 0.4,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Palette.accentViolet, Palette.accentBlue],
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('💎', style: TextStyle(fontSize: 11)),
              const SizedBox(width: 4),
              Text(
                '$cost',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
