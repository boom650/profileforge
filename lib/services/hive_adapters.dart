// Hive Adapters for Opportunity Discovery Models
// Run: flutter pub run build_runner build --delete-conflicting-outputs

import 'package:hive/hive.dart';

import '../models/opportunity/ngo_opportunity.dart';
import '../models/opportunity/place_opportunity.dart';
import '../models/opportunity/udise_school.dart';
import '../models/opportunity/atl_lab.dart';
import '../models/opportunity/competition.dart';

// Type IDs - must be unique across all adapters
const int ngoOpportunityTypeId = 100;
const int placeOpportunityTypeId = 101;
const int udiseSchoolTypeId = 102;
const int atlLabTypeId = 103;
const int competitionTypeId = 104;

// Register all adapters
void registerOpportunityAdapters() {
  if (!Hive.isAdapterRegistered(ngoOpportunityTypeId)) {
    Hive.registerAdapter(NGOOpportunityAdapter());
  }
  if (!Hive.isAdapterRegistered(placeOpportunityTypeId)) {
    Hive.registerAdapter(PlaceOpportunityAdapter());
  }
  if (!Hive.isAdapterRegistered(udiseSchoolTypeId)) {
    Hive.registerAdapter(UDISESchoolAdapter());
  }
  if (!Hive.isAdapterRegistered(atlLabTypeId)) {
    Hive.registerAdapter(ATLLabAdapter());
  }
  if (!Hive.isAdapterRegistered(competitionTypeId)) {
    Hive.registerAdapter(CompetitionAdapter());
  }
}

// NGOOpportunity Adapter
class NGOOpportunityAdapter extends TypeAdapter<NGOOpportunity> {
  @override
  final int typeId = ngoOpportunityTypeId;

  @override
  NGOOpportunity read(BinaryReader reader) {
    return NGOOpportunity(
      id: reader.readString(),
      name: reader.readString(),
      description: reader.readString(),
      address: reader.readString(),
      city: reader.readString(),
      state: reader.readString(),
      pincode: reader.readString(),
      phone: reader.readString(),
      email: reader.readString(),
      website: reader.readString(),
      latitude: reader.readDouble(),
      longitude: reader.readDouble(),
      sectors: reader.readStringList(),
      activities: reader.readStringList(),
      targetGroups: reader.readStringList(),
      hasVolunteerOpportunities: reader.readBool(),
      hasInternshipOpportunities: reader.readBool(),
      hasFellowshipOpportunities: reader.readBool(),
      registrationNumber: reader.readString(),
      registrationDate: reader.readString(),
      fcrNumber: reader.readString(),
      panNumber: reader.readString(),
      gstNumber: reader.readString(),
      establishedYear: reader.readInt(),
      annualBudget: reader.readString(),
      keyProjects: reader.readStringList(),
      contactPersons: reader.readMap(),
      distanceKm: reader.readDouble(),
      cachedAt: reader.readDateTime(),
      source: reader.readString(),
    );
  }

  @override
  void write(BinaryWriter writer, NGOOpportunity obj) {
    writer.writeString(obj.id);
    writer.writeString(obj.name);
    writer.writeString(obj.description);
    writer.writeString(obj.address);
    writer.writeString(obj.city);
    writer.writeString(obj.state);
    writer.writeString(obj.pincode);
    writer.writeString(obj.phone);
    writer.writeString(obj.email);
    writer.writeString(obj.website);
    writer.writeDouble(obj.latitude ?? 0.0);
    writer.writeDouble(obj.longitude ?? 0.0);
    writer.writeStringList(obj.sectors);
    writer.writeStringList(obj.activities);
    writer.writeStringList(obj.targetGroups);
    writer.writeBool(obj.hasVolunteerOpportunities);
    writer.writeBool(obj.hasInternshipOpportunities);
    writer.writeBool(obj.hasFellowshipOpportunities);
    writer.writeString(obj.registrationNumber ?? '');
    writer.writeString(obj.registrationDate ?? '');
    writer.writeString(obj.fcrNumber ?? '');
    writer.writeString(obj.panNumber ?? '');
    writer.writeString(obj.gstNumber ?? '');
    writer.writeInt(obj.establishedYear ?? 0);
    writer.writeString(obj.annualBudget ?? '');
    writer.writeStringList(obj.keyProjects ?? []);
    writer.writeMap(obj.contactPersons ?? {});
    writer.writeDouble(obj.distanceKm ?? 0.0);
    writer.writeDateTime(obj.cachedAt ?? DateTime.now());
    writer.writeString(obj.source ?? '');
  }
}

// PlaceOpportunity Adapter
class PlaceOpportunityAdapter extends TypeAdapter<PlaceOpportunity> {
  @override
  final int typeId = placeOpportunityTypeId;

  @override
  PlaceOpportunity read(BinaryReader reader) {
    return PlaceOpportunity(
      placeId: reader.readString(),
      name: reader.readString(),
      formattedAddress: reader.readString(),
      latitude: reader.readDouble(),
      longitude: reader.readDouble(),
      types: reader.readStringList(),
      rating: reader.readDouble(),
      userRatingsTotal: reader.readInt(),
      priceLevel: reader.readInt(),
      website: reader.readString(),
      formattedPhoneNumber: reader.readString(),
      vicinity: reader.readString(),
      businessStatus: reader.readString(),
      distanceKm: reader.readDouble(),
      rawData: reader.readMap(),
      cachedAt: reader.readDateTime(),
      source: reader.readString(),
      keywords: reader.readStringList(),
      category: reader.readInt() == -1 ? null : OpportunityCategory.values[reader.readInt()],
      relevanceScore: reader.readInt(),
      isOpenNow: reader.readBool(),
      openingHoursText: reader.readString(),
    );
  }

  @override
  void write(BinaryWriter writer, PlaceOpportunity obj) {
    writer.writeString(obj.placeId);
    writer.writeString(obj.name);
    writer.writeString(obj.formattedAddress);
    writer.writeDouble(obj.latitude);
    writer.writeDouble(obj.longitude);
    writer.writeStringList(obj.types);
    writer.writeDouble(obj.rating ?? 0.0);
    writer.writeInt(obj.userRatingsTotal ?? 0);
    writer.writeInt(obj.priceLevel ?? 0);
    writer.writeString(obj.website ?? '');
    writer.writeString(obj.formattedPhoneNumber ?? '');
    writer.writeString(obj.vicinity ?? '');
    writer.writeString(obj.businessStatus ?? '');
    writer.writeDouble(obj.distanceKm ?? 0.0);
    writer.writeMap(obj.rawData ?? {});
    writer.writeDateTime(obj.cachedAt ?? DateTime.now());
    writer.writeString(obj.source ?? '');
    writer.writeStringList(obj.keywords ?? []);
    writer.writeInt(obj.category?.index ?? -1);
    writer.writeInt(obj.relevanceScore ?? 0);
    writer.writeBool(obj.isOpenNow ?? false);
    writer.writeString(obj.openingHoursText ?? '');
  }
}

// UDISESchool Adapter
class UDISESchoolAdapter extends TypeAdapter<UDISESchool> {
  @override
  final int typeId = udiseSchoolTypeId;

  @override
  UDISESchool read(BinaryReader reader) {
    return UDISESchool(
      udiseCode: reader.readString(),
      name: reader.readString(),
      address: reader.readString(),
      village: reader.readString(),
      block: reader.readString(),
      district: reader.readString(),
      state: reader.readString(),
      pincode: reader.readString(),
      latitude: reader.readDouble(),
      longitude: reader.readDouble(),
      phone: reader.readString(),
      email: reader.readString(),
      website: reader.readString(),
      category: SchoolCategory.values[reader.readInt()],
      management: SchoolManagement.values[reader.readInt()],
      type: SchoolType.values[reader.readInt()],
      lowestClass: reader.readInt(),
      highestClass: reader.readInt(),
      totalStudents: reader.readInt(),
      boysEnrollment: reader.readInt(),
      girlsEnrollment: reader.readInt(),
      totalTeachers: reader.readInt(),
      maleTeachers: reader.readInt(),
      femaleTeachers: reader.readInt(),
      pupilTeacherRatio: reader.readDouble(),
      hasATLLab: reader.readBool(),
      hasLibrary: reader.readBool(),
      hasComputerLab: reader.readBool(),
      hasScienceLab: reader.readBool(),
      hasPhysicsLab: reader.readBool(),
      hasChemistryLab: reader.readBool(),
      hasBiologyLab: reader.readBool(),
      hasMathsLab: reader.readBool(),
      hasLanguageLab: reader.readBool(),
      hasComputerAidedLearning: reader.readBool(),
      hasInternet: reader.readBool(),
      hasSmartClassroom: reader.readBool(),
      hasDigitalLibrary: reader.readBool(),
      hasPlayground: reader.readBool(),
      hasSportsFacility: reader.readBool(),
      hasGymnasium: reader.readBool(),
      hasAuditorium: reader.readBool(),
      hasCanteen: reader.readBool(),
      hasMedicalRoom: reader.readBool(),
      hasDrinkingWater: reader.readBool(),
      hasToiletsBoys: reader.readBool(),
      hasToiletsGirls: reader.readBool(),
      hasCWSNToilets: reader.readBool(),
      hasRamp: reader.readBool(),
      hasHandrails: reader.readBool(),
      hasElevator: reader.readBool(),
      hasFireExtinguisher: reader.readBool(),
      hasBoundaryWall: reader.readBool(),
      hasElectricity: reader.readBool(),
      hasSolarPower: reader.readBool(),
      hasGenerator: reader.readBool(),
      classroomsTotal: reader.readInt(),
      classroomsGoodCondition: reader.readInt(),
      classroomsNeedMinorRepair: reader.readInt(),
      classroomsNeedMajorRepair: reader.readInt(),
      infrastructureScore: reader.readDouble(),
      academicScore: reader.readDouble(),
      affiliationBoard: reader.readString(),
      affiliationNumber: reader.readString(),
      establishedYear: reader.readInt(),
      mediumOfInstruction: reader.readStringList(),
      subjectsOffered: reader.readStringList(),
      streamsOffered: reader.readStringList(),
      vocationalCourses: reader.readStringList(),
      coCurricularActivities: reader.readStringList(),
      specializations: reader.readStringList(),
      facilitiesDetail: reader.readMap(),
      distanceKm: reader.readDouble(),
      cachedAt: reader.readDateTime(),
      source: reader.readString(),
    );
  }

  @override
  void write(BinaryWriter writer, UDISESchool obj) {
    writer.writeString(obj.udiseCode);
    writer.writeString(obj.name);
    writer.writeString(obj.address);
    writer.writeString(obj.village);
    writer.writeString(obj.block);
    writer.writeString(obj.district);
    writer.writeString(obj.state);
    writer.writeString(obj.pincode);
    writer.writeDouble(obj.latitude ?? 0.0);
    writer.writeDouble(obj.longitude ?? 0.0);
    writer.writeString(obj.phone ?? '');
    writer.writeString(obj.email ?? '');
    writer.writeString(obj.website ?? '');
    writer.writeInt(obj.category.index);
    writer.writeInt(obj.management.index);
    writer.writeInt(obj.type.index);
    writer.writeInt(obj.lowestClass ?? 0);
    writer.writeInt(obj.highestClass ?? 0);
    writer.writeInt(obj.totalStudents ?? 0);
    writer.writeInt(obj.boysEnrollment ?? 0);
    writer.writeInt(obj.girlsEnrollment ?? 0);
    writer.writeInt(obj.totalTeachers ?? 0);
    writer.writeInt(obj.maleTeachers ?? 0);
    writer.writeInt(obj.femaleTeachers ?? 0);
    writer.writeDouble(obj.pupilTeacherRatio ?? 0.0);
    writer.writeBool(obj.hasATLLab);
    writer.writeBool(obj.hasLibrary);
    writer.writeBool(obj.hasComputerLab);
    writer.writeBool(obj.hasScienceLab);
    writer.writeBool(obj.hasPhysicsLab);
    writer.writeBool(obj.hasChemistryLab);
    writer.writeBool(obj.hasBiologyLab);
    writer.writeBool(obj.hasMathsLab);
    writer.writeBool(obj.hasLanguageLab);
    writer.writeBool(obj.hasComputerAidedLearning);
    writer.writeBool(obj.hasInternet);
    writer.writeBool(obj.hasSmartClassroom);
    writer.writeBool(obj.hasDigitalLibrary);
    writer.writeBool(obj.hasPlayground);
    writer.writeBool(obj.hasSportsFacility);
    writer.writeBool(obj.hasGymnasium);
    writer.writeBool(obj.hasAuditorium);
    writer.writeBool(obj.hasCanteen);
    writer.writeBool(obj.hasMedicalRoom);
    writer.writeBool(obj.hasDrinkingWater);
    writer.writeBool(obj.hasToiletsBoys);
    writer.writeBool(obj.hasToiletsGirls);
    writer.writeBool(obj.hasCWSNToilets);
    writer.writeBool(obj.hasRamp);
    writer.writeBool(obj.hasHandrails);
    writer.writeBool(obj.hasElevator);
    writer.writeBool(obj.hasFireExtinguisher);
    writer.writeBool(obj.hasBoundaryWall);
    writer.writeBool(obj.hasElectricity);
    writer.writeBool(obj.hasSolarPower);
    writer.writeBool(obj.hasGenerator);
    writer.writeInt(obj.classroomsTotal ?? 0);
    writer.writeInt(obj.classroomsGoodCondition ?? 0);
    writer.writeInt(obj.classroomsNeedMinorRepair ?? 0);
    writer.writeInt(obj.classroomsNeedMajorRepair ?? 0);
    writer.writeDouble(obj.infrastructureScore ?? 0.0);
    writer.writeDouble(obj.academicScore ?? 0.0);
    writer.writeString(obj.affiliationBoard ?? '');
    writer.writeString(obj.affiliationNumber ?? '');
    writer.writeInt(obj.establishedYear ?? 0);
    writer.writeStringList(obj.mediumOfInstruction ?? []);
    writer.writeStringList(obj.subjectsOffered ?? []);
    writer.writeStringList(obj.streamsOffered ?? []);
    writer.writeStringList(obj.vocationalCourses ?? []);
    writer.writeStringList(obj.coCurricularActivities ?? []);
    writer.writeStringList(obj.specializations ?? []);
    writer.writeMap(obj.facilitiesDetail ?? {});
    writer.writeDouble(obj.distanceKm ?? 0.0);
    writer.writeDateTime(obj.cachedAt ?? DateTime.now());
    writer.writeString(obj.source ?? '');
  }
}

// ATLLab Adapter
class ATLLabAdapter extends TypeAdapter<ATLLab> {
  @override
  final int typeId = atlLabTypeId;

  @override
  ATLLab read(BinaryReader reader) {
    return ATLLab(
      labId: reader.readString(),
      schoolUdiseCode: reader.readString(),
      schoolName: reader.readString(),
      schoolAddress: reader.readString(),
      city: reader.readString(),
      district: reader.readString(),
      state: reader.readString(),
      pincode: reader.readString(),
      latitude: reader.readDouble(),
      longitude: reader.readDouble(),
      phone: reader.readString(),
      email: reader.readString(),
      website: reader.readString(),
      status: ATLLabStatus.values[reader.readInt()],
      establishedDate: reader.readString(),
      inchargeName: reader.readString(),
      inchargePhone: reader.readString(),
      inchargeEmail: reader.readString(),
      equipmentList: reader.readStringList(),
      programs: reader.readStringList(),
      studentCapacity: reader.readInt(),
      currentEnrollment: reader.readInt(),
      mentorsCount: reader.readInt(),
      projectsCompleted: reader.readInt(),
      competitionsParticipated: reader.readInt(),
      awardsWon: reader.readInt(),
      has3DPrinter: reader.readBool(),
      hasArduino: reader.readBool(),
      hasRaspberryPi: reader.readBool(),
      hasDroneKit: reader.readBool(),
      hasRoboticsKit: reader.readBool(),
      hasElectronicsKit: reader.readBool(),
      hasSensorsKit: reader.readBool(),
      hasMechanicalTools: reader.readBool(),
      hasSolderingStation: reader.readBool(),
      hasVRAR: reader.readBool(),
      hasAIMLKit: reader.readBool(),
      hasIoTKit: reader.readBool(),
      hasBiotechKit: reader.readBool(),
      hasAerospaceKit: reader.readBool(),
      hasAutomotiveKit: reader.readBool(),
      labAreaSqft: reader.readString(),
      fundingAmount: reader.readString(),
      fundingSource: reader.readString(),
      achievements: reader.readStringList(),
      studentProjects: reader.readStringList(),
      operatingHours: reader.readMap(),
      isOpenToCommunity: reader.readBool(),
      hasMentorProgram: reader.readBool(),
      distanceKm: reader.readDouble(),
      cachedAt: reader.readDateTime(),
      source: reader.readString(),
    );
  }

  @override
  void write(BinaryWriter writer, ATLLab obj) {
    writer.writeString(obj.labId);
    writer.writeString(obj.schoolUdiseCode);
    writer.writeString(obj.schoolName);
    writer.writeString(obj.schoolAddress);
    writer.writeString(obj.city);
    writer.writeString(obj.district);
    writer.writeString(obj.state);
    writer.writeString(obj.pincode);
    writer.writeDouble(obj.latitude ?? 0.0);
    writer.writeDouble(obj.longitude ?? 0.0);
    writer.writeString(obj.phone ?? '');
    writer.writeString(obj.email ?? '');
    writer.writeString(obj.website ?? '');
    writer.writeInt(obj.status.index);
    writer.writeString(obj.establishedDate ?? '');
    writer.writeString(obj.inchargeName ?? '');
    writer.writeString(obj.inchargePhone ?? '');
    writer.writeString(obj.inchargeEmail ?? '');
    writer.writeStringList(obj.equipmentList ?? []);
    writer.writeStringList(obj.programs ?? []);
    writer.writeInt(obj.studentCapacity ?? 0);
    writer.writeInt(obj.currentEnrollment ?? 0);
    writer.writeInt(obj.mentorsCount ?? 0);
    writer.writeInt(obj.projectsCompleted ?? 0);
    writer.writeInt(obj.competitionsParticipated ?? 0);
    writer.writeInt(obj.awardsWon ?? 0);
    writer.writeBool(obj.has3DPrinter);
    writer.writeBool(obj.hasArduino);
    writer.writeBool(obj.hasRaspberryPi);
    writer.writeBool(obj.hasDroneKit);
    writer.writeBool(obj.hasRoboticsKit);
    writer.writeBool(obj.hasElectronicsKit);
    writer.writeBool(obj.hasSensorsKit);
    writer.writeBool(obj.hasMechanicalTools);
    writer.writeBool(obj.hasSolderingStation);
    writer.writeBool(obj.hasVRAR);
    writer.writeBool(obj.hasAIMLKit);
    writer.writeBool(obj.hasIoTKit);
    writer.writeBool(obj.hasBiotechKit);
    writer.writeBool(obj.hasAerospaceKit);
    writer.writeBool(obj.hasAutomotiveKit);
    writer.writeString(obj.labAreaSqft ?? '');
    writer.writeString(obj.fundingAmount ?? '');
    writer.writeString(obj.fundingSource ?? '');
    writer.writeStringList(obj.achievements ?? []);
    writer.writeStringList(obj.studentProjects ?? []);
    writer.writeMap(obj.operatingHours ?? {});
    writer.writeBool(obj.isOpenToCommunity);
    writer.writeBool(obj.hasMentorProgram);
    writer.writeDouble(obj.distanceKm ?? 0.0);
    writer.writeDateTime(obj.cachedAt ?? DateTime.now());
    writer.writeString(obj.source ?? '');
  }
}

// Competition Adapter
class CompetitionAdapter extends TypeAdapter<Competition> {
  @override
  final int typeId = competitionTypeId;

  @override
  Competition read(BinaryReader reader) {
    return Competition(
      id: reader.readString(),
      title: reader.readString(),
      description: reader.readString(),
      category: CompetitionCategory.values[reader.readInt()],
      level: CompetitionLevel.values[reader.readInt()],
      startDate: reader.readDateTime(),
      endDate: reader.readDateTime(),
      registrationDeadline: reader.readDateTime(),
      registrationOpen: reader.readBool(),
      eligibleGrades: reader.readIntList(),
      eligibleStreams: reader.readStringList(),
      isOnline: reader.readBool(),
      venue: reader.readString(),
      city: reader.readString(),
      state: reader.readString(),
      country: reader.readString(),
      latitude: reader.readDouble(),
      longitude: reader.readDouble(),
      website: reader.readString(),
      registrationUrl: reader.readString(),
      organizer: reader.readString(),
      prizes: reader.readStringList(),
      tags: reader.readStringList(),
      contactEmail: reader.readString(),
      contactPhone: reader.readString(),
      maxTeamSize: reader.readInt(),
      minTeamSize: reader.readInt(),
      individualParticipation: reader.readBool(),
      teamParticipation: reader.readBool(),
      format: reader.readString(),
      syllabus: reader.readString(),
      prerequisites: reader.readStringList(),
      rounds: reader.readMap(),
      resultDate: reader.readDateTime(),
      cachedAt: reader.readDateTime(),
      source: reader.readString(),
    );
  }

  @override
  void write(BinaryWriter writer, Competition obj) {
    writer.writeString(obj.id);
    writer.writeString(obj.title);
    writer.writeString(obj.description);
    writer.writeInt(obj.category.index);
    writer.writeInt(obj.level.index);
    writer.writeDateTime(obj.startDate);
    writer.writeDateTime(obj.endDate);
    writer.writeDateTime(obj.registrationDeadline);
    writer.writeBool(obj.registrationOpen);
    writer.writeIntList(obj.eligibleGrades);
    writer.writeStringList(obj.eligibleStreams);
    writer.writeBool(obj.isOnline);
    writer.writeString(obj.venue ?? '');
    writer.writeString(obj.city ?? '');
    writer.writeString(obj.state ?? '');
    writer.writeString(obj.country ?? '');
    writer.writeDouble(obj.latitude ?? 0.0);
    writer.writeDouble(obj.longitude ?? 0.0);
    writer.writeString(obj.website ?? '');
    writer.writeString(obj.registrationUrl ?? '');
    writer.writeString(obj.organizer);
    writer.writeStringList(obj.prizes);
    writer.writeStringList(obj.tags);
    writer.writeString(obj.contactEmail ?? '');
    writer.writeString(obj.contactPhone ?? '');
    writer.writeInt(obj.maxTeamSize ?? 0);
    writer.writeInt(obj.minTeamSize ?? 0);
    writer.writeBool(obj.individualParticipation);
    writer.writeBool(obj.teamParticipation);
    writer.writeString(obj.format ?? '');
    writer.writeString(obj.syllabus ?? '');
    writer.writeStringList(obj.prerequisites ?? []);
    writer.writeMap(obj.rounds ?? {});
    writer.writeDateTime(obj.resultDate ?? DateTime.now());
    writer.writeDateTime(obj.cachedAt);
    writer.writeString(obj.source ?? '');
  }
}