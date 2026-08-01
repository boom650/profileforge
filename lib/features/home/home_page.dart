import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import 'package:profileforge/core/audio/sound_service.dart';
import 'package:profileforge/core/celebration/celebrate.dart';
import 'package:profileforge/core/theme/app_theme.dart';
import 'package:profileforge/core/widgets/tap_scale.dart';
import 'package:profileforge/core/widgets/premium_widgets.dart';
import 'package:profileforge/core/widgets/streak_fire.dart';
import 'package:profileforge/core/widgets/animated_counter.dart';
import 'package:profileforge/core/widgets/daily_reward_claim.dart';
import 'package:profileforge/core/widgets/magnetic_button.dart';
import 'package:profileforge/features/leagues/application/league_providers.dart';
import 'package:profileforge/features/leagues/domain/league_definitions.dart';
import 'package:profileforge/features/missions/application/mission_providers.dart';
import 'package:profileforge/features/streak/application/streak_providers.dart';
import 'package:profileforge/features/timer/presentation/ambient_audio_panel.dart';
import 'package:profileforge/features/rewards/application/daily_reward_providers.dart';
import 'package:profileforge/features/xp/application/xp_providers.dart';
import 'package:profileforge/features/wallet/application/wallet_providers.dart';
import 'package:flutter/services.dart';

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
    final weeklyXpAsync = ref.watch(weeklyXpProvider(profileId));
    final missionsAsync = ref.watch(todaysMissionsProvider(profileId));
    final leagueAsync = ref.watch(myLeagueProvider(profileId));
    final recentSessionsAsync = ref.watch(recentSessionsProvider(profileId));
    final standingsAsync = ref.watch(leagueStandingsProvider(profileId));
    final rewardAsync = ref.watch(dailyRewardProvider(profileId));

    final isLoading = xpAsync.isLoading || gemsAsync.isLoading;
    final totalXp = xpAsync.valueOrNull ?? 0;
    final gems = gemsAsync.valueOrNull ?? 0;
    final streak = streakAsync.valueOrNull?.current ?? 0;
    final weeklyXp = weeklyXpAsync.valueOrNull ?? 0;
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
                            '${_greeting()} $userName 👋',
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
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: xpInLevel >= 80
                        ? [const Color(0xFF8B5CF6), const Color(0xFFEC4899)]
                        : [const Color(0xFF3B82F6), const Color(0xFF8B5CF6)],
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
                            // Streak badge with animated fire.
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
                                  SizedBox(
                                    width: 24,
                                    height: 24,
                                    child: StreakFire(streak: streak, size: 24),
                                  ),
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

            // ── Weekly goal progress ──
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: GlassCard(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 44,
                        height: 44,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            CircularProgressIndicator(
                              value: (weeklyXp / 500).clamp(0.0, 1.0),
                              strokeWidth: 4,
                              backgroundColor: Palette.surface3,
                              valueColor: AlwaysStoppedAnimation(Palette.primary),
                            ),
                            Text(
                              '${((weeklyXp / 500).clamp(0.0, 1.0) * 100).round()}%',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                color: Palette.primary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Weekly Goal',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: Palette.textPrimary,
                              ),
                            ),
                            Text(
                              '$weeklyXp / 500 XP this week',
                              style: TextStyle(
                                fontSize: 11,
                                color: Palette.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (weeklyXp >= 500)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Palette.success.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            '✓ Complete',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: Palette.success,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ).animate().fadeIn(delay: 120.ms),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 12)),

            // ── Quick stats row ──
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    _QuickStat(
                      icon: '⭐',
                      value: '$totalXp',
                      label: 'Total XP',
                      color: Palette.accentYellow,
                    ),
                    const SizedBox(width: 10),
                    _QuickStat(
                      icon: '💎',
                      value: '$gems',
                      label: 'Gems',
                      color: Palette.accentTeal,
                    ),
                    const SizedBox(width: 10),
                    _QuickStat(
                      icon: '🔥',
                      value: '$streak',
                      label: 'Streak',
                      color: Palette.warning,
                    ),
                  ],
                ),
              ).animate().fadeIn(delay: 150.ms),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 12)),

            // ── Profile completion indicator ──
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: _ProfileCompletion(profileId: profileId),
              ).animate().fadeIn(delay: 180.ms),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 12)),

            // ── Quick actions grid ──
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    TapScale(
                      child: _QuickAction(
                        icon: Icons.auto_awesome,
                        label: 'AI Chat',
                        color: Palette.primary,
                        onTap: () => context.push('/ai-chat'),
                      ),
                    ),
                    const SizedBox(width: 10),
                    TapScale(
                      child: _QuickAction(
                        icon: Icons.analytics_outlined,
                        label: 'Analyze',
                        color: Palette.accent,
                        onTap: () => context.push('/ai-analyzer'),
                      ),
                    ),
                    const SizedBox(width: 10),
                    TapScale(
                      child: _QuickAction(
                        icon: Icons.timer_outlined,
                        label: 'Timer',
                        color: Palette.success,
                        onTap: () => context.push('/timer'),
                      ),
                    ),
                    const SizedBox(width: 10),
                    TapScale(
                      child: _QuickAction(
                        icon: Icons.assessment_outlined,
                        label: 'Readiness',
                        color: Palette.warning,
                        onTap: () => context.push('/ai-readiness'),
                      ),
                    ),
                  ],
                ),
              ).animate().fadeIn(delay: 150.ms).slideY(begin: 0.05),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 16)),

            // ── Daily reward CTA ──
            if (rewardAsync.valueOrNull?.canClaim ?? false)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: DailyRewardClaim(
                    xpReward: 25 + (rewardAsync.valueOrNull?.day ?? 1) * 5,
                    gemReward: 2 + (rewardAsync.valueOrNull?.day ?? 1),
                    dayStreak: rewardAsync.valueOrNull?.day ?? 1,
                    onClaimed: () async {
                      final g = await ref.read(
                          claimDailyRewardProvider(profileId).future);
                      ref.invalidate(dailyRewardProvider(profileId));
                    },
                  ).animate().fadeIn(delay: 300.ms),
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

            // ── Streak milestones ──
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: GlassCard(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            'Streak Milestones',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: Palette.textPrimary,
                            ),
                          ),
                          const Spacer(),
                          Text(
                            '$streak days',
                            style: TextStyle(
                              fontSize: 12,
                              color: Palette.warning,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          _MilestoneDot(reached: streak >= 3, label: '3', emoji: '🔥'),
                          _MilestoneLine(reached: streak >= 7),
                          _MilestoneDot(reached: streak >= 7, label: '7', emoji: '⚡'),
                          _MilestoneLine(reached: streak >= 14),
                          _MilestoneDot(reached: streak >= 14, label: '14', emoji: '💎'),
                          _MilestoneLine(reached: streak >= 30),
                          _MilestoneDot(reached: streak >= 30, label: '30', emoji: '👑'),
                          _MilestoneLine(reached: streak >= 60),
                          _MilestoneDot(reached: streak >= 60, label: '60', emoji: '🏆'),
                          _MilestoneLine(reached: streak >= 100),
                          _MilestoneDot(reached: streak >= 100, label: '100', emoji: '🌟'),
                        ],
                      ),
                    ],
                  ),
                ),
              ).animate().fadeIn(delay: 250.ms),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 20)),

            // ── AI quick access ──
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: TapScale(
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
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 20)),

            // ── Daily admissions tip ──
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: GlassCard(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 28,
                            height: 28,
                            decoration: BoxDecoration(
                              color: Palette.accentBlue.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Center(
                              child: Icon(Icons.lightbulb_outline, size: 16, color: Palette.accentBlue),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Text(
                            'Daily Tip',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: Palette.accentBlue,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(
                        _dailyTip(),
                        style: TextStyle(
                          fontSize: 13,
                          color: Palette.textSecondary,
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ).animate().fadeIn(delay: 320.ms),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 20)),

            // ── Recent focus sessions ──
            if (recentSessionsAsync.valueOrNull != null && recentSessionsAsync.valueOrNull!.isNotEmpty)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: SectionTitle('Recent Sessions'),
                ).animate().fadeIn(delay: 380.ms),
              ),
            if (recentSessionsAsync.valueOrNull != null && recentSessionsAsync.valueOrNull!.isNotEmpty)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: GlassCard(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Column(
                      children: recentSessionsAsync.valueOrNull!.take(3).map((s) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6),
                        child: Row(
                          children: [
                            Container(
                              width: 32,
                              height: 32,
                              decoration: BoxDecoration(
                                color: Palette.primary.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Center(child: Icon(Icons.timer_outlined, size: 16, color: Palette.primary)),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    s.tag.isNotEmpty ? s.tag : 'Focus Session',
                                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Palette.textPrimary),
                                  ),
                                  Text(
                                    '${s.durationMinutes} min · +${s.xpEarned} XP',
                                    style: TextStyle(fontSize: 11, color: Palette.textSecondary),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      )).toList(),
                    ),
                  ),
                ).animate().fadeIn(delay: 400.ms),
              ),

            const SliverToBoxAdapter(child: SizedBox(height: 20)),

            // ── Leaderboard preview ──
            if (standingsAsync.valueOrNull != null && standingsAsync.valueOrNull!.isNotEmpty)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      SectionTitle('Leaderboard'),
                      const Spacer(),
                      GestureDetector(
                        onTap: () => context.push('/leagues'),
                        child: Text(
                          'View all',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Palette.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ).animate().fadeIn(delay: 420.ms),
              ),
            if (standingsAsync.valueOrNull != null && standingsAsync.valueOrNull!.isNotEmpty)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: GlassCard(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Column(
                      children: standingsAsync.valueOrNull!.take(3).toList().asMap().entries.map((entry) {
                        final i = entry.key;
                        final s = entry.value;
                        final isMe = s.profileId == profileId;
                        final medal = i == 0 ? '🥇' : i == 1 ? '🥈' : i == 2 ? '🥉' : '${i + 1}';
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 6),
                          child: Row(
                            children: [
                              SizedBox(
                                width: 28,
                                child: Text(
                                  medal,
                                  style: TextStyle(
                                    fontSize: i < 3 ? 16 : 13,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Container(
                                width: 28,
                                height: 28,
                                decoration: BoxDecoration(
                                  color: isMe ? Palette.primary.withValues(alpha: 0.15) : Palette.surface3,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Center(
                                  child: Text(
                                    isMe ? '🦉' : '👤',
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  isMe ? 'You' : s.profileId,
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: isMe ? FontWeight.w700 : FontWeight.w600,
                                    color: isMe ? Palette.primary : Palette.textPrimary,
                                  ),
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                  color: Palette.warning.withValues(alpha: 0.12),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  '${s.weeklyXp} XP',
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w700,
                                    color: Palette.warning,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ).animate().fadeIn(delay: 440.ms),
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

  String _greeting() {
    final hour = DateTime.now().hour;
    if (hour < 6) return 'Good night';
    if (hour < 12) return 'Good morning';
    if (hour < 17) return 'Good afternoon';
    return 'Good evening';
  }

  String _dailyTip() {
    final tips = [
      'Start your personal statement with a specific moment, not a general statement. "The smell of solder made me realize..." beats "I\'ve always been passionate about..."',
      'Show intellectual curiosity through what you read, watch, and explore — not just grades. Admissions officers want genuine thinkers.',
      'Your activities should tell a story. Depth in 2-3 areas beats shallow involvement in 10 clubs.',
      'Recommendation letters are most powerful when they include specific anecdotes. Give your teachers concrete examples of your work.',
      'Research each school\'s specific programs and mention them. Generic "I love your school" essays are red flags.',
      'The "Why This College" essay should be 70% about the school and 30% about you. Most students flip this ratio.',
      'Your resume should show progression — leadership roles, increasing responsibility, lasting impact.',
      'Don\'t underestimate community college transfer programs. They\'re a legitimate path to top universities.',
      'Interviews are conversations, not interrogations. Prepare 3-5 stories that showcase your growth and curiosity.',
      'Proofread everything. A single typo can undermine months of careful work.',
      'Start early. The Common App opens August 1 — use summer to draft essays before senior year crushes your schedule.',
      'Quality over quantity: 5 meaningful activities with clear impact beats 15 superficial memberships.',
    ];
    final dayOfYear = DateTime.now().difference(DateTime(DateTime.now().year)).inDays;
    return tips[dayOfYear % tips.length];
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
      onTap: () => HapticFeedback.lightImpact(),
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
          // Title + pillar tag.
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    pillar,
                    style: TextStyle(
                      color: color,
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
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

/// Quick action button for home page grid.
class _QuickAction extends StatelessWidget {
  const _QuickAction({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          HapticFeedback.lightImpact();
          onTap();
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: color.withValues(alpha: 0.2),
              width: 1,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: color, size: 22),
              const SizedBox(height: 6),
              Text(
                label,
                style: TextStyle(
                  color: color,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Streak milestone dot — shows progress toward streak goals.
class _MilestoneDot extends StatelessWidget {
  const _MilestoneDot({
    required this.reached,
    required this.label,
    required this.emoji,
  });

  final bool reached;
  final String label;
  final String emoji;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: reached
                  ? Palette.warning.withValues(alpha: 0.2)
                  : Palette.surface3,
              border: Border.all(
                color: reached ? Palette.warning : Palette.border,
                width: reached ? 2 : 1,
              ),
            ),
            child: Center(
              child: Text(
                reached ? emoji : label,
                style: TextStyle(fontSize: reached ? 14 : 10),
              ),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 9,
              fontWeight: FontWeight.w600,
              color: reached ? Palette.warning : Palette.textTertiary,
            ),
          ),
        ],
      ),
    );
  }
}

/// Streak milestone connector line.
class _MilestoneLine extends StatelessWidget {
  const _MilestoneLine({required this.reached});
  final bool reached;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        height: 2,
        margin: const EdgeInsets.only(bottom: 18),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: reached
                ? [Palette.warning, Palette.warning]
                : [Palette.surface3, Palette.surface3],
          ),
          borderRadius: BorderRadius.circular(1),
        ),
      ),
    );
  }
}

/// Profile completion indicator — shows onboarding progress.
class _ProfileCompletion extends ConsumerWidget {
  const _ProfileCompletion({required this.profileId});
  final String profileId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ob = ref.watch(onboardingProvider(profileId)).valueOrNull;
    final dark = isDark(context);
    
    // Calculate completion based on onboarding fields
    int completed = 0;
    int total = 5;
    if (ob != null) {
      if (ob.targetUniversities.isNotEmpty) completed++;
      if (ob.subjects.isNotEmpty) completed++;
      if (ob.activities.isNotEmpty) completed++;
      if (ob.budget > 0) completed++;
      if (ob.careerInterests.isNotEmpty) completed++;
    }
    
    final pct = total > 0 ? (completed / total * 100).round() : 0;
    
    // Don't show if fully complete
    if (pct >= 100) return const SizedBox.shrink();
    
    return GlassCard(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.account_circle_outlined,
                size: 16,
                color: Palette.accentBlue,
              ),
              const SizedBox(width: 8),
              Text(
                'Complete your profile',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Palette.textPrimary,
                ),
              ),
              const Spacer(),
              Text(
                '$pct%',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: Palette.accentBlue,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: pct / 100,
              minHeight: 6,
              backgroundColor: dark ? Palette.surface3 : const Color(0xFFE2E8F0),
              valueColor: AlwaysStoppedAnimation(Palette.accentBlue),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            '$completed of $total steps completed',
            style: TextStyle(
              fontSize: 11,
              color: Palette.textSecondary,
            ),
          ),
        ],
      ),
    ).animate().fadeIn(delay: 180.ms);
  }
}

/// Quick stat tile for home page — icon + value + label.
class _QuickStat extends StatelessWidget {
  const _QuickStat({
    required this.icon,
    required this.value,
    required this.label,
    required this.color,
  });

  final String icon;
  final String value;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final numericValue = int.tryParse(value) ?? 0;
    return Expanded(
      child: GlassCard(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: Column(
          children: [
            Text(icon, style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 4),
            AnimatedCounter(
              targetValue: numericValue,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: color,
              ),
            ),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w500,
                color: Palette.textTertiary,
              ),
            ),
          ],
        ),
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

/// Bottom nav item — with animated scale on tap.
class _NavItem extends StatefulWidget {
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
  State<_NavItem> createState() => _NavItemState();
}

class _NavItemState extends State<_NavItem> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: 150.ms);
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.85).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dark = isDark(context);
    return GestureDetector(
      onTap: () async {
        await _controller.forward();
        await _controller.reverse();
        widget.onTap();
      },
      behavior: HitTestBehavior.opaque,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: SizedBox(
          width: 64,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedContainer(
                duration: 200.ms,
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: widget.isSelected
                      ? Palette.primary.withValues(alpha: 0.12)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  widget.icon,
                  size: 22,
                  color: widget.isSelected
                      ? Palette.primary
                      : Palette.textTertiary,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                widget.label,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: widget.isSelected ? FontWeight.w700 : FontWeight.w500,
                  color: widget.isSelected
                      ? Palette.primary
                      : Palette.textTertiary,
                ),
              ),
            ],
          ),
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
