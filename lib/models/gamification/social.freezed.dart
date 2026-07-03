// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'social.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Buddy _$BuddyFromJson(Map<String, dynamic> json) {
  return _Buddy.fromJson(json);
}

/// @nodoc
mixin _$Buddy {
  String get id => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  String get buddyId => throw _privateConstructorUsedError;
  BuddyStatus get status => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime? get acceptedAt => throw _privateConstructorUsedError;
  DateTime? get lastInteractionAt => throw _privateConstructorUsedError;
  int get sharedStreakDays => throw _privateConstructorUsedError;
  int get totalSharedActivities => throw _privateConstructorUsedError;
  Map<String, int> get pillarXPShared => throw _privateConstructorUsedError;
  List<String> get mutualGoals => throw _privateConstructorUsedError;
  BuddySettings get settings => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $BuddyCopyWith<Buddy> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BuddyCopyWith<$Res> {
  factory $BuddyCopyWith(Buddy value, $Res Function(Buddy) then) =
      _$BuddyCopyWithImpl<$Res, Buddy>;
  @useResult
  $Res call(
      {String id,
      String userId,
      String buddyId,
      BuddyStatus status,
      DateTime createdAt,
      DateTime? acceptedAt,
      DateTime? lastInteractionAt,
      int sharedStreakDays,
      int totalSharedActivities,
      Map<String, int> pillarXPShared,
      List<String> mutualGoals,
      BuddySettings settings});

  $BuddySettingsCopyWith<$Res> get settings;
}

/// @nodoc
class _$BuddyCopyWithImpl<$Res, $Val extends Buddy>
    implements $BuddyCopyWith<$Res> {
  _$BuddyCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? buddyId = null,
    Object? status = null,
    Object? createdAt = null,
    Object? acceptedAt = freezed,
    Object? lastInteractionAt = freezed,
    Object? sharedStreakDays = null,
    Object? totalSharedActivities = null,
    Object? pillarXPShared = null,
    Object? mutualGoals = null,
    Object? settings = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      buddyId: null == buddyId
          ? _value.buddyId
          : buddyId // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as BuddyStatus,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      acceptedAt: freezed == acceptedAt
          ? _value.acceptedAt
          : acceptedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      lastInteractionAt: freezed == lastInteractionAt
          ? _value.lastInteractionAt
          : lastInteractionAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      sharedStreakDays: null == sharedStreakDays
          ? _value.sharedStreakDays
          : sharedStreakDays // ignore: cast_nullable_to_non_nullable
              as int,
      totalSharedActivities: null == totalSharedActivities
          ? _value.totalSharedActivities
          : totalSharedActivities // ignore: cast_nullable_to_non_nullable
              as int,
      pillarXPShared: null == pillarXPShared
          ? _value.pillarXPShared
          : pillarXPShared // ignore: cast_nullable_to_non_nullable
              as Map<String, int>,
      mutualGoals: null == mutualGoals
          ? _value.mutualGoals
          : mutualGoals // ignore: cast_nullable_to_non_nullable
              as List<String>,
      settings: null == settings
          ? _value.settings
          : settings // ignore: cast_nullable_to_non_nullable
              as BuddySettings,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $BuddySettingsCopyWith<$Res> get settings {
    return $BuddySettingsCopyWith<$Res>(_value.settings, (value) {
      return _then(_value.copyWith(settings: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$BuddyImplCopyWith<$Res> implements $BuddyCopyWith<$Res> {
  factory _$$BuddyImplCopyWith(
          _$BuddyImpl value, $Res Function(_$BuddyImpl) then) =
      __$$BuddyImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String userId,
      String buddyId,
      BuddyStatus status,
      DateTime createdAt,
      DateTime? acceptedAt,
      DateTime? lastInteractionAt,
      int sharedStreakDays,
      int totalSharedActivities,
      Map<String, int> pillarXPShared,
      List<String> mutualGoals,
      BuddySettings settings});

  @override
  $BuddySettingsCopyWith<$Res> get settings;
}

/// @nodoc
class __$$BuddyImplCopyWithImpl<$Res>
    extends _$BuddyCopyWithImpl<$Res, _$BuddyImpl>
    implements _$$BuddyImplCopyWith<$Res> {
  __$$BuddyImplCopyWithImpl(
      _$BuddyImpl _value, $Res Function(_$BuddyImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? buddyId = null,
    Object? status = null,
    Object? createdAt = null,
    Object? acceptedAt = freezed,
    Object? lastInteractionAt = freezed,
    Object? sharedStreakDays = null,
    Object? totalSharedActivities = null,
    Object? pillarXPShared = null,
    Object? mutualGoals = null,
    Object? settings = null,
  }) {
    return _then(_$BuddyImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      buddyId: null == buddyId
          ? _value.buddyId
          : buddyId // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as BuddyStatus,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      acceptedAt: freezed == acceptedAt
          ? _value.acceptedAt
          : acceptedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      lastInteractionAt: freezed == lastInteractionAt
          ? _value.lastInteractionAt
          : lastInteractionAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      sharedStreakDays: null == sharedStreakDays
          ? _value.sharedStreakDays
          : sharedStreakDays // ignore: cast_nullable_to_non_nullable
              as int,
      totalSharedActivities: null == totalSharedActivities
          ? _value.totalSharedActivities
          : totalSharedActivities // ignore: cast_nullable_to_non_nullable
              as int,
      pillarXPShared: null == pillarXPShared
          ? _value._pillarXPShared
          : pillarXPShared // ignore: cast_nullable_to_non_nullable
              as Map<String, int>,
      mutualGoals: null == mutualGoals
          ? _value._mutualGoals
          : mutualGoals // ignore: cast_nullable_to_non_nullable
              as List<String>,
      settings: null == settings
          ? _value.settings
          : settings // ignore: cast_nullable_to_non_nullable
              as BuddySettings,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$BuddyImpl implements _Buddy {
  const _$BuddyImpl(
      {required this.id,
      required this.userId,
      required this.buddyId,
      required this.status,
      required this.createdAt,
      required this.acceptedAt,
      required this.lastInteractionAt,
      required this.sharedStreakDays,
      required this.totalSharedActivities,
      required final Map<String, int> pillarXPShared,
      required final List<String> mutualGoals,
      required this.settings})
      : _pillarXPShared = pillarXPShared,
        _mutualGoals = mutualGoals;

  factory _$BuddyImpl.fromJson(Map<String, dynamic> json) =>
      _$$BuddyImplFromJson(json);

  @override
  final String id;
  @override
  final String userId;
  @override
  final String buddyId;
  @override
  final BuddyStatus status;
  @override
  final DateTime createdAt;
  @override
  final DateTime? acceptedAt;
  @override
  final DateTime? lastInteractionAt;
  @override
  final int sharedStreakDays;
  @override
  final int totalSharedActivities;
  final Map<String, int> _pillarXPShared;
  @override
  Map<String, int> get pillarXPShared {
    if (_pillarXPShared is EqualUnmodifiableMapView) return _pillarXPShared;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_pillarXPShared);
  }

  final List<String> _mutualGoals;
  @override
  List<String> get mutualGoals {
    if (_mutualGoals is EqualUnmodifiableListView) return _mutualGoals;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_mutualGoals);
  }

  @override
  final BuddySettings settings;

  @override
  String toString() {
    return 'Buddy(id: $id, userId: $userId, buddyId: $buddyId, status: $status, createdAt: $createdAt, acceptedAt: $acceptedAt, lastInteractionAt: $lastInteractionAt, sharedStreakDays: $sharedStreakDays, totalSharedActivities: $totalSharedActivities, pillarXPShared: $pillarXPShared, mutualGoals: $mutualGoals, settings: $settings)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BuddyImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.buddyId, buddyId) || other.buddyId == buddyId) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.acceptedAt, acceptedAt) ||
                other.acceptedAt == acceptedAt) &&
            (identical(other.lastInteractionAt, lastInteractionAt) ||
                other.lastInteractionAt == lastInteractionAt) &&
            (identical(other.sharedStreakDays, sharedStreakDays) ||
                other.sharedStreakDays == sharedStreakDays) &&
            (identical(other.totalSharedActivities, totalSharedActivities) ||
                other.totalSharedActivities == totalSharedActivities) &&
            const DeepCollectionEquality()
                .equals(other._pillarXPShared, _pillarXPShared) &&
            const DeepCollectionEquality()
                .equals(other._mutualGoals, _mutualGoals) &&
            (identical(other.settings, settings) ||
                other.settings == settings));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      userId,
      buddyId,
      status,
      createdAt,
      acceptedAt,
      lastInteractionAt,
      sharedStreakDays,
      totalSharedActivities,
      const DeepCollectionEquality().hash(_pillarXPShared),
      const DeepCollectionEquality().hash(_mutualGoals),
      settings);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$BuddyImplCopyWith<_$BuddyImpl> get copyWith =>
      __$$BuddyImplCopyWithImpl<_$BuddyImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$BuddyImplToJson(
      this,
    );
  }
}

abstract class _Buddy implements Buddy {
  const factory _Buddy(
      {required final String id,
      required final String userId,
      required final String buddyId,
      required final BuddyStatus status,
      required final DateTime createdAt,
      required final DateTime? acceptedAt,
      required final DateTime? lastInteractionAt,
      required final int sharedStreakDays,
      required final int totalSharedActivities,
      required final Map<String, int> pillarXPShared,
      required final List<String> mutualGoals,
      required final BuddySettings settings}) = _$BuddyImpl;

  factory _Buddy.fromJson(Map<String, dynamic> json) = _$BuddyImpl.fromJson;

  @override
  String get id;
  @override
  String get userId;
  @override
  String get buddyId;
  @override
  BuddyStatus get status;
  @override
  DateTime get createdAt;
  @override
  DateTime? get acceptedAt;
  @override
  DateTime? get lastInteractionAt;
  @override
  int get sharedStreakDays;
  @override
  int get totalSharedActivities;
  @override
  Map<String, int> get pillarXPShared;
  @override
  List<String> get mutualGoals;
  @override
  BuddySettings get settings;
  @override
  @JsonKey(ignore: true)
  _$$BuddyImplCopyWith<_$BuddyImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

BuddySettings _$BuddySettingsFromJson(Map<String, dynamic> json) {
  return _BuddySettings.fromJson(json);
}

/// @nodoc
mixin _$BuddySettings {
  bool get shareStreak => throw _privateConstructorUsedError;
  bool get shareXP => throw _privateConstructorUsedError;
  bool get shareActivities => throw _privateConstructorUsedError;
  bool get shareGoals => throw _privateConstructorUsedError;
  bool get notificationsEnabled => throw _privateConstructorUsedError;
  bool get competitiveMode => throw _privateConstructorUsedError;
  int get checkInFrequency => throw _privateConstructorUsedError;
  bool get autoExpire => throw _privateConstructorUsedError;
  int get expiryDays => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $BuddySettingsCopyWith<BuddySettings> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BuddySettingsCopyWith<$Res> {
  factory $BuddySettingsCopyWith(
          BuddySettings value, $Res Function(BuddySettings) then) =
      _$BuddySettingsCopyWithImpl<$Res, BuddySettings>;
  @useResult
  $Res call(
      {bool shareStreak,
      bool shareXP,
      bool shareActivities,
      bool shareGoals,
      bool notificationsEnabled,
      bool competitiveMode,
      int checkInFrequency,
      bool autoExpire,
      int expiryDays});
}

/// @nodoc
class _$BuddySettingsCopyWithImpl<$Res, $Val extends BuddySettings>
    implements $BuddySettingsCopyWith<$Res> {
  _$BuddySettingsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? shareStreak = null,
    Object? shareXP = null,
    Object? shareActivities = null,
    Object? shareGoals = null,
    Object? notificationsEnabled = null,
    Object? competitiveMode = null,
    Object? checkInFrequency = null,
    Object? autoExpire = null,
    Object? expiryDays = null,
  }) {
    return _then(_value.copyWith(
      shareStreak: null == shareStreak
          ? _value.shareStreak
          : shareStreak // ignore: cast_nullable_to_non_nullable
              as bool,
      shareXP: null == shareXP
          ? _value.shareXP
          : shareXP // ignore: cast_nullable_to_non_nullable
              as bool,
      shareActivities: null == shareActivities
          ? _value.shareActivities
          : shareActivities // ignore: cast_nullable_to_non_nullable
              as bool,
      shareGoals: null == shareGoals
          ? _value.shareGoals
          : shareGoals // ignore: cast_nullable_to_non_nullable
              as bool,
      notificationsEnabled: null == notificationsEnabled
          ? _value.notificationsEnabled
          : notificationsEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      competitiveMode: null == competitiveMode
          ? _value.competitiveMode
          : competitiveMode // ignore: cast_nullable_to_non_nullable
              as bool,
      checkInFrequency: null == checkInFrequency
          ? _value.checkInFrequency
          : checkInFrequency // ignore: cast_nullable_to_non_nullable
              as int,
      autoExpire: null == autoExpire
          ? _value.autoExpire
          : autoExpire // ignore: cast_nullable_to_non_nullable
              as bool,
      expiryDays: null == expiryDays
          ? _value.expiryDays
          : expiryDays // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$BuddySettingsImplCopyWith<$Res>
    implements $BuddySettingsCopyWith<$Res> {
  factory _$$BuddySettingsImplCopyWith(
          _$BuddySettingsImpl value, $Res Function(_$BuddySettingsImpl) then) =
      __$$BuddySettingsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {bool shareStreak,
      bool shareXP,
      bool shareActivities,
      bool shareGoals,
      bool notificationsEnabled,
      bool competitiveMode,
      int checkInFrequency,
      bool autoExpire,
      int expiryDays});
}

/// @nodoc
class __$$BuddySettingsImplCopyWithImpl<$Res>
    extends _$BuddySettingsCopyWithImpl<$Res, _$BuddySettingsImpl>
    implements _$$BuddySettingsImplCopyWith<$Res> {
  __$$BuddySettingsImplCopyWithImpl(
      _$BuddySettingsImpl _value, $Res Function(_$BuddySettingsImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? shareStreak = null,
    Object? shareXP = null,
    Object? shareActivities = null,
    Object? shareGoals = null,
    Object? notificationsEnabled = null,
    Object? competitiveMode = null,
    Object? checkInFrequency = null,
    Object? autoExpire = null,
    Object? expiryDays = null,
  }) {
    return _then(_$BuddySettingsImpl(
      shareStreak: null == shareStreak
          ? _value.shareStreak
          : shareStreak // ignore: cast_nullable_to_non_nullable
              as bool,
      shareXP: null == shareXP
          ? _value.shareXP
          : shareXP // ignore: cast_nullable_to_non_nullable
              as bool,
      shareActivities: null == shareActivities
          ? _value.shareActivities
          : shareActivities // ignore: cast_nullable_to_non_nullable
              as bool,
      shareGoals: null == shareGoals
          ? _value.shareGoals
          : shareGoals // ignore: cast_nullable_to_non_nullable
              as bool,
      notificationsEnabled: null == notificationsEnabled
          ? _value.notificationsEnabled
          : notificationsEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      competitiveMode: null == competitiveMode
          ? _value.competitiveMode
          : competitiveMode // ignore: cast_nullable_to_non_nullable
              as bool,
      checkInFrequency: null == checkInFrequency
          ? _value.checkInFrequency
          : checkInFrequency // ignore: cast_nullable_to_non_nullable
              as int,
      autoExpire: null == autoExpire
          ? _value.autoExpire
          : autoExpire // ignore: cast_nullable_to_non_nullable
              as bool,
      expiryDays: null == expiryDays
          ? _value.expiryDays
          : expiryDays // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$BuddySettingsImpl implements _BuddySettings {
  const _$BuddySettingsImpl(
      {required this.shareStreak,
      required this.shareXP,
      required this.shareActivities,
      required this.shareGoals,
      required this.notificationsEnabled,
      required this.competitiveMode,
      required this.checkInFrequency,
      required this.autoExpire,
      required this.expiryDays});

  factory _$BuddySettingsImpl.fromJson(Map<String, dynamic> json) =>
      _$$BuddySettingsImplFromJson(json);

  @override
  final bool shareStreak;
  @override
  final bool shareXP;
  @override
  final bool shareActivities;
  @override
  final bool shareGoals;
  @override
  final bool notificationsEnabled;
  @override
  final bool competitiveMode;
  @override
  final int checkInFrequency;
  @override
  final bool autoExpire;
  @override
  final int expiryDays;

  @override
  String toString() {
    return 'BuddySettings(shareStreak: $shareStreak, shareXP: $shareXP, shareActivities: $shareActivities, shareGoals: $shareGoals, notificationsEnabled: $notificationsEnabled, competitiveMode: $competitiveMode, checkInFrequency: $checkInFrequency, autoExpire: $autoExpire, expiryDays: $expiryDays)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BuddySettingsImpl &&
            (identical(other.shareStreak, shareStreak) ||
                other.shareStreak == shareStreak) &&
            (identical(other.shareXP, shareXP) || other.shareXP == shareXP) &&
            (identical(other.shareActivities, shareActivities) ||
                other.shareActivities == shareActivities) &&
            (identical(other.shareGoals, shareGoals) ||
                other.shareGoals == shareGoals) &&
            (identical(other.notificationsEnabled, notificationsEnabled) ||
                other.notificationsEnabled == notificationsEnabled) &&
            (identical(other.competitiveMode, competitiveMode) ||
                other.competitiveMode == competitiveMode) &&
            (identical(other.checkInFrequency, checkInFrequency) ||
                other.checkInFrequency == checkInFrequency) &&
            (identical(other.autoExpire, autoExpire) ||
                other.autoExpire == autoExpire) &&
            (identical(other.expiryDays, expiryDays) ||
                other.expiryDays == expiryDays));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      shareStreak,
      shareXP,
      shareActivities,
      shareGoals,
      notificationsEnabled,
      competitiveMode,
      checkInFrequency,
      autoExpire,
      expiryDays);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$BuddySettingsImplCopyWith<_$BuddySettingsImpl> get copyWith =>
      __$$BuddySettingsImplCopyWithImpl<_$BuddySettingsImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$BuddySettingsImplToJson(
      this,
    );
  }
}

abstract class _BuddySettings implements BuddySettings {
  const factory _BuddySettings(
      {required final bool shareStreak,
      required final bool shareXP,
      required final bool shareActivities,
      required final bool shareGoals,
      required final bool notificationsEnabled,
      required final bool competitiveMode,
      required final int checkInFrequency,
      required final bool autoExpire,
      required final int expiryDays}) = _$BuddySettingsImpl;

  factory _BuddySettings.fromJson(Map<String, dynamic> json) =
      _$BuddySettingsImpl.fromJson;

  @override
  bool get shareStreak;
  @override
  bool get shareXP;
  @override
  bool get shareActivities;
  @override
  bool get shareGoals;
  @override
  bool get notificationsEnabled;
  @override
  bool get competitiveMode;
  @override
  int get checkInFrequency;
  @override
  bool get autoExpire;
  @override
  int get expiryDays;
  @override
  @JsonKey(ignore: true)
  _$$BuddySettingsImplCopyWith<_$BuddySettingsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

Team _$TeamFromJson(Map<String, dynamic> json) {
  return _Team.fromJson(json);
}

/// @nodoc
mixin _$Team {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  String get ownerId => throw _privateConstructorUsedError;
  String get avatarAsset => throw _privateConstructorUsedError;
  TeamType get type => throw _privateConstructorUsedError;
  TeamPrivacy get privacy => throw _privateConstructorUsedError;
  List<String> get memberIds => throw _privateConstructorUsedError;
  Map<String, TeamRole> get memberRoles => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime? get expiresAt => throw _privateConstructorUsedError;
  TeamSettings get settings => throw _privateConstructorUsedError;
  TeamStats get stats => throw _privateConstructorUsedError;
  List<TeamChallenge> get activeChallenges =>
      throw _privateConstructorUsedError;
  List<String> get inviteCodes => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $TeamCopyWith<Team> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TeamCopyWith<$Res> {
  factory $TeamCopyWith(Team value, $Res Function(Team) then) =
      _$TeamCopyWithImpl<$Res, Team>;
  @useResult
  $Res call(
      {String id,
      String name,
      String description,
      String ownerId,
      String avatarAsset,
      TeamType type,
      TeamPrivacy privacy,
      List<String> memberIds,
      Map<String, TeamRole> memberRoles,
      DateTime createdAt,
      DateTime? expiresAt,
      TeamSettings settings,
      TeamStats stats,
      List<TeamChallenge> activeChallenges,
      List<String> inviteCodes});

  $TeamSettingsCopyWith<$Res> get settings;
  $TeamStatsCopyWith<$Res> get stats;
}

/// @nodoc
class _$TeamCopyWithImpl<$Res, $Val extends Team>
    implements $TeamCopyWith<$Res> {
  _$TeamCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? description = null,
    Object? ownerId = null,
    Object? avatarAsset = null,
    Object? type = null,
    Object? privacy = null,
    Object? memberIds = null,
    Object? memberRoles = null,
    Object? createdAt = null,
    Object? expiresAt = freezed,
    Object? settings = null,
    Object? stats = null,
    Object? activeChallenges = null,
    Object? inviteCodes = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      ownerId: null == ownerId
          ? _value.ownerId
          : ownerId // ignore: cast_nullable_to_non_nullable
              as String,
      avatarAsset: null == avatarAsset
          ? _value.avatarAsset
          : avatarAsset // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as TeamType,
      privacy: null == privacy
          ? _value.privacy
          : privacy // ignore: cast_nullable_to_non_nullable
              as TeamPrivacy,
      memberIds: null == memberIds
          ? _value.memberIds
          : memberIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
      memberRoles: null == memberRoles
          ? _value.memberRoles
          : memberRoles // ignore: cast_nullable_to_non_nullable
              as Map<String, TeamRole>,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      expiresAt: freezed == expiresAt
          ? _value.expiresAt
          : expiresAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      settings: null == settings
          ? _value.settings
          : settings // ignore: cast_nullable_to_non_nullable
              as TeamSettings,
      stats: null == stats
          ? _value.stats
          : stats // ignore: cast_nullable_to_non_nullable
              as TeamStats,
      activeChallenges: null == activeChallenges
          ? _value.activeChallenges
          : activeChallenges // ignore: cast_nullable_to_non_nullable
              as List<TeamChallenge>,
      inviteCodes: null == inviteCodes
          ? _value.inviteCodes
          : inviteCodes // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $TeamSettingsCopyWith<$Res> get settings {
    return $TeamSettingsCopyWith<$Res>(_value.settings, (value) {
      return _then(_value.copyWith(settings: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $TeamStatsCopyWith<$Res> get stats {
    return $TeamStatsCopyWith<$Res>(_value.stats, (value) {
      return _then(_value.copyWith(stats: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$TeamImplCopyWith<$Res> implements $TeamCopyWith<$Res> {
  factory _$$TeamImplCopyWith(
          _$TeamImpl value, $Res Function(_$TeamImpl) then) =
      __$$TeamImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String name,
      String description,
      String ownerId,
      String avatarAsset,
      TeamType type,
      TeamPrivacy privacy,
      List<String> memberIds,
      Map<String, TeamRole> memberRoles,
      DateTime createdAt,
      DateTime? expiresAt,
      TeamSettings settings,
      TeamStats stats,
      List<TeamChallenge> activeChallenges,
      List<String> inviteCodes});

  @override
  $TeamSettingsCopyWith<$Res> get settings;
  @override
  $TeamStatsCopyWith<$Res> get stats;
}

/// @nodoc
class __$$TeamImplCopyWithImpl<$Res>
    extends _$TeamCopyWithImpl<$Res, _$TeamImpl>
    implements _$$TeamImplCopyWith<$Res> {
  __$$TeamImplCopyWithImpl(_$TeamImpl _value, $Res Function(_$TeamImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? description = null,
    Object? ownerId = null,
    Object? avatarAsset = null,
    Object? type = null,
    Object? privacy = null,
    Object? memberIds = null,
    Object? memberRoles = null,
    Object? createdAt = null,
    Object? expiresAt = freezed,
    Object? settings = null,
    Object? stats = null,
    Object? activeChallenges = null,
    Object? inviteCodes = null,
  }) {
    return _then(_$TeamImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      ownerId: null == ownerId
          ? _value.ownerId
          : ownerId // ignore: cast_nullable_to_non_nullable
              as String,
      avatarAsset: null == avatarAsset
          ? _value.avatarAsset
          : avatarAsset // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as TeamType,
      privacy: null == privacy
          ? _value.privacy
          : privacy // ignore: cast_nullable_to_non_nullable
              as TeamPrivacy,
      memberIds: null == memberIds
          ? _value._memberIds
          : memberIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
      memberRoles: null == memberRoles
          ? _value._memberRoles
          : memberRoles // ignore: cast_nullable_to_non_nullable
              as Map<String, TeamRole>,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      expiresAt: freezed == expiresAt
          ? _value.expiresAt
          : expiresAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      settings: null == settings
          ? _value.settings
          : settings // ignore: cast_nullable_to_non_nullable
              as TeamSettings,
      stats: null == stats
          ? _value.stats
          : stats // ignore: cast_nullable_to_non_nullable
              as TeamStats,
      activeChallenges: null == activeChallenges
          ? _value._activeChallenges
          : activeChallenges // ignore: cast_nullable_to_non_nullable
              as List<TeamChallenge>,
      inviteCodes: null == inviteCodes
          ? _value._inviteCodes
          : inviteCodes // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TeamImpl implements _Team {
  const _$TeamImpl(
      {required this.id,
      required this.name,
      required this.description,
      required this.ownerId,
      required this.avatarAsset,
      required this.type,
      required this.privacy,
      required final List<String> memberIds,
      required final Map<String, TeamRole> memberRoles,
      required this.createdAt,
      required this.expiresAt,
      required this.settings,
      required this.stats,
      required final List<TeamChallenge> activeChallenges,
      required final List<String> inviteCodes})
      : _memberIds = memberIds,
        _memberRoles = memberRoles,
        _activeChallenges = activeChallenges,
        _inviteCodes = inviteCodes;

  factory _$TeamImpl.fromJson(Map<String, dynamic> json) =>
      _$$TeamImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final String description;
  @override
  final String ownerId;
  @override
  final String avatarAsset;
  @override
  final TeamType type;
  @override
  final TeamPrivacy privacy;
  final List<String> _memberIds;
  @override
  List<String> get memberIds {
    if (_memberIds is EqualUnmodifiableListView) return _memberIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_memberIds);
  }

  final Map<String, TeamRole> _memberRoles;
  @override
  Map<String, TeamRole> get memberRoles {
    if (_memberRoles is EqualUnmodifiableMapView) return _memberRoles;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_memberRoles);
  }

  @override
  final DateTime createdAt;
  @override
  final DateTime? expiresAt;
  @override
  final TeamSettings settings;
  @override
  final TeamStats stats;
  final List<TeamChallenge> _activeChallenges;
  @override
  List<TeamChallenge> get activeChallenges {
    if (_activeChallenges is EqualUnmodifiableListView)
      return _activeChallenges;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_activeChallenges);
  }

  final List<String> _inviteCodes;
  @override
  List<String> get inviteCodes {
    if (_inviteCodes is EqualUnmodifiableListView) return _inviteCodes;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_inviteCodes);
  }

  @override
  String toString() {
    return 'Team(id: $id, name: $name, description: $description, ownerId: $ownerId, avatarAsset: $avatarAsset, type: $type, privacy: $privacy, memberIds: $memberIds, memberRoles: $memberRoles, createdAt: $createdAt, expiresAt: $expiresAt, settings: $settings, stats: $stats, activeChallenges: $activeChallenges, inviteCodes: $inviteCodes)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TeamImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.ownerId, ownerId) || other.ownerId == ownerId) &&
            (identical(other.avatarAsset, avatarAsset) ||
                other.avatarAsset == avatarAsset) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.privacy, privacy) || other.privacy == privacy) &&
            const DeepCollectionEquality()
                .equals(other._memberIds, _memberIds) &&
            const DeepCollectionEquality()
                .equals(other._memberRoles, _memberRoles) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.expiresAt, expiresAt) ||
                other.expiresAt == expiresAt) &&
            (identical(other.settings, settings) ||
                other.settings == settings) &&
            (identical(other.stats, stats) || other.stats == stats) &&
            const DeepCollectionEquality()
                .equals(other._activeChallenges, _activeChallenges) &&
            const DeepCollectionEquality()
                .equals(other._inviteCodes, _inviteCodes));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      name,
      description,
      ownerId,
      avatarAsset,
      type,
      privacy,
      const DeepCollectionEquality().hash(_memberIds),
      const DeepCollectionEquality().hash(_memberRoles),
      createdAt,
      expiresAt,
      settings,
      stats,
      const DeepCollectionEquality().hash(_activeChallenges),
      const DeepCollectionEquality().hash(_inviteCodes));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$TeamImplCopyWith<_$TeamImpl> get copyWith =>
      __$$TeamImplCopyWithImpl<_$TeamImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TeamImplToJson(
      this,
    );
  }
}

abstract class _Team implements Team {
  const factory _Team(
      {required final String id,
      required final String name,
      required final String description,
      required final String ownerId,
      required final String avatarAsset,
      required final TeamType type,
      required final TeamPrivacy privacy,
      required final List<String> memberIds,
      required final Map<String, TeamRole> memberRoles,
      required final DateTime createdAt,
      required final DateTime? expiresAt,
      required final TeamSettings settings,
      required final TeamStats stats,
      required final List<TeamChallenge> activeChallenges,
      required final List<String> inviteCodes}) = _$TeamImpl;

  factory _Team.fromJson(Map<String, dynamic> json) = _$TeamImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  String get description;
  @override
  String get ownerId;
  @override
  String get avatarAsset;
  @override
  TeamType get type;
  @override
  TeamPrivacy get privacy;
  @override
  List<String> get memberIds;
  @override
  Map<String, TeamRole> get memberRoles;
  @override
  DateTime get createdAt;
  @override
  DateTime? get expiresAt;
  @override
  TeamSettings get settings;
  @override
  TeamStats get stats;
  @override
  List<TeamChallenge> get activeChallenges;
  @override
  List<String> get inviteCodes;
  @override
  @JsonKey(ignore: true)
  _$$TeamImplCopyWith<_$TeamImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

TeamSettings _$TeamSettingsFromJson(Map<String, dynamic> json) {
  return _TeamSettings.fromJson(json);
}

/// @nodoc
mixin _$TeamSettings {
  bool get shareStreaks => throw _privateConstructorUsedError;
  bool get shareXP => throw _privateConstructorUsedError;
  bool get shareActivities => throw _privateConstructorUsedError;
  bool get notificationsEnabled => throw _privateConstructorUsedError;
  bool get competitiveMode => throw _privateConstructorUsedError;
  int get checkInFrequency => throw _privateConstructorUsedError;
  bool get autoRemoveInactive => throw _privateConstructorUsedError;
  int get inactivityDays => throw _privateConstructorUsedError;
  bool get requireCheckIn => throw _privateConstructorUsedError;
  int get minWeeklyActivities => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $TeamSettingsCopyWith<TeamSettings> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TeamSettingsCopyWith<$Res> {
  factory $TeamSettingsCopyWith(
          TeamSettings value, $Res Function(TeamSettings) then) =
      _$TeamSettingsCopyWithImpl<$Res, TeamSettings>;
  @useResult
  $Res call(
      {bool shareStreaks,
      bool shareXP,
      bool shareActivities,
      bool notificationsEnabled,
      bool competitiveMode,
      int checkInFrequency,
      bool autoRemoveInactive,
      int inactivityDays,
      bool requireCheckIn,
      int minWeeklyActivities});
}

/// @nodoc
class _$TeamSettingsCopyWithImpl<$Res, $Val extends TeamSettings>
    implements $TeamSettingsCopyWith<$Res> {
  _$TeamSettingsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? shareStreaks = null,
    Object? shareXP = null,
    Object? shareActivities = null,
    Object? notificationsEnabled = null,
    Object? competitiveMode = null,
    Object? checkInFrequency = null,
    Object? autoRemoveInactive = null,
    Object? inactivityDays = null,
    Object? requireCheckIn = null,
    Object? minWeeklyActivities = null,
  }) {
    return _then(_value.copyWith(
      shareStreaks: null == shareStreaks
          ? _value.shareStreaks
          : shareStreaks // ignore: cast_nullable_to_non_nullable
              as bool,
      shareXP: null == shareXP
          ? _value.shareXP
          : shareXP // ignore: cast_nullable_to_non_nullable
              as bool,
      shareActivities: null == shareActivities
          ? _value.shareActivities
          : shareActivities // ignore: cast_nullable_to_non_nullable
              as bool,
      notificationsEnabled: null == notificationsEnabled
          ? _value.notificationsEnabled
          : notificationsEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      competitiveMode: null == competitiveMode
          ? _value.competitiveMode
          : competitiveMode // ignore: cast_nullable_to_non_nullable
              as bool,
      checkInFrequency: null == checkInFrequency
          ? _value.checkInFrequency
          : checkInFrequency // ignore: cast_nullable_to_non_nullable
              as int,
      autoRemoveInactive: null == autoRemoveInactive
          ? _value.autoRemoveInactive
          : autoRemoveInactive // ignore: cast_nullable_to_non_nullable
              as bool,
      inactivityDays: null == inactivityDays
          ? _value.inactivityDays
          : inactivityDays // ignore: cast_nullable_to_non_nullable
              as int,
      requireCheckIn: null == requireCheckIn
          ? _value.requireCheckIn
          : requireCheckIn // ignore: cast_nullable_to_non_nullable
              as bool,
      minWeeklyActivities: null == minWeeklyActivities
          ? _value.minWeeklyActivities
          : minWeeklyActivities // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TeamSettingsImplCopyWith<$Res>
    implements $TeamSettingsCopyWith<$Res> {
  factory _$$TeamSettingsImplCopyWith(
          _$TeamSettingsImpl value, $Res Function(_$TeamSettingsImpl) then) =
      __$$TeamSettingsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {bool shareStreaks,
      bool shareXP,
      bool shareActivities,
      bool notificationsEnabled,
      bool competitiveMode,
      int checkInFrequency,
      bool autoRemoveInactive,
      int inactivityDays,
      bool requireCheckIn,
      int minWeeklyActivities});
}

/// @nodoc
class __$$TeamSettingsImplCopyWithImpl<$Res>
    extends _$TeamSettingsCopyWithImpl<$Res, _$TeamSettingsImpl>
    implements _$$TeamSettingsImplCopyWith<$Res> {
  __$$TeamSettingsImplCopyWithImpl(
      _$TeamSettingsImpl _value, $Res Function(_$TeamSettingsImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? shareStreaks = null,
    Object? shareXP = null,
    Object? shareActivities = null,
    Object? notificationsEnabled = null,
    Object? competitiveMode = null,
    Object? checkInFrequency = null,
    Object? autoRemoveInactive = null,
    Object? inactivityDays = null,
    Object? requireCheckIn = null,
    Object? minWeeklyActivities = null,
  }) {
    return _then(_$TeamSettingsImpl(
      shareStreaks: null == shareStreaks
          ? _value.shareStreaks
          : shareStreaks // ignore: cast_nullable_to_non_nullable
              as bool,
      shareXP: null == shareXP
          ? _value.shareXP
          : shareXP // ignore: cast_nullable_to_non_nullable
              as bool,
      shareActivities: null == shareActivities
          ? _value.shareActivities
          : shareActivities // ignore: cast_nullable_to_non_nullable
              as bool,
      notificationsEnabled: null == notificationsEnabled
          ? _value.notificationsEnabled
          : notificationsEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      competitiveMode: null == competitiveMode
          ? _value.competitiveMode
          : competitiveMode // ignore: cast_nullable_to_non_nullable
              as bool,
      checkInFrequency: null == checkInFrequency
          ? _value.checkInFrequency
          : checkInFrequency // ignore: cast_nullable_to_non_nullable
              as int,
      autoRemoveInactive: null == autoRemoveInactive
          ? _value.autoRemoveInactive
          : autoRemoveInactive // ignore: cast_nullable_to_non_nullable
              as bool,
      inactivityDays: null == inactivityDays
          ? _value.inactivityDays
          : inactivityDays // ignore: cast_nullable_to_non_nullable
              as int,
      requireCheckIn: null == requireCheckIn
          ? _value.requireCheckIn
          : requireCheckIn // ignore: cast_nullable_to_non_nullable
              as bool,
      minWeeklyActivities: null == minWeeklyActivities
          ? _value.minWeeklyActivities
          : minWeeklyActivities // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TeamSettingsImpl implements _TeamSettings {
  const _$TeamSettingsImpl(
      {required this.shareStreaks,
      required this.shareXP,
      required this.shareActivities,
      required this.notificationsEnabled,
      required this.competitiveMode,
      required this.checkInFrequency,
      required this.autoRemoveInactive,
      required this.inactivityDays,
      required this.requireCheckIn,
      required this.minWeeklyActivities});

  factory _$TeamSettingsImpl.fromJson(Map<String, dynamic> json) =>
      _$$TeamSettingsImplFromJson(json);

  @override
  final bool shareStreaks;
  @override
  final bool shareXP;
  @override
  final bool shareActivities;
  @override
  final bool notificationsEnabled;
  @override
  final bool competitiveMode;
  @override
  final int checkInFrequency;
  @override
  final bool autoRemoveInactive;
  @override
  final int inactivityDays;
  @override
  final bool requireCheckIn;
  @override
  final int minWeeklyActivities;

  @override
  String toString() {
    return 'TeamSettings(shareStreaks: $shareStreaks, shareXP: $shareXP, shareActivities: $shareActivities, notificationsEnabled: $notificationsEnabled, competitiveMode: $competitiveMode, checkInFrequency: $checkInFrequency, autoRemoveInactive: $autoRemoveInactive, inactivityDays: $inactivityDays, requireCheckIn: $requireCheckIn, minWeeklyActivities: $minWeeklyActivities)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TeamSettingsImpl &&
            (identical(other.shareStreaks, shareStreaks) ||
                other.shareStreaks == shareStreaks) &&
            (identical(other.shareXP, shareXP) || other.shareXP == shareXP) &&
            (identical(other.shareActivities, shareActivities) ||
                other.shareActivities == shareActivities) &&
            (identical(other.notificationsEnabled, notificationsEnabled) ||
                other.notificationsEnabled == notificationsEnabled) &&
            (identical(other.competitiveMode, competitiveMode) ||
                other.competitiveMode == competitiveMode) &&
            (identical(other.checkInFrequency, checkInFrequency) ||
                other.checkInFrequency == checkInFrequency) &&
            (identical(other.autoRemoveInactive, autoRemoveInactive) ||
                other.autoRemoveInactive == autoRemoveInactive) &&
            (identical(other.inactivityDays, inactivityDays) ||
                other.inactivityDays == inactivityDays) &&
            (identical(other.requireCheckIn, requireCheckIn) ||
                other.requireCheckIn == requireCheckIn) &&
            (identical(other.minWeeklyActivities, minWeeklyActivities) ||
                other.minWeeklyActivities == minWeeklyActivities));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      shareStreaks,
      shareXP,
      shareActivities,
      notificationsEnabled,
      competitiveMode,
      checkInFrequency,
      autoRemoveInactive,
      inactivityDays,
      requireCheckIn,
      minWeeklyActivities);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$TeamSettingsImplCopyWith<_$TeamSettingsImpl> get copyWith =>
      __$$TeamSettingsImplCopyWithImpl<_$TeamSettingsImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TeamSettingsImplToJson(
      this,
    );
  }
}

abstract class _TeamSettings implements TeamSettings {
  const factory _TeamSettings(
      {required final bool shareStreaks,
      required final bool shareXP,
      required final bool shareActivities,
      required final bool notificationsEnabled,
      required final bool competitiveMode,
      required final int checkInFrequency,
      required final bool autoRemoveInactive,
      required final int inactivityDays,
      required final bool requireCheckIn,
      required final int minWeeklyActivities}) = _$TeamSettingsImpl;

  factory _TeamSettings.fromJson(Map<String, dynamic> json) =
      _$TeamSettingsImpl.fromJson;

  @override
  bool get shareStreaks;
  @override
  bool get shareXP;
  @override
  bool get shareActivities;
  @override
  bool get notificationsEnabled;
  @override
  bool get competitiveMode;
  @override
  int get checkInFrequency;
  @override
  bool get autoRemoveInactive;
  @override
  int get inactivityDays;
  @override
  bool get requireCheckIn;
  @override
  int get minWeeklyActivities;
  @override
  @JsonKey(ignore: true)
  _$$TeamSettingsImplCopyWith<_$TeamSettingsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

TeamStats _$TeamStatsFromJson(Map<String, dynamic> json) {
  return _TeamStats.fromJson(json);
}

/// @nodoc
mixin _$TeamStats {
  int get totalMembers => throw _privateConstructorUsedError;
  int get activeMembers => throw _privateConstructorUsedError;
  int get totalSharedStreakDays => throw _privateConstructorUsedError;
  int get totalSharedActivities => throw _privateConstructorUsedError;
  int get totalSharedXP => throw _privateConstructorUsedError;
  int get completedChallenges => throw _privateConstructorUsedError;
  int get activeChallenges => throw _privateConstructorUsedError;
  double get averageStreakDays => throw _privateConstructorUsedError;
  Map<String, int> get pillarXPTotals => throw _privateConstructorUsedError;
  DateTime get lastUpdated => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $TeamStatsCopyWith<TeamStats> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TeamStatsCopyWith<$Res> {
  factory $TeamStatsCopyWith(TeamStats value, $Res Function(TeamStats) then) =
      _$TeamStatsCopyWithImpl<$Res, TeamStats>;
  @useResult
  $Res call(
      {int totalMembers,
      int activeMembers,
      int totalSharedStreakDays,
      int totalSharedActivities,
      int totalSharedXP,
      int completedChallenges,
      int activeChallenges,
      double averageStreakDays,
      Map<String, int> pillarXPTotals,
      DateTime lastUpdated});
}

/// @nodoc
class _$TeamStatsCopyWithImpl<$Res, $Val extends TeamStats>
    implements $TeamStatsCopyWith<$Res> {
  _$TeamStatsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalMembers = null,
    Object? activeMembers = null,
    Object? totalSharedStreakDays = null,
    Object? totalSharedActivities = null,
    Object? totalSharedXP = null,
    Object? completedChallenges = null,
    Object? activeChallenges = null,
    Object? averageStreakDays = null,
    Object? pillarXPTotals = null,
    Object? lastUpdated = null,
  }) {
    return _then(_value.copyWith(
      totalMembers: null == totalMembers
          ? _value.totalMembers
          : totalMembers // ignore: cast_nullable_to_non_nullable
              as int,
      activeMembers: null == activeMembers
          ? _value.activeMembers
          : activeMembers // ignore: cast_nullable_to_non_nullable
              as int,
      totalSharedStreakDays: null == totalSharedStreakDays
          ? _value.totalSharedStreakDays
          : totalSharedStreakDays // ignore: cast_nullable_to_non_nullable
              as int,
      totalSharedActivities: null == totalSharedActivities
          ? _value.totalSharedActivities
          : totalSharedActivities // ignore: cast_nullable_to_non_nullable
              as int,
      totalSharedXP: null == totalSharedXP
          ? _value.totalSharedXP
          : totalSharedXP // ignore: cast_nullable_to_non_nullable
              as int,
      completedChallenges: null == completedChallenges
          ? _value.completedChallenges
          : completedChallenges // ignore: cast_nullable_to_non_nullable
              as int,
      activeChallenges: null == activeChallenges
          ? _value.activeChallenges
          : activeChallenges // ignore: cast_nullable_to_non_nullable
              as int,
      averageStreakDays: null == averageStreakDays
          ? _value.averageStreakDays
          : averageStreakDays // ignore: cast_nullable_to_non_nullable
              as double,
      pillarXPTotals: null == pillarXPTotals
          ? _value.pillarXPTotals
          : pillarXPTotals // ignore: cast_nullable_to_non_nullable
              as Map<String, int>,
      lastUpdated: null == lastUpdated
          ? _value.lastUpdated
          : lastUpdated // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TeamStatsImplCopyWith<$Res>
    implements $TeamStatsCopyWith<$Res> {
  factory _$$TeamStatsImplCopyWith(
          _$TeamStatsImpl value, $Res Function(_$TeamStatsImpl) then) =
      __$$TeamStatsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int totalMembers,
      int activeMembers,
      int totalSharedStreakDays,
      int totalSharedActivities,
      int totalSharedXP,
      int completedChallenges,
      int activeChallenges,
      double averageStreakDays,
      Map<String, int> pillarXPTotals,
      DateTime lastUpdated});
}

/// @nodoc
class __$$TeamStatsImplCopyWithImpl<$Res>
    extends _$TeamStatsCopyWithImpl<$Res, _$TeamStatsImpl>
    implements _$$TeamStatsImplCopyWith<$Res> {
  __$$TeamStatsImplCopyWithImpl(
      _$TeamStatsImpl _value, $Res Function(_$TeamStatsImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalMembers = null,
    Object? activeMembers = null,
    Object? totalSharedStreakDays = null,
    Object? totalSharedActivities = null,
    Object? totalSharedXP = null,
    Object? completedChallenges = null,
    Object? activeChallenges = null,
    Object? averageStreakDays = null,
    Object? pillarXPTotals = null,
    Object? lastUpdated = null,
  }) {
    return _then(_$TeamStatsImpl(
      totalMembers: null == totalMembers
          ? _value.totalMembers
          : totalMembers // ignore: cast_nullable_to_non_nullable
              as int,
      activeMembers: null == activeMembers
          ? _value.activeMembers
          : activeMembers // ignore: cast_nullable_to_non_nullable
              as int,
      totalSharedStreakDays: null == totalSharedStreakDays
          ? _value.totalSharedStreakDays
          : totalSharedStreakDays // ignore: cast_nullable_to_non_nullable
              as int,
      totalSharedActivities: null == totalSharedActivities
          ? _value.totalSharedActivities
          : totalSharedActivities // ignore: cast_nullable_to_non_nullable
              as int,
      totalSharedXP: null == totalSharedXP
          ? _value.totalSharedXP
          : totalSharedXP // ignore: cast_nullable_to_non_nullable
              as int,
      completedChallenges: null == completedChallenges
          ? _value.completedChallenges
          : completedChallenges // ignore: cast_nullable_to_non_nullable
              as int,
      activeChallenges: null == activeChallenges
          ? _value.activeChallenges
          : activeChallenges // ignore: cast_nullable_to_non_nullable
              as int,
      averageStreakDays: null == averageStreakDays
          ? _value.averageStreakDays
          : averageStreakDays // ignore: cast_nullable_to_non_nullable
              as double,
      pillarXPTotals: null == pillarXPTotals
          ? _value._pillarXPTotals
          : pillarXPTotals // ignore: cast_nullable_to_non_nullable
              as Map<String, int>,
      lastUpdated: null == lastUpdated
          ? _value.lastUpdated
          : lastUpdated // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TeamStatsImpl implements _TeamStats {
  const _$TeamStatsImpl(
      {required this.totalMembers,
      required this.activeMembers,
      required this.totalSharedStreakDays,
      required this.totalSharedActivities,
      required this.totalSharedXP,
      required this.completedChallenges,
      required this.activeChallenges,
      required this.averageStreakDays,
      required final Map<String, int> pillarXPTotals,
      required this.lastUpdated})
      : _pillarXPTotals = pillarXPTotals;

  factory _$TeamStatsImpl.fromJson(Map<String, dynamic> json) =>
      _$$TeamStatsImplFromJson(json);

  @override
  final int totalMembers;
  @override
  final int activeMembers;
  @override
  final int totalSharedStreakDays;
  @override
  final int totalSharedActivities;
  @override
  final int totalSharedXP;
  @override
  final int completedChallenges;
  @override
  final int activeChallenges;
  @override
  final double averageStreakDays;
  final Map<String, int> _pillarXPTotals;
  @override
  Map<String, int> get pillarXPTotals {
    if (_pillarXPTotals is EqualUnmodifiableMapView) return _pillarXPTotals;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_pillarXPTotals);
  }

  @override
  final DateTime lastUpdated;

  @override
  String toString() {
    return 'TeamStats(totalMembers: $totalMembers, activeMembers: $activeMembers, totalSharedStreakDays: $totalSharedStreakDays, totalSharedActivities: $totalSharedActivities, totalSharedXP: $totalSharedXP, completedChallenges: $completedChallenges, activeChallenges: $activeChallenges, averageStreakDays: $averageStreakDays, pillarXPTotals: $pillarXPTotals, lastUpdated: $lastUpdated)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TeamStatsImpl &&
            (identical(other.totalMembers, totalMembers) ||
                other.totalMembers == totalMembers) &&
            (identical(other.activeMembers, activeMembers) ||
                other.activeMembers == activeMembers) &&
            (identical(other.totalSharedStreakDays, totalSharedStreakDays) ||
                other.totalSharedStreakDays == totalSharedStreakDays) &&
            (identical(other.totalSharedActivities, totalSharedActivities) ||
                other.totalSharedActivities == totalSharedActivities) &&
            (identical(other.totalSharedXP, totalSharedXP) ||
                other.totalSharedXP == totalSharedXP) &&
            (identical(other.completedChallenges, completedChallenges) ||
                other.completedChallenges == completedChallenges) &&
            (identical(other.activeChallenges, activeChallenges) ||
                other.activeChallenges == activeChallenges) &&
            (identical(other.averageStreakDays, averageStreakDays) ||
                other.averageStreakDays == averageStreakDays) &&
            const DeepCollectionEquality()
                .equals(other._pillarXPTotals, _pillarXPTotals) &&
            (identical(other.lastUpdated, lastUpdated) ||
                other.lastUpdated == lastUpdated));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      totalMembers,
      activeMembers,
      totalSharedStreakDays,
      totalSharedActivities,
      totalSharedXP,
      completedChallenges,
      activeChallenges,
      averageStreakDays,
      const DeepCollectionEquality().hash(_pillarXPTotals),
      lastUpdated);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$TeamStatsImplCopyWith<_$TeamStatsImpl> get copyWith =>
      __$$TeamStatsImplCopyWithImpl<_$TeamStatsImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TeamStatsImplToJson(
      this,
    );
  }
}

abstract class _TeamStats implements TeamStats {
  const factory _TeamStats(
      {required final int totalMembers,
      required final int activeMembers,
      required final int totalSharedStreakDays,
      required final int totalSharedActivities,
      required final int totalSharedXP,
      required final int completedChallenges,
      required final int activeChallenges,
      required final double averageStreakDays,
      required final Map<String, int> pillarXPTotals,
      required final DateTime lastUpdated}) = _$TeamStatsImpl;

  factory _TeamStats.fromJson(Map<String, dynamic> json) =
      _$TeamStatsImpl.fromJson;

  @override
  int get totalMembers;
  @override
  int get activeMembers;
  @override
  int get totalSharedStreakDays;
  @override
  int get totalSharedActivities;
  @override
  int get totalSharedXP;
  @override
  int get completedChallenges;
  @override
  int get activeChallenges;
  @override
  double get averageStreakDays;
  @override
  Map<String, int> get pillarXPTotals;
  @override
  DateTime get lastUpdated;
  @override
  @JsonKey(ignore: true)
  _$$TeamStatsImplCopyWith<_$TeamStatsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

TeamChallenge _$TeamChallengeFromJson(Map<String, dynamic> json) {
  return _TeamChallenge.fromJson(json);
}

/// @nodoc
mixin _$TeamChallenge {
  String get id => throw _privateConstructorUsedError;
  String get teamId => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  ChallengeType get type => throw _privateConstructorUsedError;
  DateTime get startDate => throw _privateConstructorUsedError;
  DateTime get endDate => throw _privateConstructorUsedError;
  @JsonKey(
      name: 'goal',
      fromJson: _challengeGoalFromJson,
      toJson: _challengeGoalToJson)
  ChallengeGoal get goal => throw _privateConstructorUsedError;
  List<ChallengeReward> get rewards => throw _privateConstructorUsedError;
  List<String> get participantIds => throw _privateConstructorUsedError;
  Map<String, ChallengeProgress> get progress =>
      throw _privateConstructorUsedError;
  ChallengeStatus get status => throw _privateConstructorUsedError;
  String get createdBy => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $TeamChallengeCopyWith<TeamChallenge> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TeamChallengeCopyWith<$Res> {
  factory $TeamChallengeCopyWith(
          TeamChallenge value, $Res Function(TeamChallenge) then) =
      _$TeamChallengeCopyWithImpl<$Res, TeamChallenge>;
  @useResult
  $Res call(
      {String id,
      String teamId,
      String title,
      String description,
      ChallengeType type,
      DateTime startDate,
      DateTime endDate,
      @JsonKey(
          name: 'goal',
          fromJson: _challengeGoalFromJson,
          toJson: _challengeGoalToJson)
      ChallengeGoal goal,
      List<ChallengeReward> rewards,
      List<String> participantIds,
      Map<String, ChallengeProgress> progress,
      ChallengeStatus status,
      String createdBy,
      DateTime createdAt});

  $ChallengeGoalCopyWith<$Res> get goal;
}

/// @nodoc
class _$TeamChallengeCopyWithImpl<$Res, $Val extends TeamChallenge>
    implements $TeamChallengeCopyWith<$Res> {
  _$TeamChallengeCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? teamId = null,
    Object? title = null,
    Object? description = null,
    Object? type = null,
    Object? startDate = null,
    Object? endDate = null,
    Object? goal = null,
    Object? rewards = null,
    Object? participantIds = null,
    Object? progress = null,
    Object? status = null,
    Object? createdBy = null,
    Object? createdAt = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      teamId: null == teamId
          ? _value.teamId
          : teamId // ignore: cast_nullable_to_non_nullable
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
              as ChallengeType,
      startDate: null == startDate
          ? _value.startDate
          : startDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      endDate: null == endDate
          ? _value.endDate
          : endDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      goal: null == goal
          ? _value.goal
          : goal // ignore: cast_nullable_to_non_nullable
              as ChallengeGoal,
      rewards: null == rewards
          ? _value.rewards
          : rewards // ignore: cast_nullable_to_non_nullable
              as List<ChallengeReward>,
      participantIds: null == participantIds
          ? _value.participantIds
          : participantIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
      progress: null == progress
          ? _value.progress
          : progress // ignore: cast_nullable_to_non_nullable
              as Map<String, ChallengeProgress>,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as ChallengeStatus,
      createdBy: null == createdBy
          ? _value.createdBy
          : createdBy // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $ChallengeGoalCopyWith<$Res> get goal {
    return $ChallengeGoalCopyWith<$Res>(_value.goal, (value) {
      return _then(_value.copyWith(goal: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$TeamChallengeImplCopyWith<$Res>
    implements $TeamChallengeCopyWith<$Res> {
  factory _$$TeamChallengeImplCopyWith(
          _$TeamChallengeImpl value, $Res Function(_$TeamChallengeImpl) then) =
      __$$TeamChallengeImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String teamId,
      String title,
      String description,
      ChallengeType type,
      DateTime startDate,
      DateTime endDate,
      @JsonKey(
          name: 'goal',
          fromJson: _challengeGoalFromJson,
          toJson: _challengeGoalToJson)
      ChallengeGoal goal,
      List<ChallengeReward> rewards,
      List<String> participantIds,
      Map<String, ChallengeProgress> progress,
      ChallengeStatus status,
      String createdBy,
      DateTime createdAt});

  @override
  $ChallengeGoalCopyWith<$Res> get goal;
}

/// @nodoc
class __$$TeamChallengeImplCopyWithImpl<$Res>
    extends _$TeamChallengeCopyWithImpl<$Res, _$TeamChallengeImpl>
    implements _$$TeamChallengeImplCopyWith<$Res> {
  __$$TeamChallengeImplCopyWithImpl(
      _$TeamChallengeImpl _value, $Res Function(_$TeamChallengeImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? teamId = null,
    Object? title = null,
    Object? description = null,
    Object? type = null,
    Object? startDate = null,
    Object? endDate = null,
    Object? goal = null,
    Object? rewards = null,
    Object? participantIds = null,
    Object? progress = null,
    Object? status = null,
    Object? createdBy = null,
    Object? createdAt = null,
  }) {
    return _then(_$TeamChallengeImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      teamId: null == teamId
          ? _value.teamId
          : teamId // ignore: cast_nullable_to_non_nullable
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
              as ChallengeType,
      startDate: null == startDate
          ? _value.startDate
          : startDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      endDate: null == endDate
          ? _value.endDate
          : endDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      goal: null == goal
          ? _value.goal
          : goal // ignore: cast_nullable_to_non_nullable
              as ChallengeGoal,
      rewards: null == rewards
          ? _value._rewards
          : rewards // ignore: cast_nullable_to_non_nullable
              as List<ChallengeReward>,
      participantIds: null == participantIds
          ? _value._participantIds
          : participantIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
      progress: null == progress
          ? _value._progress
          : progress // ignore: cast_nullable_to_non_nullable
              as Map<String, ChallengeProgress>,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as ChallengeStatus,
      createdBy: null == createdBy
          ? _value.createdBy
          : createdBy // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TeamChallengeImpl implements _TeamChallenge {
  const _$TeamChallengeImpl(
      {required this.id,
      required this.teamId,
      required this.title,
      required this.description,
      required this.type,
      required this.startDate,
      required this.endDate,
      @JsonKey(
          name: 'goal',
          fromJson: _challengeGoalFromJson,
          toJson: _challengeGoalToJson)
      required this.goal,
      required final List<ChallengeReward> rewards,
      required final List<String> participantIds,
      required final Map<String, ChallengeProgress> progress,
      required this.status,
      required this.createdBy,
      required this.createdAt})
      : _rewards = rewards,
        _participantIds = participantIds,
        _progress = progress;

  factory _$TeamChallengeImpl.fromJson(Map<String, dynamic> json) =>
      _$$TeamChallengeImplFromJson(json);

  @override
  final String id;
  @override
  final String teamId;
  @override
  final String title;
  @override
  final String description;
  @override
  final ChallengeType type;
  @override
  final DateTime startDate;
  @override
  final DateTime endDate;
  @override
  @JsonKey(
      name: 'goal',
      fromJson: _challengeGoalFromJson,
      toJson: _challengeGoalToJson)
  final ChallengeGoal goal;
  final List<ChallengeReward> _rewards;
  @override
  List<ChallengeReward> get rewards {
    if (_rewards is EqualUnmodifiableListView) return _rewards;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_rewards);
  }

  final List<String> _participantIds;
  @override
  List<String> get participantIds {
    if (_participantIds is EqualUnmodifiableListView) return _participantIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_participantIds);
  }

  final Map<String, ChallengeProgress> _progress;
  @override
  Map<String, ChallengeProgress> get progress {
    if (_progress is EqualUnmodifiableMapView) return _progress;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_progress);
  }

  @override
  final ChallengeStatus status;
  @override
  final String createdBy;
  @override
  final DateTime createdAt;

  @override
  String toString() {
    return 'TeamChallenge(id: $id, teamId: $teamId, title: $title, description: $description, type: $type, startDate: $startDate, endDate: $endDate, goal: $goal, rewards: $rewards, participantIds: $participantIds, progress: $progress, status: $status, createdBy: $createdBy, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TeamChallengeImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.teamId, teamId) || other.teamId == teamId) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.startDate, startDate) ||
                other.startDate == startDate) &&
            (identical(other.endDate, endDate) || other.endDate == endDate) &&
            (identical(other.goal, goal) || other.goal == goal) &&
            const DeepCollectionEquality().equals(other._rewards, _rewards) &&
            const DeepCollectionEquality()
                .equals(other._participantIds, _participantIds) &&
            const DeepCollectionEquality().equals(other._progress, _progress) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.createdBy, createdBy) ||
                other.createdBy == createdBy) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      teamId,
      title,
      description,
      type,
      startDate,
      endDate,
      goal,
      const DeepCollectionEquality().hash(_rewards),
      const DeepCollectionEquality().hash(_participantIds),
      const DeepCollectionEquality().hash(_progress),
      status,
      createdBy,
      createdAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$TeamChallengeImplCopyWith<_$TeamChallengeImpl> get copyWith =>
      __$$TeamChallengeImplCopyWithImpl<_$TeamChallengeImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TeamChallengeImplToJson(
      this,
    );
  }
}

abstract class _TeamChallenge implements TeamChallenge {
  const factory _TeamChallenge(
      {required final String id,
      required final String teamId,
      required final String title,
      required final String description,
      required final ChallengeType type,
      required final DateTime startDate,
      required final DateTime endDate,
      @JsonKey(
          name: 'goal',
          fromJson: _challengeGoalFromJson,
          toJson: _challengeGoalToJson)
      required final ChallengeGoal goal,
      required final List<ChallengeReward> rewards,
      required final List<String> participantIds,
      required final Map<String, ChallengeProgress> progress,
      required final ChallengeStatus status,
      required final String createdBy,
      required final DateTime createdAt}) = _$TeamChallengeImpl;

  factory _TeamChallenge.fromJson(Map<String, dynamic> json) =
      _$TeamChallengeImpl.fromJson;

  @override
  String get id;
  @override
  String get teamId;
  @override
  String get title;
  @override
  String get description;
  @override
  ChallengeType get type;
  @override
  DateTime get startDate;
  @override
  DateTime get endDate;
  @override
  @JsonKey(
      name: 'goal',
      fromJson: _challengeGoalFromJson,
      toJson: _challengeGoalToJson)
  ChallengeGoal get goal;
  @override
  List<ChallengeReward> get rewards;
  @override
  List<String> get participantIds;
  @override
  Map<String, ChallengeProgress> get progress;
  @override
  ChallengeStatus get status;
  @override
  String get createdBy;
  @override
  DateTime get createdAt;
  @override
  @JsonKey(ignore: true)
  _$$TeamChallengeImplCopyWith<_$TeamChallengeImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$ChallengeGoal {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(int targetDays, bool allowGraceDays) streak,
    required TResult Function(int targetXP, List<String> allowedPillars) xp,
    required TResult Function(int targetCount, List<String> allowedCategories)
        activity,
    required TResult Function(String pillar, int targetXP) pillar,
    required TResult Function(int targetDays, int minActivitiesPerDay)
        consistency,
    required TResult Function(String metric, int targetValue, String unit)
        custom,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(int targetDays, bool allowGraceDays)? streak,
    TResult? Function(int targetXP, List<String> allowedPillars)? xp,
    TResult? Function(int targetCount, List<String> allowedCategories)?
        activity,
    TResult? Function(String pillar, int targetXP)? pillar,
    TResult? Function(int targetDays, int minActivitiesPerDay)? consistency,
    TResult? Function(String metric, int targetValue, String unit)? custom,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(int targetDays, bool allowGraceDays)? streak,
    TResult Function(int targetXP, List<String> allowedPillars)? xp,
    TResult Function(int targetCount, List<String> allowedCategories)? activity,
    TResult Function(String pillar, int targetXP)? pillar,
    TResult Function(int targetDays, int minActivitiesPerDay)? consistency,
    TResult Function(String metric, int targetValue, String unit)? custom,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_StreakGoal value) streak,
    required TResult Function(_XPGoal value) xp,
    required TResult Function(_ActivityGoal value) activity,
    required TResult Function(_PillarGoal value) pillar,
    required TResult Function(_ConsistencyGoal value) consistency,
    required TResult Function(_CustomGoal value) custom,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_StreakGoal value)? streak,
    TResult? Function(_XPGoal value)? xp,
    TResult? Function(_ActivityGoal value)? activity,
    TResult? Function(_PillarGoal value)? pillar,
    TResult? Function(_ConsistencyGoal value)? consistency,
    TResult? Function(_CustomGoal value)? custom,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_StreakGoal value)? streak,
    TResult Function(_XPGoal value)? xp,
    TResult Function(_ActivityGoal value)? activity,
    TResult Function(_PillarGoal value)? pillar,
    TResult Function(_ConsistencyGoal value)? consistency,
    TResult Function(_CustomGoal value)? custom,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ChallengeGoalCopyWith<$Res> {
  factory $ChallengeGoalCopyWith(
          ChallengeGoal value, $Res Function(ChallengeGoal) then) =
      _$ChallengeGoalCopyWithImpl<$Res, ChallengeGoal>;
}

/// @nodoc
class _$ChallengeGoalCopyWithImpl<$Res, $Val extends ChallengeGoal>
    implements $ChallengeGoalCopyWith<$Res> {
  _$ChallengeGoalCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;
}

/// @nodoc
abstract class _$$StreakGoalImplCopyWith<$Res> {
  factory _$$StreakGoalImplCopyWith(
          _$StreakGoalImpl value, $Res Function(_$StreakGoalImpl) then) =
      __$$StreakGoalImplCopyWithImpl<$Res>;
  @useResult
  $Res call({int targetDays, bool allowGraceDays});
}

/// @nodoc
class __$$StreakGoalImplCopyWithImpl<$Res>
    extends _$ChallengeGoalCopyWithImpl<$Res, _$StreakGoalImpl>
    implements _$$StreakGoalImplCopyWith<$Res> {
  __$$StreakGoalImplCopyWithImpl(
      _$StreakGoalImpl _value, $Res Function(_$StreakGoalImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? targetDays = null,
    Object? allowGraceDays = null,
  }) {
    return _then(_$StreakGoalImpl(
      targetDays: null == targetDays
          ? _value.targetDays
          : targetDays // ignore: cast_nullable_to_non_nullable
              as int,
      allowGraceDays: null == allowGraceDays
          ? _value.allowGraceDays
          : allowGraceDays // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$StreakGoalImpl implements _StreakGoal {
  const _$StreakGoalImpl(
      {required this.targetDays, required this.allowGraceDays});

  @override
  final int targetDays;
  @override
  final bool allowGraceDays;

  @override
  String toString() {
    return 'ChallengeGoal.streak(targetDays: $targetDays, allowGraceDays: $allowGraceDays)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StreakGoalImpl &&
            (identical(other.targetDays, targetDays) ||
                other.targetDays == targetDays) &&
            (identical(other.allowGraceDays, allowGraceDays) ||
                other.allowGraceDays == allowGraceDays));
  }

  @override
  int get hashCode => Object.hash(runtimeType, targetDays, allowGraceDays);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$StreakGoalImplCopyWith<_$StreakGoalImpl> get copyWith =>
      __$$StreakGoalImplCopyWithImpl<_$StreakGoalImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(int targetDays, bool allowGraceDays) streak,
    required TResult Function(int targetXP, List<String> allowedPillars) xp,
    required TResult Function(int targetCount, List<String> allowedCategories)
        activity,
    required TResult Function(String pillar, int targetXP) pillar,
    required TResult Function(int targetDays, int minActivitiesPerDay)
        consistency,
    required TResult Function(String metric, int targetValue, String unit)
        custom,
  }) {
    return streak(targetDays, allowGraceDays);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(int targetDays, bool allowGraceDays)? streak,
    TResult? Function(int targetXP, List<String> allowedPillars)? xp,
    TResult? Function(int targetCount, List<String> allowedCategories)?
        activity,
    TResult? Function(String pillar, int targetXP)? pillar,
    TResult? Function(int targetDays, int minActivitiesPerDay)? consistency,
    TResult? Function(String metric, int targetValue, String unit)? custom,
  }) {
    return streak?.call(targetDays, allowGraceDays);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(int targetDays, bool allowGraceDays)? streak,
    TResult Function(int targetXP, List<String> allowedPillars)? xp,
    TResult Function(int targetCount, List<String> allowedCategories)? activity,
    TResult Function(String pillar, int targetXP)? pillar,
    TResult Function(int targetDays, int minActivitiesPerDay)? consistency,
    TResult Function(String metric, int targetValue, String unit)? custom,
    required TResult orElse(),
  }) {
    if (streak != null) {
      return streak(targetDays, allowGraceDays);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_StreakGoal value) streak,
    required TResult Function(_XPGoal value) xp,
    required TResult Function(_ActivityGoal value) activity,
    required TResult Function(_PillarGoal value) pillar,
    required TResult Function(_ConsistencyGoal value) consistency,
    required TResult Function(_CustomGoal value) custom,
  }) {
    return streak(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_StreakGoal value)? streak,
    TResult? Function(_XPGoal value)? xp,
    TResult? Function(_ActivityGoal value)? activity,
    TResult? Function(_PillarGoal value)? pillar,
    TResult? Function(_ConsistencyGoal value)? consistency,
    TResult? Function(_CustomGoal value)? custom,
  }) {
    return streak?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_StreakGoal value)? streak,
    TResult Function(_XPGoal value)? xp,
    TResult Function(_ActivityGoal value)? activity,
    TResult Function(_PillarGoal value)? pillar,
    TResult Function(_ConsistencyGoal value)? consistency,
    TResult Function(_CustomGoal value)? custom,
    required TResult orElse(),
  }) {
    if (streak != null) {
      return streak(this);
    }
    return orElse();
  }
}

abstract class _StreakGoal implements ChallengeGoal {
  const factory _StreakGoal(
      {required final int targetDays,
      required final bool allowGraceDays}) = _$StreakGoalImpl;

  int get targetDays;
  bool get allowGraceDays;
  @JsonKey(ignore: true)
  _$$StreakGoalImplCopyWith<_$StreakGoalImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$XPGoalImplCopyWith<$Res> {
  factory _$$XPGoalImplCopyWith(
          _$XPGoalImpl value, $Res Function(_$XPGoalImpl) then) =
      __$$XPGoalImplCopyWithImpl<$Res>;
  @useResult
  $Res call({int targetXP, List<String> allowedPillars});
}

/// @nodoc
class __$$XPGoalImplCopyWithImpl<$Res>
    extends _$ChallengeGoalCopyWithImpl<$Res, _$XPGoalImpl>
    implements _$$XPGoalImplCopyWith<$Res> {
  __$$XPGoalImplCopyWithImpl(
      _$XPGoalImpl _value, $Res Function(_$XPGoalImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? targetXP = null,
    Object? allowedPillars = null,
  }) {
    return _then(_$XPGoalImpl(
      targetXP: null == targetXP
          ? _value.targetXP
          : targetXP // ignore: cast_nullable_to_non_nullable
              as int,
      allowedPillars: null == allowedPillars
          ? _value._allowedPillars
          : allowedPillars // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ));
  }
}

/// @nodoc

class _$XPGoalImpl implements _XPGoal {
  const _$XPGoalImpl(
      {required this.targetXP, required final List<String> allowedPillars})
      : _allowedPillars = allowedPillars;

  @override
  final int targetXP;
  final List<String> _allowedPillars;
  @override
  List<String> get allowedPillars {
    if (_allowedPillars is EqualUnmodifiableListView) return _allowedPillars;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_allowedPillars);
  }

  @override
  String toString() {
    return 'ChallengeGoal.xp(targetXP: $targetXP, allowedPillars: $allowedPillars)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$XPGoalImpl &&
            (identical(other.targetXP, targetXP) ||
                other.targetXP == targetXP) &&
            const DeepCollectionEquality()
                .equals(other._allowedPillars, _allowedPillars));
  }

  @override
  int get hashCode => Object.hash(runtimeType, targetXP,
      const DeepCollectionEquality().hash(_allowedPillars));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$XPGoalImplCopyWith<_$XPGoalImpl> get copyWith =>
      __$$XPGoalImplCopyWithImpl<_$XPGoalImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(int targetDays, bool allowGraceDays) streak,
    required TResult Function(int targetXP, List<String> allowedPillars) xp,
    required TResult Function(int targetCount, List<String> allowedCategories)
        activity,
    required TResult Function(String pillar, int targetXP) pillar,
    required TResult Function(int targetDays, int minActivitiesPerDay)
        consistency,
    required TResult Function(String metric, int targetValue, String unit)
        custom,
  }) {
    return xp(targetXP, allowedPillars);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(int targetDays, bool allowGraceDays)? streak,
    TResult? Function(int targetXP, List<String> allowedPillars)? xp,
    TResult? Function(int targetCount, List<String> allowedCategories)?
        activity,
    TResult? Function(String pillar, int targetXP)? pillar,
    TResult? Function(int targetDays, int minActivitiesPerDay)? consistency,
    TResult? Function(String metric, int targetValue, String unit)? custom,
  }) {
    return xp?.call(targetXP, allowedPillars);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(int targetDays, bool allowGraceDays)? streak,
    TResult Function(int targetXP, List<String> allowedPillars)? xp,
    TResult Function(int targetCount, List<String> allowedCategories)? activity,
    TResult Function(String pillar, int targetXP)? pillar,
    TResult Function(int targetDays, int minActivitiesPerDay)? consistency,
    TResult Function(String metric, int targetValue, String unit)? custom,
    required TResult orElse(),
  }) {
    if (xp != null) {
      return xp(targetXP, allowedPillars);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_StreakGoal value) streak,
    required TResult Function(_XPGoal value) xp,
    required TResult Function(_ActivityGoal value) activity,
    required TResult Function(_PillarGoal value) pillar,
    required TResult Function(_ConsistencyGoal value) consistency,
    required TResult Function(_CustomGoal value) custom,
  }) {
    return xp(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_StreakGoal value)? streak,
    TResult? Function(_XPGoal value)? xp,
    TResult? Function(_ActivityGoal value)? activity,
    TResult? Function(_PillarGoal value)? pillar,
    TResult? Function(_ConsistencyGoal value)? consistency,
    TResult? Function(_CustomGoal value)? custom,
  }) {
    return xp?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_StreakGoal value)? streak,
    TResult Function(_XPGoal value)? xp,
    TResult Function(_ActivityGoal value)? activity,
    TResult Function(_PillarGoal value)? pillar,
    TResult Function(_ConsistencyGoal value)? consistency,
    TResult Function(_CustomGoal value)? custom,
    required TResult orElse(),
  }) {
    if (xp != null) {
      return xp(this);
    }
    return orElse();
  }
}

abstract class _XPGoal implements ChallengeGoal {
  const factory _XPGoal(
      {required final int targetXP,
      required final List<String> allowedPillars}) = _$XPGoalImpl;

  int get targetXP;
  List<String> get allowedPillars;
  @JsonKey(ignore: true)
  _$$XPGoalImplCopyWith<_$XPGoalImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$ActivityGoalImplCopyWith<$Res> {
  factory _$$ActivityGoalImplCopyWith(
          _$ActivityGoalImpl value, $Res Function(_$ActivityGoalImpl) then) =
      __$$ActivityGoalImplCopyWithImpl<$Res>;
  @useResult
  $Res call({int targetCount, List<String> allowedCategories});
}

/// @nodoc
class __$$ActivityGoalImplCopyWithImpl<$Res>
    extends _$ChallengeGoalCopyWithImpl<$Res, _$ActivityGoalImpl>
    implements _$$ActivityGoalImplCopyWith<$Res> {
  __$$ActivityGoalImplCopyWithImpl(
      _$ActivityGoalImpl _value, $Res Function(_$ActivityGoalImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? targetCount = null,
    Object? allowedCategories = null,
  }) {
    return _then(_$ActivityGoalImpl(
      targetCount: null == targetCount
          ? _value.targetCount
          : targetCount // ignore: cast_nullable_to_non_nullable
              as int,
      allowedCategories: null == allowedCategories
          ? _value._allowedCategories
          : allowedCategories // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ));
  }
}

/// @nodoc

class _$ActivityGoalImpl implements _ActivityGoal {
  const _$ActivityGoalImpl(
      {required this.targetCount,
      required final List<String> allowedCategories})
      : _allowedCategories = allowedCategories;

  @override
  final int targetCount;
  final List<String> _allowedCategories;
  @override
  List<String> get allowedCategories {
    if (_allowedCategories is EqualUnmodifiableListView)
      return _allowedCategories;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_allowedCategories);
  }

  @override
  String toString() {
    return 'ChallengeGoal.activity(targetCount: $targetCount, allowedCategories: $allowedCategories)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ActivityGoalImpl &&
            (identical(other.targetCount, targetCount) ||
                other.targetCount == targetCount) &&
            const DeepCollectionEquality()
                .equals(other._allowedCategories, _allowedCategories));
  }

  @override
  int get hashCode => Object.hash(runtimeType, targetCount,
      const DeepCollectionEquality().hash(_allowedCategories));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ActivityGoalImplCopyWith<_$ActivityGoalImpl> get copyWith =>
      __$$ActivityGoalImplCopyWithImpl<_$ActivityGoalImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(int targetDays, bool allowGraceDays) streak,
    required TResult Function(int targetXP, List<String> allowedPillars) xp,
    required TResult Function(int targetCount, List<String> allowedCategories)
        activity,
    required TResult Function(String pillar, int targetXP) pillar,
    required TResult Function(int targetDays, int minActivitiesPerDay)
        consistency,
    required TResult Function(String metric, int targetValue, String unit)
        custom,
  }) {
    return activity(targetCount, allowedCategories);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(int targetDays, bool allowGraceDays)? streak,
    TResult? Function(int targetXP, List<String> allowedPillars)? xp,
    TResult? Function(int targetCount, List<String> allowedCategories)?
        activity,
    TResult? Function(String pillar, int targetXP)? pillar,
    TResult? Function(int targetDays, int minActivitiesPerDay)? consistency,
    TResult? Function(String metric, int targetValue, String unit)? custom,
  }) {
    return activity?.call(targetCount, allowedCategories);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(int targetDays, bool allowGraceDays)? streak,
    TResult Function(int targetXP, List<String> allowedPillars)? xp,
    TResult Function(int targetCount, List<String> allowedCategories)? activity,
    TResult Function(String pillar, int targetXP)? pillar,
    TResult Function(int targetDays, int minActivitiesPerDay)? consistency,
    TResult Function(String metric, int targetValue, String unit)? custom,
    required TResult orElse(),
  }) {
    if (activity != null) {
      return activity(targetCount, allowedCategories);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_StreakGoal value) streak,
    required TResult Function(_XPGoal value) xp,
    required TResult Function(_ActivityGoal value) activity,
    required TResult Function(_PillarGoal value) pillar,
    required TResult Function(_ConsistencyGoal value) consistency,
    required TResult Function(_CustomGoal value) custom,
  }) {
    return activity(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_StreakGoal value)? streak,
    TResult? Function(_XPGoal value)? xp,
    TResult? Function(_ActivityGoal value)? activity,
    TResult? Function(_PillarGoal value)? pillar,
    TResult? Function(_ConsistencyGoal value)? consistency,
    TResult? Function(_CustomGoal value)? custom,
  }) {
    return activity?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_StreakGoal value)? streak,
    TResult Function(_XPGoal value)? xp,
    TResult Function(_ActivityGoal value)? activity,
    TResult Function(_PillarGoal value)? pillar,
    TResult Function(_ConsistencyGoal value)? consistency,
    TResult Function(_CustomGoal value)? custom,
    required TResult orElse(),
  }) {
    if (activity != null) {
      return activity(this);
    }
    return orElse();
  }
}

abstract class _ActivityGoal implements ChallengeGoal {
  const factory _ActivityGoal(
      {required final int targetCount,
      required final List<String> allowedCategories}) = _$ActivityGoalImpl;

  int get targetCount;
  List<String> get allowedCategories;
  @JsonKey(ignore: true)
  _$$ActivityGoalImplCopyWith<_$ActivityGoalImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$PillarGoalImplCopyWith<$Res> {
  factory _$$PillarGoalImplCopyWith(
          _$PillarGoalImpl value, $Res Function(_$PillarGoalImpl) then) =
      __$$PillarGoalImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String pillar, int targetXP});
}

/// @nodoc
class __$$PillarGoalImplCopyWithImpl<$Res>
    extends _$ChallengeGoalCopyWithImpl<$Res, _$PillarGoalImpl>
    implements _$$PillarGoalImplCopyWith<$Res> {
  __$$PillarGoalImplCopyWithImpl(
      _$PillarGoalImpl _value, $Res Function(_$PillarGoalImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? pillar = null,
    Object? targetXP = null,
  }) {
    return _then(_$PillarGoalImpl(
      pillar: null == pillar
          ? _value.pillar
          : pillar // ignore: cast_nullable_to_non_nullable
              as String,
      targetXP: null == targetXP
          ? _value.targetXP
          : targetXP // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc

class _$PillarGoalImpl implements _PillarGoal {
  const _$PillarGoalImpl({required this.pillar, required this.targetXP});

  @override
  final String pillar;
  @override
  final int targetXP;

  @override
  String toString() {
    return 'ChallengeGoal.pillar(pillar: $pillar, targetXP: $targetXP)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PillarGoalImpl &&
            (identical(other.pillar, pillar) || other.pillar == pillar) &&
            (identical(other.targetXP, targetXP) ||
                other.targetXP == targetXP));
  }

  @override
  int get hashCode => Object.hash(runtimeType, pillar, targetXP);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$PillarGoalImplCopyWith<_$PillarGoalImpl> get copyWith =>
      __$$PillarGoalImplCopyWithImpl<_$PillarGoalImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(int targetDays, bool allowGraceDays) streak,
    required TResult Function(int targetXP, List<String> allowedPillars) xp,
    required TResult Function(int targetCount, List<String> allowedCategories)
        activity,
    required TResult Function(String pillar, int targetXP) pillar,
    required TResult Function(int targetDays, int minActivitiesPerDay)
        consistency,
    required TResult Function(String metric, int targetValue, String unit)
        custom,
  }) {
    return pillar(this.pillar, targetXP);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(int targetDays, bool allowGraceDays)? streak,
    TResult? Function(int targetXP, List<String> allowedPillars)? xp,
    TResult? Function(int targetCount, List<String> allowedCategories)?
        activity,
    TResult? Function(String pillar, int targetXP)? pillar,
    TResult? Function(int targetDays, int minActivitiesPerDay)? consistency,
    TResult? Function(String metric, int targetValue, String unit)? custom,
  }) {
    return pillar?.call(this.pillar, targetXP);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(int targetDays, bool allowGraceDays)? streak,
    TResult Function(int targetXP, List<String> allowedPillars)? xp,
    TResult Function(int targetCount, List<String> allowedCategories)? activity,
    TResult Function(String pillar, int targetXP)? pillar,
    TResult Function(int targetDays, int minActivitiesPerDay)? consistency,
    TResult Function(String metric, int targetValue, String unit)? custom,
    required TResult orElse(),
  }) {
    if (pillar != null) {
      return pillar(this.pillar, targetXP);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_StreakGoal value) streak,
    required TResult Function(_XPGoal value) xp,
    required TResult Function(_ActivityGoal value) activity,
    required TResult Function(_PillarGoal value) pillar,
    required TResult Function(_ConsistencyGoal value) consistency,
    required TResult Function(_CustomGoal value) custom,
  }) {
    return pillar(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_StreakGoal value)? streak,
    TResult? Function(_XPGoal value)? xp,
    TResult? Function(_ActivityGoal value)? activity,
    TResult? Function(_PillarGoal value)? pillar,
    TResult? Function(_ConsistencyGoal value)? consistency,
    TResult? Function(_CustomGoal value)? custom,
  }) {
    return pillar?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_StreakGoal value)? streak,
    TResult Function(_XPGoal value)? xp,
    TResult Function(_ActivityGoal value)? activity,
    TResult Function(_PillarGoal value)? pillar,
    TResult Function(_ConsistencyGoal value)? consistency,
    TResult Function(_CustomGoal value)? custom,
    required TResult orElse(),
  }) {
    if (pillar != null) {
      return pillar(this);
    }
    return orElse();
  }
}

abstract class _PillarGoal implements ChallengeGoal {
  const factory _PillarGoal(
      {required final String pillar,
      required final int targetXP}) = _$PillarGoalImpl;

  String get pillar;
  int get targetXP;
  @JsonKey(ignore: true)
  _$$PillarGoalImplCopyWith<_$PillarGoalImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$ConsistencyGoalImplCopyWith<$Res> {
  factory _$$ConsistencyGoalImplCopyWith(_$ConsistencyGoalImpl value,
          $Res Function(_$ConsistencyGoalImpl) then) =
      __$$ConsistencyGoalImplCopyWithImpl<$Res>;
  @useResult
  $Res call({int targetDays, int minActivitiesPerDay});
}

/// @nodoc
class __$$ConsistencyGoalImplCopyWithImpl<$Res>
    extends _$ChallengeGoalCopyWithImpl<$Res, _$ConsistencyGoalImpl>
    implements _$$ConsistencyGoalImplCopyWith<$Res> {
  __$$ConsistencyGoalImplCopyWithImpl(
      _$ConsistencyGoalImpl _value, $Res Function(_$ConsistencyGoalImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? targetDays = null,
    Object? minActivitiesPerDay = null,
  }) {
    return _then(_$ConsistencyGoalImpl(
      targetDays: null == targetDays
          ? _value.targetDays
          : targetDays // ignore: cast_nullable_to_non_nullable
              as int,
      minActivitiesPerDay: null == minActivitiesPerDay
          ? _value.minActivitiesPerDay
          : minActivitiesPerDay // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc

class _$ConsistencyGoalImpl implements _ConsistencyGoal {
  const _$ConsistencyGoalImpl(
      {required this.targetDays, required this.minActivitiesPerDay});

  @override
  final int targetDays;
  @override
  final int minActivitiesPerDay;

  @override
  String toString() {
    return 'ChallengeGoal.consistency(targetDays: $targetDays, minActivitiesPerDay: $minActivitiesPerDay)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ConsistencyGoalImpl &&
            (identical(other.targetDays, targetDays) ||
                other.targetDays == targetDays) &&
            (identical(other.minActivitiesPerDay, minActivitiesPerDay) ||
                other.minActivitiesPerDay == minActivitiesPerDay));
  }

  @override
  int get hashCode => Object.hash(runtimeType, targetDays, minActivitiesPerDay);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ConsistencyGoalImplCopyWith<_$ConsistencyGoalImpl> get copyWith =>
      __$$ConsistencyGoalImplCopyWithImpl<_$ConsistencyGoalImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(int targetDays, bool allowGraceDays) streak,
    required TResult Function(int targetXP, List<String> allowedPillars) xp,
    required TResult Function(int targetCount, List<String> allowedCategories)
        activity,
    required TResult Function(String pillar, int targetXP) pillar,
    required TResult Function(int targetDays, int minActivitiesPerDay)
        consistency,
    required TResult Function(String metric, int targetValue, String unit)
        custom,
  }) {
    return consistency(targetDays, minActivitiesPerDay);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(int targetDays, bool allowGraceDays)? streak,
    TResult? Function(int targetXP, List<String> allowedPillars)? xp,
    TResult? Function(int targetCount, List<String> allowedCategories)?
        activity,
    TResult? Function(String pillar, int targetXP)? pillar,
    TResult? Function(int targetDays, int minActivitiesPerDay)? consistency,
    TResult? Function(String metric, int targetValue, String unit)? custom,
  }) {
    return consistency?.call(targetDays, minActivitiesPerDay);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(int targetDays, bool allowGraceDays)? streak,
    TResult Function(int targetXP, List<String> allowedPillars)? xp,
    TResult Function(int targetCount, List<String> allowedCategories)? activity,
    TResult Function(String pillar, int targetXP)? pillar,
    TResult Function(int targetDays, int minActivitiesPerDay)? consistency,
    TResult Function(String metric, int targetValue, String unit)? custom,
    required TResult orElse(),
  }) {
    if (consistency != null) {
      return consistency(targetDays, minActivitiesPerDay);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_StreakGoal value) streak,
    required TResult Function(_XPGoal value) xp,
    required TResult Function(_ActivityGoal value) activity,
    required TResult Function(_PillarGoal value) pillar,
    required TResult Function(_ConsistencyGoal value) consistency,
    required TResult Function(_CustomGoal value) custom,
  }) {
    return consistency(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_StreakGoal value)? streak,
    TResult? Function(_XPGoal value)? xp,
    TResult? Function(_ActivityGoal value)? activity,
    TResult? Function(_PillarGoal value)? pillar,
    TResult? Function(_ConsistencyGoal value)? consistency,
    TResult? Function(_CustomGoal value)? custom,
  }) {
    return consistency?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_StreakGoal value)? streak,
    TResult Function(_XPGoal value)? xp,
    TResult Function(_ActivityGoal value)? activity,
    TResult Function(_PillarGoal value)? pillar,
    TResult Function(_ConsistencyGoal value)? consistency,
    TResult Function(_CustomGoal value)? custom,
    required TResult orElse(),
  }) {
    if (consistency != null) {
      return consistency(this);
    }
    return orElse();
  }
}

abstract class _ConsistencyGoal implements ChallengeGoal {
  const factory _ConsistencyGoal(
      {required final int targetDays,
      required final int minActivitiesPerDay}) = _$ConsistencyGoalImpl;

  int get targetDays;
  int get minActivitiesPerDay;
  @JsonKey(ignore: true)
  _$$ConsistencyGoalImplCopyWith<_$ConsistencyGoalImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$CustomGoalImplCopyWith<$Res> {
  factory _$$CustomGoalImplCopyWith(
          _$CustomGoalImpl value, $Res Function(_$CustomGoalImpl) then) =
      __$$CustomGoalImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String metric, int targetValue, String unit});
}

/// @nodoc
class __$$CustomGoalImplCopyWithImpl<$Res>
    extends _$ChallengeGoalCopyWithImpl<$Res, _$CustomGoalImpl>
    implements _$$CustomGoalImplCopyWith<$Res> {
  __$$CustomGoalImplCopyWithImpl(
      _$CustomGoalImpl _value, $Res Function(_$CustomGoalImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? metric = null,
    Object? targetValue = null,
    Object? unit = null,
  }) {
    return _then(_$CustomGoalImpl(
      metric: null == metric
          ? _value.metric
          : metric // ignore: cast_nullable_to_non_nullable
              as String,
      targetValue: null == targetValue
          ? _value.targetValue
          : targetValue // ignore: cast_nullable_to_non_nullable
              as int,
      unit: null == unit
          ? _value.unit
          : unit // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$CustomGoalImpl implements _CustomGoal {
  const _$CustomGoalImpl(
      {required this.metric, required this.targetValue, required this.unit});

  @override
  final String metric;
  @override
  final int targetValue;
  @override
  final String unit;

  @override
  String toString() {
    return 'ChallengeGoal.custom(metric: $metric, targetValue: $targetValue, unit: $unit)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CustomGoalImpl &&
            (identical(other.metric, metric) || other.metric == metric) &&
            (identical(other.targetValue, targetValue) ||
                other.targetValue == targetValue) &&
            (identical(other.unit, unit) || other.unit == unit));
  }

  @override
  int get hashCode => Object.hash(runtimeType, metric, targetValue, unit);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$CustomGoalImplCopyWith<_$CustomGoalImpl> get copyWith =>
      __$$CustomGoalImplCopyWithImpl<_$CustomGoalImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(int targetDays, bool allowGraceDays) streak,
    required TResult Function(int targetXP, List<String> allowedPillars) xp,
    required TResult Function(int targetCount, List<String> allowedCategories)
        activity,
    required TResult Function(String pillar, int targetXP) pillar,
    required TResult Function(int targetDays, int minActivitiesPerDay)
        consistency,
    required TResult Function(String metric, int targetValue, String unit)
        custom,
  }) {
    return custom(metric, targetValue, unit);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(int targetDays, bool allowGraceDays)? streak,
    TResult? Function(int targetXP, List<String> allowedPillars)? xp,
    TResult? Function(int targetCount, List<String> allowedCategories)?
        activity,
    TResult? Function(String pillar, int targetXP)? pillar,
    TResult? Function(int targetDays, int minActivitiesPerDay)? consistency,
    TResult? Function(String metric, int targetValue, String unit)? custom,
  }) {
    return custom?.call(metric, targetValue, unit);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(int targetDays, bool allowGraceDays)? streak,
    TResult Function(int targetXP, List<String> allowedPillars)? xp,
    TResult Function(int targetCount, List<String> allowedCategories)? activity,
    TResult Function(String pillar, int targetXP)? pillar,
    TResult Function(int targetDays, int minActivitiesPerDay)? consistency,
    TResult Function(String metric, int targetValue, String unit)? custom,
    required TResult orElse(),
  }) {
    if (custom != null) {
      return custom(metric, targetValue, unit);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_StreakGoal value) streak,
    required TResult Function(_XPGoal value) xp,
    required TResult Function(_ActivityGoal value) activity,
    required TResult Function(_PillarGoal value) pillar,
    required TResult Function(_ConsistencyGoal value) consistency,
    required TResult Function(_CustomGoal value) custom,
  }) {
    return custom(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_StreakGoal value)? streak,
    TResult? Function(_XPGoal value)? xp,
    TResult? Function(_ActivityGoal value)? activity,
    TResult? Function(_PillarGoal value)? pillar,
    TResult? Function(_ConsistencyGoal value)? consistency,
    TResult? Function(_CustomGoal value)? custom,
  }) {
    return custom?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_StreakGoal value)? streak,
    TResult Function(_XPGoal value)? xp,
    TResult Function(_ActivityGoal value)? activity,
    TResult Function(_PillarGoal value)? pillar,
    TResult Function(_ConsistencyGoal value)? consistency,
    TResult Function(_CustomGoal value)? custom,
    required TResult orElse(),
  }) {
    if (custom != null) {
      return custom(this);
    }
    return orElse();
  }
}

abstract class _CustomGoal implements ChallengeGoal {
  const factory _CustomGoal(
      {required final String metric,
      required final int targetValue,
      required final String unit}) = _$CustomGoalImpl;

  String get metric;
  int get targetValue;
  String get unit;
  @JsonKey(ignore: true)
  _$$CustomGoalImplCopyWith<_$CustomGoalImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ChallengeReward _$ChallengeRewardFromJson(Map<String, dynamic> json) {
  return _ChallengeReward.fromJson(json);
}

/// @nodoc
mixin _$ChallengeReward {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  RewardType get type => throw _privateConstructorUsedError;
  int get amount => throw _privateConstructorUsedError;
  int get rankRequired => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ChallengeRewardCopyWith<ChallengeReward> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ChallengeRewardCopyWith<$Res> {
  factory $ChallengeRewardCopyWith(
          ChallengeReward value, $Res Function(ChallengeReward) then) =
      _$ChallengeRewardCopyWithImpl<$Res, ChallengeReward>;
  @useResult
  $Res call(
      {String id,
      String name,
      String description,
      RewardType type,
      int amount,
      int rankRequired});
}

/// @nodoc
class _$ChallengeRewardCopyWithImpl<$Res, $Val extends ChallengeReward>
    implements $ChallengeRewardCopyWith<$Res> {
  _$ChallengeRewardCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? description = null,
    Object? type = null,
    Object? amount = null,
    Object? rankRequired = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as RewardType,
      amount: null == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as int,
      rankRequired: null == rankRequired
          ? _value.rankRequired
          : rankRequired // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ChallengeRewardImplCopyWith<$Res>
    implements $ChallengeRewardCopyWith<$Res> {
  factory _$$ChallengeRewardImplCopyWith(_$ChallengeRewardImpl value,
          $Res Function(_$ChallengeRewardImpl) then) =
      __$$ChallengeRewardImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String name,
      String description,
      RewardType type,
      int amount,
      int rankRequired});
}

/// @nodoc
class __$$ChallengeRewardImplCopyWithImpl<$Res>
    extends _$ChallengeRewardCopyWithImpl<$Res, _$ChallengeRewardImpl>
    implements _$$ChallengeRewardImplCopyWith<$Res> {
  __$$ChallengeRewardImplCopyWithImpl(
      _$ChallengeRewardImpl _value, $Res Function(_$ChallengeRewardImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? description = null,
    Object? type = null,
    Object? amount = null,
    Object? rankRequired = null,
  }) {
    return _then(_$ChallengeRewardImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as RewardType,
      amount: null == amount
          ? _value.amount
          : amount // ignore: cast_nullable_to_non_nullable
              as int,
      rankRequired: null == rankRequired
          ? _value.rankRequired
          : rankRequired // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ChallengeRewardImpl implements _ChallengeReward {
  const _$ChallengeRewardImpl(
      {required this.id,
      required this.name,
      required this.description,
      required this.type,
      required this.amount,
      required this.rankRequired});

  factory _$ChallengeRewardImpl.fromJson(Map<String, dynamic> json) =>
      _$$ChallengeRewardImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final String description;
  @override
  final RewardType type;
  @override
  final int amount;
  @override
  final int rankRequired;

  @override
  String toString() {
    return 'ChallengeReward(id: $id, name: $name, description: $description, type: $type, amount: $amount, rankRequired: $rankRequired)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ChallengeRewardImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.amount, amount) || other.amount == amount) &&
            (identical(other.rankRequired, rankRequired) ||
                other.rankRequired == rankRequired));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, id, name, description, type, amount, rankRequired);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ChallengeRewardImplCopyWith<_$ChallengeRewardImpl> get copyWith =>
      __$$ChallengeRewardImplCopyWithImpl<_$ChallengeRewardImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ChallengeRewardImplToJson(
      this,
    );
  }
}

abstract class _ChallengeReward implements ChallengeReward {
  const factory _ChallengeReward(
      {required final String id,
      required final String name,
      required final String description,
      required final RewardType type,
      required final int amount,
      required final int rankRequired}) = _$ChallengeRewardImpl;

  factory _ChallengeReward.fromJson(Map<String, dynamic> json) =
      _$ChallengeRewardImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  String get description;
  @override
  RewardType get type;
  @override
  int get amount;
  @override
  int get rankRequired;
  @override
  @JsonKey(ignore: true)
  _$$ChallengeRewardImplCopyWith<_$ChallengeRewardImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ChallengeProgress _$ChallengeProgressFromJson(Map<String, dynamic> json) {
  return _ChallengeProgress.fromJson(json);
}

/// @nodoc
mixin _$ChallengeProgress {
  double get currentValue => throw _privateConstructorUsedError;
  double get targetValue => throw _privateConstructorUsedError;
  double get percentage => throw _privateConstructorUsedError;
  List<DateTime> get completionDates => throw _privateConstructorUsedError;
  Map<String, dynamic> get metadata => throw _privateConstructorUsedError;
  ChallengeProgressStatus get status => throw _privateConstructorUsedError;
  DateTime get startedAt => throw _privateConstructorUsedError;
  DateTime? get completedAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ChallengeProgressCopyWith<ChallengeProgress> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ChallengeProgressCopyWith<$Res> {
  factory $ChallengeProgressCopyWith(
          ChallengeProgress value, $Res Function(ChallengeProgress) then) =
      _$ChallengeProgressCopyWithImpl<$Res, ChallengeProgress>;
  @useResult
  $Res call(
      {double currentValue,
      double targetValue,
      double percentage,
      List<DateTime> completionDates,
      Map<String, dynamic> metadata,
      ChallengeProgressStatus status,
      DateTime startedAt,
      DateTime? completedAt});
}

/// @nodoc
class _$ChallengeProgressCopyWithImpl<$Res, $Val extends ChallengeProgress>
    implements $ChallengeProgressCopyWith<$Res> {
  _$ChallengeProgressCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? currentValue = null,
    Object? targetValue = null,
    Object? percentage = null,
    Object? completionDates = null,
    Object? metadata = null,
    Object? status = null,
    Object? startedAt = null,
    Object? completedAt = freezed,
  }) {
    return _then(_value.copyWith(
      currentValue: null == currentValue
          ? _value.currentValue
          : currentValue // ignore: cast_nullable_to_non_nullable
              as double,
      targetValue: null == targetValue
          ? _value.targetValue
          : targetValue // ignore: cast_nullable_to_non_nullable
              as double,
      percentage: null == percentage
          ? _value.percentage
          : percentage // ignore: cast_nullable_to_non_nullable
              as double,
      completionDates: null == completionDates
          ? _value.completionDates
          : completionDates // ignore: cast_nullable_to_non_nullable
              as List<DateTime>,
      metadata: null == metadata
          ? _value.metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as ChallengeProgressStatus,
      startedAt: null == startedAt
          ? _value.startedAt
          : startedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      completedAt: freezed == completedAt
          ? _value.completedAt
          : completedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ChallengeProgressImplCopyWith<$Res>
    implements $ChallengeProgressCopyWith<$Res> {
  factory _$$ChallengeProgressImplCopyWith(_$ChallengeProgressImpl value,
          $Res Function(_$ChallengeProgressImpl) then) =
      __$$ChallengeProgressImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {double currentValue,
      double targetValue,
      double percentage,
      List<DateTime> completionDates,
      Map<String, dynamic> metadata,
      ChallengeProgressStatus status,
      DateTime startedAt,
      DateTime? completedAt});
}

/// @nodoc
class __$$ChallengeProgressImplCopyWithImpl<$Res>
    extends _$ChallengeProgressCopyWithImpl<$Res, _$ChallengeProgressImpl>
    implements _$$ChallengeProgressImplCopyWith<$Res> {
  __$$ChallengeProgressImplCopyWithImpl(_$ChallengeProgressImpl _value,
      $Res Function(_$ChallengeProgressImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? currentValue = null,
    Object? targetValue = null,
    Object? percentage = null,
    Object? completionDates = null,
    Object? metadata = null,
    Object? status = null,
    Object? startedAt = null,
    Object? completedAt = freezed,
  }) {
    return _then(_$ChallengeProgressImpl(
      currentValue: null == currentValue
          ? _value.currentValue
          : currentValue // ignore: cast_nullable_to_non_nullable
              as double,
      targetValue: null == targetValue
          ? _value.targetValue
          : targetValue // ignore: cast_nullable_to_non_nullable
              as double,
      percentage: null == percentage
          ? _value.percentage
          : percentage // ignore: cast_nullable_to_non_nullable
              as double,
      completionDates: null == completionDates
          ? _value._completionDates
          : completionDates // ignore: cast_nullable_to_non_nullable
              as List<DateTime>,
      metadata: null == metadata
          ? _value._metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as ChallengeProgressStatus,
      startedAt: null == startedAt
          ? _value.startedAt
          : startedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      completedAt: freezed == completedAt
          ? _value.completedAt
          : completedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ChallengeProgressImpl implements _ChallengeProgress {
  const _$ChallengeProgressImpl(
      {required this.currentValue,
      required this.targetValue,
      required this.percentage,
      required final List<DateTime> completionDates,
      required final Map<String, dynamic> metadata,
      required this.status,
      required this.startedAt,
      required this.completedAt})
      : _completionDates = completionDates,
        _metadata = metadata;

  factory _$ChallengeProgressImpl.fromJson(Map<String, dynamic> json) =>
      _$$ChallengeProgressImplFromJson(json);

  @override
  final double currentValue;
  @override
  final double targetValue;
  @override
  final double percentage;
  final List<DateTime> _completionDates;
  @override
  List<DateTime> get completionDates {
    if (_completionDates is EqualUnmodifiableListView) return _completionDates;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_completionDates);
  }

  final Map<String, dynamic> _metadata;
  @override
  Map<String, dynamic> get metadata {
    if (_metadata is EqualUnmodifiableMapView) return _metadata;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_metadata);
  }

  @override
  final ChallengeProgressStatus status;
  @override
  final DateTime startedAt;
  @override
  final DateTime? completedAt;

  @override
  String toString() {
    return 'ChallengeProgress(currentValue: $currentValue, targetValue: $targetValue, percentage: $percentage, completionDates: $completionDates, metadata: $metadata, status: $status, startedAt: $startedAt, completedAt: $completedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ChallengeProgressImpl &&
            (identical(other.currentValue, currentValue) ||
                other.currentValue == currentValue) &&
            (identical(other.targetValue, targetValue) ||
                other.targetValue == targetValue) &&
            (identical(other.percentage, percentage) ||
                other.percentage == percentage) &&
            const DeepCollectionEquality()
                .equals(other._completionDates, _completionDates) &&
            const DeepCollectionEquality().equals(other._metadata, _metadata) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.startedAt, startedAt) ||
                other.startedAt == startedAt) &&
            (identical(other.completedAt, completedAt) ||
                other.completedAt == completedAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      currentValue,
      targetValue,
      percentage,
      const DeepCollectionEquality().hash(_completionDates),
      const DeepCollectionEquality().hash(_metadata),
      status,
      startedAt,
      completedAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ChallengeProgressImplCopyWith<_$ChallengeProgressImpl> get copyWith =>
      __$$ChallengeProgressImplCopyWithImpl<_$ChallengeProgressImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ChallengeProgressImplToJson(
      this,
    );
  }
}

abstract class _ChallengeProgress implements ChallengeProgress {
  const factory _ChallengeProgress(
      {required final double currentValue,
      required final double targetValue,
      required final double percentage,
      required final List<DateTime> completionDates,
      required final Map<String, dynamic> metadata,
      required final ChallengeProgressStatus status,
      required final DateTime startedAt,
      required final DateTime? completedAt}) = _$ChallengeProgressImpl;

  factory _ChallengeProgress.fromJson(Map<String, dynamic> json) =
      _$ChallengeProgressImpl.fromJson;

  @override
  double get currentValue;
  @override
  double get targetValue;
  @override
  double get percentage;
  @override
  List<DateTime> get completionDates;
  @override
  Map<String, dynamic> get metadata;
  @override
  ChallengeProgressStatus get status;
  @override
  DateTime get startedAt;
  @override
  DateTime? get completedAt;
  @override
  @JsonKey(ignore: true)
  _$$ChallengeProgressImplCopyWith<_$ChallengeProgressImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

CheckIn _$CheckInFromJson(Map<String, dynamic> json) {
  return _CheckIn.fromJson(json);
}

/// @nodoc
mixin _$CheckIn {
  String get id => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  String? get buddyId => throw _privateConstructorUsedError;
  String? get teamId => throw _privateConstructorUsedError;
  CheckInType get type => throw _privateConstructorUsedError;
  DateTime get timestamp => throw _privateConstructorUsedError;
  @JsonKey(
      name: 'data', fromJson: _checkInDataFromJson, toJson: _checkInDataToJson)
  CheckInData get data => throw _privateConstructorUsedError;
  List<String> get reactions => throw _privateConstructorUsedError;
  List<CheckInComment> get comments => throw _privateConstructorUsedError;
  bool get isPublic => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $CheckInCopyWith<CheckIn> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CheckInCopyWith<$Res> {
  factory $CheckInCopyWith(CheckIn value, $Res Function(CheckIn) then) =
      _$CheckInCopyWithImpl<$Res, CheckIn>;
  @useResult
  $Res call(
      {String id,
      String userId,
      String? buddyId,
      String? teamId,
      CheckInType type,
      DateTime timestamp,
      @JsonKey(
          name: 'data',
          fromJson: _checkInDataFromJson,
          toJson: _checkInDataToJson)
      CheckInData data,
      List<String> reactions,
      List<CheckInComment> comments,
      bool isPublic});

  $CheckInDataCopyWith<$Res> get data;
}

/// @nodoc
class _$CheckInCopyWithImpl<$Res, $Val extends CheckIn>
    implements $CheckInCopyWith<$Res> {
  _$CheckInCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? buddyId = freezed,
    Object? teamId = freezed,
    Object? type = null,
    Object? timestamp = null,
    Object? data = null,
    Object? reactions = null,
    Object? comments = null,
    Object? isPublic = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      buddyId: freezed == buddyId
          ? _value.buddyId
          : buddyId // ignore: cast_nullable_to_non_nullable
              as String?,
      teamId: freezed == teamId
          ? _value.teamId
          : teamId // ignore: cast_nullable_to_non_nullable
              as String?,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as CheckInType,
      timestamp: null == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as DateTime,
      data: null == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as CheckInData,
      reactions: null == reactions
          ? _value.reactions
          : reactions // ignore: cast_nullable_to_non_nullable
              as List<String>,
      comments: null == comments
          ? _value.comments
          : comments // ignore: cast_nullable_to_non_nullable
              as List<CheckInComment>,
      isPublic: null == isPublic
          ? _value.isPublic
          : isPublic // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $CheckInDataCopyWith<$Res> get data {
    return $CheckInDataCopyWith<$Res>(_value.data, (value) {
      return _then(_value.copyWith(data: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$CheckInImplCopyWith<$Res> implements $CheckInCopyWith<$Res> {
  factory _$$CheckInImplCopyWith(
          _$CheckInImpl value, $Res Function(_$CheckInImpl) then) =
      __$$CheckInImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String userId,
      String? buddyId,
      String? teamId,
      CheckInType type,
      DateTime timestamp,
      @JsonKey(
          name: 'data',
          fromJson: _checkInDataFromJson,
          toJson: _checkInDataToJson)
      CheckInData data,
      List<String> reactions,
      List<CheckInComment> comments,
      bool isPublic});

  @override
  $CheckInDataCopyWith<$Res> get data;
}

/// @nodoc
class __$$CheckInImplCopyWithImpl<$Res>
    extends _$CheckInCopyWithImpl<$Res, _$CheckInImpl>
    implements _$$CheckInImplCopyWith<$Res> {
  __$$CheckInImplCopyWithImpl(
      _$CheckInImpl _value, $Res Function(_$CheckInImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? buddyId = freezed,
    Object? teamId = freezed,
    Object? type = null,
    Object? timestamp = null,
    Object? data = null,
    Object? reactions = null,
    Object? comments = null,
    Object? isPublic = null,
  }) {
    return _then(_$CheckInImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      buddyId: freezed == buddyId
          ? _value.buddyId
          : buddyId // ignore: cast_nullable_to_non_nullable
              as String?,
      teamId: freezed == teamId
          ? _value.teamId
          : teamId // ignore: cast_nullable_to_non_nullable
              as String?,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as CheckInType,
      timestamp: null == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as DateTime,
      data: null == data
          ? _value.data
          : data // ignore: cast_nullable_to_non_nullable
              as CheckInData,
      reactions: null == reactions
          ? _value._reactions
          : reactions // ignore: cast_nullable_to_non_nullable
              as List<String>,
      comments: null == comments
          ? _value._comments
          : comments // ignore: cast_nullable_to_non_nullable
              as List<CheckInComment>,
      isPublic: null == isPublic
          ? _value.isPublic
          : isPublic // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CheckInImpl implements _CheckIn {
  const _$CheckInImpl(
      {required this.id,
      required this.userId,
      required this.buddyId,
      required this.teamId,
      required this.type,
      required this.timestamp,
      @JsonKey(
          name: 'data',
          fromJson: _checkInDataFromJson,
          toJson: _checkInDataToJson)
      required this.data,
      required final List<String> reactions,
      required final List<CheckInComment> comments,
      required this.isPublic})
      : _reactions = reactions,
        _comments = comments;

  factory _$CheckInImpl.fromJson(Map<String, dynamic> json) =>
      _$$CheckInImplFromJson(json);

  @override
  final String id;
  @override
  final String userId;
  @override
  final String? buddyId;
  @override
  final String? teamId;
  @override
  final CheckInType type;
  @override
  final DateTime timestamp;
  @override
  @JsonKey(
      name: 'data', fromJson: _checkInDataFromJson, toJson: _checkInDataToJson)
  final CheckInData data;
  final List<String> _reactions;
  @override
  List<String> get reactions {
    if (_reactions is EqualUnmodifiableListView) return _reactions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_reactions);
  }

  final List<CheckInComment> _comments;
  @override
  List<CheckInComment> get comments {
    if (_comments is EqualUnmodifiableListView) return _comments;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_comments);
  }

  @override
  final bool isPublic;

  @override
  String toString() {
    return 'CheckIn(id: $id, userId: $userId, buddyId: $buddyId, teamId: $teamId, type: $type, timestamp: $timestamp, data: $data, reactions: $reactions, comments: $comments, isPublic: $isPublic)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CheckInImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.buddyId, buddyId) || other.buddyId == buddyId) &&
            (identical(other.teamId, teamId) || other.teamId == teamId) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.timestamp, timestamp) ||
                other.timestamp == timestamp) &&
            (identical(other.data, data) || other.data == data) &&
            const DeepCollectionEquality()
                .equals(other._reactions, _reactions) &&
            const DeepCollectionEquality().equals(other._comments, _comments) &&
            (identical(other.isPublic, isPublic) ||
                other.isPublic == isPublic));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      userId,
      buddyId,
      teamId,
      type,
      timestamp,
      data,
      const DeepCollectionEquality().hash(_reactions),
      const DeepCollectionEquality().hash(_comments),
      isPublic);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$CheckInImplCopyWith<_$CheckInImpl> get copyWith =>
      __$$CheckInImplCopyWithImpl<_$CheckInImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CheckInImplToJson(
      this,
    );
  }
}

abstract class _CheckIn implements CheckIn {
  const factory _CheckIn(
      {required final String id,
      required final String userId,
      required final String? buddyId,
      required final String? teamId,
      required final CheckInType type,
      required final DateTime timestamp,
      @JsonKey(
          name: 'data',
          fromJson: _checkInDataFromJson,
          toJson: _checkInDataToJson)
      required final CheckInData data,
      required final List<String> reactions,
      required final List<CheckInComment> comments,
      required final bool isPublic}) = _$CheckInImpl;

  factory _CheckIn.fromJson(Map<String, dynamic> json) = _$CheckInImpl.fromJson;

  @override
  String get id;
  @override
  String get userId;
  @override
  String? get buddyId;
  @override
  String? get teamId;
  @override
  CheckInType get type;
  @override
  DateTime get timestamp;
  @override
  @JsonKey(
      name: 'data', fromJson: _checkInDataFromJson, toJson: _checkInDataToJson)
  CheckInData get data;
  @override
  List<String> get reactions;
  @override
  List<CheckInComment> get comments;
  @override
  bool get isPublic;
  @override
  @JsonKey(ignore: true)
  _$$CheckInImplCopyWith<_$CheckInImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$CheckInData {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
            int streakDays,
            int xpEarned,
            List<String> activitiesCompleted,
            int moodRating,
            String? reflection)
        daily,
    required TResult Function(
            int weeklyXP,
            int streakDays,
            int activitiesCompleted,
            Map<String, int> pillarXP,
            List<String> highlights,
            List<String> challenges,
            String? goalsForNextWeek)
        weekly,
    required TResult Function(
            String milestoneType, String milestoneName, int value)
        milestone,
    required TResult Function(int streakDays, String saveType) streakSave,
    required TResult Function(String achievementId, String achievementName)
        achievement,
    required TResult Function(
            String challengeId, String challengeName, int rank)
        challengeComplete,
    required TResult Function(String fromUserId, String message) encouragement,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(
            int streakDays,
            int xpEarned,
            List<String> activitiesCompleted,
            int moodRating,
            String? reflection)?
        daily,
    TResult? Function(
            int weeklyXP,
            int streakDays,
            int activitiesCompleted,
            Map<String, int> pillarXP,
            List<String> highlights,
            List<String> challenges,
            String? goalsForNextWeek)?
        weekly,
    TResult? Function(String milestoneType, String milestoneName, int value)?
        milestone,
    TResult? Function(int streakDays, String saveType)? streakSave,
    TResult? Function(String achievementId, String achievementName)?
        achievement,
    TResult? Function(String challengeId, String challengeName, int rank)?
        challengeComplete,
    TResult? Function(String fromUserId, String message)? encouragement,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(
            int streakDays,
            int xpEarned,
            List<String> activitiesCompleted,
            int moodRating,
            String? reflection)?
        daily,
    TResult Function(
            int weeklyXP,
            int streakDays,
            int activitiesCompleted,
            Map<String, int> pillarXP,
            List<String> highlights,
            List<String> challenges,
            String? goalsForNextWeek)?
        weekly,
    TResult Function(String milestoneType, String milestoneName, int value)?
        milestone,
    TResult Function(int streakDays, String saveType)? streakSave,
    TResult Function(String achievementId, String achievementName)? achievement,
    TResult Function(String challengeId, String challengeName, int rank)?
        challengeComplete,
    TResult Function(String fromUserId, String message)? encouragement,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_DailyCheckInData value) daily,
    required TResult Function(_WeeklyCheckInData value) weekly,
    required TResult Function(_MilestoneCheckInData value) milestone,
    required TResult Function(_StreakSaveCheckInData value) streakSave,
    required TResult Function(_AchievementCheckInData value) achievement,
    required TResult Function(_ChallengeCompleteCheckInData value)
        challengeComplete,
    required TResult Function(_EncouragementCheckInData value) encouragement,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_DailyCheckInData value)? daily,
    TResult? Function(_WeeklyCheckInData value)? weekly,
    TResult? Function(_MilestoneCheckInData value)? milestone,
    TResult? Function(_StreakSaveCheckInData value)? streakSave,
    TResult? Function(_AchievementCheckInData value)? achievement,
    TResult? Function(_ChallengeCompleteCheckInData value)? challengeComplete,
    TResult? Function(_EncouragementCheckInData value)? encouragement,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_DailyCheckInData value)? daily,
    TResult Function(_WeeklyCheckInData value)? weekly,
    TResult Function(_MilestoneCheckInData value)? milestone,
    TResult Function(_StreakSaveCheckInData value)? streakSave,
    TResult Function(_AchievementCheckInData value)? achievement,
    TResult Function(_ChallengeCompleteCheckInData value)? challengeComplete,
    TResult Function(_EncouragementCheckInData value)? encouragement,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CheckInDataCopyWith<$Res> {
  factory $CheckInDataCopyWith(
          CheckInData value, $Res Function(CheckInData) then) =
      _$CheckInDataCopyWithImpl<$Res, CheckInData>;
}

/// @nodoc
class _$CheckInDataCopyWithImpl<$Res, $Val extends CheckInData>
    implements $CheckInDataCopyWith<$Res> {
  _$CheckInDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;
}

/// @nodoc
abstract class _$$DailyCheckInDataImplCopyWith<$Res> {
  factory _$$DailyCheckInDataImplCopyWith(_$DailyCheckInDataImpl value,
          $Res Function(_$DailyCheckInDataImpl) then) =
      __$$DailyCheckInDataImplCopyWithImpl<$Res>;
  @useResult
  $Res call(
      {int streakDays,
      int xpEarned,
      List<String> activitiesCompleted,
      int moodRating,
      String? reflection});
}

/// @nodoc
class __$$DailyCheckInDataImplCopyWithImpl<$Res>
    extends _$CheckInDataCopyWithImpl<$Res, _$DailyCheckInDataImpl>
    implements _$$DailyCheckInDataImplCopyWith<$Res> {
  __$$DailyCheckInDataImplCopyWithImpl(_$DailyCheckInDataImpl _value,
      $Res Function(_$DailyCheckInDataImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? streakDays = null,
    Object? xpEarned = null,
    Object? activitiesCompleted = null,
    Object? moodRating = null,
    Object? reflection = freezed,
  }) {
    return _then(_$DailyCheckInDataImpl(
      streakDays: null == streakDays
          ? _value.streakDays
          : streakDays // ignore: cast_nullable_to_non_nullable
              as int,
      xpEarned: null == xpEarned
          ? _value.xpEarned
          : xpEarned // ignore: cast_nullable_to_non_nullable
              as int,
      activitiesCompleted: null == activitiesCompleted
          ? _value._activitiesCompleted
          : activitiesCompleted // ignore: cast_nullable_to_non_nullable
              as List<String>,
      moodRating: null == moodRating
          ? _value.moodRating
          : moodRating // ignore: cast_nullable_to_non_nullable
              as int,
      reflection: freezed == reflection
          ? _value.reflection
          : reflection // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$DailyCheckInDataImpl implements _DailyCheckInData {
  const _$DailyCheckInDataImpl(
      {required this.streakDays,
      required this.xpEarned,
      required final List<String> activitiesCompleted,
      required this.moodRating,
      required this.reflection})
      : _activitiesCompleted = activitiesCompleted;

  @override
  final int streakDays;
  @override
  final int xpEarned;
  final List<String> _activitiesCompleted;
  @override
  List<String> get activitiesCompleted {
    if (_activitiesCompleted is EqualUnmodifiableListView)
      return _activitiesCompleted;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_activitiesCompleted);
  }

  @override
  final int moodRating;
  @override
  final String? reflection;

  @override
  String toString() {
    return 'CheckInData.daily(streakDays: $streakDays, xpEarned: $xpEarned, activitiesCompleted: $activitiesCompleted, moodRating: $moodRating, reflection: $reflection)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DailyCheckInDataImpl &&
            (identical(other.streakDays, streakDays) ||
                other.streakDays == streakDays) &&
            (identical(other.xpEarned, xpEarned) ||
                other.xpEarned == xpEarned) &&
            const DeepCollectionEquality()
                .equals(other._activitiesCompleted, _activitiesCompleted) &&
            (identical(other.moodRating, moodRating) ||
                other.moodRating == moodRating) &&
            (identical(other.reflection, reflection) ||
                other.reflection == reflection));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      streakDays,
      xpEarned,
      const DeepCollectionEquality().hash(_activitiesCompleted),
      moodRating,
      reflection);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$DailyCheckInDataImplCopyWith<_$DailyCheckInDataImpl> get copyWith =>
      __$$DailyCheckInDataImplCopyWithImpl<_$DailyCheckInDataImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
            int streakDays,
            int xpEarned,
            List<String> activitiesCompleted,
            int moodRating,
            String? reflection)
        daily,
    required TResult Function(
            int weeklyXP,
            int streakDays,
            int activitiesCompleted,
            Map<String, int> pillarXP,
            List<String> highlights,
            List<String> challenges,
            String? goalsForNextWeek)
        weekly,
    required TResult Function(
            String milestoneType, String milestoneName, int value)
        milestone,
    required TResult Function(int streakDays, String saveType) streakSave,
    required TResult Function(String achievementId, String achievementName)
        achievement,
    required TResult Function(
            String challengeId, String challengeName, int rank)
        challengeComplete,
    required TResult Function(String fromUserId, String message) encouragement,
  }) {
    return daily(
        streakDays, xpEarned, activitiesCompleted, moodRating, reflection);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(
            int streakDays,
            int xpEarned,
            List<String> activitiesCompleted,
            int moodRating,
            String? reflection)?
        daily,
    TResult? Function(
            int weeklyXP,
            int streakDays,
            int activitiesCompleted,
            Map<String, int> pillarXP,
            List<String> highlights,
            List<String> challenges,
            String? goalsForNextWeek)?
        weekly,
    TResult? Function(String milestoneType, String milestoneName, int value)?
        milestone,
    TResult? Function(int streakDays, String saveType)? streakSave,
    TResult? Function(String achievementId, String achievementName)?
        achievement,
    TResult? Function(String challengeId, String challengeName, int rank)?
        challengeComplete,
    TResult? Function(String fromUserId, String message)? encouragement,
  }) {
    return daily?.call(
        streakDays, xpEarned, activitiesCompleted, moodRating, reflection);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(
            int streakDays,
            int xpEarned,
            List<String> activitiesCompleted,
            int moodRating,
            String? reflection)?
        daily,
    TResult Function(
            int weeklyXP,
            int streakDays,
            int activitiesCompleted,
            Map<String, int> pillarXP,
            List<String> highlights,
            List<String> challenges,
            String? goalsForNextWeek)?
        weekly,
    TResult Function(String milestoneType, String milestoneName, int value)?
        milestone,
    TResult Function(int streakDays, String saveType)? streakSave,
    TResult Function(String achievementId, String achievementName)? achievement,
    TResult Function(String challengeId, String challengeName, int rank)?
        challengeComplete,
    TResult Function(String fromUserId, String message)? encouragement,
    required TResult orElse(),
  }) {
    if (daily != null) {
      return daily(
          streakDays, xpEarned, activitiesCompleted, moodRating, reflection);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_DailyCheckInData value) daily,
    required TResult Function(_WeeklyCheckInData value) weekly,
    required TResult Function(_MilestoneCheckInData value) milestone,
    required TResult Function(_StreakSaveCheckInData value) streakSave,
    required TResult Function(_AchievementCheckInData value) achievement,
    required TResult Function(_ChallengeCompleteCheckInData value)
        challengeComplete,
    required TResult Function(_EncouragementCheckInData value) encouragement,
  }) {
    return daily(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_DailyCheckInData value)? daily,
    TResult? Function(_WeeklyCheckInData value)? weekly,
    TResult? Function(_MilestoneCheckInData value)? milestone,
    TResult? Function(_StreakSaveCheckInData value)? streakSave,
    TResult? Function(_AchievementCheckInData value)? achievement,
    TResult? Function(_ChallengeCompleteCheckInData value)? challengeComplete,
    TResult? Function(_EncouragementCheckInData value)? encouragement,
  }) {
    return daily?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_DailyCheckInData value)? daily,
    TResult Function(_WeeklyCheckInData value)? weekly,
    TResult Function(_MilestoneCheckInData value)? milestone,
    TResult Function(_StreakSaveCheckInData value)? streakSave,
    TResult Function(_AchievementCheckInData value)? achievement,
    TResult Function(_ChallengeCompleteCheckInData value)? challengeComplete,
    TResult Function(_EncouragementCheckInData value)? encouragement,
    required TResult orElse(),
  }) {
    if (daily != null) {
      return daily(this);
    }
    return orElse();
  }
}

abstract class _DailyCheckInData implements CheckInData {
  const factory _DailyCheckInData(
      {required final int streakDays,
      required final int xpEarned,
      required final List<String> activitiesCompleted,
      required final int moodRating,
      required final String? reflection}) = _$DailyCheckInDataImpl;

  int get streakDays;
  int get xpEarned;
  List<String> get activitiesCompleted;
  int get moodRating;
  String? get reflection;
  @JsonKey(ignore: true)
  _$$DailyCheckInDataImplCopyWith<_$DailyCheckInDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$WeeklyCheckInDataImplCopyWith<$Res> {
  factory _$$WeeklyCheckInDataImplCopyWith(_$WeeklyCheckInDataImpl value,
          $Res Function(_$WeeklyCheckInDataImpl) then) =
      __$$WeeklyCheckInDataImplCopyWithImpl<$Res>;
  @useResult
  $Res call(
      {int weeklyXP,
      int streakDays,
      int activitiesCompleted,
      Map<String, int> pillarXP,
      List<String> highlights,
      List<String> challenges,
      String? goalsForNextWeek});
}

/// @nodoc
class __$$WeeklyCheckInDataImplCopyWithImpl<$Res>
    extends _$CheckInDataCopyWithImpl<$Res, _$WeeklyCheckInDataImpl>
    implements _$$WeeklyCheckInDataImplCopyWith<$Res> {
  __$$WeeklyCheckInDataImplCopyWithImpl(_$WeeklyCheckInDataImpl _value,
      $Res Function(_$WeeklyCheckInDataImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? weeklyXP = null,
    Object? streakDays = null,
    Object? activitiesCompleted = null,
    Object? pillarXP = null,
    Object? highlights = null,
    Object? challenges = null,
    Object? goalsForNextWeek = freezed,
  }) {
    return _then(_$WeeklyCheckInDataImpl(
      weeklyXP: null == weeklyXP
          ? _value.weeklyXP
          : weeklyXP // ignore: cast_nullable_to_non_nullable
              as int,
      streakDays: null == streakDays
          ? _value.streakDays
          : streakDays // ignore: cast_nullable_to_non_nullable
              as int,
      activitiesCompleted: null == activitiesCompleted
          ? _value.activitiesCompleted
          : activitiesCompleted // ignore: cast_nullable_to_non_nullable
              as int,
      pillarXP: null == pillarXP
          ? _value._pillarXP
          : pillarXP // ignore: cast_nullable_to_non_nullable
              as Map<String, int>,
      highlights: null == highlights
          ? _value._highlights
          : highlights // ignore: cast_nullable_to_non_nullable
              as List<String>,
      challenges: null == challenges
          ? _value._challenges
          : challenges // ignore: cast_nullable_to_non_nullable
              as List<String>,
      goalsForNextWeek: freezed == goalsForNextWeek
          ? _value.goalsForNextWeek
          : goalsForNextWeek // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$WeeklyCheckInDataImpl implements _WeeklyCheckInData {
  const _$WeeklyCheckInDataImpl(
      {required this.weeklyXP,
      required this.streakDays,
      required this.activitiesCompleted,
      required final Map<String, int> pillarXP,
      required final List<String> highlights,
      required final List<String> challenges,
      required this.goalsForNextWeek})
      : _pillarXP = pillarXP,
        _highlights = highlights,
        _challenges = challenges;

  @override
  final int weeklyXP;
  @override
  final int streakDays;
  @override
  final int activitiesCompleted;
  final Map<String, int> _pillarXP;
  @override
  Map<String, int> get pillarXP {
    if (_pillarXP is EqualUnmodifiableMapView) return _pillarXP;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_pillarXP);
  }

  final List<String> _highlights;
  @override
  List<String> get highlights {
    if (_highlights is EqualUnmodifiableListView) return _highlights;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_highlights);
  }

  final List<String> _challenges;
  @override
  List<String> get challenges {
    if (_challenges is EqualUnmodifiableListView) return _challenges;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_challenges);
  }

  @override
  final String? goalsForNextWeek;

  @override
  String toString() {
    return 'CheckInData.weekly(weeklyXP: $weeklyXP, streakDays: $streakDays, activitiesCompleted: $activitiesCompleted, pillarXP: $pillarXP, highlights: $highlights, challenges: $challenges, goalsForNextWeek: $goalsForNextWeek)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WeeklyCheckInDataImpl &&
            (identical(other.weeklyXP, weeklyXP) ||
                other.weeklyXP == weeklyXP) &&
            (identical(other.streakDays, streakDays) ||
                other.streakDays == streakDays) &&
            (identical(other.activitiesCompleted, activitiesCompleted) ||
                other.activitiesCompleted == activitiesCompleted) &&
            const DeepCollectionEquality().equals(other._pillarXP, _pillarXP) &&
            const DeepCollectionEquality()
                .equals(other._highlights, _highlights) &&
            const DeepCollectionEquality()
                .equals(other._challenges, _challenges) &&
            (identical(other.goalsForNextWeek, goalsForNextWeek) ||
                other.goalsForNextWeek == goalsForNextWeek));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      weeklyXP,
      streakDays,
      activitiesCompleted,
      const DeepCollectionEquality().hash(_pillarXP),
      const DeepCollectionEquality().hash(_highlights),
      const DeepCollectionEquality().hash(_challenges),
      goalsForNextWeek);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$WeeklyCheckInDataImplCopyWith<_$WeeklyCheckInDataImpl> get copyWith =>
      __$$WeeklyCheckInDataImplCopyWithImpl<_$WeeklyCheckInDataImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
            int streakDays,
            int xpEarned,
            List<String> activitiesCompleted,
            int moodRating,
            String? reflection)
        daily,
    required TResult Function(
            int weeklyXP,
            int streakDays,
            int activitiesCompleted,
            Map<String, int> pillarXP,
            List<String> highlights,
            List<String> challenges,
            String? goalsForNextWeek)
        weekly,
    required TResult Function(
            String milestoneType, String milestoneName, int value)
        milestone,
    required TResult Function(int streakDays, String saveType) streakSave,
    required TResult Function(String achievementId, String achievementName)
        achievement,
    required TResult Function(
            String challengeId, String challengeName, int rank)
        challengeComplete,
    required TResult Function(String fromUserId, String message) encouragement,
  }) {
    return weekly(weeklyXP, streakDays, activitiesCompleted, pillarXP,
        highlights, challenges, goalsForNextWeek);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(
            int streakDays,
            int xpEarned,
            List<String> activitiesCompleted,
            int moodRating,
            String? reflection)?
        daily,
    TResult? Function(
            int weeklyXP,
            int streakDays,
            int activitiesCompleted,
            Map<String, int> pillarXP,
            List<String> highlights,
            List<String> challenges,
            String? goalsForNextWeek)?
        weekly,
    TResult? Function(String milestoneType, String milestoneName, int value)?
        milestone,
    TResult? Function(int streakDays, String saveType)? streakSave,
    TResult? Function(String achievementId, String achievementName)?
        achievement,
    TResult? Function(String challengeId, String challengeName, int rank)?
        challengeComplete,
    TResult? Function(String fromUserId, String message)? encouragement,
  }) {
    return weekly?.call(weeklyXP, streakDays, activitiesCompleted, pillarXP,
        highlights, challenges, goalsForNextWeek);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(
            int streakDays,
            int xpEarned,
            List<String> activitiesCompleted,
            int moodRating,
            String? reflection)?
        daily,
    TResult Function(
            int weeklyXP,
            int streakDays,
            int activitiesCompleted,
            Map<String, int> pillarXP,
            List<String> highlights,
            List<String> challenges,
            String? goalsForNextWeek)?
        weekly,
    TResult Function(String milestoneType, String milestoneName, int value)?
        milestone,
    TResult Function(int streakDays, String saveType)? streakSave,
    TResult Function(String achievementId, String achievementName)? achievement,
    TResult Function(String challengeId, String challengeName, int rank)?
        challengeComplete,
    TResult Function(String fromUserId, String message)? encouragement,
    required TResult orElse(),
  }) {
    if (weekly != null) {
      return weekly(weeklyXP, streakDays, activitiesCompleted, pillarXP,
          highlights, challenges, goalsForNextWeek);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_DailyCheckInData value) daily,
    required TResult Function(_WeeklyCheckInData value) weekly,
    required TResult Function(_MilestoneCheckInData value) milestone,
    required TResult Function(_StreakSaveCheckInData value) streakSave,
    required TResult Function(_AchievementCheckInData value) achievement,
    required TResult Function(_ChallengeCompleteCheckInData value)
        challengeComplete,
    required TResult Function(_EncouragementCheckInData value) encouragement,
  }) {
    return weekly(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_DailyCheckInData value)? daily,
    TResult? Function(_WeeklyCheckInData value)? weekly,
    TResult? Function(_MilestoneCheckInData value)? milestone,
    TResult? Function(_StreakSaveCheckInData value)? streakSave,
    TResult? Function(_AchievementCheckInData value)? achievement,
    TResult? Function(_ChallengeCompleteCheckInData value)? challengeComplete,
    TResult? Function(_EncouragementCheckInData value)? encouragement,
  }) {
    return weekly?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_DailyCheckInData value)? daily,
    TResult Function(_WeeklyCheckInData value)? weekly,
    TResult Function(_MilestoneCheckInData value)? milestone,
    TResult Function(_StreakSaveCheckInData value)? streakSave,
    TResult Function(_AchievementCheckInData value)? achievement,
    TResult Function(_ChallengeCompleteCheckInData value)? challengeComplete,
    TResult Function(_EncouragementCheckInData value)? encouragement,
    required TResult orElse(),
  }) {
    if (weekly != null) {
      return weekly(this);
    }
    return orElse();
  }
}

abstract class _WeeklyCheckInData implements CheckInData {
  const factory _WeeklyCheckInData(
      {required final int weeklyXP,
      required final int streakDays,
      required final int activitiesCompleted,
      required final Map<String, int> pillarXP,
      required final List<String> highlights,
      required final List<String> challenges,
      required final String? goalsForNextWeek}) = _$WeeklyCheckInDataImpl;

  int get weeklyXP;
  int get streakDays;
  int get activitiesCompleted;
  Map<String, int> get pillarXP;
  List<String> get highlights;
  List<String> get challenges;
  String? get goalsForNextWeek;
  @JsonKey(ignore: true)
  _$$WeeklyCheckInDataImplCopyWith<_$WeeklyCheckInDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$MilestoneCheckInDataImplCopyWith<$Res> {
  factory _$$MilestoneCheckInDataImplCopyWith(_$MilestoneCheckInDataImpl value,
          $Res Function(_$MilestoneCheckInDataImpl) then) =
      __$$MilestoneCheckInDataImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String milestoneType, String milestoneName, int value});
}

/// @nodoc
class __$$MilestoneCheckInDataImplCopyWithImpl<$Res>
    extends _$CheckInDataCopyWithImpl<$Res, _$MilestoneCheckInDataImpl>
    implements _$$MilestoneCheckInDataImplCopyWith<$Res> {
  __$$MilestoneCheckInDataImplCopyWithImpl(_$MilestoneCheckInDataImpl _value,
      $Res Function(_$MilestoneCheckInDataImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? milestoneType = null,
    Object? milestoneName = null,
    Object? value = null,
  }) {
    return _then(_$MilestoneCheckInDataImpl(
      milestoneType: null == milestoneType
          ? _value.milestoneType
          : milestoneType // ignore: cast_nullable_to_non_nullable
              as String,
      milestoneName: null == milestoneName
          ? _value.milestoneName
          : milestoneName // ignore: cast_nullable_to_non_nullable
              as String,
      value: null == value
          ? _value.value
          : value // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc

class _$MilestoneCheckInDataImpl implements _MilestoneCheckInData {
  const _$MilestoneCheckInDataImpl(
      {required this.milestoneType,
      required this.milestoneName,
      required this.value});

  @override
  final String milestoneType;
  @override
  final String milestoneName;
  @override
  final int value;

  @override
  String toString() {
    return 'CheckInData.milestone(milestoneType: $milestoneType, milestoneName: $milestoneName, value: $value)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MilestoneCheckInDataImpl &&
            (identical(other.milestoneType, milestoneType) ||
                other.milestoneType == milestoneType) &&
            (identical(other.milestoneName, milestoneName) ||
                other.milestoneName == milestoneName) &&
            (identical(other.value, value) || other.value == value));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, milestoneType, milestoneName, value);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$MilestoneCheckInDataImplCopyWith<_$MilestoneCheckInDataImpl>
      get copyWith =>
          __$$MilestoneCheckInDataImplCopyWithImpl<_$MilestoneCheckInDataImpl>(
              this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
            int streakDays,
            int xpEarned,
            List<String> activitiesCompleted,
            int moodRating,
            String? reflection)
        daily,
    required TResult Function(
            int weeklyXP,
            int streakDays,
            int activitiesCompleted,
            Map<String, int> pillarXP,
            List<String> highlights,
            List<String> challenges,
            String? goalsForNextWeek)
        weekly,
    required TResult Function(
            String milestoneType, String milestoneName, int value)
        milestone,
    required TResult Function(int streakDays, String saveType) streakSave,
    required TResult Function(String achievementId, String achievementName)
        achievement,
    required TResult Function(
            String challengeId, String challengeName, int rank)
        challengeComplete,
    required TResult Function(String fromUserId, String message) encouragement,
  }) {
    return milestone(milestoneType, milestoneName, value);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(
            int streakDays,
            int xpEarned,
            List<String> activitiesCompleted,
            int moodRating,
            String? reflection)?
        daily,
    TResult? Function(
            int weeklyXP,
            int streakDays,
            int activitiesCompleted,
            Map<String, int> pillarXP,
            List<String> highlights,
            List<String> challenges,
            String? goalsForNextWeek)?
        weekly,
    TResult? Function(String milestoneType, String milestoneName, int value)?
        milestone,
    TResult? Function(int streakDays, String saveType)? streakSave,
    TResult? Function(String achievementId, String achievementName)?
        achievement,
    TResult? Function(String challengeId, String challengeName, int rank)?
        challengeComplete,
    TResult? Function(String fromUserId, String message)? encouragement,
  }) {
    return milestone?.call(milestoneType, milestoneName, value);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(
            int streakDays,
            int xpEarned,
            List<String> activitiesCompleted,
            int moodRating,
            String? reflection)?
        daily,
    TResult Function(
            int weeklyXP,
            int streakDays,
            int activitiesCompleted,
            Map<String, int> pillarXP,
            List<String> highlights,
            List<String> challenges,
            String? goalsForNextWeek)?
        weekly,
    TResult Function(String milestoneType, String milestoneName, int value)?
        milestone,
    TResult Function(int streakDays, String saveType)? streakSave,
    TResult Function(String achievementId, String achievementName)? achievement,
    TResult Function(String challengeId, String challengeName, int rank)?
        challengeComplete,
    TResult Function(String fromUserId, String message)? encouragement,
    required TResult orElse(),
  }) {
    if (milestone != null) {
      return milestone(milestoneType, milestoneName, value);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_DailyCheckInData value) daily,
    required TResult Function(_WeeklyCheckInData value) weekly,
    required TResult Function(_MilestoneCheckInData value) milestone,
    required TResult Function(_StreakSaveCheckInData value) streakSave,
    required TResult Function(_AchievementCheckInData value) achievement,
    required TResult Function(_ChallengeCompleteCheckInData value)
        challengeComplete,
    required TResult Function(_EncouragementCheckInData value) encouragement,
  }) {
    return milestone(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_DailyCheckInData value)? daily,
    TResult? Function(_WeeklyCheckInData value)? weekly,
    TResult? Function(_MilestoneCheckInData value)? milestone,
    TResult? Function(_StreakSaveCheckInData value)? streakSave,
    TResult? Function(_AchievementCheckInData value)? achievement,
    TResult? Function(_ChallengeCompleteCheckInData value)? challengeComplete,
    TResult? Function(_EncouragementCheckInData value)? encouragement,
  }) {
    return milestone?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_DailyCheckInData value)? daily,
    TResult Function(_WeeklyCheckInData value)? weekly,
    TResult Function(_MilestoneCheckInData value)? milestone,
    TResult Function(_StreakSaveCheckInData value)? streakSave,
    TResult Function(_AchievementCheckInData value)? achievement,
    TResult Function(_ChallengeCompleteCheckInData value)? challengeComplete,
    TResult Function(_EncouragementCheckInData value)? encouragement,
    required TResult orElse(),
  }) {
    if (milestone != null) {
      return milestone(this);
    }
    return orElse();
  }
}

abstract class _MilestoneCheckInData implements CheckInData {
  const factory _MilestoneCheckInData(
      {required final String milestoneType,
      required final String milestoneName,
      required final int value}) = _$MilestoneCheckInDataImpl;

  String get milestoneType;
  String get milestoneName;
  int get value;
  @JsonKey(ignore: true)
  _$$MilestoneCheckInDataImplCopyWith<_$MilestoneCheckInDataImpl>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$StreakSaveCheckInDataImplCopyWith<$Res> {
  factory _$$StreakSaveCheckInDataImplCopyWith(
          _$StreakSaveCheckInDataImpl value,
          $Res Function(_$StreakSaveCheckInDataImpl) then) =
      __$$StreakSaveCheckInDataImplCopyWithImpl<$Res>;
  @useResult
  $Res call({int streakDays, String saveType});
}

/// @nodoc
class __$$StreakSaveCheckInDataImplCopyWithImpl<$Res>
    extends _$CheckInDataCopyWithImpl<$Res, _$StreakSaveCheckInDataImpl>
    implements _$$StreakSaveCheckInDataImplCopyWith<$Res> {
  __$$StreakSaveCheckInDataImplCopyWithImpl(_$StreakSaveCheckInDataImpl _value,
      $Res Function(_$StreakSaveCheckInDataImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? streakDays = null,
    Object? saveType = null,
  }) {
    return _then(_$StreakSaveCheckInDataImpl(
      streakDays: null == streakDays
          ? _value.streakDays
          : streakDays // ignore: cast_nullable_to_non_nullable
              as int,
      saveType: null == saveType
          ? _value.saveType
          : saveType // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$StreakSaveCheckInDataImpl implements _StreakSaveCheckInData {
  const _$StreakSaveCheckInDataImpl(
      {required this.streakDays, required this.saveType});

  @override
  final int streakDays;
  @override
  final String saveType;

  @override
  String toString() {
    return 'CheckInData.streakSave(streakDays: $streakDays, saveType: $saveType)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StreakSaveCheckInDataImpl &&
            (identical(other.streakDays, streakDays) ||
                other.streakDays == streakDays) &&
            (identical(other.saveType, saveType) ||
                other.saveType == saveType));
  }

  @override
  int get hashCode => Object.hash(runtimeType, streakDays, saveType);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$StreakSaveCheckInDataImplCopyWith<_$StreakSaveCheckInDataImpl>
      get copyWith => __$$StreakSaveCheckInDataImplCopyWithImpl<
          _$StreakSaveCheckInDataImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
            int streakDays,
            int xpEarned,
            List<String> activitiesCompleted,
            int moodRating,
            String? reflection)
        daily,
    required TResult Function(
            int weeklyXP,
            int streakDays,
            int activitiesCompleted,
            Map<String, int> pillarXP,
            List<String> highlights,
            List<String> challenges,
            String? goalsForNextWeek)
        weekly,
    required TResult Function(
            String milestoneType, String milestoneName, int value)
        milestone,
    required TResult Function(int streakDays, String saveType) streakSave,
    required TResult Function(String achievementId, String achievementName)
        achievement,
    required TResult Function(
            String challengeId, String challengeName, int rank)
        challengeComplete,
    required TResult Function(String fromUserId, String message) encouragement,
  }) {
    return streakSave(streakDays, saveType);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(
            int streakDays,
            int xpEarned,
            List<String> activitiesCompleted,
            int moodRating,
            String? reflection)?
        daily,
    TResult? Function(
            int weeklyXP,
            int streakDays,
            int activitiesCompleted,
            Map<String, int> pillarXP,
            List<String> highlights,
            List<String> challenges,
            String? goalsForNextWeek)?
        weekly,
    TResult? Function(String milestoneType, String milestoneName, int value)?
        milestone,
    TResult? Function(int streakDays, String saveType)? streakSave,
    TResult? Function(String achievementId, String achievementName)?
        achievement,
    TResult? Function(String challengeId, String challengeName, int rank)?
        challengeComplete,
    TResult? Function(String fromUserId, String message)? encouragement,
  }) {
    return streakSave?.call(streakDays, saveType);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(
            int streakDays,
            int xpEarned,
            List<String> activitiesCompleted,
            int moodRating,
            String? reflection)?
        daily,
    TResult Function(
            int weeklyXP,
            int streakDays,
            int activitiesCompleted,
            Map<String, int> pillarXP,
            List<String> highlights,
            List<String> challenges,
            String? goalsForNextWeek)?
        weekly,
    TResult Function(String milestoneType, String milestoneName, int value)?
        milestone,
    TResult Function(int streakDays, String saveType)? streakSave,
    TResult Function(String achievementId, String achievementName)? achievement,
    TResult Function(String challengeId, String challengeName, int rank)?
        challengeComplete,
    TResult Function(String fromUserId, String message)? encouragement,
    required TResult orElse(),
  }) {
    if (streakSave != null) {
      return streakSave(streakDays, saveType);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_DailyCheckInData value) daily,
    required TResult Function(_WeeklyCheckInData value) weekly,
    required TResult Function(_MilestoneCheckInData value) milestone,
    required TResult Function(_StreakSaveCheckInData value) streakSave,
    required TResult Function(_AchievementCheckInData value) achievement,
    required TResult Function(_ChallengeCompleteCheckInData value)
        challengeComplete,
    required TResult Function(_EncouragementCheckInData value) encouragement,
  }) {
    return streakSave(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_DailyCheckInData value)? daily,
    TResult? Function(_WeeklyCheckInData value)? weekly,
    TResult? Function(_MilestoneCheckInData value)? milestone,
    TResult? Function(_StreakSaveCheckInData value)? streakSave,
    TResult? Function(_AchievementCheckInData value)? achievement,
    TResult? Function(_ChallengeCompleteCheckInData value)? challengeComplete,
    TResult? Function(_EncouragementCheckInData value)? encouragement,
  }) {
    return streakSave?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_DailyCheckInData value)? daily,
    TResult Function(_WeeklyCheckInData value)? weekly,
    TResult Function(_MilestoneCheckInData value)? milestone,
    TResult Function(_StreakSaveCheckInData value)? streakSave,
    TResult Function(_AchievementCheckInData value)? achievement,
    TResult Function(_ChallengeCompleteCheckInData value)? challengeComplete,
    TResult Function(_EncouragementCheckInData value)? encouragement,
    required TResult orElse(),
  }) {
    if (streakSave != null) {
      return streakSave(this);
    }
    return orElse();
  }
}

abstract class _StreakSaveCheckInData implements CheckInData {
  const factory _StreakSaveCheckInData(
      {required final int streakDays,
      required final String saveType}) = _$StreakSaveCheckInDataImpl;

  int get streakDays;
  String get saveType;
  @JsonKey(ignore: true)
  _$$StreakSaveCheckInDataImplCopyWith<_$StreakSaveCheckInDataImpl>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$AchievementCheckInDataImplCopyWith<$Res> {
  factory _$$AchievementCheckInDataImplCopyWith(
          _$AchievementCheckInDataImpl value,
          $Res Function(_$AchievementCheckInDataImpl) then) =
      __$$AchievementCheckInDataImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String achievementId, String achievementName});
}

/// @nodoc
class __$$AchievementCheckInDataImplCopyWithImpl<$Res>
    extends _$CheckInDataCopyWithImpl<$Res, _$AchievementCheckInDataImpl>
    implements _$$AchievementCheckInDataImplCopyWith<$Res> {
  __$$AchievementCheckInDataImplCopyWithImpl(
      _$AchievementCheckInDataImpl _value,
      $Res Function(_$AchievementCheckInDataImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? achievementId = null,
    Object? achievementName = null,
  }) {
    return _then(_$AchievementCheckInDataImpl(
      achievementId: null == achievementId
          ? _value.achievementId
          : achievementId // ignore: cast_nullable_to_non_nullable
              as String,
      achievementName: null == achievementName
          ? _value.achievementName
          : achievementName // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$AchievementCheckInDataImpl implements _AchievementCheckInData {
  const _$AchievementCheckInDataImpl(
      {required this.achievementId, required this.achievementName});

  @override
  final String achievementId;
  @override
  final String achievementName;

  @override
  String toString() {
    return 'CheckInData.achievement(achievementId: $achievementId, achievementName: $achievementName)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AchievementCheckInDataImpl &&
            (identical(other.achievementId, achievementId) ||
                other.achievementId == achievementId) &&
            (identical(other.achievementName, achievementName) ||
                other.achievementName == achievementName));
  }

  @override
  int get hashCode => Object.hash(runtimeType, achievementId, achievementName);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$AchievementCheckInDataImplCopyWith<_$AchievementCheckInDataImpl>
      get copyWith => __$$AchievementCheckInDataImplCopyWithImpl<
          _$AchievementCheckInDataImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
            int streakDays,
            int xpEarned,
            List<String> activitiesCompleted,
            int moodRating,
            String? reflection)
        daily,
    required TResult Function(
            int weeklyXP,
            int streakDays,
            int activitiesCompleted,
            Map<String, int> pillarXP,
            List<String> highlights,
            List<String> challenges,
            String? goalsForNextWeek)
        weekly,
    required TResult Function(
            String milestoneType, String milestoneName, int value)
        milestone,
    required TResult Function(int streakDays, String saveType) streakSave,
    required TResult Function(String achievementId, String achievementName)
        achievement,
    required TResult Function(
            String challengeId, String challengeName, int rank)
        challengeComplete,
    required TResult Function(String fromUserId, String message) encouragement,
  }) {
    return achievement(achievementId, achievementName);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(
            int streakDays,
            int xpEarned,
            List<String> activitiesCompleted,
            int moodRating,
            String? reflection)?
        daily,
    TResult? Function(
            int weeklyXP,
            int streakDays,
            int activitiesCompleted,
            Map<String, int> pillarXP,
            List<String> highlights,
            List<String> challenges,
            String? goalsForNextWeek)?
        weekly,
    TResult? Function(String milestoneType, String milestoneName, int value)?
        milestone,
    TResult? Function(int streakDays, String saveType)? streakSave,
    TResult? Function(String achievementId, String achievementName)?
        achievement,
    TResult? Function(String challengeId, String challengeName, int rank)?
        challengeComplete,
    TResult? Function(String fromUserId, String message)? encouragement,
  }) {
    return achievement?.call(achievementId, achievementName);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(
            int streakDays,
            int xpEarned,
            List<String> activitiesCompleted,
            int moodRating,
            String? reflection)?
        daily,
    TResult Function(
            int weeklyXP,
            int streakDays,
            int activitiesCompleted,
            Map<String, int> pillarXP,
            List<String> highlights,
            List<String> challenges,
            String? goalsForNextWeek)?
        weekly,
    TResult Function(String milestoneType, String milestoneName, int value)?
        milestone,
    TResult Function(int streakDays, String saveType)? streakSave,
    TResult Function(String achievementId, String achievementName)? achievement,
    TResult Function(String challengeId, String challengeName, int rank)?
        challengeComplete,
    TResult Function(String fromUserId, String message)? encouragement,
    required TResult orElse(),
  }) {
    if (achievement != null) {
      return achievement(achievementId, achievementName);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_DailyCheckInData value) daily,
    required TResult Function(_WeeklyCheckInData value) weekly,
    required TResult Function(_MilestoneCheckInData value) milestone,
    required TResult Function(_StreakSaveCheckInData value) streakSave,
    required TResult Function(_AchievementCheckInData value) achievement,
    required TResult Function(_ChallengeCompleteCheckInData value)
        challengeComplete,
    required TResult Function(_EncouragementCheckInData value) encouragement,
  }) {
    return achievement(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_DailyCheckInData value)? daily,
    TResult? Function(_WeeklyCheckInData value)? weekly,
    TResult? Function(_MilestoneCheckInData value)? milestone,
    TResult? Function(_StreakSaveCheckInData value)? streakSave,
    TResult? Function(_AchievementCheckInData value)? achievement,
    TResult? Function(_ChallengeCompleteCheckInData value)? challengeComplete,
    TResult? Function(_EncouragementCheckInData value)? encouragement,
  }) {
    return achievement?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_DailyCheckInData value)? daily,
    TResult Function(_WeeklyCheckInData value)? weekly,
    TResult Function(_MilestoneCheckInData value)? milestone,
    TResult Function(_StreakSaveCheckInData value)? streakSave,
    TResult Function(_AchievementCheckInData value)? achievement,
    TResult Function(_ChallengeCompleteCheckInData value)? challengeComplete,
    TResult Function(_EncouragementCheckInData value)? encouragement,
    required TResult orElse(),
  }) {
    if (achievement != null) {
      return achievement(this);
    }
    return orElse();
  }
}

abstract class _AchievementCheckInData implements CheckInData {
  const factory _AchievementCheckInData(
      {required final String achievementId,
      required final String achievementName}) = _$AchievementCheckInDataImpl;

  String get achievementId;
  String get achievementName;
  @JsonKey(ignore: true)
  _$$AchievementCheckInDataImplCopyWith<_$AchievementCheckInDataImpl>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$ChallengeCompleteCheckInDataImplCopyWith<$Res> {
  factory _$$ChallengeCompleteCheckInDataImplCopyWith(
          _$ChallengeCompleteCheckInDataImpl value,
          $Res Function(_$ChallengeCompleteCheckInDataImpl) then) =
      __$$ChallengeCompleteCheckInDataImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String challengeId, String challengeName, int rank});
}

/// @nodoc
class __$$ChallengeCompleteCheckInDataImplCopyWithImpl<$Res>
    extends _$CheckInDataCopyWithImpl<$Res, _$ChallengeCompleteCheckInDataImpl>
    implements _$$ChallengeCompleteCheckInDataImplCopyWith<$Res> {
  __$$ChallengeCompleteCheckInDataImplCopyWithImpl(
      _$ChallengeCompleteCheckInDataImpl _value,
      $Res Function(_$ChallengeCompleteCheckInDataImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? challengeId = null,
    Object? challengeName = null,
    Object? rank = null,
  }) {
    return _then(_$ChallengeCompleteCheckInDataImpl(
      challengeId: null == challengeId
          ? _value.challengeId
          : challengeId // ignore: cast_nullable_to_non_nullable
              as String,
      challengeName: null == challengeName
          ? _value.challengeName
          : challengeName // ignore: cast_nullable_to_non_nullable
              as String,
      rank: null == rank
          ? _value.rank
          : rank // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc

class _$ChallengeCompleteCheckInDataImpl
    implements _ChallengeCompleteCheckInData {
  const _$ChallengeCompleteCheckInDataImpl(
      {required this.challengeId,
      required this.challengeName,
      required this.rank});

  @override
  final String challengeId;
  @override
  final String challengeName;
  @override
  final int rank;

  @override
  String toString() {
    return 'CheckInData.challengeComplete(challengeId: $challengeId, challengeName: $challengeName, rank: $rank)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ChallengeCompleteCheckInDataImpl &&
            (identical(other.challengeId, challengeId) ||
                other.challengeId == challengeId) &&
            (identical(other.challengeName, challengeName) ||
                other.challengeName == challengeName) &&
            (identical(other.rank, rank) || other.rank == rank));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, challengeId, challengeName, rank);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ChallengeCompleteCheckInDataImplCopyWith<
          _$ChallengeCompleteCheckInDataImpl>
      get copyWith => __$$ChallengeCompleteCheckInDataImplCopyWithImpl<
          _$ChallengeCompleteCheckInDataImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
            int streakDays,
            int xpEarned,
            List<String> activitiesCompleted,
            int moodRating,
            String? reflection)
        daily,
    required TResult Function(
            int weeklyXP,
            int streakDays,
            int activitiesCompleted,
            Map<String, int> pillarXP,
            List<String> highlights,
            List<String> challenges,
            String? goalsForNextWeek)
        weekly,
    required TResult Function(
            String milestoneType, String milestoneName, int value)
        milestone,
    required TResult Function(int streakDays, String saveType) streakSave,
    required TResult Function(String achievementId, String achievementName)
        achievement,
    required TResult Function(
            String challengeId, String challengeName, int rank)
        challengeComplete,
    required TResult Function(String fromUserId, String message) encouragement,
  }) {
    return challengeComplete(challengeId, challengeName, rank);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(
            int streakDays,
            int xpEarned,
            List<String> activitiesCompleted,
            int moodRating,
            String? reflection)?
        daily,
    TResult? Function(
            int weeklyXP,
            int streakDays,
            int activitiesCompleted,
            Map<String, int> pillarXP,
            List<String> highlights,
            List<String> challenges,
            String? goalsForNextWeek)?
        weekly,
    TResult? Function(String milestoneType, String milestoneName, int value)?
        milestone,
    TResult? Function(int streakDays, String saveType)? streakSave,
    TResult? Function(String achievementId, String achievementName)?
        achievement,
    TResult? Function(String challengeId, String challengeName, int rank)?
        challengeComplete,
    TResult? Function(String fromUserId, String message)? encouragement,
  }) {
    return challengeComplete?.call(challengeId, challengeName, rank);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(
            int streakDays,
            int xpEarned,
            List<String> activitiesCompleted,
            int moodRating,
            String? reflection)?
        daily,
    TResult Function(
            int weeklyXP,
            int streakDays,
            int activitiesCompleted,
            Map<String, int> pillarXP,
            List<String> highlights,
            List<String> challenges,
            String? goalsForNextWeek)?
        weekly,
    TResult Function(String milestoneType, String milestoneName, int value)?
        milestone,
    TResult Function(int streakDays, String saveType)? streakSave,
    TResult Function(String achievementId, String achievementName)? achievement,
    TResult Function(String challengeId, String challengeName, int rank)?
        challengeComplete,
    TResult Function(String fromUserId, String message)? encouragement,
    required TResult orElse(),
  }) {
    if (challengeComplete != null) {
      return challengeComplete(challengeId, challengeName, rank);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_DailyCheckInData value) daily,
    required TResult Function(_WeeklyCheckInData value) weekly,
    required TResult Function(_MilestoneCheckInData value) milestone,
    required TResult Function(_StreakSaveCheckInData value) streakSave,
    required TResult Function(_AchievementCheckInData value) achievement,
    required TResult Function(_ChallengeCompleteCheckInData value)
        challengeComplete,
    required TResult Function(_EncouragementCheckInData value) encouragement,
  }) {
    return challengeComplete(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_DailyCheckInData value)? daily,
    TResult? Function(_WeeklyCheckInData value)? weekly,
    TResult? Function(_MilestoneCheckInData value)? milestone,
    TResult? Function(_StreakSaveCheckInData value)? streakSave,
    TResult? Function(_AchievementCheckInData value)? achievement,
    TResult? Function(_ChallengeCompleteCheckInData value)? challengeComplete,
    TResult? Function(_EncouragementCheckInData value)? encouragement,
  }) {
    return challengeComplete?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_DailyCheckInData value)? daily,
    TResult Function(_WeeklyCheckInData value)? weekly,
    TResult Function(_MilestoneCheckInData value)? milestone,
    TResult Function(_StreakSaveCheckInData value)? streakSave,
    TResult Function(_AchievementCheckInData value)? achievement,
    TResult Function(_ChallengeCompleteCheckInData value)? challengeComplete,
    TResult Function(_EncouragementCheckInData value)? encouragement,
    required TResult orElse(),
  }) {
    if (challengeComplete != null) {
      return challengeComplete(this);
    }
    return orElse();
  }
}

abstract class _ChallengeCompleteCheckInData implements CheckInData {
  const factory _ChallengeCompleteCheckInData(
      {required final String challengeId,
      required final String challengeName,
      required final int rank}) = _$ChallengeCompleteCheckInDataImpl;

  String get challengeId;
  String get challengeName;
  int get rank;
  @JsonKey(ignore: true)
  _$$ChallengeCompleteCheckInDataImplCopyWith<
          _$ChallengeCompleteCheckInDataImpl>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$EncouragementCheckInDataImplCopyWith<$Res> {
  factory _$$EncouragementCheckInDataImplCopyWith(
          _$EncouragementCheckInDataImpl value,
          $Res Function(_$EncouragementCheckInDataImpl) then) =
      __$$EncouragementCheckInDataImplCopyWithImpl<$Res>;
  @useResult
  $Res call({String fromUserId, String message});
}

/// @nodoc
class __$$EncouragementCheckInDataImplCopyWithImpl<$Res>
    extends _$CheckInDataCopyWithImpl<$Res, _$EncouragementCheckInDataImpl>
    implements _$$EncouragementCheckInDataImplCopyWith<$Res> {
  __$$EncouragementCheckInDataImplCopyWithImpl(
      _$EncouragementCheckInDataImpl _value,
      $Res Function(_$EncouragementCheckInDataImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? fromUserId = null,
    Object? message = null,
  }) {
    return _then(_$EncouragementCheckInDataImpl(
      fromUserId: null == fromUserId
          ? _value.fromUserId
          : fromUserId // ignore: cast_nullable_to_non_nullable
              as String,
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$EncouragementCheckInDataImpl implements _EncouragementCheckInData {
  const _$EncouragementCheckInDataImpl(
      {required this.fromUserId, required this.message});

  @override
  final String fromUserId;
  @override
  final String message;

  @override
  String toString() {
    return 'CheckInData.encouragement(fromUserId: $fromUserId, message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$EncouragementCheckInDataImpl &&
            (identical(other.fromUserId, fromUserId) ||
                other.fromUserId == fromUserId) &&
            (identical(other.message, message) || other.message == message));
  }

  @override
  int get hashCode => Object.hash(runtimeType, fromUserId, message);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$EncouragementCheckInDataImplCopyWith<_$EncouragementCheckInDataImpl>
      get copyWith => __$$EncouragementCheckInDataImplCopyWithImpl<
          _$EncouragementCheckInDataImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
            int streakDays,
            int xpEarned,
            List<String> activitiesCompleted,
            int moodRating,
            String? reflection)
        daily,
    required TResult Function(
            int weeklyXP,
            int streakDays,
            int activitiesCompleted,
            Map<String, int> pillarXP,
            List<String> highlights,
            List<String> challenges,
            String? goalsForNextWeek)
        weekly,
    required TResult Function(
            String milestoneType, String milestoneName, int value)
        milestone,
    required TResult Function(int streakDays, String saveType) streakSave,
    required TResult Function(String achievementId, String achievementName)
        achievement,
    required TResult Function(
            String challengeId, String challengeName, int rank)
        challengeComplete,
    required TResult Function(String fromUserId, String message) encouragement,
  }) {
    return encouragement(fromUserId, message);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(
            int streakDays,
            int xpEarned,
            List<String> activitiesCompleted,
            int moodRating,
            String? reflection)?
        daily,
    TResult? Function(
            int weeklyXP,
            int streakDays,
            int activitiesCompleted,
            Map<String, int> pillarXP,
            List<String> highlights,
            List<String> challenges,
            String? goalsForNextWeek)?
        weekly,
    TResult? Function(String milestoneType, String milestoneName, int value)?
        milestone,
    TResult? Function(int streakDays, String saveType)? streakSave,
    TResult? Function(String achievementId, String achievementName)?
        achievement,
    TResult? Function(String challengeId, String challengeName, int rank)?
        challengeComplete,
    TResult? Function(String fromUserId, String message)? encouragement,
  }) {
    return encouragement?.call(fromUserId, message);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(
            int streakDays,
            int xpEarned,
            List<String> activitiesCompleted,
            int moodRating,
            String? reflection)?
        daily,
    TResult Function(
            int weeklyXP,
            int streakDays,
            int activitiesCompleted,
            Map<String, int> pillarXP,
            List<String> highlights,
            List<String> challenges,
            String? goalsForNextWeek)?
        weekly,
    TResult Function(String milestoneType, String milestoneName, int value)?
        milestone,
    TResult Function(int streakDays, String saveType)? streakSave,
    TResult Function(String achievementId, String achievementName)? achievement,
    TResult Function(String challengeId, String challengeName, int rank)?
        challengeComplete,
    TResult Function(String fromUserId, String message)? encouragement,
    required TResult orElse(),
  }) {
    if (encouragement != null) {
      return encouragement(fromUserId, message);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_DailyCheckInData value) daily,
    required TResult Function(_WeeklyCheckInData value) weekly,
    required TResult Function(_MilestoneCheckInData value) milestone,
    required TResult Function(_StreakSaveCheckInData value) streakSave,
    required TResult Function(_AchievementCheckInData value) achievement,
    required TResult Function(_ChallengeCompleteCheckInData value)
        challengeComplete,
    required TResult Function(_EncouragementCheckInData value) encouragement,
  }) {
    return encouragement(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_DailyCheckInData value)? daily,
    TResult? Function(_WeeklyCheckInData value)? weekly,
    TResult? Function(_MilestoneCheckInData value)? milestone,
    TResult? Function(_StreakSaveCheckInData value)? streakSave,
    TResult? Function(_AchievementCheckInData value)? achievement,
    TResult? Function(_ChallengeCompleteCheckInData value)? challengeComplete,
    TResult? Function(_EncouragementCheckInData value)? encouragement,
  }) {
    return encouragement?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_DailyCheckInData value)? daily,
    TResult Function(_WeeklyCheckInData value)? weekly,
    TResult Function(_MilestoneCheckInData value)? milestone,
    TResult Function(_StreakSaveCheckInData value)? streakSave,
    TResult Function(_AchievementCheckInData value)? achievement,
    TResult Function(_ChallengeCompleteCheckInData value)? challengeComplete,
    TResult Function(_EncouragementCheckInData value)? encouragement,
    required TResult orElse(),
  }) {
    if (encouragement != null) {
      return encouragement(this);
    }
    return orElse();
  }
}

abstract class _EncouragementCheckInData implements CheckInData {
  const factory _EncouragementCheckInData(
      {required final String fromUserId,
      required final String message}) = _$EncouragementCheckInDataImpl;

  String get fromUserId;
  String get message;
  @JsonKey(ignore: true)
  _$$EncouragementCheckInDataImplCopyWith<_$EncouragementCheckInDataImpl>
      get copyWith => throw _privateConstructorUsedError;
}

CheckInComment _$CheckInCommentFromJson(Map<String, dynamic> json) {
  return _CheckInComment.fromJson(json);
}

/// @nodoc
mixin _$CheckInComment {
  String get id => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  String get content => throw _privateConstructorUsedError;
  DateTime get timestamp => throw _privateConstructorUsedError;
  List<String> get reactions => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $CheckInCommentCopyWith<CheckInComment> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CheckInCommentCopyWith<$Res> {
  factory $CheckInCommentCopyWith(
          CheckInComment value, $Res Function(CheckInComment) then) =
      _$CheckInCommentCopyWithImpl<$Res, CheckInComment>;
  @useResult
  $Res call(
      {String id,
      String userId,
      String content,
      DateTime timestamp,
      List<String> reactions});
}

/// @nodoc
class _$CheckInCommentCopyWithImpl<$Res, $Val extends CheckInComment>
    implements $CheckInCommentCopyWith<$Res> {
  _$CheckInCommentCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? content = null,
    Object? timestamp = null,
    Object? reactions = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      content: null == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as String,
      timestamp: null == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as DateTime,
      reactions: null == reactions
          ? _value.reactions
          : reactions // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CheckInCommentImplCopyWith<$Res>
    implements $CheckInCommentCopyWith<$Res> {
  factory _$$CheckInCommentImplCopyWith(_$CheckInCommentImpl value,
          $Res Function(_$CheckInCommentImpl) then) =
      __$$CheckInCommentImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String userId,
      String content,
      DateTime timestamp,
      List<String> reactions});
}

/// @nodoc
class __$$CheckInCommentImplCopyWithImpl<$Res>
    extends _$CheckInCommentCopyWithImpl<$Res, _$CheckInCommentImpl>
    implements _$$CheckInCommentImplCopyWith<$Res> {
  __$$CheckInCommentImplCopyWithImpl(
      _$CheckInCommentImpl _value, $Res Function(_$CheckInCommentImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? content = null,
    Object? timestamp = null,
    Object? reactions = null,
  }) {
    return _then(_$CheckInCommentImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      content: null == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as String,
      timestamp: null == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as DateTime,
      reactions: null == reactions
          ? _value._reactions
          : reactions // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CheckInCommentImpl implements _CheckInComment {
  const _$CheckInCommentImpl(
      {required this.id,
      required this.userId,
      required this.content,
      required this.timestamp,
      required final List<String> reactions})
      : _reactions = reactions;

  factory _$CheckInCommentImpl.fromJson(Map<String, dynamic> json) =>
      _$$CheckInCommentImplFromJson(json);

  @override
  final String id;
  @override
  final String userId;
  @override
  final String content;
  @override
  final DateTime timestamp;
  final List<String> _reactions;
  @override
  List<String> get reactions {
    if (_reactions is EqualUnmodifiableListView) return _reactions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_reactions);
  }

  @override
  String toString() {
    return 'CheckInComment(id: $id, userId: $userId, content: $content, timestamp: $timestamp, reactions: $reactions)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CheckInCommentImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.content, content) || other.content == content) &&
            (identical(other.timestamp, timestamp) ||
                other.timestamp == timestamp) &&
            const DeepCollectionEquality()
                .equals(other._reactions, _reactions));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, userId, content, timestamp,
      const DeepCollectionEquality().hash(_reactions));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$CheckInCommentImplCopyWith<_$CheckInCommentImpl> get copyWith =>
      __$$CheckInCommentImplCopyWithImpl<_$CheckInCommentImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CheckInCommentImplToJson(
      this,
    );
  }
}

abstract class _CheckInComment implements CheckInComment {
  const factory _CheckInComment(
      {required final String id,
      required final String userId,
      required final String content,
      required final DateTime timestamp,
      required final List<String> reactions}) = _$CheckInCommentImpl;

  factory _CheckInComment.fromJson(Map<String, dynamic> json) =
      _$CheckInCommentImpl.fromJson;

  @override
  String get id;
  @override
  String get userId;
  @override
  String get content;
  @override
  DateTime get timestamp;
  @override
  List<String> get reactions;
  @override
  @JsonKey(ignore: true)
  _$$CheckInCommentImplCopyWith<_$CheckInCommentImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

SocialAchievement _$SocialAchievementFromJson(Map<String, dynamic> json) {
  return _SocialAchievement.fromJson(json);
}

/// @nodoc
mixin _$SocialAchievement {
  String get id => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  SocialAchievementType get type => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  DateTime get unlockedAt => throw _privateConstructorUsedError;
  Map<String, dynamic> get metadata => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $SocialAchievementCopyWith<SocialAchievement> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SocialAchievementCopyWith<$Res> {
  factory $SocialAchievementCopyWith(
          SocialAchievement value, $Res Function(SocialAchievement) then) =
      _$SocialAchievementCopyWithImpl<$Res, SocialAchievement>;
  @useResult
  $Res call(
      {String id,
      String userId,
      SocialAchievementType type,
      String name,
      String description,
      DateTime unlockedAt,
      Map<String, dynamic> metadata});
}

/// @nodoc
class _$SocialAchievementCopyWithImpl<$Res, $Val extends SocialAchievement>
    implements $SocialAchievementCopyWith<$Res> {
  _$SocialAchievementCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? type = null,
    Object? name = null,
    Object? description = null,
    Object? unlockedAt = null,
    Object? metadata = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as SocialAchievementType,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      unlockedAt: null == unlockedAt
          ? _value.unlockedAt
          : unlockedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      metadata: null == metadata
          ? _value.metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SocialAchievementImplCopyWith<$Res>
    implements $SocialAchievementCopyWith<$Res> {
  factory _$$SocialAchievementImplCopyWith(_$SocialAchievementImpl value,
          $Res Function(_$SocialAchievementImpl) then) =
      __$$SocialAchievementImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String userId,
      SocialAchievementType type,
      String name,
      String description,
      DateTime unlockedAt,
      Map<String, dynamic> metadata});
}

/// @nodoc
class __$$SocialAchievementImplCopyWithImpl<$Res>
    extends _$SocialAchievementCopyWithImpl<$Res, _$SocialAchievementImpl>
    implements _$$SocialAchievementImplCopyWith<$Res> {
  __$$SocialAchievementImplCopyWithImpl(_$SocialAchievementImpl _value,
      $Res Function(_$SocialAchievementImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? type = null,
    Object? name = null,
    Object? description = null,
    Object? unlockedAt = null,
    Object? metadata = null,
  }) {
    return _then(_$SocialAchievementImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as SocialAchievementType,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      unlockedAt: null == unlockedAt
          ? _value.unlockedAt
          : unlockedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      metadata: null == metadata
          ? _value._metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SocialAchievementImpl implements _SocialAchievement {
  const _$SocialAchievementImpl(
      {required this.id,
      required this.userId,
      required this.type,
      required this.name,
      required this.description,
      required this.unlockedAt,
      required final Map<String, dynamic> metadata})
      : _metadata = metadata;

  factory _$SocialAchievementImpl.fromJson(Map<String, dynamic> json) =>
      _$$SocialAchievementImplFromJson(json);

  @override
  final String id;
  @override
  final String userId;
  @override
  final SocialAchievementType type;
  @override
  final String name;
  @override
  final String description;
  @override
  final DateTime unlockedAt;
  final Map<String, dynamic> _metadata;
  @override
  Map<String, dynamic> get metadata {
    if (_metadata is EqualUnmodifiableMapView) return _metadata;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_metadata);
  }

  @override
  String toString() {
    return 'SocialAchievement(id: $id, userId: $userId, type: $type, name: $name, description: $description, unlockedAt: $unlockedAt, metadata: $metadata)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SocialAchievementImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.unlockedAt, unlockedAt) ||
                other.unlockedAt == unlockedAt) &&
            const DeepCollectionEquality().equals(other._metadata, _metadata));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, userId, type, name,
      description, unlockedAt, const DeepCollectionEquality().hash(_metadata));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$SocialAchievementImplCopyWith<_$SocialAchievementImpl> get copyWith =>
      __$$SocialAchievementImplCopyWithImpl<_$SocialAchievementImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SocialAchievementImplToJson(
      this,
    );
  }
}

abstract class _SocialAchievement implements SocialAchievement {
  const factory _SocialAchievement(
      {required final String id,
      required final String userId,
      required final SocialAchievementType type,
      required final String name,
      required final String description,
      required final DateTime unlockedAt,
      required final Map<String, dynamic> metadata}) = _$SocialAchievementImpl;

  factory _SocialAchievement.fromJson(Map<String, dynamic> json) =
      _$SocialAchievementImpl.fromJson;

  @override
  String get id;
  @override
  String get userId;
  @override
  SocialAchievementType get type;
  @override
  String get name;
  @override
  String get description;
  @override
  DateTime get unlockedAt;
  @override
  Map<String, dynamic> get metadata;
  @override
  @JsonKey(ignore: true)
  _$$SocialAchievementImplCopyWith<_$SocialAchievementImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

SocialSettings _$SocialSettingsFromJson(Map<String, dynamic> json) {
  return _SocialSettings.fromJson(json);
}

/// @nodoc
mixin _$SocialSettings {
  bool get buddyRequestsEnabled => throw _privateConstructorUsedError;
  bool get teamJoinEnabled => throw _privateConstructorUsedError;
  bool get publicProfile => throw _privateConstructorUsedError;
  bool get showOnLeaderboard => throw _privateConstructorUsedError;
  bool get allowDirectMessages => throw _privateConstructorUsedError;
  bool get notificationsEnabled => throw _privateConstructorUsedError;
  int get maxBuddies => throw _privateConstructorUsedError;
  int get maxTeams => throw _privateConstructorUsedError;
  String? get statusMessage => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $SocialSettingsCopyWith<SocialSettings> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SocialSettingsCopyWith<$Res> {
  factory $SocialSettingsCopyWith(
          SocialSettings value, $Res Function(SocialSettings) then) =
      _$SocialSettingsCopyWithImpl<$Res, SocialSettings>;
  @useResult
  $Res call(
      {bool buddyRequestsEnabled,
      bool teamJoinEnabled,
      bool publicProfile,
      bool showOnLeaderboard,
      bool allowDirectMessages,
      bool notificationsEnabled,
      int maxBuddies,
      int maxTeams,
      String? statusMessage});
}

/// @nodoc
class _$SocialSettingsCopyWithImpl<$Res, $Val extends SocialSettings>
    implements $SocialSettingsCopyWith<$Res> {
  _$SocialSettingsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? buddyRequestsEnabled = null,
    Object? teamJoinEnabled = null,
    Object? publicProfile = null,
    Object? showOnLeaderboard = null,
    Object? allowDirectMessages = null,
    Object? notificationsEnabled = null,
    Object? maxBuddies = null,
    Object? maxTeams = null,
    Object? statusMessage = freezed,
  }) {
    return _then(_value.copyWith(
      buddyRequestsEnabled: null == buddyRequestsEnabled
          ? _value.buddyRequestsEnabled
          : buddyRequestsEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      teamJoinEnabled: null == teamJoinEnabled
          ? _value.teamJoinEnabled
          : teamJoinEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      publicProfile: null == publicProfile
          ? _value.publicProfile
          : publicProfile // ignore: cast_nullable_to_non_nullable
              as bool,
      showOnLeaderboard: null == showOnLeaderboard
          ? _value.showOnLeaderboard
          : showOnLeaderboard // ignore: cast_nullable_to_non_nullable
              as bool,
      allowDirectMessages: null == allowDirectMessages
          ? _value.allowDirectMessages
          : allowDirectMessages // ignore: cast_nullable_to_non_nullable
              as bool,
      notificationsEnabled: null == notificationsEnabled
          ? _value.notificationsEnabled
          : notificationsEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      maxBuddies: null == maxBuddies
          ? _value.maxBuddies
          : maxBuddies // ignore: cast_nullable_to_non_nullable
              as int,
      maxTeams: null == maxTeams
          ? _value.maxTeams
          : maxTeams // ignore: cast_nullable_to_non_nullable
              as int,
      statusMessage: freezed == statusMessage
          ? _value.statusMessage
          : statusMessage // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SocialSettingsImplCopyWith<$Res>
    implements $SocialSettingsCopyWith<$Res> {
  factory _$$SocialSettingsImplCopyWith(_$SocialSettingsImpl value,
          $Res Function(_$SocialSettingsImpl) then) =
      __$$SocialSettingsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {bool buddyRequestsEnabled,
      bool teamJoinEnabled,
      bool publicProfile,
      bool showOnLeaderboard,
      bool allowDirectMessages,
      bool notificationsEnabled,
      int maxBuddies,
      int maxTeams,
      String? statusMessage});
}

/// @nodoc
class __$$SocialSettingsImplCopyWithImpl<$Res>
    extends _$SocialSettingsCopyWithImpl<$Res, _$SocialSettingsImpl>
    implements _$$SocialSettingsImplCopyWith<$Res> {
  __$$SocialSettingsImplCopyWithImpl(
      _$SocialSettingsImpl _value, $Res Function(_$SocialSettingsImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? buddyRequestsEnabled = null,
    Object? teamJoinEnabled = null,
    Object? publicProfile = null,
    Object? showOnLeaderboard = null,
    Object? allowDirectMessages = null,
    Object? notificationsEnabled = null,
    Object? maxBuddies = null,
    Object? maxTeams = null,
    Object? statusMessage = freezed,
  }) {
    return _then(_$SocialSettingsImpl(
      buddyRequestsEnabled: null == buddyRequestsEnabled
          ? _value.buddyRequestsEnabled
          : buddyRequestsEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      teamJoinEnabled: null == teamJoinEnabled
          ? _value.teamJoinEnabled
          : teamJoinEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      publicProfile: null == publicProfile
          ? _value.publicProfile
          : publicProfile // ignore: cast_nullable_to_non_nullable
              as bool,
      showOnLeaderboard: null == showOnLeaderboard
          ? _value.showOnLeaderboard
          : showOnLeaderboard // ignore: cast_nullable_to_non_nullable
              as bool,
      allowDirectMessages: null == allowDirectMessages
          ? _value.allowDirectMessages
          : allowDirectMessages // ignore: cast_nullable_to_non_nullable
              as bool,
      notificationsEnabled: null == notificationsEnabled
          ? _value.notificationsEnabled
          : notificationsEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      maxBuddies: null == maxBuddies
          ? _value.maxBuddies
          : maxBuddies // ignore: cast_nullable_to_non_nullable
              as int,
      maxTeams: null == maxTeams
          ? _value.maxTeams
          : maxTeams // ignore: cast_nullable_to_non_nullable
              as int,
      statusMessage: freezed == statusMessage
          ? _value.statusMessage
          : statusMessage // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SocialSettingsImpl implements _SocialSettings {
  const _$SocialSettingsImpl(
      {required this.buddyRequestsEnabled,
      required this.teamJoinEnabled,
      required this.publicProfile,
      required this.showOnLeaderboard,
      required this.allowDirectMessages,
      required this.notificationsEnabled,
      required this.maxBuddies,
      required this.maxTeams,
      required this.statusMessage});

  factory _$SocialSettingsImpl.fromJson(Map<String, dynamic> json) =>
      _$$SocialSettingsImplFromJson(json);

  @override
  final bool buddyRequestsEnabled;
  @override
  final bool teamJoinEnabled;
  @override
  final bool publicProfile;
  @override
  final bool showOnLeaderboard;
  @override
  final bool allowDirectMessages;
  @override
  final bool notificationsEnabled;
  @override
  final int maxBuddies;
  @override
  final int maxTeams;
  @override
  final String? statusMessage;

  @override
  String toString() {
    return 'SocialSettings(buddyRequestsEnabled: $buddyRequestsEnabled, teamJoinEnabled: $teamJoinEnabled, publicProfile: $publicProfile, showOnLeaderboard: $showOnLeaderboard, allowDirectMessages: $allowDirectMessages, notificationsEnabled: $notificationsEnabled, maxBuddies: $maxBuddies, maxTeams: $maxTeams, statusMessage: $statusMessage)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SocialSettingsImpl &&
            (identical(other.buddyRequestsEnabled, buddyRequestsEnabled) ||
                other.buddyRequestsEnabled == buddyRequestsEnabled) &&
            (identical(other.teamJoinEnabled, teamJoinEnabled) ||
                other.teamJoinEnabled == teamJoinEnabled) &&
            (identical(other.publicProfile, publicProfile) ||
                other.publicProfile == publicProfile) &&
            (identical(other.showOnLeaderboard, showOnLeaderboard) ||
                other.showOnLeaderboard == showOnLeaderboard) &&
            (identical(other.allowDirectMessages, allowDirectMessages) ||
                other.allowDirectMessages == allowDirectMessages) &&
            (identical(other.notificationsEnabled, notificationsEnabled) ||
                other.notificationsEnabled == notificationsEnabled) &&
            (identical(other.maxBuddies, maxBuddies) ||
                other.maxBuddies == maxBuddies) &&
            (identical(other.maxTeams, maxTeams) ||
                other.maxTeams == maxTeams) &&
            (identical(other.statusMessage, statusMessage) ||
                other.statusMessage == statusMessage));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      buddyRequestsEnabled,
      teamJoinEnabled,
      publicProfile,
      showOnLeaderboard,
      allowDirectMessages,
      notificationsEnabled,
      maxBuddies,
      maxTeams,
      statusMessage);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$SocialSettingsImplCopyWith<_$SocialSettingsImpl> get copyWith =>
      __$$SocialSettingsImplCopyWithImpl<_$SocialSettingsImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SocialSettingsImplToJson(
      this,
    );
  }
}

abstract class _SocialSettings implements SocialSettings {
  const factory _SocialSettings(
      {required final bool buddyRequestsEnabled,
      required final bool teamJoinEnabled,
      required final bool publicProfile,
      required final bool showOnLeaderboard,
      required final bool allowDirectMessages,
      required final bool notificationsEnabled,
      required final int maxBuddies,
      required final int maxTeams,
      required final String? statusMessage}) = _$SocialSettingsImpl;

  factory _SocialSettings.fromJson(Map<String, dynamic> json) =
      _$SocialSettingsImpl.fromJson;

  @override
  bool get buddyRequestsEnabled;
  @override
  bool get teamJoinEnabled;
  @override
  bool get publicProfile;
  @override
  bool get showOnLeaderboard;
  @override
  bool get allowDirectMessages;
  @override
  bool get notificationsEnabled;
  @override
  int get maxBuddies;
  @override
  int get maxTeams;
  @override
  String? get statusMessage;
  @override
  @JsonKey(ignore: true)
  _$$SocialSettingsImplCopyWith<_$SocialSettingsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
