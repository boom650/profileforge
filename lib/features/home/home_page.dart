import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import 'package:profileforge/core/audio/sound_service.dart';
import 'package:profileforge/core/celebration/celebrate.dart';
import 'package:profileforge/core/theme/app_theme.dart';
import 'package:profileforge/core/widgets/premium_widgets.dart';
import 'package:profileforge/features/leagues/application/league_providers.dart';
import 'package:profileforge/features/leagues/domain/league_definitions.dart';
import 'package:profileforge/features/missions/application/mission_providers.dart';
import 'package:profileforge/features/streak/application/streak_providers.dart';
import 'package:profileforge/features/timer/presentation/ambient_audio_panel.dart';
import 'package:profileforge/features/rewards/application/daily_reward_providers.dart';
import 'package:profileforge/features/xp/application/xp_providers.dart';
import 'package:profileforge/features/wallet/application/wallet_providers.dart';

/// ────────────────────────────────────────────────────────────────────────────
/// HomePage v2 — Premium Lusion-inspired layout.
/// Clean hierarchy: header → hero → daily focus → missions → progress → league.
/// ────────────────────────────────────────────────────────────────────────────
class HomePage extends ConsumerWidget {
  const HomePage({super.key, required this.profileId});
  final String profileId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final dark = isDark(context);
    final xpAsync = ref.watch(totalXpProvider(profileId));
    final gemsAsync = ref.watch(gemsProvider(profileId));
    final streakAsync = ref.watch(streakProvider(profileId));
    final missionsAsync = ref.watch(todaysMissionsProvider(profileId));
    final leagueAsync = ref.watch(myLeagueProvider(profileId));
    final standingsAsync = ref.watch(leagueStandingsProvider(profileId));
    final rewardAsync = ref.watch(dailyRewardProvider(profileId));

    final isLoading = xpAsync.isLoading || gemsAsync.isLoading;
    final totalXp = xpAsync.valueOrNull ?? 0;
    final gems = gemsAsync.valueOrNull ?? 0;
    final streak = streakAsync.valueOrNull?.current ?? 0;
    final missions = missionsAsync.valueOrNull ?? [];

    // Level calculation.
    final level = totalXp ~/ 100 + 1;
    final xpInLevel = totalXp % 100;

    // Get user name.
    String userName = 'there';
    SharedPreferences.getInstance().then((p) {
      userName = p.getString('pf_user_name') ?? 'there';
    });

    if (isLoading && totalXp == 0) {
      return Scaffold(
        backgroundColor: dark ? Palette.black : const Color(0xFFF8FAFC),
        bottomNavigationBar: _BottomNav(context, '/home'),
        body: const _HomeSkeleton(),
      );
    }

    return Scaffold(
      backgroundColor: dark ? Palette.black : const Color(0xFFF8FAFC),
      bottomNavigationBar: _BottomNav(context, '/home'),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // ── Header bar ──
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                child: Row(
                  children: [
                    // Avatar.
                    GestureDetector(
                      onTap: () => context.push('/profile'),
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          gradient: Palette.gradientPrimary,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Center(
                          child: Text(
                            'U',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Hi $userName 👋',
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            'Level $level',
                            style: theme.textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ),
                    // XP badge.
                    _StatBadge(
                      icon: Icons.bolt,
                      value: '$totalXp',
                      color: Palette.warning,
                    ).animate().scale(delay: 200.ms, duration: 300.ms, curve: Curves.elasticOut),
                    const SizedBox(width: 8),
                    // Gems badge.
                    _StatBadge(
                      icon: Icons.diamond,
                      value: '$gems',
                      color: Palette.info,
                    ).animate().scale(delay: 250.ms, duration: 300.ms, curve: Curves.elasticOut),
                  ],
                ),
              ).animate().fadeIn(duration: 300.ms),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 20)),

            // ── Hero card: level ring + streak ──
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: GradientBanner(
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFF3B82F6), Color(0xFF8B5CF6)],
                  ),
                  child: Row(
                    children: [
                      XpRing(
                        progress: xpInLevel / 100,
                        size: 72,
                        strokeWidth: 6,
                        color: Colors.white,
                        centerTop: '$level',
                        centerBottom: 'LVL',
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _levelTitle(level),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.3,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '$totalXp XP total',
                              style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.8),
                                fontSize: 13,
                              ),
                            ),
                            const SizedBox(height: 10),
                            // XP progress bar.
                            ClipRRect(
                              borderRadius: BorderRadius.circular(4),
                              child: LinearProgressIndicator(
                                value: xpInLevel / 100,
                                minHeight: 6,
                                backgroundColor: Colors.white.withValues(alpha: 0.2),
                                valueColor: const AlwaysStoppedAnimation(Colors.white),
                              ),
                            ),
                            const SizedBox(height: 10),
                            // Streak badge.
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Text('🔥', style: TextStyle(fontSize: 14)).animate()
                                    .scale(duration: 300.ms, curve: Curves.elasticOut, delay: 500.ms),
                                  const SizedBox(width: 4),
                                  Text(
                                    '$streak day streak',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ).animate().fadeIn(delay: 100.ms).slideY(begin: 0.05),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 16)),

            // ── Daily reward CTA ──
            if (rewardAsync.valueOrNull?.canClaim ?? false)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: GestureDetector(
                    onTap: () async {
                      final g = await ref.read(
                          claimDailyRewardProvider(profileId).future);
                      SoundService.instance.coin();
                      celebrate(context, message: '+$g 💎');
                      ref.invalidate(dailyRewardProvider(profileId));
                    },
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        gradient: Palette.gradientGold,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Palette.warning.withValues(alpha: 0.3),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          const Text('🎁', style: TextStyle(fontSize: 28)),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Daily reward available!',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 15,
                                  ),
                                ),
                                Text(
                                  'Day ${rewardAsync.valueOrNull?.day ?? 1} — tap to claim',
                                  style: TextStyle(
                                    color: Colors.white.withValues(alpha: 0.8),
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Icon(Icons.arrow_forward_ios,
                              color: Colors.white, size: 16),
                        ],
                      ),
                    ),
                  ).animate().shake(delay: 500.ms, duration: 500.ms).then()
                    .animate(delay: 1000.ms).fadeIn(duration: 300.ms),
                ),
              ),

            if (rewardAsync.valueOrNull?.canClaim ?? false)
              const SliverToBoxAdapter(child: SizedBox(height: 16)),

            // ── Today's missions ──
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                child: SectionTitle(
                  "Today's missions",
                  action: TextButton(
                    onPressed: () => context.push('/missions'),
                    child: const Text('See all'),
                  ),
                ),
              ).animate().fadeIn(delay: 200.ms),
            ),

            // Mission cards.
            if (missions.isNotEmpty)
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final m = missions[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: _MissionCard(
                          icon: _missionIcon(m.pillar),
                          title: m.title,
                          xpReward: m.xpReward,
                          pillar: m.pillar,
                        ).animate(
                          delay: Duration(milliseconds: index * 80),
                          duration: 400.ms,
                        ).fadeIn(
                          curve: Curves.easeOutCubic,
                        ).slideY(
                          begin: 0.15,
                          end: 0,
                          curve: Curves.easeOutCubic,
                        ),
                      );
                    },
                    childCount: missions.length > 3 ? 3 : missions.length,
                  ),
                ),
              )
            else
              SliverToBoxAdapter(
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
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.hintColor,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Complete onboarding to get started',
                          style: theme.textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                ),
              ),

            const SliverToBoxAdapter(child: SizedBox(height: 20)),

            // ── AI quick access ──
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: GlassCard(
                  onTap: () => context.push('/ai-chat'),
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Palette.primary, Palette.primary.withValues(alpha: 0.6)],
                          ),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: const Center(
                          child: Icon(Icons.auto_awesome, color: Colors.white, size: 24),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'AI Admissions Architect',
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 15,
                              ),
                            ),
                            Text(
                              'Chat with AI • Analyze artifacts • Get missions',
                              style: TextStyle(
                                color: theme.hintColor,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Icon(
                        Icons.arrow_forward_ios,
                        size: 16,
                        color: theme.hintColor,
                      ),
                    ],
                  ),
                ),
              ).animate().fadeIn(delay: 300.ms).slideX(begin: 0.03),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 20)),

            // ── Weekly progress heatmap ──
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: SectionTitle('This week'),
              ).animate().fadeIn(delay: 350.ms),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: _WeeklyHeatmap(streak: streak),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 20)),

            // ── League card ──
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Builder(builder: (context) {
                  final standings = standingsAsync.valueOrNull ?? [];
                  final tierStr = leagueAsync.valueOrNull?.tier ?? 'bronze';
                  final tier = LeagueTier.values.firstWhere(
                      (t) => t.name == tierStr,
                      orElse: () => LeagueTier.bronze);
                  final rank = standings
                          .indexWhere((m) => m.profileId == profileId) +
                      1;
                  return GlassCard(
                    onTap: () => context.push('/leagues'),
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: tier.tierColor.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Center(
                            child: Text(
                              tier.tierEmoji,
                              style: const TextStyle(fontSize: 24),
                            ),
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                tier.tierLabel,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 16,
                                ),
                              ),
                              Text(
                                rank > 0
                                    ? '#$rank of ${standings.length}'
                                    : 'Join a league',
                                style: TextStyle(
                                  color: theme.hintColor,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Icon(
                          Icons.arrow_forward_ios,
                          size: 16,
                          color: theme.hintColor,
                        ),
                      ],
                    ),
                  );
                  }),
                  ).animate().fadeIn(delay: 300.ms).slideX(begin: 0.03),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 20)),

            // ── Ambient sound ──
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: const AmbientAudioPanel(),
              ).animate().fadeIn(delay: 400.ms),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 100)),
          ],
        ),
      ),
    );
  }

  String _missionIcon(String pillar) {
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

  String _levelTitle(int level) {
    if (level >= 50) return 'Grandmaster';
    if (level >= 40) return 'Master';
    if (level >= 30) return 'Expert';
    if (level >= 20) return 'Advanced';
    if (level >= 10) return 'Skilled';
    if (level >= 5) return 'Apprentice';
    return 'Beginner';
  }
}

/// Stat badge in header.
class _StatBadge extends StatelessWidget {
  const _StatBadge({
    required this.icon,
    required this.value,
    required this.color,
  });

  final IconData icon;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final dark = isDark(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: dark ? 0.15 : 0.1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 16),
          const SizedBox(width: 4),
          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 14,
              color: dark ? Palette.textPrimary : Palette.textInverse,
            ),
          ),
        ],
      ),
    );
  }
}

/// Mission card.
class _MissionCard extends StatelessWidget {
  const _MissionCard({
    required this.icon,
    required this.title,
    required this.xpReward,
    required this.pillar,
  });

  final String icon;
  final String title;
  final int xpReward;
  final String pillar;

  @override
  Widget build(BuildContext context) {
    final color = pillarColor(pillar);
    return GlassCard(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          // Icon.
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(icon, style: const TextStyle(fontSize: 18)),
            ),
          ),
          const SizedBox(width: 12),
          // Title.
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ),
          // XP reward.
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              '+$xpReward',
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.w700,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Weekly heatmap — GitHub-style dots.
class _WeeklyHeatmap extends StatelessWidget {
  const _WeeklyHeatmap({required this.streak});
  final int streak;

  @override
  Widget build(BuildContext context) {
    final dark = isDark(context);
    final days = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
    // Simple: fill dots based on streak (up to 7 days).
    final filled = streak.clamp(0, 7);

    return GlassCard(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(7, (i) {
          final isFilled = i < filled;
          return Column(
            children: [
              Text(
                days[i],
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: dark ? Palette.textSecondary : Palette.textTertiary,
                ),
              ),
              const SizedBox(height: 6),
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: isFilled
                      ? Palette.primary
                      : dark
                          ? Palette.surface3
                          : const Color(0xFFE2E8F0),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: isFilled
                    ? const Icon(Icons.check, color: Colors.white, size: 16)
                    : null,
              ),
            ],
          );
        }),
      ),
    );
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
            _NavItem(
              icon: Icons.home_rounded,
              label: 'Home',
              isSelected: current == '/home',
              onTap: () => context.go('/home'),
            ),
            _NavItem(
              icon: Icons.flag_rounded,
              label: 'Missions',
              isSelected: current == '/missions',
              onTap: () => context.push('/missions'),
            ),
            _NavItem(
              icon: Icons.person_rounded,
              label: 'Profile',
              isSelected: current == '/profile',
              onTap: () => context.push('/profile'),
            ),
            _NavItem(
              icon: Icons.diamond_rounded,
              label: 'Shop',
              isSelected: current == '/skins',
              onTap: () => context.push('/skins'),
            ),
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
              color: isSelected
                  ? Palette.primary
                  : (dark ? Palette.textTertiary : Palette.textTertiary),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                color: isSelected
                    ? Palette.primary
                    : (dark ? Palette.textTertiary : Palette.textTertiary),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// ────────────────────────────────────────────────────────────────────────────
/// _HomeSkeleton — Shimmer loading placeholder for home page.
/// Shows header + hero card + mission cards skeleton.
/// ────────────────────────────────────────────────────────────────────────────
class _HomeSkeleton extends StatelessWidget {
  const _HomeSkeleton();

  @override
  Widget build(BuildContext context) {
    return ShimmerSkeleton(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 40),
            // Header row skeleton
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 100,
                        height: 14,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(7),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Container(
                        width: 60,
                        height: 10,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            // Hero card skeleton
            Container(
              height: 120,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            const SizedBox(height: 20),
            // Section title skeleton
            Container(
              width: 120,
              height: 16,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            const SizedBox(height: 16),
            // Mission cards skeleton
            ...List.generate(
              3,
              (_) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Container(
                  height: 72,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Stats row skeleton
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(
                3,
                (_) => Container(
                  width: 80,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
