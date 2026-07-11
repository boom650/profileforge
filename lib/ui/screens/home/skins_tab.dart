import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/app_theme.dart';
import '../../../models/gamification/skins.dart';
import '../../../providers/providers.dart';

/// Skins tab — gallery of unlockable visual identities.
class SkinsTab extends ConsumerWidget {
  const SkinsTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final skins = SkinCatalog.getOrderedTiers();
    final totalXP = ref.watch(totalXPProvider);
    final currentSkin = ref.watch(currentSkinProvider);
    final unlockedSkins = ref.watch(unlockedSkinsProvider);
    final unlockedTiers = unlockedSkins.map((s) => s.tier).toSet();

    return Scaffold(
      appBar: AppBar(
        title: Text('Skins Gallery',
            style: GoogleFonts.inter(fontWeight: FontWeight.w600)),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 12, top: 8, bottom: 8),
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: Theme.of(context)
                  .colorScheme
                  .secondary
                  .withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.stars_rounded,
                    size: 16, color: Theme.of(context).colorScheme.secondary),
                const SizedBox(width: 4),
                Text(
                  '$totalXP XP',
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: skins.isEmpty
          ? _EmptySkinsState()
          : Column(
              children: [
                // Current skin banner
                Container(
                  margin: const EdgeInsets.fromLTRB(20, 16, 20, 8),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: context.isDarkMode
                        ? AppTheme.gradientPrimaryDark
                        : AppTheme.gradientPrimary,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 52,
                        height: 52,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Icon(
                          _getIconForSkinTier(currentSkin.tier),
                          color: Colors.white,
                          size: 28,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Current Identity',
                              style: GoogleFonts.inter(
                                fontSize: 11,
                                color: Colors.white.withValues(alpha: 0.7),
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              currentSkin.displayName,
                              style: GoogleFonts.inter(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          '${unlockedSkins.length}/9',
                          style: GoogleFonts.inter(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // Grid of skins
                Expanded(
                  child: GridView.builder(
                    padding: const EdgeInsets.all(16),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.75,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                    ),
                    itemCount: skins.length,
                    itemBuilder: (context, index) {
                      final tier = skins[index];
                      final config = SkinCatalog.getConfig(tier);
                      final isUnlocked = unlockedTiers.contains(tier);
                      final isEquipped = currentSkin.tier == tier;
                      return _SkinGridCard(
                        config: config,
                        isUnlocked: isUnlocked,
                        isEquipped: isEquipped,
                        currentXP: totalXP,
                        onEquip: isUnlocked && !isEquipped
                            ? () async {
                                HapticFeedback.mediumImpact();
                                await ref.read(equipSkinProvider)(tier);
                                if (context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                          '${config.displayName} equipped! 🎨'),
                                      backgroundColor: AppTheme.successGreen,
                                      behavior: SnackBarBehavior.floating,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                    ),
                                  );
                                }
                              }
                            : null,
                      );
                    },
                  ),
                ),
              ],\n            ),\n          );\n        }\n\n  IconData _getIconForSkinTier(SkinTier tier) {
    switch (tier) {
      case SkinTier.explorer:
        return Icons.explore_rounded;
      case SkinTier.scholar:
        return Icons.school_rounded;
      case SkinTier.evidenceKeeper:
        return Icons.verified_rounded;
      case SkinTier.marathonRunner:
        return Icons.directions_run_rounded;
      case SkinTier.researcher:
        return Icons.science_rounded;
      case SkinTier.leader:
        return Icons.people_rounded;
      case SkinTier.creator:
        return Icons.palette_rounded;
      case SkinTier.changemaker:
        return Icons.volunteer_activism_rounded;
      case SkinTier.trailblazer:
        return Icons.star_rounded;
    }
  }
}

/// Empty state when no skins available.
class _EmptySkinsState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.emoji_events_outlined,
                size: 56,
                color: Theme.of(context).colorScheme.secondary.withValues(alpha: 0.3)),
            const SizedBox(height: 16),
            Text('No skins available',
                style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Theme.of(context).colorScheme.outline)),
            const SizedBox(height: 8),
            Text(
                'Complete missions and earn XP to unlock new skins.',
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                    fontSize: 13, color: Theme.of(context).colorScheme.outline)),
          ],
        ),
      ),
    );
  }
}

/// Grid card for a single skin in the gallery.
class _SkinGridCard extends StatelessWidget {
  final SkinConfig config;
  final bool isUnlocked;
  final bool isEquipped;
  final int currentXP;
  final VoidCallback? onEquip;

  const _SkinGridCard({
    required this.config,
    required this.isUnlocked,
    required this.isEquipped,
    required this.currentXP,
    this.onEquip,
  });

  @override
  Widget build(BuildContext context) {
    final primaryColor = config.visualProperties['primaryColor'] != null
        ? Color(config.visualProperties['primaryColor'] as int)
        : Theme.of(context).colorScheme.primary;
    final progress = config.xpRequired > 0
        ? (currentXP / config.xpRequired).clamp(0.0, 1.0)
        : 1.0;

    return Container(
      decoration: BoxDecoration(
        color: context.surfaceElevated,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isEquipped
              ? primaryColor
              : isUnlocked
                  ? primaryColor.withValues(alpha: 0.3)
                  : context.borderColor,
          width: isEquipped ? 2 : 1,
        ),
        boxShadow: isEquipped
            ? [
                BoxShadow(
                  color: primaryColor.withValues(alpha: 0.2),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ]
            : null,
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Skin icon
            Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: isUnlocked
                        ? primaryColor.withValues(alpha: 0.12)
                        : Theme.of(context)
                            .colorScheme
                            .outline
                            .withValues(alpha: 0.08),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    _getIconForTier(config.tier),
                    color: isUnlocked ? primaryColor : context.textMuted,
                    size: 28,
                  ),
                ),
                if (isEquipped)
                  Positioned(
                    right: -2,
                    top: -2,
                    child: Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        color: AppTheme.successGreen,
                        shape: BoxShape.circle,
                        border: Border.all(
                            color: context.surfaceElevated, width: 2),
                      ),
                      child: const Icon(Icons.check,
                          color: Colors.white, size: 12),
                    ),
                  ),
                if (!isUnlocked)
                  Positioned(
                    child: Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        color: context.textMuted.withValues(alpha: 0.6),
                        shape: BoxShape.circle,
                      ),
                      child:
                          const Icon(Icons.lock, color: Colors.white, size: 14),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            // Name
            Text(
              config.displayName,
              style: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: isUnlocked ? context.textPrimary : context.textMuted,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 2),
            // Rarity badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: _getRarityColor(config.rarity, context)
                    .withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                config.rarity.toString().split('.').last.toUpperCase(),
                style: GoogleFonts.inter(
                  fontSize: 8,
                  fontWeight: FontWeight.w700,
                  color: _getRarityColor(config.rarity, context),
                ),
              ),
            ),
            const SizedBox(height: 6),
            // Progress toward unlock
            if (!isUnlocked) ...[
              ClipRRect(
                borderRadius: BorderRadius.circular(3),
                child: LinearProgressIndicator(
                  value: progress,
                  minHeight: 4,
                  backgroundColor: Theme.of(context)
                      .colorScheme
                      .primary
                      .withValues(alpha: 0.08),
                  valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
                ),
              ),
              const SizedBox(height: 3),
              Text(
                '$currentXP / ${config.xpRequired} XP',
                style: GoogleFonts.inter(fontSize: 9, color: context.textMuted),
              ),
            ],
            // Equip button
            if (isUnlocked && !isEquipped && onEquip != null) ...[
              const SizedBox(height: 4),
              SizedBox(
                width: double.infinity,
                height: 30,
                child: FilledButton(
                  onPressed: onEquip,
                  style: FilledButton.styleFrom(
                    backgroundColor: primaryColor,
                    padding: EdgeInsets.zero,
                  ),
                  child: Text(
                    'Equip',
                    style: GoogleFonts.inter(
                        fontSize: 11, fontWeight: FontWeight.w700),
                  ),
                ),
              ),
            ],
            if (isEquipped) ...[
              const SizedBox(height: 4),
              Container(
                width: double.infinity,
                height: 30,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AppTheme.successGreen.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'Equipped ✓',
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.successGreen,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  IconData _getIconForTier(SkinTier tier) {
    switch (tier) {
      case SkinTier.explorer:
        return Icons.explore_rounded;
      case SkinTier.scholar:
        return Icons.school_rounded;
      case SkinTier.evidenceKeeper:
        return Icons.verified_rounded;
      case SkinTier.marathonRunner:
        return Icons.directions_run_rounded;
      case SkinTier.researcher:
        return Icons.science_rounded;
      case SkinTier.leader:
        return Icons.people_rounded;
      case SkinTier.creator:
        return Icons.palette_rounded;
      case SkinTier.changemaker:
        return Icons.volunteer_activism_rounded;
      case SkinTier.trailblazer:
        return Icons.star_rounded;
    }
  }

  Color _getRarityColor(SkinRarity rarity, BuildContext context) {
    switch (rarity) {
      case SkinRarity.common:
        return context.textMuted;
      case SkinRarity.uncommon:
        return Theme.of(context).colorScheme.primary;
      case SkinRarity.rare:
        return const Color(0xFF8B5CF6);
      case SkinRarity.legendary:
        return Theme.of(context).colorScheme.secondary;
    }
  }
}