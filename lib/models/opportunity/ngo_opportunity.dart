import 'package:freezed_annotation/freezed_annotation.dart';

part 'ngo_opportunity.freezed.dart';
part 'ngo_opportunity.g.dart';

@freezed
abstract class NGOOpportunity with _$NGOOpportunity {
  const factory NGOOpportunity({
    required String id,
    required String name,
    required String description,
    required String address,
    required String city,
    required String state,
    required String pincode,
    required String phone,
    required String email,
    required String website,
    required double? latitude,
    required double? longitude,
    required List<String> sectors,
    required List<String> activities,
    required List<String> targetGroups,
    required bool hasVolunteerOpportunities,
    required bool hasInternshipOpportunities,
    required bool hasFellowshipOpportunities,
    required String? registrationNumber,
    required String? registrationDate,
    required String? fcrNumber,
    required String? panNumber,
    required String? gstNumber,
    required int? establishedYear,
    required String? annualBudget,
    required List<String>? keyProjects,
    required Map<String, dynamic>? contactPersons,
    required double? distanceKm,
    required DateTime? cachedAt,
    required String? source,
  }) = _NGOOpportunity;

  factory NGOOpportunity.fromJson(Map<String, dynamic> json) => _$NGOOpportunityFromJson(json);
}

@freezed
abstract class NGOContactPerson with _$NGOContactPerson {
  const factory NGOContactPerson({
    required String name,
    required String designation,
    required String phone,
    required String email,
    required bool isPrimary,
  }) = _NGOContactPerson;

  factory NGOContactPerson.fromJson(Map<String, dynamic> json) => _$NGOContactPersonFromJson(json);
}

extension NGOOpportunityExtension on NGOOpportunity {
  String get formattedAddress => '$address, $city, $state - $pincode';
  
  String get shortDescription => description.length > 150 
      ? '${description.substring(0, 150)}...' 
      : description;
  
  String get primarySector => sectors.isNotEmpty ? sectors.first : 'General';
  
  bool get isLocal => (distanceKm ?? 0) <= 10;
  
  bool get isNearby => (distanceKm ?? 0) <= 25;
  
  String get distanceDisplay {
    if (distanceKm == null) return 'Distance unknown';
    if (distanceKm! < 1) return '${(distanceKm! * 1000).round()}m away';
    return '${distanceKm!.toStringAsFixed(1)} km away';
  }
  
  List<String> get matchingSectors {
    return sectors.where((s) => 
      ['Education', 'Youth Affairs', 'Child Welfare', 'Science & Technology'].contains(s)
    ).toList();
  }
  
  int get relevanceScore {
    int score = 0;
    if (hasVolunteerOpportunities) score += 30;
    if (hasInternshipOpportunities) score += 25;
    if (hasFellowshipOpportunities) score += 20;
    if (matchingSectors.isNotEmpty) score += matchingSectors.length * 10;
    if (distanceKm != null && distanceKm! <= 5) score += 15;
    else if (distanceKm != null && distanceKm! <= 15) score += 10;
    else if (distanceKm != null && distanceKm! <= 25) score += 5;
    return score;
  }
}