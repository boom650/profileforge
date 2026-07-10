import 'package:meta/meta.dart';

/// Data class to accumulate form data across onboarding screens.
@immutable
class OnboardingData {
  // Screen 2: Quick Profile
  final String name;
  final String? board;
  final String? stream;
  final int? grade;
  final Map<String, double> subjects; // subject name -> score

  // Screen 3: Goals
  final String? targetMajor;
  final Set<String> targetCountries;
  final List<String> targetUniversities;

  // Screen 10: School Timetable
  final String? schoolStartTime;
  final String? schoolEndTime;
  final bool hasCoaching;
  final String? coachingStartTime;
  final String? coachingEndTime;
  final bool hasCommute;
  final String? commuteDuration;

  // Screen 11: Free Slots
  final int freeSlotsWeekdayHours;
  final int freeSlotsWeekendHours;
  final bool freeSlotsConfirmed;

  // Screen 12: School Frequency
  final int? schoolDaysPerWeek;
  final Set<String> schoolDays;
  final bool hasSaturdaySchool;

  const OnboardingData({
    this.name = '',
    this.board,
    this.stream,
    this.grade,
    this.subjects = const {},
    this.targetMajor,
    this.targetCountries = const {},
    this.targetUniversities = const [],
    this.schoolStartTime,
    this.schoolEndTime,
    this.hasCoaching = false,
    this.coachingStartTime,
    this.coachingEndTime,
    this.hasCommute = true,
    this.commuteDuration,
    this.freeSlotsWeekdayHours = 2,
    this.freeSlotsWeekendHours = 5,
    this.freeSlotsConfirmed = false,
    this.schoolDaysPerWeek,
    this.schoolDays = const {},
    this.hasSaturdaySchool = false,
  });

  OnboardingData copyWith({
    String? name,
    String? board,
    String? stream,
    int? grade,
    Map<String, double>? subjects,
    String? targetMajor,
    Set<String>? targetCountries,
    List<String>? targetUniversities,
    String? schoolStartTime,
    String? schoolEndTime,
    bool? hasCoaching,
    String? coachingStartTime,
    String? coachingEndTime,
    bool? hasCommute,
    String? commuteDuration,
    int? freeSlotsWeekdayHours,
    int? freeSlotsWeekendHours,
    bool? freeSlotsConfirmed,
    int? schoolDaysPerWeek,
    Set<String>? schoolDays,
    bool? hasSaturdaySchool,
  }) {
    return OnboardingData(
      name: name ?? this.name,
      board: board ?? this.board,
      stream: stream ?? this.stream,
      grade: grade ?? this.grade,
      subjects: subjects ?? this.subjects,
      targetMajor: targetMajor ?? this.targetMajor,
      targetCountries: targetCountries ?? this.targetCountries,
      targetUniversities: targetUniversities ?? this.targetUniversities,
      schoolStartTime: schoolStartTime ?? this.schoolStartTime,
      schoolEndTime: schoolEndTime ?? this.schoolEndTime,
      hasCoaching: hasCoaching ?? this.hasCoaching,
      coachingStartTime: coachingStartTime ?? this.coachingStartTime,
      coachingEndTime: coachingEndTime ?? this.coachingEndTime,
      hasCommute: hasCommute ?? this.hasCommute,
      commuteDuration: commuteDuration ?? this.commuteDuration,
      freeSlotsWeekdayHours: freeSlotsWeekdayHours ?? this.freeSlotsWeekdayHours,
      freeSlotsWeekendHours: freeSlotsWeekendHours ?? this.freeSlotsWeekendHours,
      freeSlotsConfirmed: freeSlotsConfirmed ?? this.freeSlotsConfirmed,
      schoolDaysPerWeek: schoolDaysPerWeek ?? this.schoolDaysPerWeek,
      schoolDays: schoolDays ?? this.schoolDays,
      hasSaturdaySchool: hasSaturdaySchool ?? this.hasSaturdaySchool,
    );
  }
}
