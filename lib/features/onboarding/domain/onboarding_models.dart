import 'dart:convert';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'onboarding_models.freezed.dart';

/// The student's admission context, captured during intelligent onboarding (H7).
@freezed
class OnboardingProfile with _$OnboardingProfile {
  const factory OnboardingProfile({
    required String profileId,
    required List<String> targetUniversities,
    required List<String> subjects,
    required Map<String, String> grades,
    required List<String> clubs,
    required int budget,
    required int travelRadiusKm,
    required int availabilityHoursPerWeek,
    required List<String> careerInterests,
    required String location,
  }) = _OnboardingProfile;

  const OnboardingProfile._();

  /// 0–100 readiness score based on how much context is captured.
  int get readinessScore {
    var score = 0;
    if (targetUniversities.isNotEmpty) score += 20;
    if (subjects.isNotEmpty) score += 15;
    if (grades.isNotEmpty) score += 15;
    if (clubs.isNotEmpty) score += 10;
    if (budget > 0) score += 10;
    if (travelRadiusKm > 0) score += 10;
    if (availabilityHoursPerWeek > 0) score += 10;
    if (careerInterests.isNotEmpty) score += 10;
    return score;
  }

  /// Fields still missing (for nudges).
  List<String> get missing {
    final m = <String>[];
    if (targetUniversities.isEmpty) m.add('target universities');
    if (subjects.isEmpty) m.add('subjects');
    if (grades.isEmpty) m.add('grades');
    if (clubs.isEmpty) m.add('clubs');
    if (budget <= 0) m.add('budget');
    if (travelRadiusKm <= 0) m.add('travel radius');
    if (availabilityHoursPerWeek <= 0) m.add('availability');
    if (careerInterests.isEmpty) m.add('career interests');
    return m;
  }

  // JSON (de)serialization for Drift text columns.
  String get universitiesJson => jsonEncode(targetUniversities);
  String get subjectsJson => jsonEncode(subjects);
  String get gradesJson => jsonEncode(grades);
  String get clubsJson => jsonEncode(clubs);
  String get careersJson => jsonEncode(careerInterests);

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
  }) =>
      OnboardingProfile(
        profileId: profileId,
        targetUniversities: List<String>.from(jsonDecode(targetUniversities)),
        subjects: List<String>.from(jsonDecode(subjects)),
        grades: Map<String, String>.from(jsonDecode(grades)),
        clubs: List<String>.from(jsonDecode(clubs)),
        budget: budget,
        travelRadiusKm: travelRadiusKm,
        availabilityHoursPerWeek: availabilityHoursPerWeek,
        careerInterests: List<String>.from(jsonDecode(careerInterests)),
        location: location,
      );
}
