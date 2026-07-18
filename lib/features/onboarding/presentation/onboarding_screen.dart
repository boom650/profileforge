import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:profileforge/core/audio/sound_service.dart';
import 'package:profileforge/core/celebration/celebrate.dart';
import 'package:profileforge/core/theme/app_theme.dart';
import 'package:profileforge/features/onboarding/application/onboarding_providers.dart';
import 'package:profileforge/features/onboarding/domain/onboarding_models.dart';

/// Rich, CV-style onboarding. Asks specific questions (grades %, activities,
/// competitions/Olympiads/medals) so the app can personalize missions.
class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key, required this.profileId});
  final String profileId;

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final _page = PageController();
  int _step = 0;
  final int _total = 6;

  // State collected across steps.
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

  final _subjectSuggestions = [
    'Math',
    'Physics',
    'Chemistry',
    'Biology',
    'Computer Science',
    'Economics',
    'History',
    'English',
    'Geography',
  ];
  final _unis = [
    'MIT',
    'Stanford',
    'Oxford',
    'Cambridge',
    'Harvard',
    'Yale',
    'Princeton',
    'NUS',
    'ETH Zürich',
    'Imperial College',
  ];
  final _careerSugs = [
    'Engineering',
    'Medicine',
    'Computer Science',
    'Business',
    'Law',
    'Research',
    'Design',
    'Physics',
  ];

  void _next() {
    SoundService.instance.tap();
    if (_step < _total - 1) {
      _page.nextPage(duration: 300.ms, curve: Curves.easeInOut);
    } else {
      _finish();
    }
  }

  OnboardingProfile _build() => OnboardingProfile(
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

  void _finish() {
    // Parse grades "Math:92, Physics:88".
    for (final part in _gradesCtrl.text.split(',')) {
      final kv = part.split(RegExp(r'[:\-]'));
      if (kv.length == 2) {
        _grades[kv[0].trim()] = kv[1].trim();
      }
    }
    for (final a in _activitiesCtrl.text.split('\n')) {
      final t = a.trim();
      if (t.isNotEmpty) _activities.add(t);
    }
    final p = _build();
    ref.read(saveOnboardingProvider(p));
    SoundService.instance.success();
    if (mounted) {
      celebrate(context, message: 'Profile ready! 🎉');
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
    final progress = (_step + 1) / _total;
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              child: Column(
                children: [
                  Row(
                    children: [
                      Text('Your journey',
                          style: theme.textTheme.headlineSmall),
                      const Spacer(),
                      TextButton(
                        onPressed: () => Navigator.of(context).maybePop(),
                        child: const Text('Skip'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(99),
                    child: LinearProgressIndicator(
                        value: progress, minHeight: 10),
                  ),
                  const SizedBox(height: 4),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text('Step ${_step + 1} of $_total',
                        style: theme.textTheme.bodySmall),
                  ),
                ],
              ),
            ),
            Expanded(
              child: PageView(
                controller: _page,
                onPageChanged: (i) => setState(() => _step = i),
                children: [
                  _Step(
                    emoji: '🎓',
                    title: 'Target universities',
                    subtitle: 'Which schools are you aiming for?',
                    child: Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _unis
                          .map((u) => FilterChip(
                                label: Text(u),
                                selected: _targets.contains(u),
                                selectedColor: Palette.green,
                                checkmarkColor: Colors.white,
                                onSelected: (s) =>
                                    setState(() => s ? _targets.add(u) : _targets.remove(u)),
                              ))
                          .toList(),
                    ),
                  ),
                  _Step(
                    emoji: '📚',
                    title: 'Your subjects',
                    subtitle: 'Comma separated, e.g. Math, Physics, CS',
                    child: TextField(
                      controller: _subjectsCtrl,
                      decoration: InputDecoration(
                        hintText: _subjectSuggestions.take(3).join(', '),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16)),
                        filled: true,
                      ),
                    ),
                  ),
                  _Step(
                    emoji: '📊',
                    title: 'Class / board percentages',
                    subtitle: 'e.g. Math:92, Physics:88, CS:95',
                    child: TextField(
                      controller: _gradesCtrl,
                      maxLines: 4,
                      decoration: InputDecoration(
                        hintText: 'Math:92\nPhysics:88\nCS:95',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16)),
                        filled: true,
                      ),
                    ),
                  ),
                  _Step(
                    emoji: '🏅',
                    title: 'Activities you\'ve done',
                    subtitle: 'One per line — clubs, volunteering, projects',
                    child: TextField(
                      controller: _activitiesCtrl,
                      maxLines: 6,
                      decoration: InputDecoration(
                        hintText: ' debated at school\n'
                            'built a weather app\n'
                            'volunteered at animal shelter',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16)),
                        filled: true,
                      ),
                    ),
                  ),
                  _Step(
                    emoji: '🏆',
                    title: 'Competitions / Olympiads / medals',
                    subtitle: 'Add each with your result',
                    child: Column(
                      children: [
                        ..._competitions
                            .map((c) => Chip(
                                  label: Text(c.label),
                                  deleteIcon: const Icon(Icons.close, size: 16),
                                  onDeleted: () =>
                                      setState(() => _competitions.remove(c)),
                                ))
                            .toList(),
                        const SizedBox(height: 8),
                        TextField(
                          controller: _compNameCtrl,
                          decoration: InputDecoration(
                            hintText: 'Name (e.g. Math Olympiad)',
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(14)),
                            filled: true,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: _compResultCtrl,
                                decoration: InputDecoration(
                                  hintText: 'Result (Gold / Finalist)',
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(14)),
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
                                decoration: InputDecoration(
                                  hintText: 'Year',
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(14)),
                                  filled: true,
                                ),
                              ),
                            ),
                          ],
                        ),
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
                  ),
                  _Step(
                    emoji: '⏱️',
                    title: 'Weekly availability & interests',
                    subtitle:
                        'How many hours/week can you dedicate? Plus career interests.',
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('$_availability h / week',
                            style: theme.textTheme.titleMedium),
                        Slider(
                          value: _availability.toDouble(),
                          min: 0,
                          max: 40,
                          divisions: 40,
                          label: '$_availability h/week',
                          onChanged: (v) =>
                              setState(() => _availability = v.round()),
                        ),
                        const SizedBox(height: 12),
                        TextField(
                          controller: _careersCtrl,
                          decoration: InputDecoration(
                            hintText: _careerSugs.take(3).join(', '),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16)),
                            filled: true,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: _next,
                  child: Text(_step < _total - 1 ? 'Next' : 'Finish & generate plan'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Step extends StatelessWidget {
  const _Step({
    required this.emoji,
    required this.title,
    required this.subtitle,
    required this.child,
  });
  final String emoji;
  final String title;
  final String subtitle;
  final Widget child;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(emoji, style: const TextStyle(fontSize: 44)),
            const SizedBox(height: 12),
            Text(title, style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 6),
            Text(subtitle,
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(color: Theme.of(context).hintColor)),
            const SizedBox(height: 20),
            child,
          ],
        ).animate().fadeIn(duration: 300.ms).slideY(begin: 0.05),
      );
}
