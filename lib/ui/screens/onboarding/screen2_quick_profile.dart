import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/app_theme.dart';
import '../../../providers/providers.dart';

class Screen2QuickProfile extends ConsumerStatefulWidget {
  const Screen2QuickProfile({super.key, this.onFormChanged});

  /// Static GlobalKey so the onboarding flow can trigger validation.
  static final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  /// Whether the form is currently valid — updated by _FormValidationListener.
  static bool isFormValid = false;
  /// Whether the user has clicked Continue at least once.
  /// Errors only show after first submission.
  static bool hasSubmitted = false;

  /// Called when form validity changes, so the parent flow can rebuild.
  final VoidCallback? onFormChanged;

  @override
  ConsumerState<Screen2QuickProfile> createState() => _Screen2QuickProfileState();
}

class _Screen2QuickProfileState extends ConsumerState<Screen2QuickProfile> {
  final _nameController = TextEditingController();
  final _subject1Controller = TextEditingController();
  final _subject1ScoreController = TextEditingController();
  final _subject2Controller = TextEditingController();
  final _subject2ScoreController = TextEditingController();
  final _subject3Controller = TextEditingController();
  final _subject3ScoreController = TextEditingController();

  String? _selectedBoard;
  String? _selectedStream;
  String? _selectedGrade;

  @override
  void initState() {
    super.initState();
    // Restore any previously saved onboarding data
    final existingData = ref.read(onboardingDataProvider);
    if (existingData.name.isNotEmpty) {
      _nameController.text = existingData.name;
    }
    if (existingData.board != null) {
      _selectedBoard = existingData.board;
    }
    if (existingData.stream != null) {
      _selectedStream = existingData.stream;
    }
    if (existingData.grade != null) {
      _selectedGrade = _gradeToString(existingData.grade!);
    }
    // Restore subjects
    final subjectKeys = existingData.subjects.keys.toList();
    if (subjectKeys.isNotEmpty) {
      _subject1Controller.text = subjectKeys[0];
      _subject1ScoreController.text =
          existingData.subjects[subjectKeys[0]]?.toInt().toString() ?? '';
    }
    if (subjectKeys.length > 1) {
      _subject2Controller.text = subjectKeys[1];
      _subject2ScoreController.text =
          existingData.subjects[subjectKeys[1]]?.toInt().toString() ?? '';
    }
    if (subjectKeys.length > 2) {
      _subject3Controller.text = subjectKeys[2];
      _subject3ScoreController.text =
          existingData.subjects[subjectKeys[2]]?.toInt().toString() ?? '';
    }
  }

  int? _gradeToInt(String grade) {
    final map = {'9th': 9, '10th': 10, '11th': 11, '12th': 12};
    return map[grade];
  }

  String _gradeToString(int grade) {
    final map = {9: '9th', 10: '10th', 11: '11th', 12: '12th'};
    return map[grade] ?? '11th';
  }

  /// Save all current form data to the onboarding data provider.
  void _saveToProvider() {
    final notifier = ref.read(onboardingDataProvider.notifier);

    // Save name
    notifier.updateName(_nameController.text);

    // Save board, stream, grade
    notifier.updateBoard(_selectedBoard);
    notifier.updateStream(_selectedStream);
    final gradeInt = _gradeToInt(_selectedGrade ?? '');
    notifier.updateGrade(gradeInt);

    // Save subjects (name -> score pairs)
    final subjects = <String, double>{};
    if (_subject1Controller.text.trim().isNotEmpty &&
        _subject1ScoreController.text.trim().isNotEmpty) {
      final score = double.tryParse(_subject1ScoreController.text.trim());
      if (score != null) {
        subjects[_subject1Controller.text.trim()] = score;
      }
    }
    if (_subject2Controller.text.trim().isNotEmpty &&
        _subject2ScoreController.text.trim().isNotEmpty) {
      final score = double.tryParse(_subject2ScoreController.text.trim());
      if (score != null) {
        subjects[_subject2Controller.text.trim()] = score;
      }
    }
    if (_subject3Controller.text.trim().isNotEmpty &&
        _subject3ScoreController.text.trim().isNotEmpty) {
      final score = double.tryParse(_subject3ScoreController.text.trim());
      if (score != null) {
        subjects[_subject3Controller.text.trim()] = score;
      }
    }
    notifier.replaceSubjects(subjects);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _subject1Controller.dispose();
    _subject1ScoreController.dispose();
    _subject2Controller.dispose();
    _subject2ScoreController.dispose();
    _subject3Controller.dispose();
    _subject3ScoreController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _FormValidationListener(
      formKey: Screen2QuickProfile.formKey,
      onChanged: (valid) {
        Screen2QuickProfile.isFormValid = valid;
        widget.onFormChanged?.call();
      },
      child: Form(
        key: Screen2QuickProfile.formKey,
        onChanged: () {
          _saveToProvider();
          final name = _nameController.text.trim();
          final board = _selectedBoard;
          final stream = _selectedStream;
          final grade = _selectedGrade;
          Screen2QuickProfile.isFormValid =
              name.isNotEmpty && board != null && stream != null && grade != null;
          widget.onFormChanged?.call();
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: AppTheme.spacingXxl),
              // Header with completion indicator
              Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      gradient: AppTheme.gradientPrimary,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.person_rounded, color: Colors.white, size: 22),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Quick Profile',
                          style: GoogleFonts.inter(
                            fontSize: 28,
                            fontWeight: FontWeight.w800,
                            color: AppTheme.textPrimary,
                            letterSpacing: -0.5,
                            height: 1.2,
                          ),
                        ),
                        Text(
                          'Takes 30 seconds — shapes your entire strategy',
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: AppTheme.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ).animate().fadeIn().slideX(begin: -0.2),
              const SizedBox(height: 28),
              // Name field with validation feedback
              _ValidatedInputField(
                controller: _nameController,
                label: 'Your Name',
                hintText: 'e.g., Aarav Patel',
                prefixIcon: Icons.person_rounded,
                delay: 200,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter your name';
                  }
                  if (value.trim().length < 2) {
                    return 'Name must be at least 2 characters';
                  }
                  if (value.trim().length > 50) {
                    return 'Name must be less than 50 characters';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              // Board & Stream row
              Row(
                children: [
                  Expanded(
                    child: _ValidatedDropdownField(
                      label: 'Board',
                      value: _selectedBoard,
                      items: ['CBSE', 'ICSE', 'State Board', 'IB', 'IGCSE', 'NIOS'],
                      delay: 300,
                      onChanged: (val) => setState(() {
                        _selectedBoard = val;
                        _saveToProvider();
                      }),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Select a board';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _ValidatedDropdownField(
                      label: 'Stream',
                      value: _selectedStream,
                      items: ['Science', 'Commerce', 'Arts', 'Vocational'],
                      delay: 350,
                      onChanged: (val) => setState(() {
                        _selectedStream = val;
                        _saveToProvider();
                      }),
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
              // Grade dropdown
              _ValidatedDropdownField(
                label: 'Grade',
                value: _selectedGrade,
                items: ['9th', '10th', '11th', '12th'],
                delay: 400,
                onChanged: (val) => setState(() {
                  _selectedGrade = val;
                  _saveToProvider();
                }),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Select your grade';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              // Completion status badge
              _CompletionBadge(
                name: _nameController.text.trim(),
                board: _selectedBoard,
                stream: _selectedStream,
                grade: _selectedGrade,
              ),
              const SizedBox(height: 24),
              // 3 Key Subject Scores
              Row(
                children: [
                  Text(
                    'Subject Scores',
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: AppTheme.successGreen.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'Optional',
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.successGreen,
                      ),
                    ),
                  ),
                ],
              ).animate().fadeIn(delay: 450.ms),
              const SizedBox(height: 4),
              Text(
                'Add your strongest subjects — helps calculate academic probability',
                style: GoogleFonts.inter(
                  fontSize: 12,
                  color: AppTheme.textMuted,
                ),
              ).animate().fadeIn(delay: 460.ms),
              const SizedBox(height: 12),
              _SubjectScoreRow(
                label: 'Subject 1',
                example: 'e.g., Mathematics',
                nameController: _subject1Controller,
                scoreController: _subject1ScoreController,
                delay: 500,
              ),
              const SizedBox(height: 12),
              _SubjectScoreRow(
                label: 'Subject 2',
                example: 'e.g., Physics',
                nameController: _subject2Controller,
                scoreController: _subject2ScoreController,
                delay: 550,
              ),
              const SizedBox(height: 12),
              _SubjectScoreRow(
                label: 'Subject 3',
                example: 'e.g., English',
                nameController: _subject3Controller,
                scoreController: _subject3ScoreController,
                delay: 600,
              ),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppTheme.primaryBlue.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppTheme.primaryBlue.withValues(alpha: 0.15)),
                ),
                child: Row(
                  children: [
                    Icon(Icons.info_outline_rounded, color: AppTheme.primaryBlue, size: 18),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'SAT/IELTS scores will be asked later when relevant to your targets.',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: AppTheme.primaryBlue,
                        ),
                      ),
                    ),
                  ],
                ),
              ).animate().fadeIn(delay: 700.ms),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

/// Shows a mini completion badge so the user knows their progress.
class _CompletionBadge extends StatelessWidget {
  final String name;
  final String? board;
  final String? stream;
  final String? grade;

  const _CompletionBadge({
    required this.name,
    this.board,
    this.stream,
    this.grade,
  });

  @override
  Widget build(BuildContext context) {
    final fields = [name.isNotEmpty, board != null, stream != null, grade != null];
    final filled = fields.where((f) => f).length;
    final total = fields.length;
    final progress = filled / total;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: progress >= 1.0
            ? AppTheme.successGreen.withValues(alpha: 0.06)
            : AppTheme.primaryBlue.withValues(alpha: 0.04),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: progress >= 1.0
              ? AppTheme.successGreen.withValues(alpha: 0.2)
              : AppTheme.primaryBlue.withValues(alpha: 0.1),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(
                progress >= 1.0 ? Icons.check_circle_rounded : Icons.info_outline_rounded,
                size: 16,
                color: progress >= 1.0 ? AppTheme.successGreen : AppTheme.primaryBlue,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  progress >= 1.0
                      ? 'Profile complete! Your admissions odds will be calculated.'
                      : '$filled/$total fields filled — complete all for best results',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: progress >= 1.0 ? AppTheme.successGreen : AppTheme.primaryBlue,
                  ),
                ),
              ),
            ],
          ),
          if (progress < 1.0) ...[
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: progress,
                backgroundColor: AppTheme.primaryBlue.withValues(alpha: 0.1),
                color: AppTheme.primaryBlue,
                minHeight: 3,
              ),
            ),
          ],
        ],
      ),
    ).animate().fadeIn(delay: 250.ms);
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
      final form = widget.formKey.currentState;
      if (form != null && mounted) {
        final isValid = form.validate();
        if (isValid != Screen2QuickProfile.isFormValid) {
          Screen2QuickProfile.isFormValid = isValid;
          widget.onChanged(isValid);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}

class _SubjectScoreRow extends StatelessWidget {
  final String label;
  final String example;
  final int delay;
  final TextEditingController nameController;
  final TextEditingController scoreController;

  const _SubjectScoreRow({
    required this.label,
    required this.example,
    required this.delay,
    required this.nameController,
    required this.scoreController,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 3,
          child: _ValidatedInputField(
            controller: nameController,
            label: label,
            hintText: example,
            prefixIcon: Icons.book_rounded,
            delay: delay,
            validator: (value) {
              final scoreValue = scoreController.text.trim();
              if (value == null || value.trim().isEmpty) {
                if (scoreValue.isNotEmpty) return 'Name needed with score';
                return null;
              }
              return null;
            },
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          flex: 1,
          child: TextFormField(
            controller: scoreController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              hintText: '%',
              suffixText: '%',
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
              filled: true,
              fillColor: AppTheme.surfaceLight,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              errorStyle: GoogleFonts.inter(fontSize: 10, height: 0.8),
            ),
            style: GoogleFonts.inter(fontSize: 16, color: AppTheme.textPrimary),
            validator: (value) {
              final nameValue = nameController.text.trim();
              if (value == null || value.trim().isEmpty) {
                if (nameValue.isNotEmpty) return 'Score needed';
                return null;
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
          ).animate().fadeIn(delay: Duration(milliseconds: delay + 50)),
        ),
      ],
    );
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
        errorStyle: GoogleFonts.inter(fontSize: 12),
      ),
      items: items.map((e) => DropdownMenuItem(value: e, child: Text(e, style: GoogleFonts.inter()))).toList(),
      onChanged: onChanged,
      validator: validator,
      style: GoogleFonts.inter(fontSize: 16, color: AppTheme.textPrimary),
      dropdownColor: context.surfaceElevated,
    ).animate().fadeIn(delay: Duration(milliseconds: delay)).slideY(begin: 0.1);
  }
}

class _ValidatedInputField extends StatelessWidget {
  final TextEditingController? controller;
  final String label;
  final String hintText;
  final IconData prefixIcon;
  final int delay;
  final FormFieldValidator<String>? validator;

  const _ValidatedInputField({
    this.controller,
    required this.label,
    required this.hintText,
    required this.prefixIcon,
    required this.delay,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
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
        errorStyle: GoogleFonts.inter(fontSize: 12),
      ),
      style: GoogleFonts.inter(fontSize: 16, color: AppTheme.textPrimary),
      validator: validator,
    ).animate().fadeIn(delay: Duration(milliseconds: delay)).slideY(begin: 0.1);
  }
}
