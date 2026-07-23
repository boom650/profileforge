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
  XpDebt,
])
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor])
      : super(executor ?? driftDatabase(name: 'profileforge'));

  @override
  int get schemaVersion => 4;

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
            await m.createTable(xpDebt);
          }
          if (from < 4) {
            // Extended onboarding columns (v4): schedule, energy, timeline.
            await m.addColumn(onboarding, onboarding.schoolDays);
            await m.addColumn(onboarding, onboarding.schoolStartHour);
            await m.addColumn(onboarding, onboarding.schoolStartMinute);
            await m.addColumn(onboarding, onboarding.schoolEndHour);
            await m.addColumn(onboarding, onboarding.schoolEndMinute);
            await m.addColumn(onboarding, onboarding.energyPeak);
            await m.addColumn(onboarding, onboarding.sleepStart);
            await m.addColumn(onboarding, onboarding.sleepEnd);
            await m.addColumn(onboarding, onboarding.timelineGoal);
            await m.addColumn(onboarding, onboarding.screenTimeHours);
            await m.addColumn(onboarding, onboarding.studyEnvironment);
            await m.addColumn(onboarding, onboarding.socialMediaUsage);
          }
        },
      );
}
