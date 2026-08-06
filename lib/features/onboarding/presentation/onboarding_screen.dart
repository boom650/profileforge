import 'package:flutter/material.dart';
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
/// Onboarding v5 — 5-step illustrated wizard.
/// Swipe-based, full-screen pages, minimal text, maximum personality.
/// ────────────────────────────────────────────────────────────────────────────
class OnboardingScreen extends ConsumerStatefulWidget {
  final String profileId;
  const OnboardingScreen({super.key, required this.profileId});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final _page = PageController();
  int _step = 0;
  static const int _total = 11;

  // Step 1: Goal.
  String _goal = 'both';

  // Step 2: Target schools.
  final Set<String> _targets = {};

  // Step 2.5: City.
  String _city = '';

  // Step 3: Quick profile.
  String _name = '';
  int _grade = 11;
  final Set<String> _interests = {};

  // Step 3.5: Grades (subject → grade).
  final Map<String, String> _grades = {};
  final Map<String, String> _gradeInput = {};

  // Step 3.6: Activities (extracurriculars).
  final List<String> _activities = [];
  final Set<String> _activityChips = {};

  // Step 3.7: Competitions / awards.
  final List<Achievement> _competitions = [];

  // Step 3.8: Careers.
  final Set<String> _careers = {};

  // Step 3.9: Essay — story seed, values, curiosity, prompt pref.
  final TextEditingController _storyCtrl = TextEditingController();
  final TextEditingController _curiosityCtrl = TextEditingController();
  final Set<String> _values = {};
  String _promptPref = '';

  // Capture a new activity / competition.
  final _activityCtrl = TextEditingController();
  final _compNameCtrl = TextEditingController();
  final _compResultCtrl = TextEditingController();

  // Step 4: Schedule.
  int _availableHours = 15;
  String _peakTime = 'morning';

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

  final _activityItems = [
    'School Club', 'Student Council', 'Debate Team', 'Robotics',
    'Volunteering', 'Research', 'Coding', 'Sports Team', 'Music / Band',
    'Art / Design', 'Writing / Journalism', 'Math Olympiad', 'Startup',
  ];

  final _careerItems = [
    'Engineering', 'Medicine', 'Computer Science', 'Law', 'Finance',
    'Research / Science', 'Design / Architecture', 'Entrepreneurship',
    'Public Policy', 'AI / Data Science',
  ];

  final _valueItems = [
    'Curiosity', 'Grit', 'Honesty', 'Leadership', 'Kindness',
    'Creativity', 'Justice', 'Courage', 'Perseverance', 'Ambition',
  ];

  // Common App prompt labels (2024-25) for essay self-identification.
  static const _promptLabels = [
    'Identity / background', 'Obstacle & growth', 'Challenged a belief',
    'Problem to solve', 'Personal growth', 'Flow / what fascinates me',
    'Topic of my choice',
  ];

  void _next() {
    SoundService.instance.tap();
    if (_step < _total - 1) {
      _page.nextPage(duration: 350.ms, curve: Curves.easeInOut);
    } else {
      _finish();
    }
  }

  void _prev() {
    if (_step > 0) {
      _page.previousPage(duration: 350.ms, curve: Curves.easeInOut);
    }
  }

  OnboardingProfile _buildProfile() => OnboardingProfile(
        profileId: widget.profileId,
        grades: Map<String, String>.from(_grades),
        activities: List<String>.from(_activities),
        competitions: List<Achievement>.from(_competitions),
        subjects: _interests.toList(),
        targetUniversities: _targets.toList(),
        careerInterests: _careers.toList(),
        budget: 0,
        travelRadiusKm: 10,
        availabilityHoursPerWeek: _availableHours,
        location: _city,
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
    final p = _buildProfile();
    final s = _buildSchedule();

    ref.read(saveOnboardingProvider(p));
    ref.read(onboardingRepositoryProvider).saveSchedule(s, widget.profileId);

    // Persist essay material so AI missions speak to the real narrative.
    final essay = EssayContext(
      story: _storyCtrl.text.trim(),
      values: _values.toList(),
      curiosity: _curiosityCtrl.text.trim(),
      promptPref: _promptPref,
    );
    ref.read(onboardingRepositoryProvider).saveEssay(essay, widget.profileId);

    // Mark onboarded.
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('pf_onboarded', true);
    await prefs.setString('pf_user_name', _name);

    SoundService.instance.success();
    if (mounted) {
      celebrate(context, message: 'Your forge is ready! 🚀');
      Future.delayed(1200.ms, () {
        if (mounted) {
          // Navigate to psychology onboarding after basic onboarding.
          context.go('/psychology-onboarding');
        }
      });
    }
  }

  @override
  void dispose() {
    _page.dispose();
    _storyCtrl.dispose();
    _curiosityCtrl.dispose();
    _activityCtrl.dispose();
    _compNameCtrl.dispose();
    _compResultCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dark = isDark(context);
    final progress = (_step + 1) / _total;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: dark
                ? [const Color(0xFF0B1120), Palette.surface0, Palette.black]
                : [const Color(0xFFEEF2FF), const Color(0xFFF8FAFC), Colors.white],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // ── Header: progress dots + skip ──
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                child: Row(
                  children: [
                    // Back button.
                    if (_step > 0)
                      GestureDetector(
                        onTap: _prev,
                        child: Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            color: dark ? Palette.surface2 : const Color(0xFFE2E8F0),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(Icons.arrow_back_ios_new, size: 16),
                        ),
                      )
                    else
                      const SizedBox(width: 36),
                    const Spacer(),
                    // Progress dots.
                    ...List.generate(_total, (i) {
                      final isActive = i == _step;
                      final isDone = i < _step;
                      return AnimatedContainer(
                        duration: 300.ms,
                        margin: const EdgeInsets.symmetric(horizontal: 3),
                        width: isActive ? 24 : 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: isDone
                              ? Palette.primary
                              : isActive
                                  ? Palette.primary
                                  : dark
                                      ? Palette.surface3
                                      : const Color(0xFFCBD5E1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      );
                    }),
                    const Spacer(),
                    // Skip button.
                    TextButton(
                      onPressed: () => context.go('/home'),
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
              ),

              // ── Page content ──
              Expanded(
                child: PageView(
                  controller: _page,
                  onPageChanged: (i) => setState(() => _step = i),
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    _stepGoal(dark),
                    _stepSchools(dark),
                    _stepCity(dark),
                    _stepProfile(dark),
                    _stepGrades(dark),
                    _stepActivities(dark),
                    _stepCompetitions(dark),
                    _stepCareers(dark),
                    _stepEssay(dark),
                    _stepSchedule(dark),
                    _stepLaunch(dark),
                  ],
                ),
              ),

              // ── Bottom CTA ──
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                child: SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: Palette.gradientPrimary,
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [
                        BoxShadow(
                          color: Palette.primary.withValues(alpha: 0.3),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(14),
                        onTap: _next,
                        child: Center(
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                _step < _total - 1 ? 'Continue' : "Let's Go!",
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Icon(
                                _step < _total - 1
                                    ? Icons.arrow_forward
                                    : Icons.rocket_launch,
                                color: Colors.white,
                                size: 20,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ).animate().fadeIn(delay: 100.ms),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ──────────────────────────────────────────────────────────────────────────
  // STEP 1: Goal
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
            onTap: () => setState(() => _goal = 'college'),
          ),
          const SizedBox(height: 12),
          _GoalCard(
            icon: Icons.emoji_events_rounded,
            title: 'Scholarship Hunt',
            subtitle: 'Find and win scholarships worldwide',
            isSelected: _goal == 'scholarship',
            onTap: () => setState(() => _goal = 'scholarship'),
          ),
          const SizedBox(height: 12),
          _GoalCard(
            icon: Icons.auto_awesome_rounded,
            title: 'Both',
            subtitle: 'Best of both worlds — max opportunity',
            isSelected: _goal == 'both',
            onTap: () => setState(() => _goal = 'both'),
          ),
        ],
      ),
    );
  }

  // ──────────────────────────────────────────────────────────────────────────
  // STEP 2: Target Schools
  // ──────────────────────────────────────────────────────────────────────────
  Widget _stepSchools(bool dark) {
    return _stepShell(
      icon: Icons.account_balance_rounded,
      title: 'Dream schools?',
      subtitle: 'Pick a few — we\'ll customize your plan',
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: _schools.map((school) {
          final selected = _targets.contains(school);
          return GestureDetector(
            onTap: () => setState(() {
              if (selected) {
                _targets.remove(school);
              } else {
                _targets.add(school);
              }
            }),
            child: AnimatedContainer(
              duration: 200.ms,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
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
                ),
              ),
              child: Text(
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
            ),
          );
        }).toList(),
      ),
    );
  }

  // ──────────────────────────────────────────────────────────────────────────
  // STEP 2.5: City / Location
  // ──────────────────────────────────────────────────────────────────────────
  Widget _stepCity(bool dark) {
    final cities = [
      'Singapore', 'New York', 'London', 'Mumbai', 'Sydney',
      'Tokyo', 'Toronto', 'Berlin', 'Dubai', 'San Francisco',
    ];
    return _stepShell(
      icon: Icons.location_on_rounded,
      title: 'Where are you based?',
      subtitle: 'We\'ll recommend the best study spots and local resources',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Search-style input
          TextField(
            onChanged: (v) => _city = v,
            textCapitalization: TextCapitalization.words,
            textInputAction: TextInputAction.done,
            decoration: InputDecoration(
              hintText: 'Type your city...',
              prefixIcon: const Icon(Icons.search, size: 20),
              suffixIcon: _city.isNotEmpty
                  ? GestureDetector(
                      onTap: () => setState(() => _city = ''),
                      child: const Icon(Icons.clear, size: 18),
                    )
                  : null,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Popular cities',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 13,
              color: dark ? Palette.textSecondary : Palette.textTertiary,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: cities.map((city) {
              final selected = _city == city;
              return GestureDetector(
                onTap: () => setState(() => _city = city),
                child: AnimatedContainer(
                  duration: 200.ms,
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
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
                    ),
                  ),
                  child: Text(
                    city,
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
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 16),
          // City-specific tip
          if (_city.isNotEmpty)
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Palette.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Palette.primary.withValues(alpha: 0.2)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.lightbulb_rounded, size: 18, color: Palette.primary),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Great choice! We\'ll find the best study spots in $_city.',
                      style: TextStyle(
                        fontSize: 13,
                        color: dark ? Palette.textPrimary : Palette.textInverse,
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  // ──────────────────────────────────────────────────────────────────────────
  // STEP 3: Quick Profile
  // ──────────────────────────────────────────────────────────────────────────
  Widget _stepProfile(bool dark) {
    return _stepShell(
      icon: Icons.person_rounded,
      title: 'About you',
      subtitle: 'Just the basics — we\'ll get to know you better later',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Name.
          TextField(
            onChanged: (v) => _name = v,
            textCapitalization: TextCapitalization.words,
            textInputAction: TextInputAction.next,
            decoration: const InputDecoration(
              hintText: 'Your name',
              prefixIcon: Icon(Icons.person_outline, size: 20),
            ),
          ),
          const SizedBox(height: 16),

          // Grade selector.
          Text(
            'Grade / Year',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 14,
              color: isDark(context) ? Palette.textSecondary : Palette.textTertiary,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: List.generate(6, (i) {
              final g = i + 9;
              final selected = _grade == g;
              return Expanded(
                child: GestureDetector(
                  onTap: () => setState(() => _grade = g),
                  child: AnimatedContainer(
                    duration: 200.ms,
                    margin: const EdgeInsets.symmetric(horizontal: 3),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: selected ? Palette.primary : dark ? Palette.surface2 : const Color(0xFFF1F5F9),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: selected ? Palette.primary : Colors.transparent,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        '$g',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                          color: selected ? Colors.white : (dark ? Palette.textPrimary : Palette.textInverse),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
          const SizedBox(height: 20),

          // Interests.
          Text(
            'Interests',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 14,
              color: isDark(context) ? Palette.textSecondary : Palette.textTertiary,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _interestItems.map((item) {
              final selected = _interests.contains(item);
              return GestureDetector(
                onTap: () => setState(() {
                  if (selected) {
                    _interests.remove(item);
                  } else {
                    _interests.add(item);
                  }
                }),
                child: AnimatedContainer(
                  duration: 200.ms,
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
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
                    ),
                  ),
                  child: Text(
                    item,
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 13,
                      color: selected
                          ? Colors.white
                          : dark
                              ? Palette.textPrimary
                              : Palette.textInverse,
                    ),
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
  // STEP 3.5: Grades
  // ──────────────────────────────────────────────────────────────────────────
  Widget _stepGrades(bool dark) {
    final subjects = _interests.isEmpty
        ? const ['Math', 'Physics', 'Chemistry', 'Biology', 'CS', 'English']
        : _interests.toList();
    return _stepShell(
      icon: Icons.grade_rounded,
      title: 'Your grades',
      subtitle: 'Rough is fine — this helps us spot your strengths & weak spots',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ...subjects.map((s) {
            final grade = _grades[s] ?? '';
            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: Text(
                      s,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        color: dark ? Palette.textPrimary : Palette.textInverse,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 4,
                    child: SizedBox(
                      height: 40,
                      child: TextField(
                        onChanged: (v) => setState(() {
                          if (v.trim().isEmpty) {
                            _grades.remove(s);
                          } else {
                            _grades[s] = v.trim();
                          }
                        }),
                        textCapitalization: TextCapitalization.none,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          hintText: 'e.g. 92 / A*',
                          hintStyle: TextStyle(
                            fontSize: 12,
                            color: dark ? Palette.textTertiary : Palette.textTertiary,
                          ),
                          isDense: true,
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
          const SizedBox(height: 4),
          Text(
            'Tip: add your board percentage (CBSE/ICSE/IB) or letter grade.',
            style: TextStyle(
              fontSize: 12,
              color: dark ? Palette.textSecondary : Palette.textTertiary,
            ),
          ),
        ],
      ),
    );
  }

  // ──────────────────────────────────────────────────────────────────────────
  // STEP 3.6: Activities
  // ──────────────────────────────────────────────────────────────────────────
  Widget _stepActivities(bool dark) {
    return _stepShell(
      icon: Icons.rocket_rounded,
      title: 'What do you do outside class?',
      subtitle: 'Clubs, teams, projects — anything you spend time on',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _activityItems.map((item) {
              final selected = _activityChips.contains(item);
              return GestureDetector(
                onTap: () => setState(() {
                  if (selected) {
                    _activityChips.remove(item);
                    _activities.remove(item);
                  } else {
                    _activityChips.add(item);
                    _activities.add(item);
                  }
                }),
                child: _Chip(label: item, selected: selected),
              );
            }).toList(),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 44,
                  child: TextField(
                    controller: _activityCtrl,
                    textCapitalization: TextCapitalization.words,
                    decoration: const InputDecoration(
                      hintText: 'Add your own activity...',
                      isDense: true,
                      prefixIcon: Icon(Icons.add_rounded, size: 20),
                    ),
                    onSubmitted: (_) => _addActivity(),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              _IconButton(
                icon: Icons.add_rounded,
                onTap: _addActivity,
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _addActivity() {
    final v = _activityCtrl.text.trim();
    if (v.isEmpty || _activities.contains(v)) return;
    setState(() {
      _activities.add(v);
      _activityCtrl.clear();
    });
  }

  // ──────────────────────────────────────────────────────────────────────────
  // STEP 3.7: Competitions
  // ──────────────────────────────────────────────────────────────────────────
  Widget _stepCompetitions(bool dark) {
    return _stepShell(
      icon: Icons.emoji_events_rounded,
      title: 'Competitions & awards',
      subtitle: 'Olympiads, hackathons, medals — every win counts',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                flex: 5,
                child: SizedBox(
                  height: 44,
                  child: TextField(
                    controller: _compNameCtrl,
                    textCapitalization: TextCapitalization.words,
                    decoration: const InputDecoration(
                      hintText: 'Competition name',
                      isDense: true,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                flex: 4,
                child: SizedBox(
                  height: 44,
                  child: TextField(
                    controller: _compResultCtrl,
                    decoration: const InputDecoration(
                      hintText: 'Result (Gold...)',
                      isDense: true,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              _IconButton(
                icon: Icons.add_rounded,
                onTap: _addCompetition,
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (_competitions.isEmpty)
            Text(
              "No awards yet — that's fine, add them as you go.",
              style: TextStyle(
                fontSize: 13,
                color: dark ? Palette.textSecondary : Palette.textTertiary,
              ),
            )
          else
            ..._competitions.map((a) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: _AchievementTile(
                    achievement: a,
                    onRemove: () => setState(
                        () => _competitions.removeWhere((x) => x == a)),
                  ),
                )),
        ],
      ),
    );
  }

  void _addCompetition() {
    final name = _compNameCtrl.text.trim();
    final result = _compResultCtrl.text.trim();
    if (name.isEmpty || result.isEmpty) return;
    setState(() {
      _competitions.add(Achievement(name: name, result: result, year: ''));
      _compNameCtrl.clear();
      _compResultCtrl.clear();
    });
  }

  // ──────────────────────────────────────────────────────────────────────────
  // STEP 3.8: Careers
  // ──────────────────────────────────────────────────────────────────────────
  Widget _stepCareers(bool dark) {
    return _stepShell(
      icon: Icons.work_rounded,
      title: 'What could you see yourself doing?',
      subtitle: 'Career directions you find interesting right now',
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: _careerItems.map((item) {
          final selected = _careers.contains(item);
          return GestureDetector(
            onTap: () => setState(() {
              if (selected) {
                _careers.remove(item);
              } else {
                _careers.add(item);
              }
            }),
            child: _Chip(label: item, selected: selected),
          );
        }).toList(),
      ),
    );
  }

  // ──────────────────────────────────────────────────────────────────────────
  // STEP 3.9: Essay — story seed, values, curiosity, prompt pref.
  // ──────────────────────────────────────────────────────────────────────────
  Widget _stepEssay(bool dark) {
    return _stepShell(
      icon: Icons.auto_stories_rounded,
      title: 'Your story — the raw material',
      subtitle: 'A few honest details will power your personal statement & missions',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'A moment that changed how you see things',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 14,
              color: dark ? Palette.textSecondary : Palette.textTertiary,
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _storyCtrl,
            maxLines: 3,
            maxLength: 240,
            textCapitalization: TextCapitalization.sentences,
            decoration: const InputDecoration(
              hintText: 'It can be small — a failure, a question, a person...',
              alignLabelWithHint: true,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'What keeps you up at night?',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 14,
              color: dark ? Palette.textSecondary : Palette.textTertiary,
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _curiosityCtrl,
            maxLines: 2,
            maxLength: 200,
            decoration: const InputDecoration(
              hintText: 'A question you can\'t stop thinking about',
              alignLabelWithHint: true,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Values that define you',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 14,
              color: dark ? Palette.textSecondary : Palette.textTertiary,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _valueItems.map((item) {
              final selected = _values.contains(item);
              return GestureDetector(
                onTap: () => setState(() {
                  if (selected) {
                    _values.remove(item);
                  } else {
                    _values.add(item);
                  }
                }),
                child: _Chip(label: item, selected: selected),
              );
            }).toList(),
          ),
          const SizedBox(height: 20),
          Text(
            'Which essay prompt resonates most?',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 14,
              color: dark ? Palette.textSecondary : Palette.textTertiary,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: List.generate(_promptLabels.length, (i) {
              final pref = '${i + 1}';
              final selected = _promptPref == pref;
              return GestureDetector(
                onTap: () => setState(() => _promptPref = selected ? '' : pref),
                child: _Chip(label: '${i + 1}. ${_promptLabels[i]}', selected: selected),
              );
            }),
          ),
        ],
      ),
    );
  }

  // ──────────────────────────────────────────────────────────────────────────
  // STEP 4: Schedule
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
          Text(
            'Available hours per week',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 14,
              color: isDark(context) ? Palette.textSecondary : Palette.textTertiary,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: SliderTheme(
                  data: SliderThemeData(
                    activeTrackColor: Palette.primary,
                    inactiveTrackColor: dark ? Palette.surface3 : const Color(0xFFE2E8F0),
                    thumbColor: Palette.primary,
                    overlayColor: Palette.primary.withValues(alpha: 0.1),
                    trackHeight: 6,
                    thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8),
                  ),
                  child: Slider(
                    value: _availableHours.toDouble(),
                    min: 5,
                    max: 40,
                    divisions: 7,
                    label: '$_availableHours h',
                    onChanged: (v) => setState(() => _availableHours = v.round()),
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Palette.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '$_availableHours h',
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    color: Palette.primary,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

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
                onTap: () => setState(() => _peakTime = 'morning'),
              ),
              const SizedBox(width: 8),
              _PeakChip(
                icon: Icons.wb_cloudy_outlined,
                label: 'Afternoon',
                isSelected: _peakTime == 'afternoon',
                onTap: () => setState(() => _peakTime = 'afternoon'),
              ),
              const SizedBox(width: 8),
              _PeakChip(
                icon: Icons.nightlight_outlined,
                label: 'Night',
                isSelected: _peakTime == 'night',
                onTap: () => setState(() => _peakTime = 'night'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ──────────────────────────────────────────────────────────────────────────
  // STEP 5: Launch!
  // ──────────────────────────────────────────────────────────────────────────
  Widget _stepLaunch(bool dark) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Celebration icon.
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
            ).animate().scale(
                  begin: const Offset(0, 0),
                  duration: 600.ms,
                  curve: Curves.elasticOut,
                ),

            const SizedBox(height: 32),

            Text(
              "You're all set!",
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w800,
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

            const SizedBox(height: 24),

            // Summary card.
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: dark ? Palette.surface1 : Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: dark ? Palette.border : const Color(0xFFE2E8F0),
                ),
              ),
              child: Column(
                children: [
                  _SummaryRow(
                    icon: Icons.flag_rounded,
                    label: 'Goal',
                    value: _goal == 'both' ? 'College + Scholarship' : _goal == 'college' ? 'College Prep' : 'Scholarship',
                  ),
                  const SizedBox(height: 8),
                  _SummaryRow(
                    icon: Icons.school_rounded,
                    label: 'Targets',
                    value: _targets.isEmpty ? 'Not set yet' : '${_targets.length} schools',
                  ),
                  const SizedBox(height: 8),
                  _SummaryRow(
                    icon: Icons.schedule_rounded,
                    label: 'Time',
                    value: '$_availableHours h/week • $_peakTime',
                  ),
                  const SizedBox(height: 8),
                  _SummaryRow(
                    icon: Icons.grade_rounded,
                    label: 'Grades',
                    value: _grades.isEmpty
                        ? 'Not set'
                        : '${_grades.length} subjects',
                  ),
                  const SizedBox(height: 8),
                  _SummaryRow(
                    icon: Icons.rocket_rounded,
                    label: 'Activities',
                    value: _activities.isEmpty
                        ? 'None yet'
                        : '${_activities.length} listed',
                  ),
                  const SizedBox(height: 8),
                  _SummaryRow(
                    icon: Icons.emoji_events_rounded,
                    label: 'Awards',
                    value: _competitions.isEmpty
                        ? 'None yet'
                        : '${_competitions.length} listed',
                  ),
                  if (_storyCtrl.text.trim().isNotEmpty ||
                      _curiosityCtrl.text.trim().isNotEmpty ||
                      _values.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    _SummaryRow(
                      icon: Icons.auto_stories_rounded,
                      label: 'Story',
                      value: 'Captured ✨',
                    ),
                  ],
                ],
              ),
            ).animate().fadeIn(delay: 400.ms, duration: 400.ms).slideY(begin: 0.05),
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          // Icon.
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: Palette.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: Palette.primary, size: 24),
          ).animate().fadeIn(duration: 300.ms).scale(
                begin: const Offset(0.8, 0.8),
                duration: 400.ms,
                curve: Curves.elasticOut,
              ),
          const SizedBox(height: 20),
          // Title.
          Text(
            title,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
          ).animate().fadeIn(delay: 100.ms, duration: 400.ms).slideY(begin: 0.05),
          const SizedBox(height: 6),
          // Subtitle.
          Text(
            subtitle,
            style: TextStyle(
              color: Theme.of(context).hintColor,
              fontSize: 15,
              height: 1.4,
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

/// Goal selection card.
class _GoalCard extends StatelessWidget {
  const _GoalCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.isSelected,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final dark = isDark(context);
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: 200.ms,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected
              ? Palette.primary.withValues(alpha: 0.1)
              : dark
                  ? Palette.surface1
                  : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? Palette.primary : (dark ? Palette.border : const Color(0xFFE2E8F0)),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: isSelected ? Palette.primary : (dark ? Palette.surface2 : const Color(0xFFF1F5F9)),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: isSelected ? Colors.white : (dark ? Palette.textSecondary : Palette.textTertiary),
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
                      color: dark ? Palette.textSecondary : Palette.textTertiary,
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              const Icon(Icons.check_circle, color: Palette.primary, size: 22)
            else
              Icon(Icons.radio_button_unchecked,
                  color: dark ? Palette.border : const Color(0xFFCBD5E1), size: 22),
          ],
        ),
      ),
    );
  }
}

/// Peak time chip.
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
          duration: 200.ms,
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: isSelected ? Palette.primary : (dark ? Palette.surface2 : const Color(0xFFF1F5F9)),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected ? Palette.primary : Colors.transparent,
            ),
          ),
          child: Column(
            children: [
              Icon(
                icon,
                color: isSelected ? Colors.white : (dark ? Palette.textSecondary : Palette.textTertiary),
                size: 22,
              ),
              const SizedBox(height: 6),
              Text(
                label,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                  color: isSelected ? Colors.white : (dark ? Palette.textPrimary : Palette.textInverse),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Summary row for launch step.
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
        Icon(icon, size: 18, color: Palette.primary),
        const SizedBox(width: 10),
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: dark ? Palette.textSecondary : Palette.textTertiary,
          ),
        ),
        const Spacer(),
        Text(
          value,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14,
            color: dark ? Palette.textPrimary : Palette.textInverse,
          ),
        ),
      ],
    );
  }
}

/// Pill selectable chip used across onboarding steps.
class _Chip extends StatelessWidget {
  const _Chip({required this.label, required this.selected});

  final String label;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    final dark = isDark(context);
    return AnimatedContainer(
      duration: 180.ms,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
      decoration: BoxDecoration(
        color: selected
            ? Palette.primary
            : (dark ? Palette.surface2 : const Color(0xFFF1F5F9)),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: selected ? Palette.primary : Colors.transparent,
        ),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
          fontSize: 13,
          color: selected
              ? Colors.white
              : (dark ? Palette.textPrimary : Palette.textInverse),
        ),
      ),
    );
  }
}

/// Small round icon button.
class _IconButton extends StatelessWidget {
  const _IconButton({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final dark = isDark(context);
    return Material(
      color: Palette.primary.withValues(alpha: 0.1),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: SizedBox(
          width: 44,
          height: 44,
          child: Icon(icon, color: Palette.primary, size: 22),
        ),
      ),
    );
  }
}

/// Compact read-only list tile for a captured competition/award.
class _AchievementTile extends StatelessWidget {
  const _AchievementTile({required this.achievement, required this.onRemove});

  final Achievement achievement;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final dark = isDark(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: dark ? Palette.surface2 : const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: dark ? Palette.border : const Color(0xFFE2E8F0)),
      ),
      child: Row(
        children: [
          Icon(Icons.workspace_premium_rounded,
              color: Palette.primary, size: 18),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              achievement.label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: dark ? Palette.textPrimary : Palette.textInverse,
              ),
            ),
          ),
          GestureDetector(
            onTap: onRemove,
            child: Icon(Icons.close_rounded,
                size: 18,
                color: dark ? Palette.textTertiary : Palette.textTertiary),
          ),
        ],
      ),
    );
  }
}
