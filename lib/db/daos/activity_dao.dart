import 'package:drift/drift.dart';

import '../tables/all_tables.dart';
import '../database.dart';
import '../../models/student_profile.dart' hide Activity, StudentProfile;

part 'activity_dao.g.dart';

@DriftAccessor(tables: [Activities])
class ActivityDao extends DatabaseAccessor<AppDatabase> with _$ActivityDaoMixin {
  ActivityDao(super.db);

  Future<List<Activity>> getAllActivities(String studentId) => 
      (select(activities)..where((a) => a.studentId.equals(studentId))).get();

  Stream<List<Activity>> watchActivities(String studentId) => 
      (select(activities)..where((a) => a.studentId.equals(studentId))).watch();

  Future<List<Activity>> getActivitiesByCategory(String studentId, ActivityCategory category) => 
      (select(activities)
        ..where((a) => a.studentId.equals(studentId) & a.category.equals(category.name)))
        .get();

  Future<Activity?> getActivity(String id) => 
      (select(activities)..where((a) => a.id.equals(id))).getSingleOrNull();

  Future<int> insertActivity(ActivitiesCompanion activity) => 
      into(activities).insert(activity);

  Future<bool> updateActivity(ActivitiesCompanion activity) => 
      update(activities).replace(activity);

  Future<int> deleteActivity(String id) => 
      (delete(activities)..where((a) => a.id.equals(id))).go();

  Future<void> updateVerificationStatus(String id, String status, {String? verifiedBy}) => 
      (update(activities)..where((a) => a.id.equals(id))).write(ActivitiesCompanion(
        verificationStatus: Value(status),
        verifiedAt: Value(status == 'verified' ? DateTime.now() : null),
        verifiedBy: Value(verifiedBy),
        updatedAt: Value(DateTime.now()),
      ));

  Future<int> getTotalHours(String studentId) async {
    final result = await (selectOnly(activities)
      ..addColumns([activities.totalHours.sum()])
      ..where(activities.studentId.equals(studentId)))
      .getSingle();
    return result.read(activities.totalHours.sum()) ?? 0;
  }

  Future<int> getTotalAdmissionsValue(String studentId) async {
    final result = await (selectOnly(activities)
      ..addColumns([activities.admissionsValue.sum()])
      ..where(activities.studentId.equals(studentId)))
      .getSingle();
    return result.read(activities.admissionsValue.sum()) ?? 0;
  }

  Future<Map<ActivityCategory, int>> getHoursByCategory(String studentId) async {
    final rows = await (selectOnly(activities)
      ..addColumns([activities.category, activities.totalHours.sum()])
      ..where(activities.studentId.equals(studentId))
      ..groupBy([activities.category]))
      .get();

    final Map<ActivityCategory, int> result = {};
    for (final row in rows) {
      final category = ActivityCategory.values.firstWhere(
        (e) => e.name == row.read(activities.category)!,
        orElse: () => ActivityCategory.unique,
      );
      result[category] = row.read(activities.totalHours.sum()) ?? 0;
    }
    return result;
  }

  Future<Map<ActivityTier, int>> getCountByTier(String studentId) async {
    final rows = await (selectOnly(activities)
      ..addColumns([activities.tier, activities.id.count()])
      ..where(activities.studentId.equals(studentId))
      ..groupBy([activities.tier]))
      .get();

    final Map<ActivityTier, int> result = {};
    for (final row in rows) {
      final tier = ActivityTier.values.firstWhere(
        (e) => e.name == row.read(activities.tier)!,
        orElse: () => ActivityTier.tier4,
      );
      result[tier] = row.read(activities.id.count()) ?? 0;
    }
    return result;
  }

  Future<List<Activity>> getVerifiedActivities(String studentId) => 
      (select(activities)
        ..where((a) => a.studentId.equals(studentId) & a.verificationStatus.equals('verified')))
        .get();

  Future<int> getActivityCount(String studentId) async {
    final result = await (selectOnly(activities)
      ..addColumns([activities.id.count()])
      ..where(activities.studentId.equals(studentId)))
      .getSingle();
    return result.read(activities.id.count()) ?? 0;
  }
}