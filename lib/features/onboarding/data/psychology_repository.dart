import 'package:drift/drift.dart';
import 'package:profileforge/core/ai/psychological_profile.dart';
import 'package:profileforge/core/data/app_database.dart';

/// Repository that persists a student's [PsychologicalProfile] so the AI
/// adapter can stay behavior-consistent across sessions.
///
/// Previously the psych profile was built in onboarding and immediately
/// discarded — this closes that gap (v7).
class PsychologyRepository {
  PsychologyRepository(this._db);
  final AppDatabase _db;

  Future<void> save(PsychologicalProfile p, String profileId) async {
    await _db.into(_db.psychologicalProfiles).insertOnConflictUpdate(
          PsychologicalProfilesCompanion(
            profileId: Value(profileId),
            openness: Value(p.openness),
            conscientiousness: Value(p.conscientiousness),
            extraversion: Value(p.extraversion),
            agreeableness: Value(p.agreeableness),
            neuroticism: Value(p.neuroticism),
            autonomy: Value(p.autonomy),
            competence: Value(p.competence),
            relatedness: Value(p.relatedness),
            growthMindset: Value(p.growthMindset),
            selfEfficacy: Value(p.selfEfficacy),
            emotionalIntelligence: Value(p.emotionalIntelligence),
            communicationStyle: Value(p.communicationStyle.name),
            motivationFrame: Value(p.motivationFrame.name),
            supportLevel: Value(p.supportLevel.name),
            structurePreference: Value(p.structurePreference.name),
            assessedAt: Value(DateTime.now()),
          ),
        );
  }

  Future<PsychologicalProfile?> load(String profileId) async {
    final row = await (_db.select(_db.psychologicalProfiles)
          ..where((t) => t.profileId.equals(profileId)))
        .getSingleOrNull();
    if (row == null) return null;
    return _fromRow(row);
  }

  Future<void> delete(String profileId) async {
    await (_db.delete(_db.psychologicalProfiles)
          ..where((t) => t.profileId.equals(profileId)))
        .go();
  }

  PsychologicalProfile _fromRow(PsychologicalProfileRow row) {
    return PsychologicalProfile(
      openness: row.openness,
      conscientiousness: row.conscientiousness,
      extraversion: row.extraversion,
      agreeableness: row.agreeableness,
      neuroticism: row.neuroticism,
      autonomy: row.autonomy,
      competence: row.competence,
      relatedness: row.relatedness,
      growthMindset: row.growthMindset,
      selfEfficacy: row.selfEfficacy,
      emotionalIntelligence: row.emotionalIntelligence,
      communicationStyle: _enumByName(
        CommunicationStyle.values,
        row.communicationStyle,
        CommunicationStyle.balanced,
      ),
      motivationFrame: _enumByName(
        MotivationFrame.values,
        row.motivationFrame,
        MotivationFrame.balanced,
      ),
      supportLevel: _enumByName(
        SupportLevel.values,
        row.supportLevel,
        SupportLevel.moderate,
      ),
      structurePreference: _enumByName(
        StructurePreference.values,
        row.structurePreference,
        StructurePreference.moderate,
      ),
    );
  }

  T _enumByName<T extends Enum>(List<T> values, String name, T fallback) {
    for (final v in values) {
      if (v.name == name) return v;
    }
    return fallback;
  }
}
