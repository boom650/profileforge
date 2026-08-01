import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';
import 'package:profileforge/core/theme/app_theme.dart';
import 'package:profileforge/core/widgets/premium_widgets.dart';
import 'package:profileforge/core/widgets/achievement_unlock.dart';
import 'package:profileforge/features/achievements/application/achievement_providers.dart';
import 'package:profileforge/features/achievements/domain/achievement_defs.dart';

/// ────────────────────────────────────────────────────────────────────────────
/// AchievementsScreen v2 — Premium dark achievements with glassmorphism grid.
/// Staggered entrance, golden glow, lock overlay, progress header.
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
      backgroundColor: dark ? Palette.black : const Color(0xFFF8FAFC),
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
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const Spacer(),
                          GestureDetector(
                            onTap: () => context.pop(),
                            child: Container(
                              width: 36,
                              height: 36,
                              decoration: BoxDecoration(
                                color: dark ? Palette.surface2 : const Color(0xFFF1F5F9),
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
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  '$done',
                                  style: theme.textTheme.headlineLarge?.copyWith(
                                    fontWeight: FontWeight.w800,
                                    color: Colors.white,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 6),
                                  child: Text(
                                    'of',
                                    style: TextStyle(
                                      color: Colors.white.withValues(alpha: 0.7),
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                                Text(
                                  '$total',
                                  style: theme.textTheme.headlineLarge?.copyWith(
                                    fontWeight: FontWeight.w800,
                                    color: Colors.white.withValues(alpha: 0.7),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Badges Unlocked',
                              style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.8),
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 14),
                            // Progress bar.
                            ClipRRect(
                              borderRadius: BorderRadius.circular(6),
                              child: Stack(
                                children: [
                                  // Track
                                  LinearProgressIndicator(
                                    value: 1.0,
                                    minHeight: 8,
                                    backgroundColor: Colors.white.withValues(alpha: 0.2),
                                    valueColor: const AlwaysStoppedAnimation<Color>(Colors.transparent),
                                  ),
                                  // Filled portion
                                  FractionallySizedBox(
                                    widthFactor: percent.clamp(0.0, 1.0),
                                    child: Container(
                                      height: 8,
                                      decoration: const BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [Colors.white, Color(0xFFE0F2FE)],
                                        ),
                                        borderRadius: BorderRadius.only(
                                          topRight: Radius.circular(6),
                                          bottomRight: Radius.circular(6),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )
                                .animate()
                                .shimmer(
                                  duration: 2000.ms,
                                  color: Colors.white.withValues(alpha: 0.15),
                                  delay: 600.ms,
                                  interval: const Duration(milliseconds: 3000),
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
                          ).animate(
                            delay: Duration(milliseconds: i * 50),
                            duration: 400.ms,
                          ).fadeIn(
                            curve: Curves.easeOutCubic,
                          ).scale(
                            begin: const Offset(0.8, 0.8),
                            end: const Offset(1, 1),
                            curve: Curves.easeOutCubic,
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
            loading: () => const Center(
              child: _AchievementsSkeleton(),
            ),
            error: (e, _) => Center(child: Text('Error: $e')),
          ),
          loading: () => const Center(
            child: _AchievementsSkeleton(),
          ),
          error: (e, _) => Center(child: Text('Error: $e')),
        ),
      ),
    );
  }
}

/// Badge card with glassmorphism, golden glow for unlocked, lock overlay for locked,
/// and a tap bounce micro-interaction.
class _BadgeCard extends StatefulWidget {
  final AchievementDef def;
  final bool unlocked;
  final int index;

  const _BadgeCard({
    required this.def,
    required this.unlocked,
    required this.index,
  });

  @override
  State<_BadgeCard> createState() => _BadgeCardState();
}

class _BadgeCardState extends State<_BadgeCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _bounceController;
  late final Animation<double> _bounceAnim;

  @override
  void initState() {
    super.initState();
    _bounceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
    _bounceAnim = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.15), weight: 40),
      TweenSequenceItem(tween: Tween(begin: 1.15, end: 0.95), weight: 30),
      TweenSequenceItem(tween: Tween(begin: 0.95, end: 1.0), weight: 30),
    ]).animate(CurvedAnimation(
      parent: _bounceController,
      curve: Curves.easeOut,
    ));
  }

  @override
  void dispose() {
    _bounceController.dispose();
    super.dispose();
  }

  void _onTap() {
    _bounceController.forward(from: 0);
    // Show achievement unlock animation for unlocked badges.
    if (widget.unlocked) {
      AchievementUnlock.show(
        context,
        emoji: widget.def.icon,
        title: widget.def.name,
        description: widget.def.description ?? 'Achievement unlocked!',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final dark = isDark(context);

    Widget card = GlassCard(
      padding: const EdgeInsets.all(10),
      border: widget.unlocked
          ? Border.all(color: Palette.warning, width: 2)
          : null,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Icon.
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: widget.unlocked
                      ? Palette.warning.withValues(alpha: 0.12)
                      : dark
                          ? Palette.surface3
                          : const Color(0xFFE2E8F0),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Center(
                  child: Text(
                    widget.unlocked ? widget.def.icon : '❓',
                    style: TextStyle(
                      fontSize: 26,
                      color: dark ? Palette.textTertiary : Palette.textTertiary,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              // Name.
              Text(
                widget.def.name,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: widget.unlocked ? FontWeight.w700 : FontWeight.w500,
                  fontSize: 12,
                  color: widget.unlocked
                      ? (dark ? Palette.textPrimary : Palette.textInverse)
                      : (dark ? Palette.textSecondary : Palette.textTertiary),
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              // Criteria (for locked badges).
              if (!widget.unlocked) ...[
                const SizedBox(height: 2),
                Text(
                  '${widget.def.criteriaValue} ${widget.def.criteriaType.replaceAll('_', ' ')}',
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

          // Lock overlay for locked badges.
          if (!widget.unlocked)
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: (dark ? Palette.black : Colors.white).withValues(alpha: 0.15),
                ),
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: dark ? Palette.surface2 : Palette.surface1,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.lock_rounded,
                      size: 14,
                      color: dark ? Palette.textTertiary : Palette.textTertiary,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );

    // Apply golden glow animation for unlocked badges.
    if (widget.unlocked) {
      card = Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Palette.warning.withValues(alpha: 0.25),
              blurRadius: 12,
              spreadRadius: 1,
            ),
            BoxShadow(
              color: Palette.warning.withValues(alpha: 0.10),
              blurRadius: 24,
              spreadRadius: 2,
            ),
          ],
        ),
        child: card,
      );
    }

    // Apply dimmed opacity for locked badges.
    if (!widget.unlocked) {
      card = Opacity(
        opacity: 0.4,
        child: card,
      );
    }

    // Tap bounce animation.
    return ScaleTransition(
      scale: _bounceAnim,
      child: GestureDetector(
        onTap: _onTap,
        child: card,
      ),
    );
  }
}

/// ────────────────────────────────────────────────────────────────────────────
/// _AchievementsSkeleton — Shimmer loading for achievements grid.
/// ────────────────────────────────────────────────────────────────────────────
class _AchievementsSkeleton extends StatelessWidget {
  const _AchievementsSkeleton();

  @override
  Widget build(BuildContext context) {
    return ShimmerSkeleton(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Progress bar skeleton
            Container(
              height: 100,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            const SizedBox(height: 24),
            // Grid skeleton
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 0.85,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
              ),
              itemCount: 9,
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
