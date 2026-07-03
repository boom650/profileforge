// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'missions.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Mission _$MissionFromJson(Map<String, dynamic> json) {
  return _Mission.fromJson(json);
}

/// @nodoc
mixin _$Mission {
  String get id => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  @MissionTypeConverter()
  MissionType get type => throw _privateConstructorUsedError;
  @MissionCategoryConverter()
  MissionCategory get category => throw _privateConstructorUsedError;
  @MissionDifficultyConverter()
  MissionDifficulty get difficulty => throw _privateConstructorUsedError;
  int get xpReward => throw _privateConstructorUsedError;
  AdmissionsPillar get pillar => throw _privateConstructorUsedError;
  Map<String, dynamic> get completionCriteria =>
      throw _privateConstructorUsedError;
  List<String> get prerequisites => throw _privateConstructorUsedError;
  bool get isCompleted => throw _privateConstructorUsedError;
  bool get isClaimed => throw _privateConstructorUsedError;
  DateTime? get completedAt => throw _privateConstructorUsedError;
  DateTime? get claimedAt => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime? get expiresAt => throw _privateConstructorUsedError;
  Map<String, dynamic>? get metadata => throw _privateConstructorUsedError;
  int get progressCurrent => throw _privateConstructorUsedError;
  int get progressTarget => throw _privateConstructorUsedError;
  String get progressUnit => throw _privateConstructorUsedError;
  bool get isRepeatable => throw _privateConstructorUsedError;
  int get repeatCooldownDays => throw _privateConstructorUsedError;
  List<String> get tags => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $MissionCopyWith<Mission> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MissionCopyWith<$Res> {
  factory $MissionCopyWith(Mission value, $Res Function(Mission) then) =
      _$MissionCopyWithImpl<$Res, Mission>;
  @useResult
  $Res call(
      {String id,
      String title,
      String description,
      @MissionTypeConverter() MissionType type,
      @MissionCategoryConverter() MissionCategory category,
      @MissionDifficultyConverter() MissionDifficulty difficulty,
      int xpReward,
      AdmissionsPillar pillar,
      Map<String, dynamic> completionCriteria,
      List<String> prerequisites,
      bool isCompleted,
      bool isClaimed,
      DateTime? completedAt,
      DateTime? claimedAt,
      DateTime createdAt,
      DateTime? expiresAt,
      Map<String, dynamic>? metadata,
      int progressCurrent,
      int progressTarget,
      String progressUnit,
      bool isRepeatable,
      int repeatCooldownDays,
      List<String> tags});
}

/// @nodoc
class _$MissionCopyWithImpl<$Res, $Val extends Mission>
    implements $MissionCopyWith<$Res> {
  _$MissionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? description = null,
    Object? type = null,
    Object? category = null,
    Object? difficulty = null,
    Object? xpReward = null,
    Object? pillar = null,
    Object? completionCriteria = null,
    Object? prerequisites = null,
    Object? isCompleted = null,
    Object? isClaimed = null,
    Object? completedAt = freezed,
    Object? claimedAt = freezed,
    Object? createdAt = null,
    Object? expiresAt = freezed,
    Object? metadata = freezed,
    Object? progressCurrent = null,
    Object? progressTarget = null,
    Object? progressUnit = null,
    Object? isRepeatable = null,
    Object? repeatCooldownDays = null,
    Object? tags = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as MissionType,
      category: null == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as MissionCategory,
      difficulty: null == difficulty
          ? _value.difficulty
          : difficulty // ignore: cast_nullable_to_non_nullable
              as MissionDifficulty,
      xpReward: null == xpReward
          ? _value.xpReward
          : xpReward // ignore: cast_nullable_to_non_nullable
              as int,
      pillar: null == pillar
          ? _value.pillar
          : pillar // ignore: cast_nullable_to_non_nullable
              as AdmissionsPillar,
      completionCriteria: null == completionCriteria
          ? _value.completionCriteria
          : completionCriteria // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      prerequisites: null == prerequisites
          ? _value.prerequisites
          : prerequisites // ignore: cast_nullable_to_non_nullable
              as List<String>,
      isCompleted: null == isCompleted
          ? _value.isCompleted
          : isCompleted // ignore: cast_nullable_to_non_nullable
              as bool,
      isClaimed: null == isClaimed
          ? _value.isClaimed
          : isClaimed // ignore: cast_nullable_to_non_nullable
              as bool,
      completedAt: freezed == completedAt
          ? _value.completedAt
          : completedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      claimedAt: freezed == claimedAt
          ? _value.claimedAt
          : claimedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      expiresAt: freezed == expiresAt
          ? _value.expiresAt
          : expiresAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      metadata: freezed == metadata
          ? _value.metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      progressCurrent: null == progressCurrent
          ? _value.progressCurrent
          : progressCurrent // ignore: cast_nullable_to_non_nullable
              as int,
      progressTarget: null == progressTarget
          ? _value.progressTarget
          : progressTarget // ignore: cast_nullable_to_non_nullable
              as int,
      progressUnit: null == progressUnit
          ? _value.progressUnit
          : progressUnit // ignore: cast_nullable_to_non_nullable
              as String,
      isRepeatable: null == isRepeatable
          ? _value.isRepeatable
          : isRepeatable // ignore: cast_nullable_to_non_nullable
              as bool,
      repeatCooldownDays: null == repeatCooldownDays
          ? _value.repeatCooldownDays
          : repeatCooldownDays // ignore: cast_nullable_to_non_nullable
              as int,
      tags: null == tags
          ? _value.tags
          : tags // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$MissionImplCopyWith<$Res> implements $MissionCopyWith<$Res> {
  factory _$$MissionImplCopyWith(
          _$MissionImpl value, $Res Function(_$MissionImpl) then) =
      __$$MissionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String title,
      String description,
      @MissionTypeConverter() MissionType type,
      @MissionCategoryConverter() MissionCategory category,
      @MissionDifficultyConverter() MissionDifficulty difficulty,
      int xpReward,
      AdmissionsPillar pillar,
      Map<String, dynamic> completionCriteria,
      List<String> prerequisites,
      bool isCompleted,
      bool isClaimed,
      DateTime? completedAt,
      DateTime? claimedAt,
      DateTime createdAt,
      DateTime? expiresAt,
      Map<String, dynamic>? metadata,
      int progressCurrent,
      int progressTarget,
      String progressUnit,
      bool isRepeatable,
      int repeatCooldownDays,
      List<String> tags});
}

/// @nodoc
class __$$MissionImplCopyWithImpl<$Res>
    extends _$MissionCopyWithImpl<$Res, _$MissionImpl>
    implements _$$MissionImplCopyWith<$Res> {
  __$$MissionImplCopyWithImpl(
      _$MissionImpl _value, $Res Function(_$MissionImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? description = null,
    Object? type = null,
    Object? category = null,
    Object? difficulty = null,
    Object? xpReward = null,
    Object? pillar = null,
    Object? completionCriteria = null,
    Object? prerequisites = null,
    Object? isCompleted = null,
    Object? isClaimed = null,
    Object? completedAt = freezed,
    Object? claimedAt = freezed,
    Object? createdAt = null,
    Object? expiresAt = freezed,
    Object? metadata = freezed,
    Object? progressCurrent = null,
    Object? progressTarget = null,
    Object? progressUnit = null,
    Object? isRepeatable = null,
    Object? repeatCooldownDays = null,
    Object? tags = null,
  }) {
    return _then(_$MissionImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as MissionType,
      category: null == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as MissionCategory,
      difficulty: null == difficulty
          ? _value.difficulty
          : difficulty // ignore: cast_nullable_to_non_nullable
              as MissionDifficulty,
      xpReward: null == xpReward
          ? _value.xpReward
          : xpReward // ignore: cast_nullable_to_non_nullable
              as int,
      pillar: null == pillar
          ? _value.pillar
          : pillar // ignore: cast_nullable_to_non_nullable
              as AdmissionsPillar,
      completionCriteria: null == completionCriteria
          ? _value._completionCriteria
          : completionCriteria // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      prerequisites: null == prerequisites
          ? _value._prerequisites
          : prerequisites // ignore: cast_nullable_to_non_nullable
              as List<String>,
      isCompleted: null == isCompleted
          ? _value.isCompleted
          : isCompleted // ignore: cast_nullable_to_non_nullable
              as bool,
      isClaimed: null == isClaimed
          ? _value.isClaimed
          : isClaimed // ignore: cast_nullable_to_non_nullable
              as bool,
      completedAt: freezed == completedAt
          ? _value.completedAt
          : completedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      claimedAt: freezed == claimedAt
          ? _value.claimedAt
          : claimedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      expiresAt: freezed == expiresAt
          ? _value.expiresAt
          : expiresAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      metadata: freezed == metadata
          ? _value._metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      progressCurrent: null == progressCurrent
          ? _value.progressCurrent
          : progressCurrent // ignore: cast_nullable_to_non_nullable
              as int,
      progressTarget: null == progressTarget
          ? _value.progressTarget
          : progressTarget // ignore: cast_nullable_to_non_nullable
              as int,
      progressUnit: null == progressUnit
          ? _value.progressUnit
          : progressUnit // ignore: cast_nullable_to_non_nullable
              as String,
      isRepeatable: null == isRepeatable
          ? _value.isRepeatable
          : isRepeatable // ignore: cast_nullable_to_non_nullable
              as bool,
      repeatCooldownDays: null == repeatCooldownDays
          ? _value.repeatCooldownDays
          : repeatCooldownDays // ignore: cast_nullable_to_non_nullable
              as int,
      tags: null == tags
          ? _value._tags
          : tags // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$MissionImpl implements _Mission {
  const _$MissionImpl(
      {required this.id,
      required this.title,
      required this.description,
      @MissionTypeConverter() required this.type,
      @MissionCategoryConverter() required this.category,
      @MissionDifficultyConverter() required this.difficulty,
      required this.xpReward,
      required this.pillar,
      required final Map<String, dynamic> completionCriteria,
      required final List<String> prerequisites,
      required this.isCompleted,
      required this.isClaimed,
      required this.completedAt,
      required this.claimedAt,
      required this.createdAt,
      required this.expiresAt,
      required final Map<String, dynamic>? metadata,
      required this.progressCurrent,
      required this.progressTarget,
      required this.progressUnit,
      required this.isRepeatable,
      required this.repeatCooldownDays,
      required final List<String> tags})
      : _completionCriteria = completionCriteria,
        _prerequisites = prerequisites,
        _metadata = metadata,
        _tags = tags;

  factory _$MissionImpl.fromJson(Map<String, dynamic> json) =>
      _$$MissionImplFromJson(json);

  @override
  final String id;
  @override
  final String title;
  @override
  final String description;
  @override
  @MissionTypeConverter()
  final MissionType type;
  @override
  @MissionCategoryConverter()
  final MissionCategory category;
  @override
  @MissionDifficultyConverter()
  final MissionDifficulty difficulty;
  @override
  final int xpReward;
  @override
  final AdmissionsPillar pillar;
  final Map<String, dynamic> _completionCriteria;
  @override
  Map<String, dynamic> get completionCriteria {
    if (_completionCriteria is EqualUnmodifiableMapView)
      return _completionCriteria;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_completionCriteria);
  }

  final List<String> _prerequisites;
  @override
  List<String> get prerequisites {
    if (_prerequisites is EqualUnmodifiableListView) return _prerequisites;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_prerequisites);
  }

  @override
  final bool isCompleted;
  @override
  final bool isClaimed;
  @override
  final DateTime? completedAt;
  @override
  final DateTime? claimedAt;
  @override
  final DateTime createdAt;
  @override
  final DateTime? expiresAt;
  final Map<String, dynamic>? _metadata;
  @override
  Map<String, dynamic>? get metadata {
    final value = _metadata;
    if (value == null) return null;
    if (_metadata is EqualUnmodifiableMapView) return _metadata;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  final int progressCurrent;
  @override
  final int progressTarget;
  @override
  final String progressUnit;
  @override
  final bool isRepeatable;
  @override
  final int repeatCooldownDays;
  final List<String> _tags;
  @override
  List<String> get tags {
    if (_tags is EqualUnmodifiableListView) return _tags;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_tags);
  }

  @override
  String toString() {
    return 'Mission(id: $id, title: $title, description: $description, type: $type, category: $category, difficulty: $difficulty, xpReward: $xpReward, pillar: $pillar, completionCriteria: $completionCriteria, prerequisites: $prerequisites, isCompleted: $isCompleted, isClaimed: $isClaimed, completedAt: $completedAt, claimedAt: $claimedAt, createdAt: $createdAt, expiresAt: $expiresAt, metadata: $metadata, progressCurrent: $progressCurrent, progressTarget: $progressTarget, progressUnit: $progressUnit, isRepeatable: $isRepeatable, repeatCooldownDays: $repeatCooldownDays, tags: $tags)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MissionImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.difficulty, difficulty) ||
                other.difficulty == difficulty) &&
            (identical(other.xpReward, xpReward) ||
                other.xpReward == xpReward) &&
            (identical(other.pillar, pillar) || other.pillar == pillar) &&
            const DeepCollectionEquality()
                .equals(other._completionCriteria, _completionCriteria) &&
            const DeepCollectionEquality()
                .equals(other._prerequisites, _prerequisites) &&
            (identical(other.isCompleted, isCompleted) ||
                other.isCompleted == isCompleted) &&
            (identical(other.isClaimed, isClaimed) ||
                other.isClaimed == isClaimed) &&
            (identical(other.completedAt, completedAt) ||
                other.completedAt == completedAt) &&
            (identical(other.claimedAt, claimedAt) ||
                other.claimedAt == claimedAt) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.expiresAt, expiresAt) ||
                other.expiresAt == expiresAt) &&
            const DeepCollectionEquality().equals(other._metadata, _metadata) &&
            (identical(other.progressCurrent, progressCurrent) ||
                other.progressCurrent == progressCurrent) &&
            (identical(other.progressTarget, progressTarget) ||
                other.progressTarget == progressTarget) &&
            (identical(other.progressUnit, progressUnit) ||
                other.progressUnit == progressUnit) &&
            (identical(other.isRepeatable, isRepeatable) ||
                other.isRepeatable == isRepeatable) &&
            (identical(other.repeatCooldownDays, repeatCooldownDays) ||
                other.repeatCooldownDays == repeatCooldownDays) &&
            const DeepCollectionEquality().equals(other._tags, _tags));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        id,
        title,
        description,
        type,
        category,
        difficulty,
        xpReward,
        pillar,
        const DeepCollectionEquality().hash(_completionCriteria),
        const DeepCollectionEquality().hash(_prerequisites),
        isCompleted,
        isClaimed,
        completedAt,
        claimedAt,
        createdAt,
        expiresAt,
        const DeepCollectionEquality().hash(_metadata),
        progressCurrent,
        progressTarget,
        progressUnit,
        isRepeatable,
        repeatCooldownDays,
        const DeepCollectionEquality().hash(_tags)
      ]);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$MissionImplCopyWith<_$MissionImpl> get copyWith =>
      __$$MissionImplCopyWithImpl<_$MissionImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MissionImplToJson(
      this,
    );
  }
}

abstract class _Mission implements Mission {
  const factory _Mission(
      {required final String id,
      required final String title,
      required final String description,
      @MissionTypeConverter() required final MissionType type,
      @MissionCategoryConverter() required final MissionCategory category,
      @MissionDifficultyConverter() required final MissionDifficulty difficulty,
      required final int xpReward,
      required final AdmissionsPillar pillar,
      required final Map<String, dynamic> completionCriteria,
      required final List<String> prerequisites,
      required final bool isCompleted,
      required final bool isClaimed,
      required final DateTime? completedAt,
      required final DateTime? claimedAt,
      required final DateTime createdAt,
      required final DateTime? expiresAt,
      required final Map<String, dynamic>? metadata,
      required final int progressCurrent,
      required final int progressTarget,
      required final String progressUnit,
      required final bool isRepeatable,
      required final int repeatCooldownDays,
      required final List<String> tags}) = _$MissionImpl;

  factory _Mission.fromJson(Map<String, dynamic> json) = _$MissionImpl.fromJson;

  @override
  String get id;
  @override
  String get title;
  @override
  String get description;
  @override
  @MissionTypeConverter()
  MissionType get type;
  @override
  @MissionCategoryConverter()
  MissionCategory get category;
  @override
  @MissionDifficultyConverter()
  MissionDifficulty get difficulty;
  @override
  int get xpReward;
  @override
  AdmissionsPillar get pillar;
  @override
  Map<String, dynamic> get completionCriteria;
  @override
  List<String> get prerequisites;
  @override
  bool get isCompleted;
  @override
  bool get isClaimed;
  @override
  DateTime? get completedAt;
  @override
  DateTime? get claimedAt;
  @override
  DateTime get createdAt;
  @override
  DateTime? get expiresAt;
  @override
  Map<String, dynamic>? get metadata;
  @override
  int get progressCurrent;
  @override
  int get progressTarget;
  @override
  String get progressUnit;
  @override
  bool get isRepeatable;
  @override
  int get repeatCooldownDays;
  @override
  List<String> get tags;
  @override
  @JsonKey(ignore: true)
  _$$MissionImplCopyWith<_$MissionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

WeeklyMissionSet _$WeeklyMissionSetFromJson(Map<String, dynamic> json) {
  return _WeeklyMissionSet.fromJson(json);
}

/// @nodoc
mixin _$WeeklyMissionSet {
  String get id => throw _privateConstructorUsedError;
  DateTime get weekStart => throw _privateConstructorUsedError;
  DateTime get weekEnd => throw _privateConstructorUsedError;
  List<Mission> get missions => throw _privateConstructorUsedError;
  int get totalXPReward => throw _privateConstructorUsedError;
  bool get isBonusClaimed => throw _privateConstructorUsedError;
  DateTime? get bonusClaimedAt => throw _privateConstructorUsedError;
  Map<MissionCategory, int> get categoryCompletion =>
      throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $WeeklyMissionSetCopyWith<WeeklyMissionSet> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WeeklyMissionSetCopyWith<$Res> {
  factory $WeeklyMissionSetCopyWith(
          WeeklyMissionSet value, $Res Function(WeeklyMissionSet) then) =
      _$WeeklyMissionSetCopyWithImpl<$Res, WeeklyMissionSet>;
  @useResult
  $Res call(
      {String id,
      DateTime weekStart,
      DateTime weekEnd,
      List<Mission> missions,
      int totalXPReward,
      bool isBonusClaimed,
      DateTime? bonusClaimedAt,
      Map<MissionCategory, int> categoryCompletion});
}

/// @nodoc
class _$WeeklyMissionSetCopyWithImpl<$Res, $Val extends WeeklyMissionSet>
    implements $WeeklyMissionSetCopyWith<$Res> {
  _$WeeklyMissionSetCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? weekStart = null,
    Object? weekEnd = null,
    Object? missions = null,
    Object? totalXPReward = null,
    Object? isBonusClaimed = null,
    Object? bonusClaimedAt = freezed,
    Object? categoryCompletion = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      weekStart: null == weekStart
          ? _value.weekStart
          : weekStart // ignore: cast_nullable_to_non_nullable
              as DateTime,
      weekEnd: null == weekEnd
          ? _value.weekEnd
          : weekEnd // ignore: cast_nullable_to_non_nullable
              as DateTime,
      missions: null == missions
          ? _value.missions
          : missions // ignore: cast_nullable_to_non_nullable
              as List<Mission>,
      totalXPReward: null == totalXPReward
          ? _value.totalXPReward
          : totalXPReward // ignore: cast_nullable_to_non_nullable
              as int,
      isBonusClaimed: null == isBonusClaimed
          ? _value.isBonusClaimed
          : isBonusClaimed // ignore: cast_nullable_to_non_nullable
              as bool,
      bonusClaimedAt: freezed == bonusClaimedAt
          ? _value.bonusClaimedAt
          : bonusClaimedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      categoryCompletion: null == categoryCompletion
          ? _value.categoryCompletion
          : categoryCompletion // ignore: cast_nullable_to_non_nullable
              as Map<MissionCategory, int>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$WeeklyMissionSetImplCopyWith<$Res>
    implements $WeeklyMissionSetCopyWith<$Res> {
  factory _$$WeeklyMissionSetImplCopyWith(_$WeeklyMissionSetImpl value,
          $Res Function(_$WeeklyMissionSetImpl) then) =
      __$$WeeklyMissionSetImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      DateTime weekStart,
      DateTime weekEnd,
      List<Mission> missions,
      int totalXPReward,
      bool isBonusClaimed,
      DateTime? bonusClaimedAt,
      Map<MissionCategory, int> categoryCompletion});
}

/// @nodoc
class __$$WeeklyMissionSetImplCopyWithImpl<$Res>
    extends _$WeeklyMissionSetCopyWithImpl<$Res, _$WeeklyMissionSetImpl>
    implements _$$WeeklyMissionSetImplCopyWith<$Res> {
  __$$WeeklyMissionSetImplCopyWithImpl(_$WeeklyMissionSetImpl _value,
      $Res Function(_$WeeklyMissionSetImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? weekStart = null,
    Object? weekEnd = null,
    Object? missions = null,
    Object? totalXPReward = null,
    Object? isBonusClaimed = null,
    Object? bonusClaimedAt = freezed,
    Object? categoryCompletion = null,
  }) {
    return _then(_$WeeklyMissionSetImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      weekStart: null == weekStart
          ? _value.weekStart
          : weekStart // ignore: cast_nullable_to_non_nullable
              as DateTime,
      weekEnd: null == weekEnd
          ? _value.weekEnd
          : weekEnd // ignore: cast_nullable_to_non_nullable
              as DateTime,
      missions: null == missions
          ? _value._missions
          : missions // ignore: cast_nullable_to_non_nullable
              as List<Mission>,
      totalXPReward: null == totalXPReward
          ? _value.totalXPReward
          : totalXPReward // ignore: cast_nullable_to_non_nullable
              as int,
      isBonusClaimed: null == isBonusClaimed
          ? _value.isBonusClaimed
          : isBonusClaimed // ignore: cast_nullable_to_non_nullable
              as bool,
      bonusClaimedAt: freezed == bonusClaimedAt
          ? _value.bonusClaimedAt
          : bonusClaimedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      categoryCompletion: null == categoryCompletion
          ? _value._categoryCompletion
          : categoryCompletion // ignore: cast_nullable_to_non_nullable
              as Map<MissionCategory, int>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$WeeklyMissionSetImpl implements _WeeklyMissionSet {
  const _$WeeklyMissionSetImpl(
      {required this.id,
      required this.weekStart,
      required this.weekEnd,
      required final List<Mission> missions,
      required this.totalXPReward,
      required this.isBonusClaimed,
      required this.bonusClaimedAt,
      required final Map<MissionCategory, int> categoryCompletion})
      : _missions = missions,
        _categoryCompletion = categoryCompletion;

  factory _$WeeklyMissionSetImpl.fromJson(Map<String, dynamic> json) =>
      _$$WeeklyMissionSetImplFromJson(json);

  @override
  final String id;
  @override
  final DateTime weekStart;
  @override
  final DateTime weekEnd;
  final List<Mission> _missions;
  @override
  List<Mission> get missions {
    if (_missions is EqualUnmodifiableListView) return _missions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_missions);
  }

  @override
  final int totalXPReward;
  @override
  final bool isBonusClaimed;
  @override
  final DateTime? bonusClaimedAt;
  final Map<MissionCategory, int> _categoryCompletion;
  @override
  Map<MissionCategory, int> get categoryCompletion {
    if (_categoryCompletion is EqualUnmodifiableMapView)
      return _categoryCompletion;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_categoryCompletion);
  }

  @override
  String toString() {
    return 'WeeklyMissionSet(id: $id, weekStart: $weekStart, weekEnd: $weekEnd, missions: $missions, totalXPReward: $totalXPReward, isBonusClaimed: $isBonusClaimed, bonusClaimedAt: $bonusClaimedAt, categoryCompletion: $categoryCompletion)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WeeklyMissionSetImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.weekStart, weekStart) ||
                other.weekStart == weekStart) &&
            (identical(other.weekEnd, weekEnd) || other.weekEnd == weekEnd) &&
            const DeepCollectionEquality().equals(other._missions, _missions) &&
            (identical(other.totalXPReward, totalXPReward) ||
                other.totalXPReward == totalXPReward) &&
            (identical(other.isBonusClaimed, isBonusClaimed) ||
                other.isBonusClaimed == isBonusClaimed) &&
            (identical(other.bonusClaimedAt, bonusClaimedAt) ||
                other.bonusClaimedAt == bonusClaimedAt) &&
            const DeepCollectionEquality()
                .equals(other._categoryCompletion, _categoryCompletion));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      weekStart,
      weekEnd,
      const DeepCollectionEquality().hash(_missions),
      totalXPReward,
      isBonusClaimed,
      bonusClaimedAt,
      const DeepCollectionEquality().hash(_categoryCompletion));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$WeeklyMissionSetImplCopyWith<_$WeeklyMissionSetImpl> get copyWith =>
      __$$WeeklyMissionSetImplCopyWithImpl<_$WeeklyMissionSetImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$WeeklyMissionSetImplToJson(
      this,
    );
  }
}

abstract class _WeeklyMissionSet implements WeeklyMissionSet {
  const factory _WeeklyMissionSet(
          {required final String id,
          required final DateTime weekStart,
          required final DateTime weekEnd,
          required final List<Mission> missions,
          required final int totalXPReward,
          required final bool isBonusClaimed,
          required final DateTime? bonusClaimedAt,
          required final Map<MissionCategory, int> categoryCompletion}) =
      _$WeeklyMissionSetImpl;

  factory _WeeklyMissionSet.fromJson(Map<String, dynamic> json) =
      _$WeeklyMissionSetImpl.fromJson;

  @override
  String get id;
  @override
  DateTime get weekStart;
  @override
  DateTime get weekEnd;
  @override
  List<Mission> get missions;
  @override
  int get totalXPReward;
  @override
  bool get isBonusClaimed;
  @override
  DateTime? get bonusClaimedAt;
  @override
  Map<MissionCategory, int> get categoryCompletion;
  @override
  @JsonKey(ignore: true)
  _$$WeeklyMissionSetImplCopyWith<_$WeeklyMissionSetImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

MissionGenerationConfig _$MissionGenerationConfigFromJson(
    Map<String, dynamic> json) {
  return _MissionGenerationConfig.fromJson(json);
}

/// @nodoc
mixin _$MissionGenerationConfig {
  int get dailyMissionsCount => throw _privateConstructorUsedError;
  int get weeklyMissionsCount => throw _privateConstructorUsedError;
  Map<MissionCategory, int> get categoryDistribution =>
      throw _privateConstructorUsedError;
  Map<MissionDifficulty, int> get difficultyDistribution =>
      throw _privateConstructorUsedError;
  Map<AdmissionsPillar, int> get pillarDistribution =>
      throw _privateConstructorUsedError;
  bool get ensureVariety => throw _privateConstructorUsedError;
  int get maxRepeatInRow => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $MissionGenerationConfigCopyWith<MissionGenerationConfig> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MissionGenerationConfigCopyWith<$Res> {
  factory $MissionGenerationConfigCopyWith(MissionGenerationConfig value,
          $Res Function(MissionGenerationConfig) then) =
      _$MissionGenerationConfigCopyWithImpl<$Res, MissionGenerationConfig>;
  @useResult
  $Res call(
      {int dailyMissionsCount,
      int weeklyMissionsCount,
      Map<MissionCategory, int> categoryDistribution,
      Map<MissionDifficulty, int> difficultyDistribution,
      Map<AdmissionsPillar, int> pillarDistribution,
      bool ensureVariety,
      int maxRepeatInRow});
}

/// @nodoc
class _$MissionGenerationConfigCopyWithImpl<$Res,
        $Val extends MissionGenerationConfig>
    implements $MissionGenerationConfigCopyWith<$Res> {
  _$MissionGenerationConfigCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? dailyMissionsCount = null,
    Object? weeklyMissionsCount = null,
    Object? categoryDistribution = null,
    Object? difficultyDistribution = null,
    Object? pillarDistribution = null,
    Object? ensureVariety = null,
    Object? maxRepeatInRow = null,
  }) {
    return _then(_value.copyWith(
      dailyMissionsCount: null == dailyMissionsCount
          ? _value.dailyMissionsCount
          : dailyMissionsCount // ignore: cast_nullable_to_non_nullable
              as int,
      weeklyMissionsCount: null == weeklyMissionsCount
          ? _value.weeklyMissionsCount
          : weeklyMissionsCount // ignore: cast_nullable_to_non_nullable
              as int,
      categoryDistribution: null == categoryDistribution
          ? _value.categoryDistribution
          : categoryDistribution // ignore: cast_nullable_to_non_nullable
              as Map<MissionCategory, int>,
      difficultyDistribution: null == difficultyDistribution
          ? _value.difficultyDistribution
          : difficultyDistribution // ignore: cast_nullable_to_non_nullable
              as Map<MissionDifficulty, int>,
      pillarDistribution: null == pillarDistribution
          ? _value.pillarDistribution
          : pillarDistribution // ignore: cast_nullable_to_non_nullable
              as Map<AdmissionsPillar, int>,
      ensureVariety: null == ensureVariety
          ? _value.ensureVariety
          : ensureVariety // ignore: cast_nullable_to_non_nullable
              as bool,
      maxRepeatInRow: null == maxRepeatInRow
          ? _value.maxRepeatInRow
          : maxRepeatInRow // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$MissionGenerationConfigImplCopyWith<$Res>
    implements $MissionGenerationConfigCopyWith<$Res> {
  factory _$$MissionGenerationConfigImplCopyWith(
          _$MissionGenerationConfigImpl value,
          $Res Function(_$MissionGenerationConfigImpl) then) =
      __$$MissionGenerationConfigImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int dailyMissionsCount,
      int weeklyMissionsCount,
      Map<MissionCategory, int> categoryDistribution,
      Map<MissionDifficulty, int> difficultyDistribution,
      Map<AdmissionsPillar, int> pillarDistribution,
      bool ensureVariety,
      int maxRepeatInRow});
}

/// @nodoc
class __$$MissionGenerationConfigImplCopyWithImpl<$Res>
    extends _$MissionGenerationConfigCopyWithImpl<$Res,
        _$MissionGenerationConfigImpl>
    implements _$$MissionGenerationConfigImplCopyWith<$Res> {
  __$$MissionGenerationConfigImplCopyWithImpl(
      _$MissionGenerationConfigImpl _value,
      $Res Function(_$MissionGenerationConfigImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? dailyMissionsCount = null,
    Object? weeklyMissionsCount = null,
    Object? categoryDistribution = null,
    Object? difficultyDistribution = null,
    Object? pillarDistribution = null,
    Object? ensureVariety = null,
    Object? maxRepeatInRow = null,
  }) {
    return _then(_$MissionGenerationConfigImpl(
      dailyMissionsCount: null == dailyMissionsCount
          ? _value.dailyMissionsCount
          : dailyMissionsCount // ignore: cast_nullable_to_non_nullable
              as int,
      weeklyMissionsCount: null == weeklyMissionsCount
          ? _value.weeklyMissionsCount
          : weeklyMissionsCount // ignore: cast_nullable_to_non_nullable
              as int,
      categoryDistribution: null == categoryDistribution
          ? _value._categoryDistribution
          : categoryDistribution // ignore: cast_nullable_to_non_nullable
              as Map<MissionCategory, int>,
      difficultyDistribution: null == difficultyDistribution
          ? _value._difficultyDistribution
          : difficultyDistribution // ignore: cast_nullable_to_non_nullable
              as Map<MissionDifficulty, int>,
      pillarDistribution: null == pillarDistribution
          ? _value._pillarDistribution
          : pillarDistribution // ignore: cast_nullable_to_non_nullable
              as Map<AdmissionsPillar, int>,
      ensureVariety: null == ensureVariety
          ? _value.ensureVariety
          : ensureVariety // ignore: cast_nullable_to_non_nullable
              as bool,
      maxRepeatInRow: null == maxRepeatInRow
          ? _value.maxRepeatInRow
          : maxRepeatInRow // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$MissionGenerationConfigImpl implements _MissionGenerationConfig {
  const _$MissionGenerationConfigImpl(
      {required this.dailyMissionsCount,
      required this.weeklyMissionsCount,
      required final Map<MissionCategory, int> categoryDistribution,
      required final Map<MissionDifficulty, int> difficultyDistribution,
      required final Map<AdmissionsPillar, int> pillarDistribution,
      required this.ensureVariety,
      required this.maxRepeatInRow})
      : _categoryDistribution = categoryDistribution,
        _difficultyDistribution = difficultyDistribution,
        _pillarDistribution = pillarDistribution;

  factory _$MissionGenerationConfigImpl.fromJson(Map<String, dynamic> json) =>
      _$$MissionGenerationConfigImplFromJson(json);

  @override
  final int dailyMissionsCount;
  @override
  final int weeklyMissionsCount;
  final Map<MissionCategory, int> _categoryDistribution;
  @override
  Map<MissionCategory, int> get categoryDistribution {
    if (_categoryDistribution is EqualUnmodifiableMapView)
      return _categoryDistribution;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_categoryDistribution);
  }

  final Map<MissionDifficulty, int> _difficultyDistribution;
  @override
  Map<MissionDifficulty, int> get difficultyDistribution {
    if (_difficultyDistribution is EqualUnmodifiableMapView)
      return _difficultyDistribution;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_difficultyDistribution);
  }

  final Map<AdmissionsPillar, int> _pillarDistribution;
  @override
  Map<AdmissionsPillar, int> get pillarDistribution {
    if (_pillarDistribution is EqualUnmodifiableMapView)
      return _pillarDistribution;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_pillarDistribution);
  }

  @override
  final bool ensureVariety;
  @override
  final int maxRepeatInRow;

  @override
  String toString() {
    return 'MissionGenerationConfig(dailyMissionsCount: $dailyMissionsCount, weeklyMissionsCount: $weeklyMissionsCount, categoryDistribution: $categoryDistribution, difficultyDistribution: $difficultyDistribution, pillarDistribution: $pillarDistribution, ensureVariety: $ensureVariety, maxRepeatInRow: $maxRepeatInRow)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MissionGenerationConfigImpl &&
            (identical(other.dailyMissionsCount, dailyMissionsCount) ||
                other.dailyMissionsCount == dailyMissionsCount) &&
            (identical(other.weeklyMissionsCount, weeklyMissionsCount) ||
                other.weeklyMissionsCount == weeklyMissionsCount) &&
            const DeepCollectionEquality()
                .equals(other._categoryDistribution, _categoryDistribution) &&
            const DeepCollectionEquality().equals(
                other._difficultyDistribution, _difficultyDistribution) &&
            const DeepCollectionEquality()
                .equals(other._pillarDistribution, _pillarDistribution) &&
            (identical(other.ensureVariety, ensureVariety) ||
                other.ensureVariety == ensureVariety) &&
            (identical(other.maxRepeatInRow, maxRepeatInRow) ||
                other.maxRepeatInRow == maxRepeatInRow));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      dailyMissionsCount,
      weeklyMissionsCount,
      const DeepCollectionEquality().hash(_categoryDistribution),
      const DeepCollectionEquality().hash(_difficultyDistribution),
      const DeepCollectionEquality().hash(_pillarDistribution),
      ensureVariety,
      maxRepeatInRow);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$MissionGenerationConfigImplCopyWith<_$MissionGenerationConfigImpl>
      get copyWith => __$$MissionGenerationConfigImplCopyWithImpl<
          _$MissionGenerationConfigImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MissionGenerationConfigImplToJson(
      this,
    );
  }
}

abstract class _MissionGenerationConfig implements MissionGenerationConfig {
  const factory _MissionGenerationConfig(
      {required final int dailyMissionsCount,
      required final int weeklyMissionsCount,
      required final Map<MissionCategory, int> categoryDistribution,
      required final Map<MissionDifficulty, int> difficultyDistribution,
      required final Map<AdmissionsPillar, int> pillarDistribution,
      required final bool ensureVariety,
      required final int maxRepeatInRow}) = _$MissionGenerationConfigImpl;

  factory _MissionGenerationConfig.fromJson(Map<String, dynamic> json) =
      _$MissionGenerationConfigImpl.fromJson;

  @override
  int get dailyMissionsCount;
  @override
  int get weeklyMissionsCount;
  @override
  Map<MissionCategory, int> get categoryDistribution;
  @override
  Map<MissionDifficulty, int> get difficultyDistribution;
  @override
  Map<AdmissionsPillar, int> get pillarDistribution;
  @override
  bool get ensureVariety;
  @override
  int get maxRepeatInRow;
  @override
  @JsonKey(ignore: true)
  _$$MissionGenerationConfigImplCopyWith<_$MissionGenerationConfigImpl>
      get copyWith => throw _privateConstructorUsedError;
}

MissionTemplate _$MissionTemplateFromJson(Map<String, dynamic> json) {
  return _MissionTemplate.fromJson(json);
}

/// @nodoc
mixin _$MissionTemplate {
  String get id => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  @MissionTypeConverter()
  MissionType get type => throw _privateConstructorUsedError;
  @MissionCategoryConverter()
  MissionCategory get category => throw _privateConstructorUsedError;
  @MissionDifficultyConverter()
  MissionDifficulty get difficulty => throw _privateConstructorUsedError;
  int get xpReward => throw _privateConstructorUsedError;
  AdmissionsPillar get pillar => throw _privateConstructorUsedError;
  Map<String, dynamic> get completionCriteria =>
      throw _privateConstructorUsedError;
  List<String> get prerequisites => throw _privateConstructorUsedError;
  int get progressTarget => throw _privateConstructorUsedError;
  String get progressUnit => throw _privateConstructorUsedError;
  bool get isRepeatable => throw _privateConstructorUsedError;
  int get repeatCooldownDays => throw _privateConstructorUsedError;
  List<String> get tags => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $MissionTemplateCopyWith<MissionTemplate> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MissionTemplateCopyWith<$Res> {
  factory $MissionTemplateCopyWith(
          MissionTemplate value, $Res Function(MissionTemplate) then) =
      _$MissionTemplateCopyWithImpl<$Res, MissionTemplate>;
  @useResult
  $Res call(
      {String id,
      String title,
      String description,
      @MissionTypeConverter() MissionType type,
      @MissionCategoryConverter() MissionCategory category,
      @MissionDifficultyConverter() MissionDifficulty difficulty,
      int xpReward,
      AdmissionsPillar pillar,
      Map<String, dynamic> completionCriteria,
      List<String> prerequisites,
      int progressTarget,
      String progressUnit,
      bool isRepeatable,
      int repeatCooldownDays,
      List<String> tags});
}

/// @nodoc
class _$MissionTemplateCopyWithImpl<$Res, $Val extends MissionTemplate>
    implements $MissionTemplateCopyWith<$Res> {
  _$MissionTemplateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? description = null,
    Object? type = null,
    Object? category = null,
    Object? difficulty = null,
    Object? xpReward = null,
    Object? pillar = null,
    Object? completionCriteria = null,
    Object? prerequisites = null,
    Object? progressTarget = null,
    Object? progressUnit = null,
    Object? isRepeatable = null,
    Object? repeatCooldownDays = null,
    Object? tags = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as MissionType,
      category: null == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as MissionCategory,
      difficulty: null == difficulty
          ? _value.difficulty
          : difficulty // ignore: cast_nullable_to_non_nullable
              as MissionDifficulty,
      xpReward: null == xpReward
          ? _value.xpReward
          : xpReward // ignore: cast_nullable_to_non_nullable
              as int,
      pillar: null == pillar
          ? _value.pillar
          : pillar // ignore: cast_nullable_to_non_nullable
              as AdmissionsPillar,
      completionCriteria: null == completionCriteria
          ? _value.completionCriteria
          : completionCriteria // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      prerequisites: null == prerequisites
          ? _value.prerequisites
          : prerequisites // ignore: cast_nullable_to_non_nullable
              as List<String>,
      progressTarget: null == progressTarget
          ? _value.progressTarget
          : progressTarget // ignore: cast_nullable_to_non_nullable
              as int,
      progressUnit: null == progressUnit
          ? _value.progressUnit
          : progressUnit // ignore: cast_nullable_to_non_nullable
              as String,
      isRepeatable: null == isRepeatable
          ? _value.isRepeatable
          : isRepeatable // ignore: cast_nullable_to_non_nullable
              as bool,
      repeatCooldownDays: null == repeatCooldownDays
          ? _value.repeatCooldownDays
          : repeatCooldownDays // ignore: cast_nullable_to_non_nullable
              as int,
      tags: null == tags
          ? _value.tags
          : tags // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$MissionTemplateImplCopyWith<$Res>
    implements $MissionTemplateCopyWith<$Res> {
  factory _$$MissionTemplateImplCopyWith(_$MissionTemplateImpl value,
          $Res Function(_$MissionTemplateImpl) then) =
      __$$MissionTemplateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String title,
      String description,
      @MissionTypeConverter() MissionType type,
      @MissionCategoryConverter() MissionCategory category,
      @MissionDifficultyConverter() MissionDifficulty difficulty,
      int xpReward,
      AdmissionsPillar pillar,
      Map<String, dynamic> completionCriteria,
      List<String> prerequisites,
      int progressTarget,
      String progressUnit,
      bool isRepeatable,
      int repeatCooldownDays,
      List<String> tags});
}

/// @nodoc
class __$$MissionTemplateImplCopyWithImpl<$Res>
    extends _$MissionTemplateCopyWithImpl<$Res, _$MissionTemplateImpl>
    implements _$$MissionTemplateImplCopyWith<$Res> {
  __$$MissionTemplateImplCopyWithImpl(
      _$MissionTemplateImpl _value, $Res Function(_$MissionTemplateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? description = null,
    Object? type = null,
    Object? category = null,
    Object? difficulty = null,
    Object? xpReward = null,
    Object? pillar = null,
    Object? completionCriteria = null,
    Object? prerequisites = null,
    Object? progressTarget = null,
    Object? progressUnit = null,
    Object? isRepeatable = null,
    Object? repeatCooldownDays = null,
    Object? tags = null,
  }) {
    return _then(_$MissionTemplateImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as MissionType,
      category: null == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as MissionCategory,
      difficulty: null == difficulty
          ? _value.difficulty
          : difficulty // ignore: cast_nullable_to_non_nullable
              as MissionDifficulty,
      xpReward: null == xpReward
          ? _value.xpReward
          : xpReward // ignore: cast_nullable_to_non_nullable
              as int,
      pillar: null == pillar
          ? _value.pillar
          : pillar // ignore: cast_nullable_to_non_nullable
              as AdmissionsPillar,
      completionCriteria: null == completionCriteria
          ? _value._completionCriteria
          : completionCriteria // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      prerequisites: null == prerequisites
          ? _value._prerequisites
          : prerequisites // ignore: cast_nullable_to_non_nullable
              as List<String>,
      progressTarget: null == progressTarget
          ? _value.progressTarget
          : progressTarget // ignore: cast_nullable_to_non_nullable
              as int,
      progressUnit: null == progressUnit
          ? _value.progressUnit
          : progressUnit // ignore: cast_nullable_to_non_nullable
              as String,
      isRepeatable: null == isRepeatable
          ? _value.isRepeatable
          : isRepeatable // ignore: cast_nullable_to_non_nullable
              as bool,
      repeatCooldownDays: null == repeatCooldownDays
          ? _value.repeatCooldownDays
          : repeatCooldownDays // ignore: cast_nullable_to_non_nullable
              as int,
      tags: null == tags
          ? _value._tags
          : tags // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$MissionTemplateImpl implements _MissionTemplate {
  const _$MissionTemplateImpl(
      {required this.id,
      required this.title,
      required this.description,
      @MissionTypeConverter() required this.type,
      @MissionCategoryConverter() required this.category,
      @MissionDifficultyConverter() required this.difficulty,
      required this.xpReward,
      required this.pillar,
      required final Map<String, dynamic> completionCriteria,
      required final List<String> prerequisites,
      required this.progressTarget,
      required this.progressUnit,
      required this.isRepeatable,
      required this.repeatCooldownDays,
      required final List<String> tags})
      : _completionCriteria = completionCriteria,
        _prerequisites = prerequisites,
        _tags = tags;

  factory _$MissionTemplateImpl.fromJson(Map<String, dynamic> json) =>
      _$$MissionTemplateImplFromJson(json);

  @override
  final String id;
  @override
  final String title;
  @override
  final String description;
  @override
  @MissionTypeConverter()
  final MissionType type;
  @override
  @MissionCategoryConverter()
  final MissionCategory category;
  @override
  @MissionDifficultyConverter()
  final MissionDifficulty difficulty;
  @override
  final int xpReward;
  @override
  final AdmissionsPillar pillar;
  final Map<String, dynamic> _completionCriteria;
  @override
  Map<String, dynamic> get completionCriteria {
    if (_completionCriteria is EqualUnmodifiableMapView)
      return _completionCriteria;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_completionCriteria);
  }

  final List<String> _prerequisites;
  @override
  List<String> get prerequisites {
    if (_prerequisites is EqualUnmodifiableListView) return _prerequisites;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_prerequisites);
  }

  @override
  final int progressTarget;
  @override
  final String progressUnit;
  @override
  final bool isRepeatable;
  @override
  final int repeatCooldownDays;
  final List<String> _tags;
  @override
  List<String> get tags {
    if (_tags is EqualUnmodifiableListView) return _tags;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_tags);
  }

  @override
  String toString() {
    return 'MissionTemplate(id: $id, title: $title, description: $description, type: $type, category: $category, difficulty: $difficulty, xpReward: $xpReward, pillar: $pillar, completionCriteria: $completionCriteria, prerequisites: $prerequisites, progressTarget: $progressTarget, progressUnit: $progressUnit, isRepeatable: $isRepeatable, repeatCooldownDays: $repeatCooldownDays, tags: $tags)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MissionTemplateImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.difficulty, difficulty) ||
                other.difficulty == difficulty) &&
            (identical(other.xpReward, xpReward) ||
                other.xpReward == xpReward) &&
            (identical(other.pillar, pillar) || other.pillar == pillar) &&
            const DeepCollectionEquality()
                .equals(other._completionCriteria, _completionCriteria) &&
            const DeepCollectionEquality()
                .equals(other._prerequisites, _prerequisites) &&
            (identical(other.progressTarget, progressTarget) ||
                other.progressTarget == progressTarget) &&
            (identical(other.progressUnit, progressUnit) ||
                other.progressUnit == progressUnit) &&
            (identical(other.isRepeatable, isRepeatable) ||
                other.isRepeatable == isRepeatable) &&
            (identical(other.repeatCooldownDays, repeatCooldownDays) ||
                other.repeatCooldownDays == repeatCooldownDays) &&
            const DeepCollectionEquality().equals(other._tags, _tags));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      title,
      description,
      type,
      category,
      difficulty,
      xpReward,
      pillar,
      const DeepCollectionEquality().hash(_completionCriteria),
      const DeepCollectionEquality().hash(_prerequisites),
      progressTarget,
      progressUnit,
      isRepeatable,
      repeatCooldownDays,
      const DeepCollectionEquality().hash(_tags));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$MissionTemplateImplCopyWith<_$MissionTemplateImpl> get copyWith =>
      __$$MissionTemplateImplCopyWithImpl<_$MissionTemplateImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MissionTemplateImplToJson(
      this,
    );
  }
}

abstract class _MissionTemplate implements MissionTemplate {
  const factory _MissionTemplate(
      {required final String id,
      required final String title,
      required final String description,
      @MissionTypeConverter() required final MissionType type,
      @MissionCategoryConverter() required final MissionCategory category,
      @MissionDifficultyConverter() required final MissionDifficulty difficulty,
      required final int xpReward,
      required final AdmissionsPillar pillar,
      required final Map<String, dynamic> completionCriteria,
      required final List<String> prerequisites,
      required final int progressTarget,
      required final String progressUnit,
      required final bool isRepeatable,
      required final int repeatCooldownDays,
      required final List<String> tags}) = _$MissionTemplateImpl;

  factory _MissionTemplate.fromJson(Map<String, dynamic> json) =
      _$MissionTemplateImpl.fromJson;

  @override
  String get id;
  @override
  String get title;
  @override
  String get description;
  @override
  @MissionTypeConverter()
  MissionType get type;
  @override
  @MissionCategoryConverter()
  MissionCategory get category;
  @override
  @MissionDifficultyConverter()
  MissionDifficulty get difficulty;
  @override
  int get xpReward;
  @override
  AdmissionsPillar get pillar;
  @override
  Map<String, dynamic> get completionCriteria;
  @override
  List<String> get prerequisites;
  @override
  int get progressTarget;
  @override
  String get progressUnit;
  @override
  bool get isRepeatable;
  @override
  int get repeatCooldownDays;
  @override
  List<String> get tags;
  @override
  @JsonKey(ignore: true)
  _$$MissionTemplateImplCopyWith<_$MissionTemplateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

MissionProgress _$MissionProgressFromJson(Map<String, dynamic> json) {
  return _MissionProgress.fromJson(json);
}

/// @nodoc
mixin _$MissionProgress {
  String get missionId => throw _privateConstructorUsedError;
  int get currentProgress => throw _privateConstructorUsedError;
  int get targetProgress => throw _privateConstructorUsedError;
  Map<String, dynamic> get progressData => throw _privateConstructorUsedError;
  DateTime get lastUpdated => throw _privateConstructorUsedError;
  bool get isCompleted => throw _privateConstructorUsedError;
  DateTime? get completedAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $MissionProgressCopyWith<MissionProgress> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MissionProgressCopyWith<$Res> {
  factory $MissionProgressCopyWith(
          MissionProgress value, $Res Function(MissionProgress) then) =
      _$MissionProgressCopyWithImpl<$Res, MissionProgress>;
  @useResult
  $Res call(
      {String missionId,
      int currentProgress,
      int targetProgress,
      Map<String, dynamic> progressData,
      DateTime lastUpdated,
      bool isCompleted,
      DateTime? completedAt});
}

/// @nodoc
class _$MissionProgressCopyWithImpl<$Res, $Val extends MissionProgress>
    implements $MissionProgressCopyWith<$Res> {
  _$MissionProgressCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? missionId = null,
    Object? currentProgress = null,
    Object? targetProgress = null,
    Object? progressData = null,
    Object? lastUpdated = null,
    Object? isCompleted = null,
    Object? completedAt = freezed,
  }) {
    return _then(_value.copyWith(
      missionId: null == missionId
          ? _value.missionId
          : missionId // ignore: cast_nullable_to_non_nullable
              as String,
      currentProgress: null == currentProgress
          ? _value.currentProgress
          : currentProgress // ignore: cast_nullable_to_non_nullable
              as int,
      targetProgress: null == targetProgress
          ? _value.targetProgress
          : targetProgress // ignore: cast_nullable_to_non_nullable
              as int,
      progressData: null == progressData
          ? _value.progressData
          : progressData // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      lastUpdated: null == lastUpdated
          ? _value.lastUpdated
          : lastUpdated // ignore: cast_nullable_to_non_nullable
              as DateTime,
      isCompleted: null == isCompleted
          ? _value.isCompleted
          : isCompleted // ignore: cast_nullable_to_non_nullable
              as bool,
      completedAt: freezed == completedAt
          ? _value.completedAt
          : completedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$MissionProgressImplCopyWith<$Res>
    implements $MissionProgressCopyWith<$Res> {
  factory _$$MissionProgressImplCopyWith(_$MissionProgressImpl value,
          $Res Function(_$MissionProgressImpl) then) =
      __$$MissionProgressImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String missionId,
      int currentProgress,
      int targetProgress,
      Map<String, dynamic> progressData,
      DateTime lastUpdated,
      bool isCompleted,
      DateTime? completedAt});
}

/// @nodoc
class __$$MissionProgressImplCopyWithImpl<$Res>
    extends _$MissionProgressCopyWithImpl<$Res, _$MissionProgressImpl>
    implements _$$MissionProgressImplCopyWith<$Res> {
  __$$MissionProgressImplCopyWithImpl(
      _$MissionProgressImpl _value, $Res Function(_$MissionProgressImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? missionId = null,
    Object? currentProgress = null,
    Object? targetProgress = null,
    Object? progressData = null,
    Object? lastUpdated = null,
    Object? isCompleted = null,
    Object? completedAt = freezed,
  }) {
    return _then(_$MissionProgressImpl(
      missionId: null == missionId
          ? _value.missionId
          : missionId // ignore: cast_nullable_to_non_nullable
              as String,
      currentProgress: null == currentProgress
          ? _value.currentProgress
          : currentProgress // ignore: cast_nullable_to_non_nullable
              as int,
      targetProgress: null == targetProgress
          ? _value.targetProgress
          : targetProgress // ignore: cast_nullable_to_non_nullable
              as int,
      progressData: null == progressData
          ? _value._progressData
          : progressData // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      lastUpdated: null == lastUpdated
          ? _value.lastUpdated
          : lastUpdated // ignore: cast_nullable_to_non_nullable
              as DateTime,
      isCompleted: null == isCompleted
          ? _value.isCompleted
          : isCompleted // ignore: cast_nullable_to_non_nullable
              as bool,
      completedAt: freezed == completedAt
          ? _value.completedAt
          : completedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$MissionProgressImpl implements _MissionProgress {
  const _$MissionProgressImpl(
      {required this.missionId,
      required this.currentProgress,
      required this.targetProgress,
      required final Map<String, dynamic> progressData,
      required this.lastUpdated,
      required this.isCompleted,
      required this.completedAt})
      : _progressData = progressData;

  factory _$MissionProgressImpl.fromJson(Map<String, dynamic> json) =>
      _$$MissionProgressImplFromJson(json);

  @override
  final String missionId;
  @override
  final int currentProgress;
  @override
  final int targetProgress;
  final Map<String, dynamic> _progressData;
  @override
  Map<String, dynamic> get progressData {
    if (_progressData is EqualUnmodifiableMapView) return _progressData;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_progressData);
  }

  @override
  final DateTime lastUpdated;
  @override
  final bool isCompleted;
  @override
  final DateTime? completedAt;

  @override
  String toString() {
    return 'MissionProgress(missionId: $missionId, currentProgress: $currentProgress, targetProgress: $targetProgress, progressData: $progressData, lastUpdated: $lastUpdated, isCompleted: $isCompleted, completedAt: $completedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MissionProgressImpl &&
            (identical(other.missionId, missionId) ||
                other.missionId == missionId) &&
            (identical(other.currentProgress, currentProgress) ||
                other.currentProgress == currentProgress) &&
            (identical(other.targetProgress, targetProgress) ||
                other.targetProgress == targetProgress) &&
            const DeepCollectionEquality()
                .equals(other._progressData, _progressData) &&
            (identical(other.lastUpdated, lastUpdated) ||
                other.lastUpdated == lastUpdated) &&
            (identical(other.isCompleted, isCompleted) ||
                other.isCompleted == isCompleted) &&
            (identical(other.completedAt, completedAt) ||
                other.completedAt == completedAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      missionId,
      currentProgress,
      targetProgress,
      const DeepCollectionEquality().hash(_progressData),
      lastUpdated,
      isCompleted,
      completedAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$MissionProgressImplCopyWith<_$MissionProgressImpl> get copyWith =>
      __$$MissionProgressImplCopyWithImpl<_$MissionProgressImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MissionProgressImplToJson(
      this,
    );
  }
}

abstract class _MissionProgress implements MissionProgress {
  const factory _MissionProgress(
      {required final String missionId,
      required final int currentProgress,
      required final int targetProgress,
      required final Map<String, dynamic> progressData,
      required final DateTime lastUpdated,
      required final bool isCompleted,
      required final DateTime? completedAt}) = _$MissionProgressImpl;

  factory _MissionProgress.fromJson(Map<String, dynamic> json) =
      _$MissionProgressImpl.fromJson;

  @override
  String get missionId;
  @override
  int get currentProgress;
  @override
  int get targetProgress;
  @override
  Map<String, dynamic> get progressData;
  @override
  DateTime get lastUpdated;
  @override
  bool get isCompleted;
  @override
  DateTime? get completedAt;
  @override
  @JsonKey(ignore: true)
  _$$MissionProgressImplCopyWith<_$MissionProgressImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
