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
                name: (e['n'] ?? '').toString(),
                result: (e['r'] ?? '').toString(),
                year: (e['y'] ?? '').toString(),
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
