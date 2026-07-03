import 'package:drift/drift.dart';

import '../tables/all_tables.dart';
import '../database.dart';
import '../converters/type_converters.dart';

part 'admissions_probability_dao.g.dart';

@DriftAccessor(tables: [AdmissionsProbabilities])
class AdmissionsProbabilityDao extends DatabaseAccessor<AppDatabase> with _$AdmissionsProbabilityDaoMixin {
  AdmissionsProbabilityDao(super.db);

  Future<List<AdmissionsProbability>> getAllProbabilities(String studentId) => 
      (select(admissionsProbabilities)
        ..where((p) => p.studentId.equals(studentId))
        ..orderBy([(p) => OrderingTerm.desc(p.calculatedAt)]))
        .get();

  Stream<List<AdmissionsProbability>> watchProbabilities(String studentId) => 
      (select(admissionsProbabilities)
        ..where((p) => p.studentId.equals(studentId))
        ..orderBy([(p) => OrderingTerm.desc(p.calculatedAt)]))
        .watch();

  Future<List<AdmissionsProbability>> getProbabilitiesByCategory(String studentId, UniversityCategory category) => 
      (select(admissionsProbabilities)
        ..where((p) => p.studentId.equals(studentId) & p.category.equals(category.name))
        ..orderBy([(p) => OrderingTerm.desc(p.overallProbability)]))
        .get();

  Future<AdmissionsProbability?> getProbability(String id) => 
      (select(admissionsProbabilities)..where((p) => p.id.equals(id))).getSingleOrNull();

  Future<AdmissionsProbability?> getLatestForUniversity(String studentId, String universityName) => 
      (select(admissionsProbabilities)
        ..where((p) => p.studentId.equals(studentId) & p.universityName.equals(universityName))
        ..orderBy([(p) => OrderingTerm.desc(p.calculatedAt)]))
        .getSingleOrNull();

  Future<int> insertProbability(AdmissionsProbabilitiesCompanion probability) => 
      into(admissionsProbabilities).insert(probability);

  Future<bool> updateProbability(AdmissionsProbabilitiesCompanion probability) => 
      update(admissionsProbabilities).replace(probability);

  Future<int> deleteProbability(String id) => 
      (delete(admissionsProbabilities)..where((p) => p.id.equals(id))).go();

  Future<void> upsertProbability(AdmissionsProbabilitiesCompanion probability) => 
      into(admissionsProbabilities).insertOnConflictUpdate(probability);

  Future<void> updateApplicationStatus(String id, String status) => 
      (update(admissionsProbabilities)..where((p) => p.id.equals(id))).write(AdmissionsProbabilitiesCompanion(
        applicationStatus: Value(status),
        updatedAt: Value(DateTime.now()),
      ));

  Future<int> getReachCount(String studentId) async {
    final result = await (selectOnly(admissionsProbabilities)
      ..addColumns([admissionsProbabilities.id.count()])
      ..where(admissionsProbabilities.studentId.equals(studentId) & admissionsProbabilities.category.equals('reach')))
      .getSingle();
    return result.read(admissionsProbabilities.id.count()) ?? 0;
  }

  Future<int> getMatchCount(String studentId) async {
    final result = await (selectOnly(admissionsProbabilities)
      ..addColumns([admissionsProbabilities.id.count()])
      ..where(admissionsProbabilities.studentId.equals(studentId) & admissionsProbabilities.category.equals('match')))
      .getSingle();
    return result.read(admissionsProbabilities.id.count()) ?? 0;
  }

  Future<int> getSafetyCount(String studentId) async {
    final result = await (selectOnly(admissionsProbabilities)
      ..addColumns([admissionsProbabilities.id.count()])
      ..where(admissionsProbabilities.studentId.equals(studentId) & admissionsProbabilities.category.equals('safety')))
      .getSingle();
    return result.read(admissionsProbabilities.id.count()) ?? 0;
  }

  Future<Map<UniversityCategory, double>> getAverageProbabilities(String studentId) async {
    final avgExpr = admissionsProbabilities.overallProbability.avg();
    final rows = await (selectOnly(admissionsProbabilities)
      ..addColumns([admissionsProbabilities.category, avgExpr])
      ..where(admissionsProbabilities.studentId.equals(studentId))
      ..groupBy([admissionsProbabilities.category]))
      .get();

    final Map<UniversityCategory, double> result = {};
    for (final row in rows) {
      final category = UniversityCategory.values.firstWhere(
        (e) => e.name == row.read(admissionsProbabilities.category),
        orElse: () => UniversityCategory.target,
      );
      result[category] = row.read(avgExpr) ?? 0.0;
    }
    return result;
  }

  Future<List<AdmissionsProbability>> getUpcomingDeadlines(String studentId, {int days = 30}) => 
      (select(admissionsProbabilities)
        ..where((p) => p.studentId.equals(studentId) & 
          p.applicationStatus.isIn(['planning', 'preparing', 'submitted']) &
          p.applicationDeadline.isNotNull() &
          p.applicationDeadline.isSmallerOrEqualValue(DateTime.now().add(Duration(days: days)).millisecondsSinceEpoch))
        ..orderBy([(p) => OrderingTerm.asc(p.applicationDeadline)]))
        .get();
}