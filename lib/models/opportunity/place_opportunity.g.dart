// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'place_opportunity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PlaceOpportunityImpl _$$PlaceOpportunityImplFromJson(
        Map<String, dynamic> json) =>
    _$PlaceOpportunityImpl(
      placeId: json['placeId'] as String,
      name: json['name'] as String,
      formattedAddress: json['formattedAddress'] as String,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      types: (json['types'] as List<dynamic>).map((e) => e as String).toList(),
      rating: (json['rating'] as num?)?.toDouble(),
      userRatingsTotal: (json['userRatingsTotal'] as num?)?.toInt(),
      priceLevel: (json['priceLevel'] as num?)?.toInt(),
      website: json['website'] as String?,
      formattedPhoneNumber: json['formattedPhoneNumber'] as String?,
      vicinity: json['vicinity'] as String?,
      businessStatus: json['businessStatus'] as String?,
      distanceKm: (json['distanceKm'] as num?)?.toDouble(),
      rawData: json['rawData'] as Map<String, dynamic>?,
      cachedAt: json['cachedAt'] == null
          ? null
          : DateTime.parse(json['cachedAt'] as String),
      source: json['source'] as String?,
      keywords: (json['keywords'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      category:
          $enumDecodeNullable(_$OpportunityCategoryEnumMap, json['category']),
      relevanceScore: (json['relevanceScore'] as num?)?.toInt(),
      isOpenNow: json['isOpenNow'] as bool?,
      openingHoursText: json['openingHoursText'] as String?,
    );

Map<String, dynamic> _$$PlaceOpportunityImplToJson(
        _$PlaceOpportunityImpl instance) =>
    <String, dynamic>{
      'placeId': instance.placeId,
      'name': instance.name,
      'formattedAddress': instance.formattedAddress,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'types': instance.types,
      'rating': instance.rating,
      'userRatingsTotal': instance.userRatingsTotal,
      'priceLevel': instance.priceLevel,
      'website': instance.website,
      'formattedPhoneNumber': instance.formattedPhoneNumber,
      'vicinity': instance.vicinity,
      'businessStatus': instance.businessStatus,
      'distanceKm': instance.distanceKm,
      'rawData': instance.rawData,
      'cachedAt': instance.cachedAt?.toIso8601String(),
      'source': instance.source,
      'keywords': instance.keywords,
      'category': _$OpportunityCategoryEnumMap[instance.category],
      'relevanceScore': instance.relevanceScore,
      'isOpenNow': instance.isOpenNow,
      'openingHoursText': instance.openingHoursText,
    };

const _$OpportunityCategoryEnumMap = {
  OpportunityCategory.education: 'education',
  OpportunityCategory.learning: 'learning',
  OpportunityCategory.volunteering: 'volunteering',
  OpportunityCategory.skill_building: 'skill_building',
  OpportunityCategory.internship: 'internship',
  OpportunityCategory.competition: 'competition',
  OpportunityCategory.mentorship: 'mentorship',
  OpportunityCategory.other: 'other',
};
