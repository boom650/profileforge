import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/app_theme.dart';

class Screen4AcademicProfile extends StatefulWidget {
  const Screen4AcademicProfile({super.key});

  /// Static GlobalKey so the onboarding flow can trigger validation.
  static final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  /// Whether the form is currently valid — updated by _FormValidationListener.
  static bool isFormValid = false;

  @override
  State<Screen4AcademicProfile> createState() => _Screen4AcademicProfileState();
}

class _Screen4AcademicProfileState extends State<Screen4AcademicProfile> {
  final _tenthPercentageController = TextEditingController(text: '94.2');
  final _coachingInstituteController = TextEditingController();
  final _coachingHoursController = TextEditingController();
  final _satScoreController = TextEditingController();
  final _ieltsScoreController = TextEditingController();

  String? _selectedBoard;
  String? _selectedStream;
  String? _selectedGrade;

  final List<TextEditingController> _subjectControllers = [
    TextEditingController(text: '85'),
    TextEditingController(text: '82'),
    TextEditingController(text: '90'),
    TextEditingController(text: '88'),
    TextEditingController(text: '92'),
  ];

  final List<String> _subjectNames = [
    'Physics', 'Chemistry', 'Mathematics', 'English', 'Computer Science',
  ];

  @override
  void dispose() {
    _tenthPercentageController.dispose();
    _coachingInstituteController.dispose();
    _coachingHoursController.dispose();
    _satScoreController.dispose();
    _ieltsScoreController.dispose();
    for (final c in _subjectControllers) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _FormValidationListener(
      formKey: Screen4AcademicProfile.formKey,
      onChanged: (valid) => Screen4AcademicProfile.isFormValid = valid,
      child: Form(
        key: Screen4AcademicProfile.formKey,
        onChanged: () {
          final form = Screen4AcademicProfile.formKey.currentState;
          if (form != null) {
            Screen4AcademicProfile.isFormValid = form.validate();
          }
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),
              Text(
                'Academic Profile',
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
                'Your grades tell us where you stand',
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: AppTheme.textSecondary,
                ),
              ).animate().fadeIn(delay: 100.ms).slideX(begin: -0.2),
              const SizedBox(height: 32),
              // Board & Stream
              Row(
                children: [
                  Expanded(
                    child: _ValidatedDropdownField(
                      label: 'Board',
                      value: _selectedBoard,
                      items: ['CBSE', 'ICSE', 'State Board', 'IB', 'IGCSE', 'NIOS'],
                      delay: 200,
                      onChanged: (val) => setState(() => _selectedBoard = val),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Select a board';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _ValidatedDropdownField(
                      label: 'Stream',
                      value: _selectedStream,
                      items: ['Science', 'Commerce', 'Humanities', 'Vocational'],
                      delay: 250,
                      onChanged: (val) => setState(() => _selectedStream = val),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Select a stream';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _ValidatedDropdownField(
                label: 'Grade',
                value: _selectedGrade,
                items: ['9th', '10th', '11th', '12th'],
                delay: 300,
                onChanged: (val) => setState(() => _selectedGrade = val),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Select your grade';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              Text(
                'Subjects & Current %',
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textPrimary,
                ),
              ).animate().fadeIn(delay: 350.ms),
              const SizedBox(height: 12),
              Column(
                children: List.generate(_subjectNames.length, (index) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: Text(
                            _subjectNames[index],
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: AppTheme.textPrimary,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          flex: 2,
                          child: TextFormField(
                            controller: _subjectControllers[index],
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              hintText: '%',
                              suffixText: '%',
                              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                              errorStyle: const TextStyle(fontSize: 10, height: 0.8),
                            ),
                            style: GoogleFonts.inter(fontSize: 14),
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Required';
                              }
                              final score = int.tryParse(value.trim());
                              if (score == null) {
                                return 'Invalid';
                              }
                              if (score < 0 || score > 100) {
                                return '0-100';
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ).animate().fadeIn(delay: Duration(milliseconds: 400 + index * 50)).slideX(begin: 0.1),
                  );
                }),
              ),
              const SizedBox(height: 24),
              _ValidatedInputField(
                controller: _tenthPercentageController,
                label: '10th Board Percentage',
                hintText: 'e.g., 94.2%',
                prefixIcon: Icons.percent_rounded,
                delay: 600,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter your 10th percentage';
                  }
                  final score = double.tryParse(value.trim().replaceAll('%', ''));
                  if (score == null) {
                    return 'Enter a valid number';
                  }
                  if (score < 0 || score > 100) {
                    return 'Must be between 0-100';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _ValidatedInputField(
                      controller: _coachingInstituteController,
                      label: 'Coaching Institute',
                      hintText: 'e.g., Allen, Aakash, FIITJEE',
                      prefixIcon: Icons.business_rounded,
                      delay: 650,
                      validator: (value) {
                        // Optional field — no validation
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _ValidatedInputField(
                      controller: _coachingHoursController,
                      label: 'Coaching Hours/Week',
                      hintText: 'e.g., 20',
                      prefixIcon: Icons.access_time_rounded,
                      keyboardType: TextInputType.number,
                      delay: 700,
                      validator: (value) {
                        if (value != null && value.trim().isNotEmpty) {
                          final hours = int.tryParse(value.trim());
                          if (hours == null) {
                            return 'Enter a number';
                          }
                          if (hours < 0 || hours > 80) {
                            return '0-80 hrs';
                          }
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _ValidatedInputField(
                      controller: _satScoreController,
                      label: 'SAT Score',
                      hintText: 'e.g., 1450',
                      prefixIcon: Icons.grade_rounded,
                      keyboardType: TextInputType.number,
                      delay: 750,
                      validator: (value) {
                        if (value != null && value.trim().isNotEmpty) {
                          final score = int.tryParse(value.trim());
                          if (score == null) {
                            return 'Enter a number';
                          }
                          if (score < 400 || score > 1600) {
                            return '400-1600';
                          }
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _ValidatedInputField(
                      controller: _ieltsScoreController,
                      label: 'IELTS Score',
                      hintText: 'e.g., 7.5',
                      prefixIcon: Icons.language_rounded,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      delay: 800,
                      validator: (value) {
                        if (value != null && value.trim().isNotEmpty) {
                          final score = double.tryParse(value.trim());
                          if (score == null) {
                            return 'Enter a number';
                          }
                          if (score < 0 || score > 9) {
                            return '0-9';
                          }
                        }
                        return null;
                      },
                    ),
                  ),
                ],
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
                    Icon(Icons.info_outline_rounded, color: AppTheme.primaryBlue, size: 20),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        '11th grade marks are critical — they\'re used for predicted grades (US/UK) and early admissions (Canada/Australia)',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: AppTheme.primaryBlue,
                        ),
                      ),
                    ),
                  ],
                ),
              ).animate().fadeIn(delay: 850.ms),
            ],
          ),
        ),
      ),
    );
  }
}

/// A helper widget that listens to form validation changes and calls [onChanged].
class _FormValidationListener extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final ValueChanged<bool> onChanged;
  final Widget child;

  const _FormValidationListener({
    required this.formKey,
    required this.onChanged,
    required this.child,
  });

  @override
  State<_FormValidationListener> createState() => _FormValidationListenerState();
}

class _FormValidationListenerState extends State<_FormValidationListener> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkValidation();
    });
  }

  void _checkValidation() {
    final form = widget.formKey.currentState;
    if (form != null) {
      widget.onChanged(form.validate());
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}

class _ValidatedDropdownField extends StatelessWidget {
  final String label;
  final String? value;
  final List<String> items;
  final int delay;
  final ValueChanged<String?> onChanged;
  final FormFieldValidator<String>? validator;

  const _ValidatedDropdownField({
    required this.label,
    required this.value,
    required this.items,
    required this.delay,
    required this.onChanged,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      initialValue: value,
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
        errorStyle: const TextStyle(fontSize: 12),
      ),
      items: items.map((e) => DropdownMenuItem(value: e, child: Text(e, style: GoogleFonts.inter()))).toList(),
      onChanged: onChanged,
      validator: validator,
      style: GoogleFonts.inter(fontSize: 16, color: AppTheme.textPrimary),
      dropdownColor: AppTheme.surfaceWhite,
    ).animate().fadeIn(delay: Duration(milliseconds: delay)).slideY(begin: 0.1);
  }
}

class _ValidatedInputField extends StatelessWidget {
  final TextEditingController? controller;
  final String label;
  final String hintText;
  final IconData prefixIcon;
  final int delay;
  final TextInputType? keyboardType;
  final FormFieldValidator<String>? validator;

  const _ValidatedInputField({
    this.controller,
    required this.label,
    required this.hintText,
    required this.prefixIcon,
    required this.delay,
    this.keyboardType,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        hintText: hintText,
        prefixIcon: Icon(prefixIcon, color: AppTheme.primaryBlue),
        labelStyle: GoogleFonts.inter(color: AppTheme.textSecondary),
        filled: true,
        fillColor: AppTheme.surfaceLight,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        errorStyle: const TextStyle(fontSize: 12),
      ),
      style: GoogleFonts.inter(fontSize: 16, color: AppTheme.textPrimary),
      validator: validator,
    ).animate().fadeIn(delay: Duration(milliseconds: delay)).slideY(begin: 0.1);
  }
}
