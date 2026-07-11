import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/app_theme.dart';

class Screen7ScheduleBuilder extends StatelessWidget {
  const Screen7ScheduleBuilder({super.key});

  @override
  Widget build(BuildContext context) {
    final days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    final timeSlots = [
      '6:00-7:00', '7:00-8:00', '8:00-9:00', '9:00-10:00', '10:00-11:00', '11:00-12:00',
      '12:00-13:00', '13:00-14:00', '14:00-15:00', '15:00-16:00', '16:00-17:00', '17:00-18:00',
      '18:00-19:00', '19:00-20:00', '20:00-21:00', '21:00-22:00', '22:00-23:00',
    ];

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: AppTheme.spacingXxl),
          Text(
            'Weekly Schedule\nBuilder',
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
            'Drag blocks to build your typical week — we\'ll find free slots for missions',
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: AppTheme.textSecondary,
            ),
          ).animate().fadeIn(delay: 100.ms).slideX(begin: -0.2),
          const SizedBox(height: 24),
          // Quick preset
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.primaryBlue.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppTheme.primaryBlue.withValues(alpha: 0.2)),
            ),
            child: Row(
              children: [
                Icon(Icons.auto_fix_high_rounded, color: AppTheme.primaryBlue, size: 20),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Tap "Typical Indian 11th Grader" preset → then customize',
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: AppTheme.primaryBlue,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    // TODO: Apply preset schedule
                  },
                  child: Text('Apply Preset', style: GoogleFonts.inter(fontWeight: FontWeight.w600)),
                ),
              ],
            ),
          ).animate().fadeIn(delay: 200.ms),
          const SizedBox(height: 24),
          // Schedule grid
          Text(
            'Your Week',
            style: GoogleFonts.inter(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppTheme.textPrimary,
            ),
          ).animate().fadeIn(delay: 300.ms),
          const SizedBox(height: 12),
          Container(
            decoration: BoxDecoration(
              color: context.surfaceElevated,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: (AppColors.categoryColors['school'] ?? AppTheme.primaryBlue).withValues(alpha: 0.2)),
            ),
            child: Column(
              children: [
                // Header row
                Row(
                  children: [
                    const SizedBox(width: 60),
                    ...days.map((d) => Expanded(
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Text(
                            d,
                            style: GoogleFonts.inter(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: AppTheme.textSecondary,
                            ),
                          ),
                        ),
                      ),
                    )),
                  ],
                ),
                ...timeSlots.asMap().entries.map((entry) {
                  final index = entry.key;
                  final time = entry.value;
                  return _TimeRow(time: time, dayCount: days.length, index: index);
                }),
              ],
            ),
          ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.1),
          const SizedBox(height: 24),
          // Discretionary hours summary
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: AppTheme.gradientSuccess,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Weekday Discretionary',
                        style: GoogleFonts.inter(fontSize: 12, color: Colors.white.withValues(alpha: 0.8)),
                      ),
                      Text(
                        '1.5 hrs/day',
                        style: GoogleFonts.inter(fontSize: 24, fontWeight: FontWeight.w700, color: Colors.white),
                      ),
                    ],
                  ),
                ),
                Container(width: 1, height: 50, color: Colors.white.withValues(alpha: 0.3)),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Weekend Discretionary',
                        style: GoogleFonts.inter(fontSize: 12, color: Colors.white.withValues(alpha: 0.8)),
                      ),
                      Text(
                        '5 hrs/day',
                        style: GoogleFonts.inter(fontSize: 24, fontWeight: FontWeight.w700, color: Colors.white),
                      ),
                    ],
                  ),
                ),
                Container(width: 1, height: 50, color: Colors.white.withValues(alpha: 0.3)),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Weekly Total',
                        style: GoogleFonts.inter(fontSize: 12, color: Colors.white.withValues(alpha: 0.8)),
                      ),
                      Text(
                        '17.5 hrs',
                        style: GoogleFonts.inter(fontSize: 24, fontWeight: FontWeight.w700, color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ).animate().fadeIn(delay: 500.ms).slideY(begin: 0.2),
        ],
      ),
    );
  }
}

class _TimeRow extends StatelessWidget {
  final String time;
  final int dayCount;
  final int index;

  const _TimeRow({required this.time, required this.dayCount, required this.index});

  @override
  Widget build(BuildContext context) {
    // Sample schedule for typical Indian 11th grader
    final schedule = <String, List<String>>{
      '6:00-7:00': ['sleep', 'sleep', 'sleep', 'sleep', 'sleep', 'sleep', 'sleep'],
      '7:00-8:00': ['commute', 'commute', 'commute', 'commute', 'commute', 'sleep', 'sleep'],
      '8:00-9:00': ['school', 'school', 'school', 'school', 'school', 'sleep', 'sleep'],
      '9:00-10:00': ['school', 'school', 'school', 'school', 'school', 'free', 'free'],
      '10:00-11:00': ['school', 'school', 'school', 'school', 'school', 'free', 'free'],
      '11:00-12:00': ['school', 'school', 'school', 'school', 'school', 'free', 'free'],
      '12:00-13:00': ['school', 'school', 'school', 'school', 'school', 'free', 'free'],
      '13:00-14:00': ['commute', 'commute', 'commute', 'commute', 'commute', 'free', 'free'],
      '14:00-15:00': ['coaching', 'coaching', 'coaching', 'coaching', 'coaching', 'free', 'free'],
      '15:00-16:00': ['coaching', 'coaching', 'coaching', 'coaching', 'coaching', 'free', 'free'],
      '16:00-17:00': ['coaching', 'coaching', 'coaching', 'coaching', 'coaching', 'free', 'free'],
      '17:00-18:00': ['coaching', 'coaching', 'coaching', 'coaching', 'coaching', 'free', 'free'],
      '18:00-19:00': ['commute', 'commute', 'commute', 'commute', 'commute', 'free', 'free'],
      '19:00-20:00': ['meal', 'meal', 'meal', 'meal', 'meal', 'free', 'free'],
      '20:00-21:00': ['study', 'study', 'study', 'study', 'study', 'free', 'free'],
      '21:00-22:00': ['study', 'study', 'study', 'study', 'study', 'free', 'free'],
      '22:00-23:00': ['sleep', 'sleep', 'sleep', 'sleep', 'sleep', 'free', 'free'],
    };

    final blocks = schedule[time] ?? List.filled(dayCount, 'free');

    return Container(
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: AppTheme.textMuted.withValues(alpha: 0.1)),
        ),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 60,
            child: Center(
              child: Text(
                time,
                style: GoogleFonts.inter(
                  fontSize: 10,
                  color: AppTheme.textMuted,
                ),
              ),
            ),
          ),
          ...blocks.asMap().entries.map((entry) {
            final dayIndex = entry.key;
            final blockType = entry.value;
            return Expanded(
              child: Container(
                height: 32,
                margin: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  color: _getBlockColor(blockType),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Center(
                  child: Text(
                    _getBlockLabel(blockType),
                    style: GoogleFonts.inter(
                      fontSize: 8,
                      fontWeight: FontWeight.w600,
                      color: _getBlockTextColor(blockType),
                    ),
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  Color _getBlockColor(String type) {
    switch (type) {
      case 'sleep': return const Color(0xFF1E3A8A).withValues(alpha: 0.3);
      case 'school': return const Color(0xFF3B82F6).withValues(alpha: 0.3);
      case 'coaching': return AppTheme.categoryViolet.withValues(alpha: 0.3);
      case 'commute': return const Color(0xFF64748B).withValues(alpha: 0.3);
      case 'meal': return const Color(0xFFF59E0B).withValues(alpha: 0.3);
      case 'study': return AppTheme.categoryEmerald.withValues(alpha: 0.3);
      case 'free': return AppTheme.categoryEmerald.withValues(alpha: 0.15);
      default: return AppTheme.surfaceLight;
    }
  }

  Color _getBlockTextColor(String type) {
    switch (type) {
      case 'sleep': return const Color(0xFF1E3A8A);
      case 'school': return const Color(0xFF1E40AF);
      case 'coaching': return const Color(0xFF6D28D9);
      case 'commute': return const Color(0xFF334155);
      case 'meal': return const Color(0xFFB45309);
      case 'study': return const Color(0xFF047857);
      case 'free': return const Color(0xFF047857);
      default: return AppTheme.textMuted;
    }
  }

  String _getBlockLabel(String type) {
    switch (type) {
      case 'sleep': return '😴';
      case 'school': return '🏫';
      case 'coaching': return '📚';
      case 'commute': return '🚌';
      case 'meal': return '🍽️';
      case 'study': return '📖';
      case 'free': return '✨';
      default: return '';
    }
  }
}