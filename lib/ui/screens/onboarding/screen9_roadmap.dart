import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/app_theme.dart';
import '../../../models/gamification/skins.dart';

class Screen9Roadmap extends StatelessWidget {
  const Screen9Roadmap({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 40),
          // Header
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  gradient: AppTheme.gradientSuccess,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.celebration_rounded, color: Colors.white, size: 22),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Your Roadmap',
                      style: GoogleFonts.inter(
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                        color: AppTheme.textPrimary,
                        letterSpacing: -0.5,
                        height: 1.2,
                      ),
                    ),
                    Text(
                      'Here\'s your personalized journey to top universities',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: AppTheme.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ).animate().fadeIn().slideX(begin: -0.2),
          const SizedBox(height: 24),

          // ── Starter Skin Unlocked ─────────────────────────────────────
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const AppTheme.categoryBlue.withValues(alpha: 0.15),
                  const Color(0xFF2E6DA4).withValues(alpha: 0.05),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const AppTheme.categoryBlue.withValues(alpha: 0.25)),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Icon(Icons.emoji_events_rounded, color: const AppTheme.categoryBlue, size: 22),
                    const SizedBox(width: 8),
                    Text(
                      'STARTER SKIN UNLOCKED',
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: const AppTheme.categoryBlue,
                        letterSpacing: 1,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        color: const AppTheme.categoryBlue.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: const AppTheme.categoryBlue.withValues(alpha: 0.25)),
                      ),
                      child: Icon(Icons.explore_rounded, color: const AppTheme.categoryBlue, size: 32),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Academic Explorer',
                            style: GoogleFonts.inter(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: AppTheme.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'First steps into academic exploration.',
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              color: AppTheme.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.2).scale(delay: 400.ms, curve: Curves.elasticOut),
          const SizedBox(height: 20),

          // ── YOUR JOURNEY TIMELINE ─────────────────────────────────────
          Text(
            'YOUR JOURNEY TIMELINE',
            style: GoogleFonts.inter(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: AppTheme.textMuted,
              letterSpacing: 1.2,
            ),
          ).animate().fadeIn(delay: 500.ms),
          const SizedBox(height: 14),

          // Timeline items
          _TimelineItem(
            number: '0',
            title: 'Onboarding Complete',
            subtitle: 'You\'ve built your student profile',
            icon: Icons.check_circle_rounded,
            color: AppTheme.successGreen,
            isCompleted: true,
            delay: 550,
          ),
          _TimelineConnector(isCompleted: true, delay: 580),
          _TimelineItem(
            number: '1',
            title: 'Week 1 — Foundation Missions',
            subtitle: 'Club enrollment, teacher intro letters, first research idea',
            icon: Icons.foundation_rounded,
            color: AppTheme.primaryBlue,
            isCompleted: false,
            delay: 620,
          ),
          _TimelineConnector(isCompleted: false, delay: 650),
          _TimelineItem(
            number: '2',
            title: 'Week 2-4 — Build Your Spike',
            subtitle: 'Deep dive into research, competitions, or leadership roles',
            icon: Icons.trending_up_rounded,
            color: AppTheme.primaryPurple,
            isCompleted: false,
            delay: 700,
          ),
          _TimelineConnector(isCompleted: false, delay: 730),
          _TimelineItem(
            number: '3',
            title: 'Month 2 — Evidence Collection',
            subtitle: 'Photo proofs, reflections, teacher verifications',
            icon: Icons.verified_rounded,
            color: AppTheme.accentGold,
            isCompleted: false,
            delay: 780,
          ),
          _TimelineConnector(isCompleted: false, delay: 810),
          _TimelineItem(
            number: '4',
            title: 'Month 3-6 — Application Sprint',
            subtitle: 'Essay drafts, recommendation requests, final probability push',
            icon: Icons.rocket_launch_rounded,
            color: AppTheme.accentOrange,
            isCompleted: false,
            delay: 860,
          ),
          _TimelineConnector(isCompleted: false, delay: 890),
          _TimelineItem(
            number: '5',
            title: 'Decision Day',
            subtitle: 'Acceptances, waitlists, and your next chapter',
            icon: Icons.celebration_rounded,
            color: AppTheme.successGreen,
            isCompleted: false,
            delay: 940,
          ),
          const SizedBox(height: 24),

          // ── Profile Radar ─────────────────────────────────────────────
          Text(
            'YOUR PROFILE RADAR',
            style: GoogleFonts.inter(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: AppTheme.textMuted,
              letterSpacing: 1.2,
            ),
          ).animate().fadeIn(delay: 980.ms),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: context.surfaceElevated,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppTheme.primaryBlue.withValues(alpha: 0.1)),
            ),
            child: Column(
              children: [
                _RadarBar(
                  label: 'Academic',
                  icon: Icons.school_rounded,
                  value: 0.80,
                  color: AppTheme.primaryBlue,
                  isGap: false,
                ),
                _RadarBar(
                  label: 'Research',
                  icon: Icons.science_rounded,
                  value: 0.05,
                  color: const AppTheme.categoryViolet,
                  isGap: true,
                ),
                _RadarBar(
                  label: 'Leadership',
                  icon: Icons.people_rounded,
                  value: 0.40,
                  color: const AppTheme.categoryRed,
                  isGap: false,
                ),
                _RadarBar(
                  label: 'Service',
                  icon: Icons.volunteer_activism_rounded,
                  value: 0.50,
                  color: const AppTheme.categoryEmerald,
                  isGap: false,
                ),
                _RadarBar(
                  label: 'Creative',
                  icon: Icons.palette_rounded,
                  value: 0.30,
                  color: const Color(0xFFF59E0B),
                  isGap: false,
                ),
              ],
            ),
          ).animate().fadeIn(delay: 1050.ms).slideY(begin: 0.1),
          const SizedBox(height: 24),

          // ── Weekly Mission Preview ────────────────────────────────────
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              gradient: AppTheme.gradientPrimary,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.auto_awesome_rounded, color: Colors.white.withValues(alpha: 0.9), size: 20),
                    const SizedBox(width: 8),
                    Text(
                      'WHAT HAPPENS NEXT',
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: Colors.white.withValues(alpha: 0.7),
                        letterSpacing: 1.2,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                _NextStepItem(
                  icon: Icons.calendar_today_rounded,
                  text: 'Sunday Mission Briefing — personalized weekly missions delivered at 10 PM',
                ),
                const SizedBox(height: 8),
                _NextStepItem(
                  icon: Icons.notifications_rounded,
                  text: 'Daily Nudges — gentle reminders synced to your schedule',
                ),
                const SizedBox(height: 8),
                _NextStepItem(
                  icon: Icons.verified_rounded,
                  text: 'Evidence Wizard — photo + reflection + teacher verification',
                ),
                const SizedBox(height: 8),
                _NextStepItem(
                  icon: Icons.trending_up_rounded,
                  text: 'Probability Updates — watch your odds climb weekly',
                ),
              ],
            ),
          ).animate().fadeIn(delay: 1150.ms).slideY(begin: 0.2),
          const SizedBox(height: 24),

          // ── Unlock More Skins ─────────────────────────────────────────
          Text(
            'SKIN UNLOCKS',
            style: GoogleFonts.inter(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: AppTheme.textMuted,
              letterSpacing: 1.2,
            ),
          ).animate().fadeIn(delay: 1250.ms),
          const SizedBox(height: 12),
          Row(
            children: [
              _SkinPreview(
                icon: Icons.explore_rounded,
                name: 'Explorer',
                xp: '500',
                color: const AppTheme.categoryBlue,
                isUnlocked: true,
                delay: 1300,
              ),
              const SizedBox(width: 8),
              _SkinPreview(
                icon: Icons.science_rounded,
                name: 'Scholar',
                xp: '1000',
                color: const AppTheme.categoryViolet,
                isUnlocked: false,
                delay: 1350,
              ),
              const SizedBox(width: 8),
              _SkinPreview(
                icon: Icons.psychology_rounded,
                name: 'Leader',
                xp: '2500',
                color: const AppTheme.categoryRed,
                isUnlocked: false,
                delay: 1400,
              ),
            ],
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}

// ── Timeline Components ─────────────────────────────────────────────────────

class _TimelineItem extends StatelessWidget {
  final String number;
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final bool isCompleted;
  final int delay;

  const _TimelineItem({
    required this.number,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.isCompleted,
    required this.delay,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Timeline dot
        Column(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: isCompleted ? color : color.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(8),
                border: isCompleted ? null : Border.all(color: color.withValues(alpha: 0.3)),
              ),
              child: Icon(
                isCompleted ? Icons.check_rounded : icon,
                color: isCompleted ? Colors.white : color,
                size: 16,
              ),
            ),
          ],
        ),
        const SizedBox(width: 14),
        // Content
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isCompleted
                  ? color.withValues(alpha: 0.05)
                  : context.surfaceElevated,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isCompleted
                    ? color.withValues(alpha: 0.2)
                    : AppTheme.textMuted.withValues(alpha: 0.1),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: isCompleted ? color : AppTheme.textPrimary,
                      ),
                    ),
                    if (isCompleted) ...[
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: color.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          'DONE',
                          style: GoogleFonts.inter(
                            fontSize: 9,
                            fontWeight: FontWeight.w700,
                            color: color,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 3),
                Text(
                  subtitle,
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    color: AppTheme.textSecondary,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    )
        .animate()
        .fadeIn(delay: Duration(milliseconds: delay))
        .slideX(begin: 0.1);
  }
}

class _TimelineConnector extends StatelessWidget {
  final bool isCompleted;
  final int delay;

  const _TimelineConnector({required this.isCompleted, required this.delay});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 15),
      child: Container(
        width: 2,
        height: 16,
        decoration: BoxDecoration(
          color: isCompleted
              ? AppTheme.successGreen
              : AppTheme.textMuted.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(1),
        ),
      ).animate().fadeIn(delay: Duration(milliseconds: delay)),
    );
  }
}

// ── Next Step Item ──────────────────────────────────────────────────────────

class _NextStepItem extends StatelessWidget {
  final IconData icon;
  final String text;

  const _NextStepItem({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: Colors.white.withValues(alpha: 0.6), size: 16),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            text,
            style: GoogleFonts.inter(
              fontSize: 12,
              color: Colors.white.withValues(alpha: 0.8),
              height: 1.4,
            ),
          ),
        ),
      ],
    );
  }
}

// ── Skin Preview ────────────────────────────────────────────────────────────

class _SkinPreview extends StatelessWidget {
  final IconData icon;
  final String name;
  final String xp;
  final Color color;
  final bool isUnlocked;
  final int delay;

  const _SkinPreview({
    required this.icon,
    required this.name,
    required this.xp,
    required this.color,
    required this.isUnlocked,
    required this.delay,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isUnlocked
              ? color.withValues(alpha: 0.08)
              : AppTheme.surfaceLight,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isUnlocked
                ? color.withValues(alpha: 0.25)
                : AppTheme.textMuted.withValues(alpha: 0.1),
          ),
        ),
        child: Column(
          children: [
            Opacity(
              opacity: isUnlocked ? 1.0 : 0.4,
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(height: 6),
            Text(
              name,
              style: GoogleFonts.inter(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: isUnlocked ? color : AppTheme.textMuted,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              '$xp XP',
              style: GoogleFonts.inter(
                fontSize: 10,
                color: AppTheme.textMuted,
              ),
            ),
            if (!isUnlocked) ...[
              const SizedBox(height: 4),
              Icon(Icons.lock_rounded, color: AppTheme.textMuted, size: 10),
            ],
          ],
        ),
      ),
    ).animate().fadeIn(delay: Duration(milliseconds: delay));
  }
}

// ── Radar Bar ───────────────────────────────────────────────────────────────

class _RadarBar extends StatelessWidget {
  final String label;
  final IconData icon;
  final double value;
  final Color color;
  final bool isGap;

  const _RadarBar({
    required this.label,
    required this.icon,
    required this.value,
    required this.color,
    required this.isGap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 16),
          ),
          const SizedBox(width: 10),
          SizedBox(
            width: 64,
            child: Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: AppTheme.textPrimary,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Stack(
              children: [
                Container(
                  height: 8,
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                FractionallySizedBox(
                  widthFactor: value,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [color.withValues(alpha: 0.6), color],
                      ),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Text(
            '${(value * 100).toInt()}%',
            style: GoogleFonts.inter(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: isGap ? AppTheme.errorRed : color,
            ),
          ),
          if (isGap) ...[
            const SizedBox(width: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: AppTheme.errorRed.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                'GAP',
                style: GoogleFonts.inter(
                  fontSize: 8,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.errorRed,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
