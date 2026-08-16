import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:profileforge/core/audio/sound_service.dart';
import 'package:profileforge/core/celebration/celebrate.dart';
import 'package:profileforge/core/theme/app_theme.dart';
import 'package:profileforge/core/widgets/premium_widgets.dart';
import 'package:profileforge/core/widgets/motion_kit.dart';
import 'package:profileforge/features/missions/application/mission_providers.dart';
import 'package:profileforge/features/streak/presentation/streak_celebration.dart';
import 'package:profileforge/features/onboarding/application/onboarding_providers.dart';

/// ────────────────────────────────────────────────────────────────────────────
/// MissionsScreen v2 — Premium dark missions with glassmorphism cards.
/// Hero banner → daily missions → weekly missions.
/// ────────────────────────────────────────────────────────────────────────────
class MissionsScreen extends ConsumerWidget {
  const MissionsScreen({super.key, required this.profileId});
  final String profileId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final dark = isDark(context);
    final daily = ref.watch(todaysMissionsProvider(profileId));
    final weekly = ref.watch(weeklyMissionsProvider(profileId));
    final monthly = ref.watch(monthlyMissionsProvider(profileId));
    final priority = ref.watch(specialMissionsProvider(profileId));

    return Scaffold(
      backgroundColor: dark ? Palette.black : Palette.cream,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // ── Header ──
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                child: Row(
                  children: [
                    Text(
                      'Missions',
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const Spacer(),
                    // Refresh button.
                    GestureDetector(
                      onTap: () async {
                        final ob =
                            ref.read(onboardingProvider(profileId)).valueOrNull;
                        if (ob == null) {
                          context.push('/onboarding');
                          return;
                        }
                        SoundService.instance.success();
                        await ref
                            .read(generateMissionsProvider(profileId).notifier)
                            .forceRegenerate();
                        ref.invalidate(todaysMissionsProvider(profileId));
                        ref.invalidate(weeklyMissionsProvider(profileId));
                        ref.invalidate(monthlyMissionsProvider(profileId));
                        if (context.mounted) {
                          celebrate(context, message: 'Refreshed!');
                        }
                      },
                      child: Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color:
                              dark ? Palette.surface2 : const Color(0xFFF4ECE1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          Icons.refresh,
                          size: 20,
                          color: dark
                              ? Palette.textSecondary
                              : Palette.textTertiary,
                        ),
                      ),
                    ),
                  ],
                ),
              ).animate().fadeIn(duration: 300.ms),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 20)),

            // ── Hero banner ──
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: GradientBanner(
                  gradient: Palette.gradientPrimary,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Missions Hub',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Daily, weekly & monthly challenges.\nEarn XP, gems, and level up your profile.',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.85),
                          fontSize: 14,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ).animate().fadeIn(delay: 100.ms).slideY(begin: 0.05),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 24)),

            // ── Priority missions (special cadence: score-screen gap mission) ──
            priority.when(
              data: (rows) => rows.isEmpty
                  ? const SliverToBoxAdapter(child: SizedBox.shrink())
                  : SliverPadding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      sliver: SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            final m = rows[index];
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: _MissionCard(
                                title: m.title,
                                description: m.description,
                                pillar: m.pillar,
                                xp: m.xpReward,
                                source: m.source,
                                priority: m.priority,
                                rationale: m.rationale,
                                // Pinned (special-cadence) missions are
                                // highlighted — they came from a score gap.
                                pinned: true,
                                onDone: () async {
                                  SoundService.instance.success();
                                  final streakEvent = await ref.read(
                                      completeMissionProvider((
                                    profileId: profileId,
                                    missionId: m.id,
                                    xp: m.xpReward,
                                    pillar: m.pillar,
                                  )));
                                  // null = already done (double-tap / stale
                                  // pinned card): nothing was awarded, so no
                                  // fake reward toast.
                                  if (streakEvent != null) {
                                    celebrate(context,
                                        message: '+${m.xpReward} XP 🎉');
                                  }
                                  celebrateStreakEvent(context, streakEvent);
                                },
                              ),
                            );
                          },
                          childCount: rows.length,
                        ),
                      ),
                    ),
              loading: () =>
                  const SliverToBoxAdapter(child: SizedBox.shrink()),
              error: (e, _) =>
                  const SliverToBoxAdapter(child: SizedBox.shrink()),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 24)),

            // ── Today's missions ──
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: SectionTitle("Today"),
              ),
            ),

            // Mission list.
            daily.when(
              data: (rows) => rows.isEmpty
                  ? SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: GlassCard(
                          child: Column(
                            children: [
                              Icon(
                                Icons.flag_outlined,
                                size: 32,
                                color: Palette.primary.withValues(alpha: 0.5),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'No missions yet',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: dark
                                      ? Palette.textPrimary
                                      : Palette.textInverse,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Complete onboarding to generate missions',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: dark
                                      ? Palette.textSecondary
                                      : Palette.textTertiary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  : SliverPadding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      sliver: SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            final m = rows[index];
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: _MissionCard(
                                title: m.title,
                                description: m.description,
                                pillar: m.pillar,
                                xp: m.xpReward,
                                source: m.source,
                                priority: m.priority,
                                rationale: m.rationale,
                                onDone: () async {
                                  SoundService.instance.success();
                                  final streakEvent =
                                      await ref.read(completeMissionProvider((
                                    profileId: profileId,
                                    missionId: m.id,
                                    xp: m.xpReward,
                                    pillar: m.pillar,
                                  )));
                                  if (streakEvent != null) {
                                    celebrate(context,
                                        message: '+${m.xpReward} XP 🎉');
                                  }
                                  celebrateStreakEvent(context, streakEvent);
                                },
                              ),
                            );
                          },
                          childCount: rows.length,
                        ),
                      ),
                    ),
              loading: () => const SliverToBoxAdapter(
                child: Center(child: CircularProgressIndicator()),
              ),
              error: (e, _) => SliverToBoxAdapter(
                child: Center(child: Text('Error: $e')),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 24)),

            // ── Weekly missions ──
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: SectionTitle("This week"),
              ),
            ),

            weekly.when(
              data: (rows) => rows.isEmpty
                  ? SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: GlassCard(
                          child: Text(
                            'No weekly missions yet',
                            style: TextStyle(
                              color: dark
                                  ? Palette.textSecondary
                                  : Palette.textTertiary,
                            ),
                          ),
                        ),
                      ),
                    )
                  : SliverPadding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      sliver: SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            final m = rows[index];
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: _MissionCard(
                                title: m.title,
                                description: m.description,
                                pillar: m.pillar,
                                xp: m.xpReward,
                                source: m.source,
                                priority: m.priority,
                                rationale: m.rationale,
                                onDone: () async {
                                  SoundService.instance.success();
                                  final streakEvent =
                                      await ref.read(completeMissionProvider((
                                    profileId: profileId,
                                    missionId: m.id,
                                    xp: m.xpReward,
                                    pillar: m.pillar,
                                  )));
                                  if (streakEvent != null) {
                                    celebrate(context,
                                        message: '+${m.xpReward} XP 🎉');
                                  }
                                  celebrateStreakEvent(context, streakEvent);
                                },
                              ),
                            );
                          },
                          childCount: rows.length,
                        ),
                      ),
                    ),
              loading: () => const SliverToBoxAdapter(
                child: Center(child: CircularProgressIndicator()),
              ),
              error: (e, _) => SliverToBoxAdapter(
                child: Center(child: Text('Error: $e')),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 24)),

            // ── Monthly missions ──
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: SectionTitle("This month"),
              ),
            ),

            monthly.when(
              data: (rows) => rows.isEmpty
                  ? SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: GlassCard(
                          child: Text(
                            'No monthly missions yet',
                            style: TextStyle(
                              color: dark
                                  ? Palette.textSecondary
                                  : Palette.textTertiary,
                            ),
                          ),
                        ),
                      ),
                    )
                  : SliverPadding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      sliver: SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            final m = rows[index];
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: _MissionCard(
                                title: m.title,
                                description: m.description,
                                pillar: m.pillar,
                                xp: m.xpReward,
                                source: m.source,
                                priority: m.priority,
                                rationale: m.rationale,
                                onDone: () async {
                                  SoundService.instance.success();
                                  final streakEvent =
                                      await ref.read(completeMissionProvider((
                                    profileId: profileId,
                                    missionId: m.id,
                                    xp: m.xpReward,
                                    pillar: m.pillar,
                                  )));
                                  if (streakEvent != null) {
                                    celebrate(context,
                                        message: '+${m.xpReward} XP 🎉');
                                  }
                                  celebrateStreakEvent(context, streakEvent);
                                },
                              ),
                            );
                          },
                          childCount: rows.length,
                        ),
                      ),
                    ),
              loading: () => const SliverToBoxAdapter(
                child: Center(child: CircularProgressIndicator()),
              ),
              error: (e, _) => SliverToBoxAdapter(
                child: Center(child: Text('Error: $e')),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 100)),
          ],
        ),
      ),
    );
  }
}

/// Mission card.
class _MissionCard extends StatelessWidget {
  const _MissionCard({
    required this.title,
    required this.description,
    required this.pillar,
    required this.xp,
    required this.source,
    required this.priority,
    required this.rationale,
    required this.onDone,
    this.pinned = false,
  });

  final String title;
  final String description;
  final String pillar;
  final int xp;
  final String source;
  final String priority;
  final String rationale;
  final Future<void> Function() onDone;

  /// Pinned (special-cadence) missions — surfaced from a score gap, shown
  /// with an accent border + "Priority" tag so the student knows this one
  /// is the direct result of their profile feedback.
  final bool pinned;

  @override
  Widget build(BuildContext context) {
    final dark = isDark(context);
    final color = pillarColor(pillar);
    final isAi = source == 'ai';
    final prioColor = switch (priority) {
      'critical' => Palette.error,
      'high' => Palette.warning,
      'low' => Palette.textTertiary,
      _ => Palette.primary,
    };
    return GlassCard(
      padding: const EdgeInsets.all(14),
      // Pinned (priority) missions get an accent border so the score-gap
      // mission reads as special — feedback converted into action.
      border: pinned
          ? Border.all(color: Palette.warning.withValues(alpha: 0.5))
          : null,
      child: Row(
        children: [
          // Pinned tag + pillar icon.
          if (pinned) ...[
            Container(
              width: 28,
              height: 44,
              decoration: BoxDecoration(
                color: Palette.warning.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Center(
                child: Icon(Icons.push_pin,
                    size: 16, color: Palette.warning),
              ),
            ),
            const SizedBox(width: 10),
          ],
          // Pillar icon.
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Icon(pillarIcon(pillar),
                  size: 20, color: color),
            ),
          ),
          const SizedBox(width: 12),
          // Title + description + meta row.
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                    color: dark ? Palette.textPrimary : Palette.textInverse,
                  ),
                ),
                if (description.isNotEmpty) ...[
                  const SizedBox(height: 3),
                  Text(
                    description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 12,
                      color:
                          dark ? Palette.textSecondary : Palette.textTertiary,
                    ),
                  ),
                ],
                const SizedBox(height: 5),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: color.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        pillar,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: color,
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: prioColor.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        priority.toUpperCase(),
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: prioColor,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                    if (isAi) ...[
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: Palette.primary.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.auto_awesome,
                                size: 11, color: Palette.primary),
                            SizedBox(width: 3),
                            Text(
                              'AI',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                                color: Palette.primary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
                if (rationale.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.tips_and_updates_outlined,
                            size: 13,
                            color: dark
                                ? Palette.textTertiary
                                : Palette.textTertiary),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            rationale,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 11,
                              fontStyle: FontStyle.italic,
                              color: dark
                                  ? Palette.textTertiary
                                  : Palette.textTertiary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          // XP badge + complete button.
          Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: Palette.warning.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '+$xp',
                  style: const TextStyle(
                    color: Palette.warning,
                    fontWeight: FontWeight.w700,
                    fontSize: 12,
                  ),
                ),
              ),
              const SizedBox(height: 6),
              _CompleteButton(xp: xp, onDone: onDone),
            ],
          ),
        ],
      ),
    ).animate().fadeIn().slideX(begin: 0.04);
  }
}

class _CompleteButton extends StatefulWidget {
  const _CompleteButton({required this.xp, required this.onDone});

  final int xp;
  final VoidCallback onDone;

  @override
  State<_CompleteButton> createState() => _CompleteButtonState();
}

class _CompleteButtonState extends State<_CompleteButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: 420.ms,
    reverseDuration: 180.ms,
  );

  Future<void> _complete() async {
    if (_c.isAnimating) return;
    HapticFeedback.heavyImpact();
    await _c.forward();
    widget.onDone();
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _complete,
      child: AnimatedBuilder(
        animation: _c,
        builder: (_, __) {
          final v = _c.value;
          final done = v >= 1;
          return Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: done
                  ? Palette.success
                  : Palette.success.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(10),
              boxShadow: done
                  ? [
                      BoxShadow(
                        color: Palette.success.withValues(alpha: 0.4),
                        blurRadius: 10,
                        offset: const Offset(0, 3),
                      ),
                    ]
                  : null,
            ),
            child: done
                ? const Icon(Icons.check_rounded, size: 18, color: Colors.white)
                : CustomPaint(
                    painter: CheckStrokePainter(
                      progress: v,
                      color: Palette.success,
                      strokeWidth: 2.6,
                    ),
                    size: const Size(24, 24),
                  ),
          ).animate(
            target: done ? 1 : 0,
          );
        },
      ),
    );
  }
}
