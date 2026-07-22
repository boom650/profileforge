import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:profileforge/core/data/tables.dart';
import 'package:profileforge/features/skins/data/skin_table.dart';

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
  BuddyCheckIns,
  TeamChallenges,
  Onboarding,
  SyncOutbox,
  SkinStates,
  Wallets,
  DailyRewards,
  FocusSessions,
  AchievementDefinitions,
  AchievementUnlocks,
  DailyQuests,
  UserGoals,
  FriendChallenges,
])
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor])
      : super(executor ?? driftDatabase(name: 'profileforge'));

  @override
  int get schemaVersion => 3;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) => m.createAll(),
        onUpgrade: (m, from, to) async {
          if (from < 2) {
            await m.createTable(wallets);
            await m.createTable(dailyRewards);
          }
          if (from < 3) {
            await m.createTable(focusSessions);
            await m.createTable(achievementDefinitions);
            await m.createTable(achievementUnlocks);
            await m.createTable(dailyQuests);
            await m.createTable(userGoals);
            await m.createTable(friendChallenges);
          }
        },
      );
}
