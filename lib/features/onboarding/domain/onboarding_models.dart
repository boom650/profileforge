import 'dart:convert';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'onboarding_models.freezed.dart';

/// A single competition / Olympiad / medal entry (CV-style).
@freezed
class Achievement with _$Achievement {
  const factory Achievement({
    required String name,
    /// e.g. "Gold", "Finalist", "Top 10%", "Participant".
    required String result,
    /// Optional year.
    @Default('') String year,
  }) = _Achievement;

  const Achievement._();

  String get label => year.isEmpty ? '$name — $result' : '$name ($year) — $result';
}

/// The student's admission context, captured during intelligent onboarding (H7).
/// Rich, CV-style: grades, activities, competitions, medals — so the app
/// can recommend *personalized* missions instead of blind templates.
@freezed
class OnboardingProfile with _$OnboardingProfile {
  const factory OnboardingProfile({
    required String profileId,
    /// e.g. {"Math": "92%", "Physics": "88%", "CS": "95%"}.
    @Default({}) Map<String, String> grades,
    /// Free-form list of extracurriculars / activities done so far.
    @Default([]) List<String> activities,
    /// Competitions, Olympiads, medals with results.
    @Default([]) List<Achievement> competitions,
    required List<String> subjects,
    required List<String> targetUniversities,
    @Default([]) List<String> careerInterests,
    @Default(0) int budget,
    @Default(0) int travelRadiusKm,
    @Default(0) int availabilityHoursPerWeek,
    @Default('') String location,
  }) = _OnboardingProfile;

  const OnboardingProfile._();

  /// JSON used to persist [competitions] into the `location` DB column.
  String get competitionsPersistJson => jsonEncode(
      competitions.map((a) => {'name': a.name, 'result': a.result, 'year': a.year}).toList());

  bool get isComplete =>
      targetUniversities.isNotEmpty &&
      subjects.isNotEmpty &&
      grades.isNotEmpty &&
      activities.isNotEmpty;

  /// 0–100 readiness score based on how much context is captured.
  int get readinessScore {
    var score = 0;
    if (targetUniversities.isNotEmpty) score += 20;
    if (subjects.isNotEmpty) score += 15;
    if (grades.isNotEmpty) score += 15;
    if (activities.isNotEmpty) score += 15;
    if (competitions.isNotEmpty) score += 15;
    if (careerInterests.isNotEmpty) score += 10;
    if (availabilityHoursPerWeek > 0) score += 5;
    if (budget > 0) score += 5;
    return score.clamp(0, 100);
  }

  /// Fields still missing (for nudges).
  List<String> get missing {
    final m = <String>[];
    if (targetUniversities.isEmpty) m.add('target universities');
    if (subjects.isEmpty) m.add('subjects');
    if (grades.isEmpty) m.add('class/board percentages');
    if (activities.isEmpty) m.add('activities');
    if (competitions.isEmpty) m.add('competitions / Olympiads / medals');
    if (careerInterests.isEmpty) m.add('career interests');
    return m;
  }

  // JSON (de)serialization for Drift text columns.
  String get universitiesJson => jsonEncode(targetUniversities);
  String get subjectsJson => jsonEncode(subjects);
  String get gradesJson => jsonEncode(grades);
  String get activitiesJson => jsonEncode(activities);
  String get careersJson => jsonEncode(careerInterests);
  String get competitionsJson =>
      jsonEncode(competitions.map((a) => {'n': a.name, 'r': a.result, 'y': a.year}).toList());

  static OnboardingProfile fromRow({
    required String profileId,
    required String targetUniversities,
    required String subjects,
    required String grades,
    required String clubs,
    required int budget,
    required int travelRadiusKm,
    required int availabilityHoursPerWeek,
    required String careerInterests,
    required String location,
  }) {
    // `clubs` column stores activities JSON; `location` stores competitions JSON.
    final activities = List<String>.from(jsonDecode(clubs));
    List<Achievement> comps = const [];
    try {
      comps = (jsonDecode(location) as List)
          .map((e) => Achievement(
                name: (e['name'] ?? e['n'] ?? '').toString(),
                result: (e['result'] ?? e['r'] ?? '').toString(),
                year: (e['year'] ?? e['y'] ?? '').toString(),
              ))
          .toList();
    } catch (_) {
      comps = const [];
    }
    return OnboardingProfile(
      profileId: profileId,
      targetUniversities: List<String>.from(jsonDecode(targetUniversities)),
      subjects: List<String>.from(jsonDecode(subjects)),
      grades: Map<String, String>.from(jsonDecode(grades)),
      activities: activities,
      competitions: comps,
      careerInterests: List<String>.from(jsonDecode(careerInterests)),
      budget: budget,
      travelRadiusKm: travelRadiusKm,
      availabilityHoursPerWeek: availabilityHoursPerWeek,
      location: '',
    );
  }
}

// ────────────────────────────────────────────────────────────────────────────
// Schedule profile — extended onboarding data (v4), stored in the same
// Onboarding table via separate columns.  Not freezed to avoid generated-code
// conflicts; a simple immutable data class.
// ────────────────────────────────────────────────────────────────────────────

class ScheduleProfile {
  final List<int> schoolDays;   // 1=Mon..7=Sun
  final int schoolStartHour;
  final int schoolStartMinute;
  final int schoolEndHour;
  final int schoolEndMinute;
  final String energyPeak;      // "morning", "afternoon", "night"
  final String sleepStart;      // "22:00"
  final String sleepEnd;        // "07:00"
  final String timelineGoal;    // "6months", "1year", "2years", "custom"
  final int screenTimeHours;
  final String studyEnvironment; // "library", "home", "cafe", "school", "mixed"
  final String socialMediaUsage; // "light", "moderate", "heavy"

  const ScheduleProfile({
    this.schoolDays = const [1, 2, 3, 4, 5],
    this.schoolStartHour = 8,
    this.schoolStartMinute = 0,
    this.schoolEndHour = 15,
    this.schoolEndMinute = 0,
    this.energyPeak = 'morning',
    this.sleepStart = '22:00',
    this.sleepEnd = '07:00',
    this.timelineGoal = '1year',
    this.screenTimeHours = 3,
    this.studyEnvironment = 'mixed',
    this.socialMediaUsage = 'moderate',
  });

  ScheduleProfile copyWith({
    List<int>? schoolDays,
    int? schoolStartHour,
    int? schoolStartMinute,
    int? schoolEndHour,
    int? schoolEndMinute,
    String? energyPeak,
    String? sleepStart,
    String? sleepEnd,
    String? timelineGoal,
    int? screenTimeHours,
    String? studyEnvironment,
    String? socialMediaUsage,
  }) {
    return ScheduleProfile(
      schoolDays: schoolDays ?? this.schoolDays,
      schoolStartHour: schoolStartHour ?? this.schoolStartHour,
      schoolStartMinute: schoolStartMinute ?? this.schoolStartMinute,
      schoolEndHour: schoolEndHour ?? this.schoolEndHour,
      schoolEndMinute: schoolEndMinute ?? this.schoolEndMinute,
      energyPeak: energyPeak ?? this.energyPeak,
      sleepStart: sleepStart ?? this.sleepStart,
      sleepEnd: sleepEnd ?? this.sleepEnd,
      timelineGoal: timelineGoal ?? this.timelineGoal,
      screenTimeHours: screenTimeHours ?? this.screenTimeHours,
      studyEnvironment: studyEnvironment ?? this.studyEnvironment,
      socialMediaUsage: socialMediaUsage ?? this.socialMediaUsage,
    );
  }

  /// JSON columns stored in the Onboarding table.
  String get schoolDaysJson => jsonEncode(schoolDays);
}

// ────────────────────────────────────────────────────────────────────────────
// Essay context (v6) — the raw material admissions officers read for.
// Research basis: 03ba-essay-narrative-craft (authenticity, self-awareness,
// intellectual curiosity, resilience, specificity) and the Common App prompts.
// This becomes the seed for the personal-statement and AI mission framing.
// ────────────────────────────────────────────────────────────────────────────

class EssayContext {
  /// A defining moment / story seed for the personal statement.
  final String story;
  /// VIA-style values, e.g. ["Curiosity", "Grit", "Curiosity"].
  final List<String> values;
  /// "What question keeps you up at night?" — intellectual curiosity hook.
  final String curiosity;
  /// Which Common App prompt resonates most: '1'..'7' ('' = any).
  final String promptPref;

  const EssayContext({
    this.story = '',
    this.values = const [],
    this.curiosity = '',
    this.promptPref = '',
  });

  EssayContext copyWith({
    String? story,
    List<String>? values,
    String? curiosity,
    String? promptPref,
  }) {
    return EssayContext(
      story: story ?? this.story,
      values: values ?? this.values,
      curiosity: curiosity ?? this.curiosity,
      promptPref: promptPref ?? this.promptPref,
    );
  }

  String get valuesPersistJson => jsonEncode(values);

  /// True if any essay material has been captured.
  bool get isMeaningful =>
      story.isNotEmpty || values.isNotEmpty || curiosity.isNotEmpty;

  static EssayContext fromRow({
    required String story,
    required String valuesJson,
    required String curiosity,
    required String promptPref,
  }) {
    List<String> values = const [];
    try {
      values = List<String>.from(jsonDecode(valuesJson));
    } catch (_) {
      values = const [];
    }
    return EssayContext(
      story: story,
      values: values,
      curiosity: curiosity,
      promptPref: values.isEmpty ? '' : promptPref,
    );
  }
}
