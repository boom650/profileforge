import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:profileforge/core/scoring/profile_scoring.dart';
import 'package:profileforge/features/onboarding/application/onboarding_providers.dart';
import 'package:profileforge/features/onboarding/domain/onboarding_models.dart';

/// ────────────────────────────────────────────────────────────────────────────
/// Shared real-score loader — the SINGLE source of truth for computing a
/// ProfileScore from real persisted data (onboarding + psychology).
///
/// ProfileScoreScreen and ScoreBreakdownScreen both use this, so every
/// screen shows the SAME numbers (no per-screen fake variants).
/// Returns isDemo=true only when there is genuinely no user data yet.
/// ────────────────────────────────────────────────────────────────────────────
class LoadedScore {
  final ProfileScore score;
  final bool isDemo;
  const LoadedScore({required this.score, required this.isDemo});
}

Future<LoadedScore> loadProfileScore(
  WidgetRef ref,
  String? profileId,
) async {
  if (profileId == null) {
    return LoadedScore(
      score: ProfileScoring.calculate(
        student: demoStudentData(),
        psychology: null,
      ),
      isDemo: true,
    );
  }

  final onboarding =
      ref.read(onboardingProvider(profileId)).valueOrNull;
  final psych =
      ref.read(psychologicalProfileProvider(profileId)).valueOrNull;

  final hasRealGrades = onboarding != null && onboarding.grades.isNotEmpty;
  final student = hasRealGrades
      ? studentFromOnboarding(onboarding)
      : demoStudentData();

  return LoadedScore(
    score: ProfileScoring.calculate(
      student: student,
      psychology: psych,
    ),
    isDemo: !hasRealGrades,
  );
}

/// Map a real onboarding profile into the scorer's StudentData model.
/// (Same mapping the profile score screen uses — kept in sync here.)
StudentData studentFromOnboarding(OnboardingProfile o) {
  final gpa = gpaFromGrades(o.grades);

  final activities = [
    ...o.activities.map((a) => Activity(
          name: a,
          category: categoryFor(a),
          isLeadership: a.toLowerCase().contains('president') ||
              a.toLowerCase().contains('captain') ||
              a.toLowerCase().contains('lead'),
          hasImpact: true,
        )),
    ...o.competitions.map((c) => Activity(
          name: c.name,
          category: categoryFor(c.name),
          hasImpact: true,
          isNationallyRecognized: isNational(c.result),
        )),
  ];

  return StudentData(
    gpa: gpa,
    isWeighted: false,
    gpaTrend: GPATrend.stable,
    satScore: null,
    actScore: null,
    activities: activities,
    essays: const [],
  );
}

double? gpaFromGrades(Map<String, String> grades) {
  if (grades.isEmpty) return null;
  final numeric = <double>[];
  for (final raw in grades.values) {
    final v = raw.trim().toUpperCase();
    final parsed = double.tryParse(v);
    if (parsed != null && parsed >= 0 && parsed <= 100) {
      numeric.add(parsed / 25); // percent → 4.0 scale
    } else if (_letterPoints.containsKey(v)) {
      numeric.add(_letterPoints[v]!);
    }
  }
  if (numeric.isEmpty) return null;
  return numeric.reduce((a, b) => a + b) / numeric.length;
}

const Map<String, double> _letterPoints = {
  'A+': 4.3,
  'A': 4.0,
  'A-': 3.7,
  'B+': 3.3,
  'B': 3.0,
  'B-': 2.7,
  'C+': 2.3,
  'C': 2.0,
  'C-': 1.7,
  'D+': 1.3,
  'D': 1.0,
  'F': 0.0,
};

/// Best-effort scorer category classification from a free-form name.
String categoryFor(String name) {
  final n = name.toLowerCase();
  if (n.contains('math') ||
      n.contains('science') ||
      n.contains('research') ||
      n.contains('coding') ||
      n.contains('robotic') ||
      n.contains('olympiad')) {
    return 'STEM';
  }
  if (n.contains('debate') ||
      n.contains('speech') ||
      n.contains('writing') ||
      n.contains('english') ||
      n.contains('journal')) {
    return 'Communication';
  }
  if (n.contains('volunteer') ||
      n.contains('service') ||
      n.contains('outreach') ||
      n.contains('ngo') ||
      n.contains('clean')) {
    return 'Community';
  }
  if (n.contains('art') ||
      n.contains('music') ||
      n.contains('theatre') ||
      n.contains('dance') ||
      n.contains('photograph')) {
    return 'Creative';
  }
  if (n.contains('sport') ||
      n.contains('football') ||
      n.contains('cricket') ||
      n.contains('basketball') ||
      n.contains('swim')) {
    return 'Athletics';
  }
  return 'Academic';
}

bool isNational(String? result) {
  final r = (result ?? '').toLowerCase();
  return r.contains('national') ||
      r.contains('international') ||
      r.contains('state') ||
      r.contains('regional') ||
      r.contains('gold') ||
      r.contains('1st') ||
      r.contains('winner');
}

/// Demo fallback — ONLY used when there is genuinely no user data yet.
/// Screens must badge it clearly (PREVIEW), never present it as the
/// student's real score.
StudentData demoStudentData() {
  return const StudentData(
    gpa: 3.8,
    isWeighted: false,
    gpaTrend: GPATrend.upward,
    satScore: 1480,
    actScore: 33,
    activities: [
      Activity(
        name: 'Student Council President',
        category: 'Leadership',
        isLeadership: true,
        hasImpact: true,
      ),
      Activity(
        name: 'Robotics Team Captain',
        category: 'STEM',
        isLeadership: true,
        hasImpact: true,
        isNationallyRecognized: true,
      ),
      Activity(
        name: 'Volunteer Tutor',
        category: 'Community',
        hasImpact: true,
      ),
    ],
    essays: [
      Essay(
        title: 'Overcoming adversity',
        wordCount: 550,
        hasPersonalVoice: true,
      ),
    ],
  );
}
