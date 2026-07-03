// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'missions.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$MissionImpl _$$MissionImplFromJson(Map<String, dynamic> json) =>
    _$MissionImpl(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      type: const MissionTypeConverter().fromJson(json['type'] as String),
      category:
          const MissionCategoryConverter().fromJson(json['category'] as String),
      difficulty: const MissionDifficultyConverter()
          .fromJson(json['difficulty'] as String),
      xpReward: (json['xpReward'] as num).toInt(),
      pillar: $enumDecode(_$AdmissionsPillarEnumMap, json['pillar']),
      completionCriteria: json['completionCriteria'] as Map<String, dynamic>,
      prerequisites: (json['prerequisites'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      isCompleted: json['isCompleted'] as bool,
      isClaimed: json['isClaimed'] as bool,
      completedAt: json['completedAt'] == null
          ? null
          : DateTime.parse(json['completedAt'] as String),
      claimedAt: json['claimedAt'] == null
          ? null
          : DateTime.parse(json['claimedAt'] as String),
      createdAt: DateTime.parse(json['createdAt'] as String),
      expiresAt: json['expiresAt'] == null
          ? null
          : DateTime.parse(json['expiresAt'] as String),
      metadata: json['metadata'] as Map<String, dynamic>?,
      progressCurrent: (json['progressCurrent'] as num).toInt(),
      progressTarget: (json['progressTarget'] as num).toInt(),
      progressUnit: json['progressUnit'] as String,
      isRepeatable: json['isRepeatable'] as bool,
      repeatCooldownDays: (json['repeatCooldownDays'] as num).toInt(),
      tags: (json['tags'] as List<dynamic>).map((e) => e as String).toList(),
    );

Map<String, dynamic> _$$MissionImplToJson(_$MissionImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'type': const MissionTypeConverter().toJson(instance.type),
      'category': const MissionCategoryConverter().toJson(instance.category),
      'difficulty':
          const MissionDifficultyConverter().toJson(instance.difficulty),
      'xpReward': instance.xpReward,
      'pillar': _$AdmissionsPillarEnumMap[instance.pillar]!,
      'completionCriteria': instance.completionCriteria,
      'prerequisites': instance.prerequisites,
      'isCompleted': instance.isCompleted,
      'isClaimed': instance.isClaimed,
      'completedAt': instance.completedAt?.toIso8601String(),
      'claimedAt': instance.claimedAt?.toIso8601String(),
      'createdAt': instance.createdAt.toIso8601String(),
      'expiresAt': instance.expiresAt?.toIso8601String(),
      'metadata': instance.metadata,
      'progressCurrent': instance.progressCurrent,
      'progressTarget': instance.progressTarget,
      'progressUnit': instance.progressUnit,
      'isRepeatable': instance.isRepeatable,
      'repeatCooldownDays': instance.repeatCooldownDays,
      'tags': instance.tags,
    };

const _$AdmissionsPillarEnumMap = {
  AdmissionsPillar.academics: 'academics',
  AdmissionsPillar.evidence: 'evidence',
  AdmissionsPillar.consistency: 'consistency',
  AdmissionsPillar.research: 'research',
  AdmissionsPillar.leadership: 'leadership',
  AdmissionsPillar.creativity: 'creativity',
  AdmissionsPillar.communityImpact: 'communityImpact',
  AdmissionsPillar.trailblazer: 'trailblazer',
};

_$WeeklyMissionSetImpl _$$WeeklyMissionSetImplFromJson(
        Map<String, dynamic> json) =>
    _$WeeklyMissionSetImpl(
      id: json['id'] as String,
      weekStart: DateTime.parse(json['weekStart'] as String),
      weekEnd: DateTime.parse(json['weekEnd'] as String),
      missions: (json['missions'] as List<dynamic>)
          .map((e) => Mission.fromJson(e as Map<String, dynamic>))
          .toList(),
      totalXPReward: (json['totalXPReward'] as num).toInt(),
      isBonusClaimed: json['isBonusClaimed'] as bool,
      bonusClaimedAt: json['bonusClaimedAt'] == null
          ? null
          : DateTime.parse(json['bonusClaimedAt'] as String),
      categoryCompletion:
          (json['categoryCompletion'] as Map<String, dynamic>).map(
        (k, e) => MapEntry(
            $enumDecode(_$MissionCategoryEnumMap, k), (e as num).toInt()),
      ),
    );

Map<String, dynamic> _$$WeeklyMissionSetImplToJson(
        _$WeeklyMissionSetImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'weekStart': instance.weekStart.toIso8601String(),
      'weekEnd': instance.weekEnd.toIso8601String(),
      'missions': instance.missions,
      'totalXPReward': instance.totalXPReward,
      'isBonusClaimed': instance.isBonusClaimed,
      'bonusClaimedAt': instance.bonusClaimedAt?.toIso8601String(),
      'categoryCompletion': instance.categoryCompletion
          .map((k, e) => MapEntry(_$MissionCategoryEnumMap[k]!, e)),
    };

const _$MissionCategoryEnumMap = {
  MissionCategory.academics: 'academics',
  MissionCategory.activities: 'activities',
  MissionCategory.profile: 'profile',
  MissionCategory.wellbeing: 'wellbeing',
  MissionCategory.exploration: 'exploration',
  MissionCategory.social: 'social',
};

_$MissionGenerationConfigImpl _$$MissionGenerationConfigImplFromJson(
        Map<String, dynamic> json) =>
    _$MissionGenerationConfigImpl(
      dailyMissionsCount: (json['dailyMissionsCount'] as num).toInt(),
      weeklyMissionsCount: (json['weeklyMissionsCount'] as num).toInt(),
      categoryDistribution:
          (json['categoryDistribution'] as Map<String, dynamic>).map(
        (k, e) => MapEntry(
            $enumDecode(_$MissionCategoryEnumMap, k), (e as num).toInt()),
      ),
      difficultyDistribution:
          (json['difficultyDistribution'] as Map<String, dynamic>).map(
        (k, e) => MapEntry(
            $enumDecode(_$MissionDifficultyEnumMap, k), (e as num).toInt()),
      ),
      pillarDistribution:
          (json['pillarDistribution'] as Map<String, dynamic>).map(
        (k, e) => MapEntry(
            $enumDecode(_$AdmissionsPillarEnumMap, k), (e as num).toInt()),
      ),
      ensureVariety: json['ensureVariety'] as bool,
      maxRepeatInRow: (json['maxRepeatInRow'] as num).toInt(),
    );

Map<String, dynamic> _$$MissionGenerationConfigImplToJson(
        _$MissionGenerationConfigImpl instance) =>
    <String, dynamic>{
      'dailyMissionsCount': instance.dailyMissionsCount,
      'weeklyMissionsCount': instance.weeklyMissionsCount,
      'categoryDistribution': instance.categoryDistribution
          .map((k, e) => MapEntry(_$MissionCategoryEnumMap[k]!, e)),
      'difficultyDistribution': instance.difficultyDistribution
          .map((k, e) => MapEntry(_$MissionDifficultyEnumMap[k]!, e)),
      'pillarDistribution': instance.pillarDistribution
          .map((k, e) => MapEntry(_$AdmissionsPillarEnumMap[k]!, e)),
      'ensureVariety': instance.ensureVariety,
      'maxRepeatInRow': instance.maxRepeatInRow,
    };

const _$MissionDifficultyEnumMap = {
  MissionDifficulty.easy: 'easy',
  MissionDifficulty.medium: 'medium',
  MissionDifficulty.hard: 'hard',
  MissionDifficulty.expert: 'expert',
};

_$MissionTemplateImpl _$$MissionTemplateImplFromJson(
        Map<String, dynamic> json) =>
    _$MissionTemplateImpl(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      type: const MissionTypeConverter().fromJson(json['type'] as String),
      category:
          const MissionCategoryConverter().fromJson(json['category'] as String),
      difficulty: const MissionDifficultyConverter()
          .fromJson(json['difficulty'] as String),
      xpReward: (json['xpReward'] as num).toInt(),
      pillar: $enumDecode(_$AdmissionsPillarEnumMap, json['pillar']),
      completionCriteria: json['completionCriteria'] as Map<String, dynamic>,
      prerequisites: (json['prerequisites'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      progressTarget: (json['progressTarget'] as num).toInt(),
      progressUnit: json['progressUnit'] as String,
      isRepeatable: json['isRepeatable'] as bool,
      repeatCooldownDays: (json['repeatCooldownDays'] as num).toInt(),
      tags: (json['tags'] as List<dynamic>).map((e) => e as String).toList(),
    );

Map<String, dynamic> _$$MissionTemplateImplToJson(
        _$MissionTemplateImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'type': const MissionTypeConverter().toJson(instance.type),
      'category': const MissionCategoryConverter().toJson(instance.category),
      'difficulty':
          const MissionDifficultyConverter().toJson(instance.difficulty),
      'xpReward': instance.xpReward,
      'pillar': _$AdmissionsPillarEnumMap[instance.pillar]!,
      'completionCriteria': instance.completionCriteria,
      'prerequisites': instance.prerequisites,
      'progressTarget': instance.progressTarget,
      'progressUnit': instance.progressUnit,
      'isRepeatable': instance.isRepeatable,
      'repeatCooldownDays': instance.repeatCooldownDays,
      'tags': instance.tags,
    };

_$MissionProgressImpl _$$MissionProgressImplFromJson(
        Map<String, dynamic> json) =>
    _$MissionProgressImpl(
      missionId: json['missionId'] as String,
      currentProgress: (json['currentProgress'] as num).toInt(),
      targetProgress: (json['targetProgress'] as num).toInt(),
      progressData: json['progressData'] as Map<String, dynamic>,
      lastUpdated: DateTime.parse(json['lastUpdated'] as String),
      isCompleted: json['isCompleted'] as bool,
      completedAt: json['completedAt'] == null
          ? null
          : DateTime.parse(json['completedAt'] as String),
    );

Map<String, dynamic> _$$MissionProgressImplToJson(
        _$MissionProgressImpl instance) =>
    <String, dynamic>{
      'missionId': instance.missionId,
      'currentProgress': instance.currentProgress,
      'targetProgress': instance.targetProgress,
      'progressData': instance.progressData,
      'lastUpdated': instance.lastUpdated.toIso8601String(),
      'isCompleted': instance.isCompleted,
      'completedAt': instance.completedAt?.toIso8601String(),
    };
