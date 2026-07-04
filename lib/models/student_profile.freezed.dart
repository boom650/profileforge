// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'student_profile.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

StudentProfile _$StudentProfileFromJson(Map<String, dynamic> json) {
  return _StudentProfile.fromJson(json);
}

/// @nodoc
mixin _$StudentProfile {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get email => throw _privateConstructorUsedError;
  String get phone => throw _privateConstructorUsedError;
  String? get board => throw _privateConstructorUsedError;
  String? get stream => throw _privateConstructorUsedError;
  int get grade => throw _privateConstructorUsedError;
  Map<String, double> get subjects => throw _privateConstructorUsedError;
  double get tenthPercentage => throw _privateConstructorUsedError;
  String get coachingInstitute => throw _privateConstructorUsedError;
  int get coachingHoursPerWeek => throw _privateConstructorUsedError;
  int? get satScore => throw _privateConstructorUsedError;
  double? get ieltsScore => throw _privateConstructorUsedError;
  List<String> get targetCountries => throw _privateConstructorUsedError;
  String get targetMajor => throw _privateConstructorUsedError;
  List<String> get reachUniversities => throw _privateConstructorUsedError;
  List<String> get matchUniversities => throw _privateConstructorUsedError;
  List<String> get safetyUniversities => throw _privateConstructorUsedError;
  List<Activity> get activities => throw _privateConstructorUsedError;
  WeeklySchedule get schedule => throw _privateConstructorUsedError;
  MotivationProfile get motivation => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime get updatedAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $StudentProfileCopyWith<StudentProfile> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $StudentProfileCopyWith<$Res> {
  factory $StudentProfileCopyWith(
          StudentProfile value, $Res Function(StudentProfile) then) =
      _$StudentProfileCopyWithImpl<$Res, StudentProfile>;
  @useResult
  $Res call(
      {String id,
      String name,
      String email,
      String phone,
      String? board,
      String? stream,
      int grade,
      Map<String, double> subjects,
      double tenthPercentage,
      String coachingInstitute,
      int coachingHoursPerWeek,
      int? satScore,
      double? ieltsScore,
      List<String> targetCountries,
      String targetMajor,
      List<String> reachUniversities,
      List<String> matchUniversities,
      List<String> safetyUniversities,
      List<Activity> activities,
      WeeklySchedule schedule,
      MotivationProfile motivation,
      DateTime createdAt,
      DateTime updatedAt});

  $WeeklyScheduleCopyWith<$Res> get schedule;
  $MotivationProfileCopyWith<$Res> get motivation;
}

/// @nodoc
class _$StudentProfileCopyWithImpl<$Res, $Val extends StudentProfile>
    implements $StudentProfileCopyWith<$Res> {
  _$StudentProfileCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? email = null,
    Object? phone = null,
    Object? board = freezed,
    Object? stream = freezed,
    Object? grade = null,
    Object? subjects = null,
    Object? tenthPercentage = null,
    Object? coachingInstitute = null,
    Object? coachingHoursPerWeek = null,
    Object? satScore = freezed,
    Object? ieltsScore = freezed,
    Object? targetCountries = null,
    Object? targetMajor = null,
    Object? reachUniversities = null,
    Object? matchUniversities = null,
    Object? safetyUniversities = null,
    Object? activities = null,
    Object? schedule = null,
    Object? motivation = null,
    Object? createdAt = null,
    Object? updatedAt = null,
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
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      phone: null == phone
          ? _value.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String,
      board: freezed == board
          ? _value.board
          : board // ignore: cast_nullable_to_non_nullable
              as String?,
      stream: freezed == stream
          ? _value.stream
          : stream // ignore: cast_nullable_to_non_nullable
              as String?,
      grade: null == grade
          ? _value.grade
          : grade // ignore: cast_nullable_to_non_nullable
              as int,
      subjects: null == subjects
          ? _value.subjects
          : subjects // ignore: cast_nullable_to_non_nullable
              as Map<String, double>,
      tenthPercentage: null == tenthPercentage
          ? _value.tenthPercentage
          : tenthPercentage // ignore: cast_nullable_to_non_nullable
              as double,
      coachingInstitute: null == coachingInstitute
          ? _value.coachingInstitute
          : coachingInstitute // ignore: cast_nullable_to_non_nullable
              as String,
      coachingHoursPerWeek: null == coachingHoursPerWeek
          ? _value.coachingHoursPerWeek
          : coachingHoursPerWeek // ignore: cast_nullable_to_non_nullable
              as int,
      satScore: freezed == satScore
          ? _value.satScore
          : satScore // ignore: cast_nullable_to_non_nullable
              as int?,
      ieltsScore: freezed == ieltsScore
          ? _value.ieltsScore
          : ieltsScore // ignore: cast_nullable_to_non_nullable
              as double?,
      targetCountries: null == targetCountries
          ? _value.targetCountries
          : targetCountries // ignore: cast_nullable_to_non_nullable
              as List<String>,
      targetMajor: null == targetMajor
          ? _value.targetMajor
          : targetMajor // ignore: cast_nullable_to_non_nullable
              as String,
      reachUniversities: null == reachUniversities
          ? _value.reachUniversities
          : reachUniversities // ignore: cast_nullable_to_non_nullable
              as List<String>,
      matchUniversities: null == matchUniversities
          ? _value.matchUniversities
          : matchUniversities // ignore: cast_nullable_to_non_nullable
              as List<String>,
      safetyUniversities: null == safetyUniversities
          ? _value.safetyUniversities
          : safetyUniversities // ignore: cast_nullable_to_non_nullable
              as List<String>,
      activities: null == activities
          ? _value.activities
          : activities // ignore: cast_nullable_to_non_nullable
              as List<Activity>,
      schedule: null == schedule
          ? _value.schedule
          : schedule // ignore: cast_nullable_to_non_nullable
              as WeeklySchedule,
      motivation: null == motivation
          ? _value.motivation
          : motivation // ignore: cast_nullable_to_non_nullable
              as MotivationProfile,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $WeeklyScheduleCopyWith<$Res> get schedule {
    return $WeeklyScheduleCopyWith<$Res>(_value.schedule, (value) {
      return _then(_value.copyWith(schedule: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $MotivationProfileCopyWith<$Res> get motivation {
    return $MotivationProfileCopyWith<$Res>(_value.motivation, (value) {
      return _then(_value.copyWith(motivation: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$StudentProfileImplCopyWith<$Res>
    implements $StudentProfileCopyWith<$Res> {
  factory _$$StudentProfileImplCopyWith(_$StudentProfileImpl value,
          $Res Function(_$StudentProfileImpl) then) =
      __$$StudentProfileImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String name,
      String email,
      String phone,
      String? board,
      String? stream,
      int grade,
      Map<String, double> subjects,
      double tenthPercentage,
      String coachingInstitute,
      int coachingHoursPerWeek,
      int? satScore,
      double? ieltsScore,
      List<String> targetCountries,
      String targetMajor,
      List<String> reachUniversities,
      List<String> matchUniversities,
      List<String> safetyUniversities,
      List<Activity> activities,
      WeeklySchedule schedule,
      MotivationProfile motivation,
      DateTime createdAt,
      DateTime updatedAt});

  @override
  $WeeklyScheduleCopyWith<$Res> get schedule;
  @override
  $MotivationProfileCopyWith<$Res> get motivation;
}

/// @nodoc
class __$$StudentProfileImplCopyWithImpl<$Res>
    extends _$StudentProfileCopyWithImpl<$Res, _$StudentProfileImpl>
    implements _$$StudentProfileImplCopyWith<$Res> {
  __$$StudentProfileImplCopyWithImpl(
      _$StudentProfileImpl _value, $Res Function(_$StudentProfileImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? email = null,
    Object? phone = null,
    Object? board = freezed,
    Object? stream = freezed,
    Object? grade = null,
    Object? subjects = null,
    Object? tenthPercentage = null,
    Object? coachingInstitute = null,
    Object? coachingHoursPerWeek = null,
    Object? satScore = freezed,
    Object? ieltsScore = freezed,
    Object? targetCountries = null,
    Object? targetMajor = null,
    Object? reachUniversities = null,
    Object? matchUniversities = null,
    Object? safetyUniversities = null,
    Object? activities = null,
    Object? schedule = null,
    Object? motivation = null,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(_$StudentProfileImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      email: null == email
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      phone: null == phone
          ? _value.phone
          : phone // ignore: cast_nullable_to_non_nullable
              as String,
      board: freezed == board
          ? _value.board
          : board // ignore: cast_nullable_to_non_nullable
              as String?,
      stream: freezed == stream
          ? _value.stream
          : stream // ignore: cast_nullable_to_non_nullable
              as String?,
      grade: null == grade
          ? _value.grade
          : grade // ignore: cast_nullable_to_non_nullable
              as int,
      subjects: null == subjects
          ? _value._subjects
          : subjects // ignore: cast_nullable_to_non_nullable
              as Map<String, double>,
      tenthPercentage: null == tenthPercentage
          ? _value.tenthPercentage
          : tenthPercentage // ignore: cast_nullable_to_non_nullable
              as double,
      coachingInstitute: null == coachingInstitute
          ? _value.coachingInstitute
          : coachingInstitute // ignore: cast_nullable_to_non_nullable
              as String,
      coachingHoursPerWeek: null == coachingHoursPerWeek
          ? _value.coachingHoursPerWeek
          : coachingHoursPerWeek // ignore: cast_nullable_to_non_nullable
              as int,
      satScore: freezed == satScore
          ? _value.satScore
          : satScore // ignore: cast_nullable_to_non_nullable
              as int?,
      ieltsScore: freezed == ieltsScore
          ? _value.ieltsScore
          : ieltsScore // ignore: cast_nullable_to_non_nullable
              as double?,
      targetCountries: null == targetCountries
          ? _value._targetCountries
          : targetCountries // ignore: cast_nullable_to_non_nullable
              as List<String>,
      targetMajor: null == targetMajor
          ? _value.targetMajor
          : targetMajor // ignore: cast_nullable_to_non_nullable
              as String,
      reachUniversities: null == reachUniversities
          ? _value._reachUniversities
          : reachUniversities // ignore: cast_nullable_to_non_nullable
              as List<String>,
      matchUniversities: null == matchUniversities
          ? _value._matchUniversities
          : matchUniversities // ignore: cast_nullable_to_non_nullable
              as List<String>,
      safetyUniversities: null == safetyUniversities
          ? _value._safetyUniversities
          : safetyUniversities // ignore: cast_nullable_to_non_nullable
              as List<String>,
      activities: null == activities
          ? _value._activities
          : activities // ignore: cast_nullable_to_non_nullable
              as List<Activity>,
      schedule: null == schedule
          ? _value.schedule
          : schedule // ignore: cast_nullable_to_non_nullable
              as WeeklySchedule,
      motivation: null == motivation
          ? _value.motivation
          : motivation // ignore: cast_nullable_to_non_nullable
              as MotivationProfile,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$StudentProfileImpl implements _StudentProfile {
  const _$StudentProfileImpl(
      {required this.id,
      required this.name,
      required this.email,
      required this.phone,
      this.board,
      this.stream,
      required this.grade,
      required final Map<String, double> subjects,
      required this.tenthPercentage,
      required this.coachingInstitute,
      required this.coachingHoursPerWeek,
      required this.satScore,
      required this.ieltsScore,
      required final List<String> targetCountries,
      required this.targetMajor,
      required final List<String> reachUniversities,
      required final List<String> matchUniversities,
      required final List<String> safetyUniversities,
      required final List<Activity> activities,
      required this.schedule,
      required this.motivation,
      required this.createdAt,
      required this.updatedAt})
      : _subjects = subjects,
        _targetCountries = targetCountries,
        _reachUniversities = reachUniversities,
        _matchUniversities = matchUniversities,
        _safetyUniversities = safetyUniversities,
        _activities = activities;

  factory _$StudentProfileImpl.fromJson(Map<String, dynamic> json) =>
      _$$StudentProfileImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final String email;
  @override
  final String phone;
  @override
  final String? board;
  @override
  final String? stream;
  @override
  final int grade;
  final Map<String, double> _subjects;
  @override
  Map<String, double> get subjects {
    if (_subjects is EqualUnmodifiableMapView) return _subjects;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_subjects);
  }

  @override
  final double tenthPercentage;
  @override
  final String coachingInstitute;
  @override
  final int coachingHoursPerWeek;
  @override
  final int? satScore;
  @override
  final double? ieltsScore;
  final List<String> _targetCountries;
  @override
  List<String> get targetCountries {
    if (_targetCountries is EqualUnmodifiableListView) return _targetCountries;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_targetCountries);
  }

  @override
  final String targetMajor;
  final List<String> _reachUniversities;
  @override
  List<String> get reachUniversities {
    if (_reachUniversities is EqualUnmodifiableListView)
      return _reachUniversities;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_reachUniversities);
  }

  final List<String> _matchUniversities;
  @override
  List<String> get matchUniversities {
    if (_matchUniversities is EqualUnmodifiableListView)
      return _matchUniversities;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_matchUniversities);
  }

  final List<String> _safetyUniversities;
  @override
  List<String> get safetyUniversities {
    if (_safetyUniversities is EqualUnmodifiableListView)
      return _safetyUniversities;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_safetyUniversities);
  }

  final List<Activity> _activities;
  @override
  List<Activity> get activities {
    if (_activities is EqualUnmodifiableListView) return _activities;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_activities);
  }

  @override
  final WeeklySchedule schedule;
  @override
  final MotivationProfile motivation;
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;

  @override
  String toString() {
    return 'StudentProfile(id: $id, name: $name, email: $email, phone: $phone, board: $board, stream: $stream, grade: $grade, subjects: $subjects, tenthPercentage: $tenthPercentage, coachingInstitute: $coachingInstitute, coachingHoursPerWeek: $coachingHoursPerWeek, satScore: $satScore, ieltsScore: $ieltsScore, targetCountries: $targetCountries, targetMajor: $targetMajor, reachUniversities: $reachUniversities, matchUniversities: $matchUniversities, safetyUniversities: $safetyUniversities, activities: $activities, schedule: $schedule, motivation: $motivation, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StudentProfileImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.phone, phone) || other.phone == phone) &&
            (identical(other.board, board) || other.board == board) &&
            (identical(other.stream, stream) || other.stream == stream) &&
            (identical(other.grade, grade) || other.grade == grade) &&
            const DeepCollectionEquality().equals(other._subjects, _subjects) &&
            (identical(other.tenthPercentage, tenthPercentage) ||
                other.tenthPercentage == tenthPercentage) &&
            (identical(other.coachingInstitute, coachingInstitute) ||
                other.coachingInstitute == coachingInstitute) &&
            (identical(other.coachingHoursPerWeek, coachingHoursPerWeek) ||
                other.coachingHoursPerWeek == coachingHoursPerWeek) &&
            (identical(other.satScore, satScore) ||
                other.satScore == satScore) &&
            (identical(other.ieltsScore, ieltsScore) ||
                other.ieltsScore == ieltsScore) &&
            const DeepCollectionEquality()
                .equals(other._targetCountries, _targetCountries) &&
            (identical(other.targetMajor, targetMajor) ||
                other.targetMajor == targetMajor) &&
            const DeepCollectionEquality()
                .equals(other._reachUniversities, _reachUniversities) &&
            const DeepCollectionEquality()
                .equals(other._matchUniversities, _matchUniversities) &&
            const DeepCollectionEquality()
                .equals(other._safetyUniversities, _safetyUniversities) &&
            const DeepCollectionEquality()
                .equals(other._activities, _activities) &&
            (identical(other.schedule, schedule) ||
                other.schedule == schedule) &&
            (identical(other.motivation, motivation) ||
                other.motivation == motivation) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        id,
        name,
        email,
        phone,
        board,
        stream,
        grade,
        const DeepCollectionEquality().hash(_subjects),
        tenthPercentage,
        coachingInstitute,
        coachingHoursPerWeek,
        satScore,
        ieltsScore,
        const DeepCollectionEquality().hash(_targetCountries),
        targetMajor,
        const DeepCollectionEquality().hash(_reachUniversities),
        const DeepCollectionEquality().hash(_matchUniversities),
        const DeepCollectionEquality().hash(_safetyUniversities),
        const DeepCollectionEquality().hash(_activities),
        schedule,
        motivation,
        createdAt,
        updatedAt
      ]);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$StudentProfileImplCopyWith<_$StudentProfileImpl> get copyWith =>
      __$$StudentProfileImplCopyWithImpl<_$StudentProfileImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$StudentProfileImplToJson(
      this,
    );
  }
}

abstract class _StudentProfile implements StudentProfile {
  const factory _StudentProfile(
      {required final String id,
      required final String name,
      required final String email,
      required final String phone,
      final String? board,
      final String? stream,
      required final int grade,
      required final Map<String, double> subjects,
      required final double tenthPercentage,
      required final String coachingInstitute,
      required final int coachingHoursPerWeek,
      required final int? satScore,
      required final double? ieltsScore,
      required final List<String> targetCountries,
      required final String targetMajor,
      required final List<String> reachUniversities,
      required final List<String> matchUniversities,
      required final List<String> safetyUniversities,
      required final List<Activity> activities,
      required final WeeklySchedule schedule,
      required final MotivationProfile motivation,
      required final DateTime createdAt,
      required final DateTime updatedAt}) = _$StudentProfileImpl;

  factory _StudentProfile.fromJson(Map<String, dynamic> json) =
      _$StudentProfileImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  String get email;
  @override
  String get phone;
  @override
  String? get board;
  @override
  String? get stream;
  @override
  int get grade;
  @override
  Map<String, double> get subjects;
  @override
  double get tenthPercentage;
  @override
  String get coachingInstitute;
  @override
  int get coachingHoursPerWeek;
  @override
  int? get satScore;
  @override
  double? get ieltsScore;
  @override
  List<String> get targetCountries;
  @override
  String get targetMajor;
  @override
  List<String> get reachUniversities;
  @override
  List<String> get matchUniversities;
  @override
  List<String> get safetyUniversities;
  @override
  List<Activity> get activities;
  @override
  WeeklySchedule get schedule;
  @override
  MotivationProfile get motivation;
  @override
  DateTime get createdAt;
  @override
  DateTime get updatedAt;
  @override
  @JsonKey(ignore: true)
  _$$StudentProfileImplCopyWith<_$StudentProfileImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

Activity _$ActivityFromJson(Map<String, dynamic> json) {
  return _Activity.fromJson(json);
}

/// @nodoc
mixin _$Activity {
  String get id => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  ActivityCategory get category => throw _privateConstructorUsedError;
  ActivityTier get tier => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  int get hoursPerWeek => throw _privateConstructorUsedError;
  int get weeksPerYear =>
      throw _privateConstructorUsedError; // Common App fields
  String? get position => throw _privateConstructorUsedError;
  String? get organizationName => throw _privateConstructorUsedError;
  String? get gradeLevels => throw _privateConstructorUsedError;
  bool? get isContinuousYearRound => throw _privateConstructorUsedError;
  DateTime get startDate => throw _privateConstructorUsedError;
  DateTime? get endDate => throw _privateConstructorUsedError;
  String? get evidence => throw _privateConstructorUsedError;
  String? get teacherVerification => throw _privateConstructorUsedError;
  List<String> get skills => throw _privateConstructorUsedError;
  String get narrativeAngle => throw _privateConstructorUsedError;
  int get admissionsValue => throw _privateConstructorUsedError;
  bool get isInSchool => throw _privateConstructorUsedError;
  String? get location => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ActivityCopyWith<Activity> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ActivityCopyWith<$Res> {
  factory $ActivityCopyWith(Activity value, $Res Function(Activity) then) =
      _$ActivityCopyWithImpl<$Res, Activity>;
  @useResult
  $Res call(
      {String id,
      String title,
      ActivityCategory category,
      ActivityTier tier,
      String description,
      int hoursPerWeek,
      int weeksPerYear,
      String? position,
      String? organizationName,
      String? gradeLevels,
      bool? isContinuousYearRound,
      DateTime startDate,
      DateTime? endDate,
      String? evidence,
      String? teacherVerification,
      List<String> skills,
      String narrativeAngle,
      int admissionsValue,
      bool isInSchool,
      String? location});
}

/// @nodoc
class _$ActivityCopyWithImpl<$Res, $Val extends Activity>
    implements $ActivityCopyWith<$Res> {
  _$ActivityCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? category = null,
    Object? tier = null,
    Object? description = null,
    Object? hoursPerWeek = null,
    Object? weeksPerYear = null,
    Object? position = freezed,
    Object? organizationName = freezed,
    Object? gradeLevels = freezed,
    Object? isContinuousYearRound = freezed,
    Object? startDate = null,
    Object? endDate = freezed,
    Object? evidence = freezed,
    Object? teacherVerification = freezed,
    Object? skills = null,
    Object? narrativeAngle = null,
    Object? admissionsValue = null,
    Object? isInSchool = null,
    Object? location = freezed,
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
      category: null == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as ActivityCategory,
      tier: null == tier
          ? _value.tier
          : tier // ignore: cast_nullable_to_non_nullable
              as ActivityTier,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      hoursPerWeek: null == hoursPerWeek
          ? _value.hoursPerWeek
          : hoursPerWeek // ignore: cast_nullable_to_non_nullable
              as int,
      weeksPerYear: null == weeksPerYear
          ? _value.weeksPerYear
          : weeksPerYear // ignore: cast_nullable_to_non_nullable
              as int,
      position: freezed == position
          ? _value.position
          : position // ignore: cast_nullable_to_non_nullable
              as String?,
      organizationName: freezed == organizationName
          ? _value.organizationName
          : organizationName // ignore: cast_nullable_to_non_nullable
              as String?,
      gradeLevels: freezed == gradeLevels
          ? _value.gradeLevels
          : gradeLevels // ignore: cast_nullable_to_non_nullable
              as String?,
      isContinuousYearRound: freezed == isContinuousYearRound
          ? _value.isContinuousYearRound
          : isContinuousYearRound // ignore: cast_nullable_to_non_nullable
              as bool?,
      startDate: null == startDate
          ? _value.startDate
          : startDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      endDate: freezed == endDate
          ? _value.endDate
          : endDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      evidence: freezed == evidence
          ? _value.evidence
          : evidence // ignore: cast_nullable_to_non_nullable
              as String?,
      teacherVerification: freezed == teacherVerification
          ? _value.teacherVerification
          : teacherVerification // ignore: cast_nullable_to_non_nullable
              as String?,
      skills: null == skills
          ? _value.skills
          : skills // ignore: cast_nullable_to_non_nullable
              as List<String>,
      narrativeAngle: null == narrativeAngle
          ? _value.narrativeAngle
          : narrativeAngle // ignore: cast_nullable_to_non_nullable
              as String,
      admissionsValue: null == admissionsValue
          ? _value.admissionsValue
          : admissionsValue // ignore: cast_nullable_to_non_nullable
              as int,
      isInSchool: null == isInSchool
          ? _value.isInSchool
          : isInSchool // ignore: cast_nullable_to_non_nullable
              as bool,
      location: freezed == location
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ActivityImplCopyWith<$Res>
    implements $ActivityCopyWith<$Res> {
  factory _$$ActivityImplCopyWith(
          _$ActivityImpl value, $Res Function(_$ActivityImpl) then) =
      __$$ActivityImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String title,
      ActivityCategory category,
      ActivityTier tier,
      String description,
      int hoursPerWeek,
      int weeksPerYear,
      String? position,
      String? organizationName,
      String? gradeLevels,
      bool? isContinuousYearRound,
      DateTime startDate,
      DateTime? endDate,
      String? evidence,
      String? teacherVerification,
      List<String> skills,
      String narrativeAngle,
      int admissionsValue,
      bool isInSchool,
      String? location});
}

/// @nodoc
class __$$ActivityImplCopyWithImpl<$Res>
    extends _$ActivityCopyWithImpl<$Res, _$ActivityImpl>
    implements _$$ActivityImplCopyWith<$Res> {
  __$$ActivityImplCopyWithImpl(
      _$ActivityImpl _value, $Res Function(_$ActivityImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? category = null,
    Object? tier = null,
    Object? description = null,
    Object? hoursPerWeek = null,
    Object? weeksPerYear = null,
    Object? position = freezed,
    Object? organizationName = freezed,
    Object? gradeLevels = freezed,
    Object? isContinuousYearRound = freezed,
    Object? startDate = null,
    Object? endDate = freezed,
    Object? evidence = freezed,
    Object? teacherVerification = freezed,
    Object? skills = null,
    Object? narrativeAngle = null,
    Object? admissionsValue = null,
    Object? isInSchool = null,
    Object? location = freezed,
  }) {
    return _then(_$ActivityImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      category: null == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as ActivityCategory,
      tier: null == tier
          ? _value.tier
          : tier // ignore: cast_nullable_to_non_nullable
              as ActivityTier,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      hoursPerWeek: null == hoursPerWeek
          ? _value.hoursPerWeek
          : hoursPerWeek // ignore: cast_nullable_to_non_nullable
              as int,
      weeksPerYear: null == weeksPerYear
          ? _value.weeksPerYear
          : weeksPerYear // ignore: cast_nullable_to_non_nullable
              as int,
      position: freezed == position
          ? _value.position
          : position // ignore: cast_nullable_to_non_nullable
              as String?,
      organizationName: freezed == organizationName
          ? _value.organizationName
          : organizationName // ignore: cast_nullable_to_non_nullable
              as String?,
      gradeLevels: freezed == gradeLevels
          ? _value.gradeLevels
          : gradeLevels // ignore: cast_nullable_to_non_nullable
              as String?,
      isContinuousYearRound: freezed == isContinuousYearRound
          ? _value.isContinuousYearRound
          : isContinuousYearRound // ignore: cast_nullable_to_non_nullable
              as bool?,
      startDate: null == startDate
          ? _value.startDate
          : startDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      endDate: freezed == endDate
          ? _value.endDate
          : endDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      evidence: freezed == evidence
          ? _value.evidence
          : evidence // ignore: cast_nullable_to_non_nullable
              as String?,
      teacherVerification: freezed == teacherVerification
          ? _value.teacherVerification
          : teacherVerification // ignore: cast_nullable_to_non_nullable
              as String?,
      skills: null == skills
          ? _value._skills
          : skills // ignore: cast_nullable_to_non_nullable
              as List<String>,
      narrativeAngle: null == narrativeAngle
          ? _value.narrativeAngle
          : narrativeAngle // ignore: cast_nullable_to_non_nullable
              as String,
      admissionsValue: null == admissionsValue
          ? _value.admissionsValue
          : admissionsValue // ignore: cast_nullable_to_non_nullable
              as int,
      isInSchool: null == isInSchool
          ? _value.isInSchool
          : isInSchool // ignore: cast_nullable_to_non_nullable
              as bool,
      location: freezed == location
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ActivityImpl implements _Activity {
  const _$ActivityImpl(
      {required this.id,
      required this.title,
      required this.category,
      required this.tier,
      required this.description,
      required this.hoursPerWeek,
      required this.weeksPerYear,
      this.position,
      this.organizationName,
      this.gradeLevels,
      this.isContinuousYearRound,
      required this.startDate,
      required this.endDate,
      required this.evidence,
      required this.teacherVerification,
      required final List<String> skills,
      required this.narrativeAngle,
      required this.admissionsValue,
      required this.isInSchool,
      required this.location})
      : _skills = skills;

  factory _$ActivityImpl.fromJson(Map<String, dynamic> json) =>
      _$$ActivityImplFromJson(json);

  @override
  final String id;
  @override
  final String title;
  @override
  final ActivityCategory category;
  @override
  final ActivityTier tier;
  @override
  final String description;
  @override
  final int hoursPerWeek;
  @override
  final int weeksPerYear;
// Common App fields
  @override
  final String? position;
  @override
  final String? organizationName;
  @override
  final String? gradeLevels;
  @override
  final bool? isContinuousYearRound;
  @override
  final DateTime startDate;
  @override
  final DateTime? endDate;
  @override
  final String? evidence;
  @override
  final String? teacherVerification;
  final List<String> _skills;
  @override
  List<String> get skills {
    if (_skills is EqualUnmodifiableListView) return _skills;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_skills);
  }

  @override
  final String narrativeAngle;
  @override
  final int admissionsValue;
  @override
  final bool isInSchool;
  @override
  final String? location;

  @override
  String toString() {
    return 'Activity(id: $id, title: $title, category: $category, tier: $tier, description: $description, hoursPerWeek: $hoursPerWeek, weeksPerYear: $weeksPerYear, position: $position, organizationName: $organizationName, gradeLevels: $gradeLevels, isContinuousYearRound: $isContinuousYearRound, startDate: $startDate, endDate: $endDate, evidence: $evidence, teacherVerification: $teacherVerification, skills: $skills, narrativeAngle: $narrativeAngle, admissionsValue: $admissionsValue, isInSchool: $isInSchool, location: $location)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ActivityImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.tier, tier) || other.tier == tier) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.hoursPerWeek, hoursPerWeek) ||
                other.hoursPerWeek == hoursPerWeek) &&
            (identical(other.weeksPerYear, weeksPerYear) ||
                other.weeksPerYear == weeksPerYear) &&
            (identical(other.position, position) ||
                other.position == position) &&
            (identical(other.organizationName, organizationName) ||
                other.organizationName == organizationName) &&
            (identical(other.gradeLevels, gradeLevels) ||
                other.gradeLevels == gradeLevels) &&
            (identical(other.isContinuousYearRound, isContinuousYearRound) ||
                other.isContinuousYearRound == isContinuousYearRound) &&
            (identical(other.startDate, startDate) ||
                other.startDate == startDate) &&
            (identical(other.endDate, endDate) || other.endDate == endDate) &&
            (identical(other.evidence, evidence) ||
                other.evidence == evidence) &&
            (identical(other.teacherVerification, teacherVerification) ||
                other.teacherVerification == teacherVerification) &&
            const DeepCollectionEquality().equals(other._skills, _skills) &&
            (identical(other.narrativeAngle, narrativeAngle) ||
                other.narrativeAngle == narrativeAngle) &&
            (identical(other.admissionsValue, admissionsValue) ||
                other.admissionsValue == admissionsValue) &&
            (identical(other.isInSchool, isInSchool) ||
                other.isInSchool == isInSchool) &&
            (identical(other.location, location) ||
                other.location == location));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        id,
        title,
        category,
        tier,
        description,
        hoursPerWeek,
        weeksPerYear,
        position,
        organizationName,
        gradeLevels,
        isContinuousYearRound,
        startDate,
        endDate,
        evidence,
        teacherVerification,
        const DeepCollectionEquality().hash(_skills),
        narrativeAngle,
        admissionsValue,
        isInSchool,
        location
      ]);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ActivityImplCopyWith<_$ActivityImpl> get copyWith =>
      __$$ActivityImplCopyWithImpl<_$ActivityImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ActivityImplToJson(
      this,
    );
  }
}

abstract class _Activity implements Activity {
  const factory _Activity(
      {required final String id,
      required final String title,
      required final ActivityCategory category,
      required final ActivityTier tier,
      required final String description,
      required final int hoursPerWeek,
      required final int weeksPerYear,
      final String? position,
      final String? organizationName,
      final String? gradeLevels,
      final bool? isContinuousYearRound,
      required final DateTime startDate,
      required final DateTime? endDate,
      required final String? evidence,
      required final String? teacherVerification,
      required final List<String> skills,
      required final String narrativeAngle,
      required final int admissionsValue,
      required final bool isInSchool,
      required final String? location}) = _$ActivityImpl;

  factory _Activity.fromJson(Map<String, dynamic> json) =
      _$ActivityImpl.fromJson;

  @override
  String get id;
  @override
  String get title;
  @override
  ActivityCategory get category;
  @override
  ActivityTier get tier;
  @override
  String get description;
  @override
  int get hoursPerWeek;
  @override
  int get weeksPerYear;
  @override // Common App fields
  String? get position;
  @override
  String? get organizationName;
  @override
  String? get gradeLevels;
  @override
  bool? get isContinuousYearRound;
  @override
  DateTime get startDate;
  @override
  DateTime? get endDate;
  @override
  String? get evidence;
  @override
  String? get teacherVerification;
  @override
  List<String> get skills;
  @override
  String get narrativeAngle;
  @override
  int get admissionsValue;
  @override
  bool get isInSchool;
  @override
  String? get location;
  @override
  @JsonKey(ignore: true)
  _$$ActivityImplCopyWith<_$ActivityImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

WeeklySchedule _$WeeklyScheduleFromJson(Map<String, dynamic> json) {
  return _WeeklySchedule.fromJson(json);
}

/// @nodoc
mixin _$WeeklySchedule {
  Map<String, List<TimeBlock>> get schedule =>
      throw _privateConstructorUsedError;
  int get discretionaryHoursWeekday => throw _privateConstructorUsedError;
  int get discretionaryHoursWeekend => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $WeeklyScheduleCopyWith<WeeklySchedule> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WeeklyScheduleCopyWith<$Res> {
  factory $WeeklyScheduleCopyWith(
          WeeklySchedule value, $Res Function(WeeklySchedule) then) =
      _$WeeklyScheduleCopyWithImpl<$Res, WeeklySchedule>;
  @useResult
  $Res call(
      {Map<String, List<TimeBlock>> schedule,
      int discretionaryHoursWeekday,
      int discretionaryHoursWeekend});
}

/// @nodoc
class _$WeeklyScheduleCopyWithImpl<$Res, $Val extends WeeklySchedule>
    implements $WeeklyScheduleCopyWith<$Res> {
  _$WeeklyScheduleCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? schedule = null,
    Object? discretionaryHoursWeekday = null,
    Object? discretionaryHoursWeekend = null,
  }) {
    return _then(_value.copyWith(
      schedule: null == schedule
          ? _value.schedule
          : schedule // ignore: cast_nullable_to_non_nullable
              as Map<String, List<TimeBlock>>,
      discretionaryHoursWeekday: null == discretionaryHoursWeekday
          ? _value.discretionaryHoursWeekday
          : discretionaryHoursWeekday // ignore: cast_nullable_to_non_nullable
              as int,
      discretionaryHoursWeekend: null == discretionaryHoursWeekend
          ? _value.discretionaryHoursWeekend
          : discretionaryHoursWeekend // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$WeeklyScheduleImplCopyWith<$Res>
    implements $WeeklyScheduleCopyWith<$Res> {
  factory _$$WeeklyScheduleImplCopyWith(_$WeeklyScheduleImpl value,
          $Res Function(_$WeeklyScheduleImpl) then) =
      __$$WeeklyScheduleImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {Map<String, List<TimeBlock>> schedule,
      int discretionaryHoursWeekday,
      int discretionaryHoursWeekend});
}

/// @nodoc
class __$$WeeklyScheduleImplCopyWithImpl<$Res>
    extends _$WeeklyScheduleCopyWithImpl<$Res, _$WeeklyScheduleImpl>
    implements _$$WeeklyScheduleImplCopyWith<$Res> {
  __$$WeeklyScheduleImplCopyWithImpl(
      _$WeeklyScheduleImpl _value, $Res Function(_$WeeklyScheduleImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? schedule = null,
    Object? discretionaryHoursWeekday = null,
    Object? discretionaryHoursWeekend = null,
  }) {
    return _then(_$WeeklyScheduleImpl(
      schedule: null == schedule
          ? _value._schedule
          : schedule // ignore: cast_nullable_to_non_nullable
              as Map<String, List<TimeBlock>>,
      discretionaryHoursWeekday: null == discretionaryHoursWeekday
          ? _value.discretionaryHoursWeekday
          : discretionaryHoursWeekday // ignore: cast_nullable_to_non_nullable
              as int,
      discretionaryHoursWeekend: null == discretionaryHoursWeekend
          ? _value.discretionaryHoursWeekend
          : discretionaryHoursWeekend // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$WeeklyScheduleImpl implements _WeeklySchedule {
  const _$WeeklyScheduleImpl(
      {required final Map<String, List<TimeBlock>> schedule,
      required this.discretionaryHoursWeekday,
      required this.discretionaryHoursWeekend})
      : _schedule = schedule;

  factory _$WeeklyScheduleImpl.fromJson(Map<String, dynamic> json) =>
      _$$WeeklyScheduleImplFromJson(json);

  final Map<String, List<TimeBlock>> _schedule;
  @override
  Map<String, List<TimeBlock>> get schedule {
    if (_schedule is EqualUnmodifiableMapView) return _schedule;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_schedule);
  }

  @override
  final int discretionaryHoursWeekday;
  @override
  final int discretionaryHoursWeekend;

  @override
  String toString() {
    return 'WeeklySchedule(schedule: $schedule, discretionaryHoursWeekday: $discretionaryHoursWeekday, discretionaryHoursWeekend: $discretionaryHoursWeekend)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WeeklyScheduleImpl &&
            const DeepCollectionEquality().equals(other._schedule, _schedule) &&
            (identical(other.discretionaryHoursWeekday,
                    discretionaryHoursWeekday) ||
                other.discretionaryHoursWeekday == discretionaryHoursWeekday) &&
            (identical(other.discretionaryHoursWeekend,
                    discretionaryHoursWeekend) ||
                other.discretionaryHoursWeekend == discretionaryHoursWeekend));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_schedule),
      discretionaryHoursWeekday,
      discretionaryHoursWeekend);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$WeeklyScheduleImplCopyWith<_$WeeklyScheduleImpl> get copyWith =>
      __$$WeeklyScheduleImplCopyWithImpl<_$WeeklyScheduleImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$WeeklyScheduleImplToJson(
      this,
    );
  }
}

abstract class _WeeklySchedule implements WeeklySchedule {
  const factory _WeeklySchedule(
      {required final Map<String, List<TimeBlock>> schedule,
      required final int discretionaryHoursWeekday,
      required final int discretionaryHoursWeekend}) = _$WeeklyScheduleImpl;

  factory _WeeklySchedule.fromJson(Map<String, dynamic> json) =
      _$WeeklyScheduleImpl.fromJson;

  @override
  Map<String, List<TimeBlock>> get schedule;
  @override
  int get discretionaryHoursWeekday;
  @override
  int get discretionaryHoursWeekend;
  @override
  @JsonKey(ignore: true)
  _$$WeeklyScheduleImplCopyWith<_$WeeklyScheduleImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

TimeBlock _$TimeBlockFromJson(Map<String, dynamic> json) {
  return _TimeBlock.fromJson(json);
}

/// @nodoc
mixin _$TimeBlock {
  String get id => throw _privateConstructorUsedError;
  String get label => throw _privateConstructorUsedError;
  String get startTime => throw _privateConstructorUsedError;
  String get endTime => throw _privateConstructorUsedError;
  TimeBlockType get type => throw _privateConstructorUsedError;
  bool get isFree => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $TimeBlockCopyWith<TimeBlock> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TimeBlockCopyWith<$Res> {
  factory $TimeBlockCopyWith(TimeBlock value, $Res Function(TimeBlock) then) =
      _$TimeBlockCopyWithImpl<$Res, TimeBlock>;
  @useResult
  $Res call(
      {String id,
      String label,
      String startTime,
      String endTime,
      TimeBlockType type,
      bool isFree});
}

/// @nodoc
class _$TimeBlockCopyWithImpl<$Res, $Val extends TimeBlock>
    implements $TimeBlockCopyWith<$Res> {
  _$TimeBlockCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? label = null,
    Object? startTime = null,
    Object? endTime = null,
    Object? type = null,
    Object? isFree = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      label: null == label
          ? _value.label
          : label // ignore: cast_nullable_to_non_nullable
              as String,
      startTime: null == startTime
          ? _value.startTime
          : startTime // ignore: cast_nullable_to_non_nullable
              as String,
      endTime: null == endTime
          ? _value.endTime
          : endTime // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as TimeBlockType,
      isFree: null == isFree
          ? _value.isFree
          : isFree // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TimeBlockImplCopyWith<$Res>
    implements $TimeBlockCopyWith<$Res> {
  factory _$$TimeBlockImplCopyWith(
          _$TimeBlockImpl value, $Res Function(_$TimeBlockImpl) then) =
      __$$TimeBlockImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String label,
      String startTime,
      String endTime,
      TimeBlockType type,
      bool isFree});
}

/// @nodoc
class __$$TimeBlockImplCopyWithImpl<$Res>
    extends _$TimeBlockCopyWithImpl<$Res, _$TimeBlockImpl>
    implements _$$TimeBlockImplCopyWith<$Res> {
  __$$TimeBlockImplCopyWithImpl(
      _$TimeBlockImpl _value, $Res Function(_$TimeBlockImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? label = null,
    Object? startTime = null,
    Object? endTime = null,
    Object? type = null,
    Object? isFree = null,
  }) {
    return _then(_$TimeBlockImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      label: null == label
          ? _value.label
          : label // ignore: cast_nullable_to_non_nullable
              as String,
      startTime: null == startTime
          ? _value.startTime
          : startTime // ignore: cast_nullable_to_non_nullable
              as String,
      endTime: null == endTime
          ? _value.endTime
          : endTime // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as TimeBlockType,
      isFree: null == isFree
          ? _value.isFree
          : isFree // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TimeBlockImpl implements _TimeBlock {
  const _$TimeBlockImpl(
      {required this.id,
      required this.label,
      required this.startTime,
      required this.endTime,
      required this.type,
      required this.isFree});

  factory _$TimeBlockImpl.fromJson(Map<String, dynamic> json) =>
      _$$TimeBlockImplFromJson(json);

  @override
  final String id;
  @override
  final String label;
  @override
  final String startTime;
  @override
  final String endTime;
  @override
  final TimeBlockType type;
  @override
  final bool isFree;

  @override
  String toString() {
    return 'TimeBlock(id: $id, label: $label, startTime: $startTime, endTime: $endTime, type: $type, isFree: $isFree)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TimeBlockImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.label, label) || other.label == label) &&
            (identical(other.startTime, startTime) ||
                other.startTime == startTime) &&
            (identical(other.endTime, endTime) || other.endTime == endTime) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.isFree, isFree) || other.isFree == isFree));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, label, startTime, endTime, type, isFree);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$TimeBlockImplCopyWith<_$TimeBlockImpl> get copyWith =>
      __$$TimeBlockImplCopyWithImpl<_$TimeBlockImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TimeBlockImplToJson(
      this,
    );
  }
}

abstract class _TimeBlock implements TimeBlock {
  const factory _TimeBlock(
      {required final String id,
      required final String label,
      required final String startTime,
      required final String endTime,
      required final TimeBlockType type,
      required final bool isFree}) = _$TimeBlockImpl;

  factory _TimeBlock.fromJson(Map<String, dynamic> json) =
      _$TimeBlockImpl.fromJson;

  @override
  String get id;
  @override
  String get label;
  @override
  String get startTime;
  @override
  String get endTime;
  @override
  TimeBlockType get type;
  @override
  bool get isFree;
  @override
  @JsonKey(ignore: true)
  _$$TimeBlockImplCopyWith<_$TimeBlockImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

MotivationProfile _$MotivationProfileFromJson(Map<String, dynamic> json) {
  return _MotivationProfile.fromJson(json);
}

/// @nodoc
mixin _$MotivationProfile {
  List<MotivationDriver> get drivers => throw _privateConstructorUsedError;
  StressStyle get stressStyle => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $MotivationProfileCopyWith<MotivationProfile> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MotivationProfileCopyWith<$Res> {
  factory $MotivationProfileCopyWith(
          MotivationProfile value, $Res Function(MotivationProfile) then) =
      _$MotivationProfileCopyWithImpl<$Res, MotivationProfile>;
  @useResult
  $Res call({List<MotivationDriver> drivers, StressStyle stressStyle});
}

/// @nodoc
class _$MotivationProfileCopyWithImpl<$Res, $Val extends MotivationProfile>
    implements $MotivationProfileCopyWith<$Res> {
  _$MotivationProfileCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? drivers = null,
    Object? stressStyle = null,
  }) {
    return _then(_value.copyWith(
      drivers: null == drivers
          ? _value.drivers
          : drivers // ignore: cast_nullable_to_non_nullable
              as List<MotivationDriver>,
      stressStyle: null == stressStyle
          ? _value.stressStyle
          : stressStyle // ignore: cast_nullable_to_non_nullable
              as StressStyle,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$MotivationProfileImplCopyWith<$Res>
    implements $MotivationProfileCopyWith<$Res> {
  factory _$$MotivationProfileImplCopyWith(_$MotivationProfileImpl value,
          $Res Function(_$MotivationProfileImpl) then) =
      __$$MotivationProfileImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<MotivationDriver> drivers, StressStyle stressStyle});
}

/// @nodoc
class __$$MotivationProfileImplCopyWithImpl<$Res>
    extends _$MotivationProfileCopyWithImpl<$Res, _$MotivationProfileImpl>
    implements _$$MotivationProfileImplCopyWith<$Res> {
  __$$MotivationProfileImplCopyWithImpl(_$MotivationProfileImpl _value,
      $Res Function(_$MotivationProfileImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? drivers = null,
    Object? stressStyle = null,
  }) {
    return _then(_$MotivationProfileImpl(
      drivers: null == drivers
          ? _value._drivers
          : drivers // ignore: cast_nullable_to_non_nullable
              as List<MotivationDriver>,
      stressStyle: null == stressStyle
          ? _value.stressStyle
          : stressStyle // ignore: cast_nullable_to_non_nullable
              as StressStyle,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$MotivationProfileImpl implements _MotivationProfile {
  const _$MotivationProfileImpl(
      {required final List<MotivationDriver> drivers,
      required this.stressStyle})
      : _drivers = drivers;

  factory _$MotivationProfileImpl.fromJson(Map<String, dynamic> json) =>
      _$$MotivationProfileImplFromJson(json);

  final List<MotivationDriver> _drivers;
  @override
  List<MotivationDriver> get drivers {
    if (_drivers is EqualUnmodifiableListView) return _drivers;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_drivers);
  }

  @override
  final StressStyle stressStyle;

  @override
  String toString() {
    return 'MotivationProfile(drivers: $drivers, stressStyle: $stressStyle)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MotivationProfileImpl &&
            const DeepCollectionEquality().equals(other._drivers, _drivers) &&
            (identical(other.stressStyle, stressStyle) ||
                other.stressStyle == stressStyle));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, const DeepCollectionEquality().hash(_drivers), stressStyle);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$MotivationProfileImplCopyWith<_$MotivationProfileImpl> get copyWith =>
      __$$MotivationProfileImplCopyWithImpl<_$MotivationProfileImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MotivationProfileImplToJson(
      this,
    );
  }
}

abstract class _MotivationProfile implements MotivationProfile {
  const factory _MotivationProfile(
      {required final List<MotivationDriver> drivers,
      required final StressStyle stressStyle}) = _$MotivationProfileImpl;

  factory _MotivationProfile.fromJson(Map<String, dynamic> json) =
      _$MotivationProfileImpl.fromJson;

  @override
  List<MotivationDriver> get drivers;
  @override
  StressStyle get stressStyle;
  @override
  @JsonKey(ignore: true)
  _$$MotivationProfileImplCopyWith<_$MotivationProfileImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
