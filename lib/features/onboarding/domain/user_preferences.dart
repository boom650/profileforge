import 'dart:convert';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_preferences.freezed.dart';

/// Deep user preferences — what they LIKE, what they HATE, their skills, values.
/// This is what makes AI recommendations actually personal.
@freezed
class UserPreferences with _$UserPreferences {
  const factory UserPreferences({
    /// Activities the user ENJOYS (multi-select from chips).
    @Default([]) List<String> likedActivities,
    /// Activities the user DISLIKES or wants to avoid.
    @Default([]) List<String> dislikedActivities,
    /// Skills the user already has (coding, writing, drawing, etc.).
    @Default([]) List<String> skills,
    /// Skills the user WANTS to learn.
    @Default([]) List<String> wantToLearn,
    /// When the user prefers to work: morning, afternoon, evening, night.
    @Default('') String preferredTimeOfDay,
    /// Which days the user is most available.
    @Default([]) List<String> availableDays,
    /// What matters most to the user (impact, creativity, learning, prestige, etc.).
    @Default([]) List<String> values,
    /// Personality traits (introvert, extrovert, risk-taker, detail-oriented, etc.).
    @Default([]) List<String> personalityTraits,
    /// What the user has ALREADY tried (so we don't repeat).
    @Default([]) List<String> pastExperiences,
    /// Constraints (no transport, limited internet, etc.).
    @Default([]) List<String> constraints,
    /// What the user is most proud of so far.
    @Default('') String proudestAchievement,
    /// What the user wants admissions officers to remember about them.
    @Default('') String wantToBeRememberedAs,
  }) = _UserPreferences;

  const UserPreferences._();

  /// JSON serialization for storage.
  String get toJson => jsonEncode({
    'likedActivities': likedActivities,
    'dislikedActivities': dislikedActivities,
    'skills': skills,
    'wantToLearn': wantToLearn,
    'preferredTimeOfDay': preferredTimeOfDay,
    'availableDays': availableDays,
    'values': values,
    'personalityTraits': personalityTraits,
    'pastExperiences': pastExperiences,
    'constraints': constraints,
    'proudestAchievement': proudestAchievement,
    'wantToBeRememberedAs': wantToBeRememberedAs,
  });

  /// Deserialize from JSON string.
  factory UserPreferences.fromJsonString(String json) {
    try {
      final data = Map<String, dynamic>.from(jsonDecode(json));
      return UserPreferences(
        likedActivities: List<String>.from(data['likedActivities'] ?? []),
        dislikedActivities: List<String>.from(data['dislikedActivities'] ?? []),
        skills: List<String>.from(data['skills'] ?? []),
        wantToLearn: List<String>.from(data['wantToLearn'] ?? []),
        preferredTimeOfDay: data['preferredTimeOfDay'] ?? '',
        availableDays: List<String>.from(data['availableDays'] ?? []),
        values: List<String>.from(data['values'] ?? []),
        personalityTraits: List<String>.from(data['personalityTraits'] ?? []),
        pastExperiences: List<String>.from(data['pastExperiences'] ?? []),
        constraints: List<String>.from(data['constraints'] ?? []),
        proudestAchievement: data['proudestAchievement'] ?? '',
        wantToBeRememberedAs: data['wantToBeRememberedAs'] ?? '',
      );
    } catch (_) {
      return const UserPreferences();
    }
  }

  /// Readiness score — how well do we know this user?
  int get readinessScore {
    var score = 0;
    if (likedActivities.isNotEmpty) score += 15;
    if (skills.isNotEmpty) score += 15;
    if (wantToLearn.isNotEmpty) score += 10;
    if (preferredTimeOfDay.isNotEmpty) score += 10;
    if (availableDays.isNotEmpty) score += 10;
    if (values.isNotEmpty) score += 10;
    if (personalityTraits.isNotEmpty) score += 10;
    if (proudestAchievement.isNotEmpty) score += 10;
    if (wantToBeRememberedAs.isNotEmpty) score += 10;
    return score.clamp(0, 100);
  }

  /// What we still don't know about this user.
  List<String> get missing {
    final m = <String>[];
    if (likedActivities.isEmpty) m.add('what you enjoy doing');
    if (skills.isEmpty) m.add('your current skills');
    if (wantToLearn.isEmpty) m.add('what you want to learn');
    if (preferredTimeOfDay.isEmpty) m.add('when you prefer to work');
    if (values.isEmpty) m.add('what matters to you');
    if (proudestAchievement.isEmpty) m.add('your proudest achievement');
    if (wantToBeRememberedAs.isEmpty) m.add('how you want to be remembered');
    return m;
  }
}

// ─── CHIP OPTIONS FOR ONBOARDING ───

/// What activities can users say they LIKE or DISLIKE?
const likedActivityOptions = [
  'Building apps or websites',
  'Coding / programming',
  'Robotics / hardware',
  'Writing stories or essays',
  'Drawing / painting / art',
  'Photography / film',
  'Music / singing',
  'Debate / public speaking',
  'Teaching / tutoring',
  'Volunteering / community service',
  'Research / experiments',
  'Math / problem solving',
  'Sports / athletics',
  'Leading teams / organizations',
  'Organizing events',
  'Reading / learning new things',
  'Traveling / exploring',
  'Cooking / baking',
  'Gaming / game design',
  'Social media / content creation',
];

/// What skills can users say they HAVE?
const skillOptions = [
  'Python',
  'JavaScript / web dev',
  'Flutter / mobile apps',
  'Java / C++',
  'Graphic design',
  'Video editing',
  'Photography',
  'Writing / copywriting',
  'Public speaking',
  'Data analysis',
  'Research methodology',
  'Project management',
  'Social media management',
  'Event planning',
  'Tutoring / teaching',
  'Leadership',
  'Fundraising',
  'Second language',
];

/// What can users want to LEARN?
const wantToLearnOptions = [
  'Machine learning / AI',
  'Web development',
  'Mobile app development',
  'Data science',
  'Graphic design',
  'Video production',
  'Public speaking',
  'Creative writing',
  'Research methods',
  'Business / entrepreneurship',
  'Foreign language',
  'Music production',
  '3D modeling',
  'Cybersecurity',
  'Game development',
];

/// What VALUES can users prioritize?
const valueOptions = [
  'Making a real impact on people',
  'Learning and intellectual growth',
  'Creative expression',
  'Building something tangible',
  'Helping my community',
  'Academic achievement',
  'Recognition and prestige',
  'Financial independence',
  'Personal freedom',
  'Social connections',
  'Solving hard problems',
  'Being a leader',
  'Pushing boundaries',
  'Helping the underprivileged',
  'Environmental conservation',
];

/// Personality trait options.
const personalityOptions = [
  'Introvert — I prefer deep work alone',
  'Extrovert — I thrive with people',
  'Risk-taker — I jump into new things',
  'Cautious — I plan carefully first',
  'Detail-oriented — I notice everything',
  'Big-picture — I see the forest, not trees',
  'Competitive — I want to be the best',
  'Collaborative — I work best in teams',
  'Self-driven — I don\'t need external motivation',
  'Routine-lover — I like structure',
  'Spontaneous — I hate rigid schedules',
  'Perfectionist — I won\'t ship until it\'s perfect',
];

/// Time of day options.
const timeOfDayOptions = [
  'Early morning (5-8 AM)',
  'Morning (8-12 PM)',
  'Afternoon (12-5 PM)',
  'Evening (5-9 PM)',
  'Night (9 PM-12 AM)',
];

/// Day options.
const dayOptions = [
  'Monday',
  'Tuesday',
  'Wednesday',
  'Thursday',
  'Friday',
  'Saturday',
  'Sunday',
];
