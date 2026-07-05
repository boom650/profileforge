import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/app_theme.dart';

class Screen4Activities extends StatelessWidget {
  const Screen4Activities({super.key});

  @override
  Widget build(BuildContext context) {
    final categories = [
      _ActivityCategory(
        icon: '🏫',
        name: 'Clubs',
        examples: 'Robotics, MUN, Debate, Eco Club',
        color: const Color(0xFF3B82F6),
      ),
      _ActivityCategory(
        icon: '🏆',
        name: 'Competitions',
        examples: 'Olympiads, Hackathons, Quizzes',
        color: const Color(0xFFF59E0B),
      ),
      _ActivityCategory(
        icon: '🤝',
        name: 'Volunteering',
        examples: 'NGO, Teaching, Environment',
        color: const Color(0xFF10B981),
      ),
      _ActivityCategory(
        icon: '🔬',
        name: 'Research',
        examples: 'Projects, Publications, Mentored',
        color: const Color(0xFF8B5CF6),
      ),
      _ActivityCategory(
        icon: '🏃',
        name: 'Sports',
        examples: 'Cricket, Basketball, Track',
        color: const Color(0xFFEF4444),
      ),
      _ActivityCategory(
        icon: '✨',
        name: 'Other',
        examples: 'Arts, Leadership, Work, Unique',
        color: const Color(0xFF64748B),
      ),
    ];

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 40),
          Text(
            'Activities',
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
            'Tap + to add activities. We\'ll tier them for admissions impact.',
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: AppTheme.textSecondary,
            ),
          ).animate().fadeIn(delay: 100.ms).slideX(begin: -0.2),
          const SizedBox(height: 28),
          // 6 Category Cards in 2-column grid
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.6,
            ),
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final cat = categories[index];
              return _ActivityCard(
                icon: cat.icon,
                name: cat.name,
                examples: cat.examples,
                color: cat.color,
                delay: 200 + index * 80,
              );
            },
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.primaryBlue.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppTheme.primaryBlue.withValues(alpha: 0.2)),
            ),
            child: Row(
              children: [
                Icon(Icons.lightbulb_rounded, color: AppTheme.accentGold, size: 18),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    '💡 Tip: 3-5 deep activities beat 15 shallow ones. Quality > quantity for admissions.',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                ),
              ],
            ),
          ).animate().fadeIn(delay: 700.ms),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

class _ActivityCategory {
  final String icon;
  final String name;
  final String examples;
  final Color color;

  const _ActivityCategory({
    required this.icon,
    required this.name,
    required this.examples,
    required this.color,
  });
}

class _ActivityCard extends StatelessWidget {
  final String icon;
  final String name;
  final String examples;
  final Color color;
  final int delay;

  const _ActivityCard({
    required this.icon,
    required this.name,
    required this.examples,
    required this.color,
    required this.delay,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('$icon $name — we\'ll track this after onboarding'),
            duration: const Duration(seconds: 1),
            behavior: SnackBarBehavior.floating,
          ),
        );
      },
      child: Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: context.surfaceElevated,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withValues(alpha: 0.2)),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(icon, style: const TextStyle(fontSize: 24)),
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(Icons.add_rounded, color: color, size: 18),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: context.textPrimary,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                examples,
                style: GoogleFonts.inter(
                  fontSize: 10,
                  color: context.textMuted,
                  height: 1.3,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ],
      ),
    ).animate().fadeIn(delay: Duration(milliseconds: delay)).scale(begin: const Offset(0.9, 0.9)),
    );
  }
}
