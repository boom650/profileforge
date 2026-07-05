import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import 'connection/connection_native.dart'
    if (dart.library.js_interop) 'connection/connection_web.dart';

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
  AppDatabase() : super(createConnection());

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
}
