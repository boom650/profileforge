import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:profileforge/features/onboarding/application/onboarding_providers.dart';
import 'package:profileforge/features/onboarding/domain/onboarding_models.dart';

const _unis = [
  'MIT',
  'Stanford',
  'Oxford',
  'Cambridge',
  'Harvard',
  'Yale',
  'Princeton',
  'NUS',
  'ETH Zurich',
];

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key, required this.profileId});
  final String profileId;

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final _page = PageController();
  int _step = 0;
  final _targets = <String>[];
  final _subjects = <String>[];
  int _budget = 0;
  int _radius = 10;
  int _availability = 5;

  OnboardingProfile _build() => OnboardingProfile(
        profileId: widget.profileId,
        targetUniversities: _targets,
        subjects: _subjects,
        grades: const {},
        clubs: const [],
        budget: _budget,
        travelRadiusKm: _radius,
        availabilityHoursPerWeek: _availability,
        careerInterests: const [],
        location: '',
      );

  @override
  Widget build(BuildContext context) {
    final score = _build().readinessScore;
    return Scaffold(
      appBar: AppBar(title: const Text('Set up ProfileForge')),
      body: Column(
        children: [
          LinearProgressIndicator(value: (_step + 1) / 3),
          Expanded(
            child: PageView(
              controller: _page,
              onPageChanged: (i) => setState(() => _step = i),
              children: [
                _Step(
                  title: 'Target universities',
                  child: Wrap(
                    spacing: 8,
                    children: _unis
                        .map((u) => FilterChip(
                              label: Text(u),
                              selected: _targets.contains(u),
                              onSelected: (s) => setState(() => s
                                  ? _targets.add(u)
                                  : _targets.remove(u)),
                            ))
                        .toList(),
                  ),
                ),
                _Step(
                  title: 'Weekly availability & budget',
                  child: Column(
                    children: [
                      Slider(
                        value: _availability.toDouble(),
                        min: 0,
                        max: 40,
                        divisions: 40,
                        label: '$_availability h/week',
                        onChanged: (v) => setState(() => _availability = v.round()),
                      ),
                      Slider(
                        value: _radius.toDouble(),
                        min: 1,
                        max: 100,
                        divisions: 99,
                        label: '$_radius km',
                        onChanged: (v) => setState(() => _radius = v.round()),
                      ),
                      Slider(
                        value: _budget.toDouble(),
                        min: 0,
                        max: 10000,
                        divisions: 100,
                        label: '\$$_budget',
                        onChanged: (v) => setState(() => _budget = v.round()),
                      ),
                    ],
                  ),
                ),
                _Step(
                  title: 'Subjects',
                  child: TextField(
                    onChanged: (v) => _subjects
                      ..clear()
                      ..addAll(v.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty)),
                    decoration: const InputDecoration(
                      hintText: 'Math, Physics, CS (comma separated)',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Semantics(
                  label: 'Readiness score $score out of 100',
                  child: Text('Readiness: $score/100',
                      style: Theme.of(context).textTheme.titleMedium),
                ),
                const SizedBox(height: 8),
                FilledButton(
                  onPressed: () {
                    if (_step < 2) {
                      _page.nextPage(
                          duration: 300.ms, curve: Curves.easeInOut);
                    } else {
                      ref.read(saveOnboardingProvider(_build()));
                      // In production, navigate to home. TODO: router push.
                      Navigator.of(context).pop();
                    }
                  },
                  child: Text(_step < 2 ? 'Next' : 'Finish'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Step extends StatelessWidget {
  const _Step({required this.title, required this.child});
  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 16),
            child,
          ],
        ).animate().fadeIn().slideY(begin: 0.05),
      );
}
