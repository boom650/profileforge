import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/app_theme.dart';
import '../../../providers/app_providers.dart';

class Screen3Goals extends ConsumerStatefulWidget {
  const Screen3Goals({super.key, this.onFormChanged});

  /// Static GlobalKey so the onboarding flow can trigger validation.
  static final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  /// Whether the form is currently valid — updated by _FormValidationListener.
  static bool isFormValid = false;

  /// Called when form validity changes, so the parent flow can rebuild.
  final VoidCallback? onFormChanged;

  @override
  ConsumerState<Screen3Goals> createState() => _Screen3GoalsState();
}

class _Screen3GoalsState extends ConsumerState<Screen3Goals> {
  String? _selectedMajor;
  final Set<String> _selectedCountries = {};

  final reachUnis = ['MIT', 'Stanford', 'Harvard', 'Princeton', 'Oxford', 'Cambridge'];
  final matchUnis = ['Yale', 'Columbia', 'UCLA', 'UCL', 'Edinburgh', 'UofT'];
  final safetyUnis = ['UCSD', 'Purdue', 'UIUC', 'McGill', 'Melbourne', 'Waterloo'];

  @override
  void initState() {
    super.initState();
    // Restore previously saved onboarding data
    final existingData = ref.read(onboardingDataProvider);
    if (existingData.targetMajor != null && existingData.targetMajor!.isNotEmpty) {
      _selectedMajor = existingData.targetMajor;
    }
    if (existingData.targetCountries.isNotEmpty) {
      _selectedCountries.addAll(existingData.targetCountries);
    }
  }

  /// Save current goals data to the onboarding data provider.
  void _saveToProvider() {
    final notifier = ref.read(onboardingDataProvider.notifier);
    notifier.updateTargetMajor(_selectedMajor);
    notifier.updateTargetCountries(Set<String>.from(_selectedCountries));
  }

  @override
  Widget build(BuildContext context) {
    return _FormValidationListener(
      formKey: Screen3Goals.formKey,
      onChanged: (valid) {
        Screen3Goals.isFormValid = valid;
        widget.onFormChanged?.call();
      },
      child: Form(
        key: Screen3Goals.formKey,
        onChanged: () {
          final form = Screen3Goals.formKey.currentState;
          if (form != null) {
            Screen3Goals.isFormValid = form.validate();
            widget.onFormChanged?.call();
          }
          // Save to provider on every form change
          _saveToProvider();
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),
              Text(
                'Your Goals',
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
                'Where do you want to go? This shapes your entire strategy.',
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: AppTheme.textSecondary,
                ),
              ).animate().fadeIn(delay: 100.ms).slideX(begin: -0.2),
              const SizedBox(height: 28),
              // Target Major
              _ValidatedDropdownField(
                label: 'Intended Major',
                value: _selectedMajor,
                items: [
                  'Computer Science', 'Data Science', 'AI/ML', 'Electrical Engineering',
                  'Mechanical Engineering', 'Physics', 'Mathematics', 'Biology',
                  'Economics', 'Business', 'Psychology', 'Political Science',
                  'English Literature', 'History', 'Philosophy', 'Fine Arts',
                  'International Relations', 'Environmental Science', 'Architecture',
                  'Journalism', 'Communications', 'Law', 'Nursing',
                ],
                delay: 200,
                onChanged: (val) {
                  setState(() => _selectedMajor = val);
                  _saveToProvider();
                  // Re-validate form on change
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    final form = Screen3Goals.formKey.currentState;
                    if (form != null) {
                      Screen3Goals.isFormValid = form.validate();
                    }
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty || value == 'Select your major') {
                    return 'Please select your intended major';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              // Target Countries
              Text(
                'Target Countries',
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textPrimary,
                ),
              ).animate().fadeIn(delay: 300.ms),
              const SizedBox(height: 4),
              Text(
                'Select at least one country',
                style: GoogleFonts.inter(
                  fontSize: 12,
                  color: AppTheme.textMuted,
                ),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _CountryChip(label: '🇺🇸 US', delay: 350, selected: _selectedCountries.contains('US'), onTap: () => _toggleCountry('US')),
                  _CountryChip(label: '🇬🇧 UK', delay: 380, selected: _selectedCountries.contains('UK'), onTap: () => _toggleCountry('UK')),
                  _CountryChip(label: '🇨🇦 Canada', delay: 410, selected: _selectedCountries.contains('Canada'), onTap: () => _toggleCountry('Canada')),
                  _CountryChip(label: '🇦🇺 Australia', delay: 440, selected: _selectedCountries.contains('Australia'), onTap: () => _toggleCountry('Australia')),
                  _CountryChip(label: '🇪🇺 Europe', delay: 470, selected: _selectedCountries.contains('Europe'), onTap: () => _toggleCountry('Europe')),
                  _CountryChip(label: '🇸🇬 Singapore', delay: 500, selected: _selectedCountries.contains('Singapore'), onTap: () => _toggleCountry('Singapore')),
                  _CountryChip(label: '🇭🇰 Hong Kong', delay: 530, selected: _selectedCountries.contains('Hong Kong'), onTap: () => _toggleCountry('Hong Kong')),
                ],
              ),
              // Hidden validator for country selection — participates in Form validation
              FormField<String>(
                validator: (_) {
                  if (_selectedCountries.isEmpty) {
                    return 'Please select at least one country';
                  }
                  return null;
                },
                builder: (field) => field.hasError
                    ? Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text(
                          field.errorText!,
                          style: GoogleFonts.inter(fontSize: 12, color: AppTheme.errorRed),
                        ),
                      )
                    : const SizedBox.shrink(),
              ),
              const SizedBox(height: 28),
              // Target Universities
              Text(
                'Pick 3 Target Universities',
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textPrimary,
                ),
              ).animate().fadeIn(delay: 550.ms),
              const SizedBox(height: 8),
              Text(
                'One from each tier — we\'ll calculate admission probability',
                style: GoogleFonts.inter(
                  fontSize: 13,
                  color: AppTheme.textMuted,
                ),
              ).animate().fadeIn(delay: 570.ms),
              const SizedBox(height: 16),
              _UniversityTierSection(
                title: '🎯 Reach (Dream)',
                subtitle: '10-20% baseline — aim high',
                color: const Color(0xFF8B5CF6),
                universities: reachUnis,
                delay: 600,
              ),
              const SizedBox(height: 16),
              _UniversityTierSection(
                title: '🎯 Match (Realistic)',
                subtitle: '40-60% baseline — your sweet spot',
                color: const Color(0xFF3B82F6),
                universities: matchUnis,
                delay: 700,
              ),
              const SizedBox(height: 16),
              _UniversityTierSection(
                title: '🛡️ Safety (Guaranteed)',
                subtitle: '70%+ baseline — solid options',
                color: const Color(0xFF10B981),
                universities: safetyUnis,
                delay: 800,
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
                    Icon(Icons.lightbulb_rounded, color: AppTheme.accentGold, size: 18),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'We\'ll run 10,000 simulations per university. Probability updates weekly as you complete missions.',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: AppTheme.textPrimary,
                        ),
                      ),
                    ),
                  ],
                ),
              ).animate().fadeIn(delay: 900.ms),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  void _toggleCountry(String country) {
    setState(() {
      if (_selectedCountries.contains(country)) {
        _selectedCountries.remove(country);
      } else {
        _selectedCountries.add(country);
      }
    });
    _saveToProvider();
    // Re-validate entire form (including country FormField) on change
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final form = Screen3Goals.formKey.currentState;
      if (form != null) {
        Screen3Goals.isFormValid = form.validate();
        widget.onFormChanged?.call();
      }
    });
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
    // Validate form on init (after first frame) to check if restored data makes it valid.
    // This ensures Continue button works when navigating back.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final form = widget.formKey.currentState;
      if (form != null && mounted) {
        final isValid = form.validate();
        if (isValid != Screen3Goals.isFormValid) {
          Screen3Goals.isFormValid = isValid;
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

class _CountryChip extends StatelessWidget {
  final String label;
  final int delay;
  final bool selected;
  final VoidCallback onTap;

  const _CountryChip({
    required this.label,
    required this.delay,
    this.selected = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: selected
              ? AppTheme.primaryBlue.withValues(alpha: 0.2)
              : AppTheme.primaryBlue.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: selected
                ? AppTheme.primaryBlue
                : AppTheme.primaryBlue.withValues(alpha: 0.3),
            width: selected ? 2 : 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (selected) ...[
              Icon(Icons.check_circle, size: 14, color: AppTheme.primaryBlue),
              const SizedBox(width: 4),
            ],
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: selected ? AppTheme.primaryBlue : AppTheme.primaryBlue,
              ),
            ),
          ],
        ),
      ),
    ).animate().fadeIn(delay: Duration(milliseconds: delay)).scale(begin: const Offset(0.8, 0.8));
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
              decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            ),
            const SizedBox(width: 8),
            Text(
              title,
              style: GoogleFonts.inter(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: AppTheme.textPrimary,
              ),
            ),
          ],
        ).animate().fadeIn(delay: Duration(milliseconds: delay)).slideX(begin: -0.1),
        Text(
          subtitle,
          style: GoogleFonts.inter(fontSize: 12, color: AppTheme.textMuted),
        ).animate().fadeIn(delay: Duration(milliseconds: delay + 50)),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: universities.asMap().entries.map((entry) {
            final uni = entry.value;
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: color.withValues(alpha: 0.3)),
              ),
              child: Text(
                uni,
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: color,
                ),
              ),
            ).animate().fadeIn(delay: Duration(milliseconds: delay + 100 + entry.key * 40));
          }).toList(),
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
