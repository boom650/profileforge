import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/app_theme.dart';
import '../../models/gamification/skins.dart';

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
          Text(
            'Your Personalized\nRoadmap',
            style: GoogleFonts.inter(
              fontSize: 32,
              fontWeight: FontWeight.w700,
              color: AppTheme.textPrimary,
              letterSpacing: -0.5,
              height: 1.2,
            ),
          ).animate().fadeIn().slideX(begin: -0.2),
          const SizedBox(height: 8),
          Text(
            'Based on your profile — here\'s where you stand and where you\'re going',
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: AppTheme.textSecondary,
            ),
          ).animate().fadeIn(delay: 100.ms).slideX(begin: -0.2),
          const SizedBox(height: 32),
          // Admissions Probability Baseline
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppTheme.surfaceDark, const Color(0xFF1E293B)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.primaryBlue.withValues(alpha: 0.2),
                  blurRadius: 30,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryBlue.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(Icons.analytics_rounded, color: AppTheme.primaryBlueLight, size: 24),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'ADMISSIONS PROBABILITY BASELINE',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.textMuted,
                        letterSpacing: 1,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                _ProbabilityRow(
                  university: 'MIT',
                  major: 'Computer Science',
                  country: 'US',
                  current: 0.12,
                  target: 0.50,
                  color: const Color(0xFF8B5CF6),
                ),
                _ProbabilityRow(
                  university: 'Stanford',
                  major: 'Computer Science',
                  country: 'US',
                  current: 0.08,
                  target: 0.45,
                  color: const Color(0xFF8B5CF6),
                ),
                _ProbabilityRow(
                  university: 'Harvard',
                  major: 'Computer Science',
                  country: 'US',
                  current: 0.06,
                  target: 0.40,
                  color: const Color(0xFF8B5CF6),
                ),
                _ProbabilityRow(
                  university: 'UCLA',
                  major: 'Computer Science',
                  country: 'US',
                  current: 0.34,
                  target: 0.65,
                  color: const Color(0xFF3B82F6),
                ),
                _ProbabilityRow(
                  university: 'UCSD',
                  major: 'Computer Science',
                  country: 'US',
                  current: 0.42,
                  target: 0.70,
                  color: const Color(0xFF3B82F6),
                ),
                _ProbabilityRow(
                  university: 'UMass Amherst',
                  major: 'Computer Science',
                  country: 'US',
                  current: 0.67,
                  target: 0.85,
                  color: const Color(0xFF10B981),
                ),
              ],
            ),
          ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.2),
          const SizedBox(height: 24),
          // Profile Radar
          Text(
            'YOUR PROFILE RADAR',
            style: GoogleFonts.inter(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppTheme.textMuted,
              letterSpacing: 1,
            ),
          ).animate().fadeIn(delay: 400.ms),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppTheme.surfaceWhite,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppTheme.primaryBlue.withValues(alpha: 0.1)),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.primaryBlue.withValues(alpha: 0.05),
                  blurRadius: 20,
                  offset: const Offset(0, 4),
                ),
              ],
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
                  color: const Color(0xFF8B5CF6),
                  isGap: true,
                ),
                _RadarBar(
                  label: 'Leadership',
                  icon: Icons.people_rounded,
                  value: 0.40,
                  color: const Color(0xFFEF4444),
                  isGap: false,
                ),
                _RadarBar(
                  label: 'Service',
                  icon: Icons.volunteer_activism_rounded,
                  value: 0.50,
                  color: const Color(0xFF10B981),
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
          ).animate().fadeIn(delay: 500.ms).slideY(begin: 0.2),
          const SizedBox(height: 24),
          // Starter Skin Unlocked
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color(0xFF4A90D9).withValues(alpha: 0.2),
                  const Color(0xFF2E6DA4).withValues(alpha: 0.1),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0xFF4A90D9).withValues(alpha: 0.3)),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Icon(Icons.emoji_events_rounded, color: const Color(0xFF4A90D9), size: 24),
                    const SizedBox(width: 12),
                    Text(
                      'STARTER SKIN UNLOCKED',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF4A90D9),
                        letterSpacing: 1,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: const Color(0xFF4A90D9).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: const Color(0xFF4A90D9).withValues(alpha: 0.3)),
                      ),
                      child: Icon(Icons.explore_rounded, color: const Color(0xFF4A90D9), size: 40),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Academic Explorer',
                            style: GoogleFonts.inter(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              color: AppTheme.textPrimary,
                            ),
                          ),
                          Text(
                            'First steps into academic exploration.\nCuriosity sparked.',
                            style: GoogleFonts.inter(
                              fontSize: 13,
                              color: AppTheme.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  'Next: Scholar skin at 500 Academics XP',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF4A90D9),
                  ),
                ),
              ],
            ),
          ).animate().fadeIn(delay: 700.ms).slideY(begin: 0.2).scale(delay: 900.ms, curve: Curves.elasticOut),
          const SizedBox(height: 32),
          // What happens next
          Text(
            'WHAT HAPPENS NEXT',
            style: GoogleFonts.inter(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppTheme.textMuted,
              letterSpacing: 1,
            ),
          ).animate().fadeIn(delay: 800.ms),
          const SizedBox(height: 16),
          Column(
            children: [
              _NextStep(
                number: '1',
                title: 'Sunday Mission Briefing',
                subtitle: 'Personalized weekly missions delivered every Sunday 10 PM',
                icon: Icons.calendar_today_rounded,
                color: AppTheme.primaryBlue,
              ),
              _NextStep(
                number: '2',
                title: 'Daily Nudges',
                subtitle: 'Gentle reminders synced to your schedule — never during coaching',
                icon: Icons.notifications_rounded,
                color: const Color(0xFF8B5CF6),
              ),
              _NextStep(
                number: '3',
                title: 'Evidence Wizard',
                subtitle: 'Photo + reflection + teacher verification = admissions-ready proof',
                icon: Icons.verified_rounded,
                color: const Color(0xFF10B981),
              ),
              _NextStep(
                number: '4',
                title: 'Probability Updates',
                subtitle: 'Monte Carlo re-runs weekly — watch your odds climb',
                icon: Icons.trending_up_rounded,
                color: const Color(0xFFF59E0B),
              ),
            ],
          ).animate().fadeIn(delay: 900.ms).slideY(begin: 0.1),
        ],
      ),
    );
  }
}

class _ProbabilityRow extends StatelessWidget {
  final String university;
  final String major;
  final String country;
  final double current;
  final double target;
  final Color color;

  const _ProbabilityRow({
    required this.university,
    required this.major,
    required this.country,
    required this.current,
    required this.target,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                university,
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '$major • $country',
                style: GoogleFonts.inter(
                  fontSize: 11,
                  color: Colors.white.withValues(alpha: 0.6),
                ),
              ),
              const Spacer(),
              Text(
                '${(current * 100).toInt()}%',
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: color,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Stack(
            children: [
              Container(
                height: 6,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
              FractionallySizedBox(
                widthFactor: current,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [color.withValues(alpha: 0.6), color],
                    ),
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
              ),
              FractionallySizedBox(
                widthFactor: target,
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Container(
                    width: 2,
                    height: 10,
                    decoration: BoxDecoration(
                      color: AppTheme.accentGold,
                      borderRadius: BorderRadius.circular(1),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                'Target: ${(target * 100).toInt()}%',
                style: GoogleFonts.inter(
                  fontSize: 10,
                  color: AppTheme.accentGold,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

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
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 18),
          ),
          const SizedBox(width: 12),
          SizedBox(
            width: 70,
            child: Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 13,
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
          const SizedBox(width: 12),
          Text(
            '${(value * 100).toInt()}%',
            style: GoogleFonts.inter(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: isGap ? AppTheme.errorRed : color,
            ),
          ),
          if (isGap) ...[
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: AppTheme.errorRed.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                'BIGGEST GAP',
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

class _NextStep extends StatelessWidget {
  final String number;
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;

  const _NextStep({
    required this.number,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text(
                number,
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.inter(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textPrimary,
                  ),
                ),
                Text(
                  subtitle,
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: AppTheme.textMuted,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}