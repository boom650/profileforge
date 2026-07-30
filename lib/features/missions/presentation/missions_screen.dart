import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:profileforge/core/audio/sound_service.dart';
import 'package:profileforge/core/celebration/celebrate.dart';
import 'package:profileforge/core/theme/app_theme.dart';
import 'package:profileforge/core/widgets/premium_widgets.dart';
import 'package:profileforge/features/missions/application/mission_providers.dart';
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

    return Scaffold(
      backgroundColor: dark ? Palette.black : const Color(0xFFF8FAFC),
      bottomNavigationBar: _BottomNav(context, '/missions'),
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
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const Spacer(),
                    // Refresh button.
                    GestureDetector(
                      onTap: () {
                        final ob = ref.read(onboardingProvider(profileId)).valueOrNull;
                        if (ob == null) {
                          context.push('/onboarding');
                          return;
                        }
                        ref.read(generateMissionsProvider(profileId));
                        SoundService.instance.success();
                        celebrate(context, message: 'Refreshed! 🚀');
                      },
                      child: Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: dark ? Palette.surface2 : const Color(0xFFF1F5F9),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          Icons.refresh,
                          size: 20,
                          color: dark ? Palette.textSecondary : Palette.textTertiary,
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
                        '🎯 Daily missions',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Complete missions to earn XP and gems.\nThey\'re generated from your profile.',
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
                                  color: dark ? Palette.textPrimary : Palette.textInverse,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Complete onboarding to generate missions',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: dark ? Palette.textSecondary : Palette.textTertiary,
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
                                pillar: m.pillar,
                                xp: m.xpReward,
                                onDone: () async {
                                  SoundService.instance.success();
                                  await ref.read(completeMissionProvider((
                                    profileId: profileId,
                                    missionId: m.id,
                                    xp: m.xpReward,
                                    pillar: m.pillar,
                                  )));
                                  celebrate(context, message: '+${m.xpReward} XP 🎉');
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
                              color: dark ? Palette.textSecondary : Palette.textTertiary,
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
                                pillar: m.pillar,
                                xp: m.xpReward,
                                onDone: () async {
                                  SoundService.instance.success();
                                  await ref.read(completeMissionProvider((
                                    profileId: profileId,
                                    missionId: m.id,
                                    xp: m.xpReward,
                                    pillar: m.pillar,
                                  )));
                                  celebrate(context, message: '+${m.xpReward} XP 🎉');
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
    required this.pillar,
    required this.xp,
    required this.onDone,
  });

  final String title;
  final String pillar;
  final int xp;
  final Future<void> Function() onDone;

  @override
  Widget build(BuildContext context) {
    final dark = isDark(context);
    final color = pillarColor(pillar);
    return GlassCard(
      padding: const EdgeInsets.all(14),
      child: Row(
        children: [
          // Pillar icon.
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(_pillarEmoji(pillar), style: const TextStyle(fontSize: 20)),
            ),
          ),
          const SizedBox(width: 12),
          // Title + pillar chip.
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
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
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
              GestureDetector(
                onTap: onDone,
                child: Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: Palette.success.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.check, size: 18, color: Palette.success),
                ),
              ),
            ],
          ),
        ],
      ),
    ).animate().fadeIn().slideX(begin: 0.04);
  }

  String _pillarEmoji(String pillar) {
    switch (pillar.toLowerCase()) {
      case 'academics':
        return '📚';
      case 'leadership':
        return '👥';
      case 'research':
        return '🔬';
      case 'creativity':
        return '🎨';
      case 'community':
        return '🤝';
      case 'service':
        return '❤️';
      case 'sports':
        return '⚽';
      default:
        return '🎯';
    }
  }
}

/// Bottom navigation bar.
Widget _BottomNav(BuildContext context, String current) {
  final dark = isDark(context);
  return Container(
    decoration: BoxDecoration(
      color: dark ? Palette.surface0 : Colors.white,
      border: Border(
        top: BorderSide(
          color: dark ? Palette.border : const Color(0xFFE2E8F0),
          width: 1,
        ),
      ),
    ),
    child: SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _NavItem(icon: Icons.home_rounded, label: 'Home', isSelected: current == '/home', onTap: () => context.go('/home')),
            _NavItem(icon: Icons.flag_rounded, label: 'Missions', isSelected: current == '/missions', onTap: () => context.push('/missions')),
            _NavItem(icon: Icons.person_rounded, label: 'Profile', isSelected: current == '/profile', onTap: () => context.push('/profile')),
            _NavItem(icon: Icons.diamond_rounded, label: 'Shop', isSelected: current == '/skins', onTap: () => context.push('/skins')),
          ],
        ),
      ),
    ),
  );
}

/// Bottom nav item.
class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final dark = isDark(context);
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 64,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 24,
              color: isSelected ? Palette.primary : (dark ? Palette.textTertiary : Palette.textTertiary),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                color: isSelected ? Palette.primary : (dark ? Palette.textTertiary : Palette.textTertiary),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
