import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:sqlite3_flutter_libs/sqlite3_flutter_libs.dart';
import 'package:uuid/uuid.dart';
import 'dart:io';

import 'tables/all_tables.dart';
import 'daos/all_daos.dart';
import 'converters/type_converters.dart';
import '../models/student_profile.dart' hide Activity, StudentProfile;
import 'migrations/migrations.dart';

part 'database.g.dart';

@DriftDatabase(
  tables: [
    StudentProfiles,
    Activities,
    Missions,
    Opportunities,
    Skins,
    Streaks,
    Evidence,
    AdmissionsProbabilities,
    MissionProgresses,
    OpportunityApplications,
    SkinCollections,
    Notifications,
  ],
  daos: [
    StudentProfileDao,
    ActivityDao,
    MissionDao,
    OpportunityDao,
    SkinDao,
    StreakDao,
    EvidenceDao,
    AdmissionsProbabilityDao,
    MissionProgressDao,
    OpportunityApplicationDao,
    SkinCollectionDao,
    NotificationDao,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 7;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (Migrator m) async {
        await m.createAll();
        await _createUpdatedAtTriggers(m);
      },
      onUpgrade: (Migrator m, int from, int to) async {
        await migrationSteps(m, from, to);
      },
    );
  }

  static QueryExecutor _openConnection() {
    return LazyDatabase(() async {
      final dbFolder = await getApplicationDocumentsDirectory();
      final file = File(p.join(dbFolder.path, 'profileforge.sqlite3'));
      
      // Initialize sqlite3 for Android
      if (Platform.isAndroid) {
        await applyWorkaroundToOpenSqlite3OnOldAndroidVersions();
      }
      
      // Create directory if it doesn't exist
      await file.parent.create(recursive: true);
      
      // Copy pre-populated database from assets if it exists
      if (!await file.exists()) {
        try {
          final assetData = await rootBundle.load('assets/data/profileforge.sqlite3');
          await file.create(recursive: true);
          await file.writeAsBytes(assetData.buffer.asUint8List());
        } catch (_) {
          // Asset doesn't exist, will create fresh
        }
      }
      
      return NativeDatabase.createInBackground(file);
    });
  }

  Future<void> _createUpdatedAtTriggers(Migrator m) async {
    await m.database.customStatement('''
      CREATE TRIGGER IF NOT EXISTS update_student_profiles_timestamp
      AFTER UPDATE ON student_profiles
      BEGIN
        UPDATE student_profiles SET updated_at = strftime('%s', 'now') * 1000 WHERE id = NEW.id;
      END;
    ''');
    
    await m.database.customStatement('''
      CREATE TRIGGER IF NOT EXISTS update_activities_timestamp
      AFTER UPDATE ON activities
      BEGIN
        UPDATE activities SET updated_at = strftime('%s', 'now') * 1000 WHERE id = NEW.id;
      END;
    ''');
    
    await m.database.customStatement('''
      CREATE TRIGGER IF NOT EXISTS update_opportunities_timestamp
      AFTER UPDATE ON opportunities
      BEGIN
        UPDATE opportunities SET updated_at = strftime('%s', 'now') * 1000 WHERE id = NEW.id;
      END;
    ''');
    
    await m.database.customStatement('''
      CREATE TRIGGER IF NOT EXISTS update_skins_timestamp
      AFTER UPDATE ON skins
      BEGIN
        UPDATE skins SET updated_at = strftime('%s', 'now') * 1000 WHERE id = NEW.id;
      END;
    ''');
    
    await m.database.customStatement('''
      CREATE TRIGGER IF NOT EXISTS update_streaks_timestamp
      AFTER UPDATE ON streaks
      BEGIN
        UPDATE streaks SET updated_at = strftime('%s', 'now') * 1000 WHERE id = NEW.id;
      END;
    ''');
    
    await m.database.customStatement('''
      CREATE TRIGGER IF NOT EXISTS update_evidence_timestamp
      AFTER UPDATE ON evidence
      BEGIN
        UPDATE evidence SET updated_at = strftime('%s', 'now') * 1000 WHERE id = NEW.id;
      END;
    ''');
    
    await m.database.customStatement('''
      CREATE TRIGGER IF NOT EXISTS update_admissions_probabilities_timestamp
      AFTER UPDATE ON admissions_probabilities
      BEGIN
        UPDATE admissions_probabilities SET updated_at = strftime('%s', 'now') * 1000 WHERE id = NEW.id;
      END;
    ''');
    
    await m.database.customStatement('''
      CREATE TRIGGER IF NOT EXISTS update_mission_progresses_timestamp
      AFTER UPDATE ON mission_progresses
      BEGIN
        UPDATE mission_progresses SET last_updated_at = strftime('%s', 'now') * 1000 WHERE id = NEW.id;
      END;
    ''');
    
    await m.database.customStatement('''
      CREATE TRIGGER IF NOT EXISTS update_opportunity_applications_timestamp
      AFTER UPDATE ON opportunity_applications
      BEGIN
        UPDATE opportunity_applications SET updated_at = strftime('%s', 'now') * 1000 WHERE id = NEW.id;
      END;
    ''');
    
    await m.database.customStatement('''
      CREATE TRIGGER IF NOT EXISTS update_skin_collections_timestamp
      AFTER UPDATE ON skin_collections
      BEGIN
        UPDATE skin_collections SET updated_at = strftime('%s', 'now') * 1000 WHERE id = NEW.id;
      END;
    ''');
    
    await m.database.customStatement('''
      CREATE TRIGGER IF NOT EXISTS update_notifications_timestamp
      AFTER UPDATE ON notifications
      BEGIN
        UPDATE notifications SET created_at = strftime('%s', 'now') * 1000 WHERE id = NEW.id;
      END;
    ''');
  }
}