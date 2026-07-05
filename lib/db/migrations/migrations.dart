import 'package:drift/drift.dart';

import '../tables/all_tables.dart';
import '../database.dart';

/// Helper to get the AppDatabase from the Migrator
AppDatabase _db(Migrator m) => m.database as AppDatabase;

/// Migration from v1 to v2 - Add notification table and update indexes
Future<void> migrationV1ToV2(Migrator m, int from, int to) async {
  // Create notifications table
  await m.createTable(_db(m).notifications);
  
  // Add indexes for better query performance
  await m.createIndex(Index.byDialect('idx_student_profiles_email', {SqlDialect.sqlite: 'CREATE INDEX idx_student_profiles_email ON student_profiles (email)'}));
  await m.createIndex(Index.byDialect('idx_activities_student_id', {SqlDialect.sqlite: 'CREATE INDEX idx_activities_student_id ON activities (studentId)'}));
  await m.createIndex(Index.byDialect('idx_mission_progresses_student_id', {SqlDialect.sqlite: 'CREATE INDEX idx_mission_progresses_student_id ON mission_progresses (studentId)'}));
  await m.createIndex(Index.byDialect('idx_opportunity_applications_student_id', {SqlDialect.sqlite: 'CREATE INDEX idx_opportunity_applications_student_id ON opportunity_applications (studentId)'}));
  await m.createIndex(Index.byDialect('idx_skin_collections_student_id', {SqlDialect.sqlite: 'CREATE INDEX idx_skin_collections_student_id ON skin_collections (studentId)'}));
  await m.createIndex(Index.byDialect('idx_streaks_student_id', {SqlDialect.sqlite: 'CREATE INDEX idx_streaks_student_id ON streaks (studentId)'}));
  await m.createIndex(Index.byDialect('idx_evidence_student_id', {SqlDialect.sqlite: 'CREATE INDEX idx_evidence_student_id ON evidence (studentId)'}));
  await m.createIndex(Index.byDialect('idx_admissions_probabilities_student_id', {SqlDialect.sqlite: 'CREATE INDEX idx_admissions_probabilities_student_id ON admissions_probabilities (studentId)'}));
  await m.createIndex(Index.byDialect('idx_notifications_student_id', {SqlDialect.sqlite: 'CREATE INDEX idx_notifications_student_id ON notifications (studentId)'}));
  
  // Add composite indexes for common queries
  await m.createIndex(Index.byDialect('idx_mission_progresses_student_mission', {SqlDialect.sqlite: 'CREATE INDEX idx_mission_progresses_student_mission ON mission_progresses (studentId, missionId)'}));
  await m.createIndex(Index.byDialect('idx_skin_collections_student_skin', {SqlDialect.sqlite: 'CREATE INDEX idx_skin_collections_student_skin ON skin_collections (studentId, skinId)'}));
  await m.createIndex(Index.byDialect('idx_opportunity_applications_student_opportunity', {SqlDialect.sqlite: 'CREATE INDEX idx_opportunity_applications_student_opportunity ON opportunity_applications (studentId, opportunityId)'}));
  
  // Add indexes for filtering
  await m.createIndex(Index.byDialect('idx_opportunities_deadline', {SqlDialect.sqlite: 'CREATE INDEX idx_opportunities_deadline ON opportunities (applicationDeadline)'}));
  await m.createIndex(Index.byDialect('idx_opportunities_category_active', {SqlDialect.sqlite: 'CREATE INDEX idx_opportunities_category_active ON opportunities (category, isActive)'}));
  await m.createIndex(Index.byDialect('idx_admissions_probabilities_category', {SqlDialect.sqlite: 'CREATE INDEX idx_admissions_probabilities_category ON admissions_probabilities (category)'}));
  await m.createIndex(Index.byDialect('idx_activities_category_tier', {SqlDialect.sqlite: 'CREATE INDEX idx_activities_category_tier ON activities (category, tier)'}));
}

/// Migration from v2 to v3 - Add streak milestones and activity verification fields
Future<void> migrationV2ToV3(Migrator m, int from, int to) async {
  // Add streak milestones column if not exists (might need custom statement)
  await m.addColumn(_db(m).streaks, _db(m).streaks.milestoneRewards);
  
  // Add admissions score to activities
  await m.addColumn(_db(m).activities, _db(m).activities.admissionsScore);
  
  // Add verification fields to activities
  await m.addColumn(_db(m).activities, _db(m).activities.verifiedAt);
  await m.addColumn(_db(m).activities, _db(m).activities.verifiedBy);
}

// Triggers removed — timestamps are updated directly in DAO code.
// The old triggers caused infinite recursion by UPDATE-ing the same table they fire on.

/// Migration from v3 to v4 - Add university cost and scholarship fields
Future<void> migrationV3ToV4(Migrator m, int from, int to) async {
  // Add estimated cost column to admissions_probabilities
  await m.addColumn(_db(m).admissionsProbabilities, _db(m).admissionsProbabilities.estimatedCost);
  
  // Add scholarships column
  await m.addColumn(_db(m).admissionsProbabilities, _db(m).admissionsProbabilities.scholarships);
  
  // Add application deadline column
  await m.addColumn(_db(m).admissionsProbabilities, _db(m).admissionsProbabilities.applicationDeadline);
}

/// Migration from v4 to v5 - Add evidence credibility score
Future<void> migrationV4ToV5(Migrator m, int from, int to) async {
  await m.addColumn(_db(m).evidence, _db(m).evidence.credibilityScore);
}

/// Migration from v5 to v6 - Add mission streak tracking
Future<void> migrationV5ToV6(Migrator m, int from, int to) async {
  await m.addColumn(_db(m).missionProgresses, _db(m).missionProgresses.streakCount);
}

/// Migration from v6 to v7 - Add notification scheduling
Future<void> migrationV6ToV7(Migrator m, int from, int to) async {
  await m.addColumn(_db(m).notifications, _db(m).notifications.scheduledAt);
  await m.addColumn(_db(m).notifications, _db(m).notifications.sentAt);
  await m.addColumn(_db(m).notifications, _db(m).notifications.readAt);
}

/// Migration from v7 to v8 - Add Common App fields to activities
Future<void> migrationV7ToV8(Migrator m, int from, int to) async {
  await m.addColumn(_db(m).activities, _db(m).activities.position);
  await m.addColumn(_db(m).activities, _db(m).activities.organizationName);
  await m.addColumn(_db(m).activities, _db(m).activities.gradeLevels);
  await m.addColumn(_db(m).activities, _db(m).activities.isContinuousYearRound);
}

/// All migrations in order
final List<MigrationStrategy> migrationStrategies = [
  MigrationStrategy(
    onCreate: (Migrator m) async {
      await m.createAll();
    },
  ),
];

/// Migration steps for onUpgrade
Future<void> migrationSteps(Migrator m, int from, int to) async {
  if (from < 2 && to >= 2) {
    await migrationV1ToV2(m, from, to);
  }
  if (from < 3 && to >= 3) {
    await migrationV2ToV3(m, from, to);
  }
  if (from < 4 && to >= 4) {
    await migrationV3ToV4(m, from, to);
  }
  if (from < 5 && to >= 5) {
    await migrationV4ToV5(m, from, to);
  }
  if (from < 6 && to >= 6) {
    await migrationV5ToV6(m, from, to);
  }
  if (from < 7 && to >= 7) {
    await migrationV6ToV7(m, from, to);
  }
  if (from < 8 && to >= 8) {
    await migrationV7ToV8(m, from, to);
  }
}
