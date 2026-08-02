import 'package:profileforge/features/onboarding/domain/onboarding_models.dart';

/// Detects the user's primary persona from their profile data.
/// Personas determine what TYPE of tasks to recommend.
enum UserPersona {
  maker,        // builds things — apps, robots, hardware, code
  researcher,   // academic curiosity — papers, experiments, analysis
  socialWorker, // community impact — tutoring, mentoring, organizing
  creative,     // expression — writing, art, film, music, design
  leader,       // organizational — student government, clubs, teams
  advocate,     // policy & activism — campaigns, awareness, organizing
  entrepreneur, // business + social — nonprofits, startups, ventures
  generalist,   // no clear spike yet — exploration phase
}

/// Detects persona from onboarding profile.
/// Looks at activities, subjects, career interests, and competitions.
UserPersona detectPersona(OnboardingProfile profile) {
  final scores = <UserPersona, int>{};
  for (final p in UserPersona.values) {
    scores[p] = 0;
  }

  // Analyze activities.
  for (final activity in profile.activities) {
    final lower = activity.toLowerCase();
    if (_makerKeywords.any((k) => lower.contains(k))) {
      scores[UserPersona.maker] = (scores[UserPersona.maker] ?? 0) + 3;
    }
    if (_researcherKeywords.any((k) => lower.contains(k))) {
      scores[UserPersona.researcher] = (scores[UserPersona.researcher] ?? 0) + 3;
    }
    if (_socialKeywords.any((k) => lower.contains(k))) {
      scores[UserPersona.socialWorker] = (scores[UserPersona.socialWorker] ?? 0) + 3;
    }
    if (_creativeKeywords.any((k) => lower.contains(k))) {
      scores[UserPersona.creative] = (scores[UserPersona.creative] ?? 0) + 3;
    }
    if (_leaderKeywords.any((k) => lower.contains(k))) {
      scores[UserPersona.leader] = (scores[UserPersona.leader] ?? 0) + 3;
    }
    if (_advocateKeywords.any((k) => lower.contains(k))) {
      scores[UserPersona.advocate] = (scores[UserPersona.advocate] ?? 0) + 3;
    }
    if (_entrepreneurKeywords.any((k) => lower.contains(k))) {
      scores[UserPersona.entrepreneur] = (scores[UserPersona.entrepreneur] ?? 0) + 3;
    }
  }

  // Analyze subjects.
  for (final subject in profile.subjects) {
    final lower = subject.toLowerCase();
    if (_makerSubjects.any((k) => lower.contains(k))) {
      scores[UserPersona.maker] = (scores[UserPersona.maker] ?? 0) + 2;
    }
    if (_researcherSubjects.any((k) => lower.contains(k))) {
      scores[UserPersona.researcher] = (scores[UserPersona.researcher] ?? 0) + 2;
    }
  }

  // Analyze career interests.
  for (final interest in profile.careerInterests) {
    final lower = interest.toLowerCase();
    if (_makerKeywords.any((k) => lower.contains(k))) {
      scores[UserPersona.maker] = (scores[UserPersona.maker] ?? 0) + 2;
    }
    if (_socialKeywords.any((k) => lower.contains(k))) {
      scores[UserPersona.socialWorker] = (scores[UserPersona.socialWorker] ?? 0) + 2;
    }
    if (_creativeKeywords.any((k) => lower.contains(k))) {
      scores[UserPersona.creative] = (scores[UserPersona.creative] ?? 0) + 2;
    }
    if (_entrepreneurKeywords.any((k) => lower.contains(k))) {
      scores[UserPersona.entrepreneur] = (scores[UserPersona.entrepreneur] ?? 0) + 2;
    }
  }

  // Find top persona.
  var best = UserPersona.generalist;
  var bestScore = 0;
  for (final entry in scores.entries) {
    if (entry.value > bestScore) {
      bestScore = entry.value;
      best = entry.key;
    }
  }

  return best;
}

/// Returns a human-readable label for the persona.
String personaLabel(UserPersona persona) {
  switch (persona) {
    case UserPersona.maker:
      return 'Maker';
    case UserPersona.researcher:
      return 'Researcher';
    case UserPersona.socialWorker:
      return 'Social Worker';
    case UserPersona.creative:
      return 'Creative';
    case UserPersona.leader:
      return 'Leader';
    case UserPersona.advocate:
      return 'Advocate';
    case UserPersona.entrepreneur:
      return 'Entrepreneur';
    case UserPersona.generalist:
      return 'Explorer';
  }
}

/// Returns a description of what this persona does.
String personaDescription(UserPersona persona) {
  switch (persona) {
    case UserPersona.maker:
      return 'You build things — apps, robots, hardware, code. You learn by making.';
    case UserPersona.researcher:
      return 'You dive deep into questions — experiments, papers, analysis. You learn by investigating.';
    case UserPersona.socialWorker:
      return 'You lift others up — tutoring, mentoring, community organizing. You learn by serving.';
    case UserPersona.creative:
      return 'You express ideas — writing, art, film, music, design. You learn by creating.';
    case UserPersona.leader:
      return 'You bring people together — student government, clubs, teams. You learn by leading.';
    case UserPersona.advocate:
      return 'You fight for change — campaigns, awareness, policy work. You learn by advocating.';
    case UserPersona.entrepreneur:
      return 'You build ventures — nonprofits, startups, social enterprises. You learn by building.';
    case UserPersona.generalist:
      return 'You\'re exploring — trying different things to find your passion. You learn by experimenting.';
  }
}

// Keyword lists for persona detection.

const _makerKeywords = [
  'code', 'coding', 'app', 'robot', 'programming', 'software', 'hardware',
  'maker', 'build', 'engineering', 'arduino', 'raspberry', '3d print',
  'hackathon', 'web', 'website', 'prototype', 'invent',
];

const _researcherKeywords = [
  'research', 'science', 'experiment', 'journal', 'paper', 'publication',
  'lab', 'analysis', 'data', 'study', 'investigate', 'academic',
];

const _socialKeywords = [
  'volunteer', 'tutor', 'mentor', 'community', 'service', 'teach',
  'help', 'charity', 'nonprofit', 'outreach', 'social work', 'counsel',
];

const _creativeKeywords = [
  'write', 'writing', 'art', 'paint', 'draw', 'music', 'film', 'photo',
  'design', 'creative', 'story', 'poetry', 'dance', 'theater', 'media',
];

const _leaderKeywords = [
  'president', 'captain', 'leader', 'head', 'chair', 'organize',
  'manage', 'direct', 'coordinator', 'student government', 'debate',
];

const _advocateKeywords = [
  'advocate', 'activism', 'campaign', 'policy', 'rights', 'awareness',
  'protest', 'rally', 'social justice', 'equality', 'reform',
];

const _entrepreneurKeywords = [
  'startup', 'business', 'entrepreneur', 'venture', 'founder',
  'enterprise', 'innovation', 'fundraise', 'pitch', 'invest',
];

const _makerSubjects = [
  'computer science', 'physics', 'engineering', 'math', 'technology',
  'robotics', 'electronics', 'mechanics',
];

const _researcherSubjects = [
  'biology', 'chemistry', 'physics', 'research', 'science', 'math',
  'psychology', 'economics', 'statistics',
];
