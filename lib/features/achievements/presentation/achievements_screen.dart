import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:profileforge/core/theme/app_theme.dart';
import 'package:profileforge/core/widgets/premium_widgets.dart';
import 'package:profileforge/features/achievements/application/achievement_providers.dart';
import 'package:profileforge/features/achievements/domain/achievement_defs.dart';

/// ────────────────────────────────────────────────────────────────────────────
/// AchievementsScreen v2 — Premium dark achievements with glassmorphism grid.
/// Progress header → badge grid.
/// ────────────────────────────────────────────────────────────────────────────
class AchievementsScreen extends ConsumerWidget {
  final String profileId;
  const AchievementsScreen({super.key, required this.profileId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dark = isDark(context);
    final theme = Theme.of(context);
    final defsAsync = ref.watch(achievementDefsProvider);
    final unlockedAsync = ref.watch(unlockedAchievementIdsProvider(profileId));

    return Scaffold(
      backgroundColor: dark ? Palette.black : Palette.cream,
      body: SafeArea(
        child: defsAsync.when(
          data: (defs) => unlockedAsync.when(
            data: (unlocked) {
              final total = defs.length;
              final done = unlocked.length;
              final percent = total > 0 ? done / total : 0.0;

              return CustomScrollView(
                slivers: [
                  // ── Header ──
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                      child: Row(
                        children: [
                          Text(
                            'Achievements',
                            style: theme.textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const Spacer(),
                          GestureDetector(
                            onTap: () => context.pop(),
                            child: Container(
                              width: 36,
                              height: 36,
                              decoration: BoxDecoration(
                                color: dark ? Palette.surface2 : const Color(0xFFF4ECE1),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Icon(
                                Icons.arrow_back_ios_new,
                                size: 18,
                                color: dark ? Palette.textSecondary : Palette.textTertiary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ).animate().fadeIn(duration: 300.ms),
                  ),

                  const SliverToBoxAdapter(child: SizedBox(height: 20)),

                  // ── Progress header ──
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: GradientBanner(
                        gradient: Palette.gradientPrimary,
                        child: Column(
                          children: [
                            Text(
                              '$done / $total',
                              style: theme.textTheme.headlineLarge?.copyWith(
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Badges Collected',
                              style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.8),
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 14),
                            // Progress bar.
                            ClipRRect(
                              borderRadius: BorderRadius.circular(6),
                              child: LinearProgressIndicator(
                                value: percent,
                                minHeight: 8,
                                backgroundColor: Colors.white.withValues(alpha: 0.2),
                                valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '${(percent * 100).toInt()}% complete',
                              style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.7),
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ).animate().fadeIn(delay: 100.ms).slideY(begin: 0.05),
                    ),
                  ),

                  const SliverToBoxAdapter(child: SizedBox(height: 24)),

                  // ── Badge grid ──
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    sliver: SliverGrid(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        childAspectRatio: 0.85,
                        mainAxisSpacing: 10,
                        crossAxisSpacing: 10,
                      ),
                      delegate: SliverChildBuilderDelegate(
                        (context, i) {
                          final def = defs[i];
                          final isUnlocked = unlocked.contains(def.id);
                          return _BadgeCard(
                            def: def,
                            unlocked: isUnlocked,
                            index: i,
                          );
                        },
                        childCount: defs.length,
                      ),
                    ),
                  ),

                  const SliverToBoxAdapter(child: SizedBox(height: 40)),
                ],
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Center(child: Text('Error: $e')),
          ),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(child: Text('Error: $e')),
        ),
      ),
    );
  }
}

/// Badge card with glassmorphism.
class _BadgeCard extends StatelessWidget {
  final AchievementDef def;
  final bool unlocked;
  final int index;

  const _BadgeCard({
    required this.def,
    required this.unlocked,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    final dark = isDark(context);
    return GlassCard(
      padding: const EdgeInsets.all(10),
      border: unlocked ? Border.all(color: Palette.primary, width: 2) : null,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Icon.
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: unlocked
                  ? Palette.primary.withValues(alpha: 0.12)
                  : dark
                      ? Palette.surface3
                      : const Color(0xFFEDE3D6),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Center(
              child: Text(
                unlocked ? def.icon : '❓',
                style: TextStyle(
                  fontSize: 26,
                  color: unlocked ? null : (dark ? Palette.textTertiary : Palette.textTertiary),
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          // Name.
          Text(
            def.name,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: unlocked ? FontWeight.w700 : FontWeight.w500,
              fontSize: 12,
              color: unlocked
                  ? (dark ? Palette.textPrimary : Palette.textInverse)
                  : (dark ? Palette.textSecondary : Palette.textTertiary),
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          // Criteria (for locked badges).
          if (!unlocked) ...[
            const SizedBox(height: 2),
            Text(
              '${def.criteriaValue} ${def.criteriaType.replaceAll('_', ' ')}',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 10,
                color: dark ? Palette.textTertiary : Palette.textTertiary,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ],
      ),
    ).animate().scale(
          duration: 300.ms,
          delay: (50 * index).ms,
          begin: const Offset(0.85, 0.85),
          end: const Offset(1, 1),
        );
  }
}
