/// Essay / Narrative Coaching Service
///
/// Provides Common App prompt references, essay structure analysis,
/// personalized story suggestions, and a pitfalls checklist.
library;

import '../models/student_profile.dart';

// ═══════════════════════════════════════════════════════════════════════
// Common App Prompts (2024–2025)
// ═══════════════════════════════════════════════════════════════════════

class EssayPrompt {
  final int number;
  final String text;
  final String shortLabel;

  const EssayPrompt({
    required this.number,
    required this.text,
    required this.shortLabel,
  });
}

class EssayPrompts {
  EssayPrompts._();

  static const List<EssayPrompt> commonApp2024_2025 = [
    EssayPrompt(
      number: 1,
      text:
          'Some students have a background, identity, interest, or talent that is '
          'so meaningful they believe their application would be incomplete without '
          'it. If this sounds like you, then please share your story.',
      shortLabel: 'Background / Identity / Talent',
    ),
    EssayPrompt(
      number: 2,
      text:
          'The lessons we take from obstacles we encounter can be fundamental to '
          'later success. Recount a time when you faced a challenge, setback, or '
          'failure. How did it affect you, and what did you learn from the experience?',
      shortLabel: 'Challenge / Setback / Failure',
    ),
    EssayPrompt(
      number: 3,
      text:
          'Reflect on a time when you questioned or challenged a belief or idea. '
          'What prompted your thinking? What was the outcome?',
      shortLabel: 'Questioned / Challenged Belief',
    ),
    EssayPrompt(
      number: 4,
      text:
          'Reflect on something that someone has done for you that has made you '
          'happy or thankful in a surprising way. How has this gratitude affected '
          'or motivated you?',
      shortLabel: 'Gratitude / Thankfulness',
    ),
    EssayPrompt(
      number: 5,
      text:
          'Discuss an accomplishment, event, or realization that sparked a period '
          'of personal growth and a new understanding of yourself or others.',
      shortLabel: 'Growth / New Understanding',
    ),
    EssayPrompt(
      number: 6,
      text:
          'Describe a topic, idea, or concept you find so engaging that it makes '
          'you lose all track of time. Why does it captivate you? What or who do '
          'you turn to when you want to learn more?',
      shortLabel: 'Engaging Idea / Concept',
    ),
    EssayPrompt(
      number: 7,
      text:
          'Share an essay on any topic of your choice. It can be one you\'ve '
          'already written, one that responds to a different prompt, or one of '
          'your own design.',
      shortLabel: 'Topic of Your Choice',
    ),
  ];

  static EssayPrompt? byNumber(int number) {
    try {
      return commonApp2024_2025.firstWhere((p) => p.number == number);
    } catch (_) {
      return null;
    }
  }
}

// ═══════════════════════════════════════════════════════════════════════
// Essay Feedback
// ═══════════════════════════════════════════════════════════════════════

class EssayFeedback {
  /// Word count of the essay.
  final int wordCount;

  /// Whether the word count is within the Common App 250–650 sweet spot.
  final bool wordCountOk;

  /// Detected narrative arc elements.
  final NarrativeArc arc;

  /// Authenticity score 0–100 (higher = less generic).
  final int authenticityScore;

  /// Specificity score 0–100 (higher = more concrete details).
  final int specificityScore;

  /// Voice consistency score 0–100.
  final int voiceConsistencyScore;

  /// Actionable suggestions.
  final List<String> suggestions;

  const EssayFeedback({
    required this.wordCount,
    required this.wordCountOk,
    required this.arc,
    required this.authenticityScore,
    required this.specificityScore,
    required this.voiceConsistencyScore,
    required this.suggestions,
  });

  /// Average of the three quality scores.
  int get overallScore =>
      ((authenticityScore + specificityScore + voiceConsistencyScore) / 3)
          .round();
}

class NarrativeArc {
  /// Whether a clear beginning / hook is detected.
  final bool hasBeginning;

  /// Whether a challenge or conflict is described.
  final bool hasChallenge;

  /// Whether growth or change is shown.
  final bool hasGrowth;

  /// Whether a reflection or insight closes the essay.
  final bool hasReflection;

  const NarrativeArc({
    required this.hasBeginning,
    required this.hasChallenge,
    required this.hasGrowth,
    required this.hasReflection,
  });

  /// How many of the four arc elements are present (0–4).
  int get completeness => [
        hasBeginning,
        hasChallenge,
        hasGrowth,
        hasReflection,
      ].where((b) => b).length;

  bool get isComplete => completeness == 4;
}

// ═══════════════════════════════════════════════════════════════════════
// Analysis Engine
// ═══════════════════════════════════════════════════════════════════════

/// Analyzes the structure and quality of an essay [text].
///
/// Returns an [EssayFeedback] with metrics and suggestions.
EssayFeedback analyzeEssayStructure(String text) {
  final words = text.trim().split(RegExp(r'\s+'));
  final wordCount = words.length;
  final wordCountOk = wordCount >= 250 && wordCount <= 650;

  final arc = _detectNarrativeArc(text);
  final authenticity = _scoreAuthenticity(text);
  final specificity = _scoreSpecificity(text);
  final voice = _scoreVoiceConsistency(text);
  final suggestions = _generateSuggestions(text, wordCountOk, arc);

  return EssayFeedback(
    wordCount: wordCount,
    wordCountOk: wordCountOk,
    arc: arc,
    authenticityScore: authenticity,
    specificityScore: specificity,
    voiceConsistencyScore: voice,
    suggestions: suggestions,
  );
}

/// Detects the presence of narrative arc elements via keyword heuristics.
NarrativeArc _detectNarrativeArc(String text) {
  final lower = text.toLowerCase();

  // Beginning / Hook — first ~20% of text
  final firstPortion =
      lower.substring(0, (lower.length * 0.2).round());
  final hasBeginning = firstPortion.contains(RegExp(
      r'(when i |i remember|it started|i was |one day|the moment|i found)'));

  // Challenge — looks for difficulty language
  final hasChallenge = lower.contains(RegExp(
      r'(challenge|struggle|fail|problem|difficult|obstacle|setback|hard times|tough|impossible|overwhelm)'));

  // Growth — looks for learning / change language
  final hasGrowth = lower.contains(RegExp(
      r'(learned|realized|grew|changed|discovered|transformed|evolved|became|shifted|developed|improved|overcame)'));

  // Reflection — last ~25% of text
  final lastPortion =
      lower.substring((lower.length * 0.75).round());
  final hasReflection = lastPortion.contains(RegExp(
      r'(looking back|i now|this taught|taught me|realize|understand|perspective|meaning|value|appreciate|grateful|today )'));

  return NarrativeArc(
    hasBeginning: hasBeginning,
    hasChallenge: hasChallenge,
    hasGrowth: hasGrowth,
    hasReflection: hasReflection,
  );
}

/// Scores authenticity 0–100 by penalizing generic phrases.
int _scoreAuthenticity(String text) {
  final lower = text.toLowerCase();
  int penalty = 0;

  final genericPhrases = [
    'since the dawn of time',
    'in today\'s society',
    'it is important to note',
    'needless to say',
    'at the end of the day',
    'throughout my life',
    'ever since i was a child',
    'i have always been passionate',
    'making a difference',
    'the sky\'s the limit',
    'think outside the box',
    'give back to society',
    'in this day and age',
    'the world is changing',
    'i want to make an impact',
    'i learned a lot',
    'it was a learning experience',
    'i\'m a hard worker',
    'i\'m passionate about',
    'i\'m dedicated',
    'i strive to',
    'i endeavor to',
  ];

  for (final phrase in genericPhrases) {
    if (lower.contains(phrase)) {
      penalty += 10;
    }
  }

  return (100 - penalty).clamp(0, 100);
}

/// Scores specificity 0–100 based on concrete indicators.
int _scoreSpecificity(String text) {
  int score = 0;
  final lower = text.toLowerCase();

  // Numbers / data points are a strong signal of specificity
  final numberPattern = RegExp(r'\d+');
  final numbers = numberPattern.allMatches(text);
  score += (numbers.length * 3).clamp(0, 15);

  // Names (capitalized words that aren't sentence-starts)
  final names = RegExp(r'(?<=[.!?]\s)[A-Z][a-z]+').allMatches(text);
  score += (names.length * 5).clamp(0, 15);

  // Specific location mentions
  final locations = lower.contains(RegExp(
      r'(at |in |on |near |from )\w+'));
  if (locations) score += 10;

  // Quoted speech (shows dialogue / concrete scenes)
  if (text.contains('"') || text.contains('\u201c')) {
    score += 10;
  }

  // Sensory / concrete verbs (shows rather than tells)
  final concreteVerbs = [
    'saw', 'heard', 'felt', 'smelled', 'tasted', 'watched',
    'noticed', 'stared', 'grabbed', 'rushed', 'whispered',
    'laughed', 'cried', 'screamed', 'walked', 'ran',
  ];
  int verbCount = 0;
  for (final v in concreteVerbs) {
    if (lower.contains(v)) verbCount++;
  }
  score += (verbCount * 4).clamp(0, 20);

  // Time markers (specific temporal references)
  final timeMarkers = lower.contains(RegExp(
      r'(morning|afternoon|evening|night|monday|tuesday|january|february|march|april|may|june|july|august|september|october|november|december|\d{4})'));
  if (timeMarkers) score += 10;

  // Paragraph length variety (shows structure)
  final paragraphs = text.split(RegExp(r'\n\s*\n'));
  if (paragraphs.length >= 4 && paragraphs.length <= 8) score += 10;

  // Sentence length variety
  final sentences = text.split(RegExp(r'[.!?]+'));
  if (sentences.length >= 10) score += 5;

  return score.clamp(0, 100);
}

/// Scores voice consistency 0–100.
///
/// Checks for:
/// - Consistent tense usage
/// - Pronoun consistency
/// - No sudden register shifts
int _scoreVoiceConsistency(String text) {
  int score = 100;

  final lower = text.toLowerCase();

  // Check tense consistency — if most sentences use past tense,
  // penalize present tense intrusions (and vice-versa)
  final pastIndicators = RegExp(
      r'\b(was|were|had|did|went|came|said|made|took|gave|found|felt|knew|thought|saw|heard)\b');
  final presentIndicators = RegExp(
      r'\b(is|are|am|have|has|do|does|go|come|say|make|take|give|find|feel|know|think|see|hear)\b');

  final pastCount = pastIndicators.allMatches(lower).length;
  final presentCount = presentIndicators.allMatches(lower).length;

  if (pastCount > 0 && presentCount > 0) {
    final ratio = pastCount / (pastCount + presentCount);
    // 70/30 split is acceptable; anything tighter loses points
    if (ratio > 0.3 && ratio < 0.7) {
      score -= 10;
    }
  }

  // Pronoun consistency — penalize sudden switches between
  // first person and second/third person
  final firstPerson = RegExp(r'\b(i |my |me |mine |myself )\b');
  final secondPerson = RegExp(r'\b(you |your |yours |yourself )\b');

  final fpCount = firstPerson.allMatches(lower).length;
  final spCount = secondPerson.allMatches(lower).length;

  if (fpCount > 0 && spCount > 0) {
    final ratio = fpCount / (fpCount + spCount);
    if (ratio > 0.3 && ratio < 0.7) {
      score -= 15; // Switching between "I" and "you" is jarring
    }
  }

  return score.clamp(0, 100);
}

/// Generates actionable suggestions based on the analysis.
List<String> _generateSuggestions(
    String text, bool wordCountOk, NarrativeArc arc) {
  final suggestions = <String>[];
  final lower = text.toLowerCase();
  final wordCount = text.trim().split(RegExp(r'\s+')).length;

  // Word count
  if (wordCount < 250) {
    suggestions.add(
        'Your essay is only $wordCount words. Aim for 250–650 words to '
        'give yourself enough space to develop your story.');
  } else if (wordCount > 650) {
    suggestions.add(
        'Your essay is $wordCount words (over the 650 limit). '
        'Trim ~${wordCount - 650} words while preserving your strongest moments.');
  } else if (wordCount < 400) {
    suggestions.add(
        'At $wordCount words you have room to expand. Consider adding '
        'more concrete details or a deeper reflection paragraph.');
  }

  // Narrative arc
  if (!arc.hasBeginning) {
    suggestions.add(
        'Your opening doesn\'t clearly hook the reader. Try starting with '
        'a specific moment, image, or question that draws readers in.');
  }
  if (!arc.hasChallenge) {
    suggestions.add(
        'No clear challenge or tension was detected. Admissions officers '
        'want to see how you navigate difficulty — consider adding a '
        'turning point or obstacle.');
  }
  if (!arc.hasGrowth) {
    suggestions.add(
        'Your essay doesn\'t clearly show personal growth. After presenting '
        'a challenge, show how you changed, learned, or evolved.');
  }
  if (!arc.hasReflection) {
    suggestions.add(
        'End with a reflection. What did this experience teach you about '
        'yourself? How does it connect to who you want to become?');
  }

  // Generic phrases
  final genericPhrases = [
    'since the dawn of time', 'in today\'s society',
    'needless to say', 'at the end of the day',
    'i have always been passionate', 'making a difference',
    'think outside the box', 'give back to society',
    'in this day and age',
  ];
  for (final phrase in genericPhrases) {
    if (lower.contains(phrase)) {
      suggestions.add(
          'Remove the generic phrase "$phrase" — replace it with something '
          'specific to your experience.');
    }
  }

  // Tips
  if (suggestions.isEmpty) {
    suggestions.add(
        'Strong essay! Consider reading it aloud to catch any unnatural '
        'phrasing, and have a trusted mentor review it for clarity.');
  }

  return suggestions;
}

// ═══════════════════════════════════════════════════════════════════════
// Personalized Story Suggestions
// ═══════════════════════════════════════════════════════════════════════

/// Returns personalized story ideas based on the student's activities and
/// target goals. [promptNumber] is the Common App prompt number (1–7).
List<String> getSuggestions(int promptNumber, StudentProfile profile) {
  final suggestions = <String>[];
  final activities = profile.activities;

  switch (promptNumber) {
    case 1: // Background / Identity / Talent
      suggestions.add(
          'Write about a unique aspect of your cultural or family background '
          'that shaped your worldview.');
      if (profile.targetCountries.isNotEmpty) {
        suggestions.add(
            'Explore what it means to be an international applicant — the '
            'cultural bridge you navigate daily.');
      }
      if (activities.any((a) => a.category == ActivityCategory.unique)) {
        final unique = activities
            .firstWhere((a) => a.category == ActivityCategory.unique);
        suggestions.add(
            'Tell the story of "${unique.title}" — how did this unique '
            'talent or interest develop? What drives it?');
      }
      if (profile.targetMajor.isNotEmpty) {
        suggestions.add(
            'Trace the moment you first became fascinated by '
            '${profile.targetMajor} — was there a specific experience?');
      }
      break;

    case 2: // Challenge / Setback / Failure
      suggestions.add(
          'Describe a time when an academic setback (bad grade, failed '
          'exam) forced you to rethink your approach to learning.');
      if (activities.any((a) => a.category == ActivityCategory.competitions)) {
        suggestions.add(
            'Write about a competition where you didn\'t win — what did '
            'the loss teach you about resilience?');
      }
      suggestions.add(
          'Talk about balancing intense academics with coaching and '
          'extracurriculars — when did something give, and how did you recover?');
      break;

    case 3: // Questioned / Challenged Belief
      suggestions.add(
          'Reflect on a time you challenged a societal or family expectation '
          'about what "success" looks like.');
      if (profile.motivation.drivers.isNotEmpty) {
        final driver = profile.motivation.drivers.first.name;
        suggestions.add(
            'Explore how your motivation driver "$driver" has sometimes '
            'clashed with conventional wisdom.');
      }
      break;

    case 4: // Gratitude
      suggestions.add(
          'Write about a teacher, coach, or mentor who saw something in you '
          'that you didn\'t see in yourself.');
      if (profile.coachingInstitute.isNotEmpty) {
        suggestions.add(
            'Reflect on how ${profile.coachingInstitute} shaped more than '
            'just your test scores — what relationships or values did you gain?');
      }
      break;

    case 5: // Growth / New Understanding
      if (activities.isNotEmpty) {
        final mostImpactful = activities
            .reduce((a, b) =>
                a.admissionsValue > b.admissionsValue ? a : b);
        suggestions.add(
            'Write about "${mostImpactful.title}" — how did this activity '
            'change the way you see yourself or the world?');
      }
      suggestions.add(
          'Describe a realization about your privilege, community, or '
          'responsibility that shifted your perspective.');
      break;

    case 6: // Engaging Idea / Concept
      if (profile.targetMajor.isNotEmpty) {
        suggestions.add(
            'Dive deep into a specific topic within ${profile.targetMajor} '
            'that fascinates you — what question keeps you up at night?');
      }
      suggestions.add(
          'Write about an intellectual rabbit hole you fell into — what did '
          'you discover, and why does it matter to you?');
      if (activities.any((a) => a.category == ActivityCategory.research)) {
        suggestions.add(
            'Share the research question that drove your project and why '
            'it captivated you beyond just a grade.');
      }
      break;

    case 7: // Topic of Choice
      suggestions.add(
          'Consider writing a letter to your future self, or a "day in my '
          'life" narrative that reveals your character through mundane details.');
      if (profile.reachUniversities.isNotEmpty) {
        suggestions.add(
            'Write about a problem in ${profile.targetMajor} you want to '
            'solve, connecting it to your experience at ${profile.reachUniversities.first}.');
      }
      break;
  }

  return suggestions;
}

// ═══════════════════════════════════════════════════════════════════════
// Common Essay Pitfalls
// ═══════════════════════════════════════════════════════════════════════

class EssayPitfalls {
  EssayPitfalls._();

  static const List<String> checklist = [
    '❌ Starting with a dictionary definition ("Webster\'s defines leadership as…")',
    '❌ Writing a résumé in paragraph form — list activities without narrative',
    '❌ Being too vague: "I volunteered and it changed my life"',
    '❌ Using overly complex vocabulary to sound "smart" (admissions officers notice)',
    '❌ Copying someone else\'s essay structure or famous essays',
    '❌ Trying to cover too many experiences — focus on one meaningful story',
    '❌ Ending with a cliché: "And that\'s why I want to attend your university"',
    '❌ Being preachy or lecturing the reader about social issues',
    '❌ Ignoring the prompt — always answer what\'s actually asked',
    '❌ Not proofreading — typos and grammar errors signal carelessness',
    '❌ Writing about trauma without reflecting on growth (exploitative narrative)',
    '❌ Using first person excessively ("I did this, I did that, I felt…")',
    '❌ Failing to show vulnerability — perfect students aren\'t relatable',
    '❌ Not connecting your story to your future goals or college plans',
  ];
}
