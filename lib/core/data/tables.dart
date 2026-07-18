import 'package:drift/drift.dart';
import 'package:profileforge/features/skins/data/skin_table.dart'
    show SkinStates;

/// Profile table — the student's admission identity.
/// Data class named ProfileRow to avoid clashing with the domain Profile model.
@DataClassName('ProfileRow')
class Profiles extends Table {
  TextColumn get id => text()();
  TextColumn get name => text().withDefault(const Constant(''))();
  TextColumn get goal => text().withDefault(const Constant(''))();
  TextColumn get achievements =>
      text().withDefault(const Constant('[]'))(); // JSON list
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}

/// Append-only XP ledger. Single source of truth for all scoring.
@DataClassName('XpEventRow')
class XpEvents extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get profileId => text()();
  IntColumn get amount => integer()();
  TextColumn get source => text()(); // mission, streak, skin, league...
  DateTimeColumn get at => dateTime().withDefault(currentDateAndTime)();
  IntColumn get balanceAfter => integer()();
}

/// Streak state with humane recovery mechanics.
@DataClassName('StreakRow')
class Streaks extends Table {
  TextColumn get profileId => text()();
  IntColumn get current => integer().withDefault(const Constant(0))();
  IntColumn get longest => integer().withDefault(const Constant(0))();
  DateTimeColumn get lastActiveDate => dateTime().nullable()();
  IntColumn get graceDaysUsed => integer().withDefault(const Constant(0))();
  IntColumn get freezeTokens => integer().withDefault(const Constant(2))();
  IntColumn get weekendAmulets => integer().withDefault(const Constant(1))();
  BoolColumn get recovered => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {profileId};
}

/// Skin unlocks (H2).
@DataClassName('SkinUnlockRow')
class SkinUnlocks extends Table {
  TextColumn get profileId => text()();
  TextColumn get skinId => text()();
  DateTimeColumn get unlockedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {profileId, skinId};
}

/// Missions (H6). Data class MissionRow (domain model is `Mission`).
@DataClassName('MissionRow')
class Missions extends Table {
  TextColumn get id => text()();
  TextColumn get profileId => text()();
  TextColumn get title => text()();
  TextColumn get pillar => text(); // Academics, Leadership, ...
  TextColumn get cadence => text(); // daily, weekly, monthly, special, seasonal
  DateTimeColumn get due => dateTime().nullable()();
  BoolColumn get done => boolean().withDefault(const Constant(false))();
  IntColumn get xpReward => integer().withDefault(const Constant(10))();

  @override
  Set<Column> get primaryKey => {id};
}

/// League membership (H3).
@DataClassName('LeagueMembership')
class LeagueMemberships extends Table {
  TextColumn get profileId => text()();
  TextColumn get tier => text(); // bronze..obsidian
  TextColumn get cohortId => text()();
  IntColumn get weeklyXp => integer().withDefault(const Constant(0))();
  BoolColumn get shielded => boolean().withDefault(const Constant(false))();
  DateTimeColumn get seasonStart => dateTime()();

  @override
  Set<Column> get primaryKey => {profileId, cohortId};
}

/// Buddies (H4) and Teams (H5) — offline-first; synced via H9 later.
@DataClassName('BuddyRow')
class Buddies extends Table {
  TextColumn get profileId => text()();
  TextColumn get buddyId => text()();
  TextColumn get status => text().withDefault(const Constant('pending'))();

  @override
  Set<Column> get primaryKey => {profileId, buddyId};
}

@DataClassName('TeamRow')
class Teams extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get ownerProfileId => text()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

@DataClassName('TeamMemberRow')
class TeamMembers extends Table {
  TextColumn get teamId => text()();
  TextColumn get profileId => text()();
  TextColumn get role => text().withDefault(const Constant('member'))();

  @override
  Set<Column> get primaryKey => {teamId, profileId};
}

/// Buddy check-ins (H4) — XP/log book shared between accountability partners.
/// Data class BuddyCheckInRow (domain model is `BuddyCheckIn`).
@DataClassName('BuddyCheckInRow')
class BuddyCheckIns extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get fromProfileId => text()();
  TextColumn get toProfileId => text()();
  IntColumn get xp => integer().withDefault(const Constant(0))();
  TextColumn get note => text().withDefault(const Constant(''))();
  DateTimeColumn get at => dateTime().withDefault(currentDateAndTime)();
}

/// Team challenges (H5) — shared goals with XP targets and deadlines.
@DataClassName('TeamChallengeRow')
class TeamChallenges extends Table {
  TextColumn get id => text()();
  TextColumn get teamId => text()();
  TextColumn get title => text()();
  IntColumn get goalXp => integer().withDefault(const Constant(0))();
  IntColumn get currentXp => integer().withDefault(const Constant(0))();
  DateTimeColumn get endsAt => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

/// Onboarding capture (H7) — the student's admission context.
@DataClassName('OnboardingRow')
class Onboarding extends Table {
  TextColumn get profileId => text()();
  TextColumn get targetUniversities => text().withDefault(const Constant('[]'))();
  TextColumn get subjects => text().withDefault(const Constant('[]'))();
  TextColumn get grades => text().withDefault(const Constant('{}'))();
  TextColumn get clubs => text().withDefault(const Constant('[]'))();
  IntColumn get budget => integer().withDefault(const Constant(0))();
  IntColumn get travelRadiusKm => integer().withDefault(const Constant(0))();
  IntColumn get availabilityHoursPerWeek => integer().withDefault(const Constant(5))();
  TextColumn get careerInterests => text().withDefault(const Constant('[]'))();
  TextColumn get location => text().withDefault(const Constant(''))();

  @override
  Set<Column> get primaryKey => {profileId};
}

/// Offline-first sync outbox (H9). Queued mutations flushed by Workmanager
/// when connectivity returns. `kind` = insert/update/delete; `payload` is the
/// JSON body; `attempts` backs retry/backoff.
@DataClassName('SyncOutboxRow')
class SyncOutbox extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get profileId => text()();
  TextColumn get entity => text(); // profile, streak, mission, ...
  TextColumn get kind => text(); // insert | update | delete
  TextColumn get payload => text(); // JSON
  DateTimeColumn get queuedAt => dateTime().withDefault(currentDateAndTime)();
  IntColumn get attempts => integer().withDefault(const Constant(0))();
  BoolColumn get done => boolean().withDefault(const Constant(false))();
}
