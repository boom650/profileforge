import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/app_theme.dart';
import '../../../providers/providers.dart';

/// Screen 11: Free Slots — shows computed available time based on the
/// timetable entered in Screen 10. User can confirm or adjust.
class Screen11FreeSlots extends ConsumerStatefulWidget {
  const Screen11FreeSlots({super.key, this.onFormChanged});

  static bool isFormValid = true; // Always valid — confirmation only
  final VoidCallback? onFormChanged;

  @override
  ConsumerState<Screen11FreeSlots> createState() =>
      _Screen11FreeSlotsState();
}

class _Screen11FreeSlotsState extends ConsumerState<Screen11FreeSlots> {
  int _weekdayHours = 2; // default
  int _weekendHours = 5; // default
  bool _confirmed = false;

  @override
  void initState() {
    super.initState();
    final data = ref.read(onboardingDataProvider);
    _weekdayHours = data.freeSlotsWeekdayHours;
    _weekendHours = data.freeSlotsWeekendHours;
    _confirmed = data.freeSlotsConfirmed;
  }

  _formKey = GlobalKey<FormState>();
  ref.read(onboardingDataProvider.notifier).updateData(
    ref.read(onboardingDataProvider).copyWith(
      freeSlotsWeekdayHours: _weekdayHours,
    ),
  );
  }

  @override
  Widget build(BuildContext context) {
    final data = ref.watch(onboardingDataProvider);
    final schoolStart = data.schoolStartTime ?? '07:30';
    final schoolEnd = data.schoolEndTime ?? '14:00';
    final hasCoaching = data.hasCoaching;
    final coachingStart = data.coachingStartTime ?? '15:00';
    final coachingEnd = data.coachingEndTime ?? '18:00';

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: AppTheme.spacingXxl),
          Text(
            'Your Free\nSlots',
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
            'Based on your timetable, here\'s when you can fit in missions',
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: AppTheme.textSecondary,
            ),
          ).animate().fadeIn(delay: 100.ms).slideX(begin: -0.2),
          const SizedBox(height: 24),

          // Computed Schedule Timeline
          _ScheduleTimeline(
            schoolStart: schoolStart,
            schoolEnd: schoolEnd,
            hasCoaching: hasCoaching,
            coachingStart: coachingStart,
            coachingEnd: coachingEnd,
          ),
          const SizedBox(height: 24),

          // Weekday Free Hours Selector
          _HoursSelector(
            title: 'Weekday Free Hours',
            subtitle: 'After school + coaching, how many hours can you spare?',
            icon: Icons.weekend_rounded,
            color: AppTheme.primaryBlue,
            value: _weekdayHours,
            min: 1,
            max: 8,
            delay: 300,
            onChanged: (val) {
              HapticFeedback.lightImpact();
              setState(() {
                _weekdayHours = val;
                _saveToProvider();
              });
            },
          ),
          const SizedBox(height: 16),

          // Weekend Free Hours Selector
          _HoursSelector(
            title: 'Weekend Free Hours',
            subtitle: 'Saturday & Sunday — how much study/mission time?',
            icon: Icons.free_breakfast_rounded,
            color: AppTheme.successGreen,
            value: _weekendHours,
            min: 1,
            max: 12,
            delay: 400,
            onChanged: (val) {
              HapticFeedback.lightImpact();
              setState(() {
                _weekendHours = val;
                _saveToProvider();
              });
            },
          ),
          const SizedBox(height: 24),

          // Weekly Total Summary
          _WeeklyTotalCard(
            weekdayHours: _weekdayHours,
            weekendHours: _weekendHours,
            delay: 500,
          ),
          const SizedBox(height: 16),

          // Confirmation toggle
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: _confirmed
                  ? AppTheme.successGreen.withValues(alpha: 0.08)
                  : AppTheme.primaryBlue.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: _confirmed
                    ? AppTheme.successGreen.withValues(alpha: 0.3)
                    : AppTheme.primaryBlue.withValues(alpha: 0.2),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  _confirmed
                      ? Icons.check_circle_rounded
                      : Icons.info_outline_rounded,
                  color:
                      _confirmed ? AppTheme.successGreen : AppTheme.primaryBlue,
                  size: 20,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    _confirmed
                        ? 'Schedule confirmed! We\'ll schedule missions in your free slots.'
                        : 'Adjust the hours above, then confirm when ready.',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: _confirmed
                          ? AppTheme.successGreen
                          : AppTheme.primaryBlue,
                    ),
                  ),
                ),
                if (!_confirmed)
                  TextButton(
                    onPressed: () {
                      HapticFeedback.mediumImpact();
                      setState(() {
                        _confirmed = true;
                        _saveToProvider();
                      });
                    },
                    child: Text('Confirm',
                        style: GoogleFonts.inter(fontWeight: FontWeight.w600)),
                  ),
              ],
            ),
          ).animate().fadeIn(delay: 600.ms),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

// ─── Helper Widgets ──────────────────────────────────────────────────────

class _ScheduleTimeline extends StatelessWidget {
  final String schoolStart;
  final String schoolEnd;
  final bool hasCoaching;
  final String coachingStart;
  final String coachingEnd;

  const _ScheduleTimeline({
    required this.schoolStart,
    required this.schoolEnd,
    required this.hasCoaching,
    required this.coachingStart,
    required this.coachingEnd,
  });

  @override
  Widget build(BuildContext context) {
    final blocks = <_TimeBlock>[
      _TimeBlock('6:00 AM', '7:30 AM', '🌅 Morning', AppTheme.accentGold,
          AppTheme.accentGold.withValues(alpha: 0.1)),
      _TimeBlock(schoolStart, schoolEnd, '🏫 School', AppTheme.primaryBlue,
          AppTheme.primaryBlue.withValues(alpha: 0.1)),
      if (hasCoaching)
        _TimeBlock(coachingStart, coachingEnd, '📚 Coaching',
            AppTheme.primaryPurple, AppTheme.primaryPurple.withValues(alpha: 0.1)),
      _TimeBlock('7:00 PM', '10:00 PM', '📖 Study / Free', AppTheme.successGreen,
          AppTheme.successGreen.withValues(alpha: 0.1)),
    ];

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: context.surfaceElevated,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.primaryBlue.withValues(alpha: 0.15)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Typical Weekday',
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          ...blocks.asMap().entries.map((entry) {
            final i = entry.key;
            final block = entry.value;
            return Padding(
              padding: EdgeInsets.only(bottom: i < blocks.length - 1 ? 8 : 0),
              child: Row(
                children: [
                  Container(
                    width: 4,
                    height: 36,
                    decoration: BoxDecoration(
                      color: block.color,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          block.label,
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AppTheme.textPrimary,
                          ),
                        ),
                        Text(
                          '${block.start} – ${block.end}',
                          style: GoogleFonts.inter(
                            fontSize: 11,
                            color: AppTheme.textMuted,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: block.bgColor,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      _duration(block.start, block.end),
                      style: GoogleFonts.inter(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: block.color,
                      ),
                    ),
                  ),
                ],
              ),
            ).animate().fadeIn(delay: Duration(milliseconds: 200 + i * 80));
          }),
        ],
      ),
    ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.05);
  }

  String _duration(String start, String end) {
    final s = _parseMinutes(start);
    final e = _parseMinutes(end);
    final diff = e - s;
    if (diff <= 0) return '';
    final h = diff ~/ 60;
    final m = diff % 60;
    return m > 0 ? '${h}h ${m}m' : '${h}h';
  }

  int _parseMinutes(String time) {
    // Handle "7:30 AM" format
    final clean = time.replaceAll(RegExp(r'\s*(AM|PM)\s*'), '');
    final parts = clean.split(':');
    if (parts.length != 2) return 0;
    var hours = int.parse(parts[0]);
    final mins = int.parse(parts[1]);
    if (time.contains('PM') && hours != 12) hours += 12;
    if (time.contains('AM') && hours == 12) hours = 0;
    return hours * 60 + mins;
  }
}

class _TimeBlock {
  final String start;
  final String end;
  final String label;
  final Color color;
  final Color bgColor;

  const _TimeBlock(this.start, this.end, this.label, this.color, this.bgColor);
}

class _HoursSelector extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final int value;
  final int min;
  final int max;
  final int delay;
  final ValueChanged<int> onChanged;

  const _HoursSelector({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.value,
    required this.min,
    required this.max,
    required this.delay,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: context.surfaceElevated,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: color, size: 18),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        color: AppTheme.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '$value hrs',
                  style: GoogleFonts.inter(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: color,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: color,
              inactiveTrackColor: color.withValues(alpha: 0.15),
              thumbColor: color,
              overlayColor: color.withValues(alpha: 0.1),
            ),
            child: Slider(
              value: value.toDouble(),
              min: min.toDouble(),
              max: max.toDouble(),
              divisions: max - min,
              onChanged: (v) => onChanged(v.round()),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('${min}h', style: GoogleFonts.inter(fontSize: 11, color: AppTheme.textMuted)),
              Text('${max}h', style: GoogleFonts.inter(fontSize: 11, color: AppTheme.textMuted)),
            ],
          ),
        ],
      ),
    ).animate().fadeIn(delay: Duration(milliseconds: delay)).slideY(begin: 0.05);
  }
}

class _WeeklyTotalCard extends StatelessWidget {
  final int weekdayHours;
  final int weekendHours;
  final int delay;

  const _WeeklyTotalCard({
    required this.weekdayHours,
    required this.weekendHours,
    required this.delay,
  });

  @override
  Widget build(BuildContext context) {
    final weekdayTotal = weekdayHours * 5;
    final weekendTotal = weekendHours * 2;
    final weeklyTotal = weekdayTotal + weekendTotal;

    return Container(
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
                  'Weekday',
                  style: GoogleFonts.inter(
                      fontSize: 11,
                      color: Colors.white.withValues(alpha: 0.7)),
                ),
                Text(
                  '$weekdayTotal hrs',
                  style: GoogleFonts.inter(
                      fontSize: 22, fontWeight: FontWeight.w700, color: Colors.white),
                ),
              ],
            ),
          ),
          Container(
              width: 1,
              height: 48,
              color: Colors.white.withValues(alpha: 0.3)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Weekend',
                  style: GoogleFonts.inter(
                      fontSize: 11,
                      color: Colors.white.withValues(alpha: 0.7)),
                ),
                Text(
                  '$weekendTotal hrs',
                  style: GoogleFonts.inter(
                      fontSize: 22, fontWeight: FontWeight.w700, color: Colors.white),
                ),
              ],
            ),
          ),
          Container(
              width: 1,
              height: 48,
              color: Colors.white.withValues(alpha: 0.3)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Weekly Total',
                  style: GoogleFonts.inter(
                      fontSize: 11,
                      color: Colors.white.withValues(alpha: 0.7)),
                ),
                Text(
                  '$weeklyTotal hrs',
                  style: GoogleFonts.inter(
                      fontSize: 22, fontWeight: FontWeight.w700, color: Colors.white),
                ),
              ],
            ),
          ),
        ],
      ),
    ).animate().fadeIn(delay: Duration(milliseconds: delay)).slideY(begin: 0.1);
  }
}
