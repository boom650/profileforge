// Service Providers - Riverpod configuration for Opportunity Discovery

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'opportunity_discovery.dart';

part 'service_providers.g.dart';

// NGODarpanService Provider
@riverpod
NGODarpanService ngoDarpanService(NGODarpanServiceRef ref) {
  final service = NGODarpanService();
  ref.onDispose(() => service.dispose());
  return service;
}

// GooglePlacesService Provider
@riverpod
GooglePlacesService googlePlacesService(GooglePlacesServiceRef ref) {
  final service = GooglePlacesService();
  ref.onDispose(() => service.dispose());
  return service;
}

// UDISESchoolService Provider
@riverpod
UDISESchoolService udiseSchoolService(UDISESchoolServiceRef ref) {
  final service = UDISESchoolService();
  ref.onDispose(() => service.dispose());
  return service;
}

// ATLLabService Provider
@riverpod
ATLLabService atlLabService(ATLLabServiceRef ref) {
  final service = ATLLabService();
  ref.onDispose(() => service.dispose());
  return service;
}

// CompetitionCalendarService Provider
@riverpod
CompetitionCalendarService competitionCalendarService(CompetitionCalendarServiceRef ref) {
  final service = CompetitionCalendarService();
  ref.onDispose(() => service.dispose());
  return service;
}

// OpportunityDiscoveryEngine Provider
@riverpod
OpportunityDiscoveryEngine opportunityDiscoveryEngine(OpportunityDiscoveryEngineRef ref) {
  final engine = OpportunityDiscoveryEngine();
  ref.onDispose(() => engine.dispose());
  return engine;
}

// Initialize all services
@riverpod
Future<void> initializeOpportunityServices(InitializeOpportunityServicesRef ref, {
  required String googlePlacesApiKey,
}) async {
  await ref.read(ngoDarpanServiceProvider).initialize();
  ref.read(googlePlacesServiceProvider).initialize(apiKey: googlePlacesApiKey);
  await ref.read(udiseSchoolServiceProvider).initialize();
  await ref.read(atlLabServiceProvider).initialize();
  await ref.read(competitionCalendarServiceProvider).initialize();
  
  final engine = ref.read(opportunityDiscoveryEngineProvider);
  await engine.initialize(googlePlacesApiKey: googlePlacesApiKey);
}

// Search providers for reactive UI
@riverpod
Future<List<NGOOpportunity>> nearbyNGOs(NearbyNGOsRef ref, {
  required UserProfile userProfile,
  required double latitude,
  required double longitude,
  double radiusKm = 25.0,
  String? sector,
}) async {
  return ref.read(ngoDarpanServiceProvider).searchNearbyNGOs(
    userProfile: userProfile,
    latitude: latitude,
    longitude: longitude,
    radiusKm: radiusKm,
    sector: sector,
  );
}

@riverpod
Future<List<PlaceOpportunity>> nearbyPlaces(NearbyPlacesRef ref, {
  required double latitude,
  required double longitude,
  double radiusKm = 15.0,
  List<String>? types,
}) async {
  final result = await ref.read(googlePlacesServiceProvider).searchNearbyPlaces(
    location: LatLng(latitude, longitude),
    radius: radiusKm * 1000,
    types: types,
  );
  return result.places;
}

@riverpod
Future<List<UDISESchool>> nearbySchools(NearbySchoolsRef ref, {
  required double latitude,
  required double longitude,
  double radiusKm = 15.0,
  String? state,
  String? district,
}) async {
  return ref.read(udiseSchoolServiceProvider).searchNearbySchools(
    latitude: latitude,
    longitude: longitude,
    radiusKm: radiusKm,
    state: state,
    district: district,
  );
}

@riverpod
Future<List<ATLLab>> nearbyATLLabs(NearbyATLLabsRef ref, {
  required double latitude,
  required double longitude,
  double radiusKm = 25.0,
  String? state,
  String? district,
}) async {
  return ref.read(atlLabServiceProvider).searchNearbyATLLabs(
    latitude: latitude,
    longitude: longitude,
    radiusKm: radiusKm,
    state: state,
    district: district,
  );
}

@riverpod
Future<List<Competition>> upcomingCompetitions(UpcomingCompetitionsRef ref, {
  int limit = 20,
  CompetitionCategory? category,
  CompetitionLevel? level,
}) async {
  return ref.read(competitionCalendarServiceProvider).getUpcomingCompetitions(
    limit: limit,
    category: category,
    level: level,
  );
}

// Combined search for all opportunities
@riverpod
Future<PersonalizedRecommendations> personalizedRecommendations(
  PersonalizedRecommendationsRef ref, {
  required UserProfile userProfile,
  required double latitude,
  required double longitude,
}) async {
  return ref.read(opportunityDiscoveryEngineProvider).runFullScan(
    userProfile: userProfile,
    latitude: latitude,
    longitude: longitude,
  ).then((result) => result.results?['recommendations'] as PersonalizedRecommendations);
}

// Scan progress stream
@riverpod
Stream<ScanProgress> scanProgress(ScanProgressRef ref) {
  return ref.read(opportunityDiscoveryEngineProvider).progressStream;
}

// Background scan controller
@riverpod
class BackgroundScanController extends _$BackgroundScanController {
  @override
  Future<void> build() async {
    // Initial setup
  }
  
  Future<ScanResult> triggerScan({
    required UserProfile userProfile,
    required double latitude,
    required double longitude,
    bool forceRefresh = false,
  }) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => ref
        .read(opportunityDiscoveryEngineProvider)
        .runFullScan(
          userProfile: userProfile,
          latitude: latitude,
          longitude: longitude,
          forceRefresh: forceRefresh,
        ));
    return state.value!;
  }
  
  void startPeriodicScans({
    required UserProfile userProfile,
    required double latitude,
    required double longitude,
    Duration interval = const Duration(hours: 6),
  }) {
    ref.read(opportunityDiscoveryEngineProvider).startPeriodicScans(
      userProfile: userProfile,
      latitude: latitude,
      longitude: longitude,
      interval: interval,
    );
  }
  
  void stopPeriodicScans() {
    ref.read(opportunityDiscoveryEngineProvider).stopPeriodicScans();
  }
}

import 'package:latlong2/latlong.dart' as latlong;
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'service_providers.freezed.dart';
part 'service_providers.g.dart';