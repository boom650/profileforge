import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:profileforge/core/theme/app_theme.dart';
import 'package:profileforge/core/ai/psychological_profile.dart';

/// ────────────────────────────────────────────────────────────────────────────
/// Psychology Onboarding — 5-step personality assessment.
///
/// Based on research:
/// - 03-student-psychology-behavioral-design.md (Big Five traits)
/// - 03aa-nudge-theory-choice-architecture.md (Nudge theory)
/// - 03bc-growth-mindset-power-of-yet-deep.md (Growth mindset)
/// - 01-student-motivation-drivers.md (SDT motivation)
///
/// Design principles:
/// - Game-like feel, not a test
/// - Each question reveals personality traits
/// - Animated character reacts to choices
/// - Smooth transitions between steps
/// - Premium Lusion-inspired dark theme
/// ────────────────────────────────────────────────────────────────────────────
class PsychologyOnboardingScreen extends StatefulWidget {
  const PsychologyOnboardingScreen({super.key, this.onComplete});

  final Function(PsychologicalProfile)? onComplete;

  @override
  State<PsychologyOnboardingScreen> createState() =>
      _PsychologyOnboardingScreenState();
}

class _PsychologyOnboardingScreenState extends State<PsychologyOnboardingScreen>
    with TickerProviderStateMixin {
  int _currentStep = 0;
  final int _totalSteps = 5;
  late PageController _pageController;
  late AnimationController _mascotController;
  late Animation<double> _mascotAnimation;

  // Personality responses (raw values for Big Five + SDT)
  double _openness = 0.5;
  double _conscientiousness = 0.5;
  double _extraversion = 0.5;
  double _agreeableness = 0.5;
  double _neuroticism = 0.5;
  double _autonomy = 0.5;
  double _competence = 0.5;
  double _relatedness = 0.5;
  double _growthMindset = 0.5;
  double _selfEfficacy = 0.5;

  // Selections
  String _workStyle = '';
  String _stressResponse = '';
  String _learningStyle = '';
  String _motivation = '';
  String _growthAnswer = '';

  // Mascot mood
  _MascotMood _mascotMood = _MascotMood.neutral;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _mascotController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _mascotAnimation = CurvedAnimation(
      parent: _mascotController,
      curve: Curves.elasticOut,
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    _mascotController.dispose();
    super.dispose();
  }

  void _updateMascot(_MascotMood mood) {
    setState(() => _mascotMood = mood);
    _mascotController.forward(from: 0);
  }

  void _next() {
    HapticFeedback.lightImpact();
    if (_currentStep < _totalSteps - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOutCubic,
      );
    } else {
      _finish();
    }
  }

  void _previous() {
    HapticFeedback.lightImpact();
    if (_currentStep > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOutCubic,
      );
    }
  }

  void _finish() {
    final profile = PsychologicalProfile(
      openness: _openness,
      conscientiousness: _conscientiousness,
      extraversion: _extraversion,
      agreeableness: _agreeableness,
      neuroticism: _neuroticism,
      autonomy: _autonomy,
      competence: _competence,
      relatedness: _relatedness,
      growthMindset: _growthMindset,
      selfEfficacy: _selfEfficacy,
      communicationStyle: _inferCommunicationStyle(),
    );

    HapticFeedback.mediumImpact();
    widget.onComplete?.call(profile);
  }

  CommunicationStyle _inferCommunicationStyle() {
    if (_extraversion > 0.6 && _agreeableness > 0.6) {
      return CommunicationStyle.enthusiastic;
    } else if (_conscientiousness > 0.7) {
      return CommunicationStyle.analytical;
    } else if (_neuroticism > 0.6) {
      return CommunicationStyle.gentle;
    } else if (_openness > 0.7) {
      return CommunicationStyle.direct;
    } else {
      return CommunicationStyle.balanced;
    }
  }

  bool _canProceed() {
    switch (_currentStep) {
      case 0:
        return _workStyle.isNotEmpty;
      case 1:
        return _stressResponse.isNotEmpty;
      case 2:
        return _learningStyle.isNotEmpty;
      case 3:
        return _motivation.isNotEmpty;
      case 4:
        return _growthAnswer.isNotEmpty;
      default:
        return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final dark = isDark(context);

    return Scaffold(
      backgroundColor: dark ? Palette.black : const Color(0xFFF8FAFC),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: dark
                ? [
                    const Color(0xFF0B1120),
                    Palette.surface0,
                    Palette.black,
                  ]
                : [
                    const Color(0xFFEEF2FF),
                    const Color(0xFFF8FAFC),
                    Colors.white,
                  ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // ── Header: Progress + Back ──
              _buildHeader(dark),

              // ── Mascot ──
              _buildMascot(dark),

              // ── Page Content ──
              Expanded(
                child: PageView(
                  controller: _pageController,
                  onPageChanged: (i) => setState(() => _currentStep = i),
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    _buildWorkStyleStep(dark),
                    _buildStressStep(dark),
                    _buildLearningStep(dark),
                    _buildMotivationStep(dark),
                    _buildGrowthStep(dark),
                  ],
                ),
              ),

              // ── Bottom Navigation ──
              _buildNavigation(dark),
            ],
          ),
        ),
      ),
    );
  }

  /// ── Header with progress dots ────────────────────────────────────────────
  Widget _buildHeader(bool dark) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        children: [
          // Back button
          if (_currentStep > 0)
            GestureDetector(
              onTap: _previous,
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: dark
                      ? Palette.surface2.withValues(alpha: 0.7)
                      : Colors.white.withValues(alpha: 0.8),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: dark
                        ? Palette.border.withValues(alpha: 0.5)
                        : const Color(0xFFE2E8F0),
                  ),
                ),
                child: Icon(
                  Icons.arrow_back_ios_new,
                  size: 16,
                  color: dark ? Palette.textPrimary : Palette.textInverse,
                ),
              ),
            )
          else
            const SizedBox(width: 40),

          const Spacer(),

          // Progress dots
          ...List.generate(_totalSteps, (i) {
            final isActive = i == _currentStep;
            final isDone = i < _currentStep;
            return AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.symmetric(horizontal: 4),
              width: isActive ? 32 : 10,
              height: 10,
              decoration: BoxDecoration(
                color: isDone
                    ? Palette.primary
                    : isActive
                        ? Palette.primary
                        : dark
                            ? Palette.surface3
                            : const Color(0xFFCBD5E1),
                borderRadius: BorderRadius.circular(5),
                boxShadow: isActive
                    ? [
                        BoxShadow(
                          color: Palette.primary.withValues(alpha: 0.4),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ]
                    : null,
              ),
            );
          }),

          const Spacer(),

          // Step counter
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: dark
                  ? Palette.surface2.withValues(alpha: 0.7)
                  : Colors.white.withValues(alpha: 0.8),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              '${_currentStep + 1}/$_totalSteps',
              style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Palette.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// ── Mascot with animated mood ────────────────────────────────────────────
  Widget _buildMascot(bool dark) {
    return AnimatedBuilder(
      animation: _mascotAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: 0.9 + (_mascotAnimation.value * 0.1),
          child: Container(
            width: 80,
            height: 80,
            margin: const EdgeInsets.only(bottom: 8),
            decoration: BoxDecoration(
              gradient: _getMascotGradient(),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: _getMascotColor().withValues(alpha: 0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Center(
              child: Text(
                _getMascotEmoji(),
                style: const TextStyle(fontSize: 36),
              ),
            ),
          ),
        );
      },
    );
  }

  String _getMascotEmoji() {
    switch (_mascotMood) {
      case _MascotMood.neutral:
        return '🦉';
      case _MascotMood.happy:
        return '😊';
      case _MascotMood.thinking:
        return '🤔';
      case _MascotMood.excited:
        return '🤩';
      case _MascotMood.calm:
        return '😌';
    }
  }

  Color _getMascotColor() {
    switch (_mascotMood) {
      case _MascotMood.neutral:
        return Palette.primary;
      case _MascotMood.happy:
        return Palette.success;
      case _MascotMood.thinking:
        return Palette.info;
      case _MascotMood.excited:
        return Palette.warning;
      case _MascotMood.calm:
        return const Color(0xFF06B6D4);
    }
  }

  Gradient _getMascotGradient() {
    return LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        _getMascotColor(),
        _getMascotColor().withValues(alpha: 0.7),
      ],
    );
  }

  /// ── Step 1: Work Style ───────────────────────────────────────────────────
  Widget _buildWorkStyleStep(bool dark) {
    final options = [
      _OptionData(
        icon: '🧑‍💻',
        title: 'Solo Focus',
        subtitle: 'I do my best work alone, in my zone',
        value: 'solo',
        mascotMood: _MascotMood.thinking,
        traitUpdates: {'conscientiousness': 0.7, 'extraversion': 0.3},
      ),
      _OptionData(
        icon: '🤝',
        title: 'Team Player',
        subtitle: 'I thrive with others, bouncing ideas',
        value: 'team',
        mascotMood: _MascotMood.happy,
        traitUpdates: {'extraversion': 0.7, 'agreeableness': 0.7},
      ),
      _OptionData(
        icon: '👑',
        title: 'Leader',
        subtitle: 'I like to organize and drive outcomes',
        value: 'leader',
        mascotMood: _MascotMood.excited,
        traitUpdates: {'conscientiousness': 0.8, 'extraversion': 0.6},
      ),
      _OptionData(
        icon: '🔄',
        title: 'Flexible',
        subtitle: 'Depends on the task and the people',
        value: 'flexible',
        mascotMood: _MascotMood.calm,
        traitUpdates: {'openness': 0.7, 'agreeableness': 0.6},
      ),
    ];

    return _buildOptionStep(
      dark: dark,
      title: 'How do you work best?',
      subtitle: 'This shapes how we structure your tasks',
      options: options,
      selected: _workStyle,
      onSelect: (value, updates) {
        setState(() {
          _workStyle = value;
          _applyTraitUpdates(updates);
        });
      },
    );
  }

  /// ── Step 2: Stress Response ──────────────────────────────────────────────
  Widget _buildStressStep(bool dark) {
    final options = [
      _OptionData(
        icon: '🧘',
        title: 'Stay Calm',
        subtitle: 'I breathe and think through it',
        value: 'calm',
        mascotMood: _MascotMood.calm,
        traitUpdates: {'neuroticism': 0.2, 'conscientiousness': 0.6},
      ),
      _OptionData(
        icon: '💪',
        title: 'Push Through',
        subtitle: 'I power through the pressure',
        value: 'push',
        mascotMood: _MascotMood.excited,
        traitUpdates: {'conscientiousness': 0.8, 'selfEfficacy': 0.7},
      ),
      _OptionData(
        icon: '📋',
        title: 'Make a Plan',
        subtitle: 'I break it down into pieces',
        value: 'plan',
        mascotMood: _MascotMood.thinking,
        traitUpdates: {'conscientiousness': 0.9, 'openness': 0.5},
      ),
      _OptionData(
        icon: '🏃',
        title: 'Take a Break',
        subtitle: 'I step away and come back fresh',
        value: 'break',
        mascotMood: _MascotMood.neutral,
        traitUpdates: {'neuroticism': 0.4, 'openness': 0.6},
      ),
    ];

    return _buildOptionStep(
      dark: dark,
      title: 'When stress hits, you...',
      subtitle: 'No wrong answer — this helps us support you',
      options: options,
      selected: _stressResponse,
      onSelect: (value, updates) {
        setState(() {
          _stressResponse = value;
          _applyTraitUpdates(updates);
        });
      },
    );
  }

  /// ── Step 3: Learning Style ───────────────────────────────────────────────
  Widget _buildLearningStep(bool dark) {
    final options = [
      _OptionData(
        icon: '👁️',
        title: 'Visual',
        subtitle: 'Charts, diagrams, videos — I see to understand',
        value: 'visual',
        mascotMood: _MascotMood.happy,
        traitUpdates: {'openness': 0.7, 'competence': 0.6},
      ),
      _OptionData(
        icon: '📖',
        title: 'Reading',
        subtitle: 'Give me articles, books, written guides',
        value: 'reading',
        mascotMood: _MascotMood.thinking,
        traitUpdates: {'conscientiousness': 0.7, 'openness': 0.6},
      ),
      _OptionData(
        icon: '🛠️',
        title: 'Hands-on',
        subtitle: 'I learn by doing, building, experimenting',
        value: 'hands_on',
        mascotMood: _MascotMood.excited,
        traitUpdates: {'openness': 0.8, 'competence': 0.7},
      ),
      _OptionData(
        icon: '💬',
        title: 'Discussion',
        subtitle: 'I learn through conversation and debate',
        value: 'discussion',
        mascotMood: _MascotMood.happy,
        traitUpdates: {'extraversion': 0.7, 'agreeableness': 0.6},
      ),
    ];

    return _buildOptionStep(
      dark: dark,
      title: 'How do you learn best?',
      subtitle: 'We\'ll adapt content to your style',
      options: options,
      selected: _learningStyle,
      onSelect: (value, updates) {
        setState(() {
          _learningStyle = value;
          _applyTraitUpdates(updates);
        });
      },
    );
  }

  /// ── Step 4: Motivation ───────────────────────────────────────────────────
  Widget _buildMotivationStep(bool dark) {
    final options = [
      _OptionData(
        icon: '🏆',
        title: 'Top University',
        subtitle: 'Aiming for the best, no matter what',
        value: 'achievement',
        mascotMood: _MascotMood.excited,
        traitUpdates: {'conscientiousness': 0.8, 'selfEfficacy': 0.7},
      ),
      _OptionData(
        icon: '🎯',
        title: 'Best Fit',
        subtitle: 'Finding the right match for me',
        value: 'fit',
        mascotMood: _MascotMood.thinking,
        traitUpdates: {'openness': 0.7, 'autonomy': 0.8},
      ),
      _OptionData(
        icon: '🌍',
        title: 'Global Impact',
        subtitle: 'Want to change the world someday',
        value: 'impact',
        mascotMood: _MascotMood.happy,
        traitUpdates: {'agreeableness': 0.8, 'relatedness': 0.7},
      ),
      _OptionData(
        icon: '📈',
        title: 'Personal Growth',
        subtitle: 'Becoming the best version of myself',
        value: 'growth',
        mascotMood: _MascotMood.calm,
        traitUpdates: {'growthMindset': 0.8, 'openness': 0.7},
      ),
    ];

    return _buildOptionStep(
      dark: dark,
      title: 'What drives you?',
      subtitle: 'This shapes your entire journey',
      options: options,
      selected: _motivation,
      onSelect: (value, updates) {
        setState(() {
          _motivation = value;
          _applyTraitUpdates(updates);
        });
      },
    );
  }

  /// ── Step 5: Growth Mindset ───────────────────────────────────────────────
  Widget _buildGrowthStep(bool dark) {
    final options = [
      _OptionData(
        icon: '🔥',
        title: 'Embrace Challenges',
        subtitle: 'Difficult = opportunity to grow',
        value: 'embrace',
        mascotMood: _MascotMood.excited,
        traitUpdates: {'growthMindset': 0.9, 'selfEfficacy': 0.8},
      ),
      _OptionData(
        icon: ' grit',
        title: 'Grit & Persistence',
        subtitle: 'I don\'t quit, even when it\'s hard',
        value: 'grit',
        mascotMood: _MascotMood.happy,
        traitUpdates: {'conscientiousness': 0.9, 'selfEfficacy': 0.7},
      ),
      _OptionData(
        icon: '🔄',
        title: 'Learn from Failure',
        subtitle: 'Every setback is a setup for a comeback',
        value: 'failure',
        mascotMood: _MascotMood.thinking,
        traitUpdates: {'growthMindset': 0.8, 'neuroticism': 0.3},
      ),
      _OptionData(
        icon: '📝',
        title: 'Feedback is Gold',
        subtitle: 'I actively seek and apply feedback',
        value: 'feedback',
        mascotMood: _MascotMood.calm,
        traitUpdates: {'growthMindset': 0.8, 'agreeableness': 0.7},
      ),
    ];

    return _buildOptionStep(
      dark: dark,
      title: 'Your mindset about challenges?',
      subtitle: 'This is the #1 predictor of success',
      options: options,
      selected: _growthAnswer,
      onSelect: (value, updates) {
        setState(() {
          _growthAnswer = value;
          _applyTraitUpdates(updates);
        });
      },
    );
  }

  /// ── Generic Option Step ──────────────────────────────────────────────────
  Widget _buildOptionStep({
    required bool dark,
    required String title,
    required String subtitle,
    required List<_OptionData> options,
    required String selected,
    required Function(String, Map<String, double>) onSelect,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          Text(
            title,
            style: GoogleFonts.inter(
              fontSize: 28,
              fontWeight: FontWeight.w800,
              color: dark ? Palette.textPrimary : Palette.textInverse,
              height: 1.2,
            ),
          ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.1),

          const SizedBox(height: 8),

          // Subtitle
          Text(
            subtitle,
            style: GoogleFonts.inter(
              fontSize: 15,
              color: Palette.textSecondary,
              height: 1.4,
            ),
          ).animate().fadeIn(delay: 100.ms, duration: 400.ms),

          const SizedBox(height: 28),

          // Options
          Expanded(
            child: ListView.builder(
              itemCount: options.length,
              itemBuilder: (context, index) {
                final option = options[index];
                final isSelected = selected == option.value;

                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: GestureDetector(
                    onTap: () {
                      HapticFeedback.selectionClick();
                      _updateMascot(option.mascotMood);
                      onSelect(option.value, option.traitUpdates);
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      curve: Curves.easeOutCubic,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? Palette.primary.withValues(alpha: 0.12)
                            : dark
                                ? Palette.surface1.withValues(alpha: 0.6)
                                : Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: isSelected
                              ? Palette.primary
                              : dark
                                  ? Palette.border.withValues(alpha: 0.4)
                                  : const Color(0xFFE2E8F0),
                          width: isSelected ? 2 : 1,
                        ),
                        boxShadow: isSelected
                            ? [
                                BoxShadow(
                                  color: Palette.primary.withValues(alpha: 0.2),
                                  blurRadius: 12,
                                  offset: const Offset(0, 4),
                                ),
                              ]
                            : [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.05),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                      ),
                      child: Row(
                        children: [
                          // Icon
                          Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? Palette.primary.withValues(alpha: 0.15)
                                  : dark
                                      ? Palette.surface2
                                      : const Color(0xFFF1F5F9),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Center(
                              child: Text(
                                option.icon,
                                style: const TextStyle(fontSize: 22),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),

                          // Text
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  option.title,
                                  style: GoogleFonts.inter(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: isSelected
                                        ? Palette.primary
                                        : dark
                                            ? Palette.textPrimary
                                            : Palette.textInverse,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  option.subtitle,
                                  style: GoogleFonts.inter(
                                    fontSize: 13,
                                    color: Palette.textTertiary,
                                    height: 1.3,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Check indicator
                          AnimatedOpacity(
                            duration: const Duration(milliseconds: 200),
                            opacity: isSelected ? 1 : 0,
                            child: Container(
                              width: 24,
                              height: 24,
                              decoration: BoxDecoration(
                                color: Palette.primary,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.check,
                                size: 14,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                      .animate()
                      .fadeIn(
                        delay: Duration(milliseconds: 200 + index * 80),
                        duration: 400.ms,
                      )
                      .slideX(begin: 0.05),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  /// ── Bottom Navigation ────────────────────────────────────────────────────
  Widget _buildNavigation(bool dark) {
    final canProceed = _canProceed();

    return Container(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
      decoration: BoxDecoration(
        color: dark
            ? Palette.surface0.withValues(alpha: 0.8)
            : Colors.white.withValues(alpha: 0.9),
        border: Border(
          top: BorderSide(
            color: dark
                ? Palette.border.withValues(alpha: 0.3)
                : const Color(0xFFE2E8F0),
          ),
        ),
      ),
      child: Row(
        children: [
          // Back button
          if (_currentStep > 0)
            GestureDetector(
              onTap: _previous,
              child: Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: dark ? Palette.surface2 : const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: dark ? Palette.border : const Color(0xFFE2E8F0),
                  ),
                ),
                child: Icon(
                  Icons.arrow_back_ios_new,
                  size: 18,
                  color: dark ? Palette.textPrimary : Palette.textInverse,
                ),
              ),
            )
          else
            const SizedBox(width: 48),

          const SizedBox(width: 16),

          // Continue button
          Expanded(
            child: GestureDetector(
              onTap: canProceed ? _next : null,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                height: 52,
                decoration: BoxDecoration(
                  gradient: canProceed ? Palette.gradientPrimary : null,
                  color: canProceed
                      ? null
                      : dark
                          ? Palette.surface2
                          : const Color(0xFFE2E8F0),
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: canProceed
                      ? [
                          BoxShadow(
                            color: Palette.primary.withValues(alpha: 0.3),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ]
                      : null,
                ),
                child: Center(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        _currentStep == _totalSteps - 1
                            ? 'Complete'
                            : 'Continue',
                        style: GoogleFonts.inter(
                          color: canProceed
                              ? Colors.white
                              : Palette.textTertiary,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Icon(
                        _currentStep == _totalSteps - 1
                            ? Icons.check_circle
                            : Icons.arrow_forward,
                        color: canProceed ? Colors.white : Palette.textTertiary,
                        size: 20,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// ── Apply trait updates from option selection ────────────────────────────
  void _applyTraitUpdates(Map<String, double> updates) {
    for (final entry in updates.entries) {
      switch (entry.key) {
        case 'openness':
          _openness = entry.value;
          break;
        case 'conscientiousness':
          _conscientiousness = entry.value;
          break;
        case 'extraversion':
          _extraversion = entry.value;
          break;
        case 'agreeableness':
          _agreeableness = entry.value;
          break;
        case 'neuroticism':
          _neuroticism = entry.value;
          break;
        case 'autonomy':
          _autonomy = entry.value;
          break;
        case 'competence':
          _competence = entry.value;
          break;
        case 'relatedness':
          _relatedness = entry.value;
          break;
        case 'growthMindset':
          _growthMindset = entry.value;
          break;
        case 'selfEfficacy':
          _selfEfficacy = entry.value;
          break;
      }
    }
  }
}

/// ── Option Data Model ──────────────────────────────────────────────────────
class _OptionData {
  const _OptionData({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.mascotMood,
    required this.traitUpdates,
  });

  final String icon;
  final String title;
  final String subtitle;
  final String value;
  final _MascotMood mascotMood;
  final Map<String, double> traitUpdates;
}

/// ── Mascot Mood ────────────────────────────────────────────────────────────
enum _MascotMood {
  neutral,
  happy,
  thinking,
  excited,
  calm,
}
