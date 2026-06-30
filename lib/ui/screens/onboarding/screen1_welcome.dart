import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/app_theme.dart';

class Screen1Welcome extends StatelessWidget {
  const Screen1Welcome({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 60),
          // Logo animation
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: AppTheme.gradientPrimary,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(32),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.primaryBlue.withValues(alpha: 0.3),
                  blurRadius: 30,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: const Icon(
              Icons.school_rounded,
              size: 60,
              color: Colors.white,
            ),
          )
              .animate()
              .scale(delay: 200.ms, duration: 600.ms, curve: Curves.elasticOut)
              .shimmer(delay: 800.ms, duration: 1500.ms),
          const SizedBox(height: 40),
          Text(
            'ProfileForge',
            style: GoogleFonts.inter(
              fontSize: 36,
              fontWeight: FontWeight.w800,
              color: AppTheme.textPrimary,
              letterSpacing: -1,
            ),
          ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.3),
          const SizedBox(height: 12),
          Text(
            'Your admissions strategist\nin your pocket',
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              fontSize: 20,
              fontWeight: FontWeight.w400,
              color: AppTheme.textSecondary,
              height: 1.4,
            ),
          ).animate().fadeIn(delay: 500.ms).slideY(begin: 0.3),
          const SizedBox(height: 60),
          // Feature highlights
          Column(
            children: [
              _FeatureItem(
                icon: Icons.psychology_rounded,
                title: 'AI-Powered Strategy',
                subtitle: 'Monte Carlo admissions simulation\nwith 10,000+ scenarios',
                color: AppTheme.primaryBlue,
                delay: 600,
              ),
              _FeatureItem(
                icon: Icons.explore_rounded,
                title: 'Hyper-Local Opportunities',
                subtitle: '573K NGOs, 14.7L schools, 10K ATL labs\nmatched to your schedule & location',
                color: AppTheme.successGreen,
                delay: 700,
              ),
              _FeatureItem(
                icon: Icons.emoji_events_rounded,
                title: 'Identity-Based Gamification',
                subtitle: 'Skins > Currency. Unlock Researcher,\nLeader, Creator, Changemaker, Trailblazer',
                color: AppTheme.accentGold,
                delay: 800,
              ),
              _FeatureItem(
                icon: Icons.school_rounded,
                title: 'Zero-Commute School Tasks',
                subtitle: 'In-school clubs, labs, teachers mapped\nto your free periods automatically',
                color: AppTheme.accentSilver,
                delay: 900,
              ),
            ],
          ),
          const SizedBox(height: 40),
          Text(
            'Built for Indian 11th graders\ntargeting Ivy League & top global universities',
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: AppTheme.textMuted,
              height: 1.5,
            ),
          ).animate().fadeIn(delay: 1000.ms),
        ],
      ),
    );
  }
}

class _FeatureItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final int delay;

  const _FeatureItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.delay,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: color, size: 24),
          )
              .animate()
              .scale(delay: Duration(milliseconds: delay), curve: Curves.elasticOut),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                    color: AppTheme.textSecondary,
                    height: 1.4,
                  ),
                ),
              ],
            ).animate().fadeIn(delay: Duration(milliseconds: delay + 100)).slideX(begin: 0.2),
          ),
        ],
      ),
    );
  }
}