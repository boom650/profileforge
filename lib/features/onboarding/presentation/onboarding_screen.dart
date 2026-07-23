import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:profileforge/core/audio/sound_service.dart';
import 'package:profileforge/core/celebration/celebrate.dart';
import 'package:profileforge/core/theme/app_theme.dart';
import 'package:profileforge/features/onboarding/application/onboarding_providers.dart';
import 'package:profileforge/features/onboarding/domain/onboarding_models.dart';

/// ────────────────────────────────────────────────────────────────────────────
/// Overhauled onboarding (v4) — space‑themed, 10 steps.
/// Collects CV data + schedule + energy + goals + environment.
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
  static const int _total = 10;

  // Existing profile fields.
  final _targets = <String>{};
  final _subjectsCtrl = TextEditingController();
  final _gradesCtrl = TextEditingController();
  final _activitiesCtrl = TextEditingController();
  final _compNameCtrl = TextEditingController();
  final _compResultCtrl = TextEditingController();
  final _compYearCtrl = TextEditingController();
  final _careersCtrl = TextEditingController();
  int _availability = 5;
  final _grades = <String, String>{};
  final _activities = <String>[];
  final _competitions = <Achievement>[];

  // Schedule fields.
  final _schoolDays = <int>{1, 2, 3, 4, 5}; // Mon–Fri default
  int _schoolStartHour = 8;
  int _schoolStartMin = 0;
  int _schoolEndHour = 15;
  int _schoolEndMin = 0;

  // Energy fields.
  String _energyPeak = 'morning';
  int _sleepH = 22;
  int _sleepM = 0;
  int _wakeH = 7;
  int _wakeM = 0;

  // Goals.
  String _timelineGoal = '1year';
  int _timelineMonths = 12;

  // Environment.
  String _studyEnvironment = 'mixed';
  int _screenTimeHours = 3;
  String _socialMediaUsage = 'moderate';

  final _uniSuggestions = [
    'MIT', 'Stanford', 'Oxford', 'Cambridge', 'Harvard', 'Yale',
    'Princeton', 'NUS', 'ETH Zürich', 'Imperial College',
  ];
  final _subjectSuggestions = [
    'Math', 'Physics', 'Chemistry', 'Biology', 'Computer Science',
    'Economics', 'History', 'English', 'Geography',
  ];
  final _careerSugs = [
    'Engineering', 'Medicine', 'Computer Science', 'Business',
    'Law', 'Research', 'Design', 'Physics',
  ];

  // ── Labels ──
  static const _weekdayLabels = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

  void _next() {
    SoundService.instance.tap();
    if (_step < _total - 1) {
      _page.nextPage(duration: 300.ms, curve: Curves.easeInOut);
    } else {
      _finish();
    }
  }

  OnboardingProfile _buildProfile() => OnboardingProfile(
        profileId: widget.profileId,
        grades: _grades,
        activities: _activities,
        competitions: _competitions,
        subjects: _subjectsCtrl.text
            .split(',')
            .map((e) => e.trim())
            .where((e) => e.isNotEmpty)
            .toList(),
        targetUniversities: _targets.toList(),
        careerInterests: _careersCtrl.text
            .split(',')
            .map((e) => e.trim())
            .where((e) => e.isNotEmpty)
            .toList(),
        budget: 0,
        travelRadiusKm: 10,
        availabilityHoursPerWeek: _availability,
        location: '',
      );

  ScheduleProfile _buildSchedule() => ScheduleProfile(
        schoolDays: _schoolDays.toList()..sort(),
        schoolStartHour: _schoolStartHour,
        schoolStartMinute: _schoolStartMin,
        schoolEndHour: _schoolEndHour,
        schoolEndMinute: _schoolEndMin,
        energyPeak: _energyPeak,
        sleepStart: '${_sleepH.toString().padLeft(2, '0')}:${_sleepM.toString().padLeft(2, '0')}',
        sleepEnd: '${_wakeH.toString().padLeft(2, '0')}:${_wakeM.toString().padLeft(2, '0')}',
        timelineGoal: _timelineGoal,
        screenTimeHours: _screenTimeHours,
        studyEnvironment: _studyEnvironment,
        socialMediaUsage: _socialMediaUsage,
      );

  void _finish() {
    // Parse grades.
    for (final part in _gradesCtrl.text.split(',')) {
      final kv = part.split(RegExp(r'[:\\-]'));
      if (kv.length == 2) {
        _grades[kv[0].trim()] = kv[1].trim();
      }
    }
    for (final a in _activitiesCtrl.text.split('\n')) {
      final t = a.trim();
      if (t.isNotEmpty) _activities.add(t);
    }
    final p = _buildProfile();
    final s = _buildSchedule();

    ref.read(saveOnboardingProvider(p));
    ref.read(onboardingRepositoryProvider).saveSchedule(s, widget.profileId);

    SoundService.instance.success();
    if (mounted) {
      celebrate(context, message: 'Your forge is ready! 🚀');
      Future.delayed(900.ms, () {
        if (mounted) Navigator.of(context).maybePop();
      });
    }
  }

  @override
  void dispose() {
    _subjectsCtrl.dispose();
    _gradesCtrl.dispose();
    _activitiesCtrl.dispose();
    _compNameCtrl.dispose();
    _compResultCtrl.dispose();
    _compYearCtrl.dispose();
    _careersCtrl.dispose();
    _page.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final progress = (_step + 1) / _total;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isDark
                ? [Palette.ink, Palette.inkSurface, const Color(0xFF0B0E2A)]
                : [Colors.white, const Color(0xFFF0F4FF)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // ── Progress & close ──
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Text('🚀 Launch Prep',
                            style: theme.textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.w800,
                            )),
                        const Spacer(),
                        TextButton(
                          onPressed: () => Navigator.of(context).maybePop(),
                          child: const Text('Skip', style: TextStyle(fontSize: 13)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(99),
                          child: LinearProgressIndicator(
                            value: progress,
                            minHeight: 10,
                            backgroundColor: isDark ? Palette.inkSurface2 : Colors.grey.shade200,
                          ),
                        ),
                        // Star marker along progress
                        Positioned(
                          left: progress * MediaQuery.of(context).size.width - 16,
                          top: -2,
                          child: const Text('⭐', style: TextStyle(fontSize: 14)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text('Step ${_step + 1} of $_total',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.hintColor,
                          )),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              // ── Pages ──
              Expanded(
                child: PageView(
                  controller: _page,
                  onPageChanged: (i) => setState(() => _step = i),
                  children: [
                    _stepTargetUnis(),
                    _stepSubjects(),
                    _stepGrades(),
                    _stepActivities(),
                    _stepCompetitions(),
                    _stepSchoolSchedule(),
                    _stepEnergySleep(),
                    _stepTimelineGoals(),
                    _stepEnvironment(),
                    _stepReview(),
                  ],
                ),
              ),
              // ── Bottom button ──
              Padding(
                padding: const EdgeInsets.all(16),
                child: SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    onPressed: _next,
                    icon: Icon(_step < _total - 1 ? Icons.arrow_forward : Icons.rocket_launch),
                    label: Text(_step < _total - 1 ? 'Next' : 'Launch My Forge!'),
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ──────────────────────────────────────────────────────────────────────────
  // STEP HELPERS
  // ──────────────────────────────────────────────────────────────────────────

  Widget _stepShell(String emoji, String title, String subtitle, Widget child) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.all(20),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(emoji, style: const TextStyle(fontSize: 48)),
            const SizedBox(height: 12),
            Text(title, style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800)),
            const SizedBox(height: 6),
            Text(subtitle,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.hintColor,
                )),
            const SizedBox(height: 20),
            child,
          ],
        ).animate().fadeIn(duration: 300.ms).slideY(begin: 0.05),
      ),
    );
  }

  Widget _stepTargetUnis() => _stepShell(
        '🎓', 'Target Universities', 'Which schools are you aiming for?',
        Wrap(
          spacing: 8, runSpacing: 8,
          children: _uniSuggestions.map((u) => FilterChip(
                label: Text(u, style: const TextStyle(fontSize: 13)),
                selected: _targets.contains(u),
                selectedColor: Palette.green,
                checkmarkColor: Colors.white,
                onSelected: (s) => setState(() => s ? _targets.add(u) : _targets.remove(u)),
              )).toList(),
        ),
      );

  Widget _stepSubjects() => _stepShell(
        '📚', 'Your Subjects', 'Comma separated, e.g. Math, Physics, CS',
        TextField(
          controller: _subjectsCtrl,
          style: const TextStyle(fontSize: 15),
          decoration: InputDecoration(
            hintText: _subjectSuggestions.take(3).join(', '),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
            filled: true,
          ),
        ),
      );

  Widget _stepGrades() => _stepShell(
        '📊', 'Class / Board Percentages', 'Format: Subject:Grade, one per line',
        TextField(
          controller: _gradesCtrl,
          maxLines: 4,
          style: const TextStyle(fontSize: 15),
          decoration: InputDecoration(
            hintText: 'Math:92\nPhysics:88\nCS:95',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
            filled: true,
          ),
        ),
      );

  Widget _stepActivities() => _stepShell(
        '🏅', 'Activities You\'ve Done', 'One per line — clubs, volunteering, projects',
        TextField(
          controller: _activitiesCtrl,
          maxLines: 6,
          style: const TextStyle(fontSize: 15),
          decoration: InputDecoration(
            hintText: 'Debated at school\nBuilt a weather app\nVolunteered at animal shelter',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
            filled: true,
          ),
        ),
      );

  Widget _stepCompetitions() => _stepShell(
        '🏆', 'Competitions / Olympiads / Medals', 'Add each competition with your result',
        Column(
          children: [
            ..._competitions.map((c) => Chip(
                  label: Text(c.label, style: const TextStyle(fontSize: 12)),
                  deleteIcon: const Icon(Icons.close, size: 16),
                  onDeleted: () => setState(() => _competitions.remove(c)),
                )),
            const SizedBox(height: 8),
            TextField(
              controller: _compNameCtrl,
              style: const TextStyle(fontSize: 15),
              decoration: InputDecoration(
                hintText: 'Name (e.g. Math Olympiad)',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                filled: true,
              ),
            ),
            const SizedBox(height: 8),
            Row(children: [
              Expanded(
                child: TextField(
                  controller: _compResultCtrl,
                  style: const TextStyle(fontSize: 15),
                  decoration: InputDecoration(
                    hintText: 'Result (Gold / Finalist)',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                    filled: true,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              SizedBox(
                width: 90,
                child: TextField(
                  controller: _compYearCtrl,
                  keyboardType: TextInputType.number,
                  style: const TextStyle(fontSize: 15),
                  decoration: InputDecoration(
                    hintText: 'Year',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                    filled: true,
                  ),
                ),
              ),
            ]),
            const SizedBox(height: 10),
            Align(
              alignment: Alignment.centerLeft,
              child: OutlinedButton.icon(
                onPressed: () {
                  if (_compNameCtrl.text.trim().isEmpty) return;
                  setState(() => _competitions.add(Achievement(
                        name: _compNameCtrl.text.trim(),
                        result: _compResultCtrl.text.trim().isEmpty
                            ? 'Participated'
                            : _compResultCtrl.text.trim(),
                        year: _compYearCtrl.text.trim(),
                      )));
                  _compNameCtrl.clear();
                  _compResultCtrl.clear();
                  _compYearCtrl.clear();
                },
                icon: const Icon(Icons.add),
                label: const Text('Add'),
              ),
            ),
          ],
        ),
      );

  // ── STEP 6: School Schedule ──
  Widget _stepSchoolSchedule() => _stepShell(
        '🏫', 'Your School Schedule', 'Which days do you go to school, and when?',
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('School days:', style: TextStyle(fontWeight: FontWeight.w700)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 6, runSpacing: 6,
              children: List.generate(7, (i) {
                final day = i + 1;
                final selected = _schoolDays.contains(day);
                return FilterChip(
                  label: Text(_weekdayLabels[i], style: const TextStyle(fontSize: 12)),
                  selected: selected,
                  selectedColor: Palette.green,
                  onSelected: (s) => setState(() => s ? _schoolDays.add(day) : _schoolDays.remove(day)),
                );
              }),
            ),
            const SizedBox(height: 20),
            const Text('School hours:', style: TextStyle(fontWeight: FontWeight.w700)),
            const SizedBox(height: 8),
            Row(children: [
              const Text('From '),
              _TimePicker(
                label: 'Start',
                hour: _schoolStartHour,
                minute: _schoolStartMin,
                onChanged: (h, m) => setState(() { _schoolStartHour = h; _schoolStartMin = m; }),
              ),
              const SizedBox(width: 12),
              const Text('To '),
              _TimePicker(
                label: 'End',
                hour: _schoolEndHour,
                minute: _schoolEndMin,
                onChanged: (h, m) => setState(() { _schoolEndHour = h; _schoolEndMin = m; }),
              ),
            ]),
            const SizedBox(height: 16),
            // Weekly availability slider
            const Text('Weekly free hours (outside school):',
                style: TextStyle(fontWeight: FontWeight.w700)),
            Row(children: [
              Expanded(
                child: Slider(
                  value: _availability.toDouble(),
                  min: 0, max: 40, divisions: 40,
                  label: '$_availability h',
                  onChanged: (v) => setState(() => _availability = v.round()),
                ),
              ),
              Text('$_availability h', style: const TextStyle(fontWeight: FontWeight.w700)),
            ]),
          ],
        ),
      );

  // ── STEP 7: Energy & Sleep ──
  Widget _stepEnergySleep() => _stepShell(
        '😴', 'Your Energy & Sleep', 'When do you focus best? Tell us about your rhythm.',
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Energy peak:', style: TextStyle(fontWeight: FontWeight.w700)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: [
                _energyChip('🌅', 'Morning', 'morning'),
                _energyChip('☀️', 'Afternoon', 'afternoon'),
                _energyChip('🌙', 'Night', 'night'),
              ],
            ),
            const SizedBox(height: 20),
            const Text('Sleep schedule:', style: TextStyle(fontWeight: FontWeight.w700)),
            const SizedBox(height: 8),
            Row(children: [
              const Text('Sleep at '),
              _TimePicker(
                label: 'Sleep',
                hour: _sleepH, minute: _sleepM,
                onChanged: (h, m) => setState(() { _sleepH = h; _sleepM = m; }),
              ),
              const SizedBox(width: 12),
              const Text('Wake at '),
              _TimePicker(
                label: 'Wake',
                hour: _wakeH, minute: _wakeM,
                onChanged: (h, m) => setState(() { _wakeH = h; _wakeM = m; }),
              ),
            ]),
          ],
        ),
      );

  Widget _energyChip(String emoji, String label, String value) {
    final selected = _energyPeak == value;
    return GestureDetector(
      onTap: () => setState(() => _energyPeak = value),
      child: AnimatedContainer(
        duration: 200.ms,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: selected ? Palette.green.withOpacity(0.2) : null,
          borderRadius: BorderRadius.circular(14),
          border: selected ? Border.all(color: Palette.green, width: 2) : null,
        ),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          Text(emoji, style: const TextStyle(fontSize: 18)),
          const SizedBox(width: 6),
          Text(label, style: TextStyle(fontWeight: selected ? FontWeight.w700 : FontWeight.w500)),
        ]),
      ),
    );
  }

  // ── STEP 8: Timeline & Goals ──
  Widget _stepTimelineGoals() => _stepShell(
        '🎯', 'Your Timeline & Goals', 'How far ahead are you planning?',
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Time horizon:', style: TextStyle(fontWeight: FontWeight.w700)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: [
                _timelineChip('3 Months Sprint', '3months'),
                _timelineChip('6 Months', '6months'),
                _timelineChip('1 Year', '1year'),
                _timelineChip('2 Years', '2years'),
                _timelineChip('Custom', 'custom'),
              ],
            ),
            if (_timelineGoal == 'custom') ...[
              const SizedBox(height: 16),
              Row(children: [
                Text('$_timelineMonths months',
                    style: const TextStyle(fontWeight: FontWeight.w700)),
                Expanded(
                  child: Slider(
                    value: _timelineMonths.toDouble(),
                    min: 1, max: 48, divisions: 47,
                    label: '$_timelineMonths months',
                    onChanged: (v) => setState(() => _timelineMonths = v.round()),
                  ),
                ),
              ]),
            ],
            const SizedBox(height: 20),
            const Text('Career interests:', style: TextStyle(fontWeight: FontWeight.w700)),
            const SizedBox(height: 8),
            TextField(
              controller: _careersCtrl,
              style: const TextStyle(fontSize: 15),
              decoration: InputDecoration(
                hintText: _careerSugs.take(3).join(', '),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                filled: true,
              ),
            ),
          ],
        ),
      );

  Widget _timelineChip(String label, String value) {
    final selected = _timelineGoal == value;
    return GestureDetector(
      onTap: () => setState(() {
        _timelineGoal = value;
        if (value == '3months') _timelineMonths = 3;
        if (value == '6months') _timelineMonths = 6;
        if (value == '1year') _timelineMonths = 12;
        if (value == '2years') _timelineMonths = 24;
      }),
      child: AnimatedContainer(
        duration: 200.ms,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: selected ? Palette.blue.withOpacity(0.2) : null,
          borderRadius: BorderRadius.circular(14),
          border: selected ? Border.all(color: Palette.blue, width: 2) : null,
        ),
        child: Text(label,
            style: TextStyle(fontWeight: selected ? FontWeight.w700 : FontWeight.w500)),
      ),
    );
  }

  // ── STEP 9: Study Environment ──
  Widget _stepEnvironment() => _stepShell(
        '🌍', 'Your Study Environment', 'Where and how do you study best?',
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Preferred environment:',
                style: TextStyle(fontWeight: FontWeight.w700)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: [
                _envChip('📚 Library', 'library'),
                _envChip('🏠 Home', 'home'),
                _envChip('☕ Café', 'cafe'),
                _envChip('🏫 School', 'school'),
                _envChip('🔄 Mixed', 'mixed'),
              ],
            ),
            const SizedBox(height: 20),
            const Text('Daily screen time (hours):',
                style: TextStyle(fontWeight: FontWeight.w700)),
            Row(children: [
              Expanded(
                child: Slider(
                  value: _screenTimeHours.toDouble(),
                  min: 0, max: 16, divisions: 16,
                  label: '$_screenTimeHours h',
                  onChanged: (v) => setState(() => _screenTimeHours = v.round()),
                ),
              ),
              Text('$_screenTimeHours h',
                  style: const TextStyle(fontWeight: FontWeight.w700)),
            ]),
            const SizedBox(height: 16),
            const Text('Social media usage:',
                style: TextStyle(fontWeight: FontWeight.w700)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: [
                _usageChip('🌱 Light', 'light'),
                _usageChip('🌿 Moderate', 'moderate'),
                _usageChip('🌋 Heavy', 'heavy'),
              ],
            ),
          ],
        ),
      );

  Widget _envChip(String label, String value) {
    final selected = _studyEnvironment == value;
    return GestureDetector(
      onTap: () => setState(() => _studyEnvironment = value),
      child: AnimatedContainer(
        duration: 200.ms,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: selected ? Palette.orange.withOpacity(0.2) : null,
          borderRadius: BorderRadius.circular(14),
          border: selected ? Border.all(color: Palette.orange, width: 2) : null,
        ),
        child: Text(label,
            style: TextStyle(fontWeight: selected ? FontWeight.w700 : FontWeight.w500)),
      ),
    );
  }

  Widget _usageChip(String label, String value) {
    final selected = _socialMediaUsage == value;
    return GestureDetector(
      onTap: () => setState(() => _socialMediaUsage = value),
      child: AnimatedContainer(
        duration: 200.ms,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: selected ? Palette.purple.withOpacity(0.2) : null,
          borderRadius: BorderRadius.circular(14),
          border: selected ? Border.all(color: Palette.purple, width: 2) : null,
        ),
        child: Text(label,
            style: TextStyle(fontWeight: selected ? FontWeight.w700 : FontWeight.w500)),
      ),
    );
  }

  // ── STEP 10: Review ──
  Widget _stepReview() {
    final theme = Theme.of(context);
    final s = _buildSchedule();
    final p = _buildProfile();
    return _stepShell(
      '🚀', 'Ready to Launch!', 'Here\'s your profile summary — review and launch.',
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _reviewTile('🎓', 'Target Universities', p.targetUniversities.join(', ')),
          _reviewTile('📚', 'Subjects', p.subjects.join(', ')),
          _reviewTile('📊', 'Grades', _gradesCtrl.text.isNotEmpty ? _gradesCtrl.text : '—'),
          _reviewTile('⏱️', 'Availability', '${_availability} h/week'),
          _reviewTile('🏫', 'School Days',
              _schoolDays.map((d) => _weekdayLabels[d - 1]).join(', ')),
          _reviewTile('🌅', 'Energy Peak', _energyPeak),
          _reviewTile('😴', 'Sleep', '${s.sleepStart} → ${s.sleepEnd}'),
          _reviewTile('🎯', 'Timeline', _timelineGoal == 'custom'
              ? '$_timelineMonths months'
              : _timelineGoal),
          _reviewTile('🌍', 'Environment', _studyEnvironment),
          _reviewTile('🌋', 'Social Media', _socialMediaUsage),
        ],
      ),
    );
  }

  Widget _reviewTile(String emoji, String label, String value) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Text('$emoji  ', style: const TextStyle(fontSize: 16)),
          SizedBox(
            width: 130,
            child: Text(label, style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 13,
              color: theme.hintColor,
            )),
          ),
          Expanded(
            child: Text(value, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
          ),
        ],
      ),
    );
  }
}

/// ────────────────────────────────────────────────────────────────────────────
/// Time picker inline widget — quick hour / minute selection via dropdowns.
/// ────────────────────────────────────────────────────────────────────────────
class _TimePicker extends StatelessWidget {
  final String label;
  final int hour;
  final int minute;
  final void Function(int hour, int minute) onChanged;

  const _TimePicker({
    required this.label,
    required this.hour,
    required this.minute,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Hour dropdown
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: theme.cardColor,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: theme.dividerColor.withOpacity(0.3)),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<int>(
              value: hour.clamp(0, 23),
              items: List.generate(24, (i) => DropdownMenuItem(
                value: i,
                child: Text(i.toString().padLeft(2, '0'), style: const TextStyle(fontSize: 14)),
              )),
              onChanged: (v) => v != null ? onChanged(v, minute) : null,
              isDense: true,
            ),
          ),
        ),
        const Text(' : ', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
        // Minute dropdown
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: theme.cardColor,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: theme.dividerColor.withOpacity(0.3)),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<int>(
              value: [0, 15, 30, 45].contains(minute) ? minute : 0,
              items: [0, 15, 30, 45].map((m) => DropdownMenuItem(
                value: m,
                child: Text(m.toString().padLeft(2, '0'), style: const TextStyle(fontSize: 14)),
              )).toList(),
              onChanged: (v) => v != null ? onChanged(hour, v) : null,
              isDense: true,
            ),
          ),
        ),
      ],
    );
  }
}
