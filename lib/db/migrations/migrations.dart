import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:sqlite3/sqlite3.dart';

import '../tables/all_tables.dart';
import '../database.dart';

/// Migration from v1 to v2 - Add notification table and update indexes
Future<void> migrationV1ToV2(Migrator m, int from, int to) async {
  // Create notifications table
  await m.createTable(notifications);
  
  // Add indexes for better query performance
  await m.createIndex('idx_student_profiles_email', studentProfiles, columns: [studentProfiles.email]);
  await m.createIndex('idx_activities_student_id', activities, columns: [activities.studentId]);
  await m.createIndex('idx_mission_progresses_student_id', missionProgresses, columns: [missionProgresses.studentId]);
  await m.createIndex('idx_opportunity_applications_student_id', opportunityApplications, columns: [opportunityApplications.studentId]);
  await m.createIndex('idx_skin_collections_student_id', skinCollections, columns: [skinCollections.studentId]);
  await m.createIndex('idx_streaks_student_id', streaks, columns: [streaks.studentId]);
  await m.createIndex('idx_evidence_student_id', evidence, columns: [evidence.studentId]);
  await m.createIndex('idx_admissions_probabilities_student_id', admissionsProbabilities, columns: [admissionsProbabilities.studentId]);
  await m.createIndex('idx_notifications_student_id', notifications, columns: [notifications.studentId]);
  
  // Add composite indexes for common queries
  await m.createIndex('idx_mission_progresses_student_mission', missionProgresses, columns: [missionProgresses.studentId, missionProgresses.missionId]);
  await m.createIndex('idx_skin_collections_student_skin', skinCollections, columns: [skinCollections.studentId, skinCollections.skinId]);
  await m.createIndex('idx_opportunity_applications_student_opportunity', opportunityApplications, columns: [opportunityApplications.studentId, opportunityApplications.opportunityId]);
  
  // Add indexes for filtering
  await m.createIndex('idx_opportunities_deadline', opportunities, columns: [opportunities.applicationDeadline]);
  await m.createIndex('idx_opportunities_category_active', opportunities, columns: [opportunities.category, opportunities.isActive]);
  await m.createIndex('idx_admissions_probabilities_category', admissionsProbabilities, columns: [admissionsProbabilities.category]);
  await m.createIndex('idx_activities_category_tier', activities, columns: [activities.category, activities.tier]);
}

/// Migration from v2 to v3 - Add streak milestones and activity verification fields
Future<void> migrationV2ToV3(Migrator m, int from, int to) async {
  // Add streak milestones column if not exists (might need custom statement)
  await m.addColumn(streaks, streaks.milestoneRewards);
  
  // Add admissions score to activities
  await m.addColumn(activities, activities.admissionsScore);
  
  // Add verification fields to activities
  await m.addColumn(activities, activities.verifiedAt);
  await m.addColumn(activities, activities.verifiedBy);
  
  // Create trigger for auto-updating updatedAt timestamps
  await _createUpdatedAtTriggers(m);
}

Future<void> _createUpdatedAtTriggers(Migrator m) async {
  await m.runCustomStatement('''
    CREATE TRIGGER IF NOT EXISTS update_student_profiles_timestamp
    AFTER UPDATE ON student_profiles
    BEGIN
      UPDATE student_profiles SET updated_at = strftime('%s', 'now') * 1000 WHERE id = NEW.id;
    END;
  ''');
  
  await m.runCustomStatement('''
    CREATE TRIGGER IF NOT EXISTS update_activities_timestamp
    AFTER UPDATE ON activities
    BEGIN
      UPDATE activities SET updated_at = strftime('%s', 'now') * 1000 WHERE id = NEW.id;
    END;
  ''');
  
  await m.runCustomStatement('''
    CREATE TRIGGER IF NOT EXISTS update_opportunities_timestamp
    AFTER UPDATE ON opportunities
    BEGIN
      UPDATE opportunities SET updated_at = strftime('%s', 'now') * 1000 WHERE id = NEW.id;
    END;
  ''');
  
  await m.runCustomStatement('''
    CREATE TRIGGER IF NOT EXISTS update_skins_timestamp
    AFTER UPDATE ON skins
    BEGIN
      UPDATE skins SET updated_at = strftime('%s', 'now') * 1000 WHERE id = NEW.id;
    END;
  ''');
  
  await m.runCustomStatement('''
    CREATE TRIGGER IF NOT EXISTS update_streaks_timestamp
    AFTER UPDATE ON streaks
    BEGIN
      UPDATE streaks SET updated_at = strftime('%s', 'now') * 1000 WHERE id = NEW.id;
    END;
  ''');
  
  await m.runCustomStatement('''
    CREATE TRIGGER IF NOT EXISTS update_evidence_timestamp
    AFTER UPDATE ON evidence
    BEGIN
      UPDATE evidence SET updated_at = strftime('%s', 'now') * 1000 WHERE id = NEW.id;
    END;
  ''');
  
  await m.runCustomStatement('''
    CREATE TRIGGER IF NOT EXISTS update_admissions_probabilities_timestamp
    AFTER UPDATE ON admissions_probabilities
    BEGIN
      UPDATE admissions_probabilities SET updated_at = strftime('%s', 'now') * 1000 WHERE id = NEW.id;
    END;
  ''');
  
  await m.runCustomStatement('''
    CREATE TRIGGER IF NOT EXISTS update_mission_progresses_timestamp
    AFTER UPDATE ON mission_progresses
    BEGIN
      UPDATE mission_progresses SET last_updated_at = strftime('%s', 'now') * 1000 WHERE id = NEW.id;
    END;
  ''');
  
  await m.runCustomStatement('''
    CREATE TRIGGER IF NOT EXISTS update_opportunity_applications_timestamp
    AFTER UPDATE ON opportunity_applications
    BEGIN
      UPDATE opportunity_applications SET updated_at = strftime('%s', 'now') * 1000 WHERE id = NEW.id;
    END;
  ''');
  
  await m.runCustomStatement('''
    CREATE TRIGGER IF NOT EXISTS update_skin_collections_timestamp
    AFTER UPDATE ON skin_collections
    BEGIN
      UPDATE skin_collections SET updated_at = strftime('%s', 'now') * 1000 WHERE id = NEW.id;
    END;
  ''');
  
  await m.runCustomStatement('''
    CREATE TRIGGER IF NOT EXISTS update_notifications_timestamp
    AFTER UPDATE ON notifications
    BEGIN
      UPDATE notifications SET created_at = strftime('%s', 'now') * 1000 WHERE id = NEW.id;
    END;
  ''');
}

/// Migration from v3 to v4 - Add university cost and scholarship fields
Future<void> migrationV3ToV4(Migrator m, int from, int to) async {
  // Add estimated cost column to admissions_probabilities
  await m.addColumn(admissionsProbabilities, admissionsProbabilities.estimatedCost);
  
  // Add scholarships column
  await m.addColumn(admissionsProbabilities, admissionsProbabilities.scholarships);
  
  // Add application deadline column
  await m.addColumn(admissionsProbabilities, admissionsProbabilities.applicationDeadline);
}

/// Migration from v4 to v5 - Add evidence credibility score
Future<void> migrationV4ToV5(Migrator m, int from, int to) async {
  await m.addColumn(evidence, evidence.credibilityScore);
}

/// Migration from v5 to v6 - Add mission streak tracking
Future<void> migrationV5ToV6(Migrator m, int from, int to) async {
  await m.addColumn(missionProgresses, missionProgresses.streakCount);
}

/// Migration from v6 to v7 - Add notification scheduling
Future<void> migrationV6ToV7(Migrator m, int from, int to) async {
  await m.addColumn(notifications, notifications.scheduledAt);
  await m.addColumn(notifications, notifications.sentAt);
  await m.addColumn(notifications, notifications.readAt);
}

/// All migrations in order
final List<MigrationStrategy> migrationStrategies = [
  MigrationStrategy(
    onCreate: (Migrator m) async {
      await m.createAll();
      await _createUpdatedAtTriggers(m);
    },
    beforeOpen: (details) async {
      await details.connection.execute('PRAGMA foreign_keys = ON');
      await details.connection.execute('PRAGMA journal_mode = WAL');
      await details.connection.execute('PRAGMA synchronous = NORMAL');
      await details.connection.execute('PRAGMA cache_size = -32768'); // 32MB
      await details.connection.execute('PRAGMA temp_store = MEMORY');
    },
  ),
  MigrationStrategy(
    beforeOpen: (details) async {
      await details.connection.execute('PRAGMA foreign_keys = ON');
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
}

/// Export all migration utilities
export 'migrations.dart';