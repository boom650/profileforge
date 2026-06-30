import 'package:drift/drift.dart';

import '../tables/all_tables.dart';
import '../database.dart';

part 'opportunity_application_dao.g.dart';

@DriftAccessor(tables: [OpportunityApplications])
class OpportunityApplicationDao extends DatabaseAccessor<AppDatabase> with _$OpportunityApplicationDaoMixin {
  OpportunityApplicationDao(super.db);

  Future<OpportunityApplicationData?> getApplication(String studentId, String opportunityId) => 
      (select(opportunityApplications)
        ..where((oa) => oa.studentId.equals(studentId) & oa.opportunityId.equals(opportunityId)))
        .getSingleOrNull();

  Stream<OpportunityApplicationData?> watchApplication(String studentId, String opportunityId) => 
      (select(opportunityApplications)
        ..where((oa) => oa.studentId.equals(studentId) & oa.opportunityId.equals(opportunityId)))
        .watchSingleOrNull();

  Future<List<OpportunityApplicationData>> getStudentApplications(String studentId) => 
      (select(opportunityApplications)
        ..where((oa) => oa.studentId.equals(studentId))
        ..orderBy([(oa) => OrderingTerm.desc(oa.createdAt)]))
        .get();

  Stream<List<OpportunityApplicationData>> watchStudentApplications(String studentId) => 
      (select(opportunityApplications)
        ..where((oa) => oa.studentId.equals(studentId))
        ..orderBy([(oa) => OrderingTerm.desc(oa.createdAt)]))
        .watch();

  Future<List<OpportunityApplicationData>> getApplicationsByStatus(String studentId, String status) => 
      (select(opportunityApplications)
        ..where((oa) => oa.studentId.equals(studentId) & oa.status.equals(status)))
        .get();

  Future<int> upsertApplication(OpportunityApplicationsCompanion application) => 
      into(opportunityApplications).insertOnConflictUpdate(application);

  Future<void> updateStatus(String studentId, String opportunityId, String status) => 
      (update(opportunityApplications)
        ..where((oa) => oa.studentId.equals(studentId) & oa.opportunityId.equals(opportunityId)))
        .write(OpportunityApplicationsCompanion(
          status: Value(status),
          respondedAt: Value(status == 'accepted' || status == 'rejected' ? DateTime.now() : null),
          updatedAt: Value(DateTime.now()),
        ));

  Future<void> addDocument(String studentId, String opportunityId, String documentPath) async {
    final app = await getApplication(studentId, opportunityId);
    if (app == null) return;
    
    final docs = List<String>.from(app.documents);
    if (!docs.contains(documentPath)) {
      docs.add(documentPath);
      await (update(opportunityApplications)..where((oa) => oa.id.equals(app.id))).write(OpportunityApplicationsCompanion(
        documents: Value(docs),
        updatedAt: Value(DateTime.now()),
      ));
    }
  }

  Future<void> setReminder(String studentId, String opportunityId, int daysBefore) => 
      (update(opportunityApplications)
        ..where((oa) => oa.studentId.equals(studentId) & oa.opportunityId.equals(opportunityId)))
        .write(OpportunityApplicationsCompanion(
          reminderDaysBefore: Value(daysBefore),
          isReminderEnabled: const Value(true),
          updatedAt: Value(DateTime.now()),
        ));

  Future<int> getApplicationCount(String studentId) async {
    final result = await (selectOnly(opportunityApplications)
      ..addColumns([opportunityApplications.id.count()])
      ..where(opportunityApplications.studentId.equals(studentId)))
      .getSingle();
    return result.read(opportunityApplications.id.count()) ?? 0;
  }

  Future<int> getAcceptedCount(String studentId) async {
    final result = await (selectOnly(opportunityApplications)
      ..addColumns([opportunityApplications.id.count()])
      ..where(opportunityApplications.studentId.equals(studentId) & opportunityApplications.status.equals('accepted')))
      .getSingle();
    return result.read(opportunityApplications.id.count()) ?? 0;
  }

  Future<List<OpportunityApplicationData>> getUpcomingDeadlines(String studentId, {int days = 7}) => 
      (select(opportunityApplications)
        ..where((oa) => oa.studentId.equals(studentId) & 
          oa.status.isIn(['interested', 'preparing', 'applied', 'submitted']) &
          oa.isReminderEnabled.equals(true))
        ..join([innerJoin(opportunities, opportunities.id.equalsExp(opportunityApplications.opportunityId))])
        ..where(opportunities.applicationDeadline.isSmallerThanValue(DateTime.now().add(Duration(days: days)).millisecondsSinceEpoch))
        ..orderBy([(oa) => OrderingTerm.asc(opportunities.applicationDeadline)]))
        .get();
}