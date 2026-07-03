import 'package:drift/drift.dart';

import '../tables/all_tables.dart';
import '../converters/type_converters.dart';
import '../database.dart';

part 'opportunity_dao.g.dart';

@DriftAccessor(tables: [Opportunities, OpportunityApplications])
class OpportunityDao extends DatabaseAccessor<AppDatabase> with _$OpportunityDaoMixin {
  OpportunityDao(super.db);

  Future<List<Opportunity>> getAllOpportunities() => 
      (select(opportunities)..where((o) => o.isActive.equals(true))).get();

  Stream<List<Opportunity>> watchAllOpportunities() => 
      (select(opportunities)..where((o) => o.isActive.equals(true))).watch();

  Future<List<Opportunity>> getFeaturedOpportunities() => 
      (select(opportunities)
        ..where((o) => o.isActive.equals(true) & o.isFeatured.equals(true))
        ..orderBy([(o) => OrderingTerm.desc(o.createdAt)]))
        .get();

  Future<List<Opportunity>> getOpportunitiesByCategory(OpportunityCategory category) => 
      (select(opportunities)
        ..where((o) => o.isActive.equals(true) & o.category.equals(category.name))
        ..orderBy([(o) => OrderingTerm.asc(o.applicationDeadline)]))
        .get();

  Future<List<Opportunity>> getOpportunitiesByType(OpportunityType type) => 
      (select(opportunities)
        ..where((o) => o.isActive.equals(true) & o.type.equals(type.name))
        ..orderBy([(o) => OrderingTerm.asc(o.applicationDeadline)]))
        .get();

  Future<List<Opportunity>> getUpcomingDeadlines({int days = 30}) => 
      (select(opportunities)
        ..where((o) => o.isActive.equals(true) & 
            o.applicationDeadline.isBetweenValues(
              DateTime.now().millisecondsSinceEpoch,
              DateTime.now().add(Duration(days: days)).millisecondsSinceEpoch,
            ))
        ..orderBy([(o) => OrderingTerm.asc(o.applicationDeadline)]))
        .get();

  Future<List<Opportunity>> getOpportunitiesForStudent(String studentId) async {
    final student = await db.studentProfileDao.getProfile(studentId);
    if (student == null) return [];

    return (select(opportunities)
      ..where((o) => o.isActive.equals(true) & 
          (o.minGrade.isNull() | o.minGrade.isSmallerOrEqualValue(student.grade ?? 0)) &
          (o.maxGrade.isNull() | o.maxGrade.isBiggerOrEqualValue(student.grade ?? 0))))
      .get();
  }

  Future<Opportunity?> getOpportunity(String id) => 
      (select(opportunities)..where((o) => o.id.equals(id))).getSingleOrNull();

  Future<int> insertOpportunity(OpportunitiesCompanion opportunity) => 
      into(opportunities).insert(opportunity);

  Future<bool> updateOpportunity(OpportunitiesCompanion opportunity) => 
      update(opportunities).replace(opportunity);

  Future<int> deleteOpportunity(String id) => 
      (delete(opportunities)..where((o) => o.id.equals(id))).go();

  Future<void> incrementViews(String id) async => 
      (update(opportunities)..where((o) => o.id.equals(id))).write(OpportunitiesCompanion(
        views: Value(((await getOpportunity(id))?.views ?? 0) + 1),
        updatedAt: Value(DateTime.now().millisecondsSinceEpoch),
      ));

  // Opportunity Applications
  Future<OpportunityApplication?> getApplication(String studentId, String opportunityId) => 
      (select(opportunityApplications)
        ..where((oa) => oa.studentId.equals(studentId) & oa.opportunityId.equals(opportunityId)))
        .getSingleOrNull();

  Stream<OpportunityApplication?> watchApplication(String studentId, String opportunityId) => 
      (select(opportunityApplications)
        ..where((oa) => oa.studentId.equals(studentId) & oa.opportunityId.equals(opportunityId)))
        .watchSingleOrNull();

  Future<List<OpportunityApplication>> getStudentApplications(String studentId) => 
      (select(opportunityApplications)
        ..where((oa) => oa.studentId.equals(studentId))
        ..orderBy([(oa) => OrderingTerm.desc(oa.createdAt)]))
        .get();

  Future<int> upsertApplication(OpportunityApplicationsCompanion application) => 
      into(opportunityApplications).insertOnConflictUpdate(application);

  Future<void> applyToOpportunity(String studentId, String opportunityId, {
    Map<String, String>? applicationData,
    List<String>? documents,
    String? notes,
  }) async {
    await upsertApplication(OpportunityApplicationsCompanion(
      studentId: Value(studentId),
      opportunityId: Value(opportunityId),
      applicationData: Value(applicationData ?? {},),
      documents: Value(documents ?? []),
      notes: Value(notes),
      status: const Value('pending'),
      appliedAt: Value(DateTime.now()),
      createdAt: Value(DateTime.now()),
    ));
  }
}