// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_profile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserProfileImpl _$$UserProfileImplFromJson(Map<String, dynamic> json) =>
    _$UserProfileImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String,
      board: json['board'] as String?,
      stream: json['stream'] as String?,
      grade: (json['grade'] as num).toInt(),
      subjects: (json['subjects'] as Map<String, dynamic>).map(
        (k, e) => MapEntry(k, (e as num).toDouble()),
      ),
      tenthPercentage: (json['tenthPercentage'] as num).toDouble(),
      coachingInstitute: json['coachingInstitute'] as String,
      coachingHoursPerWeek: (json['coachingHoursPerWeek'] as num).toInt(),
      satScore: (json['satScore'] as num?)?.toInt(),
      ieltsScore: (json['ieltsScore'] as num?)?.toDouble(),
      targetCountries: (json['targetCountries'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      targetMajor: json['targetMajor'] as String,
      reachUniversities: (json['reachUniversities'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      matchUniversities: (json['matchUniversities'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      safetyUniversities: (json['safetyUniversities'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      activities: (json['activities'] as List<dynamic>)
          .map((e) => Activity.fromJson(e as Map<String, dynamic>))
          .toList(),
      schedule:
          WeeklySchedule.fromJson(json['schedule'] as Map<String, dynamic>),
      motivation: MotivationProfile.fromJson(
          json['motivation'] as Map<String, dynamic>),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      interests:
          (json['interests'] as List<dynamic>).map((e) => e as String).toList(),
      skills:
          (json['skills'] as List<dynamic>).map((e) => e as String).toList(),
      preferredLocations: (json['preferredLocations'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
      city: json['city'] as String?,
      state: json['state'] as String?,
      pincode: json['pincode'] as String?,
      preferences: json['preferences'] as Map<String, dynamic>,
    );

Map<String, dynamic> _$$UserProfileImplToJson(_$UserProfileImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'email': instance.email,
      'phone': instance.phone,
      'board': instance.board,
      'stream': instance.stream,
      'grade': instance.grade,
      'subjects': instance.subjects,
      'tenthPercentage': instance.tenthPercentage,
      'coachingInstitute': instance.coachingInstitute,
      'coachingHoursPerWeek': instance.coachingHoursPerWeek,
      'satScore': instance.satScore,
      'ieltsScore': instance.ieltsScore,
      'targetCountries': instance.targetCountries,
      'targetMajor': instance.targetMajor,
      'reachUniversities': instance.reachUniversities,
      'matchUniversities': instance.matchUniversities,
      'safetyUniversities': instance.safetyUniversities,
      'activities': instance.activities,
      'schedule': instance.schedule,
      'motivation': instance.motivation,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'interests': instance.interests,
      'skills': instance.skills,
      'preferredLocations': instance.preferredLocations,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'city': instance.city,
      'state': instance.state,
      'pincode': instance.pincode,
      'preferences': instance.preferences,
    };

_$ActivityImpl _$$ActivityImplFromJson(Map<String, dynamic> json) =>
    _$ActivityImpl(
      id: json['id'] as String,
      title: json['title'] as String,
      category: $enumDecode(_$ActivityCategoryEnumMap, json['category']),
      tier: $enumDecode(_$ActivityTierEnumMap, json['tier']),
      description: json['description'] as String,
      hoursPerWeek: (json['hoursPerWeek'] as num).toInt(),
      weeksPerYear: (json['weeksPerYear'] as num).toInt(),
      startDate: DateTime.parse(json['startDate'] as String),
      endDate: json['endDate'] == null
          ? null
          : DateTime.parse(json['endDate'] as String),
      evidence: json['evidence'] as String?,
      teacherVerification: json['teacherVerification'] as String?,
      skills:
          (json['skills'] as List<dynamic>).map((e) => e as String).toList(),
      narrativeAngle: json['narrativeAngle'] as String,
      admissionsValue: (json['admissionsValue'] as num).toInt(),
      isInSchool: json['isInSchool'] as bool,
      location: json['location'] as String?,
    );

Map<String, dynamic> _$$ActivityImplToJson(_$ActivityImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'category': _$ActivityCategoryEnumMap[instance.category]!,
      'tier': _$ActivityTierEnumMap[instance.tier]!,
      'description': instance.description,
      'hoursPerWeek': instance.hoursPerWeek,
      'weeksPerYear': instance.weeksPerYear,
      'startDate': instance.startDate.toIso8601String(),
      'endDate': instance.endDate?.toIso8601String(),
      'evidence': instance.evidence,
      'teacherVerification': instance.teacherVerification,
      'skills': instance.skills,
      'narrativeAngle': instance.narrativeAngle,
      'admissionsValue': instance.admissionsValue,
      'isInSchool': instance.isInSchool,
      'location': instance.location,
    };

const _$ActivityCategoryEnumMap = {
  ActivityCategory.clubs: 'clubs',
  ActivityCategory.sports: 'sports',
  ActivityCategory.arts: 'arts',
  ActivityCategory.competitions: 'competitions',
  ActivityCategory.research: 'research',
  ActivityCategory.volunteering: 'volunteering',
  ActivityCategory.leadership: 'leadership',
  ActivityCategory.work: 'work',
  ActivityCategory.courses: 'courses',
  ActivityCategory.unique: 'unique',
};

const _$ActivityTierEnumMap = {
  ActivityTier.tier1: 'tier1',
  ActivityTier.tier2: 'tier2',
  ActivityTier.tier3: 'tier3',
  ActivityTier.tier4: 'tier4',
};

_$WeeklyScheduleImpl _$$WeeklyScheduleImplFromJson(Map<String, dynamic> json) =>
    _$WeeklyScheduleImpl(
      schedule: (json['schedule'] as Map<String, dynamic>).map(
        (k, e) => MapEntry(
            k,
            (e as List<dynamic>)
                .map((e) => TimeBlock.fromJson(e as Map<String, dynamic>))
                .toList()),
      ),
      discretionaryHoursWeekday:
          (json['discretionaryHoursWeekday'] as num).toInt(),
      discretionaryHoursWeekend:
          (json['discretionaryHoursWeekend'] as num).toInt(),
    );

Map<String, dynamic> _$$WeeklyScheduleImplToJson(
        _$WeeklyScheduleImpl instance) =>
    <String, dynamic>{
      'schedule': instance.schedule,
      'discretionaryHoursWeekday': instance.discretionaryHoursWeekday,
      'discretionaryHoursWeekend': instance.discretionaryHoursWeekend,
    };

_$TimeBlockImpl _$$TimeBlockImplFromJson(Map<String, dynamic> json) =>
    _$TimeBlockImpl(
      id: json['id'] as String,
      label: json['label'] as String,
      startTime: json['startTime'] as String,
      endTime: json['endTime'] as String,
      type: $enumDecode(_$TimeBlockTypeEnumMap, json['type']),
      isFree: json['isFree'] as bool,
    );

Map<String, dynamic> _$$TimeBlockImplToJson(_$TimeBlockImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'label': instance.label,
      'startTime': instance.startTime,
      'endTime': instance.endTime,
      'type': _$TimeBlockTypeEnumMap[instance.type]!,
      'isFree': instance.isFree,
    };

const _$TimeBlockTypeEnumMap = {
  TimeBlockType.school: 'school',
  TimeBlockType.coaching: 'coaching',
  TimeBlockType.sleep: 'sleep',
  TimeBlockType.commute: 'commute',
  TimeBlockType.meal: 'meal',
  TimeBlockType.free: 'free',
  TimeBlockType.club: 'club',
  TimeBlockType.study: 'study',
  TimeBlockType.other: 'other',
};

_$MotivationProfileImpl _$$MotivationProfileImplFromJson(
        Map<String, dynamic> json) =>
    _$MotivationProfileImpl(
      drivers: (json['drivers'] as List<dynamic>)
          .map((e) => $enumDecode(_$MotivationDriverEnumMap, e))
          .toList(),
      stressStyle: $enumDecode(_$StressStyleEnumMap, json['stressStyle']),
    );

Map<String, dynamic> _$$MotivationProfileImplToJson(
        _$MotivationProfileImpl instance) =>
    <String, dynamic>{
      'drivers':
          instance.drivers.map((e) => _$MotivationDriverEnumMap[e]!).toList(),
      'stressStyle': _$StressStyleEnumMap[instance.stressStyle]!,
    };

const _$MotivationDriverEnumMap = {
  MotivationDriver.familyPride: 'family_pride',
  MotivationDriver.peerComparison: 'peer_comparison',
  MotivationDriver.fearOfFailure: 'fear_of_failure',
  MotivationDriver.scholarshipNeed: 'scholarship_need',
  MotivationDriver.genuineCuriosity: 'genuine_curiosity',
  MotivationDriver.statusAbroadDream: 'status_abroad_dream',
};

const _$StressStyleEnumMap = {
  StressStyle.planner: 'planner',
  StressStyle.sprinter: 'sprinter',
  StressStyle.avoider: 'avoider',
};
