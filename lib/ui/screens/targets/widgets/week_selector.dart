import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/app_theme.dart';
import '../weekly_targets_model.dart';

class WeekSelector extends StatelessWidget {
  final int weekNumber;
  final int year;
  final VoidCallback onPrevious;
  final VoidCallback onNext;

  const WeekSelector({
    super.key,
    required this.weekNumber,
    required this.year,
    required this.onPrevious,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    // Compute week date range
    final jan1 = DateTime(year, 1, 1);
    final firstDay = jan1.add(Duration(days: (weekNumber - 1) * 7 - jan1.weekday + 1));
    final lastDay = firstDay.add(const Duration(days: 6));
    final now = DateTime.now();
    final isCurrentWeek =
        weekNumber == _currentWeekNumber(now.year) && year == now.year;

    return Container(
      margin: const EdgeInsets.fromLTRB(20, 8, 20, 4),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
      decoration: BoxDecoration(
        color: context.surfaceElevated,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isCurrentWeek
              ? Theme.of(context).colorScheme.primary.withValues(alpha: 0.3)
              : context.borderColor,
        ),
      ),
      child: Row(
        children: [
          ArrowButton(icon: Icons.chevron_left_rounded, onTap: onPrevious),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Week $weekNumber',
                      style: GoogleFonts.inter(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: context.textPrimary,
                      ),
                    ),
                    if (isCurrentWeek) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: AppTheme.successGreen.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          'Current',
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.successGreen,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  '${_monthShort(firstDay.month)} ${firstDay.day} – ${_monthShort(lastDay.month)} ${lastDay.day}, $year',
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    color: context.textMuted,
                  ),
                ),
              ],
            ),
          ),
          ArrowButton(icon: Icons.chevron_right_rounded, onTap: onNext),
        ],
      ),
    ).animate().fadeIn(delay: 100.ms);
  }

  static int _currentWeekNumber(int year) {
    final now = DateTime.now();
    final jan1 = DateTime(year, 1, 1);
    final days = now.difference(jan1).inDays;
    return ((days + jan1.weekday - 1) ~/ 7) + 1;
  }

  static String _monthShort(int month) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return months[month - 1];
  }
}

class ArrowButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const ArrowButton({super.key, required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: Theme.of(context).colorScheme.primary, size: 22),
      ),
    );
  }
}