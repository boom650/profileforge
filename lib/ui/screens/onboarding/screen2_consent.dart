/// UNUSED IN ONBOARDING FLOW — kept for future reference.
/// Consent is now merged into screen1_welcome.dart footer.
/// Original flow: Screen 2 of 9.
library;

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/app_theme.dart';

// ignore: unused_element
class Screen2Consent extends StatelessWidget {
  const Screen2Consent({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: AppTheme.spacingXxl),
          Text(
            'How we personalize\nyour missions',
            style: GoogleFonts.inter(
              fontSize: 32,
              fontWeight: FontWeight.w700,
              color: AppTheme.textPrimary,
              letterSpacing: -0.5,
              height: 1.2,
            ),
          ).animate().fadeIn().slideX(begin: -0.2),
          const SizedBox(height: 32),
          _ConsentItem(
            icon: Icons.location_on_rounded,
            title: 'Location',
            subtitle: 'Nearby NGOs, labs, contests — never leaves your device',
            delay: 100,
          ),
          _ConsentItem(
            icon: Icons.school_rounded,
            title: 'School',
            subtitle: 'In-school clubs, teachers, facilities mapped to free periods',
            delay: 200,
          ),
          _ConsentItem(
            icon: Icons.schedule_rounded,
            title: 'Schedule',
            subtitle: 'Tasks that fit YOUR week — coaching, school, sleep respected',
            delay: 300,
          ),
          _ConsentItem(
            icon: Icons.person_rounded,
            title: 'Profile',
            subtitle: 'Admissions-targeted missions based on your target universities',
            delay: 400,
          ),
          const SizedBox(height: 32),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppTheme.primaryBlue.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppTheme.primaryBlue.withValues(alpha: 0.2)),
            ),
            child: Column(
              children: [
                _PrivacyRow(
                  icon: Icons.lock_rounded,
                  text: 'Precise location NEVER leaves device',
                ),
                _PrivacyRow(
                  icon: Icons.battery_charging_full_rounded,
                  text: 'Background research ONLY while charging',
                ),
                _PrivacyRow(
                  icon: Icons.settings_rounded,
                  text: 'You control every permission, revocable anytime',
                ),
              ],
            ),
          ).animate().fadeIn(delay: 500.ms).slideY(begin: 0.2),
          const SizedBox(height: AppTheme.spacingXxl),
          Text(
            'Your data. Your control.\nAlways.',
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: AppTheme.textSecondary,
              height: 1.5,
            ),
          ).animate().fadeIn(delay: 600.ms),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.successGreen.withValues(alpha: 0.06),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppTheme.successGreen.withValues(alpha: 0.2)),
            ),
            child: Row(
              children: [
                Icon(Icons.lock_rounded, size: 18, color: AppTheme.successGreen),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'All your data stays on your phone. We never send your grades or scores anywhere. You can delete everything anytime from Settings.',
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: AppTheme.textPrimary,
                      height: 1.5,
                    ),
                  ),
                ),
              ],
            ),
          ).animate().fadeIn(delay: 700.ms),
        ],
      ),
    );
  }
}

class _ConsentItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final int delay;

  const _ConsentItem({
    required this.icon,
    required this.title,
    required this.subtitle,
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
              gradient: AppTheme.gradientPrimary,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: Colors.white, size: 22),
          ).animate().scale(delay: Duration(milliseconds: delay), curve: Curves.elasticOut),
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

class _PrivacyRow extends StatelessWidget {
  final IconData icon;
  final String text;

  const _PrivacyRow({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon, size: 20, color: AppTheme.primaryBlue),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppTheme.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}