import 'package:freezed_annotation/freezed_annotation.dart';
import '../student_profile.dart';

part 'xp.freezed.dart';
part 'xp.g.dart';

/// XP tracking system with 7 admissions pillars
@freezed
abstract class XPState with _$XPState {
  const factory XPState({
    required int totalXP,
    required Map<AdmissionsPillar, int> pillarXP,
    required int currentLevel,
    required int xpToNextLevel,
    required Map<AdmissionsPillar, int> pillarLevels,
    required List<XPTransaction> transactionHistory,
    required DateTime lastUpdated,
    required int lifetimeXPEarned,
  }) = _XPState;

  factory XPState.fromJson(Map<String, dynamic> json) => _$XPStateFromJson(json);

  factory XPState.initial() => XPState(
        totalXP: 0,
        pillarXP: {
          AdmissionsPillar.academics: 0,
          AdmissionsPillar.evidence: 0,
          AdmissionsPillar.consistency: 0,
          AdmissionsPillar.research: 0,
          AdmissionsPillar.leadership: 0,
          AdmissionsPillar.creativity: 0,
          AdmissionsPillar.communityImpact: 0,
        },
        currentLevel: 1,
        xpToNextLevel: 100,
        pillarLevels: {
          AdmissionsPillar.academics: 1,
          AdmissionsPillar.evidence: 1,
          AdmissionsPillar.consistency: 1,
          AdmissionsPillar.research: 1,
          AdmissionsPillar.leadership: 1,
          AdmissionsPillar.creativity: 1,
          AdmissionsPillar.communityImpact: 1,
        },
        transactionHistory: [],
        lastUpdated: DateTime.now(),
        lifetimeXPEarned: 0,
      );
}

/// Individual XP transaction for history
@freezed
abstract class XPTransaction with _$XPTransaction {
  const factory XPTransaction({
    required String id,
    required int amount,
    required AdmissionsPillar pillar,
    required XPTransactionType type,
    required String source,
    required String description,
    required DateTime timestamp,
    required Map<String, dynamic>? metadata,
  }) = _XPTransaction;

  factory XPTransaction.fromJson(Map<String, dynamic> json) => _$XPTransactionFromJson(json);
}

enum XPTransactionType {
  earned,
  spent,
  bonus,
  penalty,
  milestone,
  streak,
  mission,
  activity,
  verification,
}

/// XP sources and their base values
@freezed
abstract class XPSource with _$XPSource {
  const factory XPSource({
    required String id,
    required String name,
    required AdmissionsPillar pillar,
    required int baseXP,
    required String description,
    required bool isRepeatable,
    required int? maxPerDay,
    required int? maxPerWeek,
    required Map<String, dynamic> conditions,
  }) = _XPSource;

  factory XPSource.fromJson(Map<String, dynamic> json) => _$XPSourceFromJson(json);
}

/// Level thresholds - exponential growth
@freezed
abstract class LevelConfig with _$LevelConfig {
  const factory LevelConfig({
    required int level,
    required int xpRequired,
    required int cumulativeXP,
    required List<String> rewards,
    required Map<AdmissionsPillar, int> pillarXPRequired,
  }) = _LevelConfig;

  factory LevelConfig.fromJson(Map<String, dynamic> json) => _$LevelConfigFromJson(json);
}

/// XP earning activities mapped to pillars
class XPCatalog {
  static const List<XPActivity> activities = [
    // ACADEMICS PILLAR
    XPActivity(
      id: 'add_subject',
      name: 'Add Academic Subject',
      pillar: AdmissionsPillar.academics,
      baseXP: 50,
      description: 'Add a new subject to your profile',
      type: XPTransactionType.activity,
      isRepeatable: true,
      maxPerDay: 3,
    ),
    XPActivity(
      id: 'improve_grade',
      name: 'Grade Improvement',
      pillar: AdmissionsPillar.academics,
      baseXP: 100,
      description: 'Improve a subject grade/mark',
      type: XPTransactionType.activity,
      isRepeatable: true,
      maxPerDay: 2,
    ),
    XPActivity(
      id: 'complete_study_session',
      name: 'Study Session',
      pillar: AdmissionsPillar.academics,
      baseXP: 25,
      description: 'Complete a focused study session (45+ min)',
      type: XPTransactionType.activity,
      isRepeatable: true,
      maxPerDay: 4,
    ),
    XPActivity(
      id: 'mock_test',
      name: 'Mock Test/Exam',
      pillar: AdmissionsPillar.academics,
      baseXP: 150,
      description: 'Complete a full mock test or practice exam',
      type: XPTransactionType.activity,
      isRepeatable: true,
      maxPerWeek: 3,
    ),
    XPActivity(
      id: 'sat_practice',
      name: 'SAT/ACT Practice',
      pillar: AdmissionsPillar.academics,
      baseXP: 200,
      description: 'Complete SAT/ACT practice section',
      type: XPTransactionType.activity,
      isRepeatable: true,
      maxPerWeek: 2,
    ),
    
    // EVIDENCE PILLAR
    XPActivity(
      id: 'add_activity',
      name: 'Add Activity',
      pillar: AdmissionsPillar.evidence,
      baseXP: 50,
      description: 'Add a new extracurricular activity',
      type: XPTransactionType.activity,
      isRepeatable: true,
      maxPerDay: 3,
    ),
    XPActivity(
      id: 'add_evidence',
      name: 'Add Evidence',
      pillar: AdmissionsPillar.evidence,
      baseXP: 75,
      description: 'Upload evidence for an activity (certificate, photo, letter)',
      type: XPTransactionType.activity,
      isRepeatable: true,
      maxPerDay: 5,
    ),
    XPActivity(
      id: 'teacher_verification',
      name: 'Teacher Verification',
      pillar: AdmissionsPillar.evidence,
      baseXP: 200,
      description: 'Get a teacher/mentor to verify an activity',
      type: XPTransactionType.verification,
      isRepeatable: true,
      maxPerWeek: 2,
    ),
    XPActivity(
      id: 'complete_activity_profile',
      name: 'Complete Activity Profile',
      pillar: AdmissionsPillar.evidence,
      baseXP: 100,
      description: 'Fill all fields for an activity (description, hours, skills, narrative)',
      type: XPTransactionType.activity,
      isRepeatable: true,
      maxPerDay: 3,
    ),
    XPActivity(
      id: 'portfolio_piece',
      name: 'Create Portfolio Piece',
      pillar: AdmissionsPillar.evidence,
      baseXP: 300,
      description: 'Create a polished portfolio piece for applications',
      type: XPTransactionType.activity,
      isRepeatable: true,
      maxPerWeek: 1,
    ),
    
    // CONSISTENCY PILLAR
    XPActivity(
      id: 'daily_checkin',
      name: 'Daily Check-in',
      pillar: AdmissionsPillar.consistency,
      baseXP: 20,
      description: 'Open the app and mark daily progress',
      type: XPTransactionType.activity,
      isRepeatable: true,
      maxPerDay: 1,
    ),
    XPActivity(
      id: 'weekly_plan',
      name: 'Weekly Plan Creation',
      pillar: AdmissionsPillar.consistency,
      baseXP: 100,
      description: 'Create your weekly schedule/plan',
      type: XPTransactionType.activity,
      isRepeatable: true,
      maxPerWeek: 1,
    ),
    XPActivity(
      id: 'complete_weekly_plan',
      name: 'Complete Weekly Plan',
      pillar: AdmissionsPillar.consistency,
      baseXP: 200,
      description: 'Complete 80%+ of your weekly plan',
      type: XPTransactionType.milestone,
      isRepeatable: true,
      maxPerWeek: 1,
    ),
    XPActivity(
      id: 'streak_milestone',
      name: 'Streak Milestone',
      pillar: AdmissionsPillar.consistency,
      baseXP: 0, // Variable based on milestone
      description: 'Reach a streak milestone',
      type: XPTransactionType.streak,
      isRepeatable: false,
    ),
    
    // RESEARCH PILLAR
    XPActivity(
      id: 'start_research',
      name: 'Start Research Project',
      pillar: AdmissionsPillar.research,
      baseXP: 300,
      description: 'Begin a new research project',
      type: XPTransactionType.activity,
      isRepeatable: true,
      maxPerMonth: 1,
    ),
    XPActivity(
      id: 'research_milestone',
      name: 'Research Milestone',
      pillar: AdmissionsPillar.research,
      baseXP: 200,
      description: 'Complete a research milestone (lit review, data collection, analysis)',
      type: XPTransactionType.milestone,
      isRepeatable: true,
      maxPerMonth: 2,
    ),
    XPActivity(
      id: 'research_presentation',
      name: 'Present Research',
      pillar: AdmissionsPillar.research,
      baseXP: 500,
      description: 'Present research at symposium, fair, or conference',
      type: XPTransactionType.activity,
      isRepeatable: true,
      maxPerQuarter: 2,
    ),
    XPActivity(
      id: 'research_publication',
      name: 'Publish Research',
      pillar: AdmissionsPillar.research,
      baseXP: 1000,
      description: 'Publish or get accepted for publication',
      type: XPTransactionType.activity,
      isRepeatable: true,
      maxPerYear: 2,
    ),
    
    // LEADERSHIP PILLAR
    XPActivity(
      id: 'leadership_role',
      name: 'Take Leadership Role',
      pillar: AdmissionsPillar.leadership,
      baseXP: 300,
      description: 'Assume a leadership position (club president, team captain, etc.)',
      type: XPTransactionType.activity,
      isRepeatable: true,
      maxPerYear: 3,
    ),
    XPActivity(
      id: 'lead_initiative',
      name: 'Lead Initiative',
      pillar: AdmissionsPillar.leadership,
      baseXP: 250,
      description: 'Lead a project, event, or initiative',
      type: XPTransactionType.activity,
      isRepeatable: true,
      maxPerQuarter: 2,
    ),
    XPActivity(
      id: 'mentor_peer',
      name: 'Mentor a Peer',
      pillar: AdmissionsPillar.leadership,
      baseXP: 150,
      description: 'Formally mentor or tutor another student',
      type: XPTransactionType.activity,
      isRepeatable: true,
      maxPerMonth: 2,
    ),
    XPActivity(
      id: 'team_achievement',
      name: 'Team Achievement',
      pillar: AdmissionsPillar.leadership,
      baseXP: 200,
      description: 'Team you lead achieves a goal/award',
      type: XPTransactionType.milestone,
      isRepeatable: true,
      maxPerQuarter: 2,
    ),
    
    // CREATIVITY PILLAR
    XPActivity(
      id: 'create_artwork',
      name: 'Create Artwork',
      pillar: AdmissionsPillar.creativity,
      baseXP: 100,
      description: 'Create a piece of art, music, writing, design, code project',
      type: XPTransactionType.activity,
      isRepeatable: true,
      maxPerWeek: 2,
    ),
    XPActivity(
      id: 'showcase_work',
      name: 'Showcase Creative Work',
      pillar: AdmissionsPillar.creativity,
      baseXP: 200,
      description: 'Share creative work publicly (exhibit, perform, publish, GitHub)',
      type: XPTransactionType.activity,
      isRepeatable: true,
      maxPerMonth: 2,
    ),
    XPActivity(
      id: 'creative_collaboration',
      name: 'Creative Collaboration',
      pillar: AdmissionsPillar.creativity,
      baseXP: 150,
      description: 'Collaborate on a creative project with others',
      type: XPTransactionType.activity,
      isRepeatable: true,
      maxPerMonth: 1,
    ),
    XPActivity(
      id: 'creative_award',
      name: 'Creative Award/Recognition',
      pillar: AdmissionsPillar.creativity,
      baseXP: 400,
      description: 'Win award or recognition for creative work',
      type: XPTransactionType.milestone,
      isRepeatable: true,
      maxPerYear: 3,
    ),
    
    // COMMUNITY IMPACT PILLAR
    XPActivity(
      id: 'volunteer_hours',
      name: 'Volunteer Hours',
      pillar: AdmissionsPillar.communityImpact,
      baseXP: 10, // Per hour
      description: 'Log volunteer/service hours',
      type: XPTransactionType.activity,
      isRepeatable: true,
      maxPerDay: 50, // Max 5 hours/day * 10 XP
    ),
    XPActivity(
      id: 'start_initiative',
      name: 'Start Community Initiative',
      pillar: AdmissionsPillar.communityImpact,
      baseXP: 400,
      description: 'Launch a new community service initiative',
      type: XPTransactionType.activity,
      isRepeatable: true,
      maxPerYear: 2,
    ),
    XPActivity(
      id: 'impact_milestone',
      name: 'Impact Milestone',
      pillar: AdmissionsPillar.communityImpact,
      baseXP: 300,
      description: 'Reach impact milestone (people helped, funds raised, etc.)',
      type: XPTransactionType.milestone,
      isRepeatable: true,
      maxPerQuarter: 2,
    ),
    XPActivity(
      id: 'sustainability_project',
      name: 'Sustainability Project',
      pillar: AdmissionsPillar.communityImpact,
      baseXP: 350,
      description: 'Lead or contribute to environmental/sustainability project',
      type: XPTransactionType.activity,
      isRepeatable: true,
      maxPerYear: 2,
    ),
    
    // BONUS XP SOURCES
    XPActivity(
      id: 'daily_mission',
      name: 'Complete Daily Mission',
      pillar: AdmissionsPillar.consistency,
      baseXP: 50,
      description: 'Complete a daily mission',
      type: XPTransactionType.mission,
      isRepeatable: true,
      maxPerDay: 3,
    ),
    XPActivity(
      id: 'weekly_mission',
      name: 'Complete Weekly Mission',
      pillar: AdmissionsPillar.consistency,
      baseXP: 200,
      description: 'Complete a weekly mission',
      type: XPTransactionType.mission,
      isRepeatable: true,
      maxPerWeek: 3,
    ),
    XPActivity(
      id: 'milestone_mission',
      name: 'Complete Milestone Mission',
      pillar: AdmissionsPillar.consistency,
      baseXP: 500,
      description: 'Complete a milestone mission',
      type: XPTransactionType.mission,
      isRepeatable: true,
      maxPerMonth: 2,
    ),
    XPActivity(
      id: 'profile_complete',
      name: 'Complete Profile Section',
      pillar: AdmissionsPillar.evidence,
      baseXP: 100,
      description: 'Complete a section of your profile',
      type: XPTransactionType.milestone,
      isRepeatable: true,
      maxPerSection: 1,
    ),
  ];

  static XPActivity? getActivity(String id) {
    try {
      return activities.firstWhere((a) => a.id == id);
    } catch (e) {
      return null;
    }
  }

  static List<XPActivity> getActivitiesForPillar(AdmissionsPillar pillar) {
    return activities.where((a) => a.pillar == pillar).toList();
  }
}

@freezed
abstract class XPActivity with _$XPActivity {
  const factory XPActivity({
    required String id,
    required String name,
    required AdmissionsPillar pillar,
    required int baseXP,
    required String description,
    required XPTransactionType type,
    required bool isRepeatable,
    int? maxPerDay,
    int? maxPerWeek,
    int? maxPerMonth,
    int? maxPerQuarter,
    int? maxPerYear,
    int? maxPerSection,
  }) = _XPActivity;

  factory XPActivity.fromJson(Map<String, dynamic> json) => _$XPActivityFromJson(json);
}

/// Level calculation utilities
class XPUtils {
  static const int baseXPPerLevel = 100;
  static const double levelMultiplier = 1.5;

  /// Calculate XP required for a specific level
  static int xpForLevel(int level) {
    if (level <= 1) return 0;
    int total = 0;
    for (int i = 2; i <= level; i++) {
      total += (baseXPPerLevel * (i - 1) * levelMultiplier).round();
    }
    return total;
  }

  /// Calculate current level from total XP
  static int levelFromXP(int totalXP) {
    int level = 1;
    int xpNeeded = 0;
    while (true) {
      int nextLevelXP = (baseXPPerLevel * level * levelMultiplier).round();
      if (xpNeeded + nextLevelXP > totalXP) break;
      xpNeeded += nextLevelXP;
      level++;
    }
    return level;
  }

  /// XP needed to reach next level
  static int xpToNextLevel(int totalXP) {
    int currentLevel = levelFromXP(totalXP);
    int xpForCurrentLevel = xpForLevel(currentLevel);
    int xpForNextLevel = xpForLevel(currentLevel + 1);
    return xpForNextLevel - totalXP;
  }

  /// XP needed for next pillar level
  static int pillarXPToNextLevel(int pillarXP) {
    return levelFromXP(pillarXP) == 1 
      ? 100 - pillarXP 
      : xpToNextLevel(pillarXP);
  }

  /// Pillar level from pillar XP
  static int pillarLevel(int pillarXP) {
    return levelFromXP(pillarXP);
  }

  /// Calculate XP reward with streak bonus
  static int calculateXPWithBonus({
    required int baseXP,
    required int currentStreak,
    required bool isWeekend,
    double? customMultiplier,
  }) {
    double multiplier = 1.0;
    
    // Streak bonus: 5% per 7 days, max 50%
    if (currentStreak > 0) {
      multiplier += (currentStreak / 7 * 0.05).clamp(0.0, 0.5);
    }
    
    // Weekend bonus
    if (isWeekend) {
      multiplier += 0.1;
    }
    
    // Custom multiplier
    if (customMultiplier != null) {
      multiplier *= customMultiplier;
    }
    
    return (baseXP * multiplier).round();
  }

  /// Format XP for display
  static String formatXP(int xp) {
    if (xp >= 1000000) {
      return '${(xp / 1000000).toStringAsFixed(1)}M';
    } else if (xp >= 1000) {
      return '${(xp / 1000).toStringAsFixed(1)}K';
    }
    return xp.toString();
  }
}