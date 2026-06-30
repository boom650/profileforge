import 'package:freezed_annotation/freezed_annotation.dart';

part 'atl_lab.freezed.dart';
part 'atl_lab.g.dart';

@freezed
abstract class ATLLab with _$ATLLab {
  const factory ATLLab({
    required String labId,
    required String schoolUdiseCode,
    required String schoolName,
    required String schoolAddress,
    required String city,
    required String district,
    required String state,
    required String pincode,
    required double? latitude,
    required double? longitude,
    required String? phone,
    required String? email,
    required String? website,
    required ATLLabStatus status,
    required String? establishedDate,
    required String? inchargeName,
    required String? inchargePhone,
    required String? inchargeEmail,
    required List<String>? equipmentList,
    required List<String>? programs,
    required int? studentCapacity,
    required int? currentEnrollment,
    required int? mentorsCount,
    required int? projectsCompleted,
    required int? competitionsParticipated,
    required int? awardsWon,
    required bool has3DPrinter,
    required bool hasArduino,
    required bool hasRaspberryPi,
    required bool hasDroneKit,
    required bool hasRoboticsKit,
    required bool hasElectronicsKit,
    required bool hasSensorsKit,
    required bool hasMechanicalTools,
    required bool hasSolderingStation,
    required bool hasVRAR,
    required bool hasAIMLKit,
    required bool hasIoTKit,
    required bool hasBiotechKit,
    required bool hasAerospaceKit,
    required bool hasAutomotiveKit,
    required String? labAreaSqft,
    required String? fundingAmount,
    required String? fundingSource,
    required List<String>? achievements,
    required List<String>? studentProjects,
    required Map<String, dynamic>? operatingHours,
    required bool isOpenToCommunity,
    required bool hasMentorProgram,
    required double? distanceKm,
    required DateTime? cachedAt,
    required String? source,
  }) = _ATLLab;

  factory ATLLab.fromJson(Map<String, dynamic> json) => _$ATLLabFromJson(json);
}

enum ATLLabStatus {
  @JsonValue('functional')
  functional,
  @JsonValue('non_functional')
  nonFunctional,
  @JsonValue('under_setup')
  underSetup,
  @JsonValue('proposed')
  proposed,
  @JsonValue('unknown')
  unknown,
}

extension ATLLabExtension on ATLLab {
  String get formattedAddress => '$schoolAddress, $city, $district, $state - $pincode';
  
  String get shortSchoolName => schoolName.length > 50 
      ? '${schoolName.substring(0, 50)}...' 
      : schoolName;
  
  String get statusDisplayName {
    switch (status) {
      case ATLLabStatus.functional: return 'Functional ✓';
      case ATLLabStatus.nonFunctional: return 'Non-Functional ✗';
      case ATLLabStatus.underSetup: return 'Under Setup 🔧';
      case ATLLabStatus.proposed: return 'Proposed 📋';
      case ATLLabStatus.unknown: return 'Status Unknown ❓';
    }
  }
  
  String get distanceDisplay {
    if (distanceKm == null) return 'Distance unknown';
    if (distanceKm! < 1) return '${(distanceKm! * 1000).round()}m away';
    return '${distanceKm!.toStringAsFixed(1)} km away';
  }
  
  bool get isLocal => (distanceKm ?? 0) <= 5;
  bool get isNearby => (distanceKm ?? 0) <= 15;
  bool get isAccessible => (distanceKm ?? 0) <= 30;
  
  int get equipmentCount => equipmentList?.length ?? 0;
  
  List<String> get availableEquipment {
    final equipment = <String>[];
    if (has3DPrinter) equipment.add('3D Printer');
    if (hasArduino) equipment.add('Arduino Kits');
    if (hasRaspberryPi) equipment.add('Raspberry Pi');
    if (hasDroneKit) equipment.add('Drone Kit');
    if (hasRoboticsKit) equipment.add('Robotics Kit');
    if (hasElectronicsKit) equipment.add('Electronics Kit');
    if (hasSensorsKit) equipment.add('Sensors Kit');
    if (hasMechanicalTools) equipment.add('Mechanical Tools');
    if (hasSolderingStation) equipment.add('Soldering Station');
    if (hasVRAR) equipment.add('VR/AR');
    if (hasAIMLKit) equipment.add('AI/ML Kit');
    if (hasIoTKit) equipment.add('IoT Kit');
    if (hasBiotechKit) equipment.add('Biotech Kit');
    if (hasAerospaceKit) equipment.add('Aerospace Kit');
    if (hasAutomotiveKit) equipment.add('Automotive Kit');
    return equipment;
  }
  
  int get relevanceScore {
    int score = 0;
    if (status == ATLLabStatus.functional) score += 50;
    else if (status == ATLLabStatus.underSetup) score += 20;
    if (distanceKm != null && distanceKm! <= 2) score += 30;
    else if (distanceKm != null && distanceKm! <= 5) score += 25;
    else if (distanceKm != null && distanceKm! <= 10) score += 15;
    else if (distanceKm != null && distanceKm! <= 20) score += 10;
    score += equipmentCount * 2;
    if (programs != null && programs!.isNotEmpty) score += programs!.length * 3;
    if (mentorsCount != null && mentorsCount! > 0) score += mentorsCount! * 2;
    if (projectsCompleted != null && projectsCompleted! > 0) score += projectsCompleted! ~/ 2;
    if (awardsWon != null && awardsWon! > 0) score += awardsWon! * 5;
    if (isOpenToCommunity) score += 10;
    if (hasMentorProgram) score += 15;
    return score;
  }
  
  bool get isWellEquipped => equipmentCount >= 8;
  bool get isHighlyActive => (projectsCompleted ?? 0) >= 10 && (mentorsCount ?? 0) >= 2;
  bool get isCompetitionReady => (competitionsParticipated ?? 0) >= 3 || (awardsWon ?? 0) > 0;
  bool get hasAdvancedEquipment => hasAIMLKit || hasIoTKit || hasVRAR || hasBiotechKit;
  
  String get inchargeContact {
    final contacts = <String>[];
    if (inchargeName != null && inchargeName!.isNotEmpty) contacts.add(inchargeName!);
    if (inchargePhone != null && inchargePhone!.isNotEmpty) contacts.add(inchargePhone!);
    if (inchargeEmail != null && inchargeEmail!.isNotEmpty) contacts.add(inchargeEmail!);
    return contacts.join(' | ');
  }
}