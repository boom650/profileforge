/// Split onboarding providers from main app_providers.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:meta/meta.dart';
import 'package:uuid/uuid.dart';
import '../models/onboarding/onboarding_data.dart';
import '../models/student_profile.dart';
import '../models/student_profile.dart' show TimeBlock, TimeBlockType, WeeklySchedule, MotivationProfile;
import 'profile_providers.dart';

final onboardingCompletedProvider = StateProvider<bool>((ref) {
  return false;
});

final setOnboardingCompletedProvider =
    Provider<Future<void> Function(bool)>((ref) {
  return (bool completed) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboarding_completed', completed);
    ref.read(onboardingCompletedProvider.notifier).state = completed;
  };
});

/// StateNotifier for accumulating onboarding data across screens
@immutable
class OnboardingDataNotifier extends StateNotifier<OnboardingData> {
  static const _key = 'onboarding_data';

  OnboardingDataNotifier() : super(const OnboardingData()) {
    _loadFromPrefs();
  }

  Future<void> _save() async {
    final prefs = await SharedPreferences.getInstance();
    final data = {
      'name': state.name,
      'board': state.board,
      'stream': state.stream,
      'grade': state.grade,
      'subjects': state.subjects,
      'targetMajor': state.targetMajor,
      'targetCountries': state.targetCountries.toList(),
      'targetUniversities': state.targetUniversities,
      'schoolStartTime': state.schoolStartTime,
      'schoolEndTime': state.schoolEndTime,
      'hasCoaching': state.hasCoaching,
      'coachingStartTime': state.coachingStartTime,
      'coachingEndTime': state.coachingEndTime,
      'hasCommute': state.hasCommute,
      'commuteDuration': state.commuteDuration,
      'freeSlotsWeekdayHours': state.freeSlotsWeekdayHours,
      'freeSlotsWeekendHours': state.freeSlotsWeekendHours,
      'freeSlotsConfirmed': state.freeSlotsConfirmed,
      'schoolDaysPerWeek': state.schoolDaysPerWeek,
      'schoolDays': state.schoolDays.toList(),
      'hasSaturdaySchool': state.hasSaturdaySchool,
    };
    await prefs.setString(_key, jsonEncode(data));
  }

  Future<void> _loadFromPrefs() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getString(_key);
      if (raw == null || raw.isEmpty) return;
      final data = jsonDecode(raw) as Map<String, dynamic>;
      state = OnboardingData(
        name: (data['name'] as String?) ?? '',
        board: data['board'] as String?,
        stream: data['stream'] as String?,
        grade: data['grade'] as int?,
        subjects: Map<String, double>.from(
          (data['subjects'] as Map<String, dynamic>?)?.map((k, v) => MapEntry(k, (v as num).toDouble())) ?? {},
        ),
        targetMajor: data['targetMajor'] as String?,
        targetCountries: Set<String>.from(data['targetCountries'] as List<dynamic>? ?? []),
        targetUniversities: List<String>.from(data['targetUniversities'] as List<dynamic>? ?? []),
        schoolStartTime: data['schoolStartTime'] as String?,
        schoolEndTime: data['schoolEndTime'] as String?,
        hasCoaching: data['hasCoaching'] as bool? ?? false,
        coachingStartTime: data['coachingStartTime'] as String?,
        coachingEndTime: data['coachingEndTime'] as String?,
        hasCommute: data['hasCommute'] as bool? ?? true,
        commuteDuration: data['commuteDuration'] as String?,
        freeSlotsWeekdayHours: data['freeSlotsWeekdayHours'] as int? ?? 2,
        freeSlotsWeekendHours: data['freeSlotsWeekendHours'] as int? ?? 5,
        freeSlotsConfirmed: data['freeSlotsConfirmed'] as bool? ?? false,
        schoolDaysPerWeek: data['schoolDaysPerWeek'] as int?,
        schoolDays: Set<String>.from(data['schoolDays'] as List<dynamic>? ?? []),
        hasSaturdaySchool: data['hasSaturdaySchool'] as bool? ?? false,
      );
    } catch (_) {
      // Silently ignore — fresh start if corrupt
    }
  }

  void updateName(String name) {
    state = state.copyWith(name: name);
    _save();
  }

  void updateBoard(String? board) {
    state = state.copyWith(board: board);
    _save();
  }
  
  void updateStream(String? stream) {
    state = state.copyWith(stream: stream);
    _save();
  }

  void updateGrade(int? grade) {
    state = state.copyWith(grade: grade);
    _save();
  }

  void updateSubject(String subjectName, double score) {
    final newSubjects = Map<String, double>.from(state.subjects);
    newSubjects[subjectName] = score;
    state = state.copyWith(subjects: newSubjects);
    _save();
  }

  void replaceSubjects(Map<String, double> subjects) {
    state = state.copyWith(subjects: Map<String, double>.from(subjects));
    _save();
  }

  void updateTargetMajor(String? major) {
    state = state.copyWith(targetMajor: major);
    _save();
  }

  void updateTargetCountries(Set<String> countries) {
    state = state.copyWith(targetCountries: countries);
    _save();
  }

  void updateTargetUniversities(List<String> universities) {
    state = state.copyWith(targetUniversities: universities);
    _save();
  }

  void updateSchoolTimetable({
    String? schoolStartTime,
    String? schoolEndTime,
    bool? hasCoaching,
    String? coachingStartTime,
    String? coachingEndTime,
    bool? hasCommute,
    String? commuteDuration,
  }) {
    state = state.copyWith(
      schoolStartTime: schoolStartTime,
      schoolEndTime: schoolEndTime,
      hasCoaching: hasCoaching,
      coachingStartTime: coachingStartTime,
      coachingEndTime: coachingEndTime,
      hasCommute: hasCommute,
      commuteDuration: commuteDuration,
    );
    _save();
  }
  
  void updateFreeSlots({
    int? freeSlotsWeekdayHours,
    int? freeSlotsWeekendHours,
    bool? freeSlotsConfirmed,
  }) {
    state = state.copyWith(
      freeSlotsWeekdayHours: freeSlotsWeekdayHours,
      freeSlotsWeekendHours: freeSlotsWeekendHours,
      freeSlotsConfirmed: freeSlotsConfirmed,
    );
    _save();
  }

  void updateSchoolFrequency({
    int? schoolDaysPerWeek,
    Set<String>? schoolDays,
    bool? hasSaturdaySchool,
  }) {
    state = state.copyWith(
      schoolDaysPerWeek: schoolDaysPerWeek,
      schoolDays: schoolDays,
      hasSaturdaySchool: hasSaturdaySchool,
    );
    _save();
  }

  /// Reset all accumulated onboarding data back to defaults.
  void reset() {
    state = const OnboardingData();
    _save();
  }
}

final onboardingDataProvider =
    StateNotifierProvider<OnboardingDataNotifier, OnboardingData>(
  (ref) => OnboardingDataNotifier(),
);

/// Converts accumulated onboarding data into a StudentProfile.
StudentProfile buildStudentProfileFromOnboarding(OnboardingData data) {
  // Build a WeeklySchedule from onboarding timetable data
  final schedule = _buildScheduleFromOnboarding(data);

  // Compute coaching hours per week from timetable
  int coachingHrsPerWeek = 0;
  if (data.hasCoaching &&
      data.coachingStartTime != null &&
      data.coachingEndTime != null) {
    final startParts = data.coachingStartTime!.split(':');
    final endParts = data.coachingEndTime!.split(':');
    if (startParts.length == 2 && endParts.length == 2) {
      final startMin =
          int.parse(startParts[0]) * 60 + int.parse(startParts[1]);
      final endMin = int.parse(endParts[0]) * 60 + int.parse(endParts[1]);
      final dailyMins = endMin - startMin;
      if (dailyMins > 0) {
        final daysPerWeek = data.schoolDaysPerWeek ?? 5;
        coachingHrsPerWeek = ((dailyMins * daysPerWeek) / 60).round();
      }
    }
  }

  return StudentProfile(
    id: const Uuid().v4(),
    name: data.name.trim(),
    email: '',
    phone: '',
    board: data.board,
    stream: data.stream,
    grade: data.grade ?? 11,
    subjects: data.subjects,
    tenthPercentage: 0.0,
    coachingInstitute: '',
    coachingHoursPerWeek: coachingHrsPerWeek,
    satScore: null,
    ieltsScore: null,
    targetCountries: data.targetCountries.toList(),
    targetMajor: data.targetMajor ?? '',
    reachUniversities: data.targetUniversities,
    matchUniversities: [],
    safetyUniversities: [],
    activities: [],
    schedule: schedule,
    motivation: MotivationProfile.empty(),
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
  );
}

/// Builds a WeeklySchedule from onboarding timetable + free slots data.
WeeklySchedule _buildScheduleFromOnboarding(OnboardingData data) {
  final schedule = <String, List<TimeBlock>>{};
  final days = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday'];
  if (data.hasSaturdaySchool || (data.schoolDaysPerWeek != null && data.schoolDaysPerWeek! > 5)) {
    days.add('Saturday');
  }

  final schoolStart = data.schoolStartTime ?? '07:30';
  final schoolEnd = data.schoolEndTime ?? '14:00';
  final hasCoaching = data.hasCoaching;
  final coachingStart = data.coachingStartTime ?? '15:00';
  final coachingEnd = data.coachingEndTime ?? '18:00';

  final u = const Uuid();

  for (final day in days) {
    final blocks = <TimeBlock>[
      TimeBlock(
        id: u.v4(),
        label: 'School',
        startTime: schoolStart,
        endTime: schoolEnd,
        type: TimeBlockType.school,
        isFree: false,
      ),
    ];

    if (hasCoaching) {
      blocks.add(TimeBlock(
        id: u.v4(),
        label: 'Coaching',
        startTime: coachingStart,
        endTime: coachingEnd,
        type: TimeBlockType.coaching,
        isFree: false,
      ));
    }

    schedule[day] = blocks;
  }

  return WeeklySchedule(
    schedule: schedule,
    discretionaryHoursWeekday: data.freeSlotsWeekdayHours,
    discretionaryHoursWeekend: data.freeSlotsWeekendHours,
  );
}

/// Provider that persists the onboarding profile to the database and sets
/// the in-memory student profile provider.
final persistOnboardingProfileProvider =
    Provider<Future<void> Function(StudentProfile)>((ref) {
  return (StudentProfile profile) async {
    // Set the in-memory provider so the rest of the app can use it immediately
    ref.read(studentProfileProvider.notifier).setProfile(profile);
  };
});