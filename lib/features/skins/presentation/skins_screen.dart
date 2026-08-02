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
    final unlockedAsync = ref.watch(unlockedSkinsProvider(profileId));
    final equippedAsync = ref.watch(equippedSkinProvider(profileId));
    final gemsAsync = ref.watch(gemsProvider(profileId));

    // Check if any critical provider is still loading
    final isLoading = unlockedAsync is AsyncLoading || equippedAsync is AsyncLoading;
    final hasError = unlockedAsync is AsyncError || equippedAsync is AsyncError || gemsAsync is AsyncError;

    return Scaffold(
      backgroundColor: dark ? Palette.black : const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: dark ? Palette.surface1 : Colors.white,
        title: const Text('Skins & Shop'),
        centerTitle: true,
        elevation: 0,
      ),
      bottomNavigationBar: appBottomNav(context, '/skins'),
      body: SafeArea(
          child: isLoading
          ? const _SkinsSkeleton()
          : hasError
              ? _SkinsError(
                  onRetry: () {
                    ref.invalidate(unlockedSkinsProvider(profileId));
                    ref.invalidate(equippedSkinProvider(profileId));
                    ref.invalidate(gemsProvider(profileId));
                  },
                )
              : _SkinsContent(
                  profileId: profileId,
                  dark: dark,
                  unlocked: unlockedAsync.valueOrNull ?? [],
                  equipped: equippedAsync.valueOrNull,
                  gems: gemsAsync.valueOrNull ?? 0,
                ),
    );
  }
}

/// The actual content of the skins screen once data is loaded.
class _SkinsContent extends StatelessWidget {
  final String profileId;
  final bool dark;
  final List<Skin> unlocked;
  final Skin? equipped;
  final int gems;

  const _SkinsContent({
    required this.profileId,
    required this.dark,
    required this.unlocked,
    required this.equipped,
    required this.gems,
  });

  @override
  Widget build(BuildContext context) {
    final unlockedIds = unlocked.map((s) => s.id).toSet();

    return ListView(
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
                  gradient: const LinearGradient(
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
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w900,
                        color: Palette.textPrimary,
                        letterSpacing: -1,
                      ),
                    ),
                    Text(
                      'gems available · ${unlocked.length}/${kSkins.length} unlocked',
                      style: const TextStyle(
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
        const Text(
          'Collection',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w800,
            color: Palette.textPrimary,
          ),
        ),
        const SizedBox(height: 4),
        const Text(
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
              const Text('💡', style: TextStyle(fontSize: 20)),
              const SizedBox(width: 12),
              const Expanded(
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
    );
  }
}

/// Shimmer loading skeleton for skins screen.
class _SkinsSkeleton extends StatelessWidget {
  const _SkinsSkeleton();

  @override
  Widget build(BuildContext context) {
    return ShimmerSkeleton(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hero card skeleton
            Container(
              height: 96,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            const SizedBox(height: 24),
            // Section header skeleton
            Container(
              width: 120,
              height: 20,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            const SizedBox(height: 16),
            // Grid skeleton
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 0.72,
              ),
              itemCount: 6,
              itemBuilder: (_, __) => Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Error state with retry button for skins screen.
class _SkinsError extends StatelessWidget {
  final VoidCallback onRetry;

  const _SkinsError({required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: Palette.error.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.error_outline_rounded, size: 32, color: Palette.error),
            ).animate().scale(delay: 100.ms, duration: 400.ms, curve: Curves.elasticOut),
            const SizedBox(height: 20),
            const Text(
              'Failed to load shop',
              style: TextStyle(
                color: Palette.textPrimary,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Something went wrong loading your collection',
              style: TextStyle(color: Palette.textSecondary, fontSize: 13),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh, size: 18),
              label: const Text('Retry'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Palette.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ],
        ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.1),
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
      border: Border.all(
        color: isEquipped ? Palette.accentViolet : rarity.withValues(alpha: 0.4),
        width: isEquipped ? 2 : 1,
      ),
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
            style: const TextStyle(
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
                gradient: const LinearGradient(
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
              : Palette.surface1,
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
            gradient: const LinearGradient(
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
      ),
    );
  }
}
