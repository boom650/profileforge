import 'package:drift/drift.dart';
import 'package:profileforge/features/skins/data/skin_table.dart'
    show SkinStates;

/// Profile table — the student's admission identity.
/// Data class named ProfileRow to avoid clashing with the freezed domain Profile.
@DataClassName('ProfileRow')
class Profiles extends Table {
  TextColumn get id => text();
  TextColumn get name => text().withDefault(const Constant(''));
  TextColumn get goal => text().withDefault(const Constant(''));
  TextColumn get achievements =>
      text().withDefault(const Constant('[]')); // JSON list
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime);
}

/// XP ledger — every award is an append-only event; balance = latest balanceAfter.
@DataClassName('XpEventRow')
class XpEvents extends Table {
  IntColumn get id => integer().autoIncrement();
  TextColumn get profileId => text();
  IntColumn get amount => integer();
  IntColumn get balanceAfter => integer();
  TextColumn get source => text();
  DateTimeColumn get at => dateTime().withDefault(currentDateAndTime);
}

/// Humane streak state per profile.
@DataClassName('StreakRow')
class Streaks extends Table {
  TextColumn get profileId => text();
  IntColumn get current => integer().withDefault(const Constant(0));
  IntColumn get longest => integer().withDefault(const Constant(0));
  DateTimeColumn get lastActiveDate => dateTime().nullable();
  IntColumn get graceDaysUsed => integer().withDefault(const Constant(0));
  IntColumn get freezeTokens => integer().withDefault(const Constant(3));
  IntColumn get weekendAmulets => integer().withDefault(const Constant(2));
  IntColumn get recovered => integer().withDefault(const Constant(0));
  @override
  Set<Column> get primaryKey => {profileId};
}

/// Unlocked cosmetic skins (reward layer, not gameplay).
@DataClassName('SkinUnlock')
class SkinUnlocks extends Table {
  IntColumn get id => integer().autoIncrement();
  TextColumn get profileId => text();
  TextColumn get skinId => text();
  DateTimeColumn get unlockedAt => dateTime().withDefault(currentDateAndTime);
  @override
  Set<Column> get primaryKey => {profileId, skinId};
}

/// Generated daily/weekly/monthly/special/seasonal missions.
@DataClassName('MissionRow')
class Missions extends Table {
  TextColumn get id => text();
  TextColumn get profileId => text();
  TextColumn get title => text();
  TextColumn get pillar => text(); // Academics, Leadership, ...
  TextColumn get cadence =>
      text(); // daily, weekly, monthly, special, seasonal
  DateTimeColumn get due => dateTime().nullable();
  BoolColumn get done => boolean().withDefault(const Constant(false));
  IntColumn get xpReward => integer().withDefault(const Constant(10));
  @override
  Set<Column> get primaryKey => {id};
}

/// Weekly league membership (H3).
@DataClassName('LeagueMembership')
class LeagueMemberships extends Table {
  IntColumn get id => integer().autoIncrement();
  TextColumn get profileId => text();
  TextColumn get tier => text(); // bronze..obsidian
  TextColumn get cohortId => text();
  IntColumn get weeklyXp => integer().withDefault(const Constant(0));
  BoolColumn get shielded => boolean().withDefault(const Constant(false));
  DateTimeColumn get seasonStart => dateTime().withDefault(currentDateAndTime);
  @override
  Set<Column> get primaryKey => {id};
}

/// Accountability buddies (H4).
@DataClassName('BuddyRow')
class Buddies extends Table {
  IntColumn get id => integer().autoIncrement();
  TextColumn get profileId => text();
  TextColumn get buddyProfileId => text();
  BoolColumn get sharedStreakGoal =>
      boolean().withDefault(const Constant(false));
  TextColumn get note => text().withDefault(const Constant(''));
  @override
  Set<Column> get primaryKey => {id};
}

/// Teams (H5).
@DataClassName('TeamRow')
class Teams extends Table {
  TextColumn get id => text();
  TextColumn get name => text();
  TextColumn get ownerProfileId => text();
  TextColumn get privacy =>
      text().withDefault(const Constant('public')); // public | private
  @override
  Set<Column> get primaryKey => {id};
}

/// Team membership join (H5).
@DataClassName('TeamMemberRow')
class TeamMembers extends Table {
  IntColumn get id => integer().autoIncrement();
  TextColumn get teamId => text();
  TextColumn get profileId => text();
  TextColumn get role =>
      text().withDefault(const Constant('member')); // owner | member
  @override
  Set<Column> get primaryKey => {id};
}

/// Team challenge progress (H5).
@DataClassName('TeamChallengeRow')
class TeamChallenges extends Table {
  TextColumn get id => text();
  TextColumn get teamId => text();
  TextColumn get title => text();
  IntColumn get targetXp => integer().withDefault(const Constant(0));
  IntColumn get currentXp => integer().withDefault(const Constant(0));
  @override
  Set<Column> get primaryKey => {id};
}

/// Buddy check-ins (H4) — lightweight accountability events.
@DataClassName('BuddyCheckInRow')
class BuddyCheckIns extends Table {
  IntColumn get id => integer().autoIncrement();
  TextColumn get fromProfileId => text();
  TextColumn get toProfileId => text();
  IntColumn get xp => integer().withDefault(const Constant(0));
  TextColumn get note => text().withDefault(const Constant(''));
  DateTimeColumn get at => dateTime().withDefault(currentDateAndTime);
}

/// Onboarding snapshot (H7) — target universities, subjects, goals, budget, radius.
@DataClassName('OnboardingRow')
class Onboarding extends Table {
  TextColumn get profileId => text();
  TextColumn get targetUniversities => text().withDefault(const Constant('[]'));
  TextColumn get subjects => text().withDefault(const Constant('[]'));
  TextColumn get goals => text().withDefault(const Constant('[]'));
  TextColumn get budget => text().withDefault(const Constant('')); // JSON
  IntColumn get radiusKm => integer().withDefault(const Constant(0));
  BoolColumn get completed => boolean().withDefault(const Constant(false));
  @override
  Set<Column> get primaryKey => {profileId};
}

/// Offline-first sync outbox (H9). Queued mutations flushed by Workmanager
/// when connectivity returns. `kind` = insert/update/delete; `payload` = JSON.
@DataClassName('SyncOutboxRow')
class SyncOutbox extends Table {
  IntColumn get id => integer().autoIncrement();
  TextColumn get profileId => text();
  TextColumn get entity => text(); // profile, streak, mission, ...
  TextColumn get kind => text(); // insert | update | delete
  TextColumn get payload => text(); // JSON
  BoolColumn get done => boolean().withDefault(const Constant(false));
  IntColumn get attempts => integer().withDefault(const Constant(0));
  DateTimeColumn get queuedAt => dateTime().withDefault(currentDateAndTime);
}
