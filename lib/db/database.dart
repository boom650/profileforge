import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:sqlite3_flutter_libs/sqlite3_flutter_libs.dart';

import 'tables/all_tables.dart';
import 'daos/all_daos.dart';
import 'converters/type_converters.dart';
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
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 7;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (Migrator m) async {
        await m.createAll();
        await _createUpdatedAtTriggers(m);
      },
      onUpgrade: (Migrator m, int from, int to) async {
        await migrationSteps(m, from, to);
      },
      beforeOpen: (details) async {
        await details.connection.execute('PRAGMA foreign_keys = ON');
        await details.connection.execute('PRAGMA journal_mode = WAL');
        await details.connection.execute('PRAGMA synchronous = NORMAL');
        await details.connection.execute('PRAGMA cache_size = -32768');
        await details.connection.execute('PRAGMA temp_store = MEMORY');
      },
    );
  }

  static QueryExecutor _openConnection() {
    return LazyDatabase(() async {
      final dbFolder = await getApplicationDocumentsDirectory();
      final file = File(p.join(dbFolder.path, 'profileforge.sqlite3'));
      
      // Initialize sqlite3 for Android
      if (Platform.isAndroid) {
        await applyWorkaroundToOpenSqlite3OnOldAndroidVersions();
      }
      
      // Create directory if it doesn't exist
      await file.parent.create(recursive: true);
      
      // Copy pre-populated database from assets if it exists
      if (!await file.exists()) {
        try {
          final assetDb = await rootBundle.open('assets/data/profileforge.sqlite3');
          await file.create(recursive: true);
          await file.writeAsBytes(await assetDb.readAllBytes());
        } catch (_) {
          // Asset doesn't exist, will create fresh
        }
      }
      
      return NativeDatabase.createInBackground(file);
    });
  }

  Future<void> _createUpdatedAtTriggers(Migrator m) async {
    await m.runCustomStatement('''
      CREATE TRIGGER IF NOT EXISTS update_student_profiles_timestamp
      AFTER UPDATE ON student_profiles
      BEGIN
        UPDATE student_profiles SET updated_at = strftime('%s', 'now') * 1000 WHERE id = NEW.id;
      END;
    ''');
    
    await m.runCustomStatement('''
      CREATE TRIGGER IF NOT EXISTS update_activities_timestamp
      AFTER UPDATE ON activities
      BEGIN
        UPDATE activities SET updated_at = strftime('%s', 'now') * 1000 WHERE id = NEW.id;
      END;
    ''');
    
    await m.runCustomStatement('''
      CREATE TRIGGER IF NOT EXISTS update_opportunities_timestamp
      AFTER UPDATE ON opportunities
      BEGIN
        UPDATE opportunities SET updated_at = strftime('%s', 'now') * 1000 WHERE id = NEW.id;
      END;
    ''');
    
    await m.runCustomStatement('''
      CREATE TRIGGER IF NOT EXISTS update_skins_timestamp
      AFTER UPDATE ON skins
      BEGIN
        UPDATE skins SET updated_at = strftime('%s', 'now') * 1000 WHERE id = NEW.id;
      END;
    ''');
    
    await m.runCustomStatement('''
      CREATE TRIGGER IF NOT EXISTS update_streaks_timestamp
      AFTER UPDATE ON streaks
      BEGIN
        UPDATE streaks SET updated_at = strftime('%s', 'now') * 1000 WHERE id = NEW.id;
      END;
    ''');
    
    await m.runCustomStatement('''
      CREATE TRIGGER IF NOT EXISTS update_evidence_timestamp
      AFTER UPDATE ON evidence
      BEGIN
        UPDATE evidence SET updated_at = strftime('%s', 'now') * 1000 WHERE id = NEW.id;
      END;
    ''');
    
    await m.runCustomStatement('''
      CREATE TRIGGER IF NOT EXISTS update_admissions_probabilities_timestamp
      AFTER UPDATE ON admissions_probabilities
      BEGIN
        UPDATE admissions_probabilities SET updated_at = strftime('%s', 'now') * 1000 WHERE id = NEW.id;
      END;
    ''');
    
    await m.runCustomStatement('''
      CREATE TRIGGER IF NOT EXISTS update_mission_progresses_timestamp
      AFTER UPDATE ON mission_progresses
      BEGIN
        UPDATE mission_progresses SET last_updated_at = strftime('%s', 'now') * 1000 WHERE id = NEW.id;
      END;
    ''');
    
    await m.runCustomStatement('''
      CREATE TRIGGER IF NOT EXISTS update_opportunity_applications_timestamp
      AFTER UPDATE ON opportunity_applications
      BEGIN
        UPDATE opportunity_applications SET updated_at = strftime('%s', 'now') * 1000 WHERE id = NEW.id;
      END;
    ''');
    
    await m.runCustomStatement('''
      CREATE TRIGGER IF NOT EXISTS update_skin_collections_timestamp
      AFTER UPDATE ON skin_collections
      BEGIN
        UPDATE skin_collections SET updated_at = strftime('%s', 'now') * 1000 WHERE id = NEW.id;
      END;
    ''');
    
    await m.runCustomStatement('''
      CREATE TRIGGER IF NOT EXISTS update_notifications_timestamp
      AFTER UPDATE ON notifications
      BEGIN
        UPDATE notifications SET created_at = strftime('%s', 'now') * 1000 WHERE id = NEW.id;
      END;
    ''');
  }

  // Helper method to populate initial data
  Future<void> populateInitialData() async {
    await _populateSkins();
    await _populateMissions();
    await _populateOpportunities();
  }

  Future<void> _populateSkins() async {
    // Check if skins already exist
    final existingSkins = await select(skins).get();
    if (existingSkins.isNotEmpty) return;

    final skinsData = [
      SkinsCompanion.insert(
        id: 'skin_default',
        name: 'Default Scholar',
        description: 'Clean and scholarly look',
        rarity: SkinRarity.common.name,
        category: SkinCategory.profile.name,
        assetPath: 'assets/images/skins/default_scholar.png',
        previewPath: 'assets/images/skins/default_scholar_preview.png',
        unlockCondition: 'default',
        unlockProgress: const Value(0),
        unlockTarget: const Value(0),
        isUnlocked: const Value(true),
        isEquipped: const Value(true),
        sortOrder: const Value(0),
      ),
      SkinsCompanion.insert(
        id: 'skin_scholar_bronze',
        name: 'Bronze Scholar',
        description: 'Earned your first 100 XP',
        rarity: SkinRarity.common.name,
        category: SkinCategory.profile.name,
        assetPath: 'assets/images/skins/bronze_scholar.png',
        previewPath: 'assets/images/skins/bronze_scholar_preview.png',
        unlockCondition: 'xp_100',
        unlockProgress: const Value(0),
        unlockTarget: const Value(100),
        isUnlocked: const Value(false),
        isEquipped: const Value(false),
        sortOrder: const Value(1),
      ),
      SkinsCompanion.insert(
        id: 'skin_scholar_silver',
        name: 'Silver Scholar',
        description: 'Reached 500 XP - rising scholar',
        rarity: SkinRarity.uncommon.name,
        category: SkinCategory.profile.name,
        assetPath: 'assets/images/skins/silver_scholar.png',
        previewPath: 'assets/images/skins/silver_scholar_preview.png',
        unlockCondition: 'xp_500',
        unlockProgress: const Value(0),
        unlockTarget: const Value(500),
        isUnlocked: const Value(false),
        isEquipped: const Value(false),
        sortOrder: const Value(2),
      ),
      SkinsCompanion.insert(
        id: 'skin_scholar_gold',
        name: 'Gold Scholar',
        description: '1000 XP - golden scholar status',
        rarity: SkinRarity.rare.name,
        category: SkinCategory.profile.name,
        assetPath: 'assets/images/skins/gold_scholar.png',
        previewPath: 'assets/images/skins/gold_scholar_preview.png',
        unlockCondition: 'xp_1000',
        unlockProgress: const Value(0),
        unlockTarget: const Value(1000),
        isUnlocked: const Value(false),
        isEquipped: const Value(false),
        sortOrder: const Value(3),
      ),
      SkinsCompanion.insert(
        id: 'skin_researcher',
        name: 'Research Prodigy',
        description: 'Completed 3 research activities',
        rarity: SkinRarity.rare.name,
        category: SkinCategory.profile.name,
        assetPath: 'assets/images/skins/research_prodigy.png',
        previewPath: 'assets/images/skins/research_prodigy_preview.png',
        unlockCondition: 'research_3',
        unlockProgress: const Value(0),
        unlockTarget: const Value(3),
        isUnlocked: const Value(false),
        isEquipped: const Value(false),
        sortOrder: const Value(4),
      ),
      SkinsCompanion.insert(
        id: 'skin_leader',
        name: 'Student Leader',
        description: 'Held 2+ leadership positions',
        rarity: SkinRarity.epic.name,
        category: SkinCategory.profile.name,
        assetPath: 'assets/images/skins/student_leader.png',
        previewPath: 'assets/images/skins/student_leader_preview.png',
        unlockCondition: 'leadership_2',
        unlockProgress: const Value(0),
        unlockTarget: const Value(2),
        isUnlocked: const Value(false),
        isEquipped: const Value(false),
        sortOrder: const Value(5),
      ),
      SkinsCompanion.insert(
        id: 'skin_volunteer_heart',
        name: 'Volunteer Heart',
        description: '100+ volunteering hours',
        rarity: SkinRarity.epic.name,
        category: SkinCategory.profile.name,
        assetPath: 'assets/images/skins/volunteer_heart.png',
        previewPath: 'assets/images/skins/volunteer_heart_preview.png',
        unlockCondition: 'volunteer_100',
        unlockProgress: const Value(0),
        unlockTarget: const Value(100),
        isUnlocked: const Value(false),
        isEquipped: const Value(false),
        sortOrder: const Value(6),
      ),
      SkinsCompanion.insert(
        id: 'skin_olympian',
        name: 'Scholar Olympian',
        description: 'Won state/national competition',
        rarity: SkinRarity.legendary.name,
        category: SkinCategory.profile.name,
        assetPath: 'assets/images/skins/scholar_olympian.png',
        previewPath: 'assets/images/skins/scholar_olympian_preview.png',
        unlockCondition: 'competition_national',
        unlockProgress: const Value(0),
        unlockTarget: const Value(1),
        isUnlocked: const Value(false),
        isEquipped: const Value(false),
        sortOrder: const Value(7),
      ),
      SkinsCompanion.insert(
        id: 'skin_ivy_league',
        name: 'Ivy League Dreamer',
        description: 'Targeting Ivy League universities',
        rarity: SkinRarity.legendary.name,
        category: SkinCategory.profile.name,
        assetPath: 'assets/images/skins/ivy_league.png',
        previewPath: 'assets/images/skins/ivy_league_preview.png',
        unlockCondition: 'ivy_target',
        unlockProgress: const Value(0),
        unlockTarget: const Value(1),
        isUnlocked: const Value(false),
        isEquipped: const Value(false),
        sortOrder: const Value(8),
      ),
      SkinsCompanion.insert(
        id: 'skin_streak_master',
        name: 'Streak Master',
        description: '30-day activity streak',
        rarity: SkinRarity.epic.name,
        category: SkinCategory.streak.name,
        assetPath: 'assets/images/skins/streak_master.png',
        previewPath: 'assets/images/skins/streak_master_preview.png',
        unlockCondition: 'streak_30',
        unlockProgress: const Value(0),
        unlockTarget: const Value(30),
        isUnlocked: const Value(false),
        isEquipped: const Value(false),
        sortOrder: const Value(9),
      ),
      SkinsCompanion.insert(
        id: 'skin_early_bird',
        name: 'Early Bird',
        description: 'Complete 5 morning missions',
        rarity: SkinRarity.common.name,
        category: SkinCategory.mission.name,
        assetPath: 'assets/images/skins/early_bird.png',
        previewPath: 'assets/images/skins/early_bird_preview.png',
        unlockCondition: 'morning_mission_5',
        unlockProgress: const Value(0),
        unlockTarget: const Value(5),
        isUnlocked: const Value(false),
        isEquipped: const Value(false),
        sortOrder: const Value(10),
      ),
      SkinsCompanion.insert(
        id: 'skin_night_owl',
        name: 'Night Owl Scholar',
        description: 'Complete 5 late night missions',
        rarity: SkinRarity.common.name,
        category: SkinCategory.mission.name,
        assetPath: 'assets/images/skins/night_owl.png',
        previewPath: 'assets/images/skins/night_owl_preview.png',
        unlockCondition: 'night_mission_5',
        unlockProgress: const Value(0),
        unlockTarget: const Value(5),
        isUnlocked: const Value(false),
        isEquipped: const Value(false),
        sortOrder: const Value(11),
      ),
      // Skin frames
      SkinsCompanion.insert(
        id: 'frame_default',
        name: 'Classic Frame',
        description: 'Default profile frame',
        rarity: SkinRarity.common.name,
        category: SkinCategory.frame.name,
        assetPath: 'assets/images/skins/frames/classic.png',
        previewPath: 'assets/images/skins/frames/classic_preview.png',
        unlockCondition: 'default',
        unlockProgress: const Value(0),
        unlockTarget: const Value(0),
        isUnlocked: const Value(true),
        isEquipped: const Value(true),
        sortOrder: const Value(100),
      ),
      SkinsCompanion.insert(
        id: 'frame_gold',
        name: 'Golden Frame',
        description: 'Gold scholar achievement',
        rarity: SkinRarity.rare.name,
        category: SkinCategory.frame.name,
        assetPath: 'assets/images/skins/frames/gold.png',
        previewPath: 'assets/images/skins/frames/gold_preview.png',
        unlockCondition: 'xp_1000',
        unlockProgress: const Value(0),
        unlockTarget: const Value(1000),
        isUnlocked: const Value(false),
        isEquipped: const Value(false),
        sortOrder: const Value(101),
      ),
      SkinsCompanion.insert(
        id: 'frame_diamond',
        name: 'Diamond Frame',
        description: 'Elite scholar status',
        rarity: SkinRarity.legendary.name,
        category: SkinCategory.frame.name,
        assetPath: 'assets/images/skins/frames/diamond.png',
        previewPath: 'assets/images/skins/frames/diamond_preview.png',
        unlockCondition: 'ivy_acceptance',
        unlockProgress: const Value(0),
        unlockTarget: const Value(1),
        isUnlocked: const Value(false),
        isEquipped: const Value(false),
        sortOrder: const Value(102),
      ),
      // Badges
      SkinsCompanion.insert(
        id: 'badge_research',
        name: 'Research Badge',
        description: 'Published research paper',
        rarity: SkinRarity.rare.name,
        category: SkinCategory.badge.name,
        assetPath: 'assets/images/skins/badges/research.png',
        previewPath: 'assets/images/skins/badges/research_preview.png',
        unlockCondition: 'research_published',
        unlockProgress: const Value(0),
        unlockTarget: const Value(1),
        isUnlocked: const Value(false),
        isEquipped: const Value(false),
        sortOrder: const Value(200),
      ),
      SkinsCompanion.insert(
        id: 'badge_leadership',
        name: 'Leadership Badge',
        description: 'Student council president',
        rarity: SkinRarity.rare.name,
        category: SkinCategory.badge.name,
        assetPath: 'assets/images/skins/badges/leadership.png',
        previewPath: 'assets/images/skins/badges/leadership_preview.png',
        unlockCondition: 'student_council_president',
        unlockProgress: const Value(0),
        unlockTarget: const Value(1),
        isUnlocked: const Value(false),
        isEquipped: const Value(false),
        sortOrder: const Value(201),
      ),
      SkinsCompanion.insert(
        id: 'badge_volunteer',
        name: 'Volunteer Badge',
        description: '200+ service hours',
        rarity: SkinRarity.epic.name,
        category: SkinCategory.badge.name,
        assetPath: 'assets/images/skins/badges/volunteer.png',
        previewPath: 'assets/images/skins/badges/volunteer_preview.png',
        unlockCondition: 'volunteer_200',
        unlockProgress: const Value(0),
        unlockTarget: const Value(200),
        isUnlocked: const Value(false),
        isEquipped: const Value(false),
        sortOrder: const Value(202),
      ),
    ];

    for (final skin in skinsData) {
      await into(skins).insert(skin);
    }
  }

  Future<void> _populateMissions() async {
    final existingMissions = await select(missions).get();
    if (existingMissions.isNotEmpty) return;

    final missionsData = [
      MissionsCompanion.insert(
        id: 'mission_daily_reflect',
        title: 'Daily Reflection',
        description: 'Spend 10 minutes journaling about your day',
        category: MissionCategory.daily.name,
        type: MissionType.recurring.name,
        frequency: MissionFrequency.daily.name,
        xpReward: const Value(10),
        coinReward: const Value(5),
        streakBonus: const Value(2),
        difficulty: MissionDifficulty.easy.name,
        categoryId: 'reflection',
        requiredCount: const Value(1),
        currentProgress: const Value(0),
        isActive: const Value(true),
        isCompleted: const Value(false),
        unlockCondition: const Value('default'),
        unlockProgress: const Value(0),
        unlockTarget: const Value(0),
        startDate: const Value(0),
        endDate: const Value(0),
        icon: const Value('📝'),
        color: const Value('#6366F1'),
        sortOrder: const Value(1),
      ),
      MissionsCompanion.insert(
        id: 'mission_daily_plan',
        title: 'Plan Tomorrow',
        description: 'Plan your top 3 priorities for tomorrow',
        category: MissionCategory.daily.name,
        type: MissionType.recurring.name,
        frequency: MissionFrequency.daily.name,
        xpReward: const Value(10),
        coinReward: const Value(5),
        streakBonus: const Value(2),
        difficulty: MissionDifficulty.easy.name,
        categoryId: 'planning',
        requiredCount: const Value(1),
        currentProgress: const Value(0),
        isActive: const Value(true),
        isCompleted: const Value(false),
        unlockCondition: const Value('default'),
        unlockProgress: const Value(0),
        unlockTarget: const Value(0),
        startDate: const Value(0),
        endDate: const Value(0),
        icon: const Value('📅'),
        color: const Value('#8B5CF6'),
        sortOrder: const Value(2),
      ),
      MissionsCompanion.insert(
        id: 'mission_daily_activity',
        title: 'Log Activity',
        description: 'Log at least 1 activity for today',
        category: MissionCategory.daily.name,
        type: MissionType.recurring.name,
        frequency: MissionFrequency.daily.name,
        xpReward: const Value(15),
        coinReward: const Value(10),
        streakBonus: const Value(3),
        difficulty: MissionDifficulty.easy.name,
        categoryId: 'activity_logging',
        requiredCount: const Value(1),
        currentProgress: const Value(0),
        isActive: const Value(true),
        isCompleted: const Value(false),
        unlockCondition: const Value('default'),
        unlockProgress: const Value(0),
        unlockTarget: const Value(0),
        startDate: const Value(0),
        endDate: const Value(0),
        icon: const Value('📝'),
        color: const Value('#10B981'),
        sortOrder: const Value(3),
      ),
      MissionsCompanion.insert(
        id: 'mission_weekly_review',
        title: 'Weekly Review',
        description: 'Review your week: wins, learnings, next week\'s focus',
        category: MissionCategory.weekly.name,
        type: MissionType.recurring.name,
        frequency: MissionFrequency.weekly.name,
        xpReward: const Value(50),
        coinReward: const Value(25),
        streakBonus: const Value(10),
        difficulty: MissionDifficulty.medium.name,
        categoryId: 'weekly_review',
        requiredCount: const Value(1),
        currentProgress: const Value(0),
        isActive: const Value(true),
        isCompleted: const Value(false),
        unlockCondition: const Value('default'),
        unlockProgress: const Value(0),
        unlockTarget: const Value(0),
        startDate: const Value(0),
        endDate: const Value(0),
        icon: const Value('📊'),
        color: const Value('#F59E0B'),
        sortOrder: const Value(10),
      ),
      MissionsCompanion.insert(
        id: 'mission_weekly_activity',
        title: 'Weekly Activity Sprint',
        description: 'Complete 5 hours of activities this week',
        category: MissionCategory.weekly.name,
        type: MissionType.recurring.name,
        frequency: MissionFrequency.weekly.name,
        xpReward: const Value(75),
        coinReward: const Value(40),
        streakBonus: const Value(15),
        difficulty: MissionDifficulty.medium.name,
        categoryId: 'activity_hours',
        requiredCount: const Value(5),
        currentProgress: const Value(0),
        isActive: const Value(true),
        isCompleted: const Value(false),
        unlockCondition: const Value('default'),
        unlockProgress: const Value(0),
        unlockTarget: const Value(0),
        startDate: const Value(0),
        endDate: const Value(0),
        icon: const Value('🏃'),
        color: const Value('#EF4444'),
        sortOrder: const Value(11),
      ),
      MissionsCompanion.insert(
        id: 'mission_weekly_research',
        title: 'Research Deep Dive',
        description: 'Spend 2 hours on research/project work',
        category: MissionCategory.weekly.name,
        type: MissionType.recurring.name,
        frequency: MissionFrequency.weekly.name,
        xpReward: const Value(100),
        coinReward: const Value(50),
        streakBonus: const Value(20),
        difficulty: MissionDifficulty.hard.name,
        categoryId: 'research',
        requiredCount: const Value(2),
        currentProgress: const Value(0),
        isActive: const Value(true),
        isCompleted: const Value(false),
        unlockCondition: const Value('research_unlocked'),
        unlockProgress: const Value(0),
        unlockTarget: const Value(1),
        startDate: const Value(0),
        endDate: const Value(0),
        icon: const Value('🔬'),
        color: const Value('#8B5CF6'),
        sortOrder: const Value(12),
      ),
      MissionsCompanion.insert(
        id: 'mission_monthly_portfolio',
        title: 'Portfolio Update',
        description: 'Update your portfolio with this month\'s achievements',
        category: MissionCategory.monthly.name,
        type: MissionType.recurring.name,
        frequency: MissionFrequency.monthly.name,
        xpReward: const Value(200),
        coinReward: const Value(100),
        streakBonus: const Value(50),
        difficulty: MissionDifficulty.medium.name,
        categoryId: 'portfolio',
        requiredCount: const Value(1),
        currentProgress: const Value(0),
        isActive: const Value(true),
        isCompleted: const Value(false),
        unlockCondition: const Value('default'),
        unlockProgress: const Value(0),
        unlockTarget: const Value(0),
        startDate: const Value(0),
        endDate: const Value(0),
        icon: const Value('📁'),
        color: const Value('#EC4899'),
        sortOrder: const Value(20),
      ),
      MissionsCompanion.insert(
        id: 'mission_monthly_essay',
        title: 'Essay Draft',
        description: 'Write one college essay draft this month',
        category: MissionCategory.monthly.name,
        type: MissionType.recurring.name,
        frequency: MissionFrequency.monthly.name,
        xpReward: const Value(300),
        coinReward: const Value(150),
        streakBonus: const Value(75),
        difficulty: MissionDifficulty.hard.name,
        categoryId: 'essay',
        requiredCount: const Value(1),
        currentProgress: const Value(0),
        isActive: const Value(true),
        isCompleted: const Value(false),
        unlockCondition: const Value('grade_11'),
        unlockProgress: const Value(0),
        unlockTarget: const Value(11),
        startDate: const Value(0),
        endDate: const Value(0),
        icon: const Value('✍️'),
        color: const Value('#F97316'),
        sortOrder: const Value(21),
      ),
      MissionsCompanion.insert(
        id: 'mission_special_research',
        title: 'Research Project Launch',
        description: 'Start a new research project or competition entry',
        category: MissionCategory.special.name,
        type: MissionType.oneTime.name,
        frequency: MissionFrequency.oneTime.name,
        xpReward: const Value(500),
        coinReward: const Value(250),
        streakBonus: const Value(0),
        difficulty: MissionDifficulty.expert.name,
        categoryId: 'research_launch',
        requiredCount: const Value(1),
        currentProgress: const Value(0),
        isActive: const Value(true),
        isCompleted: const Value(false),
        unlockCondition: const Value('grade_11_research'),
        unlockProgress: const Value(0),
        unlockTarget: const Value(1),
        startDate: const Value(0),
        endDate: const Value(0),
        icon: const Value('🚀'),
        color: const Value('#8B5CF6'),
        sortOrder: const Value(30),
      ),
      MissionsCompanion.insert(
        id: 'mission_special_leadership',
        title: 'Leadership Role',
        description: 'Secure a leadership position in a club/org',
        category: MissionCategory.special.name,
        type: MissionType.oneTime.name,
        frequency: MissionFrequency.oneTime.name,
        xpReward: const Value(400),
        coinReward: const Value(200),
        streakBonus: const Value(0),
        difficulty: MissionDifficulty.expert.name,
        categoryId: 'leadership_role',
        requiredCount: const Value(1),
        currentProgress: const Value(0),
        isActive: const Value(true),
        isCompleted: const Value(false),
        unlockCondition: const Value('grade_11'),
        unlockProgress: const Value(0),
        unlockTarget: const Value(11),
        startDate: const Value(0),
        endDate: const Value(0),
        icon: const Value('👑'),
        color: const Value('#F59E0B'),
        sortOrder: const Value(31),
      ),
      MissionsCompanion.insert(
        id: 'mission_milestone_100_hrs',
        title: 'Century Club',
        description: 'Accumulate 100 hours of extracurricular activities',
        category: MissionCategory.milestone.name,
        type: MissionType.oneTime.name,
        frequency: MissionFrequency.oneTime.name,
        xpReward: const Value(300),
        coinReward: const Value(150),
        streakBonus: const Value(0),
        difficulty: MissionDifficulty.medium.name,
        categoryId: 'hours_100',
        requiredCount: const Value(100),
        currentProgress: const Value(0),
        isActive: const Value(true),
        isCompleted: const Value(false),
        unlockCondition: const Value('default'),
        unlockProgress: const Value(0),
        unlockTarget: const Value(0),
        startDate: const Value(0),
        endDate: const Value(0),
        icon: const Value('💯'),
        color: const Value('#10B981'),
        sortOrder: const Value(40),
      ),
      MissionsCompanion.insert(
        id: 'mission_milestone_500_hrs',
        title: 'Half Millennium',
        description: 'Accumulate 500 hours of extracurricular activities',
        category: MissionCategory.milestone.name,
        type: MissionType.oneTime.name,
        frequency: MissionFrequency.oneTime.name,
        xpReward: const Value(1000),
        coinReward: const Value(500),
        streakBonus: const Value(0),
        difficulty: MissionDifficulty.expert.name,
        categoryId: 'hours_500',
        requiredCount: const Value(500),
        currentProgress: const Value(0),
        isActive: const Value(true),
        isCompleted: const Value(false),
        unlockCondition: const Value('default'),
        unlockProgress: const Value(0),
        unlockTarget: const Value(0),
        startDate: const Value(0),
        endDate: const Value(0),
        icon: const Value('🎯'),
        color: const Value('#8B5CF6'),
        sortOrder: const Value(41),
      ),
      MissionsCompanion.insert(
        id: 'mission_milestone_tier1',
        title: 'Tier 1 Achiever',
        description: 'Earn a Tier 1 (National/International) achievement',
        category: MissionCategory.milestone.name,
        type: MissionType.oneTime.name,
        frequency: MissionFrequency.oneTime.name,
        xpReward: const Value(2000),
        coinReward: const Value(1000),
        streakBonus: const Value(0),
        difficulty: MissionDifficulty.legendary.name,
        categoryId: 'tier1_achievement',
        requiredCount: const Value(1),
        currentProgress: const Value(0),
        isActive: const Value(true),
        isCompleted: const Value(false),
        unlockCondition: const Value('default'),
        unlockProgress: const Value(0),
        unlockTarget: const Value(0),
        startDate: const Value(0),
        endDate: const Value(0),
        icon: const Value('🏆'),
        color: const Value('#FFD700'),
        sortOrder: const Value(42),
      ),
    ];

    for (final mission in missionsData) {
      await into(missions).insert(mission);
    }
  }

  Future<void> _populateOpportunities() async {
    final existingOpportunities = await select(opportunities).get();
    if (existingOpportunities.isNotEmpty) return;

    final now = DateTime.now();
    
    // Add some sample opportunities
    final opportunitiesData = [
      OpportunitiesCompanion.insert(
        id: 'opp_isef',
        title: 'Regeneron ISEF',
        description: 'International Science and Engineering Fair - the world\'s largest pre-college science competition',
        category: OpportunityCategory.competition.name,
        type: OpportunityType.competition.name,
        organizer: 'Society for Science',
        location: const Value('Virtual/International'),
        isVirtual: const Value(true),
        country: const Value('International'),
        city: const Value(null),
        startDate: const Value(DateTime(now.year, 1, 1).millisecondsSinceEpoch),
        endDate: const Value(DateTime(now.year, 5, 31).millisecondsSinceEpoch),
        applicationDeadline: const Value(DateTime(now.year, 12, 31).millisecondsSinceEpoch),
        eligibility: 'Grades 9-12, must qualify through affiliated fair',
        requirements: 'Original research project, abstract, research paper',
        prizes: 'Up to \$75,000 in awards, scholarships, internships',
        website: const Value('https://www.societyforscience.org/isef/'),
        contactEmail: const Value('isef@societyforscience.org'),
        contactPhone: const Value(null),
        tags: const Value(['science', 'research', 'international', 'prestigious', 'scholarships']),
        difficulty: OpportunityDifficulty.legendary.name,
        prestige: OpportunityPrestige.legendary.name,
        applicationFee: const Value(0),
        maxParticipants: const Value(1800),
        currentApplicants: const Value(0),
        minGrade: const Value(9),
        maxGrade: const Value(12),
        minAge: const Value(14),
        maxAge: const Value(19),
        requiredGpa: const Value(3.5),
        requiredTestScores: const Value({}),
        requiredDocuments: const Value(['research_paper', 'abstract', 'forms']),
        selectionCriteria: 'Scientific merit, creativity, presentation',
        timeline: const Value({'qualifier_deadline': '2024-12-31', 'finals': '2025-05-10'}),
        isActive: const Value(true),
        isFeatured: const Value(true),
        views: const Value(0),
        applications: const Value(0),
        imageUrl: const Value('assets/images/opportunities/isef.jpg'),
        createdAt: const Value(DateTime.now().millisecondsSinceEpoch),
        updatedAt: const Value(DateTime.now().millisecondsSinceEpoch),
      ),
      OpportunitiesCompanion.insert(
        id: 'opp_kvpyp',
        title: 'KVPY (Kishore Vaigyanik Protsahan Yojana)',
        description: 'National fellowship program for basic sciences in India',
        category: OpportunityCategory.scholarship.name,
        type: OpportunityType.scholarship.name,
        organizer: 'Department of Science and Technology, Govt of India',
        location: const Value('India'),
        isVirtual: const Value(false),
        country: const Value('India'),
        city: const Value('Multiple centers'),
        startDate: const Value(DateTime(now.year, 11, 1).millisecondsSinceEpoch),
        endDate: const Value(DateTime(now.year + 1, 10, 31).millisecondsSinceEpoch),
        applicationDeadline: const Value(DateTime(now.year, 9, 30).millisecondsSinceEpoch),
        eligibility: 'Indian students in Class 11/12/1st year UG in basic sciences',
        requirements: 'Aptitude test, interview, academic record',
        prizes: 'Monthly fellowship ₹5000-7000, annual contingency grant ₹20000-28000',
        website: const Value('https://kvpy.iisc.ac.in/'),
        contactEmail: const Value('kvpy@iisc.ac.in'),
        contactPhone: const Value(null),
        tags: const Value(['india', 'scholarship', 'science', 'fellowship', 'government', 'prestigious']),
        difficulty: OpportunityDifficulty.hard.name,
        prestige: OpportunityPrestige.epic.name,
        applicationFee: const Value(1000),
        maxParticipants: const Value(3000),
        currentApplicants: const Value(0),
        minGrade: const Value(11),
        maxGrade: const Value(12),
        minAge: const Value(16),
        maxAge: const Value(18),
        requiredGpa: const Value(null),
        requiredTestScores: const Value({}),
        requiredDocuments: const Value(['application_form', 'marksheets', 'certificates']),
        selectionCriteria: 'Aptitude test score (75%), interview (25%)',
        timeline: const Value({'application': '2024-07-01', 'deadline': '2024-09-30', 'exam': '2024-11-03', 'results': '2025-01'}),
        isActive: const Value(true),
        isFeatured: const Value(true),
        views: const Value(0),
        applications: const Value(0),
        imageUrl: const Value('assets/images/opportunities/kvpy.jpg'),
        createdAt: const Value(DateTime.now().millisecondsSinceEpoch),
        updatedAt: const Value(DateTime.now().millisecondsSinceEpoch),
      ),
      OpportunitiesCompanion.insert(
        id: 'opp_inspire',
        title: 'INSPIRE Scholarship (SHE)',
        description: 'Scholarship for Higher Education - for top 1% Class 12 students in basic/natural sciences',
        category: OpportunityCategory.scholarship.name,
        type: OpportunityType.scholarship.name,
        organizer: 'Department of Science & Technology, Govt of India',
        location: const Value('India'),
        isVirtual: const Value(false),
        country: const Value('India'),
        city: const Value('N/A'),
        startDate: const Value(DateTime(now.year, 8, 1).millisecondsSinceEpoch),
        endDate: const Value(DateTime(now.year + 5, 7, 31).millisecondsSinceEpoch),
        applicationDeadline: const Value(DateTime(now.year, 12, 31).millisecondsSinceEpoch),
        eligibility: 'Top 1% in Class 12 board exam, pursuing BSc/BS/Int. MSc in basic/natural sciences',
        requirements: 'Class 12 marksheet, admission proof, bank details',
        prizes: '₹80,000 per year for 5 years (₹60,000 scholarship + ₹20,000 mentorship grant)',
        website: const Value('https://www.online-inspire.gov.in/'),
        contactEmail: const Value('inspire@dst.gov.in'),
        contactPhone: const Value(null),
        tags: const Value(['india', 'scholarship', 'science', 'government', 'merit_based', '5_years']),
        difficulty: OpportunityDifficulty.medium.name,
        prestige: OpportunityPrestige.rare.name,
        applicationFee: const Value(0),
        maxParticipants: const Value(12000),
        currentApplicants: const Value(0),
        minGrade: const Value(12),
        maxGrade: const Value(12),
        minAge: const Value(17),
        maxAge: const Value(19),
        requiredGpa: const Value(null),
        requiredTestScores: const Value({}),
        requiredDocuments: const Value(['class12_marksheet', 'admission_proof', 'bank_details', 'aadhar']),
        selectionCriteria: 'Top 1% in Class 12 board examination',
        timeline: const Value({'results_announced': '2025-05', 'application': '2025-06', 'disbursement': '2025-08'}),
        isActive: const Value(true),
        isFeatured: const Value(true),
        views: const Value(0),
        applications: const Value(0),
        imageUrl: const Value('assets/images/opportunities/inspire.jpg'),
        createdAt: const Value(DateTime.now().millisecondsSinceEpoch),
        updatedAt: const Value(DateTime.now().millisecondsSinceEpoch),
      ),
      OpportunitiesCompanion.insert(
        id: 'opp_iris',
        title: 'IRIS National Fair',
        description: 'Initiative for Research and Innovation in STEM - national science fair for India',
        category: OpportunityCategory.competition.name,
        type: OpportunityType.research.name,
        organizer: 'Department of Science & Technology / Intel / CII',
        location: const Value('India (National Fair in Delhi/Bangalore)'),
        isVirtual: const Value(false),
        country: const Value('India'),
        city: const Value('New Delhi'),
        startDate: const Value(DateTime(now.year, 1, 15).millisecondsSinceEpoch),
        endDate: const Value(DateTime(now.year, 1, 20).millisecondsSinceEpoch),
        applicationDeadline: const Value(DateTime(now.year - 1, 10, 31).millisecondsSinceEpoch),
        eligibility: 'Indian students Classes 5-12, individual or team of 2-3',
        requirements: 'Original research project, project report, display board, logbook',
        prizes: 'Awards, certificates, chance to represent India at ISEF',
        website: const Value('https://www.irisnationalfair.org/'),
        contactEmail: const Value('info@irisnationalfair.org'),
        contactPhone: const Value(null),
        tags: const Value(['india', 'science_fair', 'research', 'isef_qualifier', 'stem', 'national']),
        difficulty: OpportunityDifficulty.hard.name,
        prestige: OpportunityPrestige.epic.name,
        applicationFee: const Value(0),
        maxParticipants: const Value(500),
        currentApplicants: const Value(0),
        minGrade: const Value(5),
        maxGrade: const Value(12),
        minAge: const Value(10),
        maxAge: const Value(18),
        requiredGpa: const Value(null),
        requiredTestScores: const Value({}),
        requiredDocuments: const Value(['project_report', 'logbook', 'forms', 'abstract']),
        selectionCriteria: 'Scientific thought, creativity, thoroughness, skill, clarity',
        timeline: const Value({'registration': '2024-07', 'deadline': '2024-10-31', 'state_fair': '2024-12', 'national': '2025-01'}),
        isActive: const Value(true),
        isFeatured: const Value(true),
        views: const Value(0),
        applications: const Value(0),
        imageUrl: const Value('assets/images/opportunities/iris.jpg'),
        createdAt: const Value(DateTime.now().millisecondsSinceEpoch),
        updatedAt: const Value(DateTime.now().millisecondsSinceEpoch),
      ),
    ];

    for (final opportunity in opportunitiesData) {
      await into(opportunities).insert(opportunity);
    }
  }

  // Utility methods
  Future<void> close() async {
    await super.close();
  }

  Future<void> vacuum() async {
    await customStatement('VACUUM');
  }

  Future<void> analyze() async {
    await customStatement('ANALYZE');
  }
}