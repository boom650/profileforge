// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'streak.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Streak _$StreakFromJson(Map<String, dynamic> json) {
  return _Streak.fromJson(json);
}

/// @nodoc
mixin _$Streak {
  int get currentStreak => throw _privateConstructorUsedError;
  int get longestStreak => throw _privateConstructorUsedError;
  int get totalActiveDays => throw _privateConstructorUsedError;
  int get freezeTokens => throw _privateConstructorUsedError;
  int get maxFreezeTokens => throw _privateConstructorUsedError;
  int get freezeTokensEarned => throw _privateConstructorUsedError;
  int get graceDaysRemaining => throw _privateConstructorUsedError;
  int get graceDaysUsedThisWeek => throw _privateConstructorUsedError;
  DateTime? get lastActiveDate => throw _privateConstructorUsedError;
  DateTime? get streakStartDate => throw _privateConstructorUsedError;
  List<StreakMilestone> get milestonesAchieved =>
      throw _privateConstructorUsedError;
  List<GraceDayUsage> get graceDayHistory => throw _privateConstructorUsedError;
  DateTime? get lastFreezeTokenEarned => throw _privateConstructorUsedError;
  int get weeklyCheckInTarget => throw _privateConstructorUsedError;
  int get weeklyCheckInsCompleted => throw _privateConstructorUsedError;
  DateTime get lastWeekReset => throw _privateConstructorUsedError;
  bool get hasWeekendAmulet => throw _privateConstructorUsedError;
  DateTime? get weekendAmuletExpiresAt => throw _privateConstructorUsedError;
  List<int> get weeklyActivityPattern => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $StreakCopyWith<Streak> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $StreakCopyWith<$Res> {
  factory $StreakCopyWith(Streak value, $Res Function(Streak) then) =
      _$StreakCopyWithImpl<$Res, Streak>;
  @useResult
  $Res call(
      {int currentStreak,
      int longestStreak,
      int totalActiveDays,
      int freezeTokens,
      int maxFreezeTokens,
      int freezeTokensEarned,
      int graceDaysRemaining,
      int graceDaysUsedThisWeek,
      DateTime? lastActiveDate,
      DateTime? streakStartDate,
      List<StreakMilestone> milestonesAchieved,
      List<GraceDayUsage> graceDayHistory,
      DateTime? lastFreezeTokenEarned,
      int weeklyCheckInTarget,
      int weeklyCheckInsCompleted,
      DateTime lastWeekReset,
      bool hasWeekendAmulet,
      DateTime? weekendAmuletExpiresAt,
      List<int> weeklyActivityPattern});
}

/// @nodoc
class _$StreakCopyWithImpl<$Res, $Val extends Streak>
    implements $StreakCopyWith<$Res> {
  _$StreakCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? currentStreak = null,
    Object? longestStreak = null,
    Object? totalActiveDays = null,
    Object? freezeTokens = null,
    Object? maxFreezeTokens = null,
    Object? freezeTokensEarned = null,
    Object? graceDaysRemaining = null,
    Object? graceDaysUsedThisWeek = null,
    Object? lastActiveDate = freezed,
    Object? streakStartDate = freezed,
    Object? milestonesAchieved = null,
    Object? graceDayHistory = null,
    Object? lastFreezeTokenEarned = freezed,
    Object? weeklyCheckInTarget = null,
    Object? weeklyCheckInsCompleted = null,
    Object? lastWeekReset = null,
    Object? hasWeekendAmulet = null,
    Object? weekendAmuletExpiresAt = freezed,
    Object? weeklyActivityPattern = null,
  }) {
    return _then(_value.copyWith(
      currentStreak: null == currentStreak
          ? _value.currentStreak
          : currentStreak // ignore: cast_nullable_to_non_nullable
              as int,
      longestStreak: null == longestStreak
          ? _value.longestStreak
          : longestStreak // ignore: cast_nullable_to_non_nullable
              as int,
      totalActiveDays: null == totalActiveDays
          ? _value.totalActiveDays
          : totalActiveDays // ignore: cast_nullable_to_non_nullable
              as int,
      freezeTokens: null == freezeTokens
          ? _value.freezeTokens
          : freezeTokens // ignore: cast_nullable_to_non_nullable
              as int,
      maxFreezeTokens: null == maxFreezeTokens
          ? _value.maxFreezeTokens
          : maxFreezeTokens // ignore: cast_nullable_to_non_nullable
              as int,
      freezeTokensEarned: null == freezeTokensEarned
          ? _value.freezeTokensEarned
          : freezeTokensEarned // ignore: cast_nullable_to_non_nullable
              as int,
      graceDaysRemaining: null == graceDaysRemaining
          ? _value.graceDaysRemaining
          : graceDaysRemaining // ignore: cast_nullable_to_non_nullable
              as int,
      graceDaysUsedThisWeek: null == graceDaysUsedThisWeek
          ? _value.graceDaysUsedThisWeek
          : graceDaysUsedThisWeek // ignore: cast_nullable_to_non_nullable
              as int,
      lastActiveDate: freezed == lastActiveDate
          ? _value.lastActiveDate
          : lastActiveDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      streakStartDate: freezed == streakStartDate
          ? _value.streakStartDate
          : streakStartDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      milestonesAchieved: null == milestonesAchieved
          ? _value.milestonesAchieved
          : milestonesAchieved // ignore: cast_nullable_to_non_nullable
              as List<StreakMilestone>,
      graceDayHistory: null == graceDayHistory
          ? _value.graceDayHistory
          : graceDayHistory // ignore: cast_nullable_to_non_nullable
              as List<GraceDayUsage>,
      lastFreezeTokenEarned: freezed == lastFreezeTokenEarned
          ? _value.lastFreezeTokenEarned
          : lastFreezeTokenEarned // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      weeklyCheckInTarget: null == weeklyCheckInTarget
          ? _value.weeklyCheckInTarget
          : weeklyCheckInTarget // ignore: cast_nullable_to_non_nullable
              as int,
      weeklyCheckInsCompleted: null == weeklyCheckInsCompleted
          ? _value.weeklyCheckInsCompleted
          : weeklyCheckInsCompleted // ignore: cast_nullable_to_non_nullable
              as int,
      lastWeekReset: null == lastWeekReset
          ? _value.lastWeekReset
          : lastWeekReset // ignore: cast_nullable_to_non_nullable
              as DateTime,
      hasWeekendAmulet: null == hasWeekendAmulet
          ? _value.hasWeekendAmulet
          : hasWeekendAmulet // ignore: cast_nullable_to_non_nullable
              as bool,
      weekendAmuletExpiresAt: freezed == weekendAmuletExpiresAt
          ? _value.weekendAmuletExpiresAt
          : weekendAmuletExpiresAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      weeklyActivityPattern: null == weeklyActivityPattern
          ? _value.weeklyActivityPattern
          : weeklyActivityPattern // ignore: cast_nullable_to_non_nullable
              as List<int>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$StreakImplCopyWith<$Res> implements $StreakCopyWith<$Res> {
  factory _$$StreakImplCopyWith(
          _$StreakImpl value, $Res Function(_$StreakImpl) then) =
      __$$StreakImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int currentStreak,
      int longestStreak,
      int totalActiveDays,
      int freezeTokens,
      int maxFreezeTokens,
      int freezeTokensEarned,
      int graceDaysRemaining,
      int graceDaysUsedThisWeek,
      DateTime? lastActiveDate,
      DateTime? streakStartDate,
      List<StreakMilestone> milestonesAchieved,
      List<GraceDayUsage> graceDayHistory,
      DateTime? lastFreezeTokenEarned,
      int weeklyCheckInTarget,
      int weeklyCheckInsCompleted,
      DateTime lastWeekReset,
      bool hasWeekendAmulet,
      DateTime? weekendAmuletExpiresAt,
      List<int> weeklyActivityPattern});
}

/// @nodoc
class __$$StreakImplCopyWithImpl<$Res>
    extends _$StreakCopyWithImpl<$Res, _$StreakImpl>
    implements _$$StreakImplCopyWith<$Res> {
  __$$StreakImplCopyWithImpl(
      _$StreakImpl _value, $Res Function(_$StreakImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? currentStreak = null,
    Object? longestStreak = null,
    Object? totalActiveDays = null,
    Object? freezeTokens = null,
    Object? maxFreezeTokens = null,
    Object? freezeTokensEarned = null,
    Object? graceDaysRemaining = null,
    Object? graceDaysUsedThisWeek = null,
    Object? lastActiveDate = freezed,
    Object? streakStartDate = freezed,
    Object? milestonesAchieved = null,
    Object? graceDayHistory = null,
    Object? lastFreezeTokenEarned = freezed,
    Object? weeklyCheckInTarget = null,
    Object? weeklyCheckInsCompleted = null,
    Object? lastWeekReset = null,
    Object? hasWeekendAmulet = null,
    Object? weekendAmuletExpiresAt = freezed,
    Object? weeklyActivityPattern = null,
  }) {
    return _then(_$StreakImpl(
      currentStreak: null == currentStreak
          ? _value.currentStreak
          : currentStreak // ignore: cast_nullable_to_non_nullable
              as int,
      longestStreak: null == longestStreak
          ? _value.longestStreak
          : longestStreak // ignore: cast_nullable_to_non_nullable
              as int,
      totalActiveDays: null == totalActiveDays
          ? _value.totalActiveDays
          : totalActiveDays // ignore: cast_nullable_to_non_nullable
              as int,
      freezeTokens: null == freezeTokens
          ? _value.freezeTokens
          : freezeTokens // ignore: cast_nullable_to_non_nullable
              as int,
      maxFreezeTokens: null == maxFreezeTokens
          ? _value.maxFreezeTokens
          : maxFreezeTokens // ignore: cast_nullable_to_non_nullable
              as int,
      freezeTokensEarned: null == freezeTokensEarned
          ? _value.freezeTokensEarned
          : freezeTokensEarned // ignore: cast_nullable_to_non_nullable
              as int,
      graceDaysRemaining: null == graceDaysRemaining
          ? _value.graceDaysRemaining
          : graceDaysRemaining // ignore: cast_nullable_to_non_nullable
              as int,
      graceDaysUsedThisWeek: null == graceDaysUsedThisWeek
          ? _value.graceDaysUsedThisWeek
          : graceDaysUsedThisWeek // ignore: cast_nullable_to_non_nullable
              as int,
      lastActiveDate: freezed == lastActiveDate
          ? _value.lastActiveDate
          : lastActiveDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      streakStartDate: freezed == streakStartDate
          ? _value.streakStartDate
          : streakStartDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      milestonesAchieved: null == milestonesAchieved
          ? _value._milestonesAchieved
          : milestonesAchieved // ignore: cast_nullable_to_non_nullable
              as List<StreakMilestone>,
      graceDayHistory: null == graceDayHistory
          ? _value._graceDayHistory
          : graceDayHistory // ignore: cast_nullable_to_non_nullable
              as List<GraceDayUsage>,
      lastFreezeTokenEarned: freezed == lastFreezeTokenEarned
          ? _value.lastFreezeTokenEarned
          : lastFreezeTokenEarned // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      weeklyCheckInTarget: null == weeklyCheckInTarget
          ? _value.weeklyCheckInTarget
          : weeklyCheckInTarget // ignore: cast_nullable_to_non_nullable
              as int,
      weeklyCheckInsCompleted: null == weeklyCheckInsCompleted
          ? _value.weeklyCheckInsCompleted
          : weeklyCheckInsCompleted // ignore: cast_nullable_to_non_nullable
              as int,
      lastWeekReset: null == lastWeekReset
          ? _value.lastWeekReset
          : lastWeekReset // ignore: cast_nullable_to_non_nullable
              as DateTime,
      hasWeekendAmulet: null == hasWeekendAmulet
          ? _value.hasWeekendAmulet
          : hasWeekendAmulet // ignore: cast_nullable_to_non_nullable
              as bool,
      weekendAmuletExpiresAt: freezed == weekendAmuletExpiresAt
          ? _value.weekendAmuletExpiresAt
          : weekendAmuletExpiresAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      weeklyActivityPattern: null == weeklyActivityPattern
          ? _value._weeklyActivityPattern
          : weeklyActivityPattern // ignore: cast_nullable_to_non_nullable
              as List<int>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$StreakImpl implements _Streak {
  const _$StreakImpl(
      {required this.currentStreak,
      required this.longestStreak,
      required this.totalActiveDays,
      required this.freezeTokens,
      required this.maxFreezeTokens,
      required this.freezeTokensEarned,
      required this.graceDaysRemaining,
      required this.graceDaysUsedThisWeek,
      required this.lastActiveDate,
      required this.streakStartDate,
      required final List<StreakMilestone> milestonesAchieved,
      required final List<GraceDayUsage> graceDayHistory,
      required this.lastFreezeTokenEarned,
      required this.weeklyCheckInTarget,
      required this.weeklyCheckInsCompleted,
      required this.lastWeekReset,
      required this.hasWeekendAmulet,
      required this.weekendAmuletExpiresAt,
      required final List<int> weeklyActivityPattern})
      : _milestonesAchieved = milestonesAchieved,
        _graceDayHistory = graceDayHistory,
        _weeklyActivityPattern = weeklyActivityPattern;

  factory _$StreakImpl.fromJson(Map<String, dynamic> json) =>
      _$$StreakImplFromJson(json);

  @override
  final int currentStreak;
  @override
  final int longestStreak;
  @override
  final int totalActiveDays;
  @override
  final int freezeTokens;
  @override
  final int maxFreezeTokens;
  @override
  final int freezeTokensEarned;
  @override
  final int graceDaysRemaining;
  @override
  final int graceDaysUsedThisWeek;
  @override
  final DateTime? lastActiveDate;
  @override
  final DateTime? streakStartDate;
  final List<StreakMilestone> _milestonesAchieved;
  @override
  List<StreakMilestone> get milestonesAchieved {
    if (_milestonesAchieved is EqualUnmodifiableListView)
      return _milestonesAchieved;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_milestonesAchieved);
  }

  final List<GraceDayUsage> _graceDayHistory;
  @override
  List<GraceDayUsage> get graceDayHistory {
    if (_graceDayHistory is EqualUnmodifiableListView) return _graceDayHistory;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_graceDayHistory);
  }

  @override
  final DateTime? lastFreezeTokenEarned;
  @override
  final int weeklyCheckInTarget;
  @override
  final int weeklyCheckInsCompleted;
  @override
  final DateTime lastWeekReset;
  @override
  final bool hasWeekendAmulet;
  @override
  final DateTime? weekendAmuletExpiresAt;
  final List<int> _weeklyActivityPattern;
  @override
  List<int> get weeklyActivityPattern {
    if (_weeklyActivityPattern is EqualUnmodifiableListView)
      return _weeklyActivityPattern;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_weeklyActivityPattern);
  }

  @override
  String toString() {
    return 'Streak(currentStreak: $currentStreak, longestStreak: $longestStreak, totalActiveDays: $totalActiveDays, freezeTokens: $freezeTokens, maxFreezeTokens: $maxFreezeTokens, freezeTokensEarned: $freezeTokensEarned, graceDaysRemaining: $graceDaysRemaining, graceDaysUsedThisWeek: $graceDaysUsedThisWeek, lastActiveDate: $lastActiveDate, streakStartDate: $streakStartDate, milestonesAchieved: $milestonesAchieved, graceDayHistory: $graceDayHistory, lastFreezeTokenEarned: $lastFreezeTokenEarned, weeklyCheckInTarget: $weeklyCheckInTarget, weeklyCheckInsCompleted: $weeklyCheckInsCompleted, lastWeekReset: $lastWeekReset, hasWeekendAmulet: $hasWeekendAmulet, weekendAmuletExpiresAt: $weekendAmuletExpiresAt, weeklyActivityPattern: $weeklyActivityPattern)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StreakImpl &&
            (identical(other.currentStreak, currentStreak) ||
                other.currentStreak == currentStreak) &&
            (identical(other.longestStreak, longestStreak) ||
                other.longestStreak == longestStreak) &&
            (identical(other.totalActiveDays, totalActiveDays) ||
                other.totalActiveDays == totalActiveDays) &&
            (identical(other.freezeTokens, freezeTokens) ||
                other.freezeTokens == freezeTokens) &&
            (identical(other.maxFreezeTokens, maxFreezeTokens) ||
                other.maxFreezeTokens == maxFreezeTokens) &&
            (identical(other.freezeTokensEarned, freezeTokensEarned) ||
                other.freezeTokensEarned == freezeTokensEarned) &&
            (identical(other.graceDaysRemaining, graceDaysRemaining) ||
                other.graceDaysRemaining == graceDaysRemaining) &&
            (identical(other.graceDaysUsedThisWeek, graceDaysUsedThisWeek) ||
                other.graceDaysUsedThisWeek == graceDaysUsedThisWeek) &&
            (identical(other.lastActiveDate, lastActiveDate) ||
                other.lastActiveDate == lastActiveDate) &&
            (identical(other.streakStartDate, streakStartDate) ||
                other.streakStartDate == streakStartDate) &&
            const DeepCollectionEquality()
                .equals(other._milestonesAchieved, _milestonesAchieved) &&
            const DeepCollectionEquality()
                .equals(other._graceDayHistory, _graceDayHistory) &&
            (identical(other.lastFreezeTokenEarned, lastFreezeTokenEarned) ||
                other.lastFreezeTokenEarned == lastFreezeTokenEarned) &&
            (identical(other.weeklyCheckInTarget, weeklyCheckInTarget) ||
                other.weeklyCheckInTarget == weeklyCheckInTarget) &&
            (identical(
                    other.weeklyCheckInsCompleted, weeklyCheckInsCompleted) ||
                other.weeklyCheckInsCompleted == weeklyCheckInsCompleted) &&
            (identical(other.lastWeekReset, lastWeekReset) ||
                other.lastWeekReset == lastWeekReset) &&
            (identical(other.hasWeekendAmulet, hasWeekendAmulet) ||
                other.hasWeekendAmulet == hasWeekendAmulet) &&
            (identical(other.weekendAmuletExpiresAt, weekendAmuletExpiresAt) ||
                other.weekendAmuletExpiresAt == weekendAmuletExpiresAt) &&
            const DeepCollectionEquality()
                .equals(other._weeklyActivityPattern, _weeklyActivityPattern));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        currentStreak,
        longestStreak,
        totalActiveDays,
        freezeTokens,
        maxFreezeTokens,
        freezeTokensEarned,
        graceDaysRemaining,
        graceDaysUsedThisWeek,
        lastActiveDate,
        streakStartDate,
        const DeepCollectionEquality().hash(_milestonesAchieved),
        const DeepCollectionEquality().hash(_graceDayHistory),
        lastFreezeTokenEarned,
        weeklyCheckInTarget,
        weeklyCheckInsCompleted,
        lastWeekReset,
        hasWeekendAmulet,
        weekendAmuletExpiresAt,
        const DeepCollectionEquality().hash(_weeklyActivityPattern)
      ]);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$StreakImplCopyWith<_$StreakImpl> get copyWith =>
      __$$StreakImplCopyWithImpl<_$StreakImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$StreakImplToJson(
      this,
    );
  }
}

abstract class _Streak implements Streak {
  const factory _Streak(
      {required final int currentStreak,
      required final int longestStreak,
      required final int totalActiveDays,
      required final int freezeTokens,
      required final int maxFreezeTokens,
      required final int freezeTokensEarned,
      required final int graceDaysRemaining,
      required final int graceDaysUsedThisWeek,
      required final DateTime? lastActiveDate,
      required final DateTime? streakStartDate,
      required final List<StreakMilestone> milestonesAchieved,
      required final List<GraceDayUsage> graceDayHistory,
      required final DateTime? lastFreezeTokenEarned,
      required final int weeklyCheckInTarget,
      required final int weeklyCheckInsCompleted,
      required final DateTime lastWeekReset,
      required final bool hasWeekendAmulet,
      required final DateTime? weekendAmuletExpiresAt,
      required final List<int> weeklyActivityPattern}) = _$StreakImpl;

  factory _Streak.fromJson(Map<String, dynamic> json) = _$StreakImpl.fromJson;

  @override
  int get currentStreak;
  @override
  int get longestStreak;
  @override
  int get totalActiveDays;
  @override
  int get freezeTokens;
  @override
  int get maxFreezeTokens;
  @override
  int get freezeTokensEarned;
  @override
  int get graceDaysRemaining;
  @override
  int get graceDaysUsedThisWeek;
  @override
  DateTime? get lastActiveDate;
  @override
  DateTime? get streakStartDate;
  @override
  List<StreakMilestone> get milestonesAchieved;
  @override
  List<GraceDayUsage> get graceDayHistory;
  @override
  DateTime? get lastFreezeTokenEarned;
  @override
  int get weeklyCheckInTarget;
  @override
  int get weeklyCheckInsCompleted;
  @override
  DateTime get lastWeekReset;
  @override
  bool get hasWeekendAmulet;
  @override
  DateTime? get weekendAmuletExpiresAt;
  @override
  List<int> get weeklyActivityPattern;
  @override
  @JsonKey(ignore: true)
  _$$StreakImplCopyWith<_$StreakImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

StreakMilestone _$StreakMilestoneFromJson(Map<String, dynamic> json) {
  return _StreakMilestone.fromJson(json);
}

/// @nodoc
mixin _$StreakMilestone {
  String get id => throw _privateConstructorUsedError;
  StreakMilestoneType get type => throw _privateConstructorUsedError;
  int get daysRequired => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  int get xpReward => throw _privateConstructorUsedError;
  int get freezeTokenReward => throw _privateConstructorUsedError;
  int get graceDayReward => throw _privateConstructorUsedError;
  DateTime get achievedAt => throw _privateConstructorUsedError;
  bool get isClaimed => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $StreakMilestoneCopyWith<StreakMilestone> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $StreakMilestoneCopyWith<$Res> {
  factory $StreakMilestoneCopyWith(
          StreakMilestone value, $Res Function(StreakMilestone) then) =
      _$StreakMilestoneCopyWithImpl<$Res, StreakMilestone>;
  @useResult
  $Res call(
      {String id,
      StreakMilestoneType type,
      int daysRequired,
      String title,
      String description,
      int xpReward,
      int freezeTokenReward,
      int graceDayReward,
      DateTime achievedAt,
      bool isClaimed});
}

/// @nodoc
class _$StreakMilestoneCopyWithImpl<$Res, $Val extends StreakMilestone>
    implements $StreakMilestoneCopyWith<$Res> {
  _$StreakMilestoneCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? type = null,
    Object? daysRequired = null,
    Object? title = null,
    Object? description = null,
    Object? xpReward = null,
    Object? freezeTokenReward = null,
    Object? graceDayReward = null,
    Object? achievedAt = null,
    Object? isClaimed = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as StreakMilestoneType,
      daysRequired: null == daysRequired
          ? _value.daysRequired
          : daysRequired // ignore: cast_nullable_to_non_nullable
              as int,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      xpReward: null == xpReward
          ? _value.xpReward
          : xpReward // ignore: cast_nullable_to_non_nullable
              as int,
      freezeTokenReward: null == freezeTokenReward
          ? _value.freezeTokenReward
          : freezeTokenReward // ignore: cast_nullable_to_non_nullable
              as int,
      graceDayReward: null == graceDayReward
          ? _value.graceDayReward
          : graceDayReward // ignore: cast_nullable_to_non_nullable
              as int,
      achievedAt: null == achievedAt
          ? _value.achievedAt
          : achievedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      isClaimed: null == isClaimed
          ? _value.isClaimed
          : isClaimed // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$StreakMilestoneImplCopyWith<$Res>
    implements $StreakMilestoneCopyWith<$Res> {
  factory _$$StreakMilestoneImplCopyWith(_$StreakMilestoneImpl value,
          $Res Function(_$StreakMilestoneImpl) then) =
      __$$StreakMilestoneImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      StreakMilestoneType type,
      int daysRequired,
      String title,
      String description,
      int xpReward,
      int freezeTokenReward,
      int graceDayReward,
      DateTime achievedAt,
      bool isClaimed});
}

/// @nodoc
class __$$StreakMilestoneImplCopyWithImpl<$Res>
    extends _$StreakMilestoneCopyWithImpl<$Res, _$StreakMilestoneImpl>
    implements _$$StreakMilestoneImplCopyWith<$Res> {
  __$$StreakMilestoneImplCopyWithImpl(
      _$StreakMilestoneImpl _value, $Res Function(_$StreakMilestoneImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? type = null,
    Object? daysRequired = null,
    Object? title = null,
    Object? description = null,
    Object? xpReward = null,
    Object? freezeTokenReward = null,
    Object? graceDayReward = null,
    Object? achievedAt = null,
    Object? isClaimed = null,
  }) {
    return _then(_$StreakMilestoneImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as StreakMilestoneType,
      daysRequired: null == daysRequired
          ? _value.daysRequired
          : daysRequired // ignore: cast_nullable_to_non_nullable
              as int,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      xpReward: null == xpReward
          ? _value.xpReward
          : xpReward // ignore: cast_nullable_to_non_nullable
              as int,
      freezeTokenReward: null == freezeTokenReward
          ? _value.freezeTokenReward
          : freezeTokenReward // ignore: cast_nullable_to_non_nullable
              as int,
      graceDayReward: null == graceDayReward
          ? _value.graceDayReward
          : graceDayReward // ignore: cast_nullable_to_non_nullable
              as int,
      achievedAt: null == achievedAt
          ? _value.achievedAt
          : achievedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      isClaimed: null == isClaimed
          ? _value.isClaimed
          : isClaimed // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$StreakMilestoneImpl implements _StreakMilestone {
  const _$StreakMilestoneImpl(
      {required this.id,
      required this.type,
      required this.daysRequired,
      required this.title,
      required this.description,
      required this.xpReward,
      required this.freezeTokenReward,
      required this.graceDayReward,
      required this.achievedAt,
      required this.isClaimed});

  factory _$StreakMilestoneImpl.fromJson(Map<String, dynamic> json) =>
      _$$StreakMilestoneImplFromJson(json);

  @override
  final String id;
  @override
  final StreakMilestoneType type;
  @override
  final int daysRequired;
  @override
  final String title;
  @override
  final String description;
  @override
  final int xpReward;
  @override
  final int freezeTokenReward;
  @override
  final int graceDayReward;
  @override
  final DateTime achievedAt;
  @override
  final bool isClaimed;

  @override
  String toString() {
    return 'StreakMilestone(id: $id, type: $type, daysRequired: $daysRequired, title: $title, description: $description, xpReward: $xpReward, freezeTokenReward: $freezeTokenReward, graceDayReward: $graceDayReward, achievedAt: $achievedAt, isClaimed: $isClaimed)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StreakMilestoneImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.daysRequired, daysRequired) ||
                other.daysRequired == daysRequired) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.xpReward, xpReward) ||
                other.xpReward == xpReward) &&
            (identical(other.freezeTokenReward, freezeTokenReward) ||
                other.freezeTokenReward == freezeTokenReward) &&
            (identical(other.graceDayReward, graceDayReward) ||
                other.graceDayReward == graceDayReward) &&
            (identical(other.achievedAt, achievedAt) ||
                other.achievedAt == achievedAt) &&
            (identical(other.isClaimed, isClaimed) ||
                other.isClaimed == isClaimed));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      type,
      daysRequired,
      title,
      description,
      xpReward,
      freezeTokenReward,
      graceDayReward,
      achievedAt,
      isClaimed);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$StreakMilestoneImplCopyWith<_$StreakMilestoneImpl> get copyWith =>
      __$$StreakMilestoneImplCopyWithImpl<_$StreakMilestoneImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$StreakMilestoneImplToJson(
      this,
    );
  }
}

abstract class _StreakMilestone implements StreakMilestone {
  const factory _StreakMilestone(
      {required final String id,
      required final StreakMilestoneType type,
      required final int daysRequired,
      required final String title,
      required final String description,
      required final int xpReward,
      required final int freezeTokenReward,
      required final int graceDayReward,
      required final DateTime achievedAt,
      required final bool isClaimed}) = _$StreakMilestoneImpl;

  factory _StreakMilestone.fromJson(Map<String, dynamic> json) =
      _$StreakMilestoneImpl.fromJson;

  @override
  String get id;
  @override
  StreakMilestoneType get type;
  @override
  int get daysRequired;
  @override
  String get title;
  @override
  String get description;
  @override
  int get xpReward;
  @override
  int get freezeTokenReward;
  @override
  int get graceDayReward;
  @override
  DateTime get achievedAt;
  @override
  bool get isClaimed;
  @override
  @JsonKey(ignore: true)
  _$$StreakMilestoneImplCopyWith<_$StreakMilestoneImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

GraceDayUsage _$GraceDayUsageFromJson(Map<String, dynamic> json) {
  return _GraceDayUsage.fromJson(json);
}

/// @nodoc
mixin _$GraceDayUsage {
  String get id => throw _privateConstructorUsedError;
  DateTime get dateUsed => throw _privateConstructorUsedError;
  GraceDayReason get reason => throw _privateConstructorUsedError;
  String? get note => throw _privateConstructorUsedError;
  bool get wasAutoApplied => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $GraceDayUsageCopyWith<GraceDayUsage> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GraceDayUsageCopyWith<$Res> {
  factory $GraceDayUsageCopyWith(
          GraceDayUsage value, $Res Function(GraceDayUsage) then) =
      _$GraceDayUsageCopyWithImpl<$Res, GraceDayUsage>;
  @useResult
  $Res call(
      {String id,
      DateTime dateUsed,
      GraceDayReason reason,
      String? note,
      bool wasAutoApplied});
}

/// @nodoc
class _$GraceDayUsageCopyWithImpl<$Res, $Val extends GraceDayUsage>
    implements $GraceDayUsageCopyWith<$Res> {
  _$GraceDayUsageCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? dateUsed = null,
    Object? reason = null,
    Object? note = freezed,
    Object? wasAutoApplied = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      dateUsed: null == dateUsed
          ? _value.dateUsed
          : dateUsed // ignore: cast_nullable_to_non_nullable
              as DateTime,
      reason: null == reason
          ? _value.reason
          : reason // ignore: cast_nullable_to_non_nullable
              as GraceDayReason,
      note: freezed == note
          ? _value.note
          : note // ignore: cast_nullable_to_non_nullable
              as String?,
      wasAutoApplied: null == wasAutoApplied
          ? _value.wasAutoApplied
          : wasAutoApplied // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$GraceDayUsageImplCopyWith<$Res>
    implements $GraceDayUsageCopyWith<$Res> {
  factory _$$GraceDayUsageImplCopyWith(
          _$GraceDayUsageImpl value, $Res Function(_$GraceDayUsageImpl) then) =
      __$$GraceDayUsageImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      DateTime dateUsed,
      GraceDayReason reason,
      String? note,
      bool wasAutoApplied});
}

/// @nodoc
class __$$GraceDayUsageImplCopyWithImpl<$Res>
    extends _$GraceDayUsageCopyWithImpl<$Res, _$GraceDayUsageImpl>
    implements _$$GraceDayUsageImplCopyWith<$Res> {
  __$$GraceDayUsageImplCopyWithImpl(
      _$GraceDayUsageImpl _value, $Res Function(_$GraceDayUsageImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? dateUsed = null,
    Object? reason = null,
    Object? note = freezed,
    Object? wasAutoApplied = null,
  }) {
    return _then(_$GraceDayUsageImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      dateUsed: null == dateUsed
          ? _value.dateUsed
          : dateUsed // ignore: cast_nullable_to_non_nullable
              as DateTime,
      reason: null == reason
          ? _value.reason
          : reason // ignore: cast_nullable_to_non_nullable
              as GraceDayReason,
      note: freezed == note
          ? _value.note
          : note // ignore: cast_nullable_to_non_nullable
              as String?,
      wasAutoApplied: null == wasAutoApplied
          ? _value.wasAutoApplied
          : wasAutoApplied // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$GraceDayUsageImpl implements _GraceDayUsage {
  const _$GraceDayUsageImpl(
      {required this.id,
      required this.dateUsed,
      required this.reason,
      required this.note,
      required this.wasAutoApplied});

  factory _$GraceDayUsageImpl.fromJson(Map<String, dynamic> json) =>
      _$$GraceDayUsageImplFromJson(json);

  @override
  final String id;
  @override
  final DateTime dateUsed;
  @override
  final GraceDayReason reason;
  @override
  final String? note;
  @override
  final bool wasAutoApplied;

  @override
  String toString() {
    return 'GraceDayUsage(id: $id, dateUsed: $dateUsed, reason: $reason, note: $note, wasAutoApplied: $wasAutoApplied)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GraceDayUsageImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.dateUsed, dateUsed) ||
                other.dateUsed == dateUsed) &&
            (identical(other.reason, reason) || other.reason == reason) &&
            (identical(other.note, note) || other.note == note) &&
            (identical(other.wasAutoApplied, wasAutoApplied) ||
                other.wasAutoApplied == wasAutoApplied));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, dateUsed, reason, note, wasAutoApplied);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$GraceDayUsageImplCopyWith<_$GraceDayUsageImpl> get copyWith =>
      __$$GraceDayUsageImplCopyWithImpl<_$GraceDayUsageImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$GraceDayUsageImplToJson(
      this,
    );
  }
}

abstract class _GraceDayUsage implements GraceDayUsage {
  const factory _GraceDayUsage(
      {required final String id,
      required final DateTime dateUsed,
      required final GraceDayReason reason,
      required final String? note,
      required final bool wasAutoApplied}) = _$GraceDayUsageImpl;

  factory _GraceDayUsage.fromJson(Map<String, dynamic> json) =
      _$GraceDayUsageImpl.fromJson;

  @override
  String get id;
  @override
  DateTime get dateUsed;
  @override
  GraceDayReason get reason;
  @override
  String? get note;
  @override
  bool get wasAutoApplied;
  @override
  @JsonKey(ignore: true)
  _$$GraceDayUsageImplCopyWith<_$GraceDayUsageImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

StreakConfig _$StreakConfigFromJson(Map<String, dynamic> json) {
  return _StreakConfig.fromJson(json);
}

/// @nodoc
mixin _$StreakConfig {
  int get startingFreezeTokens => throw _privateConstructorUsedError;
  int get maxFreezeTokens => throw _privateConstructorUsedError;
  int get weeklyGraceDays => throw _privateConstructorUsedError;
  int get maxGraceDaysPerMonth => throw _privateConstructorUsedError;
  int get freezeTokenEarnIntervalDays =>
      throw _privateConstructorUsedError; // Earn 1 token every N days of streak
  List<StreakMilestoneConfig> get milestones =>
      throw _privateConstructorUsedError;
  Map<GraceDayReason, int> get graceDayCosts =>
      throw _privateConstructorUsedError; // Some reasons cost more
  bool get allowRetroactiveGraceDays => throw _privateConstructorUsedError;
  int get retroactiveWindowDays => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $StreakConfigCopyWith<StreakConfig> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $StreakConfigCopyWith<$Res> {
  factory $StreakConfigCopyWith(
          StreakConfig value, $Res Function(StreakConfig) then) =
      _$StreakConfigCopyWithImpl<$Res, StreakConfig>;
  @useResult
  $Res call(
      {int startingFreezeTokens,
      int maxFreezeTokens,
      int weeklyGraceDays,
      int maxGraceDaysPerMonth,
      int freezeTokenEarnIntervalDays,
      List<StreakMilestoneConfig> milestones,
      Map<GraceDayReason, int> graceDayCosts,
      bool allowRetroactiveGraceDays,
      int retroactiveWindowDays});
}

/// @nodoc
class _$StreakConfigCopyWithImpl<$Res, $Val extends StreakConfig>
    implements $StreakConfigCopyWith<$Res> {
  _$StreakConfigCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? startingFreezeTokens = null,
    Object? maxFreezeTokens = null,
    Object? weeklyGraceDays = null,
    Object? maxGraceDaysPerMonth = null,
    Object? freezeTokenEarnIntervalDays = null,
    Object? milestones = null,
    Object? graceDayCosts = null,
    Object? allowRetroactiveGraceDays = null,
    Object? retroactiveWindowDays = null,
  }) {
    return _then(_value.copyWith(
      startingFreezeTokens: null == startingFreezeTokens
          ? _value.startingFreezeTokens
          : startingFreezeTokens // ignore: cast_nullable_to_non_nullable
              as int,
      maxFreezeTokens: null == maxFreezeTokens
          ? _value.maxFreezeTokens
          : maxFreezeTokens // ignore: cast_nullable_to_non_nullable
              as int,
      weeklyGraceDays: null == weeklyGraceDays
          ? _value.weeklyGraceDays
          : weeklyGraceDays // ignore: cast_nullable_to_non_nullable
              as int,
      maxGraceDaysPerMonth: null == maxGraceDaysPerMonth
          ? _value.maxGraceDaysPerMonth
          : maxGraceDaysPerMonth // ignore: cast_nullable_to_non_nullable
              as int,
      freezeTokenEarnIntervalDays: null == freezeTokenEarnIntervalDays
          ? _value.freezeTokenEarnIntervalDays
          : freezeTokenEarnIntervalDays // ignore: cast_nullable_to_non_nullable
              as int,
      milestones: null == milestones
          ? _value.milestones
          : milestones // ignore: cast_nullable_to_non_nullable
              as List<StreakMilestoneConfig>,
      graceDayCosts: null == graceDayCosts
          ? _value.graceDayCosts
          : graceDayCosts // ignore: cast_nullable_to_non_nullable
              as Map<GraceDayReason, int>,
      allowRetroactiveGraceDays: null == allowRetroactiveGraceDays
          ? _value.allowRetroactiveGraceDays
          : allowRetroactiveGraceDays // ignore: cast_nullable_to_non_nullable
              as bool,
      retroactiveWindowDays: null == retroactiveWindowDays
          ? _value.retroactiveWindowDays
          : retroactiveWindowDays // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$StreakConfigImplCopyWith<$Res>
    implements $StreakConfigCopyWith<$Res> {
  factory _$$StreakConfigImplCopyWith(
          _$StreakConfigImpl value, $Res Function(_$StreakConfigImpl) then) =
      __$$StreakConfigImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int startingFreezeTokens,
      int maxFreezeTokens,
      int weeklyGraceDays,
      int maxGraceDaysPerMonth,
      int freezeTokenEarnIntervalDays,
      List<StreakMilestoneConfig> milestones,
      Map<GraceDayReason, int> graceDayCosts,
      bool allowRetroactiveGraceDays,
      int retroactiveWindowDays});
}

/// @nodoc
class __$$StreakConfigImplCopyWithImpl<$Res>
    extends _$StreakConfigCopyWithImpl<$Res, _$StreakConfigImpl>
    implements _$$StreakConfigImplCopyWith<$Res> {
  __$$StreakConfigImplCopyWithImpl(
      _$StreakConfigImpl _value, $Res Function(_$StreakConfigImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? startingFreezeTokens = null,
    Object? maxFreezeTokens = null,
    Object? weeklyGraceDays = null,
    Object? maxGraceDaysPerMonth = null,
    Object? freezeTokenEarnIntervalDays = null,
    Object? milestones = null,
    Object? graceDayCosts = null,
    Object? allowRetroactiveGraceDays = null,
    Object? retroactiveWindowDays = null,
  }) {
    return _then(_$StreakConfigImpl(
      startingFreezeTokens: null == startingFreezeTokens
          ? _value.startingFreezeTokens
          : startingFreezeTokens // ignore: cast_nullable_to_non_nullable
              as int,
      maxFreezeTokens: null == maxFreezeTokens
          ? _value.maxFreezeTokens
          : maxFreezeTokens // ignore: cast_nullable_to_non_nullable
              as int,
      weeklyGraceDays: null == weeklyGraceDays
          ? _value.weeklyGraceDays
          : weeklyGraceDays // ignore: cast_nullable_to_non_nullable
              as int,
      maxGraceDaysPerMonth: null == maxGraceDaysPerMonth
          ? _value.maxGraceDaysPerMonth
          : maxGraceDaysPerMonth // ignore: cast_nullable_to_non_nullable
              as int,
      freezeTokenEarnIntervalDays: null == freezeTokenEarnIntervalDays
          ? _value.freezeTokenEarnIntervalDays
          : freezeTokenEarnIntervalDays // ignore: cast_nullable_to_non_nullable
              as int,
      milestones: null == milestones
          ? _value._milestones
          : milestones // ignore: cast_nullable_to_non_nullable
              as List<StreakMilestoneConfig>,
      graceDayCosts: null == graceDayCosts
          ? _value._graceDayCosts
          : graceDayCosts // ignore: cast_nullable_to_non_nullable
              as Map<GraceDayReason, int>,
      allowRetroactiveGraceDays: null == allowRetroactiveGraceDays
          ? _value.allowRetroactiveGraceDays
          : allowRetroactiveGraceDays // ignore: cast_nullable_to_non_nullable
              as bool,
      retroactiveWindowDays: null == retroactiveWindowDays
          ? _value.retroactiveWindowDays
          : retroactiveWindowDays // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$StreakConfigImpl implements _StreakConfig {
  const _$StreakConfigImpl(
      {required this.startingFreezeTokens,
      required this.maxFreezeTokens,
      required this.weeklyGraceDays,
      required this.maxGraceDaysPerMonth,
      required this.freezeTokenEarnIntervalDays,
      required final List<StreakMilestoneConfig> milestones,
      required final Map<GraceDayReason, int> graceDayCosts,
      required this.allowRetroactiveGraceDays,
      required this.retroactiveWindowDays})
      : _milestones = milestones,
        _graceDayCosts = graceDayCosts;

  factory _$StreakConfigImpl.fromJson(Map<String, dynamic> json) =>
      _$$StreakConfigImplFromJson(json);

  @override
  final int startingFreezeTokens;
  @override
  final int maxFreezeTokens;
  @override
  final int weeklyGraceDays;
  @override
  final int maxGraceDaysPerMonth;
  @override
  final int freezeTokenEarnIntervalDays;
// Earn 1 token every N days of streak
  final List<StreakMilestoneConfig> _milestones;
// Earn 1 token every N days of streak
  @override
  List<StreakMilestoneConfig> get milestones {
    if (_milestones is EqualUnmodifiableListView) return _milestones;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_milestones);
  }

  final Map<GraceDayReason, int> _graceDayCosts;
  @override
  Map<GraceDayReason, int> get graceDayCosts {
    if (_graceDayCosts is EqualUnmodifiableMapView) return _graceDayCosts;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_graceDayCosts);
  }

// Some reasons cost more
  @override
  final bool allowRetroactiveGraceDays;
  @override
  final int retroactiveWindowDays;

  @override
  String toString() {
    return 'StreakConfig(startingFreezeTokens: $startingFreezeTokens, maxFreezeTokens: $maxFreezeTokens, weeklyGraceDays: $weeklyGraceDays, maxGraceDaysPerMonth: $maxGraceDaysPerMonth, freezeTokenEarnIntervalDays: $freezeTokenEarnIntervalDays, milestones: $milestones, graceDayCosts: $graceDayCosts, allowRetroactiveGraceDays: $allowRetroactiveGraceDays, retroactiveWindowDays: $retroactiveWindowDays)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StreakConfigImpl &&
            (identical(other.startingFreezeTokens, startingFreezeTokens) ||
                other.startingFreezeTokens == startingFreezeTokens) &&
            (identical(other.maxFreezeTokens, maxFreezeTokens) ||
                other.maxFreezeTokens == maxFreezeTokens) &&
            (identical(other.weeklyGraceDays, weeklyGraceDays) ||
                other.weeklyGraceDays == weeklyGraceDays) &&
            (identical(other.maxGraceDaysPerMonth, maxGraceDaysPerMonth) ||
                other.maxGraceDaysPerMonth == maxGraceDaysPerMonth) &&
            (identical(other.freezeTokenEarnIntervalDays,
                    freezeTokenEarnIntervalDays) ||
                other.freezeTokenEarnIntervalDays ==
                    freezeTokenEarnIntervalDays) &&
            const DeepCollectionEquality()
                .equals(other._milestones, _milestones) &&
            const DeepCollectionEquality()
                .equals(other._graceDayCosts, _graceDayCosts) &&
            (identical(other.allowRetroactiveGraceDays,
                    allowRetroactiveGraceDays) ||
                other.allowRetroactiveGraceDays == allowRetroactiveGraceDays) &&
            (identical(other.retroactiveWindowDays, retroactiveWindowDays) ||
                other.retroactiveWindowDays == retroactiveWindowDays));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      startingFreezeTokens,
      maxFreezeTokens,
      weeklyGraceDays,
      maxGraceDaysPerMonth,
      freezeTokenEarnIntervalDays,
      const DeepCollectionEquality().hash(_milestones),
      const DeepCollectionEquality().hash(_graceDayCosts),
      allowRetroactiveGraceDays,
      retroactiveWindowDays);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$StreakConfigImplCopyWith<_$StreakConfigImpl> get copyWith =>
      __$$StreakConfigImplCopyWithImpl<_$StreakConfigImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$StreakConfigImplToJson(
      this,
    );
  }
}

abstract class _StreakConfig implements StreakConfig {
  const factory _StreakConfig(
      {required final int startingFreezeTokens,
      required final int maxFreezeTokens,
      required final int weeklyGraceDays,
      required final int maxGraceDaysPerMonth,
      required final int freezeTokenEarnIntervalDays,
      required final List<StreakMilestoneConfig> milestones,
      required final Map<GraceDayReason, int> graceDayCosts,
      required final bool allowRetroactiveGraceDays,
      required final int retroactiveWindowDays}) = _$StreakConfigImpl;

  factory _StreakConfig.fromJson(Map<String, dynamic> json) =
      _$StreakConfigImpl.fromJson;

  @override
  int get startingFreezeTokens;
  @override
  int get maxFreezeTokens;
  @override
  int get weeklyGraceDays;
  @override
  int get maxGraceDaysPerMonth;
  @override
  int get freezeTokenEarnIntervalDays;
  @override // Earn 1 token every N days of streak
  List<StreakMilestoneConfig> get milestones;
  @override
  Map<GraceDayReason, int> get graceDayCosts;
  @override // Some reasons cost more
  bool get allowRetroactiveGraceDays;
  @override
  int get retroactiveWindowDays;
  @override
  @JsonKey(ignore: true)
  _$$StreakConfigImplCopyWith<_$StreakConfigImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

StreakMilestoneConfig _$StreakMilestoneConfigFromJson(
    Map<String, dynamic> json) {
  return _StreakMilestoneConfig.fromJson(json);
}

/// @nodoc
mixin _$StreakMilestoneConfig {
  StreakMilestoneType get type => throw _privateConstructorUsedError;
  int get daysRequired => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  int get xpReward => throw _privateConstructorUsedError;
  int get freezeTokenReward => throw _privateConstructorUsedError;
  int get graceDayReward => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $StreakMilestoneConfigCopyWith<StreakMilestoneConfig> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $StreakMilestoneConfigCopyWith<$Res> {
  factory $StreakMilestoneConfigCopyWith(StreakMilestoneConfig value,
          $Res Function(StreakMilestoneConfig) then) =
      _$StreakMilestoneConfigCopyWithImpl<$Res, StreakMilestoneConfig>;
  @useResult
  $Res call(
      {StreakMilestoneType type,
      int daysRequired,
      String title,
      String description,
      int xpReward,
      int freezeTokenReward,
      int graceDayReward});
}

/// @nodoc
class _$StreakMilestoneConfigCopyWithImpl<$Res,
        $Val extends StreakMilestoneConfig>
    implements $StreakMilestoneConfigCopyWith<$Res> {
  _$StreakMilestoneConfigCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? type = null,
    Object? daysRequired = null,
    Object? title = null,
    Object? description = null,
    Object? xpReward = null,
    Object? freezeTokenReward = null,
    Object? graceDayReward = null,
  }) {
    return _then(_value.copyWith(
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as StreakMilestoneType,
      daysRequired: null == daysRequired
          ? _value.daysRequired
          : daysRequired // ignore: cast_nullable_to_non_nullable
              as int,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      xpReward: null == xpReward
          ? _value.xpReward
          : xpReward // ignore: cast_nullable_to_non_nullable
              as int,
      freezeTokenReward: null == freezeTokenReward
          ? _value.freezeTokenReward
          : freezeTokenReward // ignore: cast_nullable_to_non_nullable
              as int,
      graceDayReward: null == graceDayReward
          ? _value.graceDayReward
          : graceDayReward // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$StreakMilestoneConfigImplCopyWith<$Res>
    implements $StreakMilestoneConfigCopyWith<$Res> {
  factory _$$StreakMilestoneConfigImplCopyWith(
          _$StreakMilestoneConfigImpl value,
          $Res Function(_$StreakMilestoneConfigImpl) then) =
      __$$StreakMilestoneConfigImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {StreakMilestoneType type,
      int daysRequired,
      String title,
      String description,
      int xpReward,
      int freezeTokenReward,
      int graceDayReward});
}

/// @nodoc
class __$$StreakMilestoneConfigImplCopyWithImpl<$Res>
    extends _$StreakMilestoneConfigCopyWithImpl<$Res,
        _$StreakMilestoneConfigImpl>
    implements _$$StreakMilestoneConfigImplCopyWith<$Res> {
  __$$StreakMilestoneConfigImplCopyWithImpl(_$StreakMilestoneConfigImpl _value,
      $Res Function(_$StreakMilestoneConfigImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? type = null,
    Object? daysRequired = null,
    Object? title = null,
    Object? description = null,
    Object? xpReward = null,
    Object? freezeTokenReward = null,
    Object? graceDayReward = null,
  }) {
    return _then(_$StreakMilestoneConfigImpl(
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as StreakMilestoneType,
      daysRequired: null == daysRequired
          ? _value.daysRequired
          : daysRequired // ignore: cast_nullable_to_non_nullable
              as int,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      xpReward: null == xpReward
          ? _value.xpReward
          : xpReward // ignore: cast_nullable_to_non_nullable
              as int,
      freezeTokenReward: null == freezeTokenReward
          ? _value.freezeTokenReward
          : freezeTokenReward // ignore: cast_nullable_to_non_nullable
              as int,
      graceDayReward: null == graceDayReward
          ? _value.graceDayReward
          : graceDayReward // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$StreakMilestoneConfigImpl implements _StreakMilestoneConfig {
  const _$StreakMilestoneConfigImpl(
      {required this.type,
      required this.daysRequired,
      required this.title,
      required this.description,
      required this.xpReward,
      required this.freezeTokenReward,
      required this.graceDayReward});

  factory _$StreakMilestoneConfigImpl.fromJson(Map<String, dynamic> json) =>
      _$$StreakMilestoneConfigImplFromJson(json);

  @override
  final StreakMilestoneType type;
  @override
  final int daysRequired;
  @override
  final String title;
  @override
  final String description;
  @override
  final int xpReward;
  @override
  final int freezeTokenReward;
  @override
  final int graceDayReward;

  @override
  String toString() {
    return 'StreakMilestoneConfig(type: $type, daysRequired: $daysRequired, title: $title, description: $description, xpReward: $xpReward, freezeTokenReward: $freezeTokenReward, graceDayReward: $graceDayReward)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StreakMilestoneConfigImpl &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.daysRequired, daysRequired) ||
                other.daysRequired == daysRequired) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.xpReward, xpReward) ||
                other.xpReward == xpReward) &&
            (identical(other.freezeTokenReward, freezeTokenReward) ||
                other.freezeTokenReward == freezeTokenReward) &&
            (identical(other.graceDayReward, graceDayReward) ||
                other.graceDayReward == graceDayReward));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, type, daysRequired, title,
      description, xpReward, freezeTokenReward, graceDayReward);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$StreakMilestoneConfigImplCopyWith<_$StreakMilestoneConfigImpl>
      get copyWith => __$$StreakMilestoneConfigImplCopyWithImpl<
          _$StreakMilestoneConfigImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$StreakMilestoneConfigImplToJson(
      this,
    );
  }
}

abstract class _StreakMilestoneConfig implements StreakMilestoneConfig {
  const factory _StreakMilestoneConfig(
      {required final StreakMilestoneType type,
      required final int daysRequired,
      required final String title,
      required final String description,
      required final int xpReward,
      required final int freezeTokenReward,
      required final int graceDayReward}) = _$StreakMilestoneConfigImpl;

  factory _StreakMilestoneConfig.fromJson(Map<String, dynamic> json) =
      _$StreakMilestoneConfigImpl.fromJson;

  @override
  StreakMilestoneType get type;
  @override
  int get daysRequired;
  @override
  String get title;
  @override
  String get description;
  @override
  int get xpReward;
  @override
  int get freezeTokenReward;
  @override
  int get graceDayReward;
  @override
  @JsonKey(ignore: true)
  _$$StreakMilestoneConfigImplCopyWith<_$StreakMilestoneConfigImpl>
      get copyWith => throw _privateConstructorUsedError;
}

StreakActionResult _$StreakActionResultFromJson(Map<String, dynamic> json) {
  switch (json['runtimeType']) {
    case 'success':
      return _StreakActionResultSuccess.fromJson(json);
    case 'graceDayUsed':
      return _StreakActionResultGraceDayUsed.fromJson(json);
    case 'freezeTokenUsed':
      return _StreakActionResultFreezeTokenUsed.fromJson(json);
    case 'streakBroken':
      return _StreakActionResultStreakBroken.fromJson(json);
    case 'alreadyMarked':
      return _StreakActionResultAlreadyMarked.fromJson(json);

    default:
      throw CheckedFromJsonException(json, 'runtimeType', 'StreakActionResult',
          'Invalid union type "${json['runtimeType']}"!');
  }
}

/// @nodoc
mixin _$StreakActionResult {
  String get message => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
            Streak newStreak,
            List<StreakMilestone> newMilestones,
            int xpEarned,
            int freezeTokensEarned,
            int graceDaysEarned,
            String message)
        success,
    required TResult Function(
            Streak newStreak, GraceDayUsage graceDayUsage, String message)
        graceDayUsed,
    required TResult Function(Streak newStreak, int tokensUsed, String message)
        freezeTokenUsed,
    required TResult Function(Streak newStreak, int previousStreak,
            String message, String encouragementMessage)
        streakBroken,
    required TResult Function(Streak streak, String message) alreadyMarked,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(
            Streak newStreak,
            List<StreakMilestone> newMilestones,
            int xpEarned,
            int freezeTokensEarned,
            int graceDaysEarned,
            String message)?
        success,
    TResult? Function(
            Streak newStreak, GraceDayUsage graceDayUsage, String message)?
        graceDayUsed,
    TResult? Function(Streak newStreak, int tokensUsed, String message)?
        freezeTokenUsed,
    TResult? Function(Streak newStreak, int previousStreak, String message,
            String encouragementMessage)?
        streakBroken,
    TResult? Function(Streak streak, String message)? alreadyMarked,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(
            Streak newStreak,
            List<StreakMilestone> newMilestones,
            int xpEarned,
            int freezeTokensEarned,
            int graceDaysEarned,
            String message)?
        success,
    TResult Function(
            Streak newStreak, GraceDayUsage graceDayUsage, String message)?
        graceDayUsed,
    TResult Function(Streak newStreak, int tokensUsed, String message)?
        freezeTokenUsed,
    TResult Function(Streak newStreak, int previousStreak, String message,
            String encouragementMessage)?
        streakBroken,
    TResult Function(Streak streak, String message)? alreadyMarked,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_StreakActionResultSuccess value) success,
    required TResult Function(_StreakActionResultGraceDayUsed value)
        graceDayUsed,
    required TResult Function(_StreakActionResultFreezeTokenUsed value)
        freezeTokenUsed,
    required TResult Function(_StreakActionResultStreakBroken value)
        streakBroken,
    required TResult Function(_StreakActionResultAlreadyMarked value)
        alreadyMarked,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_StreakActionResultSuccess value)? success,
    TResult? Function(_StreakActionResultGraceDayUsed value)? graceDayUsed,
    TResult? Function(_StreakActionResultFreezeTokenUsed value)?
        freezeTokenUsed,
    TResult? Function(_StreakActionResultStreakBroken value)? streakBroken,
    TResult? Function(_StreakActionResultAlreadyMarked value)? alreadyMarked,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_StreakActionResultSuccess value)? success,
    TResult Function(_StreakActionResultGraceDayUsed value)? graceDayUsed,
    TResult Function(_StreakActionResultFreezeTokenUsed value)? freezeTokenUsed,
    TResult Function(_StreakActionResultStreakBroken value)? streakBroken,
    TResult Function(_StreakActionResultAlreadyMarked value)? alreadyMarked,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $StreakActionResultCopyWith<StreakActionResult> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $StreakActionResultCopyWith<$Res> {
  factory $StreakActionResultCopyWith(
          StreakActionResult value, $Res Function(StreakActionResult) then) =
      _$StreakActionResultCopyWithImpl<$Res, StreakActionResult>;
  @useResult
  $Res call({String message});
}

/// @nodoc
class _$StreakActionResultCopyWithImpl<$Res, $Val extends StreakActionResult>
    implements $StreakActionResultCopyWith<$Res> {
  _$StreakActionResultCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? message = null,
  }) {
    return _then(_value.copyWith(
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$StreakActionResultSuccessImplCopyWith<$Res>
    implements $StreakActionResultCopyWith<$Res> {
  factory _$$StreakActionResultSuccessImplCopyWith(
          _$StreakActionResultSuccessImpl value,
          $Res Function(_$StreakActionResultSuccessImpl) then) =
      __$$StreakActionResultSuccessImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {Streak newStreak,
      List<StreakMilestone> newMilestones,
      int xpEarned,
      int freezeTokensEarned,
      int graceDaysEarned,
      String message});

  $StreakCopyWith<$Res> get newStreak;
}

/// @nodoc
class __$$StreakActionResultSuccessImplCopyWithImpl<$Res>
    extends _$StreakActionResultCopyWithImpl<$Res,
        _$StreakActionResultSuccessImpl>
    implements _$$StreakActionResultSuccessImplCopyWith<$Res> {
  __$$StreakActionResultSuccessImplCopyWithImpl(
      _$StreakActionResultSuccessImpl _value,
      $Res Function(_$StreakActionResultSuccessImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? newStreak = null,
    Object? newMilestones = null,
    Object? xpEarned = null,
    Object? freezeTokensEarned = null,
    Object? graceDaysEarned = null,
    Object? message = null,
  }) {
    return _then(_$StreakActionResultSuccessImpl(
      newStreak: null == newStreak
          ? _value.newStreak
          : newStreak // ignore: cast_nullable_to_non_nullable
              as Streak,
      newMilestones: null == newMilestones
          ? _value._newMilestones
          : newMilestones // ignore: cast_nullable_to_non_nullable
              as List<StreakMilestone>,
      xpEarned: null == xpEarned
          ? _value.xpEarned
          : xpEarned // ignore: cast_nullable_to_non_nullable
              as int,
      freezeTokensEarned: null == freezeTokensEarned
          ? _value.freezeTokensEarned
          : freezeTokensEarned // ignore: cast_nullable_to_non_nullable
              as int,
      graceDaysEarned: null == graceDaysEarned
          ? _value.graceDaysEarned
          : graceDaysEarned // ignore: cast_nullable_to_non_nullable
              as int,
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }

  @override
  @pragma('vm:prefer-inline')
  $StreakCopyWith<$Res> get newStreak {
    return $StreakCopyWith<$Res>(_value.newStreak, (value) {
      return _then(_value.copyWith(newStreak: value));
    });
  }
}

/// @nodoc
@JsonSerializable()
class _$StreakActionResultSuccessImpl implements _StreakActionResultSuccess {
  const _$StreakActionResultSuccessImpl(
      {required this.newStreak,
      required final List<StreakMilestone> newMilestones,
      required this.xpEarned,
      required this.freezeTokensEarned,
      required this.graceDaysEarned,
      required this.message,
      final String? $type})
      : _newMilestones = newMilestones,
        $type = $type ?? 'success';

  factory _$StreakActionResultSuccessImpl.fromJson(Map<String, dynamic> json) =>
      _$$StreakActionResultSuccessImplFromJson(json);

  @override
  final Streak newStreak;
  final List<StreakMilestone> _newMilestones;
  @override
  List<StreakMilestone> get newMilestones {
    if (_newMilestones is EqualUnmodifiableListView) return _newMilestones;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_newMilestones);
  }

  @override
  final int xpEarned;
  @override
  final int freezeTokensEarned;
  @override
  final int graceDaysEarned;
  @override
  final String message;

  @JsonKey(name: 'runtimeType')
  final String $type;

  @override
  String toString() {
    return 'StreakActionResult.success(newStreak: $newStreak, newMilestones: $newMilestones, xpEarned: $xpEarned, freezeTokensEarned: $freezeTokensEarned, graceDaysEarned: $graceDaysEarned, message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StreakActionResultSuccessImpl &&
            (identical(other.newStreak, newStreak) ||
                other.newStreak == newStreak) &&
            const DeepCollectionEquality()
                .equals(other._newMilestones, _newMilestones) &&
            (identical(other.xpEarned, xpEarned) ||
                other.xpEarned == xpEarned) &&
            (identical(other.freezeTokensEarned, freezeTokensEarned) ||
                other.freezeTokensEarned == freezeTokensEarned) &&
            (identical(other.graceDaysEarned, graceDaysEarned) ||
                other.graceDaysEarned == graceDaysEarned) &&
            (identical(other.message, message) || other.message == message));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      newStreak,
      const DeepCollectionEquality().hash(_newMilestones),
      xpEarned,
      freezeTokensEarned,
      graceDaysEarned,
      message);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$StreakActionResultSuccessImplCopyWith<_$StreakActionResultSuccessImpl>
      get copyWith => __$$StreakActionResultSuccessImplCopyWithImpl<
          _$StreakActionResultSuccessImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
            Streak newStreak,
            List<StreakMilestone> newMilestones,
            int xpEarned,
            int freezeTokensEarned,
            int graceDaysEarned,
            String message)
        success,
    required TResult Function(
            Streak newStreak, GraceDayUsage graceDayUsage, String message)
        graceDayUsed,
    required TResult Function(Streak newStreak, int tokensUsed, String message)
        freezeTokenUsed,
    required TResult Function(Streak newStreak, int previousStreak,
            String message, String encouragementMessage)
        streakBroken,
    required TResult Function(Streak streak, String message) alreadyMarked,
  }) {
    return success(newStreak, newMilestones, xpEarned, freezeTokensEarned,
        graceDaysEarned, message);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(
            Streak newStreak,
            List<StreakMilestone> newMilestones,
            int xpEarned,
            int freezeTokensEarned,
            int graceDaysEarned,
            String message)?
        success,
    TResult? Function(
            Streak newStreak, GraceDayUsage graceDayUsage, String message)?
        graceDayUsed,
    TResult? Function(Streak newStreak, int tokensUsed, String message)?
        freezeTokenUsed,
    TResult? Function(Streak newStreak, int previousStreak, String message,
            String encouragementMessage)?
        streakBroken,
    TResult? Function(Streak streak, String message)? alreadyMarked,
  }) {
    return success?.call(newStreak, newMilestones, xpEarned, freezeTokensEarned,
        graceDaysEarned, message);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(
            Streak newStreak,
            List<StreakMilestone> newMilestones,
            int xpEarned,
            int freezeTokensEarned,
            int graceDaysEarned,
            String message)?
        success,
    TResult Function(
            Streak newStreak, GraceDayUsage graceDayUsage, String message)?
        graceDayUsed,
    TResult Function(Streak newStreak, int tokensUsed, String message)?
        freezeTokenUsed,
    TResult Function(Streak newStreak, int previousStreak, String message,
            String encouragementMessage)?
        streakBroken,
    TResult Function(Streak streak, String message)? alreadyMarked,
    required TResult orElse(),
  }) {
    if (success != null) {
      return success(newStreak, newMilestones, xpEarned, freezeTokensEarned,
          graceDaysEarned, message);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_StreakActionResultSuccess value) success,
    required TResult Function(_StreakActionResultGraceDayUsed value)
        graceDayUsed,
    required TResult Function(_StreakActionResultFreezeTokenUsed value)
        freezeTokenUsed,
    required TResult Function(_StreakActionResultStreakBroken value)
        streakBroken,
    required TResult Function(_StreakActionResultAlreadyMarked value)
        alreadyMarked,
  }) {
    return success(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_StreakActionResultSuccess value)? success,
    TResult? Function(_StreakActionResultGraceDayUsed value)? graceDayUsed,
    TResult? Function(_StreakActionResultFreezeTokenUsed value)?
        freezeTokenUsed,
    TResult? Function(_StreakActionResultStreakBroken value)? streakBroken,
    TResult? Function(_StreakActionResultAlreadyMarked value)? alreadyMarked,
  }) {
    return success?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_StreakActionResultSuccess value)? success,
    TResult Function(_StreakActionResultGraceDayUsed value)? graceDayUsed,
    TResult Function(_StreakActionResultFreezeTokenUsed value)? freezeTokenUsed,
    TResult Function(_StreakActionResultStreakBroken value)? streakBroken,
    TResult Function(_StreakActionResultAlreadyMarked value)? alreadyMarked,
    required TResult orElse(),
  }) {
    if (success != null) {
      return success(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$StreakActionResultSuccessImplToJson(
      this,
    );
  }
}

abstract class _StreakActionResultSuccess implements StreakActionResult {
  const factory _StreakActionResultSuccess(
      {required final Streak newStreak,
      required final List<StreakMilestone> newMilestones,
      required final int xpEarned,
      required final int freezeTokensEarned,
      required final int graceDaysEarned,
      required final String message}) = _$StreakActionResultSuccessImpl;

  factory _StreakActionResultSuccess.fromJson(Map<String, dynamic> json) =
      _$StreakActionResultSuccessImpl.fromJson;

  Streak get newStreak;
  List<StreakMilestone> get newMilestones;
  int get xpEarned;
  int get freezeTokensEarned;
  int get graceDaysEarned;
  @override
  String get message;
  @override
  @JsonKey(ignore: true)
  _$$StreakActionResultSuccessImplCopyWith<_$StreakActionResultSuccessImpl>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$StreakActionResultGraceDayUsedImplCopyWith<$Res>
    implements $StreakActionResultCopyWith<$Res> {
  factory _$$StreakActionResultGraceDayUsedImplCopyWith(
          _$StreakActionResultGraceDayUsedImpl value,
          $Res Function(_$StreakActionResultGraceDayUsedImpl) then) =
      __$$StreakActionResultGraceDayUsedImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({Streak newStreak, GraceDayUsage graceDayUsage, String message});

  $StreakCopyWith<$Res> get newStreak;
  $GraceDayUsageCopyWith<$Res> get graceDayUsage;
}

/// @nodoc
class __$$StreakActionResultGraceDayUsedImplCopyWithImpl<$Res>
    extends _$StreakActionResultCopyWithImpl<$Res,
        _$StreakActionResultGraceDayUsedImpl>
    implements _$$StreakActionResultGraceDayUsedImplCopyWith<$Res> {
  __$$StreakActionResultGraceDayUsedImplCopyWithImpl(
      _$StreakActionResultGraceDayUsedImpl _value,
      $Res Function(_$StreakActionResultGraceDayUsedImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? newStreak = null,
    Object? graceDayUsage = null,
    Object? message = null,
  }) {
    return _then(_$StreakActionResultGraceDayUsedImpl(
      newStreak: null == newStreak
          ? _value.newStreak
          : newStreak // ignore: cast_nullable_to_non_nullable
              as Streak,
      graceDayUsage: null == graceDayUsage
          ? _value.graceDayUsage
          : graceDayUsage // ignore: cast_nullable_to_non_nullable
              as GraceDayUsage,
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }

  @override
  @pragma('vm:prefer-inline')
  $StreakCopyWith<$Res> get newStreak {
    return $StreakCopyWith<$Res>(_value.newStreak, (value) {
      return _then(_value.copyWith(newStreak: value));
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $GraceDayUsageCopyWith<$Res> get graceDayUsage {
    return $GraceDayUsageCopyWith<$Res>(_value.graceDayUsage, (value) {
      return _then(_value.copyWith(graceDayUsage: value));
    });
  }
}

/// @nodoc
@JsonSerializable()
class _$StreakActionResultGraceDayUsedImpl
    implements _StreakActionResultGraceDayUsed {
  const _$StreakActionResultGraceDayUsedImpl(
      {required this.newStreak,
      required this.graceDayUsage,
      required this.message,
      final String? $type})
      : $type = $type ?? 'graceDayUsed';

  factory _$StreakActionResultGraceDayUsedImpl.fromJson(
          Map<String, dynamic> json) =>
      _$$StreakActionResultGraceDayUsedImplFromJson(json);

  @override
  final Streak newStreak;
  @override
  final GraceDayUsage graceDayUsage;
  @override
  final String message;

  @JsonKey(name: 'runtimeType')
  final String $type;

  @override
  String toString() {
    return 'StreakActionResult.graceDayUsed(newStreak: $newStreak, graceDayUsage: $graceDayUsage, message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StreakActionResultGraceDayUsedImpl &&
            (identical(other.newStreak, newStreak) ||
                other.newStreak == newStreak) &&
            (identical(other.graceDayUsage, graceDayUsage) ||
                other.graceDayUsage == graceDayUsage) &&
            (identical(other.message, message) || other.message == message));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, newStreak, graceDayUsage, message);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$StreakActionResultGraceDayUsedImplCopyWith<
          _$StreakActionResultGraceDayUsedImpl>
      get copyWith => __$$StreakActionResultGraceDayUsedImplCopyWithImpl<
          _$StreakActionResultGraceDayUsedImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
            Streak newStreak,
            List<StreakMilestone> newMilestones,
            int xpEarned,
            int freezeTokensEarned,
            int graceDaysEarned,
            String message)
        success,
    required TResult Function(
            Streak newStreak, GraceDayUsage graceDayUsage, String message)
        graceDayUsed,
    required TResult Function(Streak newStreak, int tokensUsed, String message)
        freezeTokenUsed,
    required TResult Function(Streak newStreak, int previousStreak,
            String message, String encouragementMessage)
        streakBroken,
    required TResult Function(Streak streak, String message) alreadyMarked,
  }) {
    return graceDayUsed(newStreak, graceDayUsage, message);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(
            Streak newStreak,
            List<StreakMilestone> newMilestones,
            int xpEarned,
            int freezeTokensEarned,
            int graceDaysEarned,
            String message)?
        success,
    TResult? Function(
            Streak newStreak, GraceDayUsage graceDayUsage, String message)?
        graceDayUsed,
    TResult? Function(Streak newStreak, int tokensUsed, String message)?
        freezeTokenUsed,
    TResult? Function(Streak newStreak, int previousStreak, String message,
            String encouragementMessage)?
        streakBroken,
    TResult? Function(Streak streak, String message)? alreadyMarked,
  }) {
    return graceDayUsed?.call(newStreak, graceDayUsage, message);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(
            Streak newStreak,
            List<StreakMilestone> newMilestones,
            int xpEarned,
            int freezeTokensEarned,
            int graceDaysEarned,
            String message)?
        success,
    TResult Function(
            Streak newStreak, GraceDayUsage graceDayUsage, String message)?
        graceDayUsed,
    TResult Function(Streak newStreak, int tokensUsed, String message)?
        freezeTokenUsed,
    TResult Function(Streak newStreak, int previousStreak, String message,
            String encouragementMessage)?
        streakBroken,
    TResult Function(Streak streak, String message)? alreadyMarked,
    required TResult orElse(),
  }) {
    if (graceDayUsed != null) {
      return graceDayUsed(newStreak, graceDayUsage, message);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_StreakActionResultSuccess value) success,
    required TResult Function(_StreakActionResultGraceDayUsed value)
        graceDayUsed,
    required TResult Function(_StreakActionResultFreezeTokenUsed value)
        freezeTokenUsed,
    required TResult Function(_StreakActionResultStreakBroken value)
        streakBroken,
    required TResult Function(_StreakActionResultAlreadyMarked value)
        alreadyMarked,
  }) {
    return graceDayUsed(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_StreakActionResultSuccess value)? success,
    TResult? Function(_StreakActionResultGraceDayUsed value)? graceDayUsed,
    TResult? Function(_StreakActionResultFreezeTokenUsed value)?
        freezeTokenUsed,
    TResult? Function(_StreakActionResultStreakBroken value)? streakBroken,
    TResult? Function(_StreakActionResultAlreadyMarked value)? alreadyMarked,
  }) {
    return graceDayUsed?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_StreakActionResultSuccess value)? success,
    TResult Function(_StreakActionResultGraceDayUsed value)? graceDayUsed,
    TResult Function(_StreakActionResultFreezeTokenUsed value)? freezeTokenUsed,
    TResult Function(_StreakActionResultStreakBroken value)? streakBroken,
    TResult Function(_StreakActionResultAlreadyMarked value)? alreadyMarked,
    required TResult orElse(),
  }) {
    if (graceDayUsed != null) {
      return graceDayUsed(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$StreakActionResultGraceDayUsedImplToJson(
      this,
    );
  }
}

abstract class _StreakActionResultGraceDayUsed implements StreakActionResult {
  const factory _StreakActionResultGraceDayUsed(
      {required final Streak newStreak,
      required final GraceDayUsage graceDayUsage,
      required final String message}) = _$StreakActionResultGraceDayUsedImpl;

  factory _StreakActionResultGraceDayUsed.fromJson(Map<String, dynamic> json) =
      _$StreakActionResultGraceDayUsedImpl.fromJson;

  Streak get newStreak;
  GraceDayUsage get graceDayUsage;
  @override
  String get message;
  @override
  @JsonKey(ignore: true)
  _$$StreakActionResultGraceDayUsedImplCopyWith<
          _$StreakActionResultGraceDayUsedImpl>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$StreakActionResultFreezeTokenUsedImplCopyWith<$Res>
    implements $StreakActionResultCopyWith<$Res> {
  factory _$$StreakActionResultFreezeTokenUsedImplCopyWith(
          _$StreakActionResultFreezeTokenUsedImpl value,
          $Res Function(_$StreakActionResultFreezeTokenUsedImpl) then) =
      __$$StreakActionResultFreezeTokenUsedImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({Streak newStreak, int tokensUsed, String message});

  $StreakCopyWith<$Res> get newStreak;
}

/// @nodoc
class __$$StreakActionResultFreezeTokenUsedImplCopyWithImpl<$Res>
    extends _$StreakActionResultCopyWithImpl<$Res,
        _$StreakActionResultFreezeTokenUsedImpl>
    implements _$$StreakActionResultFreezeTokenUsedImplCopyWith<$Res> {
  __$$StreakActionResultFreezeTokenUsedImplCopyWithImpl(
      _$StreakActionResultFreezeTokenUsedImpl _value,
      $Res Function(_$StreakActionResultFreezeTokenUsedImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? newStreak = null,
    Object? tokensUsed = null,
    Object? message = null,
  }) {
    return _then(_$StreakActionResultFreezeTokenUsedImpl(
      newStreak: null == newStreak
          ? _value.newStreak
          : newStreak // ignore: cast_nullable_to_non_nullable
              as Streak,
      tokensUsed: null == tokensUsed
          ? _value.tokensUsed
          : tokensUsed // ignore: cast_nullable_to_non_nullable
              as int,
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }

  @override
  @pragma('vm:prefer-inline')
  $StreakCopyWith<$Res> get newStreak {
    return $StreakCopyWith<$Res>(_value.newStreak, (value) {
      return _then(_value.copyWith(newStreak: value));
    });
  }
}

/// @nodoc
@JsonSerializable()
class _$StreakActionResultFreezeTokenUsedImpl
    implements _StreakActionResultFreezeTokenUsed {
  const _$StreakActionResultFreezeTokenUsedImpl(
      {required this.newStreak,
      required this.tokensUsed,
      required this.message,
      final String? $type})
      : $type = $type ?? 'freezeTokenUsed';

  factory _$StreakActionResultFreezeTokenUsedImpl.fromJson(
          Map<String, dynamic> json) =>
      _$$StreakActionResultFreezeTokenUsedImplFromJson(json);

  @override
  final Streak newStreak;
  @override
  final int tokensUsed;
  @override
  final String message;

  @JsonKey(name: 'runtimeType')
  final String $type;

  @override
  String toString() {
    return 'StreakActionResult.freezeTokenUsed(newStreak: $newStreak, tokensUsed: $tokensUsed, message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StreakActionResultFreezeTokenUsedImpl &&
            (identical(other.newStreak, newStreak) ||
                other.newStreak == newStreak) &&
            (identical(other.tokensUsed, tokensUsed) ||
                other.tokensUsed == tokensUsed) &&
            (identical(other.message, message) || other.message == message));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, newStreak, tokensUsed, message);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$StreakActionResultFreezeTokenUsedImplCopyWith<
          _$StreakActionResultFreezeTokenUsedImpl>
      get copyWith => __$$StreakActionResultFreezeTokenUsedImplCopyWithImpl<
          _$StreakActionResultFreezeTokenUsedImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
            Streak newStreak,
            List<StreakMilestone> newMilestones,
            int xpEarned,
            int freezeTokensEarned,
            int graceDaysEarned,
            String message)
        success,
    required TResult Function(
            Streak newStreak, GraceDayUsage graceDayUsage, String message)
        graceDayUsed,
    required TResult Function(Streak newStreak, int tokensUsed, String message)
        freezeTokenUsed,
    required TResult Function(Streak newStreak, int previousStreak,
            String message, String encouragementMessage)
        streakBroken,
    required TResult Function(Streak streak, String message) alreadyMarked,
  }) {
    return freezeTokenUsed(newStreak, tokensUsed, message);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(
            Streak newStreak,
            List<StreakMilestone> newMilestones,
            int xpEarned,
            int freezeTokensEarned,
            int graceDaysEarned,
            String message)?
        success,
    TResult? Function(
            Streak newStreak, GraceDayUsage graceDayUsage, String message)?
        graceDayUsed,
    TResult? Function(Streak newStreak, int tokensUsed, String message)?
        freezeTokenUsed,
    TResult? Function(Streak newStreak, int previousStreak, String message,
            String encouragementMessage)?
        streakBroken,
    TResult? Function(Streak streak, String message)? alreadyMarked,
  }) {
    return freezeTokenUsed?.call(newStreak, tokensUsed, message);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(
            Streak newStreak,
            List<StreakMilestone> newMilestones,
            int xpEarned,
            int freezeTokensEarned,
            int graceDaysEarned,
            String message)?
        success,
    TResult Function(
            Streak newStreak, GraceDayUsage graceDayUsage, String message)?
        graceDayUsed,
    TResult Function(Streak newStreak, int tokensUsed, String message)?
        freezeTokenUsed,
    TResult Function(Streak newStreak, int previousStreak, String message,
            String encouragementMessage)?
        streakBroken,
    TResult Function(Streak streak, String message)? alreadyMarked,
    required TResult orElse(),
  }) {
    if (freezeTokenUsed != null) {
      return freezeTokenUsed(newStreak, tokensUsed, message);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_StreakActionResultSuccess value) success,
    required TResult Function(_StreakActionResultGraceDayUsed value)
        graceDayUsed,
    required TResult Function(_StreakActionResultFreezeTokenUsed value)
        freezeTokenUsed,
    required TResult Function(_StreakActionResultStreakBroken value)
        streakBroken,
    required TResult Function(_StreakActionResultAlreadyMarked value)
        alreadyMarked,
  }) {
    return freezeTokenUsed(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_StreakActionResultSuccess value)? success,
    TResult? Function(_StreakActionResultGraceDayUsed value)? graceDayUsed,
    TResult? Function(_StreakActionResultFreezeTokenUsed value)?
        freezeTokenUsed,
    TResult? Function(_StreakActionResultStreakBroken value)? streakBroken,
    TResult? Function(_StreakActionResultAlreadyMarked value)? alreadyMarked,
  }) {
    return freezeTokenUsed?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_StreakActionResultSuccess value)? success,
    TResult Function(_StreakActionResultGraceDayUsed value)? graceDayUsed,
    TResult Function(_StreakActionResultFreezeTokenUsed value)? freezeTokenUsed,
    TResult Function(_StreakActionResultStreakBroken value)? streakBroken,
    TResult Function(_StreakActionResultAlreadyMarked value)? alreadyMarked,
    required TResult orElse(),
  }) {
    if (freezeTokenUsed != null) {
      return freezeTokenUsed(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$StreakActionResultFreezeTokenUsedImplToJson(
      this,
    );
  }
}

abstract class _StreakActionResultFreezeTokenUsed
    implements StreakActionResult {
  const factory _StreakActionResultFreezeTokenUsed(
      {required final Streak newStreak,
      required final int tokensUsed,
      required final String message}) = _$StreakActionResultFreezeTokenUsedImpl;

  factory _StreakActionResultFreezeTokenUsed.fromJson(
          Map<String, dynamic> json) =
      _$StreakActionResultFreezeTokenUsedImpl.fromJson;

  Streak get newStreak;
  int get tokensUsed;
  @override
  String get message;
  @override
  @JsonKey(ignore: true)
  _$$StreakActionResultFreezeTokenUsedImplCopyWith<
          _$StreakActionResultFreezeTokenUsedImpl>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$StreakActionResultStreakBrokenImplCopyWith<$Res>
    implements $StreakActionResultCopyWith<$Res> {
  factory _$$StreakActionResultStreakBrokenImplCopyWith(
          _$StreakActionResultStreakBrokenImpl value,
          $Res Function(_$StreakActionResultStreakBrokenImpl) then) =
      __$$StreakActionResultStreakBrokenImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {Streak newStreak,
      int previousStreak,
      String message,
      String encouragementMessage});

  $StreakCopyWith<$Res> get newStreak;
}

/// @nodoc
class __$$StreakActionResultStreakBrokenImplCopyWithImpl<$Res>
    extends _$StreakActionResultCopyWithImpl<$Res,
        _$StreakActionResultStreakBrokenImpl>
    implements _$$StreakActionResultStreakBrokenImplCopyWith<$Res> {
  __$$StreakActionResultStreakBrokenImplCopyWithImpl(
      _$StreakActionResultStreakBrokenImpl _value,
      $Res Function(_$StreakActionResultStreakBrokenImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? newStreak = null,
    Object? previousStreak = null,
    Object? message = null,
    Object? encouragementMessage = null,
  }) {
    return _then(_$StreakActionResultStreakBrokenImpl(
      newStreak: null == newStreak
          ? _value.newStreak
          : newStreak // ignore: cast_nullable_to_non_nullable
              as Streak,
      previousStreak: null == previousStreak
          ? _value.previousStreak
          : previousStreak // ignore: cast_nullable_to_non_nullable
              as int,
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      encouragementMessage: null == encouragementMessage
          ? _value.encouragementMessage
          : encouragementMessage // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }

  @override
  @pragma('vm:prefer-inline')
  $StreakCopyWith<$Res> get newStreak {
    return $StreakCopyWith<$Res>(_value.newStreak, (value) {
      return _then(_value.copyWith(newStreak: value));
    });
  }
}

/// @nodoc
@JsonSerializable()
class _$StreakActionResultStreakBrokenImpl
    implements _StreakActionResultStreakBroken {
  const _$StreakActionResultStreakBrokenImpl(
      {required this.newStreak,
      required this.previousStreak,
      required this.message,
      required this.encouragementMessage,
      final String? $type})
      : $type = $type ?? 'streakBroken';

  factory _$StreakActionResultStreakBrokenImpl.fromJson(
          Map<String, dynamic> json) =>
      _$$StreakActionResultStreakBrokenImplFromJson(json);

  @override
  final Streak newStreak;
  @override
  final int previousStreak;
  @override
  final String message;
  @override
  final String encouragementMessage;

  @JsonKey(name: 'runtimeType')
  final String $type;

  @override
  String toString() {
    return 'StreakActionResult.streakBroken(newStreak: $newStreak, previousStreak: $previousStreak, message: $message, encouragementMessage: $encouragementMessage)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StreakActionResultStreakBrokenImpl &&
            (identical(other.newStreak, newStreak) ||
                other.newStreak == newStreak) &&
            (identical(other.previousStreak, previousStreak) ||
                other.previousStreak == previousStreak) &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.encouragementMessage, encouragementMessage) ||
                other.encouragementMessage == encouragementMessage));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, newStreak, previousStreak, message, encouragementMessage);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$StreakActionResultStreakBrokenImplCopyWith<
          _$StreakActionResultStreakBrokenImpl>
      get copyWith => __$$StreakActionResultStreakBrokenImplCopyWithImpl<
          _$StreakActionResultStreakBrokenImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
            Streak newStreak,
            List<StreakMilestone> newMilestones,
            int xpEarned,
            int freezeTokensEarned,
            int graceDaysEarned,
            String message)
        success,
    required TResult Function(
            Streak newStreak, GraceDayUsage graceDayUsage, String message)
        graceDayUsed,
    required TResult Function(Streak newStreak, int tokensUsed, String message)
        freezeTokenUsed,
    required TResult Function(Streak newStreak, int previousStreak,
            String message, String encouragementMessage)
        streakBroken,
    required TResult Function(Streak streak, String message) alreadyMarked,
  }) {
    return streakBroken(
        newStreak, previousStreak, message, encouragementMessage);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(
            Streak newStreak,
            List<StreakMilestone> newMilestones,
            int xpEarned,
            int freezeTokensEarned,
            int graceDaysEarned,
            String message)?
        success,
    TResult? Function(
            Streak newStreak, GraceDayUsage graceDayUsage, String message)?
        graceDayUsed,
    TResult? Function(Streak newStreak, int tokensUsed, String message)?
        freezeTokenUsed,
    TResult? Function(Streak newStreak, int previousStreak, String message,
            String encouragementMessage)?
        streakBroken,
    TResult? Function(Streak streak, String message)? alreadyMarked,
  }) {
    return streakBroken?.call(
        newStreak, previousStreak, message, encouragementMessage);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(
            Streak newStreak,
            List<StreakMilestone> newMilestones,
            int xpEarned,
            int freezeTokensEarned,
            int graceDaysEarned,
            String message)?
        success,
    TResult Function(
            Streak newStreak, GraceDayUsage graceDayUsage, String message)?
        graceDayUsed,
    TResult Function(Streak newStreak, int tokensUsed, String message)?
        freezeTokenUsed,
    TResult Function(Streak newStreak, int previousStreak, String message,
            String encouragementMessage)?
        streakBroken,
    TResult Function(Streak streak, String message)? alreadyMarked,
    required TResult orElse(),
  }) {
    if (streakBroken != null) {
      return streakBroken(
          newStreak, previousStreak, message, encouragementMessage);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_StreakActionResultSuccess value) success,
    required TResult Function(_StreakActionResultGraceDayUsed value)
        graceDayUsed,
    required TResult Function(_StreakActionResultFreezeTokenUsed value)
        freezeTokenUsed,
    required TResult Function(_StreakActionResultStreakBroken value)
        streakBroken,
    required TResult Function(_StreakActionResultAlreadyMarked value)
        alreadyMarked,
  }) {
    return streakBroken(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_StreakActionResultSuccess value)? success,
    TResult? Function(_StreakActionResultGraceDayUsed value)? graceDayUsed,
    TResult? Function(_StreakActionResultFreezeTokenUsed value)?
        freezeTokenUsed,
    TResult? Function(_StreakActionResultStreakBroken value)? streakBroken,
    TResult? Function(_StreakActionResultAlreadyMarked value)? alreadyMarked,
  }) {
    return streakBroken?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_StreakActionResultSuccess value)? success,
    TResult Function(_StreakActionResultGraceDayUsed value)? graceDayUsed,
    TResult Function(_StreakActionResultFreezeTokenUsed value)? freezeTokenUsed,
    TResult Function(_StreakActionResultStreakBroken value)? streakBroken,
    TResult Function(_StreakActionResultAlreadyMarked value)? alreadyMarked,
    required TResult orElse(),
  }) {
    if (streakBroken != null) {
      return streakBroken(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$StreakActionResultStreakBrokenImplToJson(
      this,
    );
  }
}

abstract class _StreakActionResultStreakBroken implements StreakActionResult {
  const factory _StreakActionResultStreakBroken(
          {required final Streak newStreak,
          required final int previousStreak,
          required final String message,
          required final String encouragementMessage}) =
      _$StreakActionResultStreakBrokenImpl;

  factory _StreakActionResultStreakBroken.fromJson(Map<String, dynamic> json) =
      _$StreakActionResultStreakBrokenImpl.fromJson;

  Streak get newStreak;
  int get previousStreak;
  @override
  String get message;
  String get encouragementMessage;
  @override
  @JsonKey(ignore: true)
  _$$StreakActionResultStreakBrokenImplCopyWith<
          _$StreakActionResultStreakBrokenImpl>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$StreakActionResultAlreadyMarkedImplCopyWith<$Res>
    implements $StreakActionResultCopyWith<$Res> {
  factory _$$StreakActionResultAlreadyMarkedImplCopyWith(
          _$StreakActionResultAlreadyMarkedImpl value,
          $Res Function(_$StreakActionResultAlreadyMarkedImpl) then) =
      __$$StreakActionResultAlreadyMarkedImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({Streak streak, String message});

  $StreakCopyWith<$Res> get streak;
}

/// @nodoc
class __$$StreakActionResultAlreadyMarkedImplCopyWithImpl<$Res>
    extends _$StreakActionResultCopyWithImpl<$Res,
        _$StreakActionResultAlreadyMarkedImpl>
    implements _$$StreakActionResultAlreadyMarkedImplCopyWith<$Res> {
  __$$StreakActionResultAlreadyMarkedImplCopyWithImpl(
      _$StreakActionResultAlreadyMarkedImpl _value,
      $Res Function(_$StreakActionResultAlreadyMarkedImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? streak = null,
    Object? message = null,
  }) {
    return _then(_$StreakActionResultAlreadyMarkedImpl(
      streak: null == streak
          ? _value.streak
          : streak // ignore: cast_nullable_to_non_nullable
              as Streak,
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }

  @override
  @pragma('vm:prefer-inline')
  $StreakCopyWith<$Res> get streak {
    return $StreakCopyWith<$Res>(_value.streak, (value) {
      return _then(_value.copyWith(streak: value));
    });
  }
}

/// @nodoc
@JsonSerializable()
class _$StreakActionResultAlreadyMarkedImpl
    implements _StreakActionResultAlreadyMarked {
  const _$StreakActionResultAlreadyMarkedImpl(
      {required this.streak, required this.message, final String? $type})
      : $type = $type ?? 'alreadyMarked';

  factory _$StreakActionResultAlreadyMarkedImpl.fromJson(
          Map<String, dynamic> json) =>
      _$$StreakActionResultAlreadyMarkedImplFromJson(json);

  @override
  final Streak streak;
  @override
  final String message;

  @JsonKey(name: 'runtimeType')
  final String $type;

  @override
  String toString() {
    return 'StreakActionResult.alreadyMarked(streak: $streak, message: $message)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StreakActionResultAlreadyMarkedImpl &&
            (identical(other.streak, streak) || other.streak == streak) &&
            (identical(other.message, message) || other.message == message));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, streak, message);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$StreakActionResultAlreadyMarkedImplCopyWith<
          _$StreakActionResultAlreadyMarkedImpl>
      get copyWith => __$$StreakActionResultAlreadyMarkedImplCopyWithImpl<
          _$StreakActionResultAlreadyMarkedImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(
            Streak newStreak,
            List<StreakMilestone> newMilestones,
            int xpEarned,
            int freezeTokensEarned,
            int graceDaysEarned,
            String message)
        success,
    required TResult Function(
            Streak newStreak, GraceDayUsage graceDayUsage, String message)
        graceDayUsed,
    required TResult Function(Streak newStreak, int tokensUsed, String message)
        freezeTokenUsed,
    required TResult Function(Streak newStreak, int previousStreak,
            String message, String encouragementMessage)
        streakBroken,
    required TResult Function(Streak streak, String message) alreadyMarked,
  }) {
    return alreadyMarked(streak, message);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(
            Streak newStreak,
            List<StreakMilestone> newMilestones,
            int xpEarned,
            int freezeTokensEarned,
            int graceDaysEarned,
            String message)?
        success,
    TResult? Function(
            Streak newStreak, GraceDayUsage graceDayUsage, String message)?
        graceDayUsed,
    TResult? Function(Streak newStreak, int tokensUsed, String message)?
        freezeTokenUsed,
    TResult? Function(Streak newStreak, int previousStreak, String message,
            String encouragementMessage)?
        streakBroken,
    TResult? Function(Streak streak, String message)? alreadyMarked,
  }) {
    return alreadyMarked?.call(streak, message);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(
            Streak newStreak,
            List<StreakMilestone> newMilestones,
            int xpEarned,
            int freezeTokensEarned,
            int graceDaysEarned,
            String message)?
        success,
    TResult Function(
            Streak newStreak, GraceDayUsage graceDayUsage, String message)?
        graceDayUsed,
    TResult Function(Streak newStreak, int tokensUsed, String message)?
        freezeTokenUsed,
    TResult Function(Streak newStreak, int previousStreak, String message,
            String encouragementMessage)?
        streakBroken,
    TResult Function(Streak streak, String message)? alreadyMarked,
    required TResult orElse(),
  }) {
    if (alreadyMarked != null) {
      return alreadyMarked(streak, message);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_StreakActionResultSuccess value) success,
    required TResult Function(_StreakActionResultGraceDayUsed value)
        graceDayUsed,
    required TResult Function(_StreakActionResultFreezeTokenUsed value)
        freezeTokenUsed,
    required TResult Function(_StreakActionResultStreakBroken value)
        streakBroken,
    required TResult Function(_StreakActionResultAlreadyMarked value)
        alreadyMarked,
  }) {
    return alreadyMarked(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_StreakActionResultSuccess value)? success,
    TResult? Function(_StreakActionResultGraceDayUsed value)? graceDayUsed,
    TResult? Function(_StreakActionResultFreezeTokenUsed value)?
        freezeTokenUsed,
    TResult? Function(_StreakActionResultStreakBroken value)? streakBroken,
    TResult? Function(_StreakActionResultAlreadyMarked value)? alreadyMarked,
  }) {
    return alreadyMarked?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_StreakActionResultSuccess value)? success,
    TResult Function(_StreakActionResultGraceDayUsed value)? graceDayUsed,
    TResult Function(_StreakActionResultFreezeTokenUsed value)? freezeTokenUsed,
    TResult Function(_StreakActionResultStreakBroken value)? streakBroken,
    TResult Function(_StreakActionResultAlreadyMarked value)? alreadyMarked,
    required TResult orElse(),
  }) {
    if (alreadyMarked != null) {
      return alreadyMarked(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$$StreakActionResultAlreadyMarkedImplToJson(
      this,
    );
  }
}

abstract class _StreakActionResultAlreadyMarked implements StreakActionResult {
  const factory _StreakActionResultAlreadyMarked(
      {required final Streak streak,
      required final String message}) = _$StreakActionResultAlreadyMarkedImpl;

  factory _StreakActionResultAlreadyMarked.fromJson(Map<String, dynamic> json) =
      _$StreakActionResultAlreadyMarkedImpl.fromJson;

  Streak get streak;
  @override
  String get message;
  @override
  @JsonKey(ignore: true)
  _$$StreakActionResultAlreadyMarkedImplCopyWith<
          _$StreakActionResultAlreadyMarkedImpl>
      get copyWith => throw _privateConstructorUsedError;
}
