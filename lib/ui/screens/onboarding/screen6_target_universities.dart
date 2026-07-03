import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/app_theme.dart';
import '../../../models/student_profile.dart';

class Screen6TargetUniversities extends StatelessWidget {
  const Screen6TargetUniversities({super.key});

  @override
  Widget build(BuildContext context) {
    final reachUnis = ['MIT', 'Stanford', 'Harvard', 'Caltech', 'Princeton', 'Yale', 'Columbia', 'UPenn'];
    final matchUnis = ['UCLA', 'UCSD', 'UWash', 'Georgia Tech', 'UT Austin', 'UIUC', 'Purdue', 'Texas A&M'];
    final safetyUnis = ['UMass Amherst', 'ASU', 'Purdue', 'Ohio State', 'UC Irvine', 'UC Davis', 'Colorado Boulder'];

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 40),
          Text(
            'Target Universities',
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
            'Categorize your list — we\'ll calculate admission probability for each',
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: AppTheme.textSecondary,
            ),
          ).animate().fadeIn(delay: 100.ms).slideX(begin: -0.2),
          const SizedBox(height: 24),
          // Major & Countries
          Row(
            children: [
              Expanded(
                child: _DropdownField(
                  label: 'Intended Major',
                  value: 'Computer Science',
                  items: [
                    'Computer Science', 'Data Science', 'AI/ML', 'Electrical Engineering',
                    'Mechanical Engineering', 'Physics', 'Mathematics', 'Biology/Pre-med',
                    'Economics', 'Business', 'Psychology', 'Political Science', 'Other'
                  ],
                  delay: 200,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _DropdownField(
            label: 'Target Countries',
            value: 'US, UK, Canada, Australia',
            items: ['US', 'UK', 'Canada', 'Australia', 'Europe (EU)', 'Singapore', 'Hong Kong', 'All of the above'],
            delay: 250,
          ),
          const SizedBox(height: 32),
          // University Tiers
          _UniversityTierSection(
            title: '🎯 Reach (Dream Schools)',
            subtitle: '10-20% baseline probability — aim high',
            color: const Color(0xFF8B5CF6),
            universities: reachUnis,
            delay: 300,
          ),
          const SizedBox(height: 20),
          _UniversityTierSection(
            title: '🎯 Match (Realistic Targets)',
            subtitle: '40-60% baseline probability — your sweet spot',
            color: const Color(0xFF3B82F6),
            universities: matchUnis,
            delay: 500,
          ),
          const SizedBox(height: 20),
          _UniversityTierSection(
            title: '🛡️ Safety (High Confidence)',
            subtitle: '70%+ baseline probability — guaranteed options',
            color: const Color(0xFF10B981),
            universities: safetyUnis,
            delay: 700,
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppTheme.accentGold.withValues(alpha: 0.1), AppTheme.accentGold.withValues(alpha: 0.05)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppTheme.accentGold.withValues(alpha: 0.3)),
            ),
            child: Row(
              children: [
                Icon(Icons.lightbulb_rounded, color: AppTheme.accentGold, size: 20),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'We\'ll run 10,000 Monte Carlo simulations per university. Probability updates weekly as you complete missions.',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                ),
              ],
            ),
          ).animate().fadeIn(delay: 900.ms),
        ],
      ),
    );
  }
}

class _DropdownField extends StatelessWidget {
  final String label;
  final String value;
  final List<String> items;
  final int delay;

  const _DropdownField({
    required this.label,
    required this.value,
    required this.items,
    required this.delay,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: value,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: GoogleFonts.inter(color: AppTheme.textSecondary),
        filled: true,
        fillColor: AppTheme.surfaceLight,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
      items: items.map((e) => DropdownMenuItem(value: e, child: Text(e, style: GoogleFonts.inter()))).toList(),
      onChanged: (_) {},
      style: GoogleFonts.inter(fontSize: 16, color: AppTheme.textPrimary),
      dropdownColor: AppTheme.surfaceWhite,
    ).animate().fadeIn(delay: Duration(milliseconds: delay)).slideY(begin: 0.1);
  }
}

class _UniversityTierSection extends StatelessWidget {
  final String title;
  final String subtitle;
  final Color color;
  final List<String> universities;
  final int delay;

  const _UniversityTierSection({
    required this.title,
    required this.subtitle,
    required this.color,
    required this.universities,
    required this.delay,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 10),
            Text(
              title,
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppTheme.textPrimary,
              ),
            ),
          ],
        ).animate().fadeIn(delay: Duration(milliseconds: delay)).slideX(begin: -0.1),
        Text(
          subtitle,
          style: GoogleFonts.inter(
            fontSize: 12,
            color: AppTheme.textMuted,
          ),
        ).animate().fadeIn(delay: Duration(milliseconds: delay + 100)).slideX(begin: -0.1),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: universities.asMap().entries.map((entry) {
            final index = entry.key;
            final uni = entry.value;
            return _UniversityChip(
              name: uni,
              color: color,
              delay: delay + 200 + index * 40,
            );
          }).toList(),
        ),
      ],
    );
  }
}

class _UniversityChip extends StatelessWidget {
  final String name;
  final Color color;
  final int delay;

  const _UniversityChip({
    required this.name,
    required this.color,
    required this.delay,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            name,
            style: GoogleFonts.inter(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: color,
            ),
          ),
          const SizedBox(width: 6),
          Icon(Icons.check_circle_outline_rounded, size: 14, color: color.withValues(alpha: 0.7)),
        ],
      ),
    ).animate().fadeIn(delay: Duration(milliseconds: delay)).scale(begin: const Offset(0.8, 0.8));
  }
}