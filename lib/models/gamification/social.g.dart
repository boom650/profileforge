// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'social.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$BuddyImpl _$$BuddyImplFromJson(Map<String, dynamic> json) => _$BuddyImpl(
      id: json['id'] as String,
      userId: json['userId'] as String,
      buddyId: json['buddyId'] as String,
      status: $enumDecode(_$BuddyStatusEnumMap, json['status']),
      createdAt: DateTime.parse(json['createdAt'] as String),
      acceptedAt: json['acceptedAt'] == null
          ? null
          : DateTime.parse(json['acceptedAt'] as String),
      lastInteractionAt: json['lastInteractionAt'] == null
          ? null
          : DateTime.parse(json['lastInteractionAt'] as String),
      sharedStreakDays: (json['sharedStreakDays'] as num).toInt(),
      totalSharedActivities: (json['totalSharedActivities'] as num).toInt(),
      pillarXPShared: Map<String, int>.from(json['pillarXPShared'] as Map),
      mutualGoals: (json['mutualGoals'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      settings:
          BuddySettings.fromJson(json['settings'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$BuddyImplToJson(_$BuddyImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'buddyId': instance.buddyId,
      'status': _$BuddyStatusEnumMap[instance.status]!,
      'createdAt': instance.createdAt.toIso8601String(),
      'acceptedAt': instance.acceptedAt?.toIso8601String(),
      'lastInteractionAt': instance.lastInteractionAt?.toIso8601String(),
      'sharedStreakDays': instance.sharedStreakDays,
      'totalSharedActivities': instance.totalSharedActivities,
      'pillarXPShared': instance.pillarXPShared,
      'mutualGoals': instance.mutualGoals,
      'settings': instance.settings,
    };

const _$BuddyStatusEnumMap = {
  BuddyStatus.pending: 'pending',
  BuddyStatus.active: 'active',
  BuddyStatus.paused: 'paused',
  BuddyStatus.blocked: 'blocked',
  BuddyStatus.expired: 'expired',
};

_$BuddySettingsImpl _$$BuddySettingsImplFromJson(Map<String, dynamic> json) =>
    _$BuddySettingsImpl(
      shareStreak: json['shareStreak'] as bool,
      shareXP: json['shareXP'] as bool,
      shareActivities: json['shareActivities'] as bool,
      shareGoals: json['shareGoals'] as bool,
      notificationsEnabled: json['notificationsEnabled'] as bool,
      competitiveMode: json['competitiveMode'] as bool,
      checkInFrequency: (json['checkInFrequency'] as num).toInt(),
      autoExpire: json['autoExpire'] as bool,
      expiryDays: (json['expiryDays'] as num).toInt(),
    );

Map<String, dynamic> _$$BuddySettingsImplToJson(_$BuddySettingsImpl instance) =>
    <String, dynamic>{
      'shareStreak': instance.shareStreak,
      'shareXP': instance.shareXP,
      'shareActivities': instance.shareActivities,
      'shareGoals': instance.shareGoals,
      'notificationsEnabled': instance.notificationsEnabled,
      'competitiveMode': instance.competitiveMode,
      'checkInFrequency': instance.checkInFrequency,
      'autoExpire': instance.autoExpire,
      'expiryDays': instance.expiryDays,
    };

_$TeamImpl _$$TeamImplFromJson(Map<String, dynamic> json) => _$TeamImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      ownerId: json['ownerId'] as String,
      avatarAsset: json['avatarAsset'] as String,
      type: $enumDecode(_$TeamTypeEnumMap, json['type']),
      privacy: $enumDecode(_$TeamPrivacyEnumMap, json['privacy']),
      memberIds:
          (json['memberIds'] as List<dynamic>).map((e) => e as String).toList(),
      memberRoles: (json['memberRoles'] as Map<String, dynamic>).map(
        (k, e) => MapEntry(k, $enumDecode(_$TeamRoleEnumMap, e)),
      ),
      createdAt: DateTime.parse(json['createdAt'] as String),
      expiresAt: json['expiresAt'] == null
          ? null
          : DateTime.parse(json['expiresAt'] as String),
      settings: TeamSettings.fromJson(json['settings'] as Map<String, dynamic>),
      stats: TeamStats.fromJson(json['stats'] as Map<String, dynamic>),
      activeChallenges: (json['activeChallenges'] as List<dynamic>)
          .map((e) => TeamChallenge.fromJson(e as Map<String, dynamic>))
          .toList(),
      inviteCodes: (json['inviteCodes'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$$TeamImplToJson(_$TeamImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'ownerId': instance.ownerId,
      'avatarAsset': instance.avatarAsset,
      'type': _$TeamTypeEnumMap[instance.type]!,
      'privacy': _$TeamPrivacyEnumMap[instance.privacy]!,
      'memberIds': instance.memberIds,
      'memberRoles': instance.memberRoles
          .map((k, e) => MapEntry(k, _$TeamRoleEnumMap[e]!)),
      'createdAt': instance.createdAt.toIso8601String(),
      'expiresAt': instance.expiresAt?.toIso8601String(),
      'settings': instance.settings,
      'stats': instance.stats,
      'activeChallenges': instance.activeChallenges,
      'inviteCodes': instance.inviteCodes,
    };

const _$TeamTypeEnumMap = {
  TeamType.studyGroup: 'studyGroup',
  TeamType.challengeSquad: 'challengeSquad',
  TeamType.accountability: 'accountability',
  TeamType.project: 'project',
  TeamType.interest: 'interest',
};

const _$TeamPrivacyEnumMap = {
  TeamPrivacy.open: 'open',
  TeamPrivacy.inviteOnly: 'inviteOnly',
  TeamPrivacy.closed: 'closed',
};

const _$TeamRoleEnumMap = {
  TeamRole.owner: 'owner',
  TeamRole.admin: 'admin',
  TeamRole.moderator: 'moderator',
  TeamRole.member: 'member',
};

_$TeamSettingsImpl _$$TeamSettingsImplFromJson(Map<String, dynamic> json) =>
    _$TeamSettingsImpl(
      shareStreaks: json['shareStreaks'] as bool,
      shareXP: json['shareXP'] as bool,
      shareActivities: json['shareActivities'] as bool,
      notificationsEnabled: json['notificationsEnabled'] as bool,
      competitiveMode: json['competitiveMode'] as bool,
      checkInFrequency: (json['checkInFrequency'] as num).toInt(),
      autoRemoveInactive: json['autoRemoveInactive'] as bool,
      inactivityDays: (json['inactivityDays'] as num).toInt(),
      requireCheckIn: json['requireCheckIn'] as bool,
      minWeeklyActivities: (json['minWeeklyActivities'] as num).toInt(),
    );

Map<String, dynamic> _$$TeamSettingsImplToJson(_$TeamSettingsImpl instance) =>
    <String, dynamic>{
      'shareStreaks': instance.shareStreaks,
      'shareXP': instance.shareXP,
      'shareActivities': instance.shareActivities,
      'notificationsEnabled': instance.notificationsEnabled,
      'competitiveMode': instance.competitiveMode,
      'checkInFrequency': instance.checkInFrequency,
      'autoRemoveInactive': instance.autoRemoveInactive,
      'inactivityDays': instance.inactivityDays,
      'requireCheckIn': instance.requireCheckIn,
      'minWeeklyActivities': instance.minWeeklyActivities,
    };

_$TeamStatsImpl _$$TeamStatsImplFromJson(Map<String, dynamic> json) =>
    _$TeamStatsImpl(
      totalMembers: (json['totalMembers'] as num).toInt(),
      activeMembers: (json['activeMembers'] as num).toInt(),
      totalSharedStreakDays: (json['totalSharedStreakDays'] as num).toInt(),
      totalSharedActivities: (json['totalSharedActivities'] as num).toInt(),
      totalSharedXP: (json['totalSharedXP'] as num).toInt(),
      completedChallenges: (json['completedChallenges'] as num).toInt(),
      activeChallenges: (json['activeChallenges'] as num).toInt(),
      averageStreakDays: (json['averageStreakDays'] as num).toDouble(),
      pillarXPTotals: Map<String, int>.from(json['pillarXPTotals'] as Map),
      lastUpdated: DateTime.parse(json['lastUpdated'] as String),
    );

Map<String, dynamic> _$$TeamStatsImplToJson(_$TeamStatsImpl instance) =>
    <String, dynamic>{
      'totalMembers': instance.totalMembers,
      'activeMembers': instance.activeMembers,
      'totalSharedStreakDays': instance.totalSharedStreakDays,
      'totalSharedActivities': instance.totalSharedActivities,
      'totalSharedXP': instance.totalSharedXP,
      'completedChallenges': instance.completedChallenges,
      'activeChallenges': instance.activeChallenges,
      'averageStreakDays': instance.averageStreakDays,
      'pillarXPTotals': instance.pillarXPTotals,
      'lastUpdated': instance.lastUpdated.toIso8601String(),
    };

_$TeamChallengeImpl _$$TeamChallengeImplFromJson(Map<String, dynamic> json) =>
    _$TeamChallengeImpl(
      id: json['id'] as String,
      teamId: json['teamId'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      type: $enumDecode(_$ChallengeTypeEnumMap, json['type']),
      startDate: DateTime.parse(json['startDate'] as String),
      endDate: DateTime.parse(json['endDate'] as String),
      goal: _challengeGoalFromJson(json['goal'] as Map<String, dynamic>),
      rewards: (json['rewards'] as List<dynamic>)
          .map((e) => ChallengeReward.fromJson(e as Map<String, dynamic>))
          .toList(),
      participantIds: (json['participantIds'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      progress: (json['progress'] as Map<String, dynamic>).map(
        (k, e) =>
            MapEntry(k, ChallengeProgress.fromJson(e as Map<String, dynamic>)),
      ),
      status: $enumDecode(_$ChallengeStatusEnumMap, json['status']),
      createdBy: json['createdBy'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$$TeamChallengeImplToJson(_$TeamChallengeImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'teamId': instance.teamId,
      'title': instance.title,
      'description': instance.description,
      'type': _$ChallengeTypeEnumMap[instance.type]!,
      'startDate': instance.startDate.toIso8601String(),
      'endDate': instance.endDate.toIso8601String(),
      'goal': _challengeGoalToJson(instance.goal),
      'rewards': instance.rewards,
      'participantIds': instance.participantIds,
      'progress': instance.progress,
      'status': _$ChallengeStatusEnumMap[instance.status]!,
      'createdBy': instance.createdBy,
      'createdAt': instance.createdAt.toIso8601String(),
    };

const _$ChallengeTypeEnumMap = {
  ChallengeType.streak: 'streak',
  ChallengeType.xp: 'xp',
  ChallengeType.activity: 'activity',
  ChallengeType.pillar: 'pillar',
  ChallengeType.consistency: 'consistency',
  ChallengeType.custom: 'custom',
};

const _$ChallengeStatusEnumMap = {
  ChallengeStatus.upcoming: 'upcoming',
  ChallengeStatus.active: 'active',
  ChallengeStatus.completed: 'completed',
  ChallengeStatus.cancelled: 'cancelled',
  ChallengeStatus.failed: 'failed',
};

_$ChallengeRewardImpl _$$ChallengeRewardImplFromJson(
        Map<String, dynamic> json) =>
    _$ChallengeRewardImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      type: $enumDecode(_$RewardTypeEnumMap, json['type']),
      amount: (json['amount'] as num).toInt(),
      rankRequired: (json['rankRequired'] as num).toInt(),
    );

Map<String, dynamic> _$$ChallengeRewardImplToJson(
        _$ChallengeRewardImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'type': _$RewardTypeEnumMap[instance.type]!,
      'amount': instance.amount,
      'rankRequired': instance.rankRequired,
    };

const _$RewardTypeEnumMap = {
  RewardType.xp: 'xp',
  RewardType.freezeToken: 'freezeToken',
  RewardType.graceDay: 'graceDay',
  RewardType.skin: 'skin',
  RewardType.frame: 'frame',
  RewardType.badge: 'badge',
  RewardType.title: 'title',
  RewardType.background: 'background',
  RewardType.particleEffect: 'particleEffect',
  RewardType.coins: 'coins',
};

_$ChallengeProgressImpl _$$ChallengeProgressImplFromJson(
        Map<String, dynamic> json) =>
    _$ChallengeProgressImpl(
      currentValue: (json['currentValue'] as num).toDouble(),
      targetValue: (json['targetValue'] as num).toDouble(),
      percentage: (json['percentage'] as num).toDouble(),
      completionDates: (json['completionDates'] as List<dynamic>)
          .map((e) => DateTime.parse(e as String))
          .toList(),
      metadata: json['metadata'] as Map<String, dynamic>,
      status: $enumDecode(_$ChallengeProgressStatusEnumMap, json['status']),
      startedAt: DateTime.parse(json['startedAt'] as String),
      completedAt: json['completedAt'] == null
          ? null
          : DateTime.parse(json['completedAt'] as String),
    );

Map<String, dynamic> _$$ChallengeProgressImplToJson(
        _$ChallengeProgressImpl instance) =>
    <String, dynamic>{
      'currentValue': instance.currentValue,
      'targetValue': instance.targetValue,
      'percentage': instance.percentage,
      'completionDates':
          instance.completionDates.map((e) => e.toIso8601String()).toList(),
      'metadata': instance.metadata,
      'status': _$ChallengeProgressStatusEnumMap[instance.status]!,
      'startedAt': instance.startedAt.toIso8601String(),
      'completedAt': instance.completedAt?.toIso8601String(),
    };

const _$ChallengeProgressStatusEnumMap = {
  ChallengeProgressStatus.notStarted: 'notStarted',
  ChallengeProgressStatus.inProgress: 'inProgress',
  ChallengeProgressStatus.completed: 'completed',
  ChallengeProgressStatus.failed: 'failed',
  ChallengeProgressStatus.abandoned: 'abandoned',
};

_$CheckInImpl _$$CheckInImplFromJson(Map<String, dynamic> json) =>
    _$CheckInImpl(
      id: json['id'] as String,
      userId: json['userId'] as String,
      buddyId: json['buddyId'] as String?,
      teamId: json['teamId'] as String?,
      type: $enumDecode(_$CheckInTypeEnumMap, json['type']),
      timestamp: DateTime.parse(json['timestamp'] as String),
      data: _checkInDataFromJson(json['data'] as Map<String, dynamic>),
      reactions:
          (json['reactions'] as List<dynamic>).map((e) => e as String).toList(),
      comments: (json['comments'] as List<dynamic>)
          .map((e) => CheckInComment.fromJson(e as Map<String, dynamic>))
          .toList(),
      isPublic: json['isPublic'] as bool,
    );

Map<String, dynamic> _$$CheckInImplToJson(_$CheckInImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'buddyId': instance.buddyId,
      'teamId': instance.teamId,
      'type': _$CheckInTypeEnumMap[instance.type]!,
      'timestamp': instance.timestamp.toIso8601String(),
      'data': _checkInDataToJson(instance.data),
      'reactions': instance.reactions,
      'comments': instance.comments,
      'isPublic': instance.isPublic,
    };

const _$CheckInTypeEnumMap = {
  CheckInType.daily: 'daily',
  CheckInType.weekly: 'weekly',
  CheckInType.milestone: 'milestone',
  CheckInType.streakSave: 'streakSave',
  CheckInType.achievement: 'achievement',
  CheckInType.challengeComplete: 'challengeComplete',
  CheckInType.encouragement: 'encouragement',
};

_$CheckInCommentImpl _$$CheckInCommentImplFromJson(Map<String, dynamic> json) =>
    _$CheckInCommentImpl(
      id: json['id'] as String,
      userId: json['userId'] as String,
      content: json['content'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      reactions:
          (json['reactions'] as List<dynamic>).map((e) => e as String).toList(),
    );

Map<String, dynamic> _$$CheckInCommentImplToJson(
        _$CheckInCommentImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'content': instance.content,
      'timestamp': instance.timestamp.toIso8601String(),
      'reactions': instance.reactions,
    };

_$SocialAchievementImpl _$$SocialAchievementImplFromJson(
        Map<String, dynamic> json) =>
    _$SocialAchievementImpl(
      id: json['id'] as String,
      userId: json['userId'] as String,
      type: $enumDecode(_$SocialAchievementTypeEnumMap, json['type']),
      name: json['name'] as String,
      description: json['description'] as String,
      unlockedAt: DateTime.parse(json['unlockedAt'] as String),
      metadata: json['metadata'] as Map<String, dynamic>,
    );

Map<String, dynamic> _$$SocialAchievementImplToJson(
        _$SocialAchievementImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'type': _$SocialAchievementTypeEnumMap[instance.type]!,
      'name': instance.name,
      'description': instance.description,
      'unlockedAt': instance.unlockedAt.toIso8601String(),
      'metadata': instance.metadata,
    };

const _$SocialAchievementTypeEnumMap = {
  SocialAchievementType.firstBuddy: 'firstBuddy',
  SocialAchievementType.buddyStreak: 'buddyStreak',
  SocialAchievementType.teamFounder: 'teamFounder',
  SocialAchievementType.challengeWinner: 'challengeWinner',
  SocialAchievementType.encouragementSent: 'encouragementSent',
  SocialAchievementType.weeklyCheckIn: 'weeklyCheckIn',
  SocialAchievementType.socialButterfly: 'socialButterfly',
};

_$SocialSettingsImpl _$$SocialSettingsImplFromJson(Map<String, dynamic> json) =>
    _$SocialSettingsImpl(
      buddyRequestsEnabled: json['buddyRequestsEnabled'] as bool,
      teamJoinEnabled: json['teamJoinEnabled'] as bool,
      publicProfile: json['publicProfile'] as bool,
      showOnLeaderboard: json['showOnLeaderboard'] as bool,
      allowDirectMessages: json['allowDirectMessages'] as bool,
      notificationsEnabled: json['notificationsEnabled'] as bool,
      maxBuddies: (json['maxBuddies'] as num).toInt(),
      maxTeams: (json['maxTeams'] as num).toInt(),
      statusMessage: json['statusMessage'] as String?,
    );

Map<String, dynamic> _$$SocialSettingsImplToJson(
        _$SocialSettingsImpl instance) =>
    <String, dynamic>{
      'buddyRequestsEnabled': instance.buddyRequestsEnabled,
      'teamJoinEnabled': instance.teamJoinEnabled,
      'publicProfile': instance.publicProfile,
      'showOnLeaderboard': instance.showOnLeaderboard,
      'allowDirectMessages': instance.allowDirectMessages,
      'notificationsEnabled': instance.notificationsEnabled,
      'maxBuddies': instance.maxBuddies,
      'maxTeams': instance.maxTeams,
      'statusMessage': instance.statusMessage,
    };
