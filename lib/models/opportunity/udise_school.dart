import 'package:freezed_annotation/freezed_annotation.dart';

part 'udise_school.freezed.dart';
part 'udise_school.g.dart';

@freezed
abstract class UDISESchool with _$UDISESchool {
  const factory UDISESchool({
    required String udiseCode,
    required String name,
    required String address,
    required String village,
    required String block,
    required String district,
    required String state,
    required String pincode,
    required double? latitude,
    required double? longitude,
    required String? phone,
    required String? email,
    required String? website,
    required SchoolCategory category,
    required SchoolManagement management,
    required SchoolType type,
    required int? lowestClass,
    required int? highestClass,
    required int? totalStudents,
    required int? boysEnrollment,
    required int? girlsEnrollment,
    required int? totalTeachers,
    required int? maleTeachers,
    required int? femaleTeachers,
    required double? pupilTeacherRatio,
    required bool hasATLLab,
    required bool hasLibrary,
    required bool hasComputerLab,
    required bool hasScienceLab,
    required bool hasPhysicsLab,
    required bool hasChemistryLab,
    required bool hasBiologyLab,
    required bool hasMathsLab,
    required bool hasLanguageLab,
    required bool hasComputerAidedLearning,
    required bool hasInternet,
    required bool hasSmartClassroom,
    required bool hasDigitalLibrary,
    required bool hasPlayground,
    required bool hasSportsFacility,
    required bool hasGymnasium,
    required bool hasAuditorium,
    required bool hasCanteen,
    required bool hasMedicalRoom,
    required bool hasDrinkingWater,
    required bool hasToiletsBoys,
    required bool hasToiletsGirls,
    required bool hasCWSNToilets,
    required bool hasRamp,
    required bool hasHandrails,
    required bool hasElevator,
    required bool hasFireExtinguisher,
    required bool hasBoundaryWall,
    required bool hasElectricity,
    required bool hasSolarPower,
    required bool hasGenerator,
    required int? classroomsTotal,
    required int? classroomsGoodCondition,
    required int? classroomsNeedMinorRepair,
    required int? classroomsNeedMajorRepair,
    required double? infrastructureScore,
    required double? academicScore,
    required String? affiliationBoard,
    required String? affiliationNumber,
    required int? establishedYear,
    required List<String>? mediumOfInstruction,
    required List<String>? subjectsOffered,
    required List<String>? streamsOffered,
    required List<String>? vocationalCourses,
    required List<String>? coCurricularActivities,
    required List<String>? specializations,
    required Map<String, dynamic>? facilitiesDetail,
    required double? distanceKm,
    required DateTime? cachedAt,
    required String? source,
  }) = _UDISESchool;

  factory UDISESchool.fromJson(Map<String, dynamic> json) => _$UDISESchoolFromJson(json);
}

enum SchoolCategory {
  @JsonValue('primary')
  primary,
  @JsonValue('upper_primary')
  upperPrimary,
  @JsonValue('secondary')
  secondary,
  @JsonValue('senior_secondary')
  seniorSecondary,
  @JsonValue('primary_with_upper_primary')
  primaryWithUpperPrimary,
  @JsonValue('upper_primary_with_secondary')
  upperPrimaryWithSecondary,
  @JsonValue('secondary_with_senior_secondary')
  secondaryWithSeniorSecondary,
  @JsonValue('primary_to_senior_secondary')
  primaryToSeniorSecondary,
}

enum SchoolManagement {
  @JsonValue('government')
  government,
  @JsonValue('government_aided')
  governmentAided,
  @JsonValue('private_unaided')
  privateUnaided,
  @JsonValue('central_government')
  centralGovernment,
  @JsonValue('state_government')
  stateGovernment,
  @JsonValue('local_body')
  localBody,
  @JsonValue('tribal_social_welfare')
  tribalSocialWelfare,
  @JsonValue('minority')
  minority,
  @JsonValue('other')
  other,
}

enum SchoolType {
  @JsonValue('co_educational')
  coEducational,
  @JsonValue('boys_only')
  boysOnly,
  @JsonValue('girls_only')
  girlsOnly,
}

extension UDISESchoolExtension on UDISESchool {
  String get formattedAddress => '$address, $village, $block, $district, $state - $pincode';
  
  String get shortName => name.length > 60 ? '${name.substring(0, 60)}...' : name;
  
  String get categoryDisplayName {
    switch (category) {
      case SchoolCategory.primary: return 'Primary (1-5)';
      case SchoolCategory.upperPrimary: return 'Upper Primary (1-8)';
      case SchoolCategory.secondary: return 'Secondary (1-10)';
      case SchoolCategory.seniorSecondary: return 'Senior Secondary (1-12)';
      case SchoolCategory.primaryWithUpperPrimary: return 'Primary + Upper Primary';
      case SchoolCategory.upperPrimaryWithSecondary: return 'Upper Primary + Secondary';
      case SchoolCategory.secondaryWithSeniorSecondary: return 'Secondary + Sr. Secondary';
      case SchoolCategory.primaryToSeniorSecondary: return 'Primary to Sr. Secondary';
    }
  }
  
  String get managementDisplayName {
    switch (management) {
      case SchoolManagement.government: return 'Government';
      case SchoolManagement.governmentAided: return 'Govt. Aided';
      case SchoolManagement.privateUnaided: return 'Private Unaided';
      case SchoolManagement.centralGovernment: return 'Central Govt.';
      case SchoolManagement.stateGovernment: return 'State Govt.';
      case SchoolManagement.localBody: return 'Local Body';
      case SchoolManagement.tribalSocialWelfare: return 'Tribal/Social Welfare';
      case SchoolManagement.minority: return 'Minority';
      case SchoolManagement.other: return 'Other';
    }
  }
  
  String get distanceDisplay {
    if (distanceKm == null) return 'Distance unknown';
    if (distanceKm! < 1) return '${(distanceKm! * 1000).round()}m away';
    return '${distanceKm!.toStringAsFixed(1)} km away';
  }
  
  bool get isLocal => (distanceKm ?? 0) <= 3;
  bool get isNearby => (distanceKm ?? 0) <= 10;
  bool get isAccessible => (distanceKm ?? 0) <= 25;
  
  bool get hasScienceStream => streamsOffered?.contains('Science') ?? false;
  bool get hasCommerceStream => streamsOffered?.contains('Commerce') ?? false;
  bool get hasArtsStream => streamsOffered?.contains('Arts') ?? false;
  bool get hasVocationalStream => streamsOffered?.contains('Vocational') ?? false;
  
  bool get hasAdvancedLabs => hasPhysicsLab && hasChemistryLab && hasBiologyLab;
  bool get hasSTEMFacilities => hasATLLab || hasComputerLab || hasScienceLab || hasMathsLab;
  bool get hasDigitalInfrastructure => hasInternet && (hasSmartClassroom || hasDigitalLibrary);
  bool get isWellEquipped => infrastructureScore != null && infrastructureScore! >= 75;
  bool get isHighPerforming => academicScore != null && academicScore! >= 80;
  
  int get facilityCount {
    int count = 0;
    if (hasLibrary) count++;
    if (hasComputerLab) count++;
    if (hasScienceLab) count++;
    if (hasPhysicsLab) count++;
    if (hasChemistryLab) count++;
    if (hasBiologyLab) count++;
    if (hasMathsLab) count++;
    if (hasLanguageLab) count++;
    if (hasComputerAidedLearning) count++;
    if (hasInternet) count++;
    if (hasSmartClassroom) count++;
    if (hasDigitalLibrary) count++;
    if (hasPlayground) count++;
    if (hasSportsFacility) count++;
    if (hasGymnasium) count++;
    if (hasAuditorium) count++;
    if (hasCanteen) count++;
    if (hasMedicalRoom) count++;
    return count;
  }
  
  int get accessibilityFeatureCount {
    int count = 0;
    if (hasRamp) count++;
    if (hasHandrails) count++;
    if (hasElevator) count++;
    if (hasCWSNToilets) count++;
    return count;
  }
  
  int get relevanceScore {
    int score = 0;
    if (hasATLLab) score += 50;
    if (hasScienceStream) score += 20;
    if (hasSTEMFacilities) score += 15;
    if (hasDigitalInfrastructure) score += 10;
    if (isWellEquipped) score += 15;
    if (isHighPerforming) score += 10;
    if (distanceKm != null) {
      if (distanceKm! <= 1) score += 20;
      else if (distanceKm! <= 3) score += 15;
      else if (distanceKm! <= 5) score += 10;
      else if (distanceKm! <= 10) score += 5;
    }
    if (pupilTeacherRatio != null && pupilTeacherRatio! <= 30) score += 10;
    if (management == SchoolManagement.government) score += 5;
    if (totalStudents != null && totalStudents! >= 500) score += 5;
    return score;
  }
  
  List<String> get matchingStreams {
    final priorityStreams = ['Science', 'Commerce', 'Arts', 'Vocational'];
    return streamsOffered?.where((s) => priorityStreams.contains(s)).toList() ?? [];
  }
  
  String get contactInfo {
    final contacts = <String>[];
    if (phone != null && phone!.isNotEmpty) contacts.add('📞 $phone');
    if (email != null && email!.isNotEmpty) contacts.add('📧 $email');
    if (website != null && website!.isNotEmpty) contacts.add('🌐 $website');
    return contacts.join(' | ');
  }
  
  String get infrastructureSummary {
    final facilities = <String>[];
    if (hasATLLab) facilities.add('ATL Lab');
    if (hasLibrary) facilities.add('Library');
    if (hasComputerLab) facilities.add('Computer Lab');
    if (hasScienceLab) facilities.add('Science Lab');
    if (hasInternet) facilities.add('Internet');
    if (hasSmartClassroom) facilities.add('Smart Class');
    if (hasPlayground) facilities.add('Playground');
    return facilities.join(', ');
  }
}