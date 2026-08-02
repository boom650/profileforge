import 'package:flutter/material.dart';
import 'package:profileforge/core/theme/app_theme.dart';
import 'package:profileforge/features/onboarding/domain/user_preferences.dart';

/// Detailed onboarding — captures what the user LIKES, their SKILLS, VALUES, etc.
/// This data powers the AI recommendation engine.
class DeepOnboardingScreen extends StatefulWidget {
  const DeepOnboardingScreen({super.key, required this.onComplete});
  final void Function(UserPreferences) onComplete;

  @override
  State<DeepOnboardingScreen> createState() => _DeepOnboardingScreenState();
}

class _DeepOnboardingScreenState extends State<DeepOnboardingScreen> {
  int _step = 0;
  final _prefs = const UserPreferences();
  final _liked = <String>{};
  final _disliked = <String>{};
  final _skills = <String>{};
  final _wantToLearn = <String>{};
  final _values = <String>{};
  final _personality = <String>{};
  String _timeOfDay = '';
  final _availableDays = <String>{};
  final _proudestController = TextEditingController();
  final _rememberedController = TextEditingController();

  @override
  void dispose() {
    _proudestController.dispose();
    _rememberedController.dispose();
    super.dispose();
  }

  void _next() {
    if (_step < 8) {
      setState(() => _step++);
    } else {
      widget.onComplete(UserPreferences(
        likedActivities: _liked.toList(),
        dislikedActivities: _disliked.toList(),
        skills: _skills.toList(),
        wantToLearn: _wantToLearn.toList(),
        preferredTimeOfDay: _timeOfDay,
        availableDays: _availableDays.toList(),
        values: _values.toList(),
        personalityTraits: _personality.toList(),
        proudestAchievement: _proudestController.text.trim(),
        wantToBeRememberedAs: _rememberedController.text.trim(),
      ));
    }
  }

  void _back() {
    if (_step > 0) setState(() => _step--);
  }

  @override
  Widget build(BuildContext context) {
    final dark = isDark(context);

    return Scaffold(
      backgroundColor: dark ? Palette.black : Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Progress bar.
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
              child: Row(
                children: [
                  if (_step > 0)
                    GestureDetector(
                      onTap: _back,
                      child: Icon(Icons.arrow_back_ios, size: 20, color: Palette.textSecondary),
                    )
                  else
                    const SizedBox(width: 20),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: (_step + 1) / 9,
                        backgroundColor: dark ? Palette.surface2 : const Color(0xFFE2E8F0),
                        valueColor: AlwaysStoppedAnimation(Palette.primary),
                        minHeight: 6,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    '${_step + 1}/9',
                    style: TextStyle(
                      color: Palette.textSecondary,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),

            // Content.
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: _buildStep(dark),
              ),
            ),

            // Next button.
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
              child: GestureDetector(
                onTap: _canProceed() ? _next : null,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(
                    gradient: _canProceed() ? Palette.gradientPrimary : null,
                    color: _canProceed() ? null : (dark ? Palette.surface2 : const Color(0xFFE2E8F0)),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Center(
                    child: Text(
                      _step == 8 ? 'Complete Setup' : 'Continue',
                      style: TextStyle(
                        color: _canProceed() ? Colors.white : Palette.textTertiary,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool _canProceed() {
    switch (_step) {
      case 0: return _liked.isNotEmpty;
      case 1: return _disliked.isNotEmpty;
      case 2: return _skills.isNotEmpty;
      case 3: return _wantToLearn.isNotEmpty;
      case 4: return _timeOfDay.isNotEmpty;
      case 5: return _availableDays.isNotEmpty;
      case 6: return _values.isNotEmpty;
      case 7: return _personality.isNotEmpty;
      case 8: return true;
      default: return true;
    }
  }

  Widget _buildStep(bool dark) {
    switch (_step) {
      case 0: return _ChipStep(
        title: 'What do you enjoy doing?',
        subtitle: 'Pick at least 3 things that genuinely excite you.',
        options: likedActivityOptions,
        selected: _liked,
        dark: dark,
        multi: true,
      );
      case 1: return _ChipStep(
        title: 'What do you NOT enjoy?',
        subtitle: 'So we never recommend these. Be honest.',
        options: likedActivityOptions,
        selected: _disliked,
        dark: dark,
        multi: true,
      );
      case 2: return _ChipStep(
        title: 'What can you already do?',
        subtitle: 'Your current skills — even if you\'re not an expert.',
        options: skillOptions,
        selected: _skills,
        dark: dark,
        multi: true,
      );
      case 3: return _ChipStep(
        title: 'What do you want to learn?',
        subtitle: 'Skills you\'re curious about or want to develop.',
        options: wantToLearnOptions,
        selected: _wantToLearn,
        dark: dark,
        multi: true,
      );
      case 4: return _SingleChipStep(
        title: 'When do you do your best work?',
        subtitle: 'We\'ll schedule tasks during your peak hours.',
        options: timeOfDayOptions,
        selected: _timeOfDay,
        dark: dark,
        onSelected: (v) => setState(() => _timeOfDay = v),
      );
      case 5: return _ChipStep(
        title: 'Which days are you most available?',
        subtitle: 'We\'ll plan bigger tasks for your free days.',
        options: dayOptions,
        selected: _availableDays,
        dark: dark,
        multi: true,
      );
      case 6: return _ChipStep(
        title: 'What matters most to you?',
        subtitle: 'Pick your top 3 values.',
        options: valueOptions,
        selected: _values,
        dark: dark,
        multi: true,
        maxSelect: 3,
      );
      case 7: return _ChipStep(
        title: 'How would you describe yourself?',
        subtitle: 'Pick 2-3 traits that fit you best.',
        options: personalityOptions,
        selected: _personality,
        dark: dark,
        multi: true,
        maxSelect: 3,
      );
      case 8: return _FreeTextStep(
        proudestController: _proudestController,
        rememberedController: _rememberedController,
        dark: dark,
      );
      default: return const SizedBox();
    }
  }
}

/// Multi-select chip step.
class _ChipStep extends StatelessWidget {
  const _ChipStep({
    required this.title,
    required this.subtitle,
    required this.options,
    required this.selected,
    required this.dark,
    this.multi = false,
    this.maxSelect,
  });

  final String title;
  final String subtitle;
  final List<String> options;
  final Set<String> selected;
  final bool dark;
  final bool multi;
  final int? maxSelect;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w800,
            color: dark ? Palette.textPrimary : Palette.textInverse,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          subtitle,
          style: TextStyle(
            fontSize: 14,
            color: Palette.textSecondary,
          ),
        ),
        if (maxSelect != null) ...[
          const SizedBox(height: 8),
          Text(
            'Selected: ${selected.length}/$maxSelect',
            style: TextStyle(
              fontSize: 12,
              color: selected.length >= (maxSelect!) ? Palette.success : Palette.textTertiary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
        const SizedBox(height: 20),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: options.map((option) {
            final isSelected = selected.contains(option);
            final isDisabled = maxSelect != null && selected.length >= maxSelect && !isSelected;

            return GestureDetector(
              onTap: isDisabled ? null : () {
                if (multi) {
                  if (isSelected) {
                    selected.remove(option);
                  } else {
                    selected.add(option);
                  }
                }
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: isSelected
                      ? Palette.primary.withValues(alpha: 0.15)
                      : (dark ? Palette.surface1 : const Color(0xFFF1F5F9)),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: isSelected
                        ? Palette.primary
                        : (dark ? Palette.border : const Color(0xFFE2E8F0)),
                    width: isSelected ? 2 : 1,
                  ),
                ),
                child: Text(
                  option,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                    color: isSelected
                        ? Palette.primary
                        : (dark ? Palette.textPrimary : Palette.textInverse),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

/// Single-select chip step.
class _SingleChipStep extends StatelessWidget {
  const _SingleChipStep({
    required this.title,
    required this.subtitle,
    required this.options,
    required this.selected,
    required this.dark,
    required this.onSelected,
  });

  final String title;
  final String subtitle;
  final List<String> options;
  final String selected;
  final bool dark;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w800,
            color: dark ? Palette.textPrimary : Palette.textInverse,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          subtitle,
          style: TextStyle(
            fontSize: 14,
            color: Palette.textSecondary,
          ),
        ),
        const SizedBox(height: 20),
        ...options.map((option) {
          final isSelected = selected == option;
          return GestureDetector(
            onTap: () => onSelected(option),
            child: Container(
              width: double.infinity,
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                color: isSelected
                    ? Palette.primary.withValues(alpha: 0.15)
                    : (dark ? Palette.surface1 : const Color(0xFFF1F5F9)),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isSelected
                      ? Palette.primary
                      : (dark ? Palette.border : const Color(0xFFE2E8F0)),
                  width: isSelected ? 2 : 1,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    isSelected ? Icons.radio_button_checked : Icons.radio_button_unchecked,
                    size: 20,
                    color: isSelected ? Palette.primary : Palette.textTertiary,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      option,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                        color: isSelected
                            ? Palette.primary
                            : (dark ? Palette.textPrimary : Palette.textInverse),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ],
    );
  }
}

/// Free text step — proudest achievement + how to be remembered.
class _FreeTextStep extends StatelessWidget {
  const _FreeTextStep({
    required this.proudestController,
    required this.rememberedController,
    required this.dark,
  });

  final TextEditingController proudestController;
  final TextEditingController rememberedController;
  final bool dark;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Tell us about yourself',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w800,
            color: dark ? Palette.textPrimary : Palette.textInverse,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'These help the AI understand your story.',
          style: TextStyle(
            fontSize: 14,
            color: Palette.textSecondary,
          ),
        ),
        const SizedBox(height: 24),
        Text(
          'What are you most proud of?',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: dark ? Palette.textPrimary : Palette.textInverse,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: proudestController,
          maxLines: 3,
          decoration: InputDecoration(
            hintText: 'e.g. "I built an app that helps my school manage events"',
            hintStyle: TextStyle(color: Palette.textTertiary),
            filled: true,
            fillColor: dark ? Palette.surface1 : const Color(0xFFF1F5F9),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: dark ? Palette.border : const Color(0xFFE2E8F0)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: dark ? Palette.border : const Color(0xFFE2E8F0)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Palette.primary, width: 2),
            ),
          ),
        ),
        const SizedBox(height: 24),
        Text(
          'How do you want admissions officers to remember you?',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: dark ? Palette.textPrimary : Palette.textInverse,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: rememberedController,
          maxLines: 3,
          decoration: InputDecoration(
            hintText: 'e.g. "The kid who built a water purification system for rural villages"',
            hintStyle: TextStyle(color: Palette.textTertiary),
            filled: true,
            fillColor: dark ? Palette.surface1 : const Color(0xFFF1F5F9),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: dark ? Palette.border : const Color(0xFFE2E8F0)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: dark ? Palette.border : const Color(0xFFE2E8F0)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Palette.primary, width: 2),
            ),
          ),
        ),
      ],
    );
  }
}
