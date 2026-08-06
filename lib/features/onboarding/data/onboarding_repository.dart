import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:drift/drift.dart';
import 'package:profileforge/core/data/app_database.dart';
import 'package:profileforge/features/onboarding/domain/onboarding_models.dart';

Future<_OnboardJson> _encode(OnboardingProfile p) => compute(_runEncode, p);

class _OnboardJson {
  final String universities, subjects, grades, clubs, careers;
  const _OnboardJson(
    this.universities,
    this.subjects,
    this.grades,
    this.clubs,
    this.careers,
  );
}

_OnboardJson _runEncode(OnboardingProfile p) => _OnboardJson(
      jsonEncode(p.targetUniversities),
      jsonEncode(p.subjects),
      jsonEncode(p.grades),
      jsonEncode(p.activities),
      jsonEncode(p.careerInterests),
    );

class OnboardingRepository {
  OnboardingRepository(this._db);
  final AppDatabase _db;

  Future<void> save(OnboardingProfile p) async {
    final j = await _encode(p);
    await _db.into(_db.onboarding).insertOnConflictUpdate(OnboardingCompanion(
      profileId: Value(p.profileId),
      targetUniversities: Value(j.universities),
      subjects: Value(j.subjects),
      grades: Value(j.grades),
      clubs: Value(j.clubs),
      budget: Value(p.budget),
      travelRadiusKm: Value(p.travelRadiusKm),
      availabilityHoursPerWeek: Value(p.availabilityHoursPerWeek),
      careerInterests: Value(j.careers),
      location: Value(p.competitionsPersistJson),
    ));
  }

  Future<void> saveSchedule(ScheduleProfile s, String profileId) async {
    await _db.into(_db.onboarding).insertOnConflictUpdate(OnboardingCompanion(
      profileId: Value(profileId),
      schoolDays: Value(jsonEncode(s.schoolDays)),
      schoolStartHour: Value(s.schoolStartHour),
      schoolStartMinute: Value(s.schoolStartMinute),
      schoolEndHour: Value(s.schoolEndHour),
      schoolEndMinute: Value(s.schoolEndMinute),
      energyPeak: Value(s.energyPeak),
      sleepStart: Value(s.sleepStart),
      sleepEnd: Value(s.sleepEnd),
      timelineGoal: Value(s.timelineGoal),
      screenTimeHours: Value(s.screenTimeHours),
      studyEnvironment: Value(s.studyEnvironment),
      socialMediaUsage: Value(s.socialMediaUsage),
    ));
  }

  Future<OnboardingProfile?> load(String profileId) async {
    final row = await (_db.select(_db.onboarding)
          ..where((t) => t.profileId.equals(profileId)))
        .getSingleOrNull();
    if (row == null) return null;
    return OnboardingProfile.fromRow(
      profileId: row.profileId,
      targetUniversities: row.targetUniversities,
      subjects: row.subjects,
      grades: row.grades,
      clubs: row.clubs,
      budget: row.budget,
      travelRadiusKm: row.travelRadiusKm,
      availabilityHoursPerWeek: row.availabilityHoursPerWeek,
      careerInterests: row.careerInterests,
      location: row.location,
    );
  }

  /// Persist essay material (story seed, values, curiosity, prompt pref).
  Future<void> saveEssay(EssayContext e, String profileId) async {
    await _db.into(_db.onboarding).insertOnConflictUpdate(OnboardingCompanion(
      profileId: Value(profileId),
      essayStory: Value(e.story),
      essayValues: Value(e.valuesPersistJson),
      essayCuriosity: Value(e.curiosity),
      essayPromptPref: Value(e.promptPref),
    ));
  }

  /// Load essay material (falls back to empty context).
  Future<EssayContext> loadEssay(String profileId) async {
    final row = await (_db.select(_db.onboarding)
          ..where((t) => t.profileId.equals(profileId)))
        .getSingleOrNull();
    if (row == null) return const EssayContext();
    return EssayContext.fromRow(
      story: row.essayStory,
      valuesJson: row.essayValues,
      curiosity: row.essayCuriosity,
      promptPref: row.essayPromptPref,
    );
  }

  Future<ScheduleProfile?> loadSchedule(String profileId) async {
    final row = await (_db.select(_db.onboarding)
          ..where((t) => t.profileId.equals(profileId)))
        .getSingleOrNull();
    if (row == null) return null;
    List<int> schoolDays = [1, 2, 3, 4, 5];
    try {
      schoolDays = List<int>.from(jsonDecode(row.schoolDays));
    } catch (_) {}
    return ScheduleProfile(
      schoolDays: schoolDays,
      schoolStartHour: row.schoolStartHour,
      schoolStartMinute: row.schoolStartMinute,
      schoolEndHour: row.schoolEndHour,
      schoolEndMinute: row.schoolEndMinute,
      energyPeak: row.energyPeak,
      sleepStart: row.sleepStart,
      sleepEnd: row.sleepEnd,
      timelineGoal: row.timelineGoal,
      screenTimeHours: row.screenTimeHours,
      studyEnvironment: row.studyEnvironment,
      socialMediaUsage: row.socialMediaUsage,
    );
  }
}
