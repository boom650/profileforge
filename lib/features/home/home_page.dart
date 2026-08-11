import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:profileforge/core/audio/sound_service.dart';
import 'package:profileforge/core/celebration/celebrate.dart';
import 'package:profileforge/core/theme/app_theme.dart';
import 'package:profileforge/core/widgets/premium_widgets.dart';
import 'package:profileforge/core/widgets/motion_kit.dart';
import 'package:profileforge/features/leagues/application/league_providers.dart';
import 'package:profileforge/features/leagues/domain/league_definitions.dart';
import 'package:profileforge/features/missions/application/mission_providers.dart';
import 'package:profileforge/features/streak/application/streak_providers.dart';
import 'package:profileforge/features/timer/presentation/ambient_audio_panel.dart';
import 'package:profileforge/features/rewards/application/daily_reward_providers.dart';
import 'package:profileforge/features/xp/application/xp_providers.dart';
import 'package:profileforge/features/skins/application/skin_providers.dart';
import 'package:profileforge/features/wallet/application/wallet_providers.dart';
import 'package:profileforge/core/ai/ai_service.dart';
import 'package:profileforge/core/ai/ai_recommendation_service.dart';
import 'package:profileforge/features/onboarding/application/onboarding_providers.dart';

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
    final xpByDayAsync =
        ref.watch(xpByDayProvider((profileId: profileId, days: 7)));
    final equippedSkinAsync = ref.watch(equippedSkinProvider(profileId));
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
        bottomNavigationBar: _BottomNav(context, '/home'),
        body: const Center(child: CircularProgressIndicator()),
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
                    ),
                    const SizedBox(width: 8),
                    // Gems badge.
                    _StatBadge(
                      icon: Icons.diamond,
                      value: '$gems',
                      color: Palette.info,
                    ),
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
                      _LevelUpDetector(
                        level: level,
                        xpInLevel: xpInLevel,
                        child: XpRing(
                          progress: xpInLevel / 100,
                          size: 72,
                          strokeWidth: 6,
                          color: Colors.white,
                          centerTop: '$level',
                          centerBottom: 'LVL',
                        ),
                      ),
                      const SizedBox(width: 14),
                      // Equipped skin avatar — the reward the user bought with
                      // gems is VISIBLE here (Habitica shows your avatar
                      // everywhere; the skin previously vanished after buying).
                      Builder(
                        builder: (context) {
                          final skin = equippedSkinAsync.valueOrNull;
                          if (skin == null) return const SizedBox.shrink();
                          return Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 44,
                                height: 44,
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
                                      color: Color(skin.seedColor)
                                          .withValues(alpha: 0.5),
                                      blurRadius: 14,
                                      spreadRadius: -2,
                                    ),
                                  ],
                                  border: Border.all(
                                    color: Colors.white.withValues(alpha: 0.35),
                                    width: 1.5,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                skin.name,
                                style: TextStyle(
                                  fontSize: 9,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white.withValues(alpha: 0.85),
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          );
                        },
                      ),
                      const SizedBox(width: 14),
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
                                backgroundColor:
                                    Colors.white.withValues(alpha: 0.2),
                                valueColor:
                                    const AlwaysStoppedAnimation(Colors.white),
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
                                  const StreakFlame(size: 18),
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
                  child: PressableScale(
                    onTap: () async {
                      final g = await ref
                          .read(claimDailyRewardProvider(profileId).future);
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
                  ).animate().shake(delay: 500.ms, duration: 500.ms),
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

            // ── AI Recommendations ──
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                child: Row(
                  children: [
                    Expanded(child: SectionTitle('🤖 AI Recommendations')),
                    GestureDetector(
                      onTap: () => context.push('/enhanced-ai-chat'),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          gradient: Palette.gradientPrimary,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.chat_bubble_outline,
                                size: 14, color: Colors.white),
                            SizedBox(width: 4),
                            Text(
                              'Chat with AI',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: _AIRecommendations(profileId: profileId),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 20)),

            // ── Quick Access to New Screens ──
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                child: SectionTitle('⚡ Quick Access'),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    Expanded(
                      child: _QuickAccessCard(
                        icon: Icons.psychology,
                        label: 'Personality',
                        subtitle: '5-min assessment',
                        color: const Color(0xFF8B5CF6),
                        onTap: () => context.push('/psychology-onboarding'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _QuickAccessCard(
                        icon: Icons.auto_awesome,
                        label: 'AI Chat',
                        subtitle: 'Psychology-adapted',
                        color: Palette.primary,
                        onTap: () => context.push('/enhanced-ai-chat'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                child: Row(
                  children: [
                    Expanded(
                      child: _QuickAccessCard(
                        icon: Icons.score,
                        label: 'Score',
                        subtitle: 'Your readiness',
                        color: Palette.success,
                        onTap: () => context.push('/profile-score'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _QuickAccessCard(
                        icon: Icons.settings,
                        label: 'Settings',
                        subtitle: 'App & AI config',
                        color: Palette.warning,
                        onTap: () => context.push('/settings'),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 20)),

            // ── Weekly progress heatmap ──
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: SectionTitle('This week'),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: _WeeklyHeatmap(
                  xpByDay: xpByDayAsync.valueOrNull ?? const {},
                ),
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
                  final rank =
                      standings.indexWhere((m) => m.profileId == profileId) + 1;
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
              ).animate().fadeIn(delay: 300.ms),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 20)),

            // ── Ambient sound ──
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: const AmbientAudioPanel(),
              ),
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
class _LevelUpDetector extends StatefulWidget {
  const _LevelUpDetector({
    required this.level,
    required this.xpInLevel,
    required this.child,
  });

  final int level;
  final int xpInLevel;
  final Widget child;

  @override
  State<_LevelUpDetector> createState() => _LevelUpDetectorState();
}

class _LevelUpDetectorState extends State<_LevelUpDetector> {
  int _lastLevel = 0;
  bool _initialized = false;

  @override
  void didUpdateWidget(_LevelUpDetector old) {
    super.didUpdateWidget(old);
    if (!_initialized) {
      _lastLevel = widget.level;
      _initialized = true;
    } else if (widget.level > _lastLevel) {
      _lastLevel = widget.level;
      Future.delayed(const Duration(milliseconds: 300), () {
        if (mounted) showLevelUp(context, widget.level);
      });
    }
  }

  @override
  Widget build(BuildContext context) => widget.child;
}

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

/// Weekly heatmap — GitHub-style dots driven by REAL per-day XP from the
/// XpEvents ledger. Intensity scales with XP earned that day (0 XP = dim
/// empty dot; more XP = brighter, glowing). Previously this was fake:
/// `streak.clamp(0, 7)` filled dots even when the user did nothing this week.
class _WeeklyHeatmap extends StatelessWidget {
  const _WeeklyHeatmap({required this.xpByDay});
  final Map<DateTime, int> xpByDay;

  @override
  Widget build(BuildContext context) {
    final dark = isDark(context);
    final days = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
    final today = DateTime.now();
    final dayOnly = (DateTime d) => DateTime(d.year, d.month, d.day);

    return GlassCard(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(7, (i) {
          final date = dayOnly(today.subtract(Duration(days: 6 - i)));
          final xp = xpByDay[date] ?? 0;
          final active = xp > 0;
          // Intensity: 0 XP → dim empty; 1-24 → 30%; 25-49 → 55%;
          // 50-99 → 80%; 100+ → 100% (glowing accent).
          final intensity = active
              ? (xp >= 100 ? 1.0 : (xp >= 50 ? 0.8 : (xp >= 25 ? 0.55 : 0.3)))
              : 0.0;
          final base = intensity == 0.0
              ? (dark ? Palette.surface3 : const Color(0xFFE2E8F0))
              : Palette.primary.withValues(alpha: 0.25 + intensity * 0.75);

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
                  color: base,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: active
                      ? [
                          BoxShadow(
                            color:
                                Palette.primary.withValues(alpha: 0.25 * intensity),
                            blurRadius: 10 * intensity,
                            offset: const Offset(0, 2),
                          ),
                        ]
                      : null,
                ),
                child: active
                    ? Icon(Icons.check, color: Colors.white, size: 16)
                    : null,
              ),
              const SizedBox(height: 2),
              Text(
                xp > 0 ? '$xp' : '',
                style: TextStyle(
                  fontSize: 9,
                  fontWeight: FontWeight.w600,
                  color: active ? Palette.primary : Colors.transparent,
                ),
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

/// AI-powered task recommendations widget — calls real LLM.
class _AIRecommendations extends ConsumerStatefulWidget {
  const _AIRecommendations({required this.profileId});
  final String profileId;

  @override
  ConsumerState<_AIRecommendations> createState() => _AIRecommendationsState();
}

class _AIRecommendationsState extends ConsumerState<_AIRecommendations> {
  List<AIRecommendation> _recommendations = [];
  bool _loading = false;
  String? _error;
  bool _hasProvider = false;

  @override
  void initState() {
    super.initState();
    _checkProvider();
  }

  Future<void> _checkProvider() async {
    final ai = AIService();
    final name = await ai.getActiveProviderName();
    if (mounted) {
      setState(() => _hasProvider = name != 'None');
      if (_hasProvider) _loadRecommendations();
    }
  }

  Future<void> _loadRecommendations() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    final obAsync = ref.read(onboardingProvider(widget.profileId));
    final ob = obAsync.valueOrNull;

    final ai = AIService();
    final service = AIRecommendationService(ai);

    try {
      final recs = await service.getTaskRecommendations(
        city: ob?.location ?? 'Singapore',
        interests: ob?.subjects ?? [],
        targetSchools: ob?.targetUniversities ?? [],
        grade: 11,
        hoursPerWeek: ob?.availabilityHoursPerWeek ?? 15,
        currentActivities: ob?.activities ?? [],
        grades: ob?.grades ?? {},
      );

      if (mounted) {
        setState(() {
          _recommendations = recs;
          _loading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = e.toString();
          _loading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final dark = isDark(context);

    if (!_hasProvider) {
      return GlassCard(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(
              Icons.auto_awesome,
              size: 32,
              color: Palette.primary.withValues(alpha: 0.4),
            ),
            const SizedBox(height: 8),
            Text(
              'AI Recommendations',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 14,
                color: dark ? Palette.textPrimary : Palette.textInverse,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Add an AI API key in Settings for personalized recommendations',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                color: dark ? Palette.textSecondary : Palette.textTertiary,
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton.icon(
              onPressed: () => context.push('/ai-settings'),
              icon: const Icon(Icons.settings, size: 16),
              label: const Text('Configure AI'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Palette.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ],
        ),
      );
    }

    if (_loading) {
      return GlassCard(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: Column(
            children: [
              const CircularProgressIndicator(color: Palette.primary),
              const SizedBox(height: 12),
              Text(
                'AI is analyzing your profile...',
                style: TextStyle(
                  color: dark ? Palette.textSecondary : Palette.textTertiary,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (_error != null) {
      return GlassCard(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Icon(Icons.error_outline, color: Palette.error, size: 28),
            const SizedBox(height: 8),
            Text(
              'AI unavailable',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: dark ? Palette.textPrimary : Palette.textInverse,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Check your API key in Settings',
              style: TextStyle(
                fontSize: 12,
                color: dark ? Palette.textSecondary : Palette.textTertiary,
              ),
            ),
            const SizedBox(height: 8),
            TextButton.icon(
              onPressed: _loadRecommendations,
              icon: const Icon(Icons.refresh, size: 16),
              label: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    return GlassCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  gradient: Palette.gradientPrimary,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.auto_awesome,
                    size: 18, color: Colors.white),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'AI-Powered Tasks',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                        color: dark ? Palette.textPrimary : Palette.textInverse,
                      ),
                    ),
                    Text(
                      'Personalized by AI based on your profile',
                      style: TextStyle(
                        fontSize: 12,
                        color:
                            dark ? Palette.textSecondary : Palette.textTertiary,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: _loadRecommendations,
                icon: Icon(
                  Icons.refresh,
                  size: 20,
                  color: dark ? Palette.textSecondary : Palette.textTertiary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          if (_recommendations.isEmpty)
            Text(
              'No recommendations yet. Complete your profile for better suggestions.',
              style: TextStyle(
                fontSize: 13,
                color: dark ? Palette.textSecondary : Palette.textTertiary,
              ),
            )
          else
            ..._recommendations.take(4).map((task) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: dark ? Palette.surface2 : const Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: dark ? Palette.border : const Color(0xFFE2E8F0),
                      ),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: _categoryColor(task.category)
                                .withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            task.priorityLabel,
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: _categoryColor(task.category),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                task.title,
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 13,
                                  color: dark
                                      ? Palette.textPrimary
                                      : Palette.textInverse,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                task.reason,
                                style: TextStyle(
                                  fontSize: 11,
                                  color: dark
                                      ? Palette.textSecondary
                                      : Palette.textTertiary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: Palette.primary.withValues(alpha: 0.12),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                '${task.xp} XP',
                                style: const TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                  color: Palette.primary,
                                ),
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              task.duration,
                              style: TextStyle(
                                fontSize: 10,
                                color: dark
                                    ? Palette.textSecondary
                                    : Palette.textTertiary,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                )),
        ],
      ),
    );
  }

  Color _categoryColor(String cat) {
    switch (cat) {
      case 'academics':
        return Palette.blue;
      case 'research':
        return Palette.purple;
      case 'creativity':
        return Palette.accentPink;
      case 'leadership':
        return Palette.warning;
      case 'service':
        return Palette.success;
      default:
        return Palette.primary;
    }
  }
}

/// ── Quick Access Card ──────────────────────────────────────────────────────
class _QuickAccessCard extends StatelessWidget {
  const _QuickAccessCard({
    required this.icon,
    required this.label,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final dark = isDark(context);

    return PressableScale(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: dark ? Palette.surface1.withValues(alpha: 0.6) : Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: dark
                ? Palette.border.withValues(alpha: 0.4)
                : const Color(0xFFE2E8F0),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, size: 20, color: color),
            ),
            const SizedBox(height: 10),
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: dark ? Palette.textPrimary : Palette.textInverse,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 11,
                color: dark ? Palette.textTertiary : Palette.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
