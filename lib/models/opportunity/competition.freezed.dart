// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'competition.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Competition _$CompetitionFromJson(Map<String, dynamic> json) {
  return _Competition.fromJson(json);
}

/// @nodoc
mixin _$Competition {
  String get id => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  CompetitionCategory get category => throw _privateConstructorUsedError;
  CompetitionLevel get level => throw _privateConstructorUsedError;
  DateTime get startDate => throw _privateConstructorUsedError;
  DateTime get endDate => throw _privateConstructorUsedError;
  DateTime get registrationDeadline => throw _privateConstructorUsedError;
  bool get registrationOpen => throw _privateConstructorUsedError;
  List<int> get eligibleGrades => throw _privateConstructorUsedError;
  List<String> get eligibleStreams => throw _privateConstructorUsedError;
  bool get isOnline => throw _privateConstructorUsedError;
  String? get venue => throw _privateConstructorUsedError;
  String? get city => throw _privateConstructorUsedError;
  String? get state => throw _privateConstructorUsedError;
  String? get country => throw _privateConstructorUsedError;
  double? get latitude => throw _privateConstructorUsedError;
  double? get longitude => throw _privateConstructorUsedError;
  String? get website => throw _privateConstructorUsedError;
  String? get registrationUrl => throw _privateConstructorUsedError;
  String get organizer => throw _privateConstructorUsedError;
  List<String> get prizes => throw _privateConstructorUsedError;
  List<String> get tags => throw _privateConstructorUsedError;
  String? get contactEmail => throw _privateConstructorUsedError;
  String? get contactPhone => throw _privateConstructorUsedError;
  int? get maxTeamSize => throw _privateConstructorUsedError;
  int? get minTeamSize => throw _privateConstructorUsedError;
  bool get individualParticipation => throw _privateConstructorUsedError;
  bool get teamParticipation => throw _privateConstructorUsedError;
  String? get format => throw _privateConstructorUsedError;
  String? get syllabus => throw _privateConstructorUsedError;
  List<String>? get prerequisites => throw _privateConstructorUsedError;
  Map<String, dynamic>? get rounds => throw _privateConstructorUsedError;
  DateTime? get resultDate => throw _privateConstructorUsedError;
  DateTime get cachedAt => throw _privateConstructorUsedError;
  String get source => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $CompetitionCopyWith<Competition> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CompetitionCopyWith<$Res> {
  factory $CompetitionCopyWith(
          Competition value, $Res Function(Competition) then) =
      _$CompetitionCopyWithImpl<$Res, Competition>;
  @useResult
  $Res call(
      {String id,
      String title,
      String description,
      CompetitionCategory category,
      CompetitionLevel level,
      DateTime startDate,
      DateTime endDate,
      DateTime registrationDeadline,
      bool registrationOpen,
      List<int> eligibleGrades,
      List<String> eligibleStreams,
      bool isOnline,
      String? venue,
      String? city,
      String? state,
      String? country,
      double? latitude,
      double? longitude,
      String? website,
      String? registrationUrl,
      String organizer,
      List<String> prizes,
      List<String> tags,
      String? contactEmail,
      String? contactPhone,
      int? maxTeamSize,
      int? minTeamSize,
      bool individualParticipation,
      bool teamParticipation,
      String? format,
      String? syllabus,
      List<String>? prerequisites,
      Map<String, dynamic>? rounds,
      DateTime? resultDate,
      DateTime cachedAt,
      String source});
}

/// @nodoc
class _$CompetitionCopyWithImpl<$Res, $Val extends Competition>
    implements $CompetitionCopyWith<$Res> {
  _$CompetitionCopyWithImpl(this._value, this._then);

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
    Object? category = null,
    Object? level = null,
    Object? startDate = null,
    Object? endDate = null,
    Object? registrationDeadline = null,
    Object? registrationOpen = null,
    Object? eligibleGrades = null,
    Object? eligibleStreams = null,
    Object? isOnline = null,
    Object? venue = freezed,
    Object? city = freezed,
    Object? state = freezed,
    Object? country = freezed,
    Object? latitude = freezed,
    Object? longitude = freezed,
    Object? website = freezed,
    Object? registrationUrl = freezed,
    Object? organizer = null,
    Object? prizes = null,
    Object? tags = null,
    Object? contactEmail = freezed,
    Object? contactPhone = freezed,
    Object? maxTeamSize = freezed,
    Object? minTeamSize = freezed,
    Object? individualParticipation = null,
    Object? teamParticipation = null,
    Object? format = freezed,
    Object? syllabus = freezed,
    Object? prerequisites = freezed,
    Object? rounds = freezed,
    Object? resultDate = freezed,
    Object? cachedAt = null,
    Object? source = null,
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
      category: null == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as CompetitionCategory,
      level: null == level
          ? _value.level
          : level // ignore: cast_nullable_to_non_nullable
              as CompetitionLevel,
      startDate: null == startDate
          ? _value.startDate
          : startDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      endDate: null == endDate
          ? _value.endDate
          : endDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      registrationDeadline: null == registrationDeadline
          ? _value.registrationDeadline
          : registrationDeadline // ignore: cast_nullable_to_non_nullable
              as DateTime,
      registrationOpen: null == registrationOpen
          ? _value.registrationOpen
          : registrationOpen // ignore: cast_nullable_to_non_nullable
              as bool,
      eligibleGrades: null == eligibleGrades
          ? _value.eligibleGrades
          : eligibleGrades // ignore: cast_nullable_to_non_nullable
              as List<int>,
      eligibleStreams: null == eligibleStreams
          ? _value.eligibleStreams
          : eligibleStreams // ignore: cast_nullable_to_non_nullable
              as List<String>,
      isOnline: null == isOnline
          ? _value.isOnline
          : isOnline // ignore: cast_nullable_to_non_nullable
              as bool,
      venue: freezed == venue
          ? _value.venue
          : venue // ignore: cast_nullable_to_non_nullable
              as String?,
      city: freezed == city
          ? _value.city
          : city // ignore: cast_nullable_to_non_nullable
              as String?,
      state: freezed == state
          ? _value.state
          : state // ignore: cast_nullable_to_non_nullable
              as String?,
      country: freezed == country
          ? _value.country
          : country // ignore: cast_nullable_to_non_nullable
              as String?,
      latitude: freezed == latitude
          ? _value.latitude
          : latitude // ignore: cast_nullable_to_non_nullable
              as double?,
      longitude: freezed == longitude
          ? _value.longitude
          : longitude // ignore: cast_nullable_to_non_nullable
              as double?,
      website: freezed == website
          ? _value.website
          : website // ignore: cast_nullable_to_non_nullable
              as String?,
      registrationUrl: freezed == registrationUrl
          ? _value.registrationUrl
          : registrationUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      organizer: null == organizer
          ? _value.organizer
          : organizer // ignore: cast_nullable_to_non_nullable
              as String,
      prizes: null == prizes
          ? _value.prizes
          : prizes // ignore: cast_nullable_to_non_nullable
              as List<String>,
      tags: null == tags
          ? _value.tags
          : tags // ignore: cast_nullable_to_non_nullable
              as List<String>,
      contactEmail: freezed == contactEmail
          ? _value.contactEmail
          : contactEmail // ignore: cast_nullable_to_non_nullable
              as String?,
      contactPhone: freezed == contactPhone
          ? _value.contactPhone
          : contactPhone // ignore: cast_nullable_to_non_nullable
              as String?,
      maxTeamSize: freezed == maxTeamSize
          ? _value.maxTeamSize
          : maxTeamSize // ignore: cast_nullable_to_non_nullable
              as int?,
      minTeamSize: freezed == minTeamSize
          ? _value.minTeamSize
          : minTeamSize // ignore: cast_nullable_to_non_nullable
              as int?,
      individualParticipation: null == individualParticipation
          ? _value.individualParticipation
          : individualParticipation // ignore: cast_nullable_to_non_nullable
              as bool,
      teamParticipation: null == teamParticipation
          ? _value.teamParticipation
          : teamParticipation // ignore: cast_nullable_to_non_nullable
              as bool,
      format: freezed == format
          ? _value.format
          : format // ignore: cast_nullable_to_non_nullable
              as String?,
      syllabus: freezed == syllabus
          ? _value.syllabus
          : syllabus // ignore: cast_nullable_to_non_nullable
              as String?,
      prerequisites: freezed == prerequisites
          ? _value.prerequisites
          : prerequisites // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      rounds: freezed == rounds
          ? _value.rounds
          : rounds // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      resultDate: freezed == resultDate
          ? _value.resultDate
          : resultDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      cachedAt: null == cachedAt
          ? _value.cachedAt
          : cachedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      source: null == source
          ? _value.source
          : source // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CompetitionImplCopyWith<$Res>
    implements $CompetitionCopyWith<$Res> {
  factory _$$CompetitionImplCopyWith(
          _$CompetitionImpl value, $Res Function(_$CompetitionImpl) then) =
      __$$CompetitionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String title,
      String description,
      CompetitionCategory category,
      CompetitionLevel level,
      DateTime startDate,
      DateTime endDate,
      DateTime registrationDeadline,
      bool registrationOpen,
      List<int> eligibleGrades,
      List<String> eligibleStreams,
      bool isOnline,
      String? venue,
      String? city,
      String? state,
      String? country,
      double? latitude,
      double? longitude,
      String? website,
      String? registrationUrl,
      String organizer,
      List<String> prizes,
      List<String> tags,
      String? contactEmail,
      String? contactPhone,
      int? maxTeamSize,
      int? minTeamSize,
      bool individualParticipation,
      bool teamParticipation,
      String? format,
      String? syllabus,
      List<String>? prerequisites,
      Map<String, dynamic>? rounds,
      DateTime? resultDate,
      DateTime cachedAt,
      String source});
}

/// @nodoc
class __$$CompetitionImplCopyWithImpl<$Res>
    extends _$CompetitionCopyWithImpl<$Res, _$CompetitionImpl>
    implements _$$CompetitionImplCopyWith<$Res> {
  __$$CompetitionImplCopyWithImpl(
      _$CompetitionImpl _value, $Res Function(_$CompetitionImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? description = null,
    Object? category = null,
    Object? level = null,
    Object? startDate = null,
    Object? endDate = null,
    Object? registrationDeadline = null,
    Object? registrationOpen = null,
    Object? eligibleGrades = null,
    Object? eligibleStreams = null,
    Object? isOnline = null,
    Object? venue = freezed,
    Object? city = freezed,
    Object? state = freezed,
    Object? country = freezed,
    Object? latitude = freezed,
    Object? longitude = freezed,
    Object? website = freezed,
    Object? registrationUrl = freezed,
    Object? organizer = null,
    Object? prizes = null,
    Object? tags = null,
    Object? contactEmail = freezed,
    Object? contactPhone = freezed,
    Object? maxTeamSize = freezed,
    Object? minTeamSize = freezed,
    Object? individualParticipation = null,
    Object? teamParticipation = null,
    Object? format = freezed,
    Object? syllabus = freezed,
    Object? prerequisites = freezed,
    Object? rounds = freezed,
    Object? resultDate = freezed,
    Object? cachedAt = null,
    Object? source = null,
  }) {
    return _then(_$CompetitionImpl(
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
      category: null == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as CompetitionCategory,
      level: null == level
          ? _value.level
          : level // ignore: cast_nullable_to_non_nullable
              as CompetitionLevel,
      startDate: null == startDate
          ? _value.startDate
          : startDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      endDate: null == endDate
          ? _value.endDate
          : endDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      registrationDeadline: null == registrationDeadline
          ? _value.registrationDeadline
          : registrationDeadline // ignore: cast_nullable_to_non_nullable
              as DateTime,
      registrationOpen: null == registrationOpen
          ? _value.registrationOpen
          : registrationOpen // ignore: cast_nullable_to_non_nullable
              as bool,
      eligibleGrades: null == eligibleGrades
          ? _value._eligibleGrades
          : eligibleGrades // ignore: cast_nullable_to_non_nullable
              as List<int>,
      eligibleStreams: null == eligibleStreams
          ? _value._eligibleStreams
          : eligibleStreams // ignore: cast_nullable_to_non_nullable
              as List<String>,
      isOnline: null == isOnline
          ? _value.isOnline
          : isOnline // ignore: cast_nullable_to_non_nullable
              as bool,
      venue: freezed == venue
          ? _value.venue
          : venue // ignore: cast_nullable_to_non_nullable
              as String?,
      city: freezed == city
          ? _value.city
          : city // ignore: cast_nullable_to_non_nullable
              as String?,
      state: freezed == state
          ? _value.state
          : state // ignore: cast_nullable_to_non_nullable
              as String?,
      country: freezed == country
          ? _value.country
          : country // ignore: cast_nullable_to_non_nullable
              as String?,
      latitude: freezed == latitude
          ? _value.latitude
          : latitude // ignore: cast_nullable_to_non_nullable
              as double?,
      longitude: freezed == longitude
          ? _value.longitude
          : longitude // ignore: cast_nullable_to_non_nullable
              as double?,
      website: freezed == website
          ? _value.website
          : website // ignore: cast_nullable_to_non_nullable
              as String?,
      registrationUrl: freezed == registrationUrl
          ? _value.registrationUrl
          : registrationUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      organizer: null == organizer
          ? _value.organizer
          : organizer // ignore: cast_nullable_to_non_nullable
              as String,
      prizes: null == prizes
          ? _value._prizes
          : prizes // ignore: cast_nullable_to_non_nullable
              as List<String>,
      tags: null == tags
          ? _value._tags
          : tags // ignore: cast_nullable_to_non_nullable
              as List<String>,
      contactEmail: freezed == contactEmail
          ? _value.contactEmail
          : contactEmail // ignore: cast_nullable_to_non_nullable
              as String?,
      contactPhone: freezed == contactPhone
          ? _value.contactPhone
          : contactPhone // ignore: cast_nullable_to_non_nullable
              as String?,
      maxTeamSize: freezed == maxTeamSize
          ? _value.maxTeamSize
          : maxTeamSize // ignore: cast_nullable_to_non_nullable
              as int?,
      minTeamSize: freezed == minTeamSize
          ? _value.minTeamSize
          : minTeamSize // ignore: cast_nullable_to_non_nullable
              as int?,
      individualParticipation: null == individualParticipation
          ? _value.individualParticipation
          : individualParticipation // ignore: cast_nullable_to_non_nullable
              as bool,
      teamParticipation: null == teamParticipation
          ? _value.teamParticipation
          : teamParticipation // ignore: cast_nullable_to_non_nullable
              as bool,
      format: freezed == format
          ? _value.format
          : format // ignore: cast_nullable_to_non_nullable
              as String?,
      syllabus: freezed == syllabus
          ? _value.syllabus
          : syllabus // ignore: cast_nullable_to_non_nullable
              as String?,
      prerequisites: freezed == prerequisites
          ? _value._prerequisites
          : prerequisites // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      rounds: freezed == rounds
          ? _value._rounds
          : rounds // ignore: cast_nullable_to_non_nullable
              as Map<String, dynamic>?,
      resultDate: freezed == resultDate
          ? _value.resultDate
          : resultDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      cachedAt: null == cachedAt
          ? _value.cachedAt
          : cachedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      source: null == source
          ? _value.source
          : source // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CompetitionImpl implements _Competition {
  const _$CompetitionImpl(
      {required this.id,
      required this.title,
      required this.description,
      required this.category,
      required this.level,
      required this.startDate,
      required this.endDate,
      required this.registrationDeadline,
      required this.registrationOpen,
      required final List<int> eligibleGrades,
      required final List<String> eligibleStreams,
      required this.isOnline,
      required this.venue,
      required this.city,
      required this.state,
      required this.country,
      required this.latitude,
      required this.longitude,
      required this.website,
      required this.registrationUrl,
      required this.organizer,
      required final List<String> prizes,
      required final List<String> tags,
      required this.contactEmail,
      required this.contactPhone,
      required this.maxTeamSize,
      required this.minTeamSize,
      required this.individualParticipation,
      required this.teamParticipation,
      required this.format,
      required this.syllabus,
      required final List<String>? prerequisites,
      required final Map<String, dynamic>? rounds,
      required this.resultDate,
      required this.cachedAt,
      required this.source})
      : _eligibleGrades = eligibleGrades,
        _eligibleStreams = eligibleStreams,
        _prizes = prizes,
        _tags = tags,
        _prerequisites = prerequisites,
        _rounds = rounds;

  factory _$CompetitionImpl.fromJson(Map<String, dynamic> json) =>
      _$$CompetitionImplFromJson(json);

  @override
  final String id;
  @override
  final String title;
  @override
  final String description;
  @override
  final CompetitionCategory category;
  @override
  final CompetitionLevel level;
  @override
  final DateTime startDate;
  @override
  final DateTime endDate;
  @override
  final DateTime registrationDeadline;
  @override
  final bool registrationOpen;
  final List<int> _eligibleGrades;
  @override
  List<int> get eligibleGrades {
    if (_eligibleGrades is EqualUnmodifiableListView) return _eligibleGrades;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_eligibleGrades);
  }

  final List<String> _eligibleStreams;
  @override
  List<String> get eligibleStreams {
    if (_eligibleStreams is EqualUnmodifiableListView) return _eligibleStreams;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_eligibleStreams);
  }

  @override
  final bool isOnline;
  @override
  final String? venue;
  @override
  final String? city;
  @override
  final String? state;
  @override
  final String? country;
  @override
  final double? latitude;
  @override
  final double? longitude;
  @override
  final String? website;
  @override
  final String? registrationUrl;
  @override
  final String organizer;
  final List<String> _prizes;
  @override
  List<String> get prizes {
    if (_prizes is EqualUnmodifiableListView) return _prizes;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_prizes);
  }

  final List<String> _tags;
  @override
  List<String> get tags {
    if (_tags is EqualUnmodifiableListView) return _tags;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_tags);
  }

  @override
  final String? contactEmail;
  @override
  final String? contactPhone;
  @override
  final int? maxTeamSize;
  @override
  final int? minTeamSize;
  @override
  final bool individualParticipation;
  @override
  final bool teamParticipation;
  @override
  final String? format;
  @override
  final String? syllabus;
  final List<String>? _prerequisites;
  @override
  List<String>? get prerequisites {
    final value = _prerequisites;
    if (value == null) return null;
    if (_prerequisites is EqualUnmodifiableListView) return _prerequisites;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final Map<String, dynamic>? _rounds;
  @override
  Map<String, dynamic>? get rounds {
    final value = _rounds;
    if (value == null) return null;
    if (_rounds is EqualUnmodifiableMapView) return _rounds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(value);
  }

  @override
  final DateTime? resultDate;
  @override
  final DateTime cachedAt;
  @override
  final String source;

  @override
  String toString() {
    return 'Competition(id: $id, title: $title, description: $description, category: $category, level: $level, startDate: $startDate, endDate: $endDate, registrationDeadline: $registrationDeadline, registrationOpen: $registrationOpen, eligibleGrades: $eligibleGrades, eligibleStreams: $eligibleStreams, isOnline: $isOnline, venue: $venue, city: $city, state: $state, country: $country, latitude: $latitude, longitude: $longitude, website: $website, registrationUrl: $registrationUrl, organizer: $organizer, prizes: $prizes, tags: $tags, contactEmail: $contactEmail, contactPhone: $contactPhone, maxTeamSize: $maxTeamSize, minTeamSize: $minTeamSize, individualParticipation: $individualParticipation, teamParticipation: $teamParticipation, format: $format, syllabus: $syllabus, prerequisites: $prerequisites, rounds: $rounds, resultDate: $resultDate, cachedAt: $cachedAt, source: $source)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CompetitionImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.level, level) || other.level == level) &&
            (identical(other.startDate, startDate) ||
                other.startDate == startDate) &&
            (identical(other.endDate, endDate) || other.endDate == endDate) &&
            (identical(other.registrationDeadline, registrationDeadline) ||
                other.registrationDeadline == registrationDeadline) &&
            (identical(other.registrationOpen, registrationOpen) ||
                other.registrationOpen == registrationOpen) &&
            const DeepCollectionEquality()
                .equals(other._eligibleGrades, _eligibleGrades) &&
            const DeepCollectionEquality()
                .equals(other._eligibleStreams, _eligibleStreams) &&
            (identical(other.isOnline, isOnline) ||
                other.isOnline == isOnline) &&
            (identical(other.venue, venue) || other.venue == venue) &&
            (identical(other.city, city) || other.city == city) &&
            (identical(other.state, state) || other.state == state) &&
            (identical(other.country, country) || other.country == country) &&
            (identical(other.latitude, latitude) ||
                other.latitude == latitude) &&
            (identical(other.longitude, longitude) ||
                other.longitude == longitude) &&
            (identical(other.website, website) || other.website == website) &&
            (identical(other.registrationUrl, registrationUrl) ||
                other.registrationUrl == registrationUrl) &&
            (identical(other.organizer, organizer) ||
                other.organizer == organizer) &&
            const DeepCollectionEquality().equals(other._prizes, _prizes) &&
            const DeepCollectionEquality().equals(other._tags, _tags) &&
            (identical(other.contactEmail, contactEmail) ||
                other.contactEmail == contactEmail) &&
            (identical(other.contactPhone, contactPhone) ||
                other.contactPhone == contactPhone) &&
            (identical(other.maxTeamSize, maxTeamSize) ||
                other.maxTeamSize == maxTeamSize) &&
            (identical(other.minTeamSize, minTeamSize) ||
                other.minTeamSize == minTeamSize) &&
            (identical(
                    other.individualParticipation, individualParticipation) ||
                other.individualParticipation == individualParticipation) &&
            (identical(other.teamParticipation, teamParticipation) ||
                other.teamParticipation == teamParticipation) &&
            (identical(other.format, format) || other.format == format) &&
            (identical(other.syllabus, syllabus) ||
                other.syllabus == syllabus) &&
            const DeepCollectionEquality()
                .equals(other._prerequisites, _prerequisites) &&
            const DeepCollectionEquality().equals(other._rounds, _rounds) &&
            (identical(other.resultDate, resultDate) ||
                other.resultDate == resultDate) &&
            (identical(other.cachedAt, cachedAt) ||
                other.cachedAt == cachedAt) &&
            (identical(other.source, source) || other.source == source));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        id,
        title,
        description,
        category,
        level,
        startDate,
        endDate,
        registrationDeadline,
        registrationOpen,
        const DeepCollectionEquality().hash(_eligibleGrades),
        const DeepCollectionEquality().hash(_eligibleStreams),
        isOnline,
        venue,
        city,
        state,
        country,
        latitude,
        longitude,
        website,
        registrationUrl,
        organizer,
        const DeepCollectionEquality().hash(_prizes),
        const DeepCollectionEquality().hash(_tags),
        contactEmail,
        contactPhone,
        maxTeamSize,
        minTeamSize,
        individualParticipation,
        teamParticipation,
        format,
        syllabus,
        const DeepCollectionEquality().hash(_prerequisites),
        const DeepCollectionEquality().hash(_rounds),
        resultDate,
        cachedAt,
        source
      ]);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$CompetitionImplCopyWith<_$CompetitionImpl> get copyWith =>
      __$$CompetitionImplCopyWithImpl<_$CompetitionImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CompetitionImplToJson(
      this,
    );
  }
}

abstract class _Competition implements Competition {
  const factory _Competition(
      {required final String id,
      required final String title,
      required final String description,
      required final CompetitionCategory category,
      required final CompetitionLevel level,
      required final DateTime startDate,
      required final DateTime endDate,
      required final DateTime registrationDeadline,
      required final bool registrationOpen,
      required final List<int> eligibleGrades,
      required final List<String> eligibleStreams,
      required final bool isOnline,
      required final String? venue,
      required final String? city,
      required final String? state,
      required final String? country,
      required final double? latitude,
      required final double? longitude,
      required final String? website,
      required final String? registrationUrl,
      required final String organizer,
      required final List<String> prizes,
      required final List<String> tags,
      required final String? contactEmail,
      required final String? contactPhone,
      required final int? maxTeamSize,
      required final int? minTeamSize,
      required final bool individualParticipation,
      required final bool teamParticipation,
      required final String? format,
      required final String? syllabus,
      required final List<String>? prerequisites,
      required final Map<String, dynamic>? rounds,
      required final DateTime? resultDate,
      required final DateTime cachedAt,
      required final String source}) = _$CompetitionImpl;

  factory _Competition.fromJson(Map<String, dynamic> json) =
      _$CompetitionImpl.fromJson;

  @override
  String get id;
  @override
  String get title;
  @override
  String get description;
  @override
  CompetitionCategory get category;
  @override
  CompetitionLevel get level;
  @override
  DateTime get startDate;
  @override
  DateTime get endDate;
  @override
  DateTime get registrationDeadline;
  @override
  bool get registrationOpen;
  @override
  List<int> get eligibleGrades;
  @override
  List<String> get eligibleStreams;
  @override
  bool get isOnline;
  @override
  String? get venue;
  @override
  String? get city;
  @override
  String? get state;
  @override
  String? get country;
  @override
  double? get latitude;
  @override
  double? get longitude;
  @override
  String? get website;
  @override
  String? get registrationUrl;
  @override
  String get organizer;
  @override
  List<String> get prizes;
  @override
  List<String> get tags;
  @override
  String? get contactEmail;
  @override
  String? get contactPhone;
  @override
  int? get maxTeamSize;
  @override
  int? get minTeamSize;
  @override
  bool get individualParticipation;
  @override
  bool get teamParticipation;
  @override
  String? get format;
  @override
  String? get syllabus;
  @override
  List<String>? get prerequisites;
  @override
  Map<String, dynamic>? get rounds;
  @override
  DateTime? get resultDate;
  @override
  DateTime get cachedAt;
  @override
  String get source;
  @override
  @JsonKey(ignore: true)
  _$$CompetitionImplCopyWith<_$CompetitionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
