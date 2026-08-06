import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:profileforge/core/theme/app_theme.dart';

/// ────────────────────────────────────────────────────────────────────────────
/// AchievementsScreen — Display earned badges and milestones.
///
/// Features:
/// - Badge grid with locked/unlocked states
/// - Milestone progress bars
/// - Achievement categories
/// - Detailed achievement info on tap
/// ────────────────────────────────────────────────────────────────────────────
class AchievementsScreen extends StatelessWidget {
  const AchievementsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = isDark(context);

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: dark
                ? [const Color(0xFF0B1120), Palette.surface0, Palette.black]
                : [const Color(0xFFEEF2FF), const Color(0xFFF8FAFC), Colors.white],
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
                          color: dark ? Palette.surface2 : const Color(0xFFF1F5F9),
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
                      _buildStatsSummary(dark),
                      const SizedBox(height: 24),

                      // ── Recent Achievements ──
                      _buildSectionTitle('Recent Achievements', dark),
                      const SizedBox(height: 12),
                      _buildRecentAchievements(dark),
                      const SizedBox(height: 24),

                      // ── All Badges ──
                      _buildSectionTitle('All Badges', dark),
                      const SizedBox(height: 12),
                      _buildBadgeGrid(dark),
                      const SizedBox(height: 24),

                      // ── Milestones ──
                      _buildSectionTitle('Milestones', dark),
                      const SizedBox(height: 12),
                      _buildMilestones(dark),
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

  Widget _buildStatsSummary(bool dark) {
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
          _buildStatItem('12', 'Badges', Icons.emoji_events),
          _buildStatItem('3', 'Streak', Icons.local_fire_department),
          _buildStatItem('850', 'XP', Icons.star),
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
            fontWeight: FontWeight.w800,
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

  Widget _buildRecentAchievements(bool dark) {
    final recent = [
      _Achievement(
        icon: Icons.psychology,
        title: 'Mind Mapper',
        description: 'Completed psychology assessment',
        color: Palette.primary,
        earnedAt: 'Today',
      ),
      _Achievement(
        icon: Icons.school,
        title: 'First Step',
        description: 'Completed onboarding',
        color: Palette.success,
        earnedAt: 'Yesterday',
      ),
      _Achievement(
        icon: Icons.star,
        title: 'Profile Builder',
        description: 'Filled in 80% of profile',
        color: Palette.warning,
        earnedAt: '2 days ago',
      ),
    ];

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
              color: dark ? Palette.border : const Color(0xFFE2E8F0),
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
                child: Icon(achievement.icon, color: achievement.color, size: 24),
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

  Widget _buildBadgeGrid(bool dark) {
    final badges = [
      _Badge(icon: Icons.psychology, label: 'Mind Mapper', unlocked: true, color: Palette.primary),
      _Badge(icon: Icons.school, label: 'First Step', unlocked: true, color: Palette.success),
      _Badge(icon: Icons.star, label: 'Profile Builder', unlocked: true, color: Palette.warning),
      _Badge(icon: Icons.local_fire_department, label: 'On Fire', unlocked: true, color: Palette.error),
      _Badge(icon: Icons.emoji_events, label: 'Champion', unlocked: true, color: Palette.accentPink),
      _Badge(icon: Icons.auto_awesome, label: 'AI Whisperer', unlocked: false, color: Palette.info),
      _Badge(icon: Icons.trending_up, label: 'Rising Star', unlocked: false, color: Palette.primary),
      _Badge(icon: Icons.diamond, label: 'Diamond', unlocked: false, color: Palette.info),
      _Badge(icon: Icons.bolt, label: 'Speed Demon', unlocked: false, color: Palette.warning),
    ];

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
                  : const Color(0xFFF1F5F9).withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: badge.unlocked
                ? badge.color.withValues(alpha: 0.3)
                : (dark ? Palette.border.withValues(alpha: 0.3) : const Color(0xFFE2E8F0)),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              badge.icon,
              size: 32,
              color: badge.unlocked
                  ? badge.color
                  : dark
                      ? Palette.textTertiary.withValues(alpha: 0.5)
                      : Palette.textSecondary.withValues(alpha: 0.3),
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

  Widget _buildMilestones(bool dark) {
    final milestones = [
      _Milestone(title: 'Complete Profile', current: 80, total: 100, color: Palette.primary),
      _Milestone(title: 'First AI Chat', current: 0, total: 1, color: Palette.success),
      _Milestone(title: '7-Day Streak', current: 3, total: 7, color: Palette.warning),
      _Milestone(title: '10 Achievements', current: 3, total: 10, color: Palette.accentPink),
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
              color: dark ? Palette.border : const Color(0xFFE2E8F0),
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
                  backgroundColor: dark ? Palette.surface2 : const Color(0xFFE2E8F0),
                  valueColor: AlwaysStoppedAnimation(milestone.color),
                ),
              ),
            ],
          ),
        );
      }).toList(),
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
                child: Icon(badge.icon, size: 30, color: badge.color),
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
  final IconData icon;
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
  final IconData icon;
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
