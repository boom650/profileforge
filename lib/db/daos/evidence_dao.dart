import 'package:drift/drift.dart';

import '../tables/all_tables.dart';
import '../database.dart';

part 'evidence_dao.g.dart';

@DriftAccessor(tables: [Evidence])
class EvidenceDao extends DatabaseAccessor<AppDatabase> with _$EvidenceDaoMixin {
  EvidenceDao(super.db);

  Future<List<EvidenceData>> getAllEvidence(String studentId) => 
      (select(evidence)..where((e) => e.studentId.equals(studentId))..orderBy([(e) => OrderingTerm.desc(e.createdAt)])).get();

  Stream<List<EvidenceData>> watchEvidence(String studentId) => 
      (select(evidence)..where((e) => e.studentId.equals(studentId))..orderBy([(e) => OrderingTerm.desc(e.createdAt)])).watch();

  Future<List<EvidenceData>> getEvidenceByActivity(String activityId) => 
      (select(evidence)..where((e) => e.activityId.equals(activityId))..orderBy([(e) => OrderingTerm.desc(e.createdAt)])).get();

  Future<EvidenceData?> getEvidence(String id) => 
      (select(evidence)..where((e) => e.id.equals(id))).getSingleOrNull();

  Future<int> insertEvidence(EvidenceCompanion evidenceData) => 
      into(evidence).insert(evidenceData);

  Future<bool> updateEvidence(EvidenceCompanion evidenceData) => 
      update(evidence).replace(evidenceData);

  Future<int> deleteEvidence(String id) => 
      (delete(evidence)..where((e) => e.id.equals(id))).go();

  Future<void> updateVerificationStatus(String id, String status, {String? verifiedBy, String? notes}) => 
      (update(evidence)..where((e) => e.id.equals(id))).write(EvidenceCompanion(
        verificationStatus: Value(status),
        verifiedBy: Value(verifiedBy),
        verifiedAt: Value(['verified', 'rejected'].contains(status) ? DateTime.now() : null),
        verificationNotes: Value(notes),
        updatedAt: Value(DateTime.now()),
      ));

  Future<int> getEvidenceCount(String studentId) async {
    final result = await (selectOnly(evidence)
      ..addColumns([evidence.id.count()])
      ..where(evidence.studentId.equals(studentId)))
      .getSingle();
    return result.read(evidence.id.count()) ?? 0;
  }

  Future<int> getVerifiedCount(String studentId) async {
    final result = await (selectOnly(evidence)
      ..addColumns([evidence.id.count()])
      ..where(evidence.studentId.equals(studentId) & evidence.verificationStatus.equals('verified')))
      .getSingle();
    return result.read(evidence.id.count()) ?? 0;
  }

  Future<double> getAverageCredibility(String studentId) async {
    final result = await (selectOnly(evidence)
      ..addColumns([evidence.credibilityScore.average()])
      ..where(evidence.studentId.equals(studentId)))
      .getSingle();
    return result.read(evidence.credibilityScore.average()) ?? 0.0;
  }
}