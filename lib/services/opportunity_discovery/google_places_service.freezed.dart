// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'google_places_service.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$GooglePlacesConfig {
  String get apiKey => throw _privateConstructorUsedError;
  double get defaultRadius => throw _privateConstructorUsedError;
  List<String> get defaultTypes => throw _privateConstructorUsedError;
  String get language => throw _privateConstructorUsedError;
  String get region => throw _privateConstructorUsedError;
  int get maxResults => throw _privateConstructorUsedError;
  Duration get cacheDuration => throw _privateConstructorUsedError;
  int get maxRetries => throw _privateConstructorUsedError;
  Duration get requestTimeout => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $GooglePlacesConfigCopyWith<GooglePlacesConfig> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GooglePlacesConfigCopyWith<$Res> {
  factory $GooglePlacesConfigCopyWith(
          GooglePlacesConfig value, $Res Function(GooglePlacesConfig) then) =
      _$GooglePlacesConfigCopyWithImpl<$Res, GooglePlacesConfig>;
  @useResult
  $Res call(
      {String apiKey,
      double defaultRadius,
      List<String> defaultTypes,
      String language,
      String region,
      int maxResults,
      Duration cacheDuration,
      int maxRetries,
      Duration requestTimeout});
}

/// @nodoc
class _$GooglePlacesConfigCopyWithImpl<$Res, $Val extends GooglePlacesConfig>
    implements $GooglePlacesConfigCopyWith<$Res> {
  _$GooglePlacesConfigCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? apiKey = null,
    Object? defaultRadius = null,
    Object? defaultTypes = null,
    Object? language = null,
    Object? region = null,
    Object? maxResults = null,
    Object? cacheDuration = null,
    Object? maxRetries = null,
    Object? requestTimeout = null,
  }) {
    return _then(_value.copyWith(
      apiKey: null == apiKey
          ? _value.apiKey
          : apiKey // ignore: cast_nullable_to_non_nullable
              as String,
      defaultRadius: null == defaultRadius
          ? _value.defaultRadius
          : defaultRadius // ignore: cast_nullable_to_non_nullable
              as double,
      defaultTypes: null == defaultTypes
          ? _value.defaultTypes
          : defaultTypes // ignore: cast_nullable_to_non_nullable
              as List<String>,
      language: null == language
          ? _value.language
          : language // ignore: cast_nullable_to_non_nullable
              as String,
      region: null == region
          ? _value.region
          : region // ignore: cast_nullable_to_non_nullable
              as String,
      maxResults: null == maxResults
          ? _value.maxResults
          : maxResults // ignore: cast_nullable_to_non_nullable
              as int,
      cacheDuration: null == cacheDuration
          ? _value.cacheDuration
          : cacheDuration // ignore: cast_nullable_to_non_nullable
              as Duration,
      maxRetries: null == maxRetries
          ? _value.maxRetries
          : maxRetries // ignore: cast_nullable_to_non_nullable
              as int,
      requestTimeout: null == requestTimeout
          ? _value.requestTimeout
          : requestTimeout // ignore: cast_nullable_to_non_nullable
              as Duration,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$GooglePlacesConfigImplCopyWith<$Res>
    implements $GooglePlacesConfigCopyWith<$Res> {
  factory _$$GooglePlacesConfigImplCopyWith(_$GooglePlacesConfigImpl value,
          $Res Function(_$GooglePlacesConfigImpl) then) =
      __$$GooglePlacesConfigImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String apiKey,
      double defaultRadius,
      List<String> defaultTypes,
      String language,
      String region,
      int maxResults,
      Duration cacheDuration,
      int maxRetries,
      Duration requestTimeout});
}

/// @nodoc
class __$$GooglePlacesConfigImplCopyWithImpl<$Res>
    extends _$GooglePlacesConfigCopyWithImpl<$Res, _$GooglePlacesConfigImpl>
    implements _$$GooglePlacesConfigImplCopyWith<$Res> {
  __$$GooglePlacesConfigImplCopyWithImpl(_$GooglePlacesConfigImpl _value,
      $Res Function(_$GooglePlacesConfigImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? apiKey = null,
    Object? defaultRadius = null,
    Object? defaultTypes = null,
    Object? language = null,
    Object? region = null,
    Object? maxResults = null,
    Object? cacheDuration = null,
    Object? maxRetries = null,
    Object? requestTimeout = null,
  }) {
    return _then(_$GooglePlacesConfigImpl(
      apiKey: null == apiKey
          ? _value.apiKey
          : apiKey // ignore: cast_nullable_to_non_nullable
              as String,
      defaultRadius: null == defaultRadius
          ? _value.defaultRadius
          : defaultRadius // ignore: cast_nullable_to_non_nullable
              as double,
      defaultTypes: null == defaultTypes
          ? _value._defaultTypes
          : defaultTypes // ignore: cast_nullable_to_non_nullable
              as List<String>,
      language: null == language
          ? _value.language
          : language // ignore: cast_nullable_to_non_nullable
              as String,
      region: null == region
          ? _value.region
          : region // ignore: cast_nullable_to_non_nullable
              as String,
      maxResults: null == maxResults
          ? _value.maxResults
          : maxResults // ignore: cast_nullable_to_non_nullable
              as int,
      cacheDuration: null == cacheDuration
          ? _value.cacheDuration
          : cacheDuration // ignore: cast_nullable_to_non_nullable
              as Duration,
      maxRetries: null == maxRetries
          ? _value.maxRetries
          : maxRetries // ignore: cast_nullable_to_non_nullable
              as int,
      requestTimeout: null == requestTimeout
          ? _value.requestTimeout
          : requestTimeout // ignore: cast_nullable_to_non_nullable
              as Duration,
    ));
  }
}

/// @nodoc

class _$GooglePlacesConfigImpl
    with DiagnosticableTreeMixin
    implements _GooglePlacesConfig {
  const _$GooglePlacesConfigImpl(
      {required this.apiKey,
      required this.defaultRadius,
      required final List<String> defaultTypes,
      required this.language,
      required this.region,
      required this.maxResults,
      required this.cacheDuration,
      required this.maxRetries,
      required this.requestTimeout})
      : _defaultTypes = defaultTypes;

  @override
  final String apiKey;
  @override
  final double defaultRadius;
  final List<String> _defaultTypes;
  @override
  List<String> get defaultTypes {
    if (_defaultTypes is EqualUnmodifiableListView) return _defaultTypes;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_defaultTypes);
  }

  @override
  final String language;
  @override
  final String region;
  @override
  final int maxResults;
  @override
  final Duration cacheDuration;
  @override
  final int maxRetries;
  @override
  final Duration requestTimeout;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'GooglePlacesConfig(apiKey: $apiKey, defaultRadius: $defaultRadius, defaultTypes: $defaultTypes, language: $language, region: $region, maxResults: $maxResults, cacheDuration: $cacheDuration, maxRetries: $maxRetries, requestTimeout: $requestTimeout)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'GooglePlacesConfig'))
      ..add(DiagnosticsProperty('apiKey', apiKey))
      ..add(DiagnosticsProperty('defaultRadius', defaultRadius))
      ..add(DiagnosticsProperty('defaultTypes', defaultTypes))
      ..add(DiagnosticsProperty('language', language))
      ..add(DiagnosticsProperty('region', region))
      ..add(DiagnosticsProperty('maxResults', maxResults))
      ..add(DiagnosticsProperty('cacheDuration', cacheDuration))
      ..add(DiagnosticsProperty('maxRetries', maxRetries))
      ..add(DiagnosticsProperty('requestTimeout', requestTimeout));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GooglePlacesConfigImpl &&
            (identical(other.apiKey, apiKey) || other.apiKey == apiKey) &&
            (identical(other.defaultRadius, defaultRadius) ||
                other.defaultRadius == defaultRadius) &&
            const DeepCollectionEquality()
                .equals(other._defaultTypes, _defaultTypes) &&
            (identical(other.language, language) ||
                other.language == language) &&
            (identical(other.region, region) || other.region == region) &&
            (identical(other.maxResults, maxResults) ||
                other.maxResults == maxResults) &&
            (identical(other.cacheDuration, cacheDuration) ||
                other.cacheDuration == cacheDuration) &&
            (identical(other.maxRetries, maxRetries) ||
                other.maxRetries == maxRetries) &&
            (identical(other.requestTimeout, requestTimeout) ||
                other.requestTimeout == requestTimeout));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      apiKey,
      defaultRadius,
      const DeepCollectionEquality().hash(_defaultTypes),
      language,
      region,
      maxResults,
      cacheDuration,
      maxRetries,
      requestTimeout);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$GooglePlacesConfigImplCopyWith<_$GooglePlacesConfigImpl> get copyWith =>
      __$$GooglePlacesConfigImplCopyWithImpl<_$GooglePlacesConfigImpl>(
          this, _$identity);
}

abstract class _GooglePlacesConfig implements GooglePlacesConfig {
  const factory _GooglePlacesConfig(
      {required final String apiKey,
      required final double defaultRadius,
      required final List<String> defaultTypes,
      required final String language,
      required final String region,
      required final int maxResults,
      required final Duration cacheDuration,
      required final int maxRetries,
      required final Duration requestTimeout}) = _$GooglePlacesConfigImpl;

  @override
  String get apiKey;
  @override
  double get defaultRadius;
  @override
  List<String> get defaultTypes;
  @override
  String get language;
  @override
  String get region;
  @override
  int get maxResults;
  @override
  Duration get cacheDuration;
  @override
  int get maxRetries;
  @override
  Duration get requestTimeout;
  @override
  @JsonKey(ignore: true)
  _$$GooglePlacesConfigImplCopyWith<_$GooglePlacesConfigImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$PlaceSearchParams {
  LatLng get location => throw _privateConstructorUsedError;
  double get radius => throw _privateConstructorUsedError;
  List<String> get types => throw _privateConstructorUsedError;
  String? get keyword => throw _privateConstructorUsedError;
  String? get language => throw _privateConstructorUsedError;
  String? get region => throw _privateConstructorUsedError;
  int? get minPrice => throw _privateConstructorUsedError;
  int? get maxPrice => throw _privateConstructorUsedError;
  bool? get openNow => throw _privateConstructorUsedError;
  String? get pageToken => throw _privateConstructorUsedError;
  int get maxResults => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $PlaceSearchParamsCopyWith<PlaceSearchParams> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PlaceSearchParamsCopyWith<$Res> {
  factory $PlaceSearchParamsCopyWith(
          PlaceSearchParams value, $Res Function(PlaceSearchParams) then) =
      _$PlaceSearchParamsCopyWithImpl<$Res, PlaceSearchParams>;
  @useResult
  $Res call(
      {LatLng location,
      double radius,
      List<String> types,
      String? keyword,
      String? language,
      String? region,
      int? minPrice,
      int? maxPrice,
      bool? openNow,
      String? pageToken,
      int maxResults});
}

/// @nodoc
class _$PlaceSearchParamsCopyWithImpl<$Res, $Val extends PlaceSearchParams>
    implements $PlaceSearchParamsCopyWith<$Res> {
  _$PlaceSearchParamsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? location = freezed,
    Object? radius = null,
    Object? types = null,
    Object? keyword = freezed,
    Object? language = freezed,
    Object? region = freezed,
    Object? minPrice = freezed,
    Object? maxPrice = freezed,
    Object? openNow = freezed,
    Object? pageToken = freezed,
    Object? maxResults = null,
  }) {
    return _then(_value.copyWith(
      location: freezed == location
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as LatLng,
      radius: null == radius
          ? _value.radius
          : radius // ignore: cast_nullable_to_non_nullable
              as double,
      types: null == types
          ? _value.types
          : types // ignore: cast_nullable_to_non_nullable
              as List<String>,
      keyword: freezed == keyword
          ? _value.keyword
          : keyword // ignore: cast_nullable_to_non_nullable
              as String?,
      language: freezed == language
          ? _value.language
          : language // ignore: cast_nullable_to_non_nullable
              as String?,
      region: freezed == region
          ? _value.region
          : region // ignore: cast_nullable_to_non_nullable
              as String?,
      minPrice: freezed == minPrice
          ? _value.minPrice
          : minPrice // ignore: cast_nullable_to_non_nullable
              as int?,
      maxPrice: freezed == maxPrice
          ? _value.maxPrice
          : maxPrice // ignore: cast_nullable_to_non_nullable
              as int?,
      openNow: freezed == openNow
          ? _value.openNow
          : openNow // ignore: cast_nullable_to_non_nullable
              as bool?,
      pageToken: freezed == pageToken
          ? _value.pageToken
          : pageToken // ignore: cast_nullable_to_non_nullable
              as String?,
      maxResults: null == maxResults
          ? _value.maxResults
          : maxResults // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PlaceSearchParamsImplCopyWith<$Res>
    implements $PlaceSearchParamsCopyWith<$Res> {
  factory _$$PlaceSearchParamsImplCopyWith(_$PlaceSearchParamsImpl value,
          $Res Function(_$PlaceSearchParamsImpl) then) =
      __$$PlaceSearchParamsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {LatLng location,
      double radius,
      List<String> types,
      String? keyword,
      String? language,
      String? region,
      int? minPrice,
      int? maxPrice,
      bool? openNow,
      String? pageToken,
      int maxResults});
}

/// @nodoc
class __$$PlaceSearchParamsImplCopyWithImpl<$Res>
    extends _$PlaceSearchParamsCopyWithImpl<$Res, _$PlaceSearchParamsImpl>
    implements _$$PlaceSearchParamsImplCopyWith<$Res> {
  __$$PlaceSearchParamsImplCopyWithImpl(_$PlaceSearchParamsImpl _value,
      $Res Function(_$PlaceSearchParamsImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? location = freezed,
    Object? radius = null,
    Object? types = null,
    Object? keyword = freezed,
    Object? language = freezed,
    Object? region = freezed,
    Object? minPrice = freezed,
    Object? maxPrice = freezed,
    Object? openNow = freezed,
    Object? pageToken = freezed,
    Object? maxResults = null,
  }) {
    return _then(_$PlaceSearchParamsImpl(
      location: freezed == location
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as LatLng,
      radius: null == radius
          ? _value.radius
          : radius // ignore: cast_nullable_to_non_nullable
              as double,
      types: null == types
          ? _value._types
          : types // ignore: cast_nullable_to_non_nullable
              as List<String>,
      keyword: freezed == keyword
          ? _value.keyword
          : keyword // ignore: cast_nullable_to_non_nullable
              as String?,
      language: freezed == language
          ? _value.language
          : language // ignore: cast_nullable_to_non_nullable
              as String?,
      region: freezed == region
          ? _value.region
          : region // ignore: cast_nullable_to_non_nullable
              as String?,
      minPrice: freezed == minPrice
          ? _value.minPrice
          : minPrice // ignore: cast_nullable_to_non_nullable
              as int?,
      maxPrice: freezed == maxPrice
          ? _value.maxPrice
          : maxPrice // ignore: cast_nullable_to_non_nullable
              as int?,
      openNow: freezed == openNow
          ? _value.openNow
          : openNow // ignore: cast_nullable_to_non_nullable
              as bool?,
      pageToken: freezed == pageToken
          ? _value.pageToken
          : pageToken // ignore: cast_nullable_to_non_nullable
              as String?,
      maxResults: null == maxResults
          ? _value.maxResults
          : maxResults // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc

class _$PlaceSearchParamsImpl
    with DiagnosticableTreeMixin
    implements _PlaceSearchParams {
  const _$PlaceSearchParamsImpl(
      {required this.location,
      required this.radius,
      required final List<String> types,
      this.keyword,
      this.language,
      this.region,
      this.minPrice,
      this.maxPrice,
      this.openNow,
      this.pageToken,
      this.maxResults = 60})
      : _types = types;

  @override
  final LatLng location;
  @override
  final double radius;
  final List<String> _types;
  @override
  List<String> get types {
    if (_types is EqualUnmodifiableListView) return _types;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_types);
  }

  @override
  final String? keyword;
  @override
  final String? language;
  @override
  final String? region;
  @override
  final int? minPrice;
  @override
  final int? maxPrice;
  @override
  final bool? openNow;
  @override
  final String? pageToken;
  @override
  @JsonKey()
  final int maxResults;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'PlaceSearchParams(location: $location, radius: $radius, types: $types, keyword: $keyword, language: $language, region: $region, minPrice: $minPrice, maxPrice: $maxPrice, openNow: $openNow, pageToken: $pageToken, maxResults: $maxResults)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'PlaceSearchParams'))
      ..add(DiagnosticsProperty('location', location))
      ..add(DiagnosticsProperty('radius', radius))
      ..add(DiagnosticsProperty('types', types))
      ..add(DiagnosticsProperty('keyword', keyword))
      ..add(DiagnosticsProperty('language', language))
      ..add(DiagnosticsProperty('region', region))
      ..add(DiagnosticsProperty('minPrice', minPrice))
      ..add(DiagnosticsProperty('maxPrice', maxPrice))
      ..add(DiagnosticsProperty('openNow', openNow))
      ..add(DiagnosticsProperty('pageToken', pageToken))
      ..add(DiagnosticsProperty('maxResults', maxResults));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PlaceSearchParamsImpl &&
            const DeepCollectionEquality().equals(other.location, location) &&
            (identical(other.radius, radius) || other.radius == radius) &&
            const DeepCollectionEquality().equals(other._types, _types) &&
            (identical(other.keyword, keyword) || other.keyword == keyword) &&
            (identical(other.language, language) ||
                other.language == language) &&
            (identical(other.region, region) || other.region == region) &&
            (identical(other.minPrice, minPrice) ||
                other.minPrice == minPrice) &&
            (identical(other.maxPrice, maxPrice) ||
                other.maxPrice == maxPrice) &&
            (identical(other.openNow, openNow) || other.openNow == openNow) &&
            (identical(other.pageToken, pageToken) ||
                other.pageToken == pageToken) &&
            (identical(other.maxResults, maxResults) ||
                other.maxResults == maxResults));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(location),
      radius,
      const DeepCollectionEquality().hash(_types),
      keyword,
      language,
      region,
      minPrice,
      maxPrice,
      openNow,
      pageToken,
      maxResults);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$PlaceSearchParamsImplCopyWith<_$PlaceSearchParamsImpl> get copyWith =>
      __$$PlaceSearchParamsImplCopyWithImpl<_$PlaceSearchParamsImpl>(
          this, _$identity);
}

abstract class _PlaceSearchParams implements PlaceSearchParams {
  const factory _PlaceSearchParams(
      {required final LatLng location,
      required final double radius,
      required final List<String> types,
      final String? keyword,
      final String? language,
      final String? region,
      final int? minPrice,
      final int? maxPrice,
      final bool? openNow,
      final String? pageToken,
      final int maxResults}) = _$PlaceSearchParamsImpl;

  @override
  LatLng get location;
  @override
  double get radius;
  @override
  List<String> get types;
  @override
  String? get keyword;
  @override
  String? get language;
  @override
  String? get region;
  @override
  int? get minPrice;
  @override
  int? get maxPrice;
  @override
  bool? get openNow;
  @override
  String? get pageToken;
  @override
  int get maxResults;
  @override
  @JsonKey(ignore: true)
  _$$PlaceSearchParamsImplCopyWith<_$PlaceSearchParamsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$NearbySearchResult {
  List<PlaceOpportunity> get places => throw _privateConstructorUsedError;
  String? get nextPageToken => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  String? get errorMessage => throw _privateConstructorUsedError;
  DateTime get timestamp => throw _privateConstructorUsedError;
  LatLng get searchCenter => throw _privateConstructorUsedError;
  double get searchRadius => throw _privateConstructorUsedError;
  List<String> get searchTypes => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $NearbySearchResultCopyWith<NearbySearchResult> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $NearbySearchResultCopyWith<$Res> {
  factory $NearbySearchResultCopyWith(
          NearbySearchResult value, $Res Function(NearbySearchResult) then) =
      _$NearbySearchResultCopyWithImpl<$Res, NearbySearchResult>;
  @useResult
  $Res call(
      {List<PlaceOpportunity> places,
      String? nextPageToken,
      String status,
      String? errorMessage,
      DateTime timestamp,
      LatLng searchCenter,
      double searchRadius,
      List<String> searchTypes});
}

/// @nodoc
class _$NearbySearchResultCopyWithImpl<$Res, $Val extends NearbySearchResult>
    implements $NearbySearchResultCopyWith<$Res> {
  _$NearbySearchResultCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? places = null,
    Object? nextPageToken = freezed,
    Object? status = null,
    Object? errorMessage = freezed,
    Object? timestamp = null,
    Object? searchCenter = freezed,
    Object? searchRadius = null,
    Object? searchTypes = null,
  }) {
    return _then(_value.copyWith(
      places: null == places
          ? _value.places
          : places // ignore: cast_nullable_to_non_nullable
              as List<PlaceOpportunity>,
      nextPageToken: freezed == nextPageToken
          ? _value.nextPageToken
          : nextPageToken // ignore: cast_nullable_to_non_nullable
              as String?,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      errorMessage: freezed == errorMessage
          ? _value.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String?,
      timestamp: null == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as DateTime,
      searchCenter: freezed == searchCenter
          ? _value.searchCenter
          : searchCenter // ignore: cast_nullable_to_non_nullable
              as LatLng,
      searchRadius: null == searchRadius
          ? _value.searchRadius
          : searchRadius // ignore: cast_nullable_to_non_nullable
              as double,
      searchTypes: null == searchTypes
          ? _value.searchTypes
          : searchTypes // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$NearbySearchResultImplCopyWith<$Res>
    implements $NearbySearchResultCopyWith<$Res> {
  factory _$$NearbySearchResultImplCopyWith(_$NearbySearchResultImpl value,
          $Res Function(_$NearbySearchResultImpl) then) =
      __$$NearbySearchResultImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {List<PlaceOpportunity> places,
      String? nextPageToken,
      String status,
      String? errorMessage,
      DateTime timestamp,
      LatLng searchCenter,
      double searchRadius,
      List<String> searchTypes});
}

/// @nodoc
class __$$NearbySearchResultImplCopyWithImpl<$Res>
    extends _$NearbySearchResultCopyWithImpl<$Res, _$NearbySearchResultImpl>
    implements _$$NearbySearchResultImplCopyWith<$Res> {
  __$$NearbySearchResultImplCopyWithImpl(_$NearbySearchResultImpl _value,
      $Res Function(_$NearbySearchResultImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? places = null,
    Object? nextPageToken = freezed,
    Object? status = null,
    Object? errorMessage = freezed,
    Object? timestamp = null,
    Object? searchCenter = freezed,
    Object? searchRadius = null,
    Object? searchTypes = null,
  }) {
    return _then(_$NearbySearchResultImpl(
      places: null == places
          ? _value._places
          : places // ignore: cast_nullable_to_non_nullable
              as List<PlaceOpportunity>,
      nextPageToken: freezed == nextPageToken
          ? _value.nextPageToken
          : nextPageToken // ignore: cast_nullable_to_non_nullable
              as String?,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      errorMessage: freezed == errorMessage
          ? _value.errorMessage
          : errorMessage // ignore: cast_nullable_to_non_nullable
              as String?,
      timestamp: null == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as DateTime,
      searchCenter: freezed == searchCenter
          ? _value.searchCenter
          : searchCenter // ignore: cast_nullable_to_non_nullable
              as LatLng,
      searchRadius: null == searchRadius
          ? _value.searchRadius
          : searchRadius // ignore: cast_nullable_to_non_nullable
              as double,
      searchTypes: null == searchTypes
          ? _value._searchTypes
          : searchTypes // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ));
  }
}

/// @nodoc

class _$NearbySearchResultImpl
    with DiagnosticableTreeMixin
    implements _NearbySearchResult {
  const _$NearbySearchResultImpl(
      {required final List<PlaceOpportunity> places,
      required this.nextPageToken,
      required this.status,
      required this.errorMessage,
      required this.timestamp,
      required this.searchCenter,
      required this.searchRadius,
      required final List<String> searchTypes})
      : _places = places,
        _searchTypes = searchTypes;

  final List<PlaceOpportunity> _places;
  @override
  List<PlaceOpportunity> get places {
    if (_places is EqualUnmodifiableListView) return _places;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_places);
  }

  @override
  final String? nextPageToken;
  @override
  final String status;
  @override
  final String? errorMessage;
  @override
  final DateTime timestamp;
  @override
  final LatLng searchCenter;
  @override
  final double searchRadius;
  final List<String> _searchTypes;
  @override
  List<String> get searchTypes {
    if (_searchTypes is EqualUnmodifiableListView) return _searchTypes;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_searchTypes);
  }

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'NearbySearchResult(places: $places, nextPageToken: $nextPageToken, status: $status, errorMessage: $errorMessage, timestamp: $timestamp, searchCenter: $searchCenter, searchRadius: $searchRadius, searchTypes: $searchTypes)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'NearbySearchResult'))
      ..add(DiagnosticsProperty('places', places))
      ..add(DiagnosticsProperty('nextPageToken', nextPageToken))
      ..add(DiagnosticsProperty('status', status))
      ..add(DiagnosticsProperty('errorMessage', errorMessage))
      ..add(DiagnosticsProperty('timestamp', timestamp))
      ..add(DiagnosticsProperty('searchCenter', searchCenter))
      ..add(DiagnosticsProperty('searchRadius', searchRadius))
      ..add(DiagnosticsProperty('searchTypes', searchTypes));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NearbySearchResultImpl &&
            const DeepCollectionEquality().equals(other._places, _places) &&
            (identical(other.nextPageToken, nextPageToken) ||
                other.nextPageToken == nextPageToken) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage) &&
            (identical(other.timestamp, timestamp) ||
                other.timestamp == timestamp) &&
            const DeepCollectionEquality()
                .equals(other.searchCenter, searchCenter) &&
            (identical(other.searchRadius, searchRadius) ||
                other.searchRadius == searchRadius) &&
            const DeepCollectionEquality()
                .equals(other._searchTypes, _searchTypes));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_places),
      nextPageToken,
      status,
      errorMessage,
      timestamp,
      const DeepCollectionEquality().hash(searchCenter),
      searchRadius,
      const DeepCollectionEquality().hash(_searchTypes));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$NearbySearchResultImplCopyWith<_$NearbySearchResultImpl> get copyWith =>
      __$$NearbySearchResultImplCopyWithImpl<_$NearbySearchResultImpl>(
          this, _$identity);
}

abstract class _NearbySearchResult implements NearbySearchResult {
  const factory _NearbySearchResult(
      {required final List<PlaceOpportunity> places,
      required final String? nextPageToken,
      required final String status,
      required final String? errorMessage,
      required final DateTime timestamp,
      required final LatLng searchCenter,
      required final double searchRadius,
      required final List<String> searchTypes}) = _$NearbySearchResultImpl;

  @override
  List<PlaceOpportunity> get places;
  @override
  String? get nextPageToken;
  @override
  String get status;
  @override
  String? get errorMessage;
  @override
  DateTime get timestamp;
  @override
  LatLng get searchCenter;
  @override
  double get searchRadius;
  @override
  List<String> get searchTypes;
  @override
  @JsonKey(ignore: true)
  _$$NearbySearchResultImplCopyWith<_$NearbySearchResultImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

PlaceDetails _$PlaceDetailsFromJson(Map<String, dynamic> json) {
  return _PlaceDetails.fromJson(json);
}

/// @nodoc
mixin _$PlaceDetails {
  String get placeId => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get formattedAddress => throw _privateConstructorUsedError;
  LatLng get geometry => throw _privateConstructorUsedError;
  double? get rating => throw _privateConstructorUsedError;
  int? get userRatingsTotal => throw _privateConstructorUsedError;
  int? get priceLevel => throw _privateConstructorUsedError;
  List<String> get types => throw _privateConstructorUsedError;
  String? get website => throw _privateConstructorUsedError;
  String? get formattedPhoneNumber => throw _privateConstructorUsedError;
  OpeningHours? get openingHours => throw _privateConstructorUsedError;
  List<PlacePhotoData>? get photos => throw _privateConstructorUsedError;
  List<PlaceReview>? get reviews => throw _privateConstructorUsedError;
  String? get businessStatus => throw _privateConstructorUsedError;
  String? get url => throw _privateConstructorUsedError;
  String? get vicinity => throw _privateConstructorUsedError;
  bool? get wheelchairAccessibleEntrance => throw _privateConstructorUsedError;
  OpeningHours? get currentOpeningHours => throw _privateConstructorUsedError;
  OpeningHours? get secondaryOpeningHours => throw _privateConstructorUsedError;
  String? get editorialSummary => throw _privateConstructorUsedError;
  String? get adrAddress => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $PlaceDetailsCopyWith<PlaceDetails> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PlaceDetailsCopyWith<$Res> {
  factory $PlaceDetailsCopyWith(
          PlaceDetails value, $Res Function(PlaceDetails) then) =
      _$PlaceDetailsCopyWithImpl<$Res, PlaceDetails>;
  @useResult
  $Res call(
      {String placeId,
      String name,
      String formattedAddress,
      LatLng geometry,
      double? rating,
      int? userRatingsTotal,
      int? priceLevel,
      List<String> types,
      String? website,
      String? formattedPhoneNumber,
      OpeningHours? openingHours,
      List<PlacePhotoData>? photos,
      List<PlaceReview>? reviews,
      String? businessStatus,
      String? url,
      String? vicinity,
      bool? wheelchairAccessibleEntrance,
      OpeningHours? currentOpeningHours,
      OpeningHours? secondaryOpeningHours,
      String? editorialSummary,
      String? adrAddress});

  $OpeningHoursCopyWith<$Res>? get openingHours;
  $OpeningHoursCopyWith<$Res>? get currentOpeningHours;
  $OpeningHoursCopyWith<$Res>? get secondaryOpeningHours;
}

/// @nodoc
class _$PlaceDetailsCopyWithImpl<$Res, $Val extends PlaceDetails>
    implements $PlaceDetailsCopyWith<$Res> {
  _$PlaceDetailsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? placeId = null,
    Object? name = null,
    Object? formattedAddress = null,
    Object? geometry = freezed,
    Object? rating = freezed,
    Object? userRatingsTotal = freezed,
    Object? priceLevel = freezed,
    Object? types = null,
    Object? website = freezed,
    Object? formattedPhoneNumber = freezed,
    Object? openingHours = freezed,
    Object? photos = freezed,
    Object? reviews = freezed,
    Object? businessStatus = freezed,
    Object? url = freezed,
    Object? vicinity = freezed,
    Object? wheelchairAccessibleEntrance = freezed,
    Object? currentOpeningHours = freezed,
    Object? secondaryOpeningHours = freezed,
    Object? editorialSummary = freezed,
    Object? adrAddress = freezed,
  }) {
    return _then(_value.copyWith(
      placeId: null == placeId
          ? _value.placeId
          : placeId // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      formattedAddress: null == formattedAddress
          ? _value.formattedAddress
          : formattedAddress // ignore: cast_nullable_to_non_nullable
              as String,
      geometry: freezed == geometry
          ? _value.geometry
          : geometry // ignore: cast_nullable_to_non_nullable
              as LatLng,
      rating: freezed == rating
          ? _value.rating
          : rating // ignore: cast_nullable_to_non_nullable
              as double?,
      userRatingsTotal: freezed == userRatingsTotal
          ? _value.userRatingsTotal
          : userRatingsTotal // ignore: cast_nullable_to_non_nullable
              as int?,
      priceLevel: freezed == priceLevel
          ? _value.priceLevel
          : priceLevel // ignore: cast_nullable_to_non_nullable
              as int?,
      types: null == types
          ? _value.types
          : types // ignore: cast_nullable_to_non_nullable
              as List<String>,
      website: freezed == website
          ? _value.website
          : website // ignore: cast_nullable_to_non_nullable
              as String?,
      formattedPhoneNumber: freezed == formattedPhoneNumber
          ? _value.formattedPhoneNumber
          : formattedPhoneNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      openingHours: freezed == openingHours
          ? _value.openingHours
          : openingHours // ignore: cast_nullable_to_non_nullable
              as OpeningHours?,
      photos: freezed == photos
          ? _value.photos
          : photos // ignore: cast_nullable_to_non_nullable
              as List<PlacePhotoData>?,
      reviews: freezed == reviews
          ? _value.reviews
          : reviews // ignore: cast_nullable_to_non_nullable
              as List<PlaceReview>?,
      businessStatus: freezed == businessStatus
          ? _value.businessStatus
          : businessStatus // ignore: cast_nullable_to_non_nullable
              as String?,
      url: freezed == url
          ? _value.url
          : url // ignore: cast_nullable_to_non_nullable
              as String?,
      vicinity: freezed == vicinity
          ? _value.vicinity
          : vicinity // ignore: cast_nullable_to_non_nullable
              as String?,
      wheelchairAccessibleEntrance: freezed == wheelchairAccessibleEntrance
          ? _value.wheelchairAccessibleEntrance
          : wheelchairAccessibleEntrance // ignore: cast_nullable_to_non_nullable
              as bool?,
      currentOpeningHours: freezed == currentOpeningHours
          ? _value.currentOpeningHours
          : currentOpeningHours // ignore: cast_nullable_to_non_nullable
              as OpeningHours?,
      secondaryOpeningHours: freezed == secondaryOpeningHours
          ? _value.secondaryOpeningHours
          : secondaryOpeningHours // ignore: cast_nullable_to_non_nullable
              as OpeningHours?,
      editorialSummary: freezed == editorialSummary
          ? _value.editorialSummary
          : editorialSummary // ignore: cast_nullable_to_non_nullable
              as String?,
      adrAddress: freezed == adrAddress
          ? _value.adrAddress
          : adrAddress // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $OpeningHoursCopyWith<$Res>? get openingHours {
    if (_value.openingHours == null) {
      return null;
    }

    return $OpeningHoursCopyWith<$Res>(_value.openingHours!, (value) {
      return _then(_value.copyWith(openingHours: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $OpeningHoursCopyWith<$Res>? get currentOpeningHours {
    if (_value.currentOpeningHours == null) {
      return null;
    }

    return $OpeningHoursCopyWith<$Res>(_value.currentOpeningHours!, (value) {
      return _then(_value.copyWith(currentOpeningHours: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $OpeningHoursCopyWith<$Res>? get secondaryOpeningHours {
    if (_value.secondaryOpeningHours == null) {
      return null;
    }

    return $OpeningHoursCopyWith<$Res>(_value.secondaryOpeningHours!, (value) {
      return _then(_value.copyWith(secondaryOpeningHours: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$PlaceDetailsImplCopyWith<$Res>
    implements $PlaceDetailsCopyWith<$Res> {
  factory _$$PlaceDetailsImplCopyWith(
          _$PlaceDetailsImpl value, $Res Function(_$PlaceDetailsImpl) then) =
      __$$PlaceDetailsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String placeId,
      String name,
      String formattedAddress,
      LatLng geometry,
      double? rating,
      int? userRatingsTotal,
      int? priceLevel,
      List<String> types,
      String? website,
      String? formattedPhoneNumber,
      OpeningHours? openingHours,
      List<PlacePhotoData>? photos,
      List<PlaceReview>? reviews,
      String? businessStatus,
      String? url,
      String? vicinity,
      bool? wheelchairAccessibleEntrance,
      OpeningHours? currentOpeningHours,
      OpeningHours? secondaryOpeningHours,
      String? editorialSummary,
      String? adrAddress});

  @override
  $OpeningHoursCopyWith<$Res>? get openingHours;
  @override
  $OpeningHoursCopyWith<$Res>? get currentOpeningHours;
  @override
  $OpeningHoursCopyWith<$Res>? get secondaryOpeningHours;
}

/// @nodoc
class __$$PlaceDetailsImplCopyWithImpl<$Res>
    extends _$PlaceDetailsCopyWithImpl<$Res, _$PlaceDetailsImpl>
    implements _$$PlaceDetailsImplCopyWith<$Res> {
  __$$PlaceDetailsImplCopyWithImpl(
      _$PlaceDetailsImpl _value, $Res Function(_$PlaceDetailsImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? placeId = null,
    Object? name = null,
    Object? formattedAddress = null,
    Object? geometry = freezed,
    Object? rating = freezed,
    Object? userRatingsTotal = freezed,
    Object? priceLevel = freezed,
    Object? types = null,
    Object? website = freezed,
    Object? formattedPhoneNumber = freezed,
    Object? openingHours = freezed,
    Object? photos = freezed,
    Object? reviews = freezed,
    Object? businessStatus = freezed,
    Object? url = freezed,
    Object? vicinity = freezed,
    Object? wheelchairAccessibleEntrance = freezed,
    Object? currentOpeningHours = freezed,
    Object? secondaryOpeningHours = freezed,
    Object? editorialSummary = freezed,
    Object? adrAddress = freezed,
  }) {
    return _then(_$PlaceDetailsImpl(
      placeId: null == placeId
          ? _value.placeId
          : placeId // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      formattedAddress: null == formattedAddress
          ? _value.formattedAddress
          : formattedAddress // ignore: cast_nullable_to_non_nullable
              as String,
      geometry: freezed == geometry
          ? _value.geometry
          : geometry // ignore: cast_nullable_to_non_nullable
              as LatLng,
      rating: freezed == rating
          ? _value.rating
          : rating // ignore: cast_nullable_to_non_nullable
              as double?,
      userRatingsTotal: freezed == userRatingsTotal
          ? _value.userRatingsTotal
          : userRatingsTotal // ignore: cast_nullable_to_non_nullable
              as int?,
      priceLevel: freezed == priceLevel
          ? _value.priceLevel
          : priceLevel // ignore: cast_nullable_to_non_nullable
              as int?,
      types: null == types
          ? _value._types
          : types // ignore: cast_nullable_to_non_nullable
              as List<String>,
      website: freezed == website
          ? _value.website
          : website // ignore: cast_nullable_to_non_nullable
              as String?,
      formattedPhoneNumber: freezed == formattedPhoneNumber
          ? _value.formattedPhoneNumber
          : formattedPhoneNumber // ignore: cast_nullable_to_non_nullable
              as String?,
      openingHours: freezed == openingHours
          ? _value.openingHours
          : openingHours // ignore: cast_nullable_to_non_nullable
              as OpeningHours?,
      photos: freezed == photos
          ? _value._photos
          : photos // ignore: cast_nullable_to_non_nullable
              as List<PlacePhotoData>?,
      reviews: freezed == reviews
          ? _value._reviews
          : reviews // ignore: cast_nullable_to_non_nullable
              as List<PlaceReview>?,
      businessStatus: freezed == businessStatus
          ? _value.businessStatus
          : businessStatus // ignore: cast_nullable_to_non_nullable
              as String?,
      url: freezed == url
          ? _value.url
          : url // ignore: cast_nullable_to_non_nullable
              as String?,
      vicinity: freezed == vicinity
          ? _value.vicinity
          : vicinity // ignore: cast_nullable_to_non_nullable
              as String?,
      wheelchairAccessibleEntrance: freezed == wheelchairAccessibleEntrance
          ? _value.wheelchairAccessibleEntrance
          : wheelchairAccessibleEntrance // ignore: cast_nullable_to_non_nullable
              as bool?,
      currentOpeningHours: freezed == currentOpeningHours
          ? _value.currentOpeningHours
          : currentOpeningHours // ignore: cast_nullable_to_non_nullable
              as OpeningHours?,
      secondaryOpeningHours: freezed == secondaryOpeningHours
          ? _value.secondaryOpeningHours
          : secondaryOpeningHours // ignore: cast_nullable_to_non_nullable
              as OpeningHours?,
      editorialSummary: freezed == editorialSummary
          ? _value.editorialSummary
          : editorialSummary // ignore: cast_nullable_to_non_nullable
              as String?,
      adrAddress: freezed == adrAddress
          ? _value.adrAddress
          : adrAddress // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PlaceDetailsImpl with DiagnosticableTreeMixin implements _PlaceDetails {
  const _$PlaceDetailsImpl(
      {required this.placeId,
      required this.name,
      required this.formattedAddress,
      required this.geometry,
      required this.rating,
      required this.userRatingsTotal,
      required this.priceLevel,
      required final List<String> types,
      required this.website,
      required this.formattedPhoneNumber,
      required this.openingHours,
      required final List<PlacePhotoData>? photos,
      required final List<PlaceReview>? reviews,
      required this.businessStatus,
      required this.url,
      required this.vicinity,
      required this.wheelchairAccessibleEntrance,
      required this.currentOpeningHours,
      required this.secondaryOpeningHours,
      required this.editorialSummary,
      required this.adrAddress})
      : _types = types,
        _photos = photos,
        _reviews = reviews;

  factory _$PlaceDetailsImpl.fromJson(Map<String, dynamic> json) =>
      _$$PlaceDetailsImplFromJson(json);

  @override
  final String placeId;
  @override
  final String name;
  @override
  final String formattedAddress;
  @override
  final LatLng geometry;
  @override
  final double? rating;
  @override
  final int? userRatingsTotal;
  @override
  final int? priceLevel;
  final List<String> _types;
  @override
  List<String> get types {
    if (_types is EqualUnmodifiableListView) return _types;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_types);
  }

  @override
  final String? website;
  @override
  final String? formattedPhoneNumber;
  @override
  final OpeningHours? openingHours;
  final List<PlacePhotoData>? _photos;
  @override
  List<PlacePhotoData>? get photos {
    final value = _photos;
    if (value == null) return null;
    if (_photos is EqualUnmodifiableListView) return _photos;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  final List<PlaceReview>? _reviews;
  @override
  List<PlaceReview>? get reviews {
    final value = _reviews;
    if (value == null) return null;
    if (_reviews is EqualUnmodifiableListView) return _reviews;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  final String? businessStatus;
  @override
  final String? url;
  @override
  final String? vicinity;
  @override
  final bool? wheelchairAccessibleEntrance;
  @override
  final OpeningHours? currentOpeningHours;
  @override
  final OpeningHours? secondaryOpeningHours;
  @override
  final String? editorialSummary;
  @override
  final String? adrAddress;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'PlaceDetails(placeId: $placeId, name: $name, formattedAddress: $formattedAddress, geometry: $geometry, rating: $rating, userRatingsTotal: $userRatingsTotal, priceLevel: $priceLevel, types: $types, website: $website, formattedPhoneNumber: $formattedPhoneNumber, openingHours: $openingHours, photos: $photos, reviews: $reviews, businessStatus: $businessStatus, url: $url, vicinity: $vicinity, wheelchairAccessibleEntrance: $wheelchairAccessibleEntrance, currentOpeningHours: $currentOpeningHours, secondaryOpeningHours: $secondaryOpeningHours, editorialSummary: $editorialSummary, adrAddress: $adrAddress)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'PlaceDetails'))
      ..add(DiagnosticsProperty('placeId', placeId))
      ..add(DiagnosticsProperty('name', name))
      ..add(DiagnosticsProperty('formattedAddress', formattedAddress))
      ..add(DiagnosticsProperty('geometry', geometry))
      ..add(DiagnosticsProperty('rating', rating))
      ..add(DiagnosticsProperty('userRatingsTotal', userRatingsTotal))
      ..add(DiagnosticsProperty('priceLevel', priceLevel))
      ..add(DiagnosticsProperty('types', types))
      ..add(DiagnosticsProperty('website', website))
      ..add(DiagnosticsProperty('formattedPhoneNumber', formattedPhoneNumber))
      ..add(DiagnosticsProperty('openingHours', openingHours))
      ..add(DiagnosticsProperty('photos', photos))
      ..add(DiagnosticsProperty('reviews', reviews))
      ..add(DiagnosticsProperty('businessStatus', businessStatus))
      ..add(DiagnosticsProperty('url', url))
      ..add(DiagnosticsProperty('vicinity', vicinity))
      ..add(DiagnosticsProperty(
          'wheelchairAccessibleEntrance', wheelchairAccessibleEntrance))
      ..add(DiagnosticsProperty('currentOpeningHours', currentOpeningHours))
      ..add(DiagnosticsProperty('secondaryOpeningHours', secondaryOpeningHours))
      ..add(DiagnosticsProperty('editorialSummary', editorialSummary))
      ..add(DiagnosticsProperty('adrAddress', adrAddress));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PlaceDetailsImpl &&
            (identical(other.placeId, placeId) || other.placeId == placeId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.formattedAddress, formattedAddress) ||
                other.formattedAddress == formattedAddress) &&
            const DeepCollectionEquality().equals(other.geometry, geometry) &&
            (identical(other.rating, rating) || other.rating == rating) &&
            (identical(other.userRatingsTotal, userRatingsTotal) ||
                other.userRatingsTotal == userRatingsTotal) &&
            (identical(other.priceLevel, priceLevel) ||
                other.priceLevel == priceLevel) &&
            const DeepCollectionEquality().equals(other._types, _types) &&
            (identical(other.website, website) || other.website == website) &&
            (identical(other.formattedPhoneNumber, formattedPhoneNumber) ||
                other.formattedPhoneNumber == formattedPhoneNumber) &&
            (identical(other.openingHours, openingHours) ||
                other.openingHours == openingHours) &&
            const DeepCollectionEquality().equals(other._photos, _photos) &&
            const DeepCollectionEquality().equals(other._reviews, _reviews) &&
            (identical(other.businessStatus, businessStatus) ||
                other.businessStatus == businessStatus) &&
            (identical(other.url, url) || other.url == url) &&
            (identical(other.vicinity, vicinity) ||
                other.vicinity == vicinity) &&
            (identical(other.wheelchairAccessibleEntrance,
                    wheelchairAccessibleEntrance) ||
                other.wheelchairAccessibleEntrance ==
                    wheelchairAccessibleEntrance) &&
            (identical(other.currentOpeningHours, currentOpeningHours) ||
                other.currentOpeningHours == currentOpeningHours) &&
            (identical(other.secondaryOpeningHours, secondaryOpeningHours) ||
                other.secondaryOpeningHours == secondaryOpeningHours) &&
            (identical(other.editorialSummary, editorialSummary) ||
                other.editorialSummary == editorialSummary) &&
            (identical(other.adrAddress, adrAddress) ||
                other.adrAddress == adrAddress));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        placeId,
        name,
        formattedAddress,
        const DeepCollectionEquality().hash(geometry),
        rating,
        userRatingsTotal,
        priceLevel,
        const DeepCollectionEquality().hash(_types),
        website,
        formattedPhoneNumber,
        openingHours,
        const DeepCollectionEquality().hash(_photos),
        const DeepCollectionEquality().hash(_reviews),
        businessStatus,
        url,
        vicinity,
        wheelchairAccessibleEntrance,
        currentOpeningHours,
        secondaryOpeningHours,
        editorialSummary,
        adrAddress
      ]);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$PlaceDetailsImplCopyWith<_$PlaceDetailsImpl> get copyWith =>
      __$$PlaceDetailsImplCopyWithImpl<_$PlaceDetailsImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PlaceDetailsImplToJson(
      this,
    );
  }
}

abstract class _PlaceDetails implements PlaceDetails {
  const factory _PlaceDetails(
      {required final String placeId,
      required final String name,
      required final String formattedAddress,
      required final LatLng geometry,
      required final double? rating,
      required final int? userRatingsTotal,
      required final int? priceLevel,
      required final List<String> types,
      required final String? website,
      required final String? formattedPhoneNumber,
      required final OpeningHours? openingHours,
      required final List<PlacePhotoData>? photos,
      required final List<PlaceReview>? reviews,
      required final String? businessStatus,
      required final String? url,
      required final String? vicinity,
      required final bool? wheelchairAccessibleEntrance,
      required final OpeningHours? currentOpeningHours,
      required final OpeningHours? secondaryOpeningHours,
      required final String? editorialSummary,
      required final String? adrAddress}) = _$PlaceDetailsImpl;

  factory _PlaceDetails.fromJson(Map<String, dynamic> json) =
      _$PlaceDetailsImpl.fromJson;

  @override
  String get placeId;
  @override
  String get name;
  @override
  String get formattedAddress;
  @override
  LatLng get geometry;
  @override
  double? get rating;
  @override
  int? get userRatingsTotal;
  @override
  int? get priceLevel;
  @override
  List<String> get types;
  @override
  String? get website;
  @override
  String? get formattedPhoneNumber;
  @override
  OpeningHours? get openingHours;
  @override
  List<PlacePhotoData>? get photos;
  @override
  List<PlaceReview>? get reviews;
  @override
  String? get businessStatus;
  @override
  String? get url;
  @override
  String? get vicinity;
  @override
  bool? get wheelchairAccessibleEntrance;
  @override
  OpeningHours? get currentOpeningHours;
  @override
  OpeningHours? get secondaryOpeningHours;
  @override
  String? get editorialSummary;
  @override
  String? get adrAddress;
  @override
  @JsonKey(ignore: true)
  _$$PlaceDetailsImplCopyWith<_$PlaceDetailsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

OpeningHours _$OpeningHoursFromJson(Map<String, dynamic> json) {
  return _OpeningHours.fromJson(json);
}

/// @nodoc
mixin _$OpeningHours {
  bool get openNow => throw _privateConstructorUsedError;
  List<String> get periods => throw _privateConstructorUsedError;
  List<String> get weekdayText => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $OpeningHoursCopyWith<OpeningHours> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OpeningHoursCopyWith<$Res> {
  factory $OpeningHoursCopyWith(
          OpeningHours value, $Res Function(OpeningHours) then) =
      _$OpeningHoursCopyWithImpl<$Res, OpeningHours>;
  @useResult
  $Res call({bool openNow, List<String> periods, List<String> weekdayText});
}

/// @nodoc
class _$OpeningHoursCopyWithImpl<$Res, $Val extends OpeningHours>
    implements $OpeningHoursCopyWith<$Res> {
  _$OpeningHoursCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? openNow = null,
    Object? periods = null,
    Object? weekdayText = null,
  }) {
    return _then(_value.copyWith(
      openNow: null == openNow
          ? _value.openNow
          : openNow // ignore: cast_nullable_to_non_nullable
              as bool,
      periods: null == periods
          ? _value.periods
          : periods // ignore: cast_nullable_to_non_nullable
              as List<String>,
      weekdayText: null == weekdayText
          ? _value.weekdayText
          : weekdayText // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$OpeningHoursImplCopyWith<$Res>
    implements $OpeningHoursCopyWith<$Res> {
  factory _$$OpeningHoursImplCopyWith(
          _$OpeningHoursImpl value, $Res Function(_$OpeningHoursImpl) then) =
      __$$OpeningHoursImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({bool openNow, List<String> periods, List<String> weekdayText});
}

/// @nodoc
class __$$OpeningHoursImplCopyWithImpl<$Res>
    extends _$OpeningHoursCopyWithImpl<$Res, _$OpeningHoursImpl>
    implements _$$OpeningHoursImplCopyWith<$Res> {
  __$$OpeningHoursImplCopyWithImpl(
      _$OpeningHoursImpl _value, $Res Function(_$OpeningHoursImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? openNow = null,
    Object? periods = null,
    Object? weekdayText = null,
  }) {
    return _then(_$OpeningHoursImpl(
      openNow: null == openNow
          ? _value.openNow
          : openNow // ignore: cast_nullable_to_non_nullable
              as bool,
      periods: null == periods
          ? _value._periods
          : periods // ignore: cast_nullable_to_non_nullable
              as List<String>,
      weekdayText: null == weekdayText
          ? _value._weekdayText
          : weekdayText // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$OpeningHoursImpl with DiagnosticableTreeMixin implements _OpeningHours {
  const _$OpeningHoursImpl(
      {required this.openNow,
      required final List<String> periods,
      required final List<String> weekdayText})
      : _periods = periods,
        _weekdayText = weekdayText;

  factory _$OpeningHoursImpl.fromJson(Map<String, dynamic> json) =>
      _$$OpeningHoursImplFromJson(json);

  @override
  final bool openNow;
  final List<String> _periods;
  @override
  List<String> get periods {
    if (_periods is EqualUnmodifiableListView) return _periods;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_periods);
  }

  final List<String> _weekdayText;
  @override
  List<String> get weekdayText {
    if (_weekdayText is EqualUnmodifiableListView) return _weekdayText;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_weekdayText);
  }

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'OpeningHours(openNow: $openNow, periods: $periods, weekdayText: $weekdayText)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'OpeningHours'))
      ..add(DiagnosticsProperty('openNow', openNow))
      ..add(DiagnosticsProperty('periods', periods))
      ..add(DiagnosticsProperty('weekdayText', weekdayText));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OpeningHoursImpl &&
            (identical(other.openNow, openNow) || other.openNow == openNow) &&
            const DeepCollectionEquality().equals(other._periods, _periods) &&
            const DeepCollectionEquality()
                .equals(other._weekdayText, _weekdayText));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      openNow,
      const DeepCollectionEquality().hash(_periods),
      const DeepCollectionEquality().hash(_weekdayText));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$OpeningHoursImplCopyWith<_$OpeningHoursImpl> get copyWith =>
      __$$OpeningHoursImplCopyWithImpl<_$OpeningHoursImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$OpeningHoursImplToJson(
      this,
    );
  }
}

abstract class _OpeningHours implements OpeningHours {
  const factory _OpeningHours(
      {required final bool openNow,
      required final List<String> periods,
      required final List<String> weekdayText}) = _$OpeningHoursImpl;

  factory _OpeningHours.fromJson(Map<String, dynamic> json) =
      _$OpeningHoursImpl.fromJson;

  @override
  bool get openNow;
  @override
  List<String> get periods;
  @override
  List<String> get weekdayText;
  @override
  @JsonKey(ignore: true)
  _$$OpeningHoursImplCopyWith<_$OpeningHoursImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

PlacePhotoData _$PlacePhotoDataFromJson(Map<String, dynamic> json) {
  return _PlacePhotoData.fromJson(json);
}

/// @nodoc
mixin _$PlacePhotoData {
  int get height => throw _privateConstructorUsedError;
  List<String> get htmlAttributions => throw _privateConstructorUsedError;
  String get photoReference => throw _privateConstructorUsedError;
  int get width => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $PlacePhotoDataCopyWith<PlacePhotoData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PlacePhotoDataCopyWith<$Res> {
  factory $PlacePhotoDataCopyWith(
          PlacePhotoData value, $Res Function(PlacePhotoData) then) =
      _$PlacePhotoDataCopyWithImpl<$Res, PlacePhotoData>;
  @useResult
  $Res call(
      {int height,
      List<String> htmlAttributions,
      String photoReference,
      int width});
}

/// @nodoc
class _$PlacePhotoDataCopyWithImpl<$Res, $Val extends PlacePhotoData>
    implements $PlacePhotoDataCopyWith<$Res> {
  _$PlacePhotoDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? height = null,
    Object? htmlAttributions = null,
    Object? photoReference = null,
    Object? width = null,
  }) {
    return _then(_value.copyWith(
      height: null == height
          ? _value.height
          : height // ignore: cast_nullable_to_non_nullable
              as int,
      htmlAttributions: null == htmlAttributions
          ? _value.htmlAttributions
          : htmlAttributions // ignore: cast_nullable_to_non_nullable
              as List<String>,
      photoReference: null == photoReference
          ? _value.photoReference
          : photoReference // ignore: cast_nullable_to_non_nullable
              as String,
      width: null == width
          ? _value.width
          : width // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PlacePhotoDataImplCopyWith<$Res>
    implements $PlacePhotoDataCopyWith<$Res> {
  factory _$$PlacePhotoDataImplCopyWith(_$PlacePhotoDataImpl value,
          $Res Function(_$PlacePhotoDataImpl) then) =
      __$$PlacePhotoDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int height,
      List<String> htmlAttributions,
      String photoReference,
      int width});
}

/// @nodoc
class __$$PlacePhotoDataImplCopyWithImpl<$Res>
    extends _$PlacePhotoDataCopyWithImpl<$Res, _$PlacePhotoDataImpl>
    implements _$$PlacePhotoDataImplCopyWith<$Res> {
  __$$PlacePhotoDataImplCopyWithImpl(
      _$PlacePhotoDataImpl _value, $Res Function(_$PlacePhotoDataImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? height = null,
    Object? htmlAttributions = null,
    Object? photoReference = null,
    Object? width = null,
  }) {
    return _then(_$PlacePhotoDataImpl(
      height: null == height
          ? _value.height
          : height // ignore: cast_nullable_to_non_nullable
              as int,
      htmlAttributions: null == htmlAttributions
          ? _value._htmlAttributions
          : htmlAttributions // ignore: cast_nullable_to_non_nullable
              as List<String>,
      photoReference: null == photoReference
          ? _value.photoReference
          : photoReference // ignore: cast_nullable_to_non_nullable
              as String,
      width: null == width
          ? _value.width
          : width // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PlacePhotoDataImpl
    with DiagnosticableTreeMixin
    implements _PlacePhotoData {
  const _$PlacePhotoDataImpl(
      {required this.height,
      required final List<String> htmlAttributions,
      required this.photoReference,
      required this.width})
      : _htmlAttributions = htmlAttributions;

  factory _$PlacePhotoDataImpl.fromJson(Map<String, dynamic> json) =>
      _$$PlacePhotoDataImplFromJson(json);

  @override
  final int height;
  final List<String> _htmlAttributions;
  @override
  List<String> get htmlAttributions {
    if (_htmlAttributions is EqualUnmodifiableListView)
      return _htmlAttributions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_htmlAttributions);
  }

  @override
  final String photoReference;
  @override
  final int width;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'PlacePhotoData(height: $height, htmlAttributions: $htmlAttributions, photoReference: $photoReference, width: $width)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'PlacePhotoData'))
      ..add(DiagnosticsProperty('height', height))
      ..add(DiagnosticsProperty('htmlAttributions', htmlAttributions))
      ..add(DiagnosticsProperty('photoReference', photoReference))
      ..add(DiagnosticsProperty('width', width));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PlacePhotoDataImpl &&
            (identical(other.height, height) || other.height == height) &&
            const DeepCollectionEquality()
                .equals(other._htmlAttributions, _htmlAttributions) &&
            (identical(other.photoReference, photoReference) ||
                other.photoReference == photoReference) &&
            (identical(other.width, width) || other.width == width));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      height,
      const DeepCollectionEquality().hash(_htmlAttributions),
      photoReference,
      width);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$PlacePhotoDataImplCopyWith<_$PlacePhotoDataImpl> get copyWith =>
      __$$PlacePhotoDataImplCopyWithImpl<_$PlacePhotoDataImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PlacePhotoDataImplToJson(
      this,
    );
  }
}

abstract class _PlacePhotoData implements PlacePhotoData {
  const factory _PlacePhotoData(
      {required final int height,
      required final List<String> htmlAttributions,
      required final String photoReference,
      required final int width}) = _$PlacePhotoDataImpl;

  factory _PlacePhotoData.fromJson(Map<String, dynamic> json) =
      _$PlacePhotoDataImpl.fromJson;

  @override
  int get height;
  @override
  List<String> get htmlAttributions;
  @override
  String get photoReference;
  @override
  int get width;
  @override
  @JsonKey(ignore: true)
  _$$PlacePhotoDataImplCopyWith<_$PlacePhotoDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

PlaceReview _$PlaceReviewFromJson(Map<String, dynamic> json) {
  return _PlaceReview.fromJson(json);
}

/// @nodoc
mixin _$PlaceReview {
  String get authorName => throw _privateConstructorUsedError;
  String get authorUrl => throw _privateConstructorUsedError;
  String get language => throw _privateConstructorUsedError;
  String get originalLanguage => throw _privateConstructorUsedError;
  String get profilePhotoUrl => throw _privateConstructorUsedError;
  int get rating => throw _privateConstructorUsedError;
  String get relativeTimeDescription => throw _privateConstructorUsedError;
  String get text => throw _privateConstructorUsedError;
  int get time => throw _privateConstructorUsedError;
  String get translated => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $PlaceReviewCopyWith<PlaceReview> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PlaceReviewCopyWith<$Res> {
  factory $PlaceReviewCopyWith(
          PlaceReview value, $Res Function(PlaceReview) then) =
      _$PlaceReviewCopyWithImpl<$Res, PlaceReview>;
  @useResult
  $Res call(
      {String authorName,
      String authorUrl,
      String language,
      String originalLanguage,
      String profilePhotoUrl,
      int rating,
      String relativeTimeDescription,
      String text,
      int time,
      String translated});
}

/// @nodoc
class _$PlaceReviewCopyWithImpl<$Res, $Val extends PlaceReview>
    implements $PlaceReviewCopyWith<$Res> {
  _$PlaceReviewCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? authorName = null,
    Object? authorUrl = null,
    Object? language = null,
    Object? originalLanguage = null,
    Object? profilePhotoUrl = null,
    Object? rating = null,
    Object? relativeTimeDescription = null,
    Object? text = null,
    Object? time = null,
    Object? translated = null,
  }) {
    return _then(_value.copyWith(
      authorName: null == authorName
          ? _value.authorName
          : authorName // ignore: cast_nullable_to_non_nullable
              as String,
      authorUrl: null == authorUrl
          ? _value.authorUrl
          : authorUrl // ignore: cast_nullable_to_non_nullable
              as String,
      language: null == language
          ? _value.language
          : language // ignore: cast_nullable_to_non_nullable
              as String,
      originalLanguage: null == originalLanguage
          ? _value.originalLanguage
          : originalLanguage // ignore: cast_nullable_to_non_nullable
              as String,
      profilePhotoUrl: null == profilePhotoUrl
          ? _value.profilePhotoUrl
          : profilePhotoUrl // ignore: cast_nullable_to_non_nullable
              as String,
      rating: null == rating
          ? _value.rating
          : rating // ignore: cast_nullable_to_non_nullable
              as int,
      relativeTimeDescription: null == relativeTimeDescription
          ? _value.relativeTimeDescription
          : relativeTimeDescription // ignore: cast_nullable_to_non_nullable
              as String,
      text: null == text
          ? _value.text
          : text // ignore: cast_nullable_to_non_nullable
              as String,
      time: null == time
          ? _value.time
          : time // ignore: cast_nullable_to_non_nullable
              as int,
      translated: null == translated
          ? _value.translated
          : translated // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PlaceReviewImplCopyWith<$Res>
    implements $PlaceReviewCopyWith<$Res> {
  factory _$$PlaceReviewImplCopyWith(
          _$PlaceReviewImpl value, $Res Function(_$PlaceReviewImpl) then) =
      __$$PlaceReviewImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String authorName,
      String authorUrl,
      String language,
      String originalLanguage,
      String profilePhotoUrl,
      int rating,
      String relativeTimeDescription,
      String text,
      int time,
      String translated});
}

/// @nodoc
class __$$PlaceReviewImplCopyWithImpl<$Res>
    extends _$PlaceReviewCopyWithImpl<$Res, _$PlaceReviewImpl>
    implements _$$PlaceReviewImplCopyWith<$Res> {
  __$$PlaceReviewImplCopyWithImpl(
      _$PlaceReviewImpl _value, $Res Function(_$PlaceReviewImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? authorName = null,
    Object? authorUrl = null,
    Object? language = null,
    Object? originalLanguage = null,
    Object? profilePhotoUrl = null,
    Object? rating = null,
    Object? relativeTimeDescription = null,
    Object? text = null,
    Object? time = null,
    Object? translated = null,
  }) {
    return _then(_$PlaceReviewImpl(
      authorName: null == authorName
          ? _value.authorName
          : authorName // ignore: cast_nullable_to_non_nullable
              as String,
      authorUrl: null == authorUrl
          ? _value.authorUrl
          : authorUrl // ignore: cast_nullable_to_non_nullable
              as String,
      language: null == language
          ? _value.language
          : language // ignore: cast_nullable_to_non_nullable
              as String,
      originalLanguage: null == originalLanguage
          ? _value.originalLanguage
          : originalLanguage // ignore: cast_nullable_to_non_nullable
              as String,
      profilePhotoUrl: null == profilePhotoUrl
          ? _value.profilePhotoUrl
          : profilePhotoUrl // ignore: cast_nullable_to_non_nullable
              as String,
      rating: null == rating
          ? _value.rating
          : rating // ignore: cast_nullable_to_non_nullable
              as int,
      relativeTimeDescription: null == relativeTimeDescription
          ? _value.relativeTimeDescription
          : relativeTimeDescription // ignore: cast_nullable_to_non_nullable
              as String,
      text: null == text
          ? _value.text
          : text // ignore: cast_nullable_to_non_nullable
              as String,
      time: null == time
          ? _value.time
          : time // ignore: cast_nullable_to_non_nullable
              as int,
      translated: null == translated
          ? _value.translated
          : translated // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PlaceReviewImpl with DiagnosticableTreeMixin implements _PlaceReview {
  const _$PlaceReviewImpl(
      {required this.authorName,
      required this.authorUrl,
      required this.language,
      required this.originalLanguage,
      required this.profilePhotoUrl,
      required this.rating,
      required this.relativeTimeDescription,
      required this.text,
      required this.time,
      required this.translated});

  factory _$PlaceReviewImpl.fromJson(Map<String, dynamic> json) =>
      _$$PlaceReviewImplFromJson(json);

  @override
  final String authorName;
  @override
  final String authorUrl;
  @override
  final String language;
  @override
  final String originalLanguage;
  @override
  final String profilePhotoUrl;
  @override
  final int rating;
  @override
  final String relativeTimeDescription;
  @override
  final String text;
  @override
  final int time;
  @override
  final String translated;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'PlaceReview(authorName: $authorName, authorUrl: $authorUrl, language: $language, originalLanguage: $originalLanguage, profilePhotoUrl: $profilePhotoUrl, rating: $rating, relativeTimeDescription: $relativeTimeDescription, text: $text, time: $time, translated: $translated)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'PlaceReview'))
      ..add(DiagnosticsProperty('authorName', authorName))
      ..add(DiagnosticsProperty('authorUrl', authorUrl))
      ..add(DiagnosticsProperty('language', language))
      ..add(DiagnosticsProperty('originalLanguage', originalLanguage))
      ..add(DiagnosticsProperty('profilePhotoUrl', profilePhotoUrl))
      ..add(DiagnosticsProperty('rating', rating))
      ..add(DiagnosticsProperty(
          'relativeTimeDescription', relativeTimeDescription))
      ..add(DiagnosticsProperty('text', text))
      ..add(DiagnosticsProperty('time', time))
      ..add(DiagnosticsProperty('translated', translated));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PlaceReviewImpl &&
            (identical(other.authorName, authorName) ||
                other.authorName == authorName) &&
            (identical(other.authorUrl, authorUrl) ||
                other.authorUrl == authorUrl) &&
            (identical(other.language, language) ||
                other.language == language) &&
            (identical(other.originalLanguage, originalLanguage) ||
                other.originalLanguage == originalLanguage) &&
            (identical(other.profilePhotoUrl, profilePhotoUrl) ||
                other.profilePhotoUrl == profilePhotoUrl) &&
            (identical(other.rating, rating) || other.rating == rating) &&
            (identical(
                    other.relativeTimeDescription, relativeTimeDescription) ||
                other.relativeTimeDescription == relativeTimeDescription) &&
            (identical(other.text, text) || other.text == text) &&
            (identical(other.time, time) || other.time == time) &&
            (identical(other.translated, translated) ||
                other.translated == translated));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      authorName,
      authorUrl,
      language,
      originalLanguage,
      profilePhotoUrl,
      rating,
      relativeTimeDescription,
      text,
      time,
      translated);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$PlaceReviewImplCopyWith<_$PlaceReviewImpl> get copyWith =>
      __$$PlaceReviewImplCopyWithImpl<_$PlaceReviewImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PlaceReviewImplToJson(
      this,
    );
  }
}

abstract class _PlaceReview implements PlaceReview {
  const factory _PlaceReview(
      {required final String authorName,
      required final String authorUrl,
      required final String language,
      required final String originalLanguage,
      required final String profilePhotoUrl,
      required final int rating,
      required final String relativeTimeDescription,
      required final String text,
      required final int time,
      required final String translated}) = _$PlaceReviewImpl;

  factory _PlaceReview.fromJson(Map<String, dynamic> json) =
      _$PlaceReviewImpl.fromJson;

  @override
  String get authorName;
  @override
  String get authorUrl;
  @override
  String get language;
  @override
  String get originalLanguage;
  @override
  String get profilePhotoUrl;
  @override
  int get rating;
  @override
  String get relativeTimeDescription;
  @override
  String get text;
  @override
  int get time;
  @override
  String get translated;
  @override
  @JsonKey(ignore: true)
  _$$PlaceReviewImplCopyWith<_$PlaceReviewImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$PlacePhoto {
  String get photoReference => throw _privateConstructorUsedError;
  int get width => throw _privateConstructorUsedError;
  int get height => throw _privateConstructorUsedError;
  List<String> get htmlAttributions => throw _privateConstructorUsedError;
  String get url => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $PlacePhotoCopyWith<PlacePhoto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PlacePhotoCopyWith<$Res> {
  factory $PlacePhotoCopyWith(
          PlacePhoto value, $Res Function(PlacePhoto) then) =
      _$PlacePhotoCopyWithImpl<$Res, PlacePhoto>;
  @useResult
  $Res call(
      {String photoReference,
      int width,
      int height,
      List<String> htmlAttributions,
      String url});
}

/// @nodoc
class _$PlacePhotoCopyWithImpl<$Res, $Val extends PlacePhoto>
    implements $PlacePhotoCopyWith<$Res> {
  _$PlacePhotoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? photoReference = null,
    Object? width = null,
    Object? height = null,
    Object? htmlAttributions = null,
    Object? url = null,
  }) {
    return _then(_value.copyWith(
      photoReference: null == photoReference
          ? _value.photoReference
          : photoReference // ignore: cast_nullable_to_non_nullable
              as String,
      width: null == width
          ? _value.width
          : width // ignore: cast_nullable_to_non_nullable
              as int,
      height: null == height
          ? _value.height
          : height // ignore: cast_nullable_to_non_nullable
              as int,
      htmlAttributions: null == htmlAttributions
          ? _value.htmlAttributions
          : htmlAttributions // ignore: cast_nullable_to_non_nullable
              as List<String>,
      url: null == url
          ? _value.url
          : url // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PlacePhotoImplCopyWith<$Res>
    implements $PlacePhotoCopyWith<$Res> {
  factory _$$PlacePhotoImplCopyWith(
          _$PlacePhotoImpl value, $Res Function(_$PlacePhotoImpl) then) =
      __$$PlacePhotoImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String photoReference,
      int width,
      int height,
      List<String> htmlAttributions,
      String url});
}

/// @nodoc
class __$$PlacePhotoImplCopyWithImpl<$Res>
    extends _$PlacePhotoCopyWithImpl<$Res, _$PlacePhotoImpl>
    implements _$$PlacePhotoImplCopyWith<$Res> {
  __$$PlacePhotoImplCopyWithImpl(
      _$PlacePhotoImpl _value, $Res Function(_$PlacePhotoImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? photoReference = null,
    Object? width = null,
    Object? height = null,
    Object? htmlAttributions = null,
    Object? url = null,
  }) {
    return _then(_$PlacePhotoImpl(
      photoReference: null == photoReference
          ? _value.photoReference
          : photoReference // ignore: cast_nullable_to_non_nullable
              as String,
      width: null == width
          ? _value.width
          : width // ignore: cast_nullable_to_non_nullable
              as int,
      height: null == height
          ? _value.height
          : height // ignore: cast_nullable_to_non_nullable
              as int,
      htmlAttributions: null == htmlAttributions
          ? _value._htmlAttributions
          : htmlAttributions // ignore: cast_nullable_to_non_nullable
              as List<String>,
      url: null == url
          ? _value.url
          : url // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$PlacePhotoImpl with DiagnosticableTreeMixin implements _PlacePhoto {
  const _$PlacePhotoImpl(
      {required this.photoReference,
      required this.width,
      required this.height,
      required final List<String> htmlAttributions,
      required this.url})
      : _htmlAttributions = htmlAttributions;

  @override
  final String photoReference;
  @override
  final int width;
  @override
  final int height;
  final List<String> _htmlAttributions;
  @override
  List<String> get htmlAttributions {
    if (_htmlAttributions is EqualUnmodifiableListView)
      return _htmlAttributions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_htmlAttributions);
  }

  @override
  final String url;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'PlacePhoto(photoReference: $photoReference, width: $width, height: $height, htmlAttributions: $htmlAttributions, url: $url)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'PlacePhoto'))
      ..add(DiagnosticsProperty('photoReference', photoReference))
      ..add(DiagnosticsProperty('width', width))
      ..add(DiagnosticsProperty('height', height))
      ..add(DiagnosticsProperty('htmlAttributions', htmlAttributions))
      ..add(DiagnosticsProperty('url', url));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PlacePhotoImpl &&
            (identical(other.photoReference, photoReference) ||
                other.photoReference == photoReference) &&
            (identical(other.width, width) || other.width == width) &&
            (identical(other.height, height) || other.height == height) &&
            const DeepCollectionEquality()
                .equals(other._htmlAttributions, _htmlAttributions) &&
            (identical(other.url, url) || other.url == url));
  }

  @override
  int get hashCode => Object.hash(runtimeType, photoReference, width, height,
      const DeepCollectionEquality().hash(_htmlAttributions), url);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$PlacePhotoImplCopyWith<_$PlacePhotoImpl> get copyWith =>
      __$$PlacePhotoImplCopyWithImpl<_$PlacePhotoImpl>(this, _$identity);
}

abstract class _PlacePhoto implements PlacePhoto {
  const factory _PlacePhoto(
      {required final String photoReference,
      required final int width,
      required final int height,
      required final List<String> htmlAttributions,
      required final String url}) = _$PlacePhotoImpl;

  @override
  String get photoReference;
  @override
  int get width;
  @override
  int get height;
  @override
  List<String> get htmlAttributions;
  @override
  String get url;
  @override
  @JsonKey(ignore: true)
  _$$PlacePhotoImplCopyWith<_$PlacePhotoImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
