import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:profileforge/core/application/session_provider.dart';
import 'package:profileforge/core/rate_app/rate_app_service.dart';
import 'package:profileforge/core/theme/app_theme.dart';
import 'package:profileforge/features/achievements/application/achievement_providers.dart';
import 'package:profileforge/features/achievements/domain/achievement_defs.dart';
import 'package:profileforge/features/streak/application/streak_providers.dart';
import 'package:profileforge/features/xp/application/xp_providers.dart';

/// ────────────────────────────────────────────────────────────────────────────
/// AchievementsScreen — Display earned badges and milestones.
///
/// Features:
/// - Badge grid with locked/unlocked states (REAL defs × unlocks)
/// - Milestone progress bars (REAL streak / XP / chat / badge totals)
/// - Achievement categories
/// - Detailed achievement info on tap
///
/// ALL numbers come from the real ledger — no hardcoded '12'/'3'/'850'.
/// ────────────────────────────────────────────────────────────────────────────
class AchievementsScreen extends ConsumerWidget {
  const AchievementsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dark = isDark(context);
    final profileId = ref.watch(activeProfileIdProvider).valueOrNull ?? '';
    final defsAsync = ref.watch(achievementDefsProvider);
    final unlockedAsync = ref.watch(unlockedAchievementIdsProvider(profileId));
    final streakAsync = ref.watch(streakProvider(profileId));
    final xpAsync = ref.watch(totalXpProvider(profileId));

    return defsAsync.when(
      loading: () => const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (e, s) => Scaffold(body: Center(child: Text('Failed to load achievements'))),
      data: (defs) => unlockedAsync.when(
        loading: () => const Scaffold(body: Center(child: CircularProgressIndicator())),
        error: (e, s) => Scaffold(body: Center(child: Text('Failed to load achievements'))),
        data: (unlocked) {
          final badgeCount = unlocked.length;
          final streak = streakAsync.valueOrNull?.current ?? 0;
          final xp = xpAsync.valueOrNull ?? 0;
          final chatCountAsync = RateAppService.instance.chatCount();

          return _buildScaffold(
            context,
            dark,
            defs: defs,
            unlocked: unlocked,
            badgeCount: badgeCount,
            streak: streak,
            xp: xp,
            chatCountAsync: chatCountAsync,
          );
        },
      ),
    );
  }

  Widget _buildScaffold(
    BuildContext context,
    bool dark, {
    required List<AchievementDef> defs,
    required Set<String> unlocked,
    required int badgeCount,
    required int streak,
    required int xp,
    required Future<int> chatCountAsync,
  }) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: dark
                ? [const Color(0xFF1A0F0A), Palette.surface0, Palette.black]
                : [const Color(0xFFFBF1E3), Palette.cream, Palette.creamCard],
          ),
        ),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Header ──
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: dark ? Palette.surface2 : const Color(0xFFF4ECE1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          Icons.arrow_back_ios_new,
                          size: 16,
                          color: dark ? Palette.textPrimary : Palette.textInverse,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Achievements',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: dark ? Palette.textPrimary : Palette.textInverse,
                      ),
                    ),
                  ],
                ),
              ),

              // ── Content ──
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 8),

                      // ── Stats Summary ──
                      _buildStatsSummary(dark, badgeCount, streak, xp),
                      const SizedBox(height: 24),

                      // ── Recent Achievements ──
                      _buildSectionTitle('Recent Achievements', dark),
                      const SizedBox(height: 12),
                      _buildRecentAchievements(dark, defs, unlocked),
                      const SizedBox(height: 24),

                      // ── All Badges ──
                      _buildSectionTitle('All Badges', dark),
                      const SizedBox(height: 12),
                      _buildBadgeGrid(dark, defs, unlocked),
                      const SizedBox(height: 24),

                      // ── Milestones ──
                      _buildSectionTitle('Milestones', dark),
                      const SizedBox(height: 12),
                      _buildMilestones(dark, streak, xp, chatCountAsync, badgeCount),
                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatsSummary(bool dark, int badges, int streak, int xp) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: Palette.gradientPrimary,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Palette.primary.withValues(alpha: 0.3),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem('$badges', 'Badges', Icons.emoji_events),
          _buildStatItem('$streak', 'Streak', Icons.local_fire_department),
          _buildStatItem('$xp', 'XP', Icons.star),
        ],
      ),
    );
  }

  Widget _buildStatItem(String value, String label, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: Colors.white.withValues(alpha: 0.8), size: 24),
        const SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.white.withValues(alpha: 0.7),
          ),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title, bool dark) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w700,
        color: dark ? Palette.textPrimary : Palette.textInverse,
      ),
    );
  }

  Widget _buildRecentAchievements(
      bool dark, List<AchievementDef> defs, Set<String> unlocked) {
    // REAL unlocked badges (newest unlock = first in grid order preserved).
    final recentDefs = defs.where((d) => unlocked.contains(d.id)).take(3).toList();
    if (recentDefs.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 12),
        child: Text(
          'No badges unlocked yet — complete missions, keep streaks and chat with the AI to earn your first one.',
          style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic),
        ),
      );
    }
    final recent = recentDefs
        .map((d) => _Achievement(
              icon: d.icon,
              title: d.name,
              description: d.description,
              color: Palette.primary,
              earnedAt: 'Unlocked',
            ))
        .toList();

    return Column(
      children: recent.map((achievement) {
        return Container(
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: dark
                ? Palette.surface1.withValues(alpha: 0.7)
                : Colors.white.withValues(alpha: 0.8),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: dark ? Palette.border : const Color(0xFFEDE3D6),
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: achievement.color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(achievement.icon,
                      style: const TextStyle(fontSize: 24)),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      achievement.title,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: dark ? Palette.textPrimary : Palette.textInverse,
                      ),
                    ),
                    Text(
                      achievement.description,
                      style: TextStyle(
                        fontSize: 12,
                        color: dark ? Palette.textSecondary : Palette.textTertiary,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                achievement.earnedAt,
                style: TextStyle(
                  fontSize: 11,
                  color: Palette.textTertiary,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildBadgeGrid(
      bool dark, List<AchievementDef> defs, Set<String> unlocked) {
    final badges = defs
        .map((d) => _Badge(
              icon: d.icon,
              label: d.name,
              unlocked: unlocked.contains(d.id),
              color: Palette.primary,
            ))
        .toList();

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 0.85,
      ),
      itemCount: badges.length,
      itemBuilder: (context, index) {
        final badge = badges[index];
        return _buildBadgeItem(context, badge, dark);
      },
    );
  }

  Widget _buildBadgeItem(BuildContext context, _Badge badge, bool dark) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.selectionClick();
        _showBadgeDetail(context, badge, dark);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: badge.unlocked
              ? badge.color.withValues(alpha: 0.08)
              : dark
                  ? Palette.surface2.withValues(alpha: 0.3)
                  : const Color(0xFFF4ECE1).withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: badge.unlocked
                ? badge.color.withValues(alpha: 0.3)
                : (dark ? Palette.border.withValues(alpha: 0.3) : const Color(0xFFEDE3D6)),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              badge.icon,
              style: TextStyle(
                fontSize: 32,
                color: badge.unlocked
                    ? badge.color
                    : dark
                        ? Palette.textTertiary.withValues(alpha: 0.5)
                        : Palette.textSecondary.withValues(alpha: 0.3),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              badge.label,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: badge.unlocked
                    ? (dark ? Palette.textPrimary : Palette.textInverse)
                    : Palette.textTertiary.withValues(alpha: 0.5),
              ),
            ),
            if (!badge.unlocked)
              Icon(
                Icons.lock,
                size: 12,
                color: Palette.textTertiary.withValues(alpha: 0.5),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildMilestones(bool dark, int streak, int xp, Future<int> chatCountAsync, int badges) {
    return FutureBuilder<int>(
      future: chatCountAsync,
      builder: (context, snap) {
        final chatCount = snap.data ?? 0;
        final milestones = [
          _Milestone(title: 'Achievements Earned', current: badges, total: AchievementDef.all.length, color: Palette.primary),
          _Milestone(title: 'Day Streak', current: streak, total: 7, color: Palette.warning),
          _Milestone(title: 'Total XP', current: xp, total: 1000, color: Palette.success),
          _Milestone(title: 'AI Chats', current: chatCount, total: 10, color: Palette.accentPink),
        ];

    return Column(
      children: milestones.map((milestone) {
        final progress = milestone.current / milestone.total;

        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: dark
                ? Palette.surface1.withValues(alpha: 0.7)
                : Colors.white.withValues(alpha: 0.8),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: dark ? Palette.border : const Color(0xFFEDE3D6),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    milestone.title,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: dark ? Palette.textPrimary : Palette.textInverse,
                    ),
                  ),
                  Text(
                    '${milestone.current}/${milestone.total}',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: milestone.color,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: progress,
                  minHeight: 6,
                  backgroundColor: dark ? Palette.surface2 : const Color(0xFFEDE3D6),
                  valueColor: AlwaysStoppedAnimation(milestone.color),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
      },
    );
  }

  void _showBadgeDetail(BuildContext context, _Badge badge, bool dark) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: dark ? Palette.surface1 : Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: badge.color.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: Text(
                  badge.icon,
                  style: TextStyle(fontSize: 30, color: badge.color),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                badge.label,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: dark ? Palette.textPrimary : Palette.textInverse,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                badge.unlocked ? 'Achievement Unlocked!' : 'Keep working to unlock this badge',
                style: TextStyle(
                  fontSize: 14,
                  color: dark ? Palette.textSecondary : Palette.textTertiary,
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        );
      },
    );
  }
}

class _Achievement {
  final String icon;
  final String title;
  final String description;
  final Color color;
  final String earnedAt;

  const _Achievement({
    required this.icon,
    required this.title,
    required this.description,
    required this.color,
    required this.earnedAt,
  });
}

class _Badge {
  final String icon;
  final String label;
  final bool unlocked;
  final Color color;

  const _Badge({
    required this.icon,
    required this.label,
    required this.unlocked,
    required this.color,
  });
}

class _Milestone {
  final String title;
  final int current;
  final int total;
  final Color color;

  const _Milestone({
    required this.title,
    required this.current,
    required this.total,
    required this.color,
  });
}
