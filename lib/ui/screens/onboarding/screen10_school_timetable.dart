import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/app_theme.dart';
import '../../../providers/app_providers.dart';

/// Screen 10: School Timetable — collect school hours, coaching/tuition,
/// and commute info so we can compute free slots for missions.
class Screen10SchoolTimetable extends ConsumerStatefulWidget {
  const Screen10SchoolTimetable({super.key, this.onFormChanged});

  static bool isFormValid = false;
  final VoidCallback? onFormChanged;

  @override
  ConsumerState<Screen10SchoolTimetable> createState() =>
      _Screen10SchoolTimetableState();
}

class _Screen10SchoolTimetableState
    extends ConsumerState<Screen10SchoolTimetable> {
  String? _schoolStartTime;
  String? _schoolEndTime;
  bool _hasCoaching = false;
  String? _coachingStartTime;
  String? _coachingEndTime;
  bool _hasCommute = true;
  String? _commuteDuration;

  /// Typical Indian 11th grader presets.
  static const Map<String, String> _presets = {
    'schoolStart': '07:30',
    'schoolEnd': '14:00',
    'coachingStart': '15:00',
    'coachingEnd': '18:00',
    'commuteDuration': '45',
  };

  static const List<String> _timeOptions = [
    '06:00', '06:30', '07:00', '07:30', '08:00', '08:30',
    '09:00', '09:30', '10:00', '10:30', '11:00', '11:30',
    '12:00', '12:30', '13:00', '13:30', '14:00', '14:30',
    '15:00', '15:30', '16:00', '16:30', '17:00', '17:30',
    '18:00', '18:30', '19:00', '19:30', '20:00',
  ];

  static const List<String> _commuteOptions = [
    '15 min', '30 min', '45 min', '1 hour', '1.5 hours', '2 hours',
  ];

  @override
  void initState() {
    super.initState();
    final data = ref.read(onboardingDataProvider);
    _schoolStartTime = data.schoolStartTime;
    _schoolEndTime = data.schoolEndTime;
    _hasCoaching = data.hasCoaching;
    _coachingStartTime = data.coachingStartTime;
    _coachingEndTime = data.coachingEndTime;
    _hasCommute = data.hasCommute;
    _commuteDuration = data.commuteDuration;
    _validateForm();
  }

  void _saveToProvider() {
    final notifier = ref.read(onboardingDataProvider.notifier);
    notifier.updateSchoolTimetable(
      schoolStartTime: _schoolStartTime,
      schoolEndTime: _schoolEndTime,
      hasCoaching: _hasCoaching,
      coachingStartTime: _coachingStartTime,
      coachingEndTime: _coachingEndTime,
      hasCommute: _hasCommute,
      commuteDuration: _commuteDuration,
    );
  }

  void _validateForm() {
    final valid = _schoolStartTime != null && _schoolEndTime != null;
    Screen10SchoolTimetable.isFormValid = valid;
    widget.onFormChanged?.call();
  }

  void _applyPreset() {
    HapticFeedback.mediumImpact();
    setState(() {
      _schoolStartTime = _presets['schoolStart'];
      _schoolEndTime = _presets['schoolEnd'];
      _hasCoaching = true;
      _coachingStartTime = _presets['coachingStart'];
      _coachingEndTime = _presets['coachingEnd'];
      _hasCommute = true;
      _commuteDuration = _presets['commuteDuration'];
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
          const SizedBox(height: 40),
          Text(
            'School\nTimetable',
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
            'Tell us your school hours — we\'ll find free slots for missions',
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: AppTheme.textSecondary,
            ),
          ).animate().fadeIn(delay: 100.ms).slideX(begin: -0.2),
          const SizedBox(height: 24),

          // Quick Preset
          _InfoBanner(
            icon: Icons.auto_fix_high_rounded,
            text: 'Typical Indian 11th grader? Tap to pre-fill, then customise.',
            actionLabel: 'Apply Preset',
            onAction: _applyPreset,
          ).animate().fadeIn(delay: 200.ms),
          const SizedBox(height: 24),

          // School Hours Card
          _SectionCard(
            title: 'School Hours',
            subtitle: 'When does your school day start and end?',
            icon: Icons.school_rounded,
            color: AppTheme.primaryBlue,
            delay: 300,
            child: Row(
              children: [
                Expanded(
                  child: _TimeDropdown(
                    label: 'Start',
                    value: _schoolStartTime,
                    options: _timeOptions,
                    onChanged: (val) => setState(() {
                      _schoolStartTime = val;
                      _saveToProvider();
                      _validateForm();
                    }),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Icon(
                    Icons.arrow_forward_rounded,
                    color: AppTheme.textMuted,
                    size: 20,
                  ),
                ),
                Expanded(
                  child: _TimeDropdown(
                    label: 'End',
                    value: _schoolEndTime,
                    options: _timeOptions,
                    onChanged: (val) => setState(() {
                      _schoolEndTime = val;
                      _saveToProvider();
                      _validateForm();
                    }),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Coaching / Tuition Card
          _SectionCard(
            title: 'Coaching / Tuition',
            subtitle: 'Do you attend coaching classes after school?',
            icon: Icons.menu_book_rounded,
            color: AppTheme.accentGold,
            delay: 400,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'I attend coaching',
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: AppTheme.textPrimary,
                        ),
                      ),
                    ),
                    Switch(
                      value: _hasCoaching,
                      onChanged: (val) {
                        HapticFeedback.lightImpact();
                        setState(() {
                          _hasCoaching = val;
                          if (!val) {
                            _coachingStartTime = null;
                            _coachingEndTime = null;
                          }
                          _saveToProvider();
                        });
                      },
                      activeColor: AppTheme.primaryBlue,
                    ),
                  ],
                ),
                if (_hasCoaching) ...[
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _TimeDropdown(
                          label: 'Start',
                          value: _coachingStartTime,
                          options: _timeOptions,
                          onChanged: (val) => setState(() {
                            _coachingStartTime = val;
                            _saveToProvider();
                          }),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Icon(
                          Icons.arrow_forward_rounded,
                          color: AppTheme.textMuted,
                          size: 20,
                        ),
                      ),
                      Expanded(
                        child: _TimeDropdown(
                          label: 'End',
                          value: _coachingEndTime,
                          options: _timeOptions,
                          onChanged: (val) => setState(() {
                            _coachingEndTime = val;
                            _saveToProvider();
                          }),
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Commute Card
          _SectionCard(
            title: 'Commute',
            subtitle: 'How long is your daily commute (one way)?',
            icon: Icons.directions_bus_rounded,
            color: AppTheme.successGreen,
            delay: 500,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'I commute to school',
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: AppTheme.textPrimary,
                        ),
                      ),
                    ),
                    Switch(
                      value: _hasCommute,
                      onChanged: (val) {
                        HapticFeedback.lightImpact();
                        setState(() {
                          _hasCommute = val;
                          if (!val) _commuteDuration = null;
                          _saveToProvider();
                        });
                      },
                      activeColor: AppTheme.primaryBlue,
                    ),
                  ],
                ),
                if (_hasCommute) ...[
                  const SizedBox(height: 12),
                  _DropdownField(
                    label: 'One-way commute',
                    value: _commuteDuration,
                    items: _commuteOptions,
                    onChanged: (val) => setState(() {
                      _commuteDuration = val;
                      _saveToProvider();
                    }),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Preview
          if (_schoolStartTime != null && _schoolEndTime != null)
            _TimetableSummary(
              schoolStart: _schoolStartTime!,
              schoolEnd: _schoolEndTime!,
              hasCoaching: _hasCoaching,
              coachingStart: _coachingStartTime,
              coachingEnd: _coachingEndTime,
              hasCommute: _hasCommute,
              commuteDuration: _commuteDuration,
            ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

// ─── Helper Widgets ──────────────────────────────────────────────────────

class _InfoBanner extends StatelessWidget {
  final IconData icon;
  final String text;
  final String actionLabel;
  final VoidCallback onAction;

  const _InfoBanner({
    required this.icon,
    required this.text,
    required this.actionLabel,
    required this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.primaryBlue.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.primaryBlue.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppTheme.primaryBlue, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: AppTheme.primaryBlue,
              ),
            ),
          ),
          TextButton(
            onPressed: onAction,
            child: Text(actionLabel,
                style: GoogleFonts.inter(fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final int delay;
  final Widget child;

  const _SectionCard({
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
        color: context.surfaceElevated,
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
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: color, size: 20),
              ),
              const SizedBox(width: 12),
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
                    Text(
                      subtitle,
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: AppTheme.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ).animate().fadeIn(delay: Duration(milliseconds: delay)).slideX(begin: -0.15),
          const SizedBox(height: 16),
          child,
        ],
      ),
    ).animate().fadeIn(delay: Duration(milliseconds: delay)).slideY(begin: 0.05);
  }
}

class _TimeDropdown extends StatelessWidget {
  final String label;
  final String? value;
  final List<String> options;
  final ValueChanged<String?> onChanged;

  const _TimeDropdown({
    required this.label,
    required this.value,
    required this.options,
    required this.onChanged,
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
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        isDense: true,
      ),
      items: options
          .map((t) => DropdownMenuItem(
                value: t,
                child: Text(t, style: GoogleFonts.inter(fontSize: 14)),
              ))
          .toList(),
      onChanged: onChanged,
      style: GoogleFonts.inter(fontSize: 14, color: AppTheme.textPrimary),
      dropdownColor: context.surfaceElevated,
    );
  }
}

class _DropdownField extends StatelessWidget {
  final String label;
  final String? value;
  final List<String> items;
  final ValueChanged<String?> onChanged;

  const _DropdownField({
    required this.label,
    required this.value,
    required this.items,
    required this.onChanged,
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
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
      items: items
          .map((e) => DropdownMenuItem(
                value: e,
                child: Text(e, style: GoogleFonts.inter()),
              ))
          .toList(),
      onChanged: onChanged,
      style: GoogleFonts.inter(fontSize: 16, color: AppTheme.textPrimary),
      dropdownColor: context.surfaceElevated,
    );
  }
}

class _TimetableSummary extends StatelessWidget {
  final String schoolStart;
  final String schoolEnd;
  final bool hasCoaching;
  final String? coachingStart;
  final String? coachingEnd;
  final bool hasCommute;
  final String? commuteDuration;

  const _TimetableSummary({
    required this.schoolStart,
    required this.schoolEnd,
    required this.hasCoaching,
    this.coachingStart,
    this.coachingEnd,
    required this.hasCommute,
    this.commuteDuration,
  });

  String _formatDuration(String start, String end) {
    final sParts = start.split(':');
    final eParts = end.split(':');
    if (sParts.length != 2 || eParts.length != 2) return '';
    final sMin = int.parse(sParts[0]) * 60 + int.parse(sParts[1]);
    final eMin = int.parse(eParts[0]) * 60 + int.parse(eParts[1]);
    final diff = eMin - sMin;
    if (diff <= 0) return '';
    final h = diff ~/ 60;
    final m = diff % 60;
    return m > 0 ? '${h}h ${m}m' : '${h}h';
  }

  @override
  Widget build(BuildContext context) {
    final schoolDuration = _formatDuration(schoolStart, schoolEnd);
    final coachingDuration =
        hasCoaching && coachingStart != null && coachingEnd != null
            ? _formatDuration(coachingStart!, coachingEnd!)
            : '';

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: AppTheme.gradientSuccess,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Your Daily Schedule',
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.white.withValues(alpha: 0.9),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _SummaryItem(
                label: 'School',
                value: '$schoolStart – $schoolEnd',
                sublabel: schoolDuration,
              ),
              if (hasCoaching && coachingDuration.isNotEmpty) ...[
                Container(
                    width: 1,
                    height: 40,
                    color: Colors.white.withValues(alpha: 0.3)),
                _SummaryItem(
                  label: 'Coaching',
                  value: '$coachingStart – $coachingEnd',
                  sublabel: coachingDuration,
                ),
              ],
              if (hasCommute && commuteDuration != null) ...[
                Container(
                    width: 1,
                    height: 40,
                    color: Colors.white.withValues(alpha: 0.3)),
                _SummaryItem(
                  label: 'Commute',
                  value: commuteDuration!,
                  sublabel: 'one way',
                ),
              ],
            ],
          ),
        ],
      ),
    ).animate().fadeIn(delay: 600.ms).slideY(begin: 0.15);
  }
}

class _SummaryItem extends StatelessWidget {
  final String label;
  final String value;
  final String sublabel;

  const _SummaryItem({
    required this.label,
    required this.value,
    required this.sublabel,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 11,
              color: Colors.white.withValues(alpha: 0.7),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
          Text(
            sublabel,
            style: GoogleFonts.inter(
              fontSize: 11,
              color: Colors.white.withValues(alpha: 0.7),
            ),
          ),
        ],
      ),
    );
  }
}
