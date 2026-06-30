import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:latlong2/latlong.dart' as latlong;

import 'opportunity_discovery/ngo_darpan_service.dart';
import 'opportunity_discovery/google_places_service.dart';
import 'opportunity_discovery/udise_school_service.dart';
import 'opportunity_discovery/atl_lab_service.dart';
import 'opportunity_discovery/competition_calendar_service.dart';
import '../models/opportunity/ngo_opportunity.dart';
import '../models/opportunity/place_opportunity.dart';
import '../models/opportunity/udise_school.dart';
import '../models/opportunity/atl_lab.dart';
import '../models/opportunity/competition.dart';
import '../models/user/user_profile.dart';

class ScanProgress {
  final String stage;
  final double progress;
  final String message;
  final DateTime timestamp;
  
  const ScanProgress({
    required this.stage,
    required this.progress,
    required this.message,
    required this.timestamp,
  });
}

class ScanResult {
  final Map<String, dynamic> results;
  final int totalFound;
  final DateTime scannedAt;
  final Duration duration;
  final List<String> errors;
  
  const ScanResult({
    required this.results,
    required this.totalFound,
    required this.scannedAt,
    required this.duration,
    required this.errors,
  });
}

class PersonalizedRecommendations {
  final List<NGOOpportunity> nearbyNGOs;
  final List<NGOOpportunity> volunteerOpportunities;
  final List<NGOOpportunity> internshipOpportunities;
  final List<PlaceOpportunity> educationalPlaces;
  final List<PlaceOpportunity> learningCenters;
  final List<PlaceOpportunity> competitionVenues;
  final List<PlaceOpportunity> internshipVenues;
  final List<PlaceOpportunity> mentorshipVenues;
  final List<UDISESchool> nearbySchools;
  final List<UDISESchool> atlSchools;
  final List<UDISESchool> topSchools;
  final List<ATLLab> nearbyATLLabs;
  final List<ATLLab> functionalATLLabs;
  final List<ATLLab> wellEquippedATLLabs;
  final List<Competition> upcomingCompetitions;
  final List<Competition> deadlineApproaching;
  final List<Competition> registrationOpen;
  final List<Competition> onlineCompetitions;
  final List<Competition> gradeAppropriate;
  final List<Competition> streamAppropriate;
  final DateTime generatedAt;
  final latlong.LatLng userLocation;
  
  const PersonalizedRecommendations({
    required this.nearbyNGOs,
    required this.volunteerOpportunities,
    required this.internshipOpportunities,
    required this.educationalPlaces,
    required this.learningCenters,
    required this.competitionVenues,
    required this.internshipVenues,
    required this.mentorshipVenues,
    required this.nearbySchools,
    required this.atlSchools,
    required this.topSchools,
    required this.nearbyATLLabs,
    required this.functionalATLLabs,
    required this.wellEquippedATLLabs,
    required this.upcomingCompetitions,
    required this.deadlineApproaching,
    required this.registrationOpen,
    required this.onlineCompetitions,
    required this.gradeAppropriate,
    required this.streamAppropriate,
    required this.generatedAt,
    required this.userLocation,
  });
  
  int get totalOpportunities => 
    nearbyNGOs.length + volunteerOpportunities.length + internshipOpportunities.length +
    educationalPlaces.length + learningCenters.length + competitionVenues.length +
    internshipVenues.length + mentorshipVenues.length + nearbySchools.length +
    atlSchools.length + topSchools.length + nearbyATLLabs.length +
    functionalATLLabs.length + wellEquippedATLLabs.length +
    upcomingCompetitions.length + deadlineApproaching.length +
    registrationOpen.length + onlineCompetitions.length +
    gradeAppropriate.length + streamAppropriate.length;
}

class OpportunityDiscoveryEngine extends ChangeNotifier {
  final NGODarpanService _ngoService = NGODarpanService();
  final GooglePlacesService _placesService = GooglePlacesService();
  final UDISESchoolService _schoolService = UDISESchoolService();
  final ATLLabService _atlService = ATLLabService();
  final CompetitionCalendarService _competitionService = CompetitionCalendarService();
  
  final StreamController<ScanProgress> _progressController = 
      StreamController<ScanProgress>.broadcast();
  Timer? _periodicScanTimer;
  bool _isScanning = false;
  ScanResult? _lastScanResult;
  
  Stream<ScanProgress> get progressStream => _progressController.stream;
  bool get isScanning => _isScanning;
  ScanResult? get lastScanResult => _lastScanResult;
  
  Future<void> initialize({required String googlePlacesApiKey}) async {
    await _ngoService.initialize();
    _placesService.initialize(apiKey: googlePlacesApiKey);
    await _schoolService.initialize();
    await _atlService.initialize();
    await _competitionService.initialize();
  }
  
  Future<ScanResult> runFullScan({
    required UserProfile userProfile,
    required double latitude,
    required double longitude,
    bool forceRefresh = false,
  }) async {
    if (_isScanning) {
      throw Exception('Scan already in progress');
    }
    
    _isScanning = true;
    notifyListeners();
    
    final startTime = DateTime.now();
    final errors = <String>[];
    final results = <String, dynamic>{};
    
    try {
      _emitProgress('initializing', 0.0, 'Starting opportunity scan...');
      
      // Parallel execution for independent services
      final futures = <Future>[];
      
      // NGO-DARPAN Search
      futures.add(_searchNGOs(userProfile, latitude, longitude, forceRefresh)
        .then((ngos) => results['ngos'] = ngos)
        .catchError((e) => errors.add('NGO search: $e')));
      
      // Google Places Searches
      futures.add(_searchEducationalPlaces(latitude, longitude, forceRefresh)
        .then((places) => results['educational_places'] = places)
        .catchError((e) => errors.add('Places search: $e')));
      
      futures.add(_searchATLLabs(latitude, longitude, forceRefresh)
        .then((labs) => results['atl_labs'] = labs)
        .catchError((e) => errors.add('ATL labs: $e')));
      
      futures.add(_searchSchools(latitude, longitude, forceRefresh)
        .then((schools) => results['schools'] = schools)
        .catchError((e) => errors.add('Schools: $e')));
      
      futures.add(_searchCompetitions(userProfile, forceRefresh)
        .then((competitions) => results['competitions'] = competitions)
        .catchError((e) => errors.add('Competitions: $e')));
      
      _emitProgress('searching', 0.3, 'Searching all sources...');
      
      await Future.wait(futures);
      
      _emitProgress('processing', 0.7, 'Processing results...');
      
      // Generate personalized recommendations
      final recommendations = _generateRecommendations(
        userProfile: userProfile,
        latitude: latitude,
        longitude: longitude,
        results: results,
      );
      results['recommendations'] = recommendations;
      
      final duration = DateTime.now().difference(startTime);
      final totalFound = _countTotalResults(results);
      
      _lastScanResult = ScanResult(
        results: results,
        totalFound: totalFound,
        scannedAt: DateTime.now(),
        duration: duration,
        errors: errors,
      );
      
      _emitProgress('complete', 1.0, 'Found $totalFound opportunities');
      
    } catch (e) {
      errors.add('Full scan error: $e');
    } finally {
      _isScanning = false;
      notifyListeners();
    }
    
    return _lastScanResult!;
  }
  
  Future<List<NGOOpportunity>> _searchNGOs(
    UserProfile userProfile,
    double latitude,
    double longitude,
    bool forceRefresh,
  ) async {
    _emitProgress('ngo_search', 0.1, 'Searching nearby NGOs...');
    
    final ngos = await _ngoService.searchNearbyNGOs(
      userProfile: userProfile,
      latitude: latitude,
      longitude: longitude,
      radiusKm: 25.0,
      useCache: !forceRefresh,
    );
    
    final volunteerOps = await _ngoService.getVolunteerOpportunities(
      userProfile: userProfile,
      latitude: latitude,
      longitude: longitude,
    );
    
    final internships = await _ngoService.getInternshipOpportunities(
      userProfile: userProfile,
      latitude: latitude,
      longitude: longitude,
    );
    
    return ngos;
  }
  
  Future<List<PlaceOpportunity>> _searchEducationalPlaces(
    double latitude,
    double longitude,
    bool forceRefresh,
  ) async {
    _emitProgress('places_search', 0.15, 'Searching educational places...');
    
    final result = await _placesService.searchEducationalOpportunities(
      location: latlong.LatLng(latitude, longitude),
      radius: 15000,
    );
    
    return result.places;
  }
  
  Future<List<ATLLab>> _searchATLLabs(
    double latitude,
    double longitude,
    bool forceRefresh,
  ) async {
    _emitProgress('atl_search', 0.2, 'Searching ATL labs...');
    
    return _atlService.searchNearbyATLLabs(
      latitude: latitude,
      longitude: longitude,
      radiusKm: 25.0,
      useCache: !forceRefresh,
    );
  }
  
  Future<List<UDISESchool>> _searchSchools(
    double latitude,
    double longitude,
    bool forceRefresh,
  ) async {
    _emitProgress('school_search', 0.25, 'Searching schools...');
    
    return _schoolService.searchNearbySchools(
      latitude: latitude,
      longitude: longitude,
      radiusKm: 15.0,
      useCache: !forceRefresh,
    );
  }
  
  Future<List<Competition>> _searchCompetitions(
    UserProfile userProfile,
    bool forceRefresh,
  ) async {
    _emitProgress('competition_search', 0.3, 'Fetching competitions...');
    
    return _competitionService.getUpcomingCompetitions(
      limit: 200,
      useCache: !forceRefresh,
    );
  }
  
  PersonalizedRecommendations _generateRecommendations({
    required UserProfile userProfile,
    required double latitude,
    required double longitude,
    required Map<String, dynamic> results,
  }) {
    final ngos = (results['ngos'] as List<NGOOpportunity>?) ?? [];
    final places = (results['educational_places'] as List<PlaceOpportunity>?) ?? [];
    final atlLabs = (results['atl_labs'] as List<ATLLab>?) ?? [];
    final schools = (results['schools'] as List<UDISESchool>?) ?? [];
    final competitions = (results['competitions'] as List<Competition>?) ?? [];
    
    // Filter and sort NGOs
    final volunteerOps = ngos.where((n) => n.hasVolunteerOpportunities).toList()
      ..sort((a, b) => b.relevanceScore.compareTo(a.relevanceScore));
    
    final internships = ngos.where((n) => n.hasInternshipOpportunities).toList()
      ..sort((a, b) => b.relevanceScore.compareTo(a.relevanceScore));
    
    // Filter places by category
    final educationalPlaces = places.where((p) => p.category == OpportunityCategory.education).toList()
      ..sort((a, b) => (b.relevanceScore ?? 0).compareTo(a.relevanceScore ?? 0));
    
    final learningCenters = places.where((p) => p.category == OpportunityCategory.learning).toList()
      ..sort((a, b) => (b.relevanceScore ?? 0).compareTo(a.relevanceScore ?? 0));
    
    final competitionVenues = places.where((p) => p.category == OpportunityCategory.competition).toList();
    final internshipVenues = places.where((p) => p.category == OpportunityCategory.internship).toList();
    final mentorshipVenues = places.where((p) => p.category == OpportunityCategory.mentorship).toList();
    
    // Filter schools
    final atlSchools = schools.where((s) => s.hasATLLab).toList()
      ..sort((a, b) => b.relevanceScore.compareTo(a.relevanceScore));
    
    final topSchools = schools.where((s) => s.isHighPerforming || s.isWellEquipped).toList()
      ..sort((a, b) => b.relevanceScore.compareTo(a.relevanceScore));
    
    // Filter ATL labs
    final functionalATLLabs = atlLabs.where((l) => l.status == ATLLabStatus.functional).toList()
      ..sort((a, b) => b.relevanceScore.compareTo(a.relevanceScore));
    
    final wellEquippedATLLabs = atlLabs.where((l) => l.isWellEquipped).toList()
      ..sort((a, b) => b.relevanceScore.compareTo(a.relevanceScore));
    
    // Filter competitions
    final now = DateTime.now();
    final deadlineSoon = now.add(const Duration(days: 7));
    
    final upcomingCompetitions = competitions.where((c) => c.isUpcoming).toList()
      ..sort((a, b) => a.registrationDeadline.compareTo(b.registrationDeadline));
    
    final deadlineApproaching = competitions.where((c) => 
      c.registrationDeadline.isBefore(deadlineSoon) && 
      c.registrationDeadline.isAfter(now) &&
      c.registrationOpen
    ).toList()
      ..sort((a, b) => a.registrationDeadline.compareTo(b.registrationDeadline));
    
    final registrationOpen = competitions.where((c) => 
      c.registrationOpen && c.registrationDeadline.isAfter(now)
    ).toList()
      ..sort((a, b) => a.registrationDeadline.compareTo(b.registrationDeadline));
    
    final onlineCompetitions = competitions.where((c) => c.isOnline).toList();
    
    final gradeAppropriate = competitions.where((c) => 
      c.eligibleGrades.contains(userProfile.grade)
    ).toList();
    
    final streamAppropriate = competitions.where((c) => 
      c.eligibleStreams.contains('All') || c.eligibleStreams.contains(userProfile.stream)
    ).toList();
    
    return PersonalizedRecommendations(
      nearbyNGOs: ngos.take(20).toList(),
      volunteerOpportunities: volunteerOps.take(10).toList(),
      internshipOpportunities: internships.take(10).toList(),
      educationalPlaces: educationalPlaces.take(15).toList(),
      learningCenters: learningCenters.take(15).toList(),
      competitionVenues: competitionVenues.take(10).toList(),
      internshipVenues: internshipVenues.take(10).toList(),
      mentorshipVenues: mentorshipVenues.take(10).toList(),
      nearbySchools: schools.take(20).toList(),
      atlSchools: atlSchools.take(15).toList(),
      topSchools: topSchools.take(10).toList(),
      nearbyATLLabs: atlLabs.take(15).toList(),
      functionalATLLabs: functionalATLLabs.take(10).toList(),
      wellEquippedATLLabs: wellEquippedATLLabs.take(10).toList(),
      upcomingCompetitions: upcomingCompetitions.take(20).toList(),
      deadlineApproaching: deadlineApproaching.take(10).toList(),
      registrationOpen: registrationOpen.take(15).toList(),
      onlineCompetitions: onlineCompetitions.take(15).toList(),
      gradeAppropriate: gradeAppropriate.take(15).toList(),
      streamAppropriate: streamAppropriate.take(15).toList(),
      generatedAt: DateTime.now(),
      userLocation: latlong.LatLng(latitude, longitude),
    );
  }
  
  int _countTotalResults(Map<String, dynamic> results) {
    int count = 0;
    for (final value in results.values) {
      if (value is List) {
        count += value.length;
      }
    }
    return count;
  }
  
  void _emitProgress(String stage, double progress, String message) {
    _progressController.add(ScanProgress(
      stage: stage,
      progress: progress,
      message: message,
      timestamp: DateTime.now(),
    ));
  }
  
  void startPeriodicScans({
    required UserProfile userProfile,
    required double latitude,
    required double longitude,
    Duration interval = const Duration(hours: 6),
  }) {
    _periodicScanTimer?.cancel();
    _periodicScanTimer = Timer.periodic(interval, (_) {
      runFullScan(
        userProfile: userProfile,
        latitude: latitude,
        longitude: longitude,
        forceRefresh: true,
      );
    });
    
    // Run initial scan
    runFullScan(
      userProfile: userProfile,
      latitude: latitude,
      longitude: longitude,
      forceRefresh: true,
    );
  }
  
  void stopPeriodicScans() {
    _periodicScanTimer?.cancel();
    _periodicScanTimer = null;
  }
  
  @override
  void dispose() {
    _periodicScanTimer?.cancel();
    _progressController.close();
    _ngoService.dispose();
    _placesService.dispose();
    _schoolService.dispose();
    _atlService.dispose();
    _competitionService.dispose();
    super.dispose();
  }
}