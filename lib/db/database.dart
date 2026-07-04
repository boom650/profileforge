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
import '../models/gamification/missions.dart'
    show MissionCategory, MissionType, MissionDifficulty;
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

  // Timestamps are now updated directly in DAO code instead of via triggers.
  // Triggers caused infinite recursion by UPDATE-ing the same table they fire on.
}