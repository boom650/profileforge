import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/app_theme.dart';
import '../../../providers/providers.dart';

/// Screen 12: School Frequency — select how many days per week the
/// student attends school, and which days.
class Screen12SchoolFrequency extends ConsumerStatefulWidget {
  const Screen12SchoolFrequency({super.key, this.onFormChanged});

  static bool isFormValid = false;
  final VoidCallback? onFormChanged;

  @override
  ConsumerState<Screen12SchoolFrequency> createState() =>
      _Screen12SchoolFrequencyState();
}

class _Screen12SchoolFrequencyState
    extends ConsumerState<Screen12SchoolFrequency> {
  int? _daysPerWeek;
  final Set<String> _selectedDays = {};
  bool _hasSaturdaySchool = false;

  static const List<String> _allDays = [
    'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday',
    'Saturday', 'Sunday',
  ];
  static const List<String> _shortDays = [
    'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun',
  ];

  @override
  void initState() {
    super.initState();
    final data = ref.read(onboardingDataProvider);
    _daysPerWeek = data.schoolDaysPerWeek;
    _selectedDays.addAll(data.schoolDays);
    _hasSaturdaySchool = data.hasSaturdaySchool;
    _validateForm();
  }

  void _saveToProvider() {
    ref.read(onboardingDataProvider.notifier).updateSchoolFrequency(
      daysPerWeek: _daysPerWeek,
      schoolDays: Set<String>.from(_selectedDays),
      hasSaturdaySchool: _hasSaturdaySchool,
    );
  }

  void _validateForm() {
    Screen12SchoolFrequency.isFormValid = _daysPerWeek != null && _daysPerWeek! > 0;
    widget.onFormChanged?.call();
  }

  void _selectDaysPreset(int days) {
    HapticFeedback.mediumImpact();
    setState(() {
      _daysPerWeek = days;
      _selectedDays.clear();
      // Select first N weekdays
      for (int i = 0; i < days && i < 5; i++) {
        _selectedDays.add(_allDays[i]);
      }
      if (days > 5) {
        _selectedDays.add('Saturday');
      }
      _hasSaturdaySchool = days > 5;
    });
    _saveToProvider();
    _validateForm();
  }

  void _toggleDay(String day) {
    HapticFeedback.lightImpact();
    setState(() {
      if (_selectedDays.contains(day)) {
        _selectedDays.remove(day);
      } else {
        _selectedDays.add(day);
      }
      _daysPerWeek = _selectedDays.length;
      _hasSaturdaySchool = _selectedDays.contains('Saturday');
    });
    _saveToProvider();
    _validateForm();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: AppTheme.spacingXxl),
          Text(
            'School\nFrequency',
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
            'How many days a week do you attend school?',
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: AppTheme.textSecondary,
            ),
          ).animate().fadeIn(delay: 100.ms).slideX(begin: -0.2),
          const SizedBox(height: 28),

          // Quick Preset Buttons
          Row(
            children: [
              _PresetChip(
                label: '5 days',
                subtitle: 'Mon–Fri',
                isSelected: _daysPerWeek == 5 && !_hasSaturdaySchool,
                onTap: () => _selectDaysPreset(5),
                delay: 200,
              ),
              const SizedBox(width: 12),
              _PresetChip(
                label: '6 days',
                subtitle: 'Mon–Sat',
                isSelected: _daysPerWeek == 6 || (_hasSaturdaySchool && _daysPerWeek == 6),
                onTap: () => _selectDaysPreset(6),
                delay: 250,
              ),
              const SizedBox(width: 12),
              _PresetChip(
                label: 'Custom',
                subtitle: 'Pick days',
                isSelected: _daysPerWeek != null &&
                    _daysPerWeek != 5 &&
                    _daysPerWeek != 6,
                onTap: () {
                  HapticFeedback.lightImpact();
                  setState(() {
                    _daysPerWeek = null;
                    _selectedDays.clear();
                  });
                },
                delay: 300,
              ),
            ],
          ),
          const SizedBox(height: 28),

          // Day Picker Grid
          Container(
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
                  'Select your school days',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textPrimary,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: List.generate(7, (index) {
                    final day = _allDays[index];
                    final isSelected = _selectedDays.contains(day);
                    return Expanded(
                      child: GestureDetector(
                        onTap: () => _toggleDay(day),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          margin: EdgeInsets.only(right: index < 6 ? 6 : 0),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppTheme.primaryBlue
                                : AppTheme.primaryBlue.withValues(alpha: 0.05),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: isSelected
                                  ? AppTheme.primaryBlue
                                  : AppTheme.primaryBlue.withValues(alpha: 0.15),
                            ),
                          ),
                          child: Column(
                            children: [
                              Text(
                                _shortDays[index],
                                style: GoogleFonts.inter(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: isSelected
                                      ? Colors.white
                                      : AppTheme.textPrimary,
                                ),
                              ),
                              if (isSelected) ...[
                                const SizedBox(height: 4),
                                Icon(
                                  Icons.check_rounded,
                                  size: 14,
                                  color: Colors.white,
                                ),
                              ],
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
                ),
                if (_selectedDays.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  Text(
                    '${_selectedDays.length} day${_selectedDays.length > 1 ? 's' : ''} selected',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: AppTheme.successGreen,
                    ),
                  ),
                ],
              ],
            ),
          ).animate().fadeIn(delay: 350.ms).slideY(begin: 0.05),
          const SizedBox(height: 20),

          // Saturday School Toggle
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: context.surfaceElevated,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppTheme.accentGold.withValues(alpha: 0.2)),
            ),
            child: Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: AppTheme.accentGold.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.school_rounded,
                    color: AppTheme.accentGold,
                    size: 18,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Saturday School / Extra Classes',
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.textPrimary,
                        ),
                      ),
                      Text(
                        'Coaching on Saturday or school on Saturday?',
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          color: AppTheme.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                Switch(
                  value: _hasSaturdaySchool,
                  onChanged: (val) {
                    HapticFeedback.lightImpact();
                    setState(() {
                      _hasSaturdaySchool = val;
                      if (val && !_selectedDays.contains('Saturday')) {
                        _selectedDays.add('Saturday');
                        _daysPerWeek = _selectedDays.length;
                      } else if (!val && _selectedDays.contains('Saturday')) {
                        _selectedDays.remove('Saturday');
                        _daysPerWeek = _selectedDays.length;
                      }
                      _saveToProvider();
                    });
                  },
                  activeColor: AppTheme.primaryBlue,
                ),
              ],
            ),
          ).animate().fadeIn(delay: 450.ms),
          const SizedBox(height: 24),

          // Impact Preview
          if (_daysPerWeek != null && _daysPerWeek! > 0)
            _ImpactPreview(
              daysPerWeek: _daysPerWeek!,
              hasSaturday: _hasSaturdaySchool,
              delay: 500,
            ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

// ─── Helper Widgets ──────────────────────────────────────────────────────

class _PresetChip extends StatelessWidget {
  final String label;
  final String subtitle;
  final bool isSelected;
  final VoidCallback onTap;
  final int delay;

  const _PresetChip({
    required this.label,
    required this.subtitle,
    required this.isSelected,
    required this.onTap,
    required this.delay,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            color: isSelected
                ? AppTheme.primaryBlue
                : AppTheme.primaryBlue.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected
                  ? AppTheme.primaryBlue
                  : AppTheme.primaryBlue.withValues(alpha: 0.2),
            ),
          ),
          child: Column(
            children: [
              Text(
                label,
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: isSelected ? Colors.white : AppTheme.primaryBlue,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: GoogleFonts.inter(
                  fontSize: 11,
                  color: isSelected
                      ? Colors.white.withValues(alpha: 0.8)
                      : AppTheme.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ).animate().fadeIn(delay: Duration(milliseconds: delay)).scale(begin: const Offset(0.95, 0.95)),
    );
  }
}

class _ImpactPreview extends StatelessWidget {
  final int daysPerWeek;
  final bool hasSaturday;
  final int delay;

  const _ImpactPreview({
    required this.daysPerWeek,
    required this.hasSaturday,
    required this.delay,
  });

  @override
  Widget build(BuildContext context) {
    final weekdays = daysPerWeek > 5 ? 5 : daysPerWeek;
    final weekendDays = daysPerWeek > 5 ? daysPerWeek - 5 : 0;

    // Rough estimate: ~7 school hours/day, commute 1.5h, coaching 3h
    final schoolHours = weekdays * 10.5; // school + commute + coaching
    final weekendSchoolHours = weekendDays * 10.5;
    final totalSchoolHours = schoolHours + weekendSchoolHours;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: AppTheme.gradientPrimary,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Weekly Time Commitment',
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.white.withValues(alpha: 0.9),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'School Days',
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        color: Colors.white.withValues(alpha: 0.7),
                      ),
                    ),
                    Text(
                      '$daysPerWeek days/wk',
                      style: GoogleFonts.inter(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: 1,
                height: 44,
                color: Colors.white.withValues(alpha: 0.3),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Total Hours',
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        color: Colors.white.withValues(alpha: 0.7),
                      ),
                    ),
                    Text(
                      '${totalSchoolHours.toInt()} hrs/wk',
                      style: GoogleFonts.inter(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: 1,
                height: 44,
                color: Colors.white.withValues(alpha: 0.3),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Free Time',
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        color: Colors.white.withValues(alpha: 0.7),
                      ),
                    ),
                    Text(
                      '${(168 - totalSchoolHours - (7 * 8)).toInt()} hrs/wk',
                      style: GoogleFonts.inter(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    ).animate().fadeIn(delay: Duration(milliseconds: delay)).slideY(begin: 0.1);
  }
}
