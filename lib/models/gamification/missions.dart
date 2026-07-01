import 'package:freezed_annotation/freezed_annotation.dart';
import '../student_profile.dart';
import 'admissions_pillar.dart';

part 'missions.freezed.dart';
part 'missions.g.dart';

/// Mission types
enum MissionType {
  daily,
  weekly,
  milestone,
  inSchool,
  research,
  leadership,
  volunteering,
  special,
}

extension MissionTypeExtension on MissionType {
  String get name => toString().split('.').last;
}

class MissionTypeConverter implements JsonConverter<MissionType, String> {
  const MissionTypeConverter();

  @override
  MissionType fromJson(String json) {
    return MissionType.values.firstWhere(
      (e) => e.name.toLowerCase() == json.toLowerCase(),
      orElse: () => MissionType.daily,
    );
  }

  @override
  String toJson(MissionType object) => object.name;
}

/// Mission category for filtering
enum MissionCategory {
  academics,
  activities,
  profile,
  wellbeing,
  exploration,
  social,
}

extension MissionCategoryExtension on MissionCategory {
  String get name => toString().split('.').last;
}

class MissionCategoryConverter implements JsonConverter<MissionCategory, String> {
  const MissionCategoryConverter();

  @override
  MissionCategory fromJson(String json) {
    return MissionCategory.values.firstWhere(
      (e) => e.name.toLowerCase() == json.toLowerCase(),
      orElse: () => MissionCategory.academics,
    );
  }

  @override
  String toJson(MissionCategory object) => object.name;
}

/// Mission difficulty
enum MissionDifficulty {
  easy,      // 50-100 XP
  medium,    // 100-250 XP
  hard,      // 250-500 XP
  expert,    // 500+ XP
}

extension MissionDifficultyExtension on MissionDifficulty {
  String get name => toString().split('.').last;
}

class MissionDifficultyConverter implements JsonConverter<MissionDifficulty, String> {
  const MissionDifficultyConverter();

  @override
  MissionDifficulty fromJson(String json) {
    return MissionDifficulty.values.firstWhere(
      (e) => e.name.toLowerCase() == json.toLowerCase(),
      orElse: () => MissionDifficulty.easy,
    );
  }

  @override
  String toJson(MissionDifficulty object) => object.name;
}

/// Mission model
@freezed
abstract class Mission with _$Mission {
  const factory Mission({
    required String id,
    required String title,
    required String description,
    @MissionTypeConverter() required MissionType type,
    @MissionCategoryConverter() required MissionCategory category,
    @MissionDifficultyConverter() required MissionDifficulty difficulty,
    required int xpReward,
    required AdmissionsPillar pillar,
    required Map<String, dynamic> completionCriteria,
    required List<String> prerequisites,
    required bool isCompleted,
    required bool isClaimed,
    required DateTime? completedAt,
    required DateTime? claimedAt,
    required DateTime createdAt,
    required DateTime? expiresAt,
    required Map<String, dynamic>? metadata,
    required int progressCurrent,
    required int progressTarget,
    required String progressUnit,
    required bool isRepeatable,
    required int repeatCooldownDays,
    required List<String> tags,
  }) = _Mission;

  factory Mission.fromJson(Map<String, dynamic> json) => _$MissionFromJson(json);
}

/// Weekly mission set
@freezed
abstract class WeeklyMissionSet with _$WeeklyMissionSet {
  const factory WeeklyMissionSet({
    required String id,
    required DateTime weekStart,
    required DateTime weekEnd,
    required List<Mission> missions,
    required int totalXPReward,
    required bool isBonusClaimed,
    required DateTime? bonusClaimedAt,
    required Map<MissionCategory, int> categoryCompletion,
  }) = _WeeklyMissionSet;

  factory WeeklyMissionSet.fromJson(Map<String, dynamic> json) => _$WeeklyMissionSetFromJson(json);
}

/// Mission generation config
@freezed
abstract class MissionGenerationConfig with _$MissionGenerationConfig {
  const factory MissionGenerationConfig({
    required int dailyMissionsCount,
    required int weeklyMissionsCount,
    required Map<MissionCategory, int> categoryDistribution,
    required Map<MissionDifficulty, int> difficultyDistribution,
    required Map<AdmissionsPillar, int> pillarDistribution,
    required bool ensureVariety,
    required int maxRepeatInRow,
  }) = _MissionGenerationConfig;

  factory MissionGenerationConfig.fromJson(Map<String, dynamic> json) => _$MissionGenerationConfigFromJson(json);

  factory MissionGenerationConfig.defaultConfig() => MissionGenerationConfig(
        dailyMissionsCount: 3,
        weeklyMissionsCount: 5,
        categoryDistribution: {
          MissionCategory.academics: 2,
          MissionCategory.activities: 2,
          MissionCategory.profile: 1,
          MissionCategory.wellbeing: 1,
          MissionCategory.exploration: 1,
          MissionCategory.social: 1,
        },
        difficultyDistribution: {
          MissionDifficulty.easy: 3,
          MissionDifficulty.medium: 3,
          MissionDifficulty.hard: 1,
          MissionDifficulty.expert: 1,
        },
        pillarDistribution: {
          AdmissionsPillar.academics: 2,
          AdmissionsPillar.evidence: 2,
          AdmissionsPillar.consistency: 2,
          AdmissionsPillar.research: 1,
          AdmissionsPillar.leadership: 1,
          AdmissionsPillar.creativity: 1,
          AdmissionsPillar.communityImpact: 1,
        },
        ensureVariety: true,
        maxRepeatInRow: 2,
      );
}

/// Predefined mission templates
class MissionTemplates {
  static const List<MissionTemplate> templates = [
    // DAILY MISSIONS - Easy
    MissionTemplate(
      id: 'daily_checkin',
      title: 'Daily Check-in',
      description: 'Open ProfileForge and mark your progress for today',
      type: MissionType.daily,
      category: MissionCategory.wellbeing,
      difficulty: MissionDifficulty.easy,
      xpReward: 20,
      pillar: AdmissionsPillar.consistency,
      completionCriteria: {'action': 'daily_checkin', 'count': 1},
      prerequisites: [],
      progressTarget: 1,
      progressUnit: 'check-in',
      isRepeatable: true,
      repeatCooldownDays: 1,
      tags: ['daily', 'habit', 'consistency'],
    ),
    MissionTemplate(
      id: 'study_session_45',
      title: 'Focused Study Session',
      description: 'Complete a 45-minute focused study session (no phone!)',
      type: MissionType.daily,
      category: MissionCategory.academics,
      difficulty: MissionDifficulty.easy,
      xpReward: 50,
      pillar: AdmissionsPillar.academics,
      completionCriteria: {'action': 'study_session', 'duration_minutes': 45},
      prerequisites: [],
      progressTarget: 1,
      progressUnit: 'session',
      isRepeatable: true,
      repeatCooldownDays: 1,
      tags: ['daily', 'study', 'focus'],
    ),
    MissionTemplate(
      id: 'review_schedule',
      title: 'Review Tomorrow\'s Schedule',
      description: 'Check your schedule for tomorrow and prepare materials',
      type: MissionType.daily,
      category: MissionCategory.profile,
      difficulty: MissionDifficulty.easy,
      xpReward: 30,
      pillar: AdmissionsPillar.consistency,
      completionCriteria: {'action': 'review_schedule', 'count': 1},
      prerequisites: [],
      progressTarget: 1,
      progressUnit: 'review',
      isRepeatable: true,
      repeatCooldownDays: 1,
      tags: ['daily', 'planning', 'organization'],
    ),
    
    // DAILY MISSIONS - Medium
    MissionTemplate(
      id: 'add_evidence_today',
      title: 'Document Today\'s Achievement',
      description: 'Add evidence (photo, certificate, note) for something you did today',
      type: MissionType.daily,
      category: MissionCategory.activities,
      difficulty: MissionDifficulty.medium,
      xpReward: 100,
      pillar: AdmissionsPillar.evidence,
      completionCriteria: {'action': 'add_evidence', 'count': 1},
      prerequisites: [],
      progressTarget: 1,
      progressUnit: 'evidence',
      isRepeatable: true,
      repeatCooldownDays: 1,
      tags: ['daily', 'evidence', 'documentation'],
    ),
    MissionTemplate(
      id: 'practice_problem_set',
      title: 'Practice Problem Set',
      description: 'Complete 10 practice problems in any subject',
      type: MissionType.daily,
      category: MissionCategory.academics,
      difficulty: MissionDifficulty.medium,
      xpReward: 100,
      pillar: AdmissionsPillar.academics,
      completionCriteria: {'action': 'practice_problems', 'count': 10},
      prerequisites: [],
      progressTarget: 10,
      progressUnit: 'problems',
      isRepeatable: true,
      repeatCooldownDays: 1,
      tags: ['daily', 'practice', 'academics'],
    ),
    
    // WEEKLY MISSIONS - Easy
    MissionTemplate(
      id: 'weekly_plan_create',
      title: 'Create Weekly Plan',
      description: 'Plan your study, activities, and goals for the week ahead',
      type: MissionType.weekly,
      category: MissionCategory.profile,
      difficulty: MissionDifficulty.easy,
      xpReward: 100,
      pillar: AdmissionsPillar.consistency,
      completionCriteria: {'action': 'create_weekly_plan', 'count': 1},
      prerequisites: [],
      progressTarget: 1,
      progressUnit: 'plan',
      isRepeatable: true,
      repeatCooldownDays: 7,
      tags: ['weekly', 'planning', 'organization'],
    ),
    MissionTemplate(
      id: 'connect_with_mentor',
      title: 'Connect with a Mentor',
      description: 'Reach out to a teacher, counselor, or mentor for guidance',
      type: MissionType.weekly,
      category: MissionCategory.social,
      difficulty: MissionDifficulty.easy,
      xpReward: 100,
      pillar: AdmissionsPillar.leadership,
      completionCriteria: {'action': 'mentor_contact', 'count': 1},
      prerequisites: [],
      progressTarget: 1,
      progressUnit: 'connection',
      isRepeatable: true,
      repeatCooldownDays: 7,
      tags: ['weekly', 'mentorship', 'networking'],
    ),
    
    // WEEKLY MISSIONS - Medium
    MissionTemplate(
      id: 'complete_activity_profile',
      title: 'Complete an Activity Profile',
      description: 'Fully fill out one activity with description, hours, skills, and narrative',
      type: MissionType.weekly,
      category: MissionCategory.activities,
      difficulty: MissionDifficulty.medium,
      xpReward: 200,
      pillar: AdmissionsPillar.evidence,
      completionCriteria: {'action': 'complete_activity_profile', 'count': 1},
      prerequisites: [],
      progressTarget: 1,
      progressUnit: 'profile',
      isRepeatable: true,
      repeatCooldownDays: 7,
      tags: ['weekly', 'activities', 'profile'],
    ),
    MissionTemplate(
      id: 'mock_test_section',
      title: 'Mock Test Section',
      description: 'Complete one timed section of a mock test (SAT, ACT, or subject test)',
      type: MissionType.weekly,
      category: MissionCategory.academics,
      difficulty: MissionDifficulty.medium,
      xpReward: 200,
      pillar: AdmissionsPillar.academics,
      completionCriteria: {'action': 'mock_test_section', 'count': 1},
      prerequisites: [],
      progressTarget: 1,
      progressUnit: 'section',
      isRepeatable: true,
      repeatCooldownDays: 7,
      tags: ['weekly', 'test_prep', 'practice'],
    ),
    MissionTemplate(
      id: 'volunteer_hours_weekly',
      title: 'Weekly Volunteer Hours',
      description: 'Log at least 3 hours of volunteer/service work this week',
      type: MissionType.weekly,
      category: MissionCategory.social,
      difficulty: MissionDifficulty.medium,
      xpReward: 200,
      pillar: AdmissionsPillar.communityImpact,
      completionCriteria: {'action': 'volunteer_hours', 'hours': 3},
      prerequisites: [],
      progressTarget: 3,
      progressUnit: 'hours',
      isRepeatable: true,
      repeatCooldownDays: 7,
      tags: ['weekly', 'volunteering', 'community'],
    ),
    MissionTemplate(
      id: 'creative_output_weekly',
      title: 'Weekly Creative Output',
      description: 'Create something new: art, code, writing, music, design',
      type: MissionType.weekly,
      category: MissionCategory.exploration,
      difficulty: MissionDifficulty.medium,
      xpReward: 200,
      pillar: AdmissionsPillar.creativity,
      completionCriteria: {'action': 'creative_output', 'count': 1},
      prerequisites: [],
      progressTarget: 1,
      progressUnit: 'creation',
      isRepeatable: true,
      repeatCooldownDays: 7,
      tags: ['weekly', 'creativity', 'portfolio'],
    ),
    
    // WEEKLY MISSIONS - Hard
    MissionTemplate(
      id: 'lead_mini_initiative',
      title: 'Lead a Mini Initiative',
      description: 'Organize a small event, study group, or project with 3+ people',
      type: MissionType.weekly,
      category: MissionCategory.social,
      difficulty: MissionDifficulty.hard,
      xpReward: 350,
      pillar: AdmissionsPillar.leadership,
      completionCriteria: {'action': 'lead_initiative', 'participants': 3},
      prerequisites: [],
      progressTarget: 1,
      progressUnit: 'initiative',
      isRepeatable: true,
      repeatCooldownDays: 14,
      tags: ['weekly', 'leadership', 'initiative'],
    ),
    MissionTemplate(
      id: 'research_progress',
      title: 'Research Progress Milestone',
      description: 'Make measurable progress on a research project (lit review, data, analysis)',
      type: MissionType.weekly,
      category: MissionCategory.exploration,
      difficulty: MissionDifficulty.hard,
      xpReward: 350,
      pillar: AdmissionsPillar.research,
      completionCriteria: {'action': 'research_milestone', 'count': 1},
      prerequisites: ['start_research_project'],
      progressTarget: 1,
      progressUnit: 'milestone',
      isRepeatable: true,
      repeatCooldownDays: 14,
      tags: ['weekly', 'research', 'academic'],
    ),
    
    // MILESTONE MISSIONS - Expert
    MissionTemplate(
      id: 'capstone_project_proposal',
      title: 'Capstone Project Proposal',
      description: 'Write and submit a proposal for your capstone/passion project',
      type: MissionType.milestone,
      category: MissionCategory.exploration,
      difficulty: MissionDifficulty.expert,
      xpReward: 1000,
      pillar: AdmissionsPillar.research,
      completionCriteria: {'action': 'submit_proposal', 'count': 1},
      prerequisites: [],
      progressTarget: 1,
      progressUnit: 'proposal',
      isRepeatable: false,
      repeatCooldownDays: 0,
      tags: ['milestone', 'capstone', 'major'],
    ),
    MissionTemplate(
      id: 'complete_portfolio',
      title: 'Complete Application Portfolio',
      description: 'Finish all portfolio pieces for college applications',
      type: MissionType.milestone,
      category: MissionCategory.activities,
      difficulty: MissionDifficulty.expert,
      xpReward: 1500,
      pillar: AdmissionsPillar.evidence,
      completionCriteria: {'action': 'complete_portfolio', 'pieces': 5},
      prerequisites: [],
      progressTarget: 5,
      progressUnit: 'pieces',
      isRepeatable: false,
      repeatCooldownDays: 0,
      tags: ['milestone', 'portfolio', 'applications'],
    ),
    MissionTemplate(
      id: 'lead_major_initiative',
      title: 'Lead a Major Initiative',
      description: 'Found and lead a significant project impacting 20+ people',
      type: MissionType.milestone,
      category: MissionCategory.social,
      difficulty: MissionDifficulty.expert,
      xpReward: 1500,
      pillar: AdmissionsPillar.leadership,
      completionCriteria: {'action': 'lead_major_initiative', 'impact_count': 20},
      prerequisites: ['lead_mini_initiative'],
      progressTarget: 1,
      progressUnit: 'initiative',
      isRepeatable: false,
      repeatCooldownDays: 0,
      tags: ['milestone', 'leadership', 'impact'],
    ),
    MissionTemplate(
      id: 'research_publication',
      title: 'Publish or Present Research',
      description: 'Get research published, accepted to conference, or win at science fair',
      type: MissionType.milestone,
      category: MissionCategory.exploration,
      difficulty: MissionDifficulty.expert,
      xpReward: 2000,
      pillar: AdmissionsPillar.research,
      completionCriteria: {'action': 'research_publication', 'count': 1},
      prerequisites: ['research_progress'],
      progressTarget: 1,
      progressUnit: 'publication',
      isRepeatable: true,
      repeatCooldownDays: 90,
      tags: ['milestone', 'research', 'publication'],
    ),
    
    // SPECIAL MISSIONS
    MissionTemplate(
      id: 'explore_new_activity',
      title: 'Try Something New',
      description: 'Join a new club, try a new sport, or start a new hobby',
      type: MissionType.special,
      category: MissionCategory.exploration,
      difficulty: MissionDifficulty.medium,
      xpReward: 200,
      pillar: AdmissionsPillar.evidence,
      completionCriteria: {'action': 'new_activity', 'count': 1},
      prerequisites: [],
      progressTarget: 1,
      progressUnit: 'activity',
      isRepeatable: true,
      repeatCooldownDays: 30,
      tags: ['special', 'exploration', 'growth'],
    ),
    MissionTemplate(
      id: 'help_peer',
      title: 'Help a Peer Succeed',
      description: 'Tutor, mentor, or significantly help another student',
      type: MissionType.special,
      category: MissionCategory.social,
      difficulty: MissionDifficulty.medium,
      xpReward: 200,
      pillar: AdmissionsPillar.leadership,
      completionCriteria: {'action': 'help_peer', 'count': 1},
      prerequisites: [],
      progressTarget: 1,
      progressUnit: 'peer',
      isRepeatable: true,
      repeatCooldownDays: 14,
      tags: ['special', 'mentorship', 'kindness'],
    ),
    MissionTemplate(
      id: 'wellbeing_check',
      title: 'Wellbeing Check-in',
      description: 'Do something purely for your mental/physical health (exercise, meditate, hobby)',
      type: MissionType.special,
      category: MissionCategory.wellbeing,
      difficulty: MissionDifficulty.easy,
      xpReward: 50,
      pillar: AdmissionsPillar.consistency,
      completionCriteria: {'action': 'wellbeing_activity', 'duration_minutes': 30},
      prerequisites: [],
      progressTarget: 1,
      progressUnit: 'session',
      isRepeatable: true,
      repeatCooldownDays: 1,
      tags: ['special', 'wellbeing', 'health'],
    ),
  ];

  static List<MissionTemplate> getTemplatesForType(MissionType type) {
    return templates.where((t) => t.type == type).toList();
  }

  static List<MissionTemplate> getTemplatesForCategory(MissionCategory category) {
    return templates.where((t) => t.category == category).toList();
  }

  static MissionTemplate? getTemplate(String id) {
    try {
      return templates.firstWhere((t) => t.id == id);
    } catch (e) {
      return null;
    }
  }
}

@freezed
abstract class MissionTemplate with _$MissionTemplate {
  const factory MissionTemplate({
    required String id,
    required String title,
    required String description,
    @MissionTypeConverter() required MissionType type,
    @MissionCategoryConverter() required MissionCategory category,
    @MissionDifficultyConverter() required MissionDifficulty difficulty,
    required int xpReward,
    required AdmissionsPillar pillar,
    required Map<String, dynamic> completionCriteria,
    required List<String> prerequisites,
    required int progressTarget,
    required String progressUnit,
    required bool isRepeatable,
    required int repeatCooldownDays,
    required List<String> tags,
  }) = _MissionTemplate;

  factory MissionTemplate.fromJson(Map<String, dynamic> json) => _$MissionTemplateFromJson(json);
}

/// Mission progress tracking
@freezed
abstract class MissionProgress with _$MissionProgress {
  const factory MissionProgress({
    required String missionId,
    required int currentProgress,
    required int targetProgress,
    required Map<String, dynamic> progressData,
    required DateTime lastUpdated,
    required bool isCompleted,
    required DateTime? completedAt,
  }) = _MissionProgress;

  factory MissionProgress.fromJson(Map<String, dynamic> json) => _$MissionProgressFromJson(json);
}