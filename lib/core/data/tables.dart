import 'package:drift/drift.dart';

// ============================================================
// EXISTING TABLES (preserved as-is)
// ============================================================

/// Profile table — the student's admission identity.
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
  TextColumn get description => text().withDefault(const Constant(''))();
  TextColumn get pillar => text().withDefault(const Constant(''))();
  TextColumn get cadence => text().withDefault(const Constant('daily'))();
  DateTimeColumn get due => dateTime().nullable()();
  BoolColumn get done => boolean().withDefault(const Constant(false))();
  IntColumn get xpReward => integer().withDefault(const Constant(10))();
  IntColumn get gemReward => integer().withDefault(const Constant(0))();

  /// 'ai' | 'rule' | 'engine' — how this mission was authored.
  TextColumn get source => text().withDefault(const Constant('rule'))();

  /// Priority band: critical | high | medium | low.
  TextColumn get priority => text().withDefault(const Constant('medium'))();

  /// "Why this mission" — psychology/admissions reasoning (filled by AI).
  TextColumn get rationale => text().withDefault(const Constant(''))();
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
  DateTimeColumn get seasonStart =>
      dateTime().withDefault(currentDateAndTime)();
}

/// Accountability buddies (H4).
@DataClassName('BuddyRow')
class Buddies extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get profileId => text()();
  TextColumn get buddyProfileId => text()();
  BoolColumn get sharedStreakGoal =>
      boolean().withDefault(const Constant(false))();
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

/// Onboarding snapshot (H7) — extended with schedule, energy, and timeline data.
@DataClassName('OnboardingRow')
class Onboarding extends Table {
  TextColumn get profileId => text()();
  TextColumn get targetUniversities =>
      text().withDefault(const Constant('[]'))();
  TextColumn get subjects => text().withDefault(const Constant('[]'))();
  TextColumn get grades => text().withDefault(const Constant('{}'))();
  TextColumn get clubs => text().withDefault(const Constant('[]'))();
  IntColumn get budget => integer().withDefault(const Constant(0))();
  IntColumn get travelRadiusKm => integer().withDefault(const Constant(0))();
  IntColumn get availabilityHoursPerWeek =>
      integer().withDefault(const Constant(0))();
  TextColumn get careerInterests => text().withDefault(const Constant('[]'))();
  TextColumn get location => text().withDefault(const Constant(''))();

  // ── Schedule & timetable (v4) ──
  /// JSON array of weekday codes: [1,2,3,4,5] (1=Mon..7=Sun).
  TextColumn get schoolDays =>
      text().withDefault(const Constant('[1,2,3,4,5]'))();
  IntColumn get schoolStartHour => integer().withDefault(const Constant(8))();
  IntColumn get schoolStartMinute => integer().withDefault(const Constant(0))();
  IntColumn get schoolEndHour => integer().withDefault(const Constant(15))();
  IntColumn get schoolEndMinute => integer().withDefault(const Constant(0))();

  // ── Energy & sleep ──
  /// "morning", "afternoon", or "night".
  TextColumn get energyPeak => text().withDefault(const Constant('morning'))();

  /// "22:00"
  TextColumn get sleepStart => text().withDefault(const Constant('22:00'))();

  /// "07:00"
  TextColumn get sleepEnd => text().withDefault(const Constant('07:00'))();

  // ── Essay context (v6) ──
  /// Defining moment / story seed for the personal statement.
  TextColumn get essayStory => text().withDefault(const Constant(''))();

  /// JSON array of VIA-style values, e.g. ["Curiosity","Grit"].
  TextColumn get essayValues => text().withDefault(const Constant('[]'))();

  /// "What question keeps you up at night?" — intellectual curiosity hook.
  TextColumn get essayCuriosity => text().withDefault(const Constant(''))();

  /// Which Common App prompt resonates most ('1'..'7').
  TextColumn get essayPromptPref => text().withDefault(const Constant(''))();

  // ── Goals & environment ──
  /// "6months", "1year", "2years", "custom".
  TextColumn get timelineGoal => text().withDefault(const Constant('1year'))();

  /// Daily screen time (hours).
  IntColumn get screenTimeHours => integer().withDefault(const Constant(3))();

  /// "library", "home", "cafe", "school", "mixed".
  TextColumn get studyEnvironment =>
      text().withDefault(const Constant('mixed'))();

  /// "light", "moderate", "heavy".
  TextColumn get socialMediaUsage =>
      text().withDefault(const Constant('moderate'))();

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

// ============================================================
// NEW TABLES
// ============================================================

/// Big Five + SDT psychological profile (v7).
/// Persisted so the AI adapter can stay consistent across sessions.
@DataClassName('PsychologicalProfileRow')
class PsychologicalProfiles extends Table {
  TextColumn get profileId => text()();

  /// Big Five (0.0–1.0)
  RealColumn get openness => real().withDefault(const Constant(0.5))();
  RealColumn get conscientiousness => real().withDefault(const Constant(0.5))();
  RealColumn get extraversion => real().withDefault(const Constant(0.5))();
  RealColumn get agreeableness => real().withDefault(const Constant(0.5))();
  RealColumn get neuroticism => real().withDefault(const Constant(0.5))();

  /// SDT needs
  RealColumn get autonomy => real().withDefault(const Constant(0.5))();
  RealColumn get competence => real().withDefault(const Constant(0.5))();
  RealColumn get relatedness => real().withDefault(const Constant(0.5))();

  /// Mindset
  RealColumn get growthMindset => real().withDefault(const Constant(0.5))();
  RealColumn get selfEfficacy => real().withDefault(const Constant(0.5))();
  RealColumn get emotionalIntelligence =>
      real().withDefault(const Constant(0.5))();

  /// Derived communication preferences (enums as strings).
  TextColumn get communicationStyle =>
      text().withDefault(const Constant('balanced'))();
  TextColumn get motivationFrame =>
      text().withDefault(const Constant('balanced'))();
  TextColumn get supportLevel =>
      text().withDefault(const Constant('moderate'))();
  TextColumn get structurePreference =>
      text().withDefault(const Constant('moderate'))();
  DateTimeColumn get assessedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column<Object>> get primaryKey => {profileId};
}

/// XP Debt incurred by broken streaks or missed missions.
@DataClassName('XpDebtRow')
class XpDebt extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get profileId => text()();
  IntColumn get amount => integer()();
  TextColumn get reason => text()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  BoolColumn get isPaid => boolean().withDefault(const Constant(false))();
}

/// Study timer (Pomodoro) focus sessions log.
@DataClassName('FocusSessionRow')
class FocusSessions extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get profileId => text()();
  IntColumn get durationMinutes => integer()();
  IntColumn get xpEarned => integer().withDefault(const Constant(0))();
  TextColumn get tag => text().withDefault(const Constant(''))();
  BoolColumn get completed => boolean().withDefault(const Constant(true))();
  DateTimeColumn get startedAt => dateTime()();
}

/// Achievement / badge definitions.
@DataClassName('AchievementDefRow')
class AchievementDefinitions extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get description => text()();
  TextColumn get icon => text().withDefault(const Constant('🏆'))();
  TextColumn get criteriaType =>
      text()(); // 'streak', 'xp_total', 'missions_total', 'focus_total', 'quests_total', 'daily_login', 'skins_unlocked', 'challenges_won'
  IntColumn get criteriaValue => integer()(); // threshold
  @override
  Set<Column<Object>> get primaryKey => {id};
}

/// Unlocked achievements per profile.
@DataClassName('AchievementUnlockRow')
class AchievementUnlocks extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get profileId => text()();
  TextColumn get achievementId => text()();
  DateTimeColumn get unlockedAt => dateTime().withDefault(currentDateAndTime)();
}

/// Daily quests — 3 quick high-XP challenges per day.
@DataClassName('DailyQuestRow')
class DailyQuests extends Table {
  TextColumn get id => text()();
  TextColumn get profileId => text()();
  TextColumn get title => text()();
  TextColumn get description => text().withDefault(const Constant(''))();
  IntColumn get xpReward => integer().withDefault(const Constant(25))();
  BoolColumn get done => boolean().withDefault(const Constant(false))();
  TextColumn get date => text()(); // 'YYYY-MM-DD'
  @override
  Set<Column<Object>> get primaryKey => {id};
}

/// User goals (primary & secondary).
@DataClassName('UserGoalRow')
class UserGoals extends Table {
  TextColumn get profileId => text()();
  TextColumn get primaryGoal => text().withDefault(const Constant(
      'general'))(); // 'exam_prep', 'competition', 'general', 'skill_building', 'college_apps'
  TextColumn get secondaryGoals => text().withDefault(const Constant('[]'))();
  @override
  Set<Column<Object>> get primaryKey => {profileId};
}

/// Friend challenges / duels.
@DataClassName('FriendChallengeRow')
class FriendChallenges extends Table {
  TextColumn get id => text()();
  TextColumn get profileId => text()(); // creator
  TextColumn get opponentId =>
      text()(); // other profile (or 'ghost' for AI opponent)
  IntColumn get wagerXp => integer().withDefault(const Constant(50))();
  TextColumn get status => text().withDefault(const Constant(
      'pending'))(); // 'pending', 'active', 'completed', 'expired'
  IntColumn get challengerScore => integer().withDefault(const Constant(0))();
  IntColumn get opponentScore => integer().withDefault(const Constant(0))();
  DateTimeColumn get expiresAt => dateTime()();
  TextColumn get winnerId => text().withDefault(const Constant(''))();
  @override
  Set<Column<Object>> get primaryKey => {id};
}
