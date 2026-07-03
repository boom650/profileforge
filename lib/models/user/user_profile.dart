import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_profile.freezed.dart';
part 'user_profile.g.dart';

@freezed
abstract class UserProfile with _$UserProfile {
  const factory UserProfile({
    required String id,
    required String name,
    required String email,
    required String phone,
    String? board,
    String? stream,
    required int grade,
    required Map<String, double> subjects,
    required double tenthPercentage,
    required String coachingInstitute,
    required int coachingHoursPerWeek,
    required int? satScore,
    required double? ieltsScore,
    required List<String> targetCountries,
    required String targetMajor,
    required List<String> reachUniversities,
    required List<String> matchUniversities,
    required List<String> safetyUniversities,
    required List<Activity> activities,
    required WeeklySchedule schedule,
    required MotivationProfile motivation,
    required DateTime createdAt,
    required DateTime updatedAt,
    required List<String> interests,
    required List<String> skills,
    required List<String> preferredLocations,
    required double? latitude,
    required double? longitude,
    required String? city,
    required String? state,
    required String? pincode,
    required Map<String, dynamic> preferences,
  }) = _UserProfile;

  factory UserProfile.fromJson(Map<String, dynamic> json) => _$UserProfileFromJson(json);

  factory UserProfile.empty() => UserProfile(
    id: '',
    name: '',
    email: '',
    phone: '',
    board: 'CBSE',
    stream: null,
    grade: 11,
    subjects: {},
    tenthPercentage: 0.0,
    coachingInstitute: '',
    coachingHoursPerWeek: 0,
    satScore: null,
    ieltsScore: null,
    targetCountries: [],
    targetMajor: '',
    reachUniversities: [],
    matchUniversities: [],
    safetyUniversities: [],
    activities: [],
    schedule: WeeklySchedule.empty(),
    motivation: MotivationProfile.empty(),
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
    interests: [],
    skills: [],
    preferredLocations: [],
    latitude: null,
    longitude: null,
    city: null,
    state: null,
    pincode: null,
    preferences: {},
  );
}

@freezed
abstract class Activity with _$Activity {
  const factory Activity({
    required String id,
    required String title,
    required ActivityCategory category,
    required ActivityTier tier,
    required String description,
    required int hoursPerWeek,
    required int weeksPerYear,
    required DateTime startDate,
    required DateTime? endDate,
    required String? evidence,
    required String? teacherVerification,
    required List<String> skills,
    required String narrativeAngle,
    required int admissionsValue,
    required bool isInSchool,
    required String? location,
  }) = _Activity;

  factory Activity.fromJson(Map<String, dynamic> json) => _$ActivityFromJson(json);
}

@freezed
abstract class WeeklySchedule with _$WeeklySchedule {
  const factory WeeklySchedule({
    required Map<String, List<TimeBlock>> schedule,
    required int discretionaryHoursWeekday,
    required int discretionaryHoursWeekend,
  }) = _WeeklySchedule;

  factory WeeklySchedule.fromJson(Map<String, dynamic> json) => _$WeeklyScheduleFromJson(json);

  factory WeeklySchedule.empty() => WeeklySchedule(
    schedule: {},
    discretionaryHoursWeekday: 0,
    discretionaryHoursWeekend: 0,
  );
}

@freezed
abstract class TimeBlock with _$TimeBlock {
  const factory TimeBlock({
    required String id,
    required String label,
    required String startTime,
    required String endTime,
    required TimeBlockType type,
    required bool isFree,
  }) = _TimeBlock;

  factory TimeBlock.fromJson(Map<String, dynamic> json) => _$TimeBlockFromJson(json);
}

@freezed
abstract class MotivationProfile with _$MotivationProfile {
  const factory MotivationProfile({
    required List<MotivationDriver> drivers,
    required StressStyle stressStyle,
  }) = _MotivationProfile;

  factory MotivationProfile.fromJson(Map<String, dynamic> json) => _$MotivationProfileFromJson(json);

  factory MotivationProfile.empty() => MotivationProfile(
    drivers: [],
    stressStyle: StressStyle.planner,
  );
}

enum ActivityCategory {
  @JsonValue('clubs')
  clubs,
  @JsonValue('sports')
  sports,
  @JsonValue('arts')
  arts,
  @JsonValue('competitions')
  competitions,
  @JsonValue('research')
  research,
  @JsonValue('volunteering')
  volunteering,
  @JsonValue('leadership')
  leadership,
  @JsonValue('work')
  work,
  @JsonValue('courses')
  courses,
  @JsonValue('unique')
  unique,
}

enum ActivityTier {
  @JsonValue('tier1')
  tier1,
  @JsonValue('tier2')
  tier2,
  @JsonValue('tier3')
  tier3,
  @JsonValue('tier4')
  tier4,
}

enum TimeBlockType {
  @JsonValue('school')
  school,
  @JsonValue('coaching')
  coaching,
  @JsonValue('sleep')
  sleep,
  @JsonValue('commute')
  commute,
  @JsonValue('meal')
  meal,
  @JsonValue('free')
  free,
  @JsonValue('club')
  club,
  @JsonValue('study')
  study,
  @JsonValue('other')
  other,
}

enum MotivationDriver {
  @JsonValue('family_pride')
  familyPride,
  @JsonValue('peer_comparison')
  peerComparison,
  @JsonValue('fear_of_failure')
  fearOfFailure,
  @JsonValue('scholarship_need')
  scholarshipNeed,
  @JsonValue('genuine_curiosity')
  genuineCuriosity,
  @JsonValue('status_abroad_dream')
  statusAbroadDream,
}

enum StressStyle {
  @JsonValue('planner')
  planner,
  @JsonValue('sprinter')
  sprinter,
  @JsonValue('avoider')
  avoider,
}