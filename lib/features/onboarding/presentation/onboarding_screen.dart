import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:profileforge/core/audio/sound_service.dart';
import 'package:profileforge/core/celebration/celebrate.dart';
import 'package:profileforge/core/theme/app_theme.dart';
import 'package:profileforge/features/onboarding/application/onboarding_providers.dart';
import 'package:profileforge/features/onboarding/domain/onboarding_models.dart';

/// ────────────────────────────────────────────────────────────────────────────
/// Onboarding v6 — Premium 5-step illustrated wizard.
/// Haptic feedback, animated progress, staggered card reveals.
/// ────────────────────────────────────────────────────────────────────────────
class OnboardingScreen extends ConsumerStatefulWidget {
  final String profileId;
  const OnboardingScreen({super.key, required this.profileId});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen>
    with TickerProviderStateMixin {
  final _page = PageController();
  int _step = 0;
  static const int _total = 5;

  // Step 1: Goal.
  String _goal = 'both';

  // Step 2: Target schools.
  final Set<String> _targets = {};

  // Step 3: Quick profile.
  String _name = '';
  int _grade = 11;
  final Set<String> _interests = {};

  // Step 4: Schedule.
  int _availableHours = 15;
  String _peakTime = 'morning';

  // Completion state.
  bool _showCompletion = false;

  // Animated progress controller.
  late AnimationController _progressAnim;
  late Animation<double> _progressValue;

  // Data for suggestions.
  final _schools = [
    'MIT', 'Stanford', 'Harvard', 'Oxford', 'Cambridge',
    'Yale', 'Princeton', 'NUS', 'ETH Zürich', 'Imperial',
    'Columbia', 'UCLA', 'UC Berkeley', 'Caltech', 'LSE',
  ];

  final _interestItems = [
    'Math', 'Physics', 'CS', 'Chemistry', 'Biology',
    'Economics', 'Design', 'Writing', 'Music', 'Sports',
    'Debate', 'Robotics', 'Volunteering', 'Research', 'Art',
  ];

  final _stepLabels = ['Goal', 'Schools', 'Profile', 'Schedule', 'Launch'];

  @override
  void initState() {
    super.initState();
    _progressAnim = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _progressValue = Tween<double>(begin: 0, end: 1 / _total).animate(
      CurvedAnimation(parent: _progressAnim, curve: Curves.easeOutCubic),
    );
    _progressAnim.forward();
  }

  void _hapticLight() => HapticFeedback.lightImpact();
  void _hapticMedium() => HapticFeedback.mediumImpact();
  void _hapticHeavy() => HapticFeedback.heavyImpact();

  void _next() {
    _hapticMedium();
    SoundService.instance.tap();
    if (_step < _total - 1) {
      _page.nextPage(
          duration: 500.ms, curve: Curves.easeInOutCubic);
      _progressAnim.animateTo(
        (_step + 2) / _total,
        duration: 500.ms,
        curve: Curves.easeOutCubic,
      );
    } else {
      _finish();
    }
  }

  void _prev() {
    _hapticLight();
    if (_step > 0) {
      _page.previousPage(
          duration: 500.ms, curve: Curves.easeInOutCubic);
      _progressAnim.animateTo(
        (_step) / _total,
        duration: 500.ms,
        curve: Curves.easeOutCubic,
      );
    }
  }

  OnboardingProfile _buildProfile() => OnboardingProfile(
        profileId: widget.profileId,
        grades: {},
        activities: [],
        competitions: [],
        subjects: _interests.toList(),
        targetUniversities: _targets.toList(),
        careerInterests: [],
        budget: 0,
        travelRadiusKm: 10,
        availabilityHoursPerWeek: _availableHours,
        location: '',
      );

  ScheduleProfile _buildSchedule() => ScheduleProfile(
        schoolDays: [1, 2, 3, 4, 5],
        schoolStartHour: 8,
        schoolStartMinute: 0,
        schoolEndHour: 15,
        schoolEndMinute: 0,
        energyPeak: _peakTime,
        sleepStart: '22:00',
        sleepEnd: '07:00',
        timelineGoal: '1year',
        screenTimeHours: 3,
        studyEnvironment: 'mixed',
        socialMediaUsage: 'moderate',
      );

  Future<void> _finish() async {
    _hapticHeavy();
    final p = _buildProfile();
    final s = _buildSchedule();

    ref.read(saveOnboardingProvider(p));
    ref.read(onboardingRepositoryProvider).saveSchedule(s, widget.profileId);

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('pf_onboarded', true);
    await prefs.setString('pf_user_name', _name);

    SoundService.instance.success();
    setState(() => _showCompletion = true);

    Future.delayed(3000.ms, () {
      if (mounted) context.go('/auth-prompt');
    });
  }

  @override
  void dispose() {
    _progressAnim.dispose();
    _page.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dark = isDark(context);

    return Scaffold(
      body: Stack(
        children: [
          // ── Animated gradient background ──
          AnimatedContainer(
            duration: 800.ms,
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: dark
                    ? [
                        _step == 0
                            ? const Color(0xFF1a1040)
                            : _step == 1
                                ? const Color(0xFF0B1120)
                                : _step == 2
                                    ? const Color(0xFF0a1628)
                                    : _step == 3
                                        ? const Color(0xFF0d1520)
                                        : const Color(0xFF111827),
                        Palette.surface0,
                        Palette.black,
                      ]
                    : [
                        _step == 0
                            ? const Color(0xFFEEF2FF)
                            : _step == 1
                                ? const Color(0xFFF0F9FF)
                                : _step == 2
                                    ? const Color(0xFFF5F3FF)
                                    : const Color(0xFFECFDF5),
                        const Color(0xFFF8FAFC),
                        Colors.white,
                      ],
              ),
            ),
            child: SafeArea(
              child: Column(
                children: [
                  // ── Header: animated progress bar + back/skip ──
                  _buildHeader(dark),

                  // ── Page content ──
                  Expanded(
                    child: PageView(
                      controller: _page,
                      onPageChanged: (i) => setState(() => _step = i),
                      physics: const NeverScrollableScrollPhysics(),
                      children: [
                        _stepGoal(dark),
                        _stepSchools(dark),
                        _stepProfile(dark),
                        _stepSchedule(dark),
                        _stepLaunch(dark),
                      ],
                    ),
                  ),

                  // ── Bottom CTA with glow ──
                  _buildCTA(dark),
                ],
              ),
            ),
          ),
          // Confetti overlay on completion.
          if (_showCompletion)
            Positioned.fill(child: _OnboardingConfetti(dark: dark)),
        ],
      ),
    );
  }

  // ──────────────────────────────────────────────────────────────────────────
  // HEADER with animated progress bar + step labels
  // ──────────────────────────────────────────────────────────────────────────
  Widget _buildHeader(bool dark) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Column(
        children: [
          Row(
            children: [
              // Back button.
              if (_step > 0)
                GestureDetector(
                  onTap: _prev,
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: dark
                          ? Palette.surface2.withValues(alpha: 0.8)
                          : const Color(0xFFE2E8F0).withValues(alpha: 0.8),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: dark
                            ? Palette.border.withValues(alpha: 0.5)
                            : const Color(0xFFCBD5E1).withValues(alpha: 0.5),
                      ),
                    ),
                    child: const Icon(Icons.arrow_back_ios_new,
                        size: 16, color: Palette.textSecondary),
                  ),
                )
              else
                const SizedBox(width: 40),
              const Spacer(),
              // Step indicator text.
              AnimatedSwitcher(
                duration: 300.ms,
                child: Text(
                  '${_step + 1} of $_total',
                  key: ValueKey(_step),
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: dark ? Palette.textSecondary : Palette.textTertiary,
                  ),
                ),
              ),
              const Spacer(),
              // Skip button.
              TextButton(
                onPressed: () {
                  _hapticLight();
                  context.go('/home');
                },
                child: Text(
                  'Skip',
                  style: TextStyle(
                    color: dark ? Palette.textSecondary : Palette.textTertiary,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Animated progress bar.
          Row(
            children: [
              // Step labels + progress dots.
              ...List.generate(_total, (i) {
                final isActive = i == _step;
                final isDone = i < _step;
                return Expanded(
                  child: Column(
                    children: [
                      AnimatedContainer(
                        duration: 400.ms,
                        height: 4,
                        margin: EdgeInsets.only(right: i < _total - 1 ? 4 : 0),
                        decoration: BoxDecoration(
                          color: isDone || isActive
                              ? Palette.primary
                              : dark
                                  ? Palette.surface3
                                  : const Color(0xFFCBD5E1),
                          borderRadius: BorderRadius.circular(2),
                          boxShadow: isActive
                              ? [
                                  BoxShadow(
                                    color: Palette.primary.withValues(alpha: 0.4),
                                    blurRadius: 6,
                                    spreadRadius: 1,
                                  ),
                                ]
                              : null,
                        ),
                      ),
                      const SizedBox(height: 6),
                      AnimatedDefaultTextStyle(
                        duration: 300.ms,
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight:
                              isActive ? FontWeight.w700 : FontWeight.w500,
                          color: isDone || isActive
                              ? Palette.primary
                              : dark
                                  ? Palette.textTertiary
                                  : const Color(0xFF9CA3AF),
                        ),
                        child: Text(_stepLabels[i]),
                      ),
                    ],
                  ),
                );
              }),
            ],
          ),
        ],
      ),
    );
  }

  // ──────────────────────────────────────────────────────────────────────────
  // BOTTOM CTA with glow and animated text
  // ──────────────────────────────────────────────────────────────────────────
  Widget _buildCTA(bool dark) {
    final bool canProceed = _step == 0
        ? true
        : _step == 1
            ? _targets.isNotEmpty
            : true;

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
      child: AnimatedContainer(
        duration: 400.ms,
        width: double.infinity,
        height: 56,
        decoration: BoxDecoration(
          gradient: canProceed ? Palette.gradientPrimary : null,
          color: canProceed ? null : dark ? Palette.surface2 : const Color(0xFFE2E8F0),
          borderRadius: BorderRadius.circular(16),
          boxShadow: canProceed
              ? [
                  BoxShadow(
                    color: Palette.primary.withValues(alpha: 0.35),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                    spreadRadius: -2,
                  ),
                ]
              : null,
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: canProceed ? _next : null,
            child: Center(
              child: AnimatedSwitcher(
                duration: 300.ms,
                child: Row(
                  key: ValueKey('$_step-$_total'),
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      _step < _total - 1 ? 'Continue' : "Let's Go!",
                      style: TextStyle(
                        color: canProceed
                            ? Colors.white
                            : dark
                                ? Palette.textTertiary
                                : const Color(0xFF9CA3AF),
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                        letterSpacing: 0.3,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Icon(
                      _step < _total - 1
                          ? Icons.arrow_forward_rounded
                          : Icons.rocket_launch_rounded,
                      color: canProceed
                          ? Colors.white
                          : dark
                              ? Palette.textTertiary
                              : const Color(0xFF9CA3AF),
                      size: 20,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ).animate().fadeIn(delay: 100.ms).slideY(begin: 0.1),
    );
  }

  // ──────────────────────────────────────────────────────────────────────────
  // STEP 1: Goal — with staggered card animations
  // ──────────────────────────────────────────────────────────────────────────
  Widget _stepGoal(bool dark) {
    return _stepShell(
      icon: Icons.flag_rounded,
      title: "What's your goal?",
      subtitle: 'This helps us tailor your experience',
      child: Column(
        children: [
          _GoalCard(
            icon: Icons.school_rounded,
            title: 'College Prep',
            subtitle: 'Build a strong profile for top universities',
            isSelected: _goal == 'college',
            index: 0,
            onTap: () {
              _hapticLight();
              setState(() => _goal = 'college');
            },
          ).animate().fadeIn(delay: 100.ms).slideX(begin: 0.05),
          const SizedBox(height: 12),
          _GoalCard(
            icon: Icons.emoji_events_rounded,
            title: 'Scholarship Hunt',
            subtitle: 'Find and win scholarships worldwide',
            isSelected: _goal == 'scholarship',
            index: 1,
            onTap: () {
              _hapticLight();
              setState(() => _goal = 'scholarship');
            },
          ).animate().fadeIn(delay: 200.ms).slideX(begin: 0.05),
          const SizedBox(height: 12),
          _GoalCard(
            icon: Icons.auto_awesome_rounded,
            title: 'Both',
            subtitle: 'Best of both worlds — max opportunity',
            isSelected: _goal == 'both',
            index: 2,
            onTap: () {
              _hapticLight();
              setState(() => _goal = 'both');
            },
          ).animate().fadeIn(delay: 300.ms).slideX(begin: 0.05),
        ],
      ),
    );
  }

  // ──────────────────────────────────────────────────────────────────────────
  // STEP 2: Target Schools — with chip counter
  // ──────────────────────────────────────────────────────────────────────────
  Widget _stepSchools(bool dark) {
    return _stepShell(
      icon: Icons.account_balance_rounded,
      title: 'Dream schools?',
      subtitle: _targets.isEmpty
          ? 'Pick at least one — we\'ll customize your plan'
          : '${_targets.length} selected',
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: _schools.map((school) {
          final selected = _targets.contains(school);
          return GestureDetector(
            onTap: () {
              _hapticLight();
              setState(() {
                if (selected) {
                  _targets.remove(school);
                } else {
                  _targets.add(school);
                }
              });
            },
            child: AnimatedContainer(
              duration: 250.ms,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 11),
              decoration: BoxDecoration(
                color: selected
                    ? Palette.primary
                    : dark
                        ? Palette.surface2
                        : const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: selected
                      ? Palette.primary
                      : dark
                          ? Palette.border
                          : const Color(0xFFE2E8F0),
                  width: selected ? 1.5 : 1,
                ),
                boxShadow: selected
                    ? [
                        BoxShadow(
                          color: Palette.primary.withValues(alpha: 0.25),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ]
                    : null,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AnimatedSwitcher(
                    duration: 200.ms,
                    child: selected
                        ? const Icon(Icons.check_circle_rounded,
                            key: ValueKey('check'), color: Colors.white, size: 16)
                        : const SizedBox(key: ValueKey('empty'), width: 4),
                  ),
                  if (selected) const SizedBox(width: 6),
                  Text(
                    school,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      color: selected
                          ? Colors.white
                          : dark
                              ? Palette.textPrimary
                              : Palette.textInverse,
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  // ──────────────────────────────────────────────────────────────────────────
  // STEP 3: Quick Profile — with improved inputs
  // ──────────────────────────────────────────────────────────────────────────
  Widget _stepProfile(bool dark) {
    return _stepShell(
      icon: Icons.person_rounded,
      title: 'About you',
      subtitle: 'Just the basics — we\'ll get to know you better later',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Name input with focus glow.
          TextField(
            onChanged: (v) => _name = v,
            textCapitalization: TextCapitalization.words,
            textInputAction: TextInputAction.next,
            decoration: InputDecoration(
              hintText: 'Your name',
              prefixIcon: const Icon(Icons.person_outline, size: 20),
              filled: true,
              fillColor: dark ? Palette.surface1 : Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide(
                  color: dark ? Palette.border : const Color(0xFFE2E8F0),
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide(
                  color: dark ? Palette.border : const Color(0xFFE2E8F0),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: const BorderSide(color: Palette.primary, width: 1.5),
              ),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            ),
          ).animate().fadeIn(delay: 100.ms),
          const SizedBox(height: 20),

          // Grade selector with premium look.
          Text(
            'Grade / Year',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 14,
              color: isDark(context) ? Palette.textSecondary : Palette.textTertiary,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: List.generate(6, (i) {
              final g = i + 9;
              final selected = _grade == g;
              return Expanded(
                child: GestureDetector(
                  onTap: () {
                    _hapticLight();
                    setState(() => _grade = g);
                  },
                  child: AnimatedContainer(
                    duration: 250.ms,
                    margin: const EdgeInsets.symmetric(horizontal: 3),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    decoration: BoxDecoration(
                      color: selected
                          ? Palette.primary
                          : dark
                              ? Palette.surface2
                              : const Color(0xFFF1F5F9),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: selected
                            ? Palette.primary
                            : Colors.transparent,
                        width: selected ? 1.5 : 1,
                      ),
                      boxShadow: selected
                          ? [
                              BoxShadow(
                                color: Palette.primary.withValues(alpha: 0.2),
                                blurRadius: 6,
                                offset: const Offset(0, 2),
                              ),
                            ]
                          : null,
                    ),
                    child: Center(
                      child: Text(
                        '$g',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 15,
                          color: selected
                              ? Colors.white
                              : (dark
                                  ? Palette.textPrimary
                                  : Palette.textInverse),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
          const SizedBox(height: 24),

          // Interests.
          Text(
            'Interests',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 14,
              color: isDark(context) ? Palette.textSecondary : Palette.textTertiary,
            ),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _interestItems.map((item) {
              final selected = _interests.contains(item);
              return GestureDetector(
                onTap: () {
                  _hapticLight();
                  setState(() {
                    if (selected) {
                      _interests.remove(item);
                    } else {
                      _interests.add(item);
                    }
                  });
                },
                child: AnimatedContainer(
                  duration: 250.ms,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
                  decoration: BoxDecoration(
                    color: selected
                        ? Palette.primary
                        : dark
                            ? Palette.surface2
                            : const Color(0xFFF1F5F9),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: selected
                          ? Palette.primary
                          : dark
                              ? Palette.border
                              : const Color(0xFFE2E8F0),
                      width: selected ? 1.5 : 1,
                    ),
                    boxShadow: selected
                        ? [
                            BoxShadow(
                              color: Palette.primary.withValues(alpha: 0.2),
                              blurRadius: 6,
                              offset: const Offset(0, 2),
                            ),
                          ]
                        : null,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      AnimatedSwitcher(
                        duration: 200.ms,
                        child: selected
                            ? const Icon(Icons.check_rounded,
                                key: ValueKey('chk'),
                                color: Colors.white,
                                size: 14)
                            : const SizedBox(key: ValueKey('emp'), width: 2),
                      ),
                      if (selected) const SizedBox(width: 4),
                      Text(
                        item,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                          color: selected
                              ? Colors.white
                              : dark
                                  ? Palette.textPrimary
                                  : Palette.textInverse,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  // ──────────────────────────────────────────────────────────────────────────
  // STEP 4: Schedule — with premium slider
  // ──────────────────────────────────────────────────────────────────────────
  Widget _stepSchedule(bool dark) {
    return _stepShell(
      icon: Icons.schedule_rounded,
      title: 'Your time',
      subtitle: 'How much can you dedicate each week?',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Available hours.
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Hours per week',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  color: isDark(context) ? Palette.textSecondary : Palette.textTertiary,
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                decoration: BoxDecoration(
                  color: Palette.primary.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '$_availableHours h',
                  style: const TextStyle(
                    fontWeight: FontWeight.w800,
                    color: Palette.primary,
                    fontSize: 18,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          SliderTheme(
            data: SliderThemeData(
              activeTrackColor: Palette.primary,
              inactiveTrackColor: dark ? Palette.surface3 : const Color(0xFFE2E8F0),
              thumbColor: Palette.primary,
              overlayColor: Palette.primary.withValues(alpha: 0.1),
              trackHeight: 6,
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 10),
              overlayShape: const RoundSliderOverlayShape(overlayRadius: 20),
            ),
            child: Slider(
              value: _availableHours.toDouble(),
              min: 5,
              max: 40,
              divisions: 7,
              onChanged: (v) {
                _hapticLight();
                setState(() => _availableHours = v.round());
              },
            ),
          ),
          const SizedBox(height: 32),

          // Peak time.
          Text(
            'When do you focus best?',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 14,
              color: isDark(context) ? Palette.textSecondary : Palette.textTertiary,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _PeakChip(
                icon: Icons.wb_sunny_outlined,
                label: 'Morning',
                isSelected: _peakTime == 'morning',
                onTap: () {
                  _hapticLight();
                  setState(() => _peakTime = 'morning');
                },
              ),
              const SizedBox(width: 8),
              _PeakChip(
                icon: Icons.wb_cloudy_outlined,
                label: 'Afternoon',
                isSelected: _peakTime == 'afternoon',
                onTap: () {
                  _hapticLight();
                  setState(() => _peakTime = 'afternoon');
                },
              ),
              const SizedBox(width: 8),
              _PeakChip(
                icon: Icons.nightlight_outlined,
                label: 'Night',
                isSelected: _peakTime == 'night',
                onTap: () {
                  _hapticLight();
                  setState(() => _peakTime = 'night');
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ──────────────────────────────────────────────────────────────────────────
  // STEP 5: Launch — with animated summary cards
  // ──────────────────────────────────────────────────────────────────────────
  Widget _stepLaunch(bool dark) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Celebration icon with pulse.
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                gradient: Palette.gradientPrimary,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Palette.primary.withValues(alpha: 0.4),
                    blurRadius: 30,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: const Icon(
                Icons.rocket_launch_rounded,
                color: Colors.white,
                size: 48,
              ),
            )
                .animate()
                .scale(
                    duration: 600.ms, curve: Curves.elasticOut)
                .then()
                .shimmer(
                    duration: 1200.ms,
                    color: Colors.white.withValues(alpha: 0.3)),

            const SizedBox(height: 32),
            Text(
              "You're all set!",
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.5,
                  ),
            ).animate().fadeIn(delay: 200.ms, duration: 400.ms),

            const SizedBox(height: 8),
            Text(
              'Your personalized profile plan is ready.\nTime to start forging your future.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: dark ? Palette.textSecondary : Palette.textTertiary,
                fontSize: 16,
                height: 1.5,
              ),
            ).animate().fadeIn(delay: 300.ms, duration: 400.ms),

            const SizedBox(height: 28),

            // Animated summary card.
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: dark
                    ? Palette.surface1.withValues(alpha: 0.8)
                    : Colors.white,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: dark ? Palette.border : const Color(0xFFE2E8F0),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 20,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  _SummaryRow(
                    icon: Icons.flag_rounded,
                    label: 'Goal',
                    value: _goal == 'both'
                        ? 'College + Scholarship'
                        : _goal == 'college'
                            ? 'College Prep'
                            : 'Scholarship',
                  ),
                  const SizedBox(height: 10),
                  _SummaryRow(
                    icon: Icons.school_rounded,
                    label: 'Targets',
                    value: _targets.isEmpty
                        ? 'Not set yet'
                        : '${_targets.length} schools',
                  ),
                  const SizedBox(height: 10),
                  _SummaryRow(
                    icon: Icons.schedule_rounded,
                    label: 'Time',
                    value: '$_availableHours h/week • $_peakTime',
                  ),
                  if (_interests.isNotEmpty) ...[
                    const SizedBox(height: 10),
                    _SummaryRow(
                      icon: Icons.interests_rounded,
                      label: 'Interests',
                      value: _interests.take(3).join(', ') +
                          (_interests.length > 3
                              ? ' +${_interests.length - 3} more'
                              : ''),
                    ),
                  ],
                ],
              ),
            ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.05),
          ],
        ),
      ),
    );
  }

  // ──────────────────────────────────────────────────────────────────────────
  // HELPERS
  // ──────────────────────────────────────────────────────────────────────────
  Widget _stepShell({
    required IconData icon,
    required String title,
    required String subtitle,
    required Widget child,
  }) {
    final dark = isDark(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          // Icon.
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Palette.primary.withValues(alpha: 0.15),
                  Palette.primary.withValues(alpha: 0.05),
                ],
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: Palette.primary.withValues(alpha: 0.15),
              ),
            ),
            child: Icon(icon, color: Palette.primary, size: 24),
          )
              .animate()
              .fadeIn(duration: 300.ms)
              .scale(
                begin: const Offset(0.8, 0.8),
                duration: 400.ms,
                curve: Curves.elasticOut,
              ),
          const SizedBox(height: 20),
          // Title.
          Text(
            title,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.3,
                ),
          )
              .animate()
              .fadeIn(delay: 100.ms, duration: 400.ms)
              .slideY(begin: 0.05),
          const SizedBox(height: 6),
          // Subtitle.
          AnimatedSwitcher(
            duration: 300.ms,
            child: Text(
              subtitle,
              key: ValueKey(subtitle),
              style: TextStyle(
                color: dark ? Palette.textSecondary : Palette.textTertiary,
                fontSize: 15,
                height: 1.4,
              ),
            ),
          ).animate().fadeIn(delay: 200.ms, duration: 400.ms),
          const SizedBox(height: 24),
          // Content.
          Expanded(
            child: SingleChildScrollView(
              child: child,
            ),
          ),
        ],
      ),
    );
  }
}

/// ────────────────────────────────────────────────────────────────────────────
/// CONFETTI OVERLAY — Premium completion celebration
/// ────────────────────────────────────────────────────────────────────────────
class _OnboardingConfetti extends StatelessWidget {
  final bool dark;
  const _OnboardingConfetti({required this.dark});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Material(
      color: Colors.black54,
      child: Stack(
        children: [
          // Confetti particles
          ...List.generate(
            40,
            (i) => Positioned(
              left: (i * 29.0) % size.width,
              top: -30 - (i * 17.0) % 150,
              child: Text(
                ['🎉', '⭐', '✨', '🌟', '💫', '🎊', '🏆', '🎯'][i % 8],
                style: TextStyle(fontSize: 14 + (i % 5) * 4),
              )
                  .animate(
                    delay: (i * 40).ms,
                    onPlay: (c) => c.repeat(),
                  )
                  .moveY(
                    begin: -30,
                    end: size.height + 60,
                    duration:
                        Duration(milliseconds: 1800 + (i * 150)),
                    curve: Curves.linear,
                  )
                  .rotate(
                    begin: 0,
                    end: (i % 2 == 0 ? 1 : -1) * 3 * math.pi,
                    duration:
                        Duration(milliseconds: 2500 + (i * 100)),
                  ),
            ),
          ),
          // Center card with premium glass effect.
          Center(
            child: Container(
              margin: const EdgeInsets.all(40),
              padding: const EdgeInsets.all(36),
              decoration: BoxDecoration(
                color: dark
                    ? Palette.surface1.withValues(alpha: 0.95)
                    : Colors.white.withValues(alpha: 0.98),
                borderRadius: BorderRadius.circular(28),
                border: Border.all(
                  color: dark
                      ? Palette.border.withValues(alpha: 0.3)
                      : const Color(0xFFE2E8F0),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Palette.primary.withValues(alpha: 0.3),
                    blurRadius: 60,
                    spreadRadius: 10,
                  ),
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('🚀', style: TextStyle(fontSize: 72))
                      .animate()
                      .scale(
                          duration: 500.ms, curve: Curves.elasticOut),
                  const SizedBox(height: 20),
                  Text(
                    'Your forge is ready!',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w800,
                      color: dark ? Palette.textPrimary : Palette.textInverse,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Let\'s build your admissions profile',
                    style: TextStyle(
                      fontSize: 15,
                      color: dark
                          ? Palette.textSecondary
                          : Palette.textTertiary,
                    ),
                  ),
                ],
              ),
            )
                .animate()
                .scale(
                  duration: 400.ms,
                  begin: const Offset(0.5, 0.5),
                  end: const Offset(1, 1),
                  curve: Curves.elasticOut,
                )
                .then()
                .shimmer(
                    duration: 1500.ms,
                    color: Palette.primary.withValues(alpha: 0.15)),
          ),
        ],
      ),
    );
  }
}

/// ────────────────────────────────────────────────────────────────────────────
/// GOAL SELECTION CARD — with premium hover/selection state
/// ────────────────────────────────────────────────────────────────────────────
class _GoalCard extends StatelessWidget {
  const _GoalCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.isSelected,
    required this.onTap,
    this.index = 0,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final bool isSelected;
  final VoidCallback onTap;
  final int index;

  @override
  Widget build(BuildContext context) {
    final dark = isDark(context);
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: 250.ms,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected
              ? Palette.primary.withValues(alpha: 0.1)
              : dark
                  ? Palette.surface1
                  : Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: isSelected
                ? Palette.primary
                : (dark ? Palette.border : const Color(0xFFE2E8F0)),
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
                    color: Colors.black.withValues(alpha: 0.03),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
        ),
        child: Row(
          children: [
            AnimatedContainer(
              duration: 250.ms,
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                gradient: isSelected
                    ? Palette.gradientPrimary
                    : null,
                color: isSelected
                    ? null
                    : (dark
                        ? Palette.surface2
                        : const Color(0xFFF1F5F9)),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(
                icon,
                color: isSelected
                    ? Colors.white
                    : (dark ? Palette.textSecondary : Palette.textTertiary),
                size: 22,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                      color: isSelected
                          ? Palette.primary
                          : (dark ? Palette.textPrimary : Palette.textInverse),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 13,
                      color:
                          dark ? Palette.textSecondary : Palette.textTertiary,
                    ),
                  ),
                ],
              ),
            ),
            AnimatedSwitcher(
              duration: 200.ms,
              child: isSelected
                  ? const Icon(Icons.check_circle_rounded,
                      key: ValueKey('selected'),
                      color: Palette.primary,
                      size: 24)
                  : Icon(Icons.radio_button_unchecked,
                      key: ValueKey('unselected'),
                      color: dark
                          ? Palette.border
                          : const Color(0xFFCBD5E1),
                      size: 24),
            ),
          ],
        ),
      ),
    );
  }
}

/// ────────────────────────────────────────────────────────────────────────────
/// PEAK TIME CHIP — with icon and glow on selection
/// ────────────────────────────────────────────────────────────────────────────
class _PeakChip extends StatelessWidget {
  const _PeakChip({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final dark = isDark(context);
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: 250.ms,
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            color: isSelected
                ? Palette.primary
                : (dark ? Palette.surface2 : const Color(0xFFF1F5F9)),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: isSelected ? Palette.primary : Colors.transparent,
              width: 1.5,
            ),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: Palette.primary.withValues(alpha: 0.25),
                      blurRadius: 10,
                      offset: const Offset(0, 3),
                    ),
                  ]
                : null,
          ),
          child: Column(
            children: [
              Icon(
                icon,
                color: isSelected
                    ? Colors.white
                    : (dark ? Palette.textSecondary : Palette.textTertiary),
                size: 24,
              ),
              const SizedBox(height: 8),
              Text(
                label,
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 13,
                  color: isSelected
                      ? Colors.white
                      : (dark ? Palette.textPrimary : Palette.textInverse),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// ────────────────────────────────────────────────────────────────────────────
/// SUMMARY ROW — for the launch step summary card
/// ────────────────────────────────────────────────────────────────────────────
class _SummaryRow extends StatelessWidget {
  const _SummaryRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final dark = isDark(context);
    return Row(
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: Palette.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: Palette.primary, size: 18),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: dark ? Palette.textTertiary : Palette.textTertiary,
              ),
            ),
            Text(
              value,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: dark ? Palette.textPrimary : Palette.textInverse,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
