import 'package:drift/drift.dart';

/// Profile table — the student's admission identity.
/// Data class named ProfileRow to avoid clashing with the domain Profile model.
@DataClassName('ProfileRow')
class Profiles extends Table {
  TextColumn get id => text()();
  TextColumn get name => text().withDefault(const Constant(''))();
  TextColumn get goal => text().withDefault(const Constant(''))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}

/// Append-only XP ledger. Single source of truth for all scoring.
class XpEvents extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get profileId => text()();
  IntColumn get amount => integer()();
  TextColumn get source => text()(); // mission, streak, skin, league...
  DateTimeColumn get at => dateTime().withDefault(currentDateAndTime)();
  IntColumn get balanceAfter => integer()();
}

/// Streak state with humane recovery mechanics.
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
class SkinUnlocks extends Table {
  TextColumn get profileId => text()();
  TextColumn get skinId => text()();
  DateTimeColumn get unlockedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {profileId, skinId};
}

/// Missions (H6).
class Missions extends Table {
  TextColumn get id => text()();
  TextColumn get profileId => text()();
  TextColumn get title => text()();
  TextColumn get pillar => text()(); // Academics, Leadership, ...
  TextColumn get cadence => text()(); // daily, weekly, monthly, special, seasonal
  DateTimeColumn get due => dateTime().nullable()();
  BoolColumn get done => boolean().withDefault(const Constant(false))();
  IntColumn get xpReward => integer().withDefault(const Constant(10))();

  @override
  Set<Column> get primaryKey => {id};
}

/// League membership (H3).
class LeagueMemberships extends Table {
  TextColumn get profileId => text()();
  TextColumn get tier => text()(); // bronze..obsidian
  TextColumn get cohortId => text()();
  IntColumn get weeklyXp => integer().withDefault(const Constant(0))();
  BoolColumn get shielded => boolean().withDefault(const Constant(false))();
  DateTimeColumn get seasonStart => dateTime()();

  @override
  Set<Column> get primaryKey => {profileId, cohortId};
}

/// Buddies (H4) and Teams (H5) — offline-first; synced via H9 later.
class Buddies extends Table {
  TextColumn get profileId => text()();
  TextColumn get buddyId => text()();
  TextColumn get status => text().withDefault(const Constant('pending'))();

  @override
  Set<Column> get primaryKey => {profileId, buddyId};
}

class Teams extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get ownerProfileId => text()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

class TeamMembers extends Table {
  TextColumn get teamId => text()();
  TextColumn get profileId => text()();
  TextColumn get role => text().withDefault(const Constant('member'))();

  @override
  Set<Column> get primaryKey => {teamId, profileId};
}
