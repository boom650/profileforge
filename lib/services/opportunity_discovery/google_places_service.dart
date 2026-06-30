import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_places_flutter/google_places_flutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../models/opportunity/place_opportunity.dart';

part 'google_places_service.freezed.dart';
part 'google_places_service.g.dart';

@riverpod
GooglePlacesService googlePlacesService(GooglePlacesServiceRef ref) {
  return GooglePlacesService();
}

@freezed
abstract class GooglePlacesConfig with _$GooglePlacesConfig {
  const factory GooglePlacesConfig({
    required String apiKey,
    required double defaultRadius,
    required List<String> defaultTypes,
    required String language,
    required String region,
    required int maxResults,
    required Duration cacheDuration,
    required int maxRetries,
    required Duration requestTimeout,
  }) = _GooglePlacesConfig;

  factory GooglePlacesConfig.defaultConfig(String apiKey) => GooglePlacesConfig(
    apiKey: apiKey,
    defaultRadius: 10000.0,
    defaultTypes: [
      'school',
      'university',
      'library',
      'museum',
      'community_center',
      'non_profit',
      'ngo',
      'organization',
      'training',
      'career_counseling',
      'tutoring',
      'after_school_program',
      'summer_camp',
      'volunteer_organization',
      'social_service',
      'youth_organization',
      'science_center',
      'technology_center',
      'innovation_center',
      'maker_space',
      'coworking_space',
      'incubator',
      'accelerator',
      'research_institute',
      'laboratory',
      'observatory',
      'planetarium',
      'aquarium',
      'zoo',
      'botanical_garden',
      'nature_center',
      'environmental_center',
      'sustainability_center',
      'climate_center',
      'robotics_lab',
      'ai_lab',
      'coding_bootcamp',
      'stem_center',
      'math_center',
      'science_fair',
      'robotics_competition',
      'hackathon_venue',
      'innovation_hub',
      'entrepreneurship_center',
      'startup_incubator',
      'social_enterprise',
      'impact_hub',
      'community_college',
      'vocational_school',
      'technical_institute',
      'polytechnic',
      'engineering_college',
      'medical_college',
      'dental_college',
      'nursing_college',
      'pharmacy_college',
      'architecture_college',
      'design_school',
      'art_school',
      'music_school',
      'dance_school',
      'theater_school',
      'film_school',
      'journalism_school',
      'law_school',
      'business_school',
      'management_institute',
      'hotel_management',
      'culinary_school',
      'fashion_institute',
      'media_institute',
      'communication_institute',
      'psychology_institute',
      'social_work_institute',
      'education_college',
      'teacher_training',
      'special_education',
      'early_childhood',
      'primary_school',
      'secondary_school',
      'high_school',
      'senior_secondary',
      'junior_college',
      'pre_university',
    ],
    language: 'en',
    region: 'IN',
    maxResults: 60,
    cacheDuration: const Duration(hours: 6),
    maxRetries: 3,
    requestTimeout: const Duration(seconds: 30),
  );
}

@freezed
abstract class PlaceSearchParams with _$PlaceSearchParams {
  const factory PlaceSearchParams({
    required LatLng location,
    required double radius,
    required List<String> types,
    String? keyword,
    String? language,
    String? region,
    int? minPrice,
    int? maxPrice,
    bool? openNow,
    String? pageToken,
    int maxResults,
  }) = _PlaceSearchParams;
}

@freezed
abstract class NearbySearchResult with _$NearbySearchResult {
  const factory NearbySearchResult({
    required List<PlaceOpportunity> places,
    required String? nextPageToken,
    required String status,
    required String? errorMessage,
    required DateTime timestamp,
    required LatLng searchCenter,
    required double searchRadius,
    required List<String> searchTypes,
  }) = _NearbySearchResult;
}

class GooglePlacesService {
  static const String _baseUrl = 'https://maps.googleapis.com/maps/api/place';
  
  GooglePlacesConfig? _config;
  Map<String, NearbySearchResult> _cache = {};
  DateTime? _cacheExpiry;
  
  GooglePlacesConfig get config => _config ?? GooglePlacesConfig.defaultConfig('');
  
  void initialize({required String apiKey, GooglePlacesConfig? config}) {
    _config = config ?? GooglePlacesConfig.defaultConfig(apiKey);
    _cache.clear();
    _cacheExpiry = DateTime.now().add(_config!.cacheDuration);
  }
  
  Future<NearbySearchResult> searchNearbyPlaces({
    required LatLng location,
    double? radius,
    List<String>? types,
    String? keyword,
    String? pageToken,
    bool forceRefresh = false,
  }) async {
    if (_config == null) {
      throw Exception('GooglePlacesService not initialized. Call initialize() first.');
    }
    
    final params = PlaceSearchParams(
      location: location,
      radius: radius ?? _config!.defaultRadius,
      types: types ?? _config!.defaultTypes,
      keyword: keyword,
      language: _config!.language,
      region: _config!.region,
      pageToken: pageToken,
      maxResults: _config!.maxResults,
    );
    
    final cacheKey = _buildCacheKey(params);
    
    if (!forceRefresh && _isCacheValid(cacheKey)) {
      return _cache[cacheKey]!;
    }
    
    final result = await _performSearch(params);
    
    _cache[cacheKey] = result;
    _cacheExpiry = DateTime.now().add(_config!.cacheDuration);
    
    return result;
  }
  
  Future<NearbySearchResult> searchEducationalOpportunities({
    required LatLng location,
    double radius = 15000,
    String? keyword,
  }) async {
    return searchNearbyPlaces(
      location: location,
      radius: radius,
      types: _getEducationalTypes(),
      keyword: keyword,
    );
  }
  
  Future<NearbySearchResult> searchNGOOpportunities({
    required LatLng location,
    double radius = 15000,
    String? keyword,
  }) async {
    return searchNearbyPlaces(
      location: location,
      radius: radius,
      types: _getNGOTypes(),
      keyword: keyword,
    );
  }
  
  Future<NearbySearchResult> searchATLLabs({
    required LatLng location,
    double radius = 25000,
  }) async {
    return searchNearbyPlaces(
      location: location,
      radius: radius,
      types: ['school', 'university', 'technology_center', 'innovation_center', 'stem_center'],
      keyword: 'ATL lab Atal Tinkering Lab',
    );
  }
  
  Future<NearbySearchResult> searchCompetitionVenues({
    required LatLng location,
    double radius = 20000,
    String? keyword,
  }) async {
    return searchNearbyPlaces(
      location: location,
      radius: radius,
      types: _getCompetitionVenueTypes(),
      keyword: keyword ?? 'competition competition venue hackathon science fair',
    );
  }
  
  Future<NearbySearchResult> searchInternshipVenues({
    required LatLng location,
    double radius = 20000,
    String? keyword,
  }) async {
    return searchNearbyPlaces(
      location: location,
      radius: radius,
      types: _getInternshipVenueTypes(),
      keyword: keyword ?? 'internship internship company startup company office',
    );
  }
  
  Future<NearbySearchResult> searchMentorshipVenues({
    required LatLng location,
    double radius = 15000,
  }) async {
    return searchNearbyPlaces(
      location: location,
      radius: radius,
      types: _getMentorshipVenueTypes(),
      keyword: 'mentor mentorship coaching career guidance',
    );
  }
  
  Future<PlaceDetails> getPlaceDetails(String placeId) async {
    if (_config == null) {
      throw Exception('GooglePlacesService not initialized');
    }
    
    final cacheKey = 'details_$placeId';
    
    if (_isCacheValid(cacheKey)) {
      final cached = _cache[cacheKey] as PlaceDetails?;
      if (cached != null) return cached;
    }
    
    final uri = Uri.parse('$_baseUrl/details/json').replace(queryParameters: {
      'place_id': placeId,
      'fields': 'place_id,name,formatted_address,geometry,rating,'
          'user_ratings_total,price_level,types,website,formatted_phone_number,'
          'opening_hours,photos,reviews,business_status,url,vicinity,'
          'wheelchair_accessible_entrance,current_opening_hours,secondary_opening_hours,'
          'editorial_summary,adr_address,formatted_address,geometry,icon,'
          'name,permanently_closed,photos,place_id,plus_code,price_level,'
          'rating,reference,scope,types,url,user_ratings_total,utc_offset,vicinity',
      'language': _config!.language,
      'key': _config!.apiKey,
    });
    
    final response = await _makeRequest(uri);
    
    if (response['status'] == 'OK') {
      final details = PlaceDetails.fromJson(response['result'] as Map<String, dynamic>);
      _cache[cacheKey] = details as dynamic;
      return details;
    }
    
    throw Exception('Place details error: ${response['status']} - ${response['error_message']}');
  }
  
  Future<List<PlacePhoto>> getPlacePhotos(String placeId, {int maxPhotos = 5}) async {
    final details = await getPlaceDetails(placeId);
    final photos = details.photos ?? [];
    
    return photos.take(maxPhotos).map((photo) => PlacePhoto(
      photoReference: photo.photoReference,
      width: photo.width,
      height: photo.height,
      htmlAttributions: photo.htmlAttributions,
      url: _buildPhotoUrl(photo.photoReference, maxWidth: 800),
    )).toList();
  }
  
  Future<NearbySearchResult> getNextPage(String pageToken, LatLng location, double radius) async {
    return searchNearbyPlaces(
      location: location,
      radius: radius,
      pageToken: pageToken,
    );
  }
  
  Future<NearbySearchResult> _performSearch(PlaceSearchParams params) async {
    final uri = Uri.parse('$_baseUrl/nearbysearch/json').replace(queryParameters: {
      'location': '${params.location.latitude},${params.location.longitude}',
      'radius': params.radius.round().toString(),
      'type': params.types.first,
      'keyword': params.keyword ?? '',
      'language': params.language ?? _config!.language,
      'region': params.region ?? _config!.region,
      'key': _config!.apiKey,
    });
    
    int attempt = 0;
    Exception? lastError;
    
    while (attempt < _config!.maxRetries) {
      try {
        final response = await _makeRequest(uri);
        
        if (response['status'] == 'OK') {
          return _parseSearchResponse(response, params);
        } else if (response['status'] == 'ZERO_RESULTS') {
          return NearbySearchResult(
            places: [],
            nextPageToken: null,
            status: 'ZERO_RESULTS',
            errorMessage: null,
            timestamp: DateTime.now(),
            searchCenter: params.location,
            searchRadius: params.radius,
            searchTypes: params.types,
          );
        } else if (response['status'] == 'OVER_QUERY_LIMIT') {
          attempt++;
          if (attempt < _config!.maxRetries) {
            await Future.delayed(Duration(seconds: 2 * attempt));
            continue;
          }
        }
        
        throw Exception('Places API error: ${response['status']} - ${response['error_message']}');
      } catch (e) {
        lastError = e is Exception ? e : Exception(e.toString());
        attempt++;
        if (attempt < _config!.maxRetries) {
          await Future.delayed(Duration(seconds: attempt * 2));
        }
      }
    }
    
    throw lastError ?? Exception('Max retries exceeded');
  }
  
  Future<Map<String, dynamic>> _makeRequest(Uri uri) async {
    final response = await http.get(uri).timeout(_config!.requestTimeout);
    
    if (response.statusCode == 200) {
      return json.decode(response.body) as Map<String, dynamic>;
    }
    
    throw Exception('HTTP ${response.statusCode}: ${response.body}');
  }
  
  NearbySearchResult _parseSearchResponse(
    Map<String, dynamic> response,
    PlaceSearchParams params,
  ) {
    final results = response['results'] as List<dynamic>? ?? [];
    final places = <PlaceOpportunity>[];
    
    for (final result in results.take(params.maxResults)) {
      try {
        final place = PlaceOpportunity.fromGooglePlacesJson(
          result as Map<String, dynamic>,
          params.location,
        );
        places.add(place);
      } catch (e) {
        debugPrint('Error parsing place: $e');
      }
    }
    
    return NearbySearchResult(
      places: places,
      nextPageToken: response['next_page_token'] as String?,
      status: response['status'] as String,
      errorMessage: response['error_message'] as String?,
      timestamp: DateTime.now(),
      searchCenter: params.location,
      searchRadius: params.radius,
      searchTypes: params.types,
    );
  }
  
  String _buildCacheKey(PlaceSearchParams params) {
    return 'places_${params.location.latitude.toStringAsFixed(4)}_'
        '${params.location.longitude.toStringAsFixed(4)}_'
        '${params.radius.round()}_'
        '${params.types.join('_')}_'
        '${params.keyword?.hashCode ?? 'none'}_'
        '${params.pageToken ?? 'first'}';
  }
  
  bool _isCacheValid(String key) {
    if (_cacheExpiry == null || DateTime.now().isAfter(_cacheExpiry!)) {
      _cache.clear();
      _cacheExpiry = null;
      return false;
    }
    return _cache.containsKey(key);
  }
  
  String _buildPhotoUrl(String photoReference, {int maxWidth = 400}) {
    return '$_baseUrl/photo?maxwidth=$maxWidth&photo_reference=$photoReference&key=${_config!.apiKey}';
  }
  
  List<String> _getEducationalTypes() => [
    'school', 'university', 'library', 'museum', 'training',
    'career_counseling', 'tutoring', 'after_school_program',
    'summer_camp', 'science_center', 'technology_center',
    'innovation_center', 'maker_space', 'stem_center',
    'math_center', 'robotics_lab', 'ai_lab', 'coding_bootcamp',
  ];
  
  List<String> _getNGOTypes() => [
    'non_profit', 'ngo', 'organization', 'volunteer_organization',
    'social_service', 'youth_organization', 'community_center',
  ];
  
  List<String> _getATLLabTypes() => [
    'school', 'university', 'technology_center', 'innovation_center',
    'stem_center', 'robotics_lab', 'maker_space',
  ];
  
  List<String> _getCompetitionVenueTypes() => [
    'school', 'university', 'community_center', 'convention_center',
    'event_venue', 'auditorium', 'stadium', 'conference_center',
    'exhibition_center', 'science_center', 'technology_center',
  ];
  
  List<String> _getInternshipVenueTypes() => [
    'company', 'office', 'startup', 'incubator', 'accelerator',
    'coworking_space', 'innovation_hub', 'entrepreneurship_center',
    'research_institute', 'laboratory', 'technology_park',
  ];
  
  List<String> _getMentorshipVenueTypes() => [
    'career_counseling', 'coaching', 'training', 'university',
    'community_center', 'youth_organization', 'non_profit',
  ];
  
  void clearCache() {
    _cache.clear();
    _cacheExpiry = null;
  }
  
  void dispose() {
    _cache.clear();
    _cacheExpiry = null;
  }
}

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:latlong2/latlong.dart' as latlong;

@freezed
abstract class PlaceDetails with _$PlaceDetails {
  const factory PlaceDetails({
    required String placeId,
    required String name,
    required String formattedAddress,
    required LatLng geometry,
    required double? rating,
    required int? userRatingsTotal,
    required int? priceLevel,
    required List<String> types,
    required String? website,
    required String? formattedPhoneNumber,
    required OpeningHours? openingHours,
    required List<PlacePhotoData>? photos,
    required List<PlaceReview>? reviews,
    required String? businessStatus,
    required String? url,
    required String? vicinity,
    required bool? wheelchairAccessibleEntrance,
    required OpeningHours? currentOpeningHours,
    required OpeningHours? secondaryOpeningHours,
    required String? editorialSummary,
    required String? adrAddress,
  }) = _PlaceDetails;
  
  factory PlaceDetails.fromJson(Map<String, dynamic> json) => _$PlaceDetailsFromJson(json);
}

@freezed
abstract class OpeningHours with _$OpeningHours {
  const factory OpeningHours({
    required bool openNow,
    required List<String> periods,
    required List<String> weekdayText,
  }) = _OpeningHours;
  
  factory OpeningHours.fromJson(Map<String, dynamic> json) => _$OpeningHoursFromJson(json);
}

@freezed
abstract class PlacePhotoData with _$PlacePhotoData {
  const factory PlacePhotoData({
    required String photoReference,
    required int width,
    required int height,
    required List<String> htmlAttributions,
  }) = _PlacePhotoData;
  
  factory PlacePhotoData.fromJson(Map<String, dynamic> json) => _$PlacePhotoDataFromJson(json);
}

@freezed
abstract class PlaceReview with _$PlaceReview {
  const factory PlaceReview({
    required String authorName,
    required String authorUrl,
    required String language,
    required String profilePhotoUrl,
    required int rating,
    required String relativeTimeDescription,
    required String text,
    required int time,
  }) = _PlaceReview;
  
  factory PlaceReview.fromJson(Map<String, dynamic> json) => _$PlaceReviewFromJson(json);
}

@freezed
abstract class PlacePhoto with _$PlacePhoto {
  const factory PlacePhoto({
    required String photoReference,
    required int width,
    required int height,
    required List<String> htmlAttributions,
    required String url,
  }) = _PlacePhoto;
}