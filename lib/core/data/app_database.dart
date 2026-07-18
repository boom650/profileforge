import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'tables.dart';

part 'app_database.g.dart';

/// Application-wide Drift database.
/// Offline-first: all gamification state lives here on-device.
@DriftDatabase(tables: [
  Profiles,
  XpEvents,
  Streaks,
  SkinUnlocks,
  Missions,
  LeagueMemberships,
  Buddies,
  Teams,
  TeamMembers,
])
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor])
      : super(executor ?? driftDatabase(name: 'profileforge'));

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) => m.createAll(),
        onUpgrade: (m, from, to) async {
          // Future migrations go here with `m.addColumn` etc.
          // Safe, incremental, never destructive.
        },
      );
}
