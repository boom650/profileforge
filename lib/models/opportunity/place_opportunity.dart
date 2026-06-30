import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart' as latlong;
import 'dart:math';

import 'package:freezed_annotation/freezed_annotation.dart';

part 'place_opportunity.freezed.dart';
part 'place_opportunity.g.dart';

/// Place opportunity from Google Places API
@freezed
abstract class PlaceOpportunity with _$PlaceOpportunity {
  const factory PlaceOpportunity({
    required String placeId,
    required String name,
    required String formattedAddress,
    required double latitude,
    required double longitude,
    required List<String> types,
    required double? rating,
    required int? userRatingsTotal,
    required int? priceLevel,
    required String? website,
    required String? formattedPhoneNumber,
    required String? vicinity,
    required String? businessStatus,
    required double? distanceKm,
    required Map<String, dynamic>? rawData,
    required DateTime? cachedAt,
    required String? source,
    required List<String>? keywords,
    required OpportunityCategory? category,
    required int? relevanceScore,
    required bool? isOpenNow,
    required String? openingHoursText,
  }) = _PlaceOpportunity;

  factory PlaceOpportunity.fromJson(Map<String, dynamic> json) => _$PlaceOpportunityFromJson(json);
}

extension PlaceOpportunityFactory on PlaceOpportunity {
  static PlaceOpportunity fromGooglePlacesJson(
    Map<String, dynamic> json,
    latlong.LatLng searchCenter,
  ) {
    final geometry = json['geometry'] as Map<String, dynamic>? ?? {};
    final location = geometry['location'] as Map<String, dynamic>? ?? {};
    final lat = (location['lat'] as num?)?.toDouble() ?? 0.0;
    final lng = (location['lng'] as num?)?.toDouble() ?? 0.0;
    
    final distanceKm = _calculateDistance(searchCenter, lat, lng);
    
    return PlaceOpportunity(
      placeId: json['place_id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      formattedAddress: json['formatted_address'] as String? ?? json['vicinity'] as String? ?? '',
      latitude: lat,
      longitude: lng,
      types: (json['types'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
      rating: (json['rating'] as num?)?.toDouble(),
      userRatingsTotal: json['user_ratings_total'] as int?,
      priceLevel: json['price_level'] as int?,
      website: json['website'] as String?,
      formattedPhoneNumber: json['formatted_phone_number'] as String?,
      vicinity: json['vicinity'] as String?,
      businessStatus: json['business_status'] as String?,
      distanceKm: distanceKm,
      rawData: json,
      cachedAt: DateTime.now(),
      source: 'google_places',
      category: _categorizeFromTypes(json['types'] as List<dynamic>? ?? []),
      relevanceScore: _calculateRelevance(json, distanceKm),
      isOpenNow: json['opening_hours'] != null 
          ? (json['opening_hours'] as Map)['open_now'] as bool? 
          : null,
      openingHoursText: null,
      keywords: null,
    );
  }
  
  static double _calculateDistance(latlong.LatLng center, double lat, double lng) {
    const double earthRadius = 6371.0;
    final dLat = _toRadians(lat - center.latitude);
    final dLng = _toRadians(lng - center.longitude);
    final a = (sin(dLat / 2) * sin(dLat / 2)) +
        cos(_toRadians(center.latitude)) * cos(_toRadians(lat)) *
        (sin(dLng / 2) * sin(dLng / 2));
    final c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return earthRadius * c;
  }
  
  static double _toRadians(double deg) => deg * (3.141592653589793 / 180.0);
  
  static OpportunityCategory? _categorizeFromTypes(List<dynamic> types) {
    final typeSet = types.map((e) => e.toString()).toSet();
    
    if (typeSet.contains('school') || typeSet.contains('university') || 
        typeSet.contains('primary_school') || typeSet.contains('secondary_school')) {
      return OpportunityCategory.education;
    }
    if (typeSet.contains('library') || typeSet.contains('museum') || 
        typeSet.contains('science_center') || typeSet.contains('technology_center')) {
      return OpportunityCategory.learning;
    }
    if (typeSet.contains('non_profit') || typeSet.contains('ngo') || 
        typeSet.contains('volunteer_organization') || typeSet.contains('social_service') ||
        typeSet.contains('charity')) {
      return OpportunityCategory.volunteering;
    }
    if (typeSet.contains('training') || typeSet.contains('bootcamp') || 
        typeSet.contains('coding_bootcamp') || typeSet.contains('skill_training')) {
      return OpportunityCategory.skill_building;
    }
    if (typeSet.contains('internship') || typeSet.contains('apprenticeship') || 
        typeSet.contains('career') || typeSet.contains('job_training')) {
      return OpportunityCategory.internship;
    }
    if (typeSet.contains('competition') || typeSet.contains('contest') || 
        typeSet.contains('hackathon') || typeSet.contains('olympiad')) {
      return OpportunityCategory.competition;
    }
    if (typeSet.contains('mentor') || typeSet.contains('coaching') || 
        typeSet.contains('tutoring')) {
      return OpportunityCategory.mentorship;
    }
    
    return OpportunityCategory.other;
  }
  
  static int _calculateRelevance(Map<String, dynamic> json, double distanceKm) {
    int score = 0;
    
    // Distance factor (closer is better)
    if (distanceKm < 5) score += 30;
    else if (distanceKm < 10) score += 20;
    else if (distanceKm < 25) score += 10;
    
    // Rating factor
    final rating = (json['rating'] as num?)?.toDouble() ?? 0.0;
    if (rating >= 4.5) score += 20;
    else if (rating >= 4.0) score += 15;
    else if (rating >= 3.5) score += 10;
    
    // Reviews factor
    final reviews = json['user_ratings_total'] as int? ?? 0;
    if (reviews > 100) score += 10;
    else if (reviews > 20) score += 5;
    
    // Business status
    if (json['business_status'] == 'OPERATIONAL') score += 10;
    
    // Type relevance
    final types = (json['types'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [];
    if (types.any((t) => ['school', 'university', 'library', 'museum', 'non_profit', 'ngo'].contains(t))) {
      score += 15;
    }
    
    return score;
  }
  
  IconData get categoryIcon {
    switch (category) {
      case OpportunityCategory.education: return Icons.school;
      case OpportunityCategory.learning: return Icons.menu_book;
      case OpportunityCategory.volunteering: return Icons.volunteer_activism;
      case OpportunityCategory.skill_building: return Icons.code;
      case OpportunityCategory.internship: return Icons.work;
      case OpportunityCategory.competition: return Icons.emoji_events;
      case OpportunityCategory.mentorship: return Icons.person;
      default: return Icons.place;
    }
  }
}

enum OpportunityCategory {
  education,
  learning,
  volunteering,
  skill_building,
  internship,
  competition,
  mentorship,
  other,
}