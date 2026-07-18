import 'package:drift/drift.dart';

/// Profile table — the student's admission identity.
/// Data class named ProfileRow to avoid clashing with the freezed domain Profile.
@DataClassName('ProfileRow')
class Profiles extends Table {
  TextColumn get id => text()();
  TextColumn get name => text().withDefault(const Constant(''))();
  TextColumn get goal => text().withDefault(const Constant(''))();
  TextColumn get achievements => text().withDefault(const Constant('[]'))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

/// XP ledger — every award is an append-only event; balance = latest balanceAfter.
@DataClassName('XpEventRow')
class XpEvents extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get profileId => text()();
  IntColumn get amount => integer()();
  IntColumn get balanceAfter => integer()();
  TextColumn get source => text()();
  DateTimeColumn get at => dateTime().withDefault(currentDateAndTime)();
}

/// Humane streak state per profile.
@DataClassName('StreakRow')
class Streaks extends Table {
  TextColumn get profileId => text()();
  IntColumn get current => integer().withDefault(const Constant(0))();
  IntColumn get longest => integer().withDefault(const Constant(0))();
  DateTimeColumn get lastActiveDate => dateTime().nullable()();
  IntColumn get graceDaysUsed => integer().withDefault(const Constant(0))();
  IntColumn get freezeTokens => integer().withDefault(const Constant(3))();
  IntColumn get weekendAmulets => integer().withDefault(const Constant(2))();
  BoolColumn get recovered => boolean().withDefault(const Constant(false))();
  @override
  Set<Column<Object>> get primaryKey => {profileId};
}

/// Unlocked cosmetic skins (reward layer, not gameplay).
@DataClassName('SkinUnlock')
class SkinUnlocks extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get profileId => text()();
  TextColumn get skinId => text()();
  DateTimeColumn get unlockedAt => dateTime().withDefault(currentDateAndTime)();
}

/// Generated daily/weekly/monthly/special/seasonal missions.
@DataClassName('MissionRow')
class Missions extends Table {
  TextColumn get id => text().withDefault(const Constant(''))();
  TextColumn get profileId => text().withDefault(const Constant(''))();
  TextColumn get title => text().withDefault(const Constant(''))();
  TextColumn get pillar => text().withDefault(const Constant(''))();
  TextColumn get cadence => text().withDefault(const Constant('daily'))();
  DateTimeColumn get due => dateTime().nullable()();
  BoolColumn get done => boolean().withDefault(const Constant(false))();
  IntColumn get xpReward => integer().withDefault(const Constant(10))();
  @override
  Set<Column<Object>> get primaryKey => {id};
}

/// Weekly league membership (H3).
@DataClassName('LeagueMembership')
class LeagueMemberships extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get profileId => text()();
  TextColumn get tier => text()();
  TextColumn get cohortId => text()();
  IntColumn get weeklyXp => integer().withDefault(const Constant(0))();
  BoolColumn get shielded => boolean().withDefault(const Constant(false))();
  DateTimeColumn get seasonStart => dateTime().withDefault(currentDateAndTime)();
}

/// Accountability buddies (H4).
@DataClassName('BuddyRow')
class Buddies extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get profileId => text()();
  TextColumn get buddyProfileId => text()();
  BoolColumn get sharedStreakGoal => boolean().withDefault(const Constant(false))();
  TextColumn get note => text().withDefault(const Constant(''))();
}

/// Teams (H5).
@DataClassName('TeamRow')
class Teams extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get ownerProfileId => text()();
  TextColumn get privacy => text().withDefault(const Constant('public'))();
  @override
  Set<Column<Object>> get primaryKey => {id};
}

/// Team membership join (H5).
@DataClassName('TeamMemberRow')
class TeamMembers extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get teamId => text()();
  TextColumn get profileId => text()();
  TextColumn get role => text().withDefault(const Constant('member'))();
}

/// Team challenge progress (H5).
@DataClassName('TeamChallengeRow')
class TeamChallenges extends Table {
  TextColumn get id => text()();
  TextColumn get teamId => text()();
  TextColumn get title => text()();
  IntColumn get targetXp => integer().withDefault(const Constant(0))();
  IntColumn get currentXp => integer().withDefault(const Constant(0))();
  @override
  Set<Column<Object>> get primaryKey => {id};
}

/// Buddy check-ins (H4).
@DataClassName('BuddyCheckInRow')
class BuddyCheckIns extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get fromProfileId => text()();
  TextColumn get toProfileId => text()();
  IntColumn get xp => integer().withDefault(const Constant(0))();
  TextColumn get note => text().withDefault(const Constant(''))();
  DateTimeColumn get at => dateTime().withDefault(currentDateAndTime)();
}

/// Onboarding snapshot (H7).
@DataClassName('OnboardingRow')
class Onboarding extends Table {
  TextColumn get profileId => text()();
  TextColumn get targetUniversities => text().withDefault(const Constant('[]'))();
  TextColumn get subjects => text().withDefault(const Constant('[]'))();
  TextColumn get grades => text().withDefault(const Constant('{}'))();
  TextColumn get clubs => text().withDefault(const Constant('[]'))();
  IntColumn get budget => integer().withDefault(const Constant(0))();
  IntColumn get travelRadiusKm => integer().withDefault(const Constant(0))();
  IntColumn get availabilityHoursPerWeek => integer().withDefault(const Constant(0))();
  TextColumn get careerInterests => text().withDefault(const Constant('[]'))();
  TextColumn get location => text().withDefault(const Constant(''))();
  @override
  Set<Column<Object>> get primaryKey => {profileId};
}

/// Offline-first sync outbox (H9).
@DataClassName('SyncOutboxRow')
class SyncOutbox extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get profileId => text()();
  TextColumn get entity => text()();
  TextColumn get kind => text()();
  TextColumn get payload => text()();
  BoolColumn get done => boolean().withDefault(const Constant(false))();
  IntColumn get attempts => integer().withDefault(const Constant(0))();
  DateTimeColumn get queuedAt => dateTime().withDefault(currentDateAndTime)();
}

/// Soft currency (gems) earned from activity; spent in the shop.
@DataClassName('WalletRow')
class Wallets extends Table {
  TextColumn get profileId => text()();
  IntColumn get gems => integer().withDefault(const Constant(0))();
  @override
  Set<Column<Object>> get primaryKey => {profileId};
}

/// Daily-login reward tracking (7-day streak wheel).
@DataClassName('DailyRewardRow')
class DailyRewards extends Table {
  TextColumn get profileId => text()();
  IntColumn get day => integer().withDefault(const Constant(0))();
  DateTimeColumn get lastClaimed => dateTime().nullable()();
  @override
  Set<Column<Object>> get primaryKey => {profileId};
}
