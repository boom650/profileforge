import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:drift/drift.dart';
import 'package:profileforge/core/data/app_database.dart';
import 'package:profileforge/features/onboarding/domain/onboarding_models.dart';

/// Encodes an OnboardingProfile to its Drift text-column JSON off the UI thread.
Future<_OnboardJson> _encode(OnboardingProfile p) => compute(_runEncode, p);

class _OnboardJson {
  const _OnboardJson(this.universities, this.subjects, this.grades, this.clubs, this.careers);
  final String universities, subjects, grades, clubs, careers;
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
      clubs: Value(j.clubs), // activities stored in `clubs` column
      budget: Value(p.budget),
      travelRadiusKm: Value(p.travelRadiusKm),
      availabilityHoursPerWeek: Value(p.availabilityHoursPerWeek),
      careerInterests: Value(j.careers),
      location: Value(p.competitionsPersistJson), // competitions stored in `location`
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
}
