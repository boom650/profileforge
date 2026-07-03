import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:json_annotation/json_annotation.dart';

part 'social.freezed.dart';
part 'social.g.dart';

// ---------------------------------------------------------------------------
// JSON converters for freezed union types
// ---------------------------------------------------------------------------

class ChallengeGoalConverter
    implements JsonConverter<ChallengeGoal, Map<String, dynamic>> {
  const ChallengeGoalConverter();

  @override
  ChallengeGoal fromJson(Map<String, dynamic> json) {
    final type = json['type'] as String;
    final data = Map<String, dynamic>.from(json['data'] ?? {});
    return switch (type) {
      'streak' => ChallengeGoal.streak(
          targetDays: data['targetDays'] as int,
          allowGraceDays: data['allowGraceDays'] as bool,
        ),
      'xp' => ChallengeGoal.xp(
          targetXP: data['targetXP'] as int,
          allowedPillars: List<String>.from(data['allowedPillars'] ?? []),
        ),
      'activity' => ChallengeGoal.activity(
          targetCount: data['targetCount'] as int,
          allowedCategories:
              List<String>.from(data['allowedCategories'] ?? []),
        ),
      'pillar' => ChallengeGoal.pillar(
          pillar: data['pillar'] as String,
          targetXP: data['targetXP'] as int,
        ),
      'consistency' => ChallengeGoal.consistency(
          targetDays: data['targetDays'] as int,
          minActivitiesPerDay: data['minActivitiesPerDay'] as int,
        ),
      'custom' => ChallengeGoal.custom(
          metric: data['metric'] as String,
          targetValue: data['targetValue'] as int,
          unit: data['unit'] as String,
        ),
      _ => throw ArgumentError('Unknown ChallengeGoal type: $type'),
    };
  }

  @override
  Map<String, dynamic> toJson(ChallengeGoal object) {
    if (object is _StreakGoal) {
      return {
        'type': 'streak',
        'data': {'targetDays': object.targetDays, 'allowGraceDays': object.allowGraceDays},
      };
    } else if (object is _XPGoal) {
      return {
        'type': 'xp',
        'data': {'targetXP': object.targetXP, 'allowedPillars': object.allowedPillars},
      };
    } else if (object is _ActivityGoal) {
      return {
        'type': 'activity',
        'data': {
          'targetCount': object.targetCount,
          'allowedCategories': object.allowedCategories,
        },
      };
    } else if (object is _PillarGoal) {
      return {
        'type': 'pillar',
        'data': {'pillar': object.pillar, 'targetXP': object.targetXP},
      };
    } else if (object is _ConsistencyGoal) {
      return {
        'type': 'consistency',
        'data': {
          'targetDays': object.targetDays,
          'minActivitiesPerDay': object.minActivitiesPerDay,
        },
      };
    } else if (object is _CustomGoal) {
      return {
        'type': 'custom',
        'data': {
          'metric': object.metric,
          'targetValue': object.targetValue,
          'unit': object.unit,
        },
      };
    }
    throw ArgumentError('Unknown ChallengeGoal type: ${object.runtimeType}');
  }
}

ChallengeGoal _challengeGoalFromJson(Map<String, dynamic> json) =>
    const ChallengeGoalConverter().fromJson(json);

Map<String, dynamic> _challengeGoalToJson(ChallengeGoal goal) =>
    const ChallengeGoalConverter().toJson(goal);

class CheckInDataConverter
    implements JsonConverter<CheckInData, Map<String, dynamic>> {
  const CheckInDataConverter();

  @override
  CheckInData fromJson(Map<String, dynamic> json) {
    final type = json['type'] as String;
    final data = Map<String, dynamic>.from(json['data'] ?? {});
    return switch (type) {
      'daily' => CheckInData.daily(
          streakDays: data['streakDays'] as int,
          xpEarned: data['xpEarned'] as int,
          activitiesCompleted:
              List<String>.from(data['activitiesCompleted'] ?? []),
          moodRating: data['moodRating'] as int,
          reflection: data['reflection'] as String?,
        ),
      'weekly' => CheckInData.weekly(
          weeklyXP: data['weeklyXP'] as int,
          streakDays: data['streakDays'] as int,
          activitiesCompleted: data['activitiesCompleted'] as int,
          pillarXP: Map<String, int>.from(data['pillarXP'] ?? {}),
          highlights: List<String>.from(data['highlights'] ?? []),
          challenges: List<String>.from(data['challenges'] ?? []),
          goalsForNextWeek: data['goalsForNextWeek'] as String?,
        ),
      'milestone' => CheckInData.milestone(
          milestoneType: data['milestoneType'] as String,
          milestoneName: data['milestoneName'] as String,
          value: data['value'] as int,
        ),
      'streakSave' => CheckInData.streakSave(
          streakDays: data['streakDays'] as int,
          saveType: data['saveType'] as String,
        ),
      'achievement' => CheckInData.achievement(
          achievementId: data['achievementId'] as String,
          achievementName: data['achievementName'] as String,
        ),
      'challengeComplete' => CheckInData.challengeComplete(
          challengeId: data['challengeId'] as String,
          challengeName: data['challengeName'] as String,
          rank: data['rank'] as int,
        ),
      'encouragement' => CheckInData.encouragement(
          fromUserId: data['fromUserId'] as String,
          message: data['message'] as String,
        ),
      _ => throw ArgumentError('Unknown CheckInData type: $type'),
    };
  }

  @override
  Map<String, dynamic> toJson(CheckInData object) {
    if (object is _DailyCheckInData) {
      return {
        'type': 'daily',
        'data': {
          'streakDays': object.streakDays,
          'xpEarned': object.xpEarned,
          'activitiesCompleted': object.activitiesCompleted,
          'moodRating': object.moodRating,
          'reflection': object.reflection,
        },
      };
    } else if (object is _WeeklyCheckInData) {
      return {
        'type': 'weekly',
        'data': {
          'weeklyXP': object.weeklyXP,
          'streakDays': object.streakDays,
          'activitiesCompleted': object.activitiesCompleted,
          'pillarXP': object.pillarXP,
          'highlights': object.highlights,
          'challenges': object.challenges,
          'goalsForNextWeek': object.goalsForNextWeek,
        },
      };
    } else if (object is _MilestoneCheckInData) {
      return {
        'type': 'milestone',
        'data': {
          'milestoneType': object.milestoneType,
          'milestoneName': object.milestoneName,
          'value': object.value,
        },
      };
    } else if (object is _StreakSaveCheckInData) {
      return {
        'type': 'streakSave',
        'data': {'streakDays': object.streakDays, 'saveType': object.saveType},
      };
    } else if (object is _AchievementCheckInData) {
      return {
        'type': 'achievement',
        'data': {
          'achievementId': object.achievementId,
          'achievementName': object.achievementName,
        },
      };
    } else if (object is _ChallengeCompleteCheckInData) {
      return {
        'type': 'challengeComplete',
        'data': {
          'challengeId': object.challengeId,
          'challengeName': object.challengeName,
          'rank': object.rank,
        },
      };
    } else if (object is _EncouragementCheckInData) {
      return {
        'type': 'encouragement',
        'data': {'fromUserId': object.fromUserId, 'message': object.message},
      };
    }
    throw ArgumentError('Unknown CheckInData type: ${object.runtimeType}');
  }
}

CheckInData _checkInDataFromJson(Map<String, dynamic> json) =>
    const CheckInDataConverter().fromJson(json);

Map<String, dynamic> _checkInDataToJson(CheckInData data) =>
    const CheckInDataConverter().toJson(data);

// ---------------------------------------------------------------------------
// Enums
// ---------------------------------------------------------------------------

enum BuddyStatus {
  pending,
  active,
  paused,
  blocked,
  expired;

  String get displayName => switch (this) {
        BuddyStatus.pending => 'Pending',
        BuddyStatus.active => 'Active',
        BuddyStatus.paused => 'Paused',
        BuddyStatus.blocked => 'Blocked',
        BuddyStatus.expired => 'Expired',
      };
}

enum TeamType {
  studyGroup,
  challengeSquad,
  accountability,
  project,
  interest;

  String get displayName => switch (this) {
        TeamType.studyGroup => 'Study Group',
        TeamType.challengeSquad => 'Challenge Squad',
        TeamType.accountability => 'Accountability Crew',
        TeamType.project => 'Project Team',
        TeamType.interest => 'Interest Group',
      };
}

enum TeamPrivacy {
  open,
  inviteOnly,
  closed;

  String get displayName => switch (this) {
        TeamPrivacy.open => 'Open',
        TeamPrivacy.inviteOnly => 'Invite Only',
        TeamPrivacy.closed => 'Closed',
      };
}

enum TeamRole {
  owner,
  admin,
  moderator,
  member;

  String get displayName => switch (this) {
        TeamRole.owner => 'Owner',
        TeamRole.admin => 'Admin',
        TeamRole.moderator => 'Moderator',
        TeamRole.member => 'Member',
      };

  bool get canManageMembers =>
      this == TeamRole.owner || this == TeamRole.admin;
  bool get canManageChallenges =>
      this == TeamRole.owner || this == TeamRole.admin;
  bool get canModerate => this != TeamRole.member;
}

enum ChallengeType {
  streak,
  xp,
  activity,
  pillar,
  consistency,
  custom;

  String get displayName => switch (this) {
        ChallengeType.streak => 'Streak Challenge',
        ChallengeType.xp => 'XP Challenge',
        ChallengeType.activity => 'Activity Challenge',
        ChallengeType.pillar => 'Pillar Challenge',
        ChallengeType.consistency => 'Consistency Challenge',
        ChallengeType.custom => 'Custom Challenge',
      };
}

enum RewardType {
  xp,
  freezeToken,
  graceDay,
  skin,
  frame,
  badge,
  title,
  background,
  particleEffect,
  coins,
}

enum ChallengeStatus {
  upcoming,
  active,
  completed,
  cancelled,
  failed,
}

enum ChallengeProgressStatus {
  notStarted,
  inProgress,
  completed,
  failed,
  abandoned,
}

enum CheckInType {
  daily,
  weekly,
  milestone,
  streakSave,
  achievement,
  challengeComplete,
  encouragement,
}

enum SocialAchievementType {
  firstBuddy,
  buddyStreak,
  teamFounder,
  challengeWinner,
  encouragementSent,
  weeklyCheckIn,
  socialButterfly;

  String get displayName => switch (this) {
        SocialAchievementType.firstBuddy => 'First Buddy',
        SocialAchievementType.buddyStreak => 'Buddy Streak Master',
        SocialAchievementType.teamFounder => 'Team Founder',
        SocialAchievementType.challengeWinner => 'Challenge Winner',
        SocialAchievementType.encouragementSent => 'Encouragement Pro',
        SocialAchievementType.weeklyCheckIn => 'Weekly Warrior',
        SocialAchievementType.socialButterfly => 'Social Butterfly',
      };
}

// ---------------------------------------------------------------------------
// Freezed models
// ---------------------------------------------------------------------------

/// Buddy relationship
@freezed
abstract class Buddy with _$Buddy {
  const factory Buddy({
    required String id,
    required String userId,
    required String buddyId,
    required BuddyStatus status,
    required DateTime createdAt,
    required DateTime? acceptedAt,
    required DateTime? lastInteractionAt,
    required int sharedStreakDays,
    required int totalSharedActivities,
    required Map<String, int> pillarXPShared,
    required List<String> mutualGoals,
    required BuddySettings settings,
  }) = _Buddy;

  factory Buddy.fromJson(Map<String, dynamic> json) => _$BuddyFromJson(json);
}

/// Buddy relationship settings
@freezed
abstract class BuddySettings with _$BuddySettings {
  const factory BuddySettings({
    required bool shareStreak,
    required bool shareXP,
    required bool shareActivities,
    required bool shareGoals,
    required bool notificationsEnabled,
    required bool competitiveMode,
    required int checkInFrequency,
    required bool autoExpire,
    required int expiryDays,
  }) = _BuddySettings;

  factory BuddySettings.fromJson(Map<String, dynamic> json) =>
      _$BuddySettingsFromJson(json);

  factory BuddySettings.defaultSettings() => const BuddySettings(
        shareStreak: true,
        shareXP: true,
        shareActivities: true,
        shareGoals: true,
        notificationsEnabled: true,
        competitiveMode: false,
        checkInFrequency: 3,
        autoExpire: true,
        expiryDays: 14,
      );
}

/// Team for group challenges
@freezed
abstract class Team with _$Team {
  const factory Team({
    required String id,
    required String name,
    required String description,
    required String ownerId,
    required String avatarAsset,
    required TeamType type,
    required TeamPrivacy privacy,
    required List<String> memberIds,
    required Map<String, TeamRole> memberRoles,
    required DateTime createdAt,
    required DateTime? expiresAt,
    required TeamSettings settings,
    required TeamStats stats,
    required List<TeamChallenge> activeChallenges,
    required List<String> inviteCodes,
  }) = _Team;

  factory Team.fromJson(Map<String, dynamic> json) => _$TeamFromJson(json);
}

/// Team settings
@freezed
abstract class TeamSettings with _$TeamSettings {
  const factory TeamSettings({
    required bool shareStreaks,
    required bool shareXP,
    required bool shareActivities,
    required bool notificationsEnabled,
    required bool competitiveMode,
    required int checkInFrequency,
    required bool autoRemoveInactive,
    required int inactivityDays,
    required bool requireCheckIn,
    required int minWeeklyActivities,
  }) = _TeamSettings;

  factory TeamSettings.fromJson(Map<String, dynamic> json) =>
      _$TeamSettingsFromJson(json);

  factory TeamSettings.defaultSettings() => const TeamSettings(
        shareStreaks: true,
        shareXP: true,
        shareActivities: true,
        notificationsEnabled: true,
        competitiveMode: true,
        checkInFrequency: 3,
        requireCheckIn: true,
        minWeeklyActivities: 3,
        autoRemoveInactive: true,
        inactivityDays: 7,
      );
}

/// Team statistics
@freezed
abstract class TeamStats with _$TeamStats {
  const factory TeamStats({
    required int totalMembers,
    required int activeMembers,
    required int totalSharedStreakDays,
    required int totalSharedActivities,
    required int totalSharedXP,
    required int completedChallenges,
    required int activeChallenges,
    required double averageStreakDays,
    required Map<String, int> pillarXPTotals,
    required DateTime lastUpdated,
  }) = _TeamStats;

  factory TeamStats.fromJson(Map<String, dynamic> json) =>
      _$TeamStatsFromJson(json);

  factory TeamStats.initial() => TeamStats(
        totalMembers: 0,
        activeMembers: 0,
        totalSharedStreakDays: 0,
        totalSharedActivities: 0,
        totalSharedXP: 0,
        completedChallenges: 0,
        activeChallenges: 0,
        averageStreakDays: 0.0,
        pillarXPTotals: {},
        lastUpdated: DateTime.now(),
      );
}

/// Team challenge
@freezed
abstract class TeamChallenge with _$TeamChallenge {
  const factory TeamChallenge({
    required String id,
    required String teamId,
    required String title,
    required String description,
    required ChallengeType type,
    required DateTime startDate,
    required DateTime endDate,
    @JsonKey(
        name: 'goal',
        fromJson: _challengeGoalFromJson,
        toJson: _challengeGoalToJson)
    required ChallengeGoal goal,
    required List<ChallengeReward> rewards,
    required List<String> participantIds,
    required Map<String, ChallengeProgress> progress,
    required ChallengeStatus status,
    required String createdBy,
    required DateTime createdAt,
  }) = _TeamChallenge;

  factory TeamChallenge.fromJson(Map<String, dynamic> json) =>
      _$TeamChallengeFromJson(json);
}

@freezed
abstract class ChallengeGoal with _$ChallengeGoal {
  const factory ChallengeGoal.streak({
    required int targetDays,
    required bool allowGraceDays,
  }) = _StreakGoal;

  const factory ChallengeGoal.xp({
    required int targetXP,
    required List<String> allowedPillars,
  }) = _XPGoal;

  const factory ChallengeGoal.activity({
    required int targetCount,
    required List<String> allowedCategories,
  }) = _ActivityGoal;

  const factory ChallengeGoal.pillar({
    required String pillar,
    required int targetXP,
  }) = _PillarGoal;

  const factory ChallengeGoal.consistency({
    required int targetDays,
    required int minActivitiesPerDay,
  }) = _ConsistencyGoal;

  const factory ChallengeGoal.custom({
    required String metric,
    required int targetValue,
    required String unit,
  }) = _CustomGoal;
}

@freezed
abstract class ChallengeReward with _$ChallengeReward {
  const factory ChallengeReward({
    required String id,
    required String name,
    required String description,
    required RewardType type,
    required int amount,
    required int rankRequired,
  }) = _ChallengeReward;

  factory ChallengeReward.fromJson(Map<String, dynamic> json) =>
      _$ChallengeRewardFromJson(json);
}

@freezed
abstract class ChallengeProgress with _$ChallengeProgress {
  const factory ChallengeProgress({
    required double currentValue,
    required double targetValue,
    required double percentage,
    required List<DateTime> completionDates,
    required Map<String, dynamic> metadata,
    required ChallengeProgressStatus status,
    required DateTime startedAt,
    required DateTime? completedAt,
  }) = _ChallengeProgress;

  factory ChallengeProgress.fromJson(Map<String, dynamic> json) =>
      _$ChallengeProgressFromJson(json);
}

/// Social accountability check-in
@freezed
abstract class CheckIn with _$CheckIn {
  const factory CheckIn({
    required String id,
    required String userId,
    required String? buddyId,
    required String? teamId,
    required CheckInType type,
    required DateTime timestamp,
    @JsonKey(
        name: 'data',
        fromJson: _checkInDataFromJson,
        toJson: _checkInDataToJson)
    required CheckInData data,
    required List<String> reactions,
    required List<CheckInComment> comments,
    required bool isPublic,
  }) = _CheckIn;

  factory CheckIn.fromJson(Map<String, dynamic> json) =>
      _$CheckInFromJson(json);
}

@freezed
abstract class CheckInData with _$CheckInData {
  const factory CheckInData.daily({
    required int streakDays,
    required int xpEarned,
    required List<String> activitiesCompleted,
    required int moodRating,
    required String? reflection,
  }) = _DailyCheckInData;

  const factory CheckInData.weekly({
    required int weeklyXP,
    required int streakDays,
    required int activitiesCompleted,
    required Map<String, int> pillarXP,
    required List<String> highlights,
    required List<String> challenges,
    required String? goalsForNextWeek,
  }) = _WeeklyCheckInData;

  const factory CheckInData.milestone({
    required String milestoneType,
    required String milestoneName,
    required int value,
  }) = _MilestoneCheckInData;

  const factory CheckInData.streakSave({
    required int streakDays,
    required String saveType,
  }) = _StreakSaveCheckInData;

  const factory CheckInData.achievement({
    required String achievementId,
    required String achievementName,
  }) = _AchievementCheckInData;

  const factory CheckInData.challengeComplete({
    required String challengeId,
    required String challengeName,
    required int rank,
  }) = _ChallengeCompleteCheckInData;

  const factory CheckInData.encouragement({
    required String fromUserId,
    required String message,
  }) = _EncouragementCheckInData;
}

@freezed
abstract class CheckInComment with _$CheckInComment {
  const factory CheckInComment({
    required String id,
    required String userId,
    required String content,
    required DateTime timestamp,
    required List<String> reactions,
  }) = _CheckInComment;

  factory CheckInComment.fromJson(Map<String, dynamic> json) =>
      _$CheckInCommentFromJson(json);
}

/// Social achievement
@freezed
abstract class SocialAchievement with _$SocialAchievement {
  const factory SocialAchievement({
    required String id,
    required String userId,
    required SocialAchievementType type,
    required String name,
    required String description,
    required DateTime unlockedAt,
    required Map<String, dynamic> metadata,
  }) = _SocialAchievement;

  factory SocialAchievement.fromJson(Map<String, dynamic> json) =>
      _$SocialAchievementFromJson(json);
}

/// Social settings
@freezed
abstract class SocialSettings with _$SocialSettings {
  const factory SocialSettings({
    required bool buddyRequestsEnabled,
    required bool teamJoinEnabled,
    required bool publicProfile,
    required bool showOnLeaderboard,
    required bool allowDirectMessages,
    required bool notificationsEnabled,
    required int maxBuddies,
    required int maxTeams,
    required String? statusMessage,
  }) = _SocialSettings;

  factory SocialSettings.fromJson(Map<String, dynamic> json) =>
      _$SocialSettingsFromJson(json);

  factory SocialSettings.defaultSettings() => const SocialSettings(
        buddyRequestsEnabled: true,
        teamJoinEnabled: true,
        publicProfile: true,
        showOnLeaderboard: true,
        allowDirectMessages: true,
        notificationsEnabled: true,
        maxBuddies: 5,
        maxTeams: 3,
        statusMessage: null,
      );
}
