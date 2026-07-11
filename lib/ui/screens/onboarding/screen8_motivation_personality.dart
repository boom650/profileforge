/// UNUSED IN ONBOARDING FLOW — kept for future reference.
/// Motivation/personality is not needed during onboarding.
/// Can be used later for personalized nudge framing.
library;

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/app_theme.dart';
import '../../../models/student_profile.dart';

// ignore: unused_element
class Screen8MotivationPersonality extends StatelessWidget {
  const Screen8MotivationPersonality({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: AppTheme.spacingXxl),
          Text(
            'What Drives You?',
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
            'Pick your top 2 — we\'ll tailor nudges & mission framing to your psychology',
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: AppTheme.textSecondary,
            ),
          ).animate().fadeIn(delay: 100.ms).slideX(begin: -0.2),
          const SizedBox(height: 32),
          // Motivation drivers
          Column(
            children: MotivationDriver.values.asMap().entries.map((entry) {
              final index = entry.key;
              final driver = entry.value;
              return _MotivationCard(
                driver: driver,
                delay: 200 + index * 80,
              );
            }).toList(),
          ),
          const SizedBox(height: 32),
          Text(
            'Stress Style',
            style: GoogleFonts.inter(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: AppTheme.textPrimary,
            ),
          ).animate().fadeIn(delay: 700.ms).slideX(begin: -0.2),
          const SizedBox(height: 8),
          Text(
            'How do you handle pressure?',
            style: GoogleFonts.inter(
              fontSize: 14,
              color: AppTheme.textSecondary,
            ),
          ).animate().fadeIn(delay: 750.ms).slideX(begin: -0.2),
          const SizedBox(height: 16),
          Column(
            children: StressStyle.values.asMap().entries.map((entry) {
              final index = entry.key;
              final style = entry.value;
              return _StressStyleCard(
                style: style,
                delay: 800 + index * 100,
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

class _MotivationCard extends StatelessWidget {
  final MotivationDriver driver;
  final int delay;

  const _MotivationCard({required this.driver, required this.delay});

  @override
  Widget build(BuildContext context) {
    final configs = {
      MotivationDriver.familyPride: {
        'icon': Icons.favorite_rounded,
        'title': 'Family Pride',
        'subtitle': '"Make them proud" — your North Star',
        'color': AppTheme.categoryPink,
      },
      MotivationDriver.peerComparison: {
        'icon': Icons.people_rounded,
        'title': 'Peer Competition',
        'subtitle': '"Sharma ji\'s kid got into Cornell"',
        'color': AppTheme.categoryViolet,
      },
      MotivationDriver.fearOfFailure: {
        'icon': Icons.shield_rounded,
        'title': 'Fear of Failure',
        'subtitle': '"What if I don\'t get anywhere?"',
        'color': AppTheme.categoryRed,
      },
      MotivationDriver.scholarshipNeed: {
        'icon': Icons.attach_money_rounded,
        'title': 'Scholarship Need',
        'subtitle': 'Financial reality — every dollar counts',
        'color': AppTheme.categoryEmerald,
      },
      MotivationDriver.genuineCuriosity: {
        'icon': Icons.lightbulb_rounded,
        'title': 'Genuine Curiosity',
        'subtitle': 'Learning for the love of it (highest retention)',
        'color': AppTheme.accentGold,
      },
      MotivationDriver.statusAbroadDream: {
        'icon': Icons.flight_takeoff_rounded,
        'title': 'Status / "Abroad" Dream',
        'subtitle': 'Social mobility signal — the ultimate flex',
        'color': const Color(0xFF06B6D4),
      },
    };

    final config = configs[driver]!;
    final color = config['color'] as Color;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: context.surfaceElevated,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withValues(alpha: 0.2)),
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(config['icon'] as IconData, color: color, size: 22),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    config['title'] as String,
                    style: GoogleFonts.inter(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  Text(
                    config['subtitle'] as String,
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: AppTheme.textMuted,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: color.withValues(alpha: 0.3)),
              ),
              child: Icon(Icons.check_rounded, size: 14, color: color),
            ),
          ],
        ),
      ).animate().fadeIn(delay: Duration(milliseconds: delay)).slideX(begin: 0.1),
    );
  }
}

class _StressStyleCard extends StatelessWidget {
  final StressStyle style;
  final int delay;

  const _StressStyleCard({required this.style, required this.delay});

  @override
  Widget build(BuildContext context) {
    final configs = {
      StressStyle.planner: {
        'icon': Icons.calendar_month_rounded,
        'title': 'Planner',
        'subtitle': 'Schedule everything. Predictability = peace.',
        'color': const Color(0xFF3B82F6),
      },
      StressStyle.sprinter: {
        'icon': Icons.flash_on_rounded,
        'title': 'Sprinter',
        'subtitle': 'Burst work. Deadlines fuel you. Rest hard after.',
        'color': const AppTheme.accentGold,
      },
      StressStyle.avoider: {
        'icon': Icons.psychology_rounded,
        'title': 'Avoider',
        'subtitle': 'Need gentle nudges. "Just 2 minutes" works.',
        'color': const AppTheme.categoryPink,
      },
    };

    final config = configs[style]!;
    final color = config['color'] as Color;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: context.surfaceElevated,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withValues(alpha: 0.3), width: 2),
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(config['icon'] as IconData, color: color, size: 22),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    config['title'] as String,
                    style: GoogleFonts.inter(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  Text(
                    config['subtitle'] as String,
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: AppTheme.textMuted,
                    ),
                  ),
                ],
              ),
            ),
            Radio<String>(
              value: style.name,
              groupValue: style.name,
              onChanged: (_) {},
              activeColor: color,
            ),
          ],
        ),
      ).animate().fadeIn(delay: Duration(milliseconds: delay)).slideX(begin: 0.1),
    );
  }
}