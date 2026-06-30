import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../converters/type_converters.dart';

part 'all_tables.g.dart';

enum StudentProfileField {
  id,
  name,
  email,
  phone,
  board,
  stream,
  grade,
  subjects,
  tenthPercentage,
  coachingInstitute,
  coachingHoursPerWeek,
  satScore,
  ieltsScore,
  targetCountries,
  targetMajor,
  reachUniversities,
  matchUniversities,
  safetyUniversities,
  totalXp,
  totalCoins,
  currentStreak,
  longestStreak,
  lastActiveDate,
  createdAt,
  updatedAt,
}

class StudentProfiles extends Table {
  TextColumn get id => text().clientDefault(() => const Uuid().v4())();
  TextColumn get name => text().withLength(min: 1, max: 100)();
  TextColumn get email => text().withLength(max: 255)();
  TextColumn get phone => text().withLength(max: 20)();
  TextColumn get board => text().withDefault(const Constant('CBSE'))();
  TextColumn get stream => text().withDefault(const Constant('Science'))();
  IntColumn get grade => integer().withDefault(const Constant(11))();
  TextColumn get subjects => text().map(const MapStringDoubleConverter())();
  RealColumn get tenthPercentage => real().withDefault(const Constant(0.0))();
  TextColumn get coachingInstitute => text().nullable()();
  IntColumn get coachingHoursPerWeek => integer().withDefault(const Constant(0))();
  IntColumn get satScore => integer().nullable()();
  RealColumn get ieltsScore => real().nullable()();
  TextColumn get targetCountries => text().map(const StringListConverter())();
  TextColumn get targetMajor => text().nullable()();
  TextColumn get reachUniversities => text().map(const StringListConverter())();
  TextColumn get matchUniversities => text().map(const StringListConverter())();
  TextColumn get safetyUniversities => text().map(const StringListConverter())();
  IntColumn get totalXp => integer().withDefault(const Constant(0))();
  IntColumn get totalCoins => integer().withDefault(const Constant(0))();
  IntColumn get currentStreak => integer().withDefault(const Constant(0))();
  IntColumn get longestStreak => integer().withDefault(const Constant(0))();
  IntColumn get lastActiveDate => integer().nullable()();
  DateTimeColumn get createdAt => dateTime().clientDefault(() => DateTime.now())();
  DateTimeColumn get updatedAt => dateTime().clientDefault(() => DateTime.now())();

  @override
  Set<Column> get primaryKey => {id};

  @override
  List<String> get customConstraints => [
        'CHECK (grade >= 9 AND grade <= 12)',
        'CHECK (tenthPercentage >= 0 AND tenthPercentage <= 100)',
        'CHECK (satScore IS NULL OR (satScore >= 400 AND satScore <= 1600))',
        'CHECK (ieltsScore IS NULL OR (ieltsScore >= 0 AND ieltsScore <= 9))',
        'CHECK (tenthPercentage >= 0 AND tenthPercentage <= 100)',
      ];
}

class Activities extends Table {
  TextColumn get id => text().clientDefault(() => const Uuid().v4())();
  TextColumn get studentId => text().references(StudentProfiles, #id, onDelete: KeyAction.cascade)();
  TextColumn get title => text().withLength(min: 1, max: 200)();
  TextColumn get category => text().map(const ActivityCategoryConverter())();
  TextColumn get tier => text().map(const ActivityTierConverter())();
  TextColumn get description => text().withLength(max: 2000)();
  IntColumn get hoursPerWeek => integer().withDefault(const Constant(0))();
  IntColumn get weeksPerYear => integer().withDefault(const Constant(0))();
  DateTimeColumn get startDate => dateTime()();
  DateTimeColumn get endDate => dateTime().nullable()();
  TextColumn get evidence => text().nullable()();
  TextColumn get teacherVerification => text().nullable()();
  TextColumn get skills => text().map(const StringListConverter())();
  TextColumn get narrativeAngle => text().nullable()();
  IntColumn get admissionsValue => integer().withDefault(const Constant(0))();
  BoolColumn get isInSchool => boolean().withDefault(const Constant(true))();
  TextColumn get location => text().nullable()();
  IntColumn get totalHours => integer().withDefault(const Constant(0))();
  IntColumn get admissionsScore => integer().withDefault(const Constant(0))();
  TextColumn get verificationStatus => text().withDefault(const Constant('pending'))();
  DateTimeColumn get verifiedAt => dateTime().nullable()();
  TextColumn get verifiedBy => text().nullable()();
  DateTimeColumn get createdAt => dateTime().clientDefault(() => DateTime.now())();
  DateTimeColumn get updatedAt => dateTime().clientDefault(() => DateTime.now())();

  @override
  Set<Column> get primaryKey => {id};

  @override
  List<String> get customConstraints => [
        'CHECK (hoursPerWeek >= 0 AND hoursPerWeek <= 100)',
        'CHECK (weeksPerYear >= 0 AND weeksPerYear <= 52)',
        'CHECK (admissionsValue >= 0)',
        'CHECK (verificationStatus IN (\'pending\', \'verified\', \'rejected\'))',
      ];
}

enum MissionCategory {
  daily,
  weekly,
  monthly,
  special,
  milestone,
}

enum MissionType {
  recurring,
  oneTime,
}

enum MissionFrequency {
  daily,
  weekly,
  monthly,
  oneTime,
}

enum MissionDifficulty {
  easy,
  medium,
  hard,
  expert,
  legendary,
}

class Missions extends Table {
  TextColumn get id => text().clientDefault(() => const Uuid().v4())();
  TextColumn get title => text().withLength(min: 1, max: 200)();
  TextColumn get description => text().withLength(max: 1000)();
  TextColumn get category => text().map(const MissionCategoryConverter())();
  TextColumn get type => text().map(const MissionTypeConverter())();
  TextColumn get frequency => text().map(const MissionFrequencyConverter())();
  IntColumn get xpReward => integer().withDefault(const Constant(0))();
  IntColumn get coinReward => integer().withDefault(const Constant(0))();
  IntColumn get streakBonus => integer().withDefault(const Constant(0))();
  TextColumn get difficulty => text().map(const MissionDifficultyConverter())();
  TextColumn get categoryId => text()();
  IntColumn get requiredCount => integer().withDefault(const Constant(1))();
  IntColumn get currentProgress => integer().withDefault(const Constant(0))();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
  BoolColumn get isCompleted => boolean().withDefault(const Constant(false))();
  TextColumn get unlockCondition => text().nullable()();
  IntColumn get unlockProgress => integer().withDefault(const Constant(0))();
  IntColumn get unlockTarget => integer().withDefault(const Constant(0))();
  IntColumn get startDate => integer()();
  IntColumn get endDate => integer().nullable()();
  TextColumn get icon => text().nullable()();
  TextColumn get color => text().nullable()();
  IntColumn get sortOrder => integer().withDefault(const Constant(0))();
  DateTimeColumn get createdAt => dateTime().clientDefault(() => DateTime.now())();
  DateTimeColumn get updatedAt => dateTime().clientDefault(() => DateTime.now())();

  @override
  Set<Column> get primaryKey => {id};
}

class Opportunities extends Table {
  TextColumn get id => text().clientDefault(() => const Uuid().v4())();
  TextColumn get title => text().withLength(min: 1, max: 300)();
  TextColumn get description => text().withLength(max: 5000)();
  TextColumn get category => text().map(const OpportunityCategoryConverter())();
  TextColumn get type => text().map(const OpportunityTypeConverter())();
  TextColumn get organizer => text().withLength(max: 300)();
  TextColumn get location => text().nullable()();
  BoolColumn get isVirtual => boolean().withDefault(const Constant(false))();
  TextColumn get country => text().nullable()();
  TextColumn get city => text().nullable()();
  IntColumn get startDate => integer()();
  IntColumn get endDate => integer()();
  IntColumn get applicationDeadline => integer()();
  TextColumn get eligibility => text().withLength(max: 3000)();
  TextColumn get requirements => text().withLength(max: 3000)();
  TextColumn get prizes => text().withLength(max: 2000)();
  TextColumn get website => text().nullable()();
  TextColumn get contactEmail => text().nullable()();
  TextColumn get contactPhone => text().nullable()();
  TextColumn get tags => text().map(const StringListConverter())();
  TextColumn get difficulty => text().map(const OpportunityDifficultyConverter())();
  TextColumn get prestige => text().map(const OpportunityPrestigeConverter())();
  IntColumn get applicationFee => integer().withDefault(const Constant(0))();
  IntColumn get maxParticipants => integer().nullable()();
  IntColumn get currentApplicants => integer().withDefault(const Constant(0))();
  IntColumn get minGrade => integer().nullable()();
  IntColumn get maxGrade => integer().nullable()();
  IntColumn get minAge => integer().nullable()();
  IntColumn get maxAge => integer().nullable()();
  RealColumn get requiredGpa => real().nullable()();
  TextColumn get requiredTestScores => text().map(const MapStringDoubleConverter())();
  TextColumn get requiredDocuments => text().map(const StringListConverter())();
  TextColumn get selectionCriteria => text().withLength(max: 2000)();
  TextColumn get timeline => text().map(const MapStringStringConverter())();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
  BoolColumn get isFeatured => boolean().withDefault(const Constant(false))();
  IntColumn get views => integer().withDefault(const Constant(0))();
  IntColumn get applications => integer().withDefault(const Constant(0))();
  TextColumn get imageUrl => text().nullable()();
  IntColumn get createdAt => integer()();
  IntColumn get updatedAt => integer()();

  @override
  Set<Column> get primaryKey => {id};

  @override
  List<String> get customConstraints => [
        'CHECK (applicationFee >= 0)',
        'CHECK (maxParticipants IS NULL OR maxParticipants > 0)',
        'CHECK (currentApplicants >= 0)',
        'CHECK (minGrade IS NULL OR (minGrade >= 9 AND minGrade <= 12))',
        'CHECK (maxGrade IS NULL OR (maxGrade >= 9 AND maxGrade <= 12))',
        'CHECK (requiredGpa IS NULL OR (requiredGpa >= 0 AND requiredGpa <= 4.0 OR requiredGpa <= 10))',
      ];
}

enum SkinRarity {
  common,
  uncommon,
  rare,
  epic,
  legendary,
}

enum SkinCategory {
  profile,
  frame,
  badge,
  streak,
  mission,
}

class Skins extends Table {
  TextColumn get id => text().clientDefault(() => const Uuid().v4())();
  TextColumn get name => text().withLength(min: 1, max: 100)();
  TextColumn get description => text().withLength(max: 500)();
  TextColumn get rarity => text().map(const SkinRarityConverter())();
  TextColumn get category => text().map(const SkinCategoryConverter())();
  TextColumn get assetPath => text().nullable()();
  TextColumn get previewPath => text().nullable()();
  TextColumn get unlockCondition => text().nullable()();
  IntColumn get unlockProgress => integer().withDefault(const Constant(0))();
  IntColumn get unlockTarget => integer().withDefault(const Constant(0))();
  BoolColumn get isUnlocked => boolean().withDefault(const Constant(false))();
  BoolColumn get isEquipped => boolean().withDefault(const Constant(false))();
  IntColumn get sortOrder => integer().withDefault(const Constant(0))();
  DateTimeColumn get createdAt => dateTime().clientDefault(() => DateTime.now())();
  DateTimeColumn get updatedAt => dateTime().clientDefault(() => DateTime.now())();

  @override
  Set<Column> get primaryKey => {id};
}

class Streaks extends Table {
  TextColumn get id => text().clientDefault(() => const Uuid().v4())();
  TextColumn get studentId => text().references(StudentProfiles, #id, onDelete: KeyAction.cascade)();
  TextColumn get type => text().withDefault(const Constant('activity'))();
  IntColumn get currentStreak => integer().withDefault(const Constant(0))();
  IntColumn get longestStreak => integer().withDefault(const Constant(0))();
  DateTimeColumn get lastActivityDate => dateTime().nullable()();
  DateTimeColumn get streakStartDate => dateTime().nullable()();
  IntColumn get totalDays => integer().withDefault(const Constant(0))();
  TextColumn get milestoneRewards => text().map(const StringListConverter())();
  DateTimeColumn get createdAt => dateTime().clientDefault(() => DateTime.now())();
  DateTimeColumn get updatedAt => dateTime().clientDefault(() => DateTime.now())();

  @override
  Set<Column> get primaryKey => {id};

  @override
  List<String> get customConstraints => [
        'UNIQUE (studentId, type)',
      ];
}

class Evidence extends Table {
  TextColumn get id => text().clientDefault(() => const Uuid().v4())();
  TextColumn get studentId => text().references(StudentProfiles, #id, onDelete: KeyAction.cascade)();
  TextColumn get activityId => text().references(Activities, #id, onDelete: KeyAction.cascade).nullable()();
  TextColumn get type => text()();
  TextColumn get title => text().withLength(min: 1, max: 200)();
  TextColumn get description => text().withLength(max: 2000)();
  TextColumn get filePath => text().nullable()();
  TextColumn get fileType => text().nullable()();
  IntColumn get fileSize => integer().nullable()();
  TextColumn get url => text().nullable()();
  TextColumn get verificationStatus => text().withDefault(const Constant('pending'))();
  TextColumn get verifiedBy => text().nullable()();
  DateTimeColumn get verifiedAt => dateTime().nullable()();
  TextColumn get verificationNotes => text().nullable()();
  IntColumn get credibilityScore => integer().withDefault(const Constant(50))();
  DateTimeColumn get createdAt => dateTime().clientDefault(() => DateTime.now())();
  DateTimeColumn get updatedAt => dateTime().clientDefault(() => DateTime.now())();

  @override
  Set<Column> get primaryKey => {id};

  @override
  List<String> get customConstraints => [
        'CHECK (verificationStatus IN (\'pending\', \'verified\', \'rejected\', \'under_review\'))',
        'CHECK (credibilityScore >= 0 AND credibilityScore <= 100)',
      ];
}

class AdmissionsProbabilities extends Table {
  TextColumn get id => text().clientDefault(() => const Uuid().v4())();
  TextColumn get studentId => text().references(StudentProfiles, #id, onDelete: KeyAction.cascade)();
  TextColumn get universityName => text().withLength(min: 1, max: 300)();
  TextColumn get country => text().withLength(max: 100)();
  TextColumn get major => text().withLength(max: 200)();
  TextColumn get category => text().map(const UniversityCategoryConverter())();
  RealColumn get reachProbability => real().withDefault(const Constant(0.0))();
  RealColumn get matchProbability => real().withDefault(const Constant(0.0))();
  RealColumn get safetyProbability => real().withDefault(const Constant(0.0))();
  RealColumn get overallProbability => real().withDefault(const Constant(0.0))();
  TextColumn get factors => text().map(const MapStringDoubleConverter())();
  TextColumn get strengths => text().map(const StringListConverter())();
  TextColumn get weaknesses => text().map(const StringListConverter())();
  TextColumn get recommendations => text().map(const StringListConverter())();
  IntColumn get estimatedCost => integer().nullable()();
  TextColumn get scholarships => text().map(const StringListConverter())();
  IntColumn get applicationDeadline => integer().nullable()();
  TextColumn get applicationStatus => text().withDefault(const Constant('planning'))();
  TextColumn get notes => text().nullable()();
  DateTimeColumn get calculatedAt => dateTime().clientDefault(() => DateTime.now())();
  DateTimeColumn get createdAt => dateTime().clientDefault(() => DateTime.now())();
  DateTimeColumn get updatedAt => dateTime().clientDefault(() => DateTime.now())();

  @override
  Set<Column> get primaryKey => {id};

  @override
  List<String> get customConstraints => [
        'CHECK (reachProbability >= 0 AND reachProbability <= 1)',
        'CHECK (matchProbability >= 0 AND matchProbability <= 1)',
        'CHECK (safetyProbability >= 0 AND safetyProbability <= 1)',
        'CHECK (overallProbability >= 0 AND overallProbability <= 1)',
        'CHECK (applicationStatus IN (\'planning\', \'preparing\', \'submitted\', \'accepted\', \'rejected\', \'waitlisted\', \'deferred\'))',
      ];
}

class MissionProgresses extends Table {
  TextColumn get id => text().clientDefault(() => const Uuid().v4())();
  TextColumn get studentId => text().references(StudentProfiles, #id, onDelete: KeyAction.cascade)();
  TextColumn get missionId => text().references(Missions, #id, onDelete: KeyAction.cascade)();
  IntColumn get currentProgress => integer().withDefault(const Constant(0))();
  BoolColumn get isCompleted => boolean().withDefault(const Constant(false))();
  DateTimeColumn get completedAt => dateTime().nullable()();
  IntColumn get xpEarned => integer().withDefault(const Constant(0))();
  IntColumn get coinsEarned => integer().withDefault(const Constant(0))();
  IntColumn get streakCount => integer().withDefault(const Constant(0))();
  DateTimeColumn get lastUpdatedAt => dateTime().clientDefault(() => DateTime.now())();
  DateTimeColumn get createdAt => dateTime().clientDefault(() => DateTime.now())();

  @override
  Set<Column> get primaryKey => {id};

  @override
  List<String> get customConstraints => [
        'UNIQUE (studentId, missionId)',
      ];
}

class OpportunityApplications extends Table {
  TextColumn get id => text().clientDefault(() => const Uuid().v4())();
  TextColumn get studentId => text().references(StudentProfiles, #id, onDelete: KeyAction.cascade)();
  TextColumn get opportunityId => text().references(Opportunities, #id, onDelete: KeyAction.cascade)();
  TextColumn get status => text().withDefault(const Constant('interested'))();
  TextColumn get applicationData => text().map(const MapStringStringConverter())();
  TextColumn get documents => text().map(const StringListConverter())();
  TextColumn get notes => text().nullable()();
  DateTimeColumn get appliedAt => dateTime().nullable()();
  DateTimeColumn get respondedAt => dateTime().nullable()();
  TextColumn get response => text().nullable()();
  IntColumn get reminderDaysBefore => integer().withDefault(const Constant(7))();
  BoolColumn get isReminderEnabled => boolean().withDefault(const Constant(true))();
  DateTimeColumn get createdAt => dateTime().clientDefault(() => DateTime.now())();
  DateTimeColumn get updatedAt => dateTime().clientDefault(() => DateTime.now())();

  @override
  Set<Column> get primaryKey => {id};

  @override
  List<String> get customConstraints => [
        'UNIQUE (studentId, opportunityId)',
        'CHECK (status IN (\'interested\', \'preparing\', \'applied\', \'submitted\', \'under_review\', \'accepted\', \'rejected\', \'waitlisted\', \'withdrawn\'))',
      ];
}

class SkinCollections extends Table {
  TextColumn get id => text().clientDefault(() => const Uuid().v4())();
  TextColumn get studentId => text().references(StudentProfiles, #id, onDelete: KeyAction.cascade)();
  TextColumn get skinId => text().references(Skins, #id, onDelete: KeyAction.cascade)();
  BoolColumn get isUnlocked => boolean().withDefault(const Constant(false))();
  BoolColumn get isEquipped => boolean().withDefault(const Constant(false))();
  IntColumn get unlockProgress => integer().withDefault(const Constant(0))();
  DateTimeColumn get unlockedAt => dateTime().nullable()();
  DateTimeColumn get equippedAt => dateTime().nullable()();
  DateTimeColumn get createdAt => dateTime().clientDefault(() => DateTime.now())();
  DateTimeColumn get updatedAt => dateTime().clientDefault(() => DateTime.now())();

  @override
  Set<Column> get primaryKey => {id};

  @override
  List<String> get customConstraints => [
        'UNIQUE (studentId, skinId)',
      ];
}

class Notifications extends Table {
  TextColumn get id => text().clientDefault(() => const Uuid().v4())();
  TextColumn get studentId => text().references(StudentProfiles, #id, onDelete: KeyAction.cascade)();
  TextColumn get title => text().withLength(min: 1, max: 200)();
  TextColumn get body => text().withLength(max: 1000)();
  TextColumn get type => text()();
  TextColumn get payload => text().map(const MapStringStringConverter())();
  BoolColumn get isRead => boolean().withDefault(const Constant(false))();
  BoolColumn get isArchived => boolean().withDefault(const Constant(false))();
  DateTimeColumn get scheduledAt => dateTime().nullable()();
  DateTimeColumn get sentAt => dateTime().nullable()();
  DateTimeColumn get readAt => dateTime().nullable()();
  DateTimeColumn get createdAt => dateTime().clientDefault(() => DateTime.now())();

  @override
  Set<Column> get primaryKey => {id};
}