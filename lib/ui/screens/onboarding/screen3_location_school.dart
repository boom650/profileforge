import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/app_theme.dart';

class Screen3LocationSchool extends StatelessWidget {
  const Screen3LocationSchool({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 40),
          Text(
            'Home Location\n& School',
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
            'We\'ll calculate commute times and find opportunities near you',
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: AppTheme.textSecondary,
            ),
          ).animate().fadeIn(delay: 100.ms).slideX(begin: -0.2),
          const SizedBox(height: 32),
          // Home Location Card
          _LocationCard(
            title: 'Home Location',
            subtitle: 'Pin your home for commute calculations',
            icon: Icons.home_rounded,
            color: AppTheme.primaryBlue,
            delay: 200,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppTheme.surfaceLight,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppTheme.primaryBlue.withValues(alpha: 0.2)),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.search_rounded, color: AppTheme.primaryBlue, size: 24),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Search address or drop pin on map',
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            color: AppTheme.textMuted,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  '📍 12.9714342° N, 77.6101° E (Example: Koramangala, Bangalore)',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: AppTheme.successGreen,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          // School Detection Card
          _LocationCard(
            title: 'School Detection',
            subtitle: 'Auto-detect or manually select your school',
            icon: Icons.school_rounded,
            color: AppTheme.successGreen,
            delay: 300,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _SchoolDetectionOption(
                  icon: Icons.auto_awesome_rounded,
                  title: 'Auto-detect from location',
                  subtitle: 'Uses geofence + schedule inference (85% accuracy)',
                  delay: 0,
                ),
                _SchoolDetectionOption(
                  icon: Icons.camera_alt_rounded,
                  title: 'Scan ID card / Timetable',
                  subtitle: 'OCR on-device — 95% accuracy, privacy-first',
                  delay: 100,
                ),
                _SchoolDetectionOption(
                  icon: Icons.search_rounded,
                  title: 'Search manually (UDISE+)',
                  subtitle: '14.7L schools database — 99% accuracy',
                  delay: 200,
                ),
                _SchoolDetectionOption(
                  icon: Icons.share_rounded,
                  title: 'Parent/Teacher invite link',
                  subtitle: 'They select your school — 90% accuracy',
                  delay: 300,
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          // Preview of what we build
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppTheme.primaryBlue.withValues(alpha: 0.1), AppTheme.primaryBlueLight.withValues(alpha: 0.05)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppTheme.primaryBlue.withValues(alpha: 0.2)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Once detected, we auto-build:',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textPrimary,
                  ),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _PreviewChip(label: 'Club schedules'),
                    _PreviewChip(label: 'Teacher mentors'),
                    _PreviewChip(label: 'ATL Lab access'),
                    _PreviewChip(label: 'Library resources'),
                    _PreviewChip(label: 'Sports facilities'),
                    _PreviewChip(label: 'School calendar'),
                  ],
                ),
              ],
            ),
          ).animate().fadeIn(delay: 500.ms).slideY(begin: 0.2),
        ],
      ),
    );
  }
}

class _LocationCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final int delay;
  final Widget child;

  const _LocationCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.delay,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.surfaceWhite,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.2)),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.05),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: 22),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.inter(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        color: AppTheme.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ).animate().fadeIn(delay: Duration(milliseconds: delay)).slideX(begin: -0.2),
          const SizedBox(height: 16),
          child.animate().fadeIn(delay: Duration(milliseconds: delay + 200)).slideY(begin: 0.1),
        ],
      ),
    );
  }
}

class _SchoolDetectionOption extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final int delay;

  const _SchoolDetectionOption({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.delay,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon, size: 20, color: AppTheme.textMuted),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
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
          Radio<String>(
            value: title,
            groupValue: null,
            onChanged: (_) {},
            activeColor: AppTheme.primaryBlue,
          ),
        ],
      ).animate().fadeIn(delay: Duration(milliseconds: 200 + delay)).slideX(begin: 0.1),
    );
  }
}

class _PreviewChip extends StatelessWidget {
  final String label;

  const _PreviewChip({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppTheme.primaryBlue.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppTheme.primaryBlue.withValues(alpha: 0.2)),
      ),
      child: Text(
        label,
        style: GoogleFonts.inter(
          fontSize: 11,
          fontWeight: FontWeight.w500,
          color: AppTheme.primaryBlue,
        ),
      ),
    );
  }
}