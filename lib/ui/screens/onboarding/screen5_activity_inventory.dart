import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/app_theme.dart';
import '../../../models/student_profile.dart';

class Screen5ActivityInventory extends StatelessWidget {
  const Screen5ActivityInventory({super.key});

  @override
  Widget build(BuildContext context) {
    final categories = ActivityCategory.values;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 40),
          Text(
            'Activity Inventory\n(Grades 9-11)',
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
            'Import from resume, LinkedIn, or add manually — we\'ll tier them for admissions impact',
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: AppTheme.textSecondary,
            ),
          ).animate().fadeIn(delay: 100.ms).slideX(begin: -0.2),
          const SizedBox(height: 24),
          // Import options
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppTheme.surfaceLight,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppTheme.primaryBlue.withValues(alpha: 0.2)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '📥 Quick Import',
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textPrimary,
                  ),
                ),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: [
                    _ImportButton(
                      icon: Icons.picture_as_pdf_rounded,
                      label: 'Resume/CV (PDF)',
                      color: AppTheme.primaryBlue,
                    ),
                    _ImportButton(
                      icon: Icons.description_rounded,
                      label: 'Common App Draft',
                      color: AppTheme.successGreen,
                    ),
                    _ImportButton(
                      icon: Icons.link_rounded,
                      label: 'LinkedIn Profile',
                      color: const Color(0xFF0A66C2),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                OutlinedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.add_rounded, size: 20),
                  label: Text('Manual Entry (Guided)', style: GoogleFonts.inter(fontSize: 14)),
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 48),
                    side: BorderSide(color: AppTheme.primaryBlue),
                  ),
                ),
              ],
            ),
          ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.1),
          const SizedBox(height: 32),
          Text(
            'Categories we track',
            style: GoogleFonts.inter(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppTheme.textPrimary,
            ),
          ).animate().fadeIn(delay: 300.ms),
          const SizedBox(height: 16),
          Column(
            children: categories.asMap().entries.map((entry) {
              final index = entry.key;
              final category = entry.value;
              return _CategoryRow(
                category: category,
                delay: 400 + index * 60,
              );
            }).toList(),
          ),
          const SizedBox(height: 24),
          Text(
            '💡 Tip: Depth > Breadth. 3-5 Tier 1-2 activities with strong narratives beat 15 Tier 4 activities.',
            style: GoogleFonts.inter(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: AppTheme.primaryBlue,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ).animate().fadeIn(delay: 800.ms),
        ],
      ),
    );
  }
}

class _ImportButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _ImportButton({
    required this.icon,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: 8),
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

class _CategoryRow extends StatelessWidget {
  final ActivityCategory category;
  final int delay;

  const _CategoryRow({required this.category, required this.delay});

  @override
  Widget build(BuildContext context) {
    final color = AppColors.categoryColors[category.name] ?? AppTheme.primaryBlue;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppTheme.surfaceWhite,
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
              child: Text(category.icon, style: TextStyle(fontSize: 22)),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    category.displayName,
                    style: GoogleFonts.inter(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  Text(
                    _getExamples(category),
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: AppTheme.textMuted,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                'Add',
                style: GoogleFonts.inter(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: color,
                ),
              ),
            ),
          ],
        ),
      ).animate().fadeIn(delay: Duration(milliseconds: delay)).slideX(begin: 0.1),
    );
  }

  String _getExamples(ActivityCategory category) {
    switch (category) {
      case ActivityCategory.clubs:
        return 'Robotics, MUN, Debate, Eco Club, Interact...';
      case ActivityCategory.sports:
        return 'Cricket, Basketball, Swimming, Track, Badminton...';
      case ActivityCategory.arts:
        return 'Music, Dance, Theatre, Painting, Photography...';
      case ActivityCategory.competitions:
        return 'Olympiads, IRIS, NCSC, Hackathons, Quiz...';
      case ActivityCategory.research:
        return 'Independent research, Mentored projects, Publications...';
      case ActivityCategory.volunteering:
        return 'NGO work, Teaching, Environmental, Healthcare...';
      case ActivityCategory.leadership:
        return 'Student Council, Club President, Team Captain...';
      case ActivityCategory.work:
        return 'Internships, Part-time jobs, Freelance...';
      case ActivityCategory.courses:
        return 'Online courses, Summer programs, Certifications...';
      case ActivityCategory.unique:
        return 'Origami museum, App development, Patent, Book...';
    }
  }
}