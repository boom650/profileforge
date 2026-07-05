import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import 'micro_interactions.dart';

class StreakRing extends StatelessWidget {
  final int currentStreak;
  final int longestStreak;
  final int freezeTokens;
  final int maxFreezeTokens;
  final bool hasWeekendAmulet;
  final DateTime? weekendAmuletExpiresAt;
  final List<int> weeklyActivityPattern;
  final int freezeTokensEarned;
  final List<int> achievedMilestones;
  final VoidCallback? onCheckIn;

  const StreakRing({
    super.key,
    required this.currentStreak,
    required this.longestStreak,
    this.freezeTokens = 3,
    this.maxFreezeTokens = 5,
    this.hasWeekendAmulet = false,
    this.weekendAmuletExpiresAt,
    this.weeklyActivityPattern = const [],
    this.freezeTokensEarned = 0,
    this.achievedMilestones = const [],
    this.onCheckIn,
  });

  @override
  Widget build(BuildContext context) {
    final streakProgress = (currentStreak % 30) / 30.0;
    final nextMilestone = _getNextMilestone(currentStreak);
    final milestoneProgress = currentStreak > 0 
        ? (currentStreak - _getPreviousMilestone(currentStreak)) / 
          (nextMilestone - _getPreviousMilestone(currentStreak))
        : 0.0;
    
    final isWeekend = DateTime.now().weekday == 6 || DateTime.now().weekday == 7;
    final weekendAmuletActive = hasWeekendAmulet && 
        weekendAmuletExpiresAt != null && 
        weekendAmuletExpiresAt!.isAfter(DateTime.now());

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppTheme.surfaceWhite, AppTheme.surfaceLight],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppTheme.primaryBlue.withValues(alpha: 0.1)),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryBlue.withValues(alpha: 0.08),
            blurRadius: 24,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header with streak label and weekend amulet
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppTheme.primaryBlue, AppTheme.primaryBlueLight],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.primaryBlue.withValues(alpha: 0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const Icon(Icons.local_fire_department_rounded, color: Colors.white, size: 22),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Streak',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                  Text(
                    _getStreakTierLabel(currentStreak),
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.primaryBlue,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              // Weekend Amulet indicator
              if (weekendAmuletActive)
                _WeekendAmuletBadge(expiresAt: weekendAmuletExpiresAt!),
            ],
          ),
          const SizedBox(height: 20),
          
          // Main streak ring with milestone progress
          Stack(
            alignment: Alignment.center,
            children: [
              // Outer milestone progress ring
              SizedBox(
                width: 120,
                height: 120,
                child: CircularProgressIndicator(
                  value: milestoneProgress.clamp(0.0, 1.0),
                  strokeWidth: 8,
                  backgroundColor: AppTheme.primaryBlue.withValues(alpha: 0.08),
                  valueColor: AlwaysStoppedAnimation<Color>(
                    _getMilestoneColor(nextMilestone),
                  ),
                  strokeCap: StrokeCap.round,
                ),
              ),
              // Inner streak ring
              SizedBox(
                width: 90,
                height: 90,
                child: CircularProgressIndicator(
                  value: streakProgress,
                  strokeWidth: 6,
                  backgroundColor: AppTheme.primaryBlue.withValues(alpha: 0.1),
                  valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primaryBlue),
                  strokeCap: StrokeCap.round,
                ),
              ),
              // Center content
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CountingAnimation(
                    targetValue: currentStreak,
                    duration: const Duration(milliseconds: 1000),
                    builder: (context, currentValue) {
                      return Text(
                        '$currentValue',
                        style: GoogleFonts.inter(
                          fontSize: 36,
                          fontWeight: FontWeight.w900,
                          color: AppTheme.textPrimary,
                        ),
                      );
                    },
                  )
                  .animate()
                  .scale(duration: 600.ms, curve: Curves.elasticOut),
                  Text(
                    currentStreak == 1 ? 'day' : 'days',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: AppTheme.textMuted,
                    ),
                  ),
                  if (nextMilestone > currentStreak) ...[
                    const SizedBox(height: 4),
                    Text(
                      '${nextMilestone - currentStreak} to $nextMilestone 🏆',
                      style: GoogleFonts.inter(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: _getMilestoneColor(nextMilestone),
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
          
          // Weekly heatmap (GitHub-style)
          _WeeklyHeatmap(
            pattern: weeklyActivityPattern,
            currentStreak: currentStreak,
          ),
          const SizedBox(height: 20),
          
          // Stats row with freeze tokens, milestones
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _StreakStat(
                label: 'Longest',
                value: '$longestStreak',
                icon: Icons.emoji_events_rounded,
                color: AppTheme.accentGold,
                animate: true,
              ),
              _StreakStat(
                label: 'Freezes',
                value: '$freezeTokens/$maxFreezeTokens',
                icon: Icons.shield_rounded,
                color: AppTheme.successGreen,
                animate: true,
                subtitle: '+${freezeTokensEarned} earned',
              ),
              _StreakStat(
                label: 'Milestones',
                value: '${achievedMilestones.length}',
                icon: Icons.star_rounded,
                color: _getMilestoneColor(nextMilestone),
                animate: true,
                subtitle: 'Next: $nextMilestone days',
              ),
            ],
          ),
          // Check In button
          if (onCheckIn != null) ...[
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: onCheckIn,
                icon: const Icon(Icons.check_circle_rounded, size: 20),
                label: Text(
                  'Check In',
                  style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w600),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryBlue,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  elevation: 0,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  int _getPreviousMilestone(int streak) {
    final milestones = [3, 7, 14, 21, 30, 60, 90, 180, 365];
    for (int i = milestones.length - 1; i >= 0; i--) {
      if (streak >= milestones[i]) return milestones[i];
    }
    return 0;
  }

  int _getNextMilestone(int streak) {
    final milestones = [3, 7, 14, 21, 30, 60, 90, 180, 365];
    for (final m in milestones) {
      if (streak < m) return m;
    }
    return 365;
  }

  Color _getMilestoneColor(int milestone) {
    if (milestone >= 365) return AppTheme.accentGold;
    if (milestone >= 180) return AppTheme.primaryPurple;
    if (milestone >= 90) return AppTheme.primaryBlue;
    if (milestone >= 30) return AppTheme.successGreen;
    if (milestone >= 14) return AppTheme.accentOrange;
    if (milestone >= 7) return AppTheme.accentTeal;
    return AppTheme.primaryBlue;
  }

  String _getStreakTierLabel(int streak) {
    if (streak >= 365) return 'Legendary 🏆';
    if (streak >= 180) return 'Epic ⭐';
    if (streak >= 90) return 'Master 💎';
    if (streak >= 60) return 'Expert 💫';
    if (streak >= 30) return 'Pro 🌟';
    if (streak >= 21) return 'Habit Former 🌱';
    if (streak >= 14) return 'Consistent 🔥';
    if (streak >= 7) return 'Week Warrior ⚡';
    if (streak >= 3) return 'Getting Started 🌱';
    return 'Beginner';
  }
}

class _WeekendAmuletBadge extends StatelessWidget {
  final DateTime expiresAt;

  const _WeekendAmuletBadge({required this.expiresAt});

  @override
  Widget build(BuildContext context) {
    final hoursLeft = expiresAt.difference(DateTime.now()).inHours;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppTheme.accentGold, AppTheme.accentOrange],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppTheme.accentGold.withValues(alpha: 0.4),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.weekend_rounded, color: Colors.white, size: 14),
          const SizedBox(width: 4),
          Text(
            'Weekend Amulet',
            style: GoogleFonts.inter(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 4),
          Text(
            '${hoursLeft}h',
            style: GoogleFonts.inter(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: Colors.white.withValues(alpha: 0.9),
            ),
          ),
        ],
      ),
    ).animate()
      .fadeIn(duration: 400.ms)
      .slideY(begin: -0.2, end: 0);
  }
}

class _WeeklyHeatmap extends StatelessWidget {
  final List<int> pattern;
  final int currentStreak;

  const _WeeklyHeatmap({
    required this.pattern,
    required this.currentStreak,
  });

  @override
  Widget build(BuildContext context) {
    final days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    final maxCount = pattern.reduce((a, b) => a > b ? a : b);
    final todayIndex = DateTime.now().weekday - 1; // 0 = Monday

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Weekly Activity',
          style: GoogleFonts.inter(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: AppTheme.textSecondary,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: List.generate(7, (i) {
            final count = pattern[i];
            final intensity = maxCount > 0 ? count / maxCount : 0.0;
            final isToday = i == todayIndex;
            final isFuture = i > todayIndex;
            final isStreakDay = currentStreak > 0 && 
                (DateTime.now().subtract(Duration(days: currentStreak)).weekday - 1) <= i;

            return Column(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: _getHeatmapColor(intensity, isFuture, isToday, isStreakDay),
                    border: isToday 
                        ? Border.all(color: AppTheme.primaryBlue, width: 2.5)
                        : null,
                    boxShadow: isToday ? [
                      BoxShadow(
                        color: AppTheme.primaryBlue.withValues(alpha: 0.4),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ] : null,
                  ),
                  child: Center(
                    child: count > 0
                        ? Text(
                            '$count',
                            style: GoogleFonts.inter(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: intensity > 0.5 ? Colors.white : AppTheme.textPrimary,
                            ),
                          )
                        : Icon(
                            isFuture ? Icons.lock_clock_rounded : Icons.circle_outlined,
                            size: 14,
                            color: intensity > 0.5 ? Colors.white.withValues(alpha: 0.7) : AppTheme.textMuted,
                          ),
                  ),
                )
                .animate()
                .scale(
                  delay: (i * 50).ms,
                  duration: 400.ms,
                  curve: Curves.elasticOut,
                ),
                const SizedBox(height: 4),
                Text(
                  days[i],
                  style: GoogleFonts.inter(
                    fontSize: 9,
                    fontWeight: isToday ? FontWeight.w700 : FontWeight.w400,
                    color: isToday ? AppTheme.primaryBlue : AppTheme.textMuted,
                  ),
                ),
              ],
            );
          }),
        ),
      ],
    );
  }

  Color _getHeatmapColor(double intensity, bool isFuture, bool isToday, bool isStreakDay) {
    if (isFuture) {
      return AppTheme.surfaceLight.withValues(alpha: 0.5);
    }
    if (intensity == 0) {
      return isStreakDay 
          ? AppTheme.primaryBlue.withValues(alpha: 0.15)
          : AppTheme.surfaceLight;
    }
    if (intensity <= 0.33) {
      return AppTheme.primaryBlue.withValues(alpha: 0.2 + intensity * 0.3);
    }
    if (intensity <= 0.66) {
      return AppTheme.primaryBlue.withValues(alpha: 0.5 + intensity * 0.2);
    }
    return AppTheme.primaryBlue;
  }
}

class _StreakStat extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;
  final bool animate;
  final String? subtitle;

  const _StreakStat({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
    this.animate = false,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    Widget content = Column(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [color.withValues(alpha: 0.15), color.withValues(alpha: 0.05)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: color.withValues(alpha: 0.2)),
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: GoogleFonts.inter(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: AppTheme.textPrimary,
          ),
        ),
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 10,
            fontWeight: FontWeight.w500,
            color: AppTheme.textMuted,
          ),
        ),
        if (subtitle != null) ...[
          const SizedBox(height: 2),
          Text(
            subtitle!,
            style: GoogleFonts.inter(
              fontSize: 9,
              fontWeight: FontWeight.w500,
              color: color,
            ),
          ),
        ],
      ],
    );

    if (animate) {
      return content
          .animate()
          .fadeIn(duration: 500.ms, delay: 200.ms)
          .slideY(begin: 0.2, end: 0, curve: Curves.easeOutCubic);
    }
    return content;
  }
}