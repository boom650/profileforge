import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:meta/meta.dart';

import 'package:http/http.dart' as http;
import '../models/opportunity/ngo_opportunity.dart';
import '../models/opportunity/competition.dart';
import '../models/opportunity/place_opportunity.dart';
import '../models/student_profile.dart';

/// Hyper-Local Opportunity Discovery Engine
/// Integrates NGO-DARPAN, Google Places, UDISE+, ATL Labs, Competition Calendars
class OpportunityDiscoveryEngine {
  static const String NGO_DARPAN_BASE = 'https://ngodarpan.gov.in/api';
  static const String GOOGLE_PLACES_BASE = 'https://maps.googleapis.com/maps/api/place';
  static const String UDISE_BASE = 'https://api.udiseplus.gov.in';
  static const String ATL_LABS_BASE = 'https://aim.gov.in/api';
  
  final http.Client _httpClient;
  final String? _googlePlacesApiKey;
  
  // In-memory cache for offline-first operation
  final Map<String, CachedOpportunityData> _cache = {};
  static const Duration CACHE_TTL = Duration(hours: 24);
  
  OpportunityDiscoveryEngine({
    http.Client? httpClient,
    String? googlePlacesApiKey,
  }) : _httpClient = httpClient ?? http.Client(),
       _googlePlacesApiKey = googlePlacesApiKey;
  
  /// Discover opportunities near student's location
  Future<List<Opportunity>> discoverOpportunities({
    required StudentProfile student,
    required double latitude,
    required double longitude,
    double radiusKm = 25,
    List<OpportunityCategory>? categories,
  }) async {
    final allOpportunities = <Opportunity>[];
    
    // Run discovery in parallel
    final futures = [
      _discoverNGOOpportunities(latitude, longitude, radiusKm, student),
      _discoverGooglePlacesOpportunities(latitude, longitude, radiusKm, categories, student),
      _discoverATLLabOpportunities(latitude, longitude, radiusKm, student),
      _discoverCompetitionOpportunities(student),
      _discoverUDISESchoolOpportunities(student),
    ];
    
    final results = await Future.wait(futures);
    for (final opps in results) {
      allOpportunities.addAll(opps);
    }
    
    // Score and rank opportunities
    final scored = _scoreAndRankOpportunities(allOpportunities, student);
    
    // Cache results
    _cacheResults(latitude, longitude, scored);
    
    return scored;
  }
  
  /// NGO-DARPAN Integration (573K+ NGOs)
  Future<List<NGOOpportunity>> _discoverNGOOpportunities(
    double lat,
    double lng,
    double radiusKm,
    StudentProfile student,
  ) async {
    try {
      // NGO-DARPAN doesn't have a public API, so we use their sector/state lists
      // In production, this would use their CSV exports or web scraping
      final ngos = await _fetchNGODARPANData(student);
      
      return ngos
          .where((ngo) => _calculateDistance(lat, lng, ngo.latitude, ngo.longitude) <= radiusKm)
          .map((ngo) => ngo.toOpportunity(student))
          .toList();
    } catch (e) {
      // Return cached or mock data if API fails
      return _getMockNGOOpportunities(lat, lng, radiusKm, student);
    }
  }
  
  Future<List<NGOData>> _fetchNGODARPANData(StudentProfile student) async {
    // NGO-DARPAN provides state-wise CSV downloads
    // This would download and parse the CSV
    // For now, return mock data structure
    return _getMockNGOData(student);
  }
  
  List<NGOOpportunity> _getMockNGOOpportunities(
    double lat, double lng, double radiusKm, StudentProfile student) {
    final mockNGOs = [
      NGOData(
        id: 'ngo_goonj',
        name: 'Goonj',
        sector: 'Education, Clothing, Disaster Relief',
        address: 'Goonj Centre, Sarita Vihar, New Delhi',
        latitude: 28.5245,
        longitude: 77.2850,
        contactEmail: 'volunteer@goonj.org',
        contactPhone: '+91-11-41404444',
        website: 'https://goonj.org',
        establishedYear: 1999,
        darpanId: 'DL/2017/0165432',
        activities: ['Weekend Teaching', 'Material Collection', 'Disaster Relief'],
        volunteerCapacity: 50,
      ),
      NGOData(
        id: 'ngo_pehchaan',
        name: 'Pehchaan The Street School',
        sector: 'Education',
        address: 'Multiple centers across Delhi NCR',
        latitude: 28.6139,
        longitude: 77.2090,
        contactEmail: 'info@pehchaan.org',
        contactPhone: '+91-9876543210',
        website: 'https://pehchaan.org',
        establishedYear: 2015,
        darpanId: 'DL/2017/0165433',
        activities: ['Street Teaching', 'Mentorship', 'Life Skills'],
        volunteerCapacity: 30,
      ),
      NGOData(
        id: 'ngo_dhara',
        name: 'Dhara Sansthan',
        sector: 'Environment, Water Conservation',
        address: 'Jaipur, Rajasthan',
        latitude: 26.9124,
        longitude: 75.7873,
        contactEmail: 'dhara@dhara.org',
        contactPhone: '+91-141-2345678',
        website: 'https://dhara.org',
        establishedYear: 2005,
        darpanId: 'RJ/2017/0165434',
        activities: ['Water Conservation', 'Tree Plantation', 'Awareness Campaigns'],
        volunteerCapacity: 25,
      ),
    ];
    
    return mockNGOs
        .where((ngo) => _calculateDistance(lat, lng, ngo.latitude, ngo.longitude) <= radiusKm)
        .map((ngo) => ngo.toOpportunity(student))
        .toList();
  }
  
  List<NGOData> _getMockNGOData(StudentProfile student) {
    return [
      NGOData(
        id: 'ngo_goonj',
        name: 'Goonj',
        sector: 'Education, Clothing, Disaster Relief',
        address: 'Goonj Centre, Sarita Vihar, New Delhi',
        latitude: 28.5245,
        longitude: 77.2850,
        contactEmail: 'volunteer@goonj.org',
        contactPhone: '+91-11-41404444',
        website: 'https://goonj.org',
        establishedYear: 1999,
        darpanId: 'DL/2017/0165432',
        activities: ['Weekend Teaching', 'Material Collection', 'Disaster Relief'],
        volunteerCapacity: 50,
      ),
      // Add more mock NGOs...
    ];
  }
  
  /// Google Places API Integration
  Future<List<PlaceOpportunity>> _discoverGooglePlacesOpportunities(
    double lat,
    double lng,
    double radiusKm,
    List<OpportunityCategory>? categories,
    StudentProfile student,
  ) async {
    if (_googlePlacesApiKey == null) {
      return _getMockPlaceOpportunities(lat, lng, radiusKm, student);
    }
    
    final placeTypes = _getPlaceTypesForCategories(categories ?? []);
    final allPlaces = <PlaceOpportunity>[];
    
    for (final type in placeTypes) {
      try {
        final places = await _searchPlaces(lat, lng, radiusKm * 1000, type);
        for (final place in places) {
          allPlaces.add(PlaceOpportunity.fromGooglePlacesJson(
            place,
            LatLng(lat, lng),
          ));
        }
      } catch (e) {
        // Continue with other types
      }
    }
    
    return allPlaces;
  }
  
  Future<List<Map<String, dynamic>>> _searchPlaces(
    double lat, double lng, int radiusMeters, String type) async {
    final url = Uri.parse('$GOOGLE_PLACES_BASE/nearbysearch/json')
        .replace(queryParameters: {
      'location': '$lat,$lng',
      'radius': radiusMeters.toString(),
      'type': type,
      'key': _googlePlacesApiKey!,
    });
    
    final response = await _httpClient.get(url);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return List<Map<String, dynamic>>.from(data['results'] ?? []);
    }
    return [];
  }
  
  List<String> _getPlaceTypesForCategories(List<OpportunityCategory> categories) {
    final typeMap = {
      OpportunityCategory.volunteering: ['non_profit', 'ngo', 'charity', 'volunteer_organization'],
      OpportunityCategory.education: ['school', 'university', 'library', 'museum', 'science_center'],
      OpportunityCategory.skill_building: ['training_center', 'bootcamp', 'coding_bootcamp'],
      OpportunityCategory.internship: ['company', 'startup', 'tech_company'],
      OpportunityCategory.competitions: ['hackathon', 'competition', 'olympiad'],
      OpportunityCategory.mentorship: ['mentor', 'coaching', 'tutoring'],
    };
    
    final types = <String>[];
    for (final cat in categories) {
      types.addAll(typeMap[cat] ?? []);
    }
    return types.toSet().toList();
  }
  
  List<PlaceOpportunity> _getMockPlaceOpportunities(
    double lat, double lng, double radiusKm, StudentProfile student) {
    return [
      PlaceOpportunity(
        placeId: 'place_atl_lab',
        name: 'Atal Tinkering Lab - DPS RK Puram',
        formattedAddress: 'DPS RK Puram, Sector 12, New Delhi',
        latitude: 28.5562,
        longitude: 77.1845,
        types: ['school', 'technology_center'],
        rating: 4.5,
        userRatingsTotal: 42,
        website: 'https://dpsrkp.net/atl-lab',
        distanceKm: 3.2,
        cachedAt: DateTime.now(),
        source: 'google_places',
        category: OpportunityCategory.education,
        relevanceScore: 95,
      ),
      PlaceOpportunity(
        placeId: 'place_museum',
        name: 'National Science Centre',
        formattedAddress: 'Bhairon Marg, Pragati Maidan, New Delhi',
        latitude: 28.6139,
        longitude: 77.2425,
        types: ['museum', 'science_center'],
        rating: 4.3,
        userRatingsTotal: 1200,
        website: 'https://nscdelhi.org',
        distanceKm: 8.5,
        cachedAt: DateTime.now(),
        source: 'google_places',
        category: OpportunityCategory.education,
        relevanceScore: 80,
      ),
    ];
  }
  
  /// ATL Lab Discovery (10K+ labs across India)
  Future<List<Opportunity>> _discoverATLLabOpportunities(
    double lat,
    double lng,
    double radiusKm,
    StudentProfile student,
  ) async {
    try {
      // ATL Labs list from AIM (Atal Innovation Mission)
      final atlLabs = await _fetchATLLabs();
      
      return atlLabs
          .where((lab) => _calculateDistance(lat, lng, lab.latitude, lab.longitude) <= radiusKm)
          .map((lab) => lab.toOpportunity(student))
          .toList();
    } catch (e) {
      return _getMockATLOpportunities(lat, lng, radiusKm, student);
    }
  }
  
  Future<List<ATLLabData>> _fetchATLLabs() async {
    // AIM publishes ATL lab lists - would parse from their website/PDF
    return _getMockATLData();
  }
  
  List<Opportunity> _getMockATLOpportunities(
    double lat, double lng, double radiusKm, StudentProfile student) {
    final atlLabs = [
      ATLLabData(
        id: 'atl_dps_rkp',
        name: 'Atal Tinkering Lab - DPS RK Puram',
        schoolName: 'Delhi Public School RK Puram',
        address: 'Sector 12, RK Puram, New Delhi',
        latitude: 28.5562,
        longitude: 77.1845,
        equipment: ['3D Printers', 'Arduino', 'Raspberry Pi', 'Sensors', 'Drones'],
        mentor: 'Mr. Sharma (Physics)',
        operatingHours: 'Mon-Fri 2:30-4:30 PM, Sat 10-1 PM',
        establishedYear: 2018,
      ),
      ATLLabData(
        id: 'atl_kv_janakpuri',
        name: 'ATL - Kendriya Vidyalaya Janakpuri',
        schoolName: 'Kendriya Vidyalaya Janakpuri',
        address: 'Janakpuri, New Delhi',
        latitude: 28.6225,
        longitude: 77.0833,
        equipment: ['3D Printers', 'Robotics Kits', 'Electronics', 'IoT Sensors'],
        mentor: 'Ms. Gupta (CS)',
        operatingHours: 'Mon-Sat 2-5 PM',
        establishedYear: 2019,
      ),
    ];
    
    return atlLabs
        .where((lab) => _calculateDistance(lat, lng, lab.latitude, lab.longitude) <= radiusKm)
        .map((lab) => lab.toOpportunity(student))
        .toList();
  }
  
  List<ATLLabData> _getMockATLData() {
    return [
      ATLLabData(
        id: 'atl_dps_rkp',
        name: 'Atal Tinkering Lab - DPS RK Puram',
        schoolName: 'Delhi Public School RK Puram',
        address: 'Sector 12, RK Puram, New Delhi',
        latitude: 28.5562,
        longitude: 77.1845,
        equipment: ['3D Printers', 'Arduino', 'Raspberry Pi', 'Sensors', 'Drones'],
        mentor: 'Mr. Sharma (Physics)',
        operatingHours: 'Mon-Fri 2:30-4:30 PM, Sat 10-1 PM',
        establishedYear: 2018,
      ),
    ];
  }
  
  /// Competition Calendar Integration
  Future<List<CompetitionOpportunity>> _discoverCompetitionOpportunities(
    StudentProfile student,
  ) async {
    final competitions = await _fetchCompetitionCalendar();
    
    return competitions
        .where((comp) => _isEligibleForCompetition(comp, student))
        .map((comp) => comp.toOpportunity(student))
        .toList();
  }
  
  Future<List<CompetitionData>> _fetchCompetitionCalendar() async {
    // Major Indian competitions with fixed annual cycles
    return _getMockCompetitions();
  }
  
  List<CompetitionData> _getMockCompetitions() {
    return [
      CompetitionData(
        id: 'comp_iris',
        name: 'IRIS National Fair',
        fullName: 'Initiative for Research and Innovation in STEM',
        category: CompetitionCategory.science,
        level: CompetitionLevel.national,
        description: 'National level science fair for school students',
        startDate: DateTime(DateTime.now().year, 10, 1),
        endDate: DateTime(DateTime.now().year, 12, 15),
        registrationDeadline: DateTime(DateTime.now().year, 9, 15),
        registrationOpen: true,
        eligibleGrades: [9, 10, 11, 12],
        eligibleStreams: ['Science'],
        isOnline: false,
        venue: 'New Delhi',
        website: 'https://irisnationalfair.org',
        organizer: 'Department of Science & Technology',
        prizes: ['Cash awards', 'Mentorship', 'International fair qualification'],
        tags: ['prestigious', 'scholarship', 'research'],
        maxTeamSize: 2,
        minTeamSize: 1,
        individualParticipation: true,
      ),
      CompetitionData(
        id: 'comp_kvpy',
        name: 'KVPY Fellowship',
        fullName: 'Kishore Vaigyanik Protsahan Yojana',
        category: CompetitionCategory.research,
        level: CompetitionLevel.national,
        description: 'National fellowship for basic sciences',
        startDate: DateTime(DateTime.now().year, 11, 1),
        endDate: DateTime(DateTime.now().year, 11, 1),
        registrationDeadline: DateTime(DateTime.now().year, 9, 30),
        registrationOpen: true,
        eligibleGrades: [11, 12],
        eligibleStreams: ['Science'],
        isOnline: true,
        website: 'https://kvpy.iisc.ac.in',
        organizer: 'IISc Bangalore',
        prizes: ['Fellowship Rs 80,000/year', 'Contingency grant', 'Summer camp'],
        tags: ['prestigious', 'fellowship', 'scholarship'],
        individualParticipation: true,
      ),
      CompetitionData(
        id: 'comp_sof_imo',
        name: 'SOF International Mathematics Olympiad',
        category: CompetitionCategory.mathematics,
        level: CompetitionLevel.international,
        description: 'International math olympiad for school students',
        startDate: DateTime(DateTime.now().year, 12, 1),
        endDate: DateTime(DateTime.now().year, 12, 15),
        registrationDeadline: DateTime(DateTime.now().year, 10, 31),
        registrationOpen: true,
        eligibleGrades: [9, 10, 11, 12],
        eligibleStreams: ['Science', 'Commerce'],
        isOnline: false,
        website: 'https://sofworld.org',
        organizer: 'Science Olympiad Foundation',
        prizes: ['Medals', 'Certificates', 'Cash prizes'],
        tags: ['international', 'mathematics'],
        individualParticipation: true,
      ),
      CompetitionData(
        id: 'comp_google_codein',
        name: 'Google Code-in',
        category: CompetitionCategory.coding,
        level: CompetitionLevel.international,
        description: 'Open source coding competition for pre-university students',
        startDate: DateTime(DateTime.now().year, 11, 15),
        endDate: DateTime(DateTime.now().year + 1, 1, 15),
        registrationDeadline: DateTime(DateTime.now().year, 11, 1),
        registrationOpen: true,
        eligibleGrades: [9, 10, 11, 12],
        isOnline: true,
        website: 'https://codein.withgoogle.com',
        organizer: 'Google',
        prizes: ['T-shirt', 'Certificate', 'Trip to Google HQ'],
        tags: ['coding', 'open source', 'international'],
        individualParticipation: true,
      ),
    ];
  }
  
  bool _isEligibleForCompetition(CompetitionData comp, StudentProfile student) {
    if (!comp.registrationOpen) return false;
    if (comp.eligibleGrades.isNotEmpty && !comp.eligibleGrades.contains(student.grade)) return false;
    if (comp.eligibleStreams.isNotEmpty && !comp.eligibleStreams.contains(student.stream)) return false;
    return true;
  }
  
  /// UDISE+ School Opportunities
  Future<List<Opportunity>> _discoverUDISESchoolOpportunities(
    StudentProfile student,
  ) async {
    // Would query UDISE+ API for school facilities, clubs, teachers
    // For now return mock in-school opportunities
    return _getMockSchoolOpportunities(student);
  }
  
  List<Opportunity> _getMockSchoolOpportunities(StudentProfile student) {
    return [
      Opportunity(
        id: 'school_robotics_club',
        title: 'Robotics Club (ATL Lab)',
        type: 'In-School Club',
        tier: 2,
        category: 'Technology',
        description: 'School robotics club with access to ATL Lab equipment',
        location: 'School ATL Lab',
        distanceKm: 0,
        matchScore: 0.9,
        schedule: 'Tue/Thu 2:30-4:30 PM',
        tags: ['in-school', 'robotics', 'ATL'],
      ),
      Opportunity(
        id: 'school_mun',
        title: 'Model UN Club',
        type: 'In-School Club',
        tier: 2,
        category: 'Leadership',
        description: 'MUN club with 3 conferences per year',
        location: 'School Library',
        distanceKm: 0,
        matchScore: 0.85,
        schedule: 'Wed 2:30-4:00 PM',
        tags: ['in-school', 'MUN', 'leadership'],
      ),
    ];
  }
  
  /// Score and rank all opportunities
  List<Opportunity> _scoreAndRankOpportunities(
    List<Opportunity> opportunities,
    StudentProfile student,
  ) {
    for (final opp in opportunities) {
      opp.matchScore = _calculateMatchScore(opp, student);
    }
    
    // Sort by match score descending
    opportunities.sort((a, b) => b.matchScore.compareTo(a.matchScore));
    
    return opportunities;
  }
  
  double _calculateMatchScore(Opportunity opp, StudentProfile student) {
    double score = 0;
    
    // Base score from opportunity's relevance
    score += (opp.relevanceScore ?? 50) * 0.4;
    
    // Distance factor (closer is better)
    if (opp.distanceKm != null) {
      if (opp.distanceKm! <= 2) score += 20;
      else if (opp.distanceKm! <= 5) score += 15;
      else if (opp.distanceKm! <= 10) score += 10;
      else if (opp.distanceKm! <= 25) score += 5;
    }
    
    // Tier bonus
    score += (4 - opp.tier) * 5;
    
    // Category alignment with student interests
    if (student.targetMajor.toLowerCase().contains('computer') && 
        opp.category.toLowerCase().contains('tech')) {
      score += 10;
    }
    
    // Schedule compatibility (simplified)
    score += 5;
    
    return score.clamp(0, 100);
  }
  
  double _calculateDistance(double lat1, double lng1, double lat2, double lng2) {
    const double earthRadius = 6371;
    final dLat = _toRadians(lat2 - lat1);
    final dLng = _toRadians(lng2 - lng1);
    final a = sin(dLat/2) * sin(dLat/2) +
        cos(_toRadians(lat1)) * cos(_toRadians(lat2)) *
        sin(dLng/2) * sin(dLng/2);
    final c = 2 * atan2(sqrt(a), sqrt(1-a));
    return earthRadius * c;
  }
  
  double _toRadians(double deg) => deg * (pi / 180);
  
  void _cacheResults(double lat, double lng, List<Opportunity> opportunities) {
    final key = '${lat.toStringAsFixed(4)},${lng.toStringAsFixed(4)}';
    _cache[key] = CachedOpportunityData(
      opportunities: opportunities,
      timestamp: DateTime.now(),
    );
  }
  
  /// Get cached opportunities if available
  List<Opportunity>? getCachedOpportunities(double lat, double lng) {
    final key = '${lat.toStringAsFixed(4)},${lng.toStringAsFixed(4)}';
    final cached = _cache[key];
    if (cached != null && DateTime.now().difference(cached.timestamp) < CACHE_TTL) {
      return cached.opportunities;
    }
    return null;
  }
  
  void dispose() {
    _httpClient.close();
  }
}

@immutable
class CachedOpportunityData {
  final List<Opportunity> opportunities;
  final DateTime timestamp;
  
  const CachedOpportunityData({
    required this.opportunities,
    required this.timestamp,
  });
}

@immutable
class NGOData {
  final String id;
  final String name;
  final String sector;
  final String address;
  final double latitude;
  final double longitude;
  final String contactEmail;
  final String contactPhone;
  final String website;
  final int establishedYear;
  final String darpanId;
  final List<String> activities;
  final int volunteerCapacity;
  
  const NGOData({
    required this.id,
    required this.name,
    required this.sector,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.contactEmail,
    required this.contactPhone,
    required this.website,
    required this.establishedYear,
    required this.darpanId,
    required this.activities,
    required this.volunteerCapacity,
  });
  
  NGOOpportunity toOpportunity(StudentProfile student) {
    return NGOOpportunity(
      id: id,
      name: name,
      sector: sector,
      address: address,
      latitude: latitude,
      longitude: longitude,
      contactEmail: contactEmail,
      contactPhone: contactPhone,
      website: website,
      darpanId: darpanId,
      activities: activities,
      volunteerCapacity: volunteerCapacity,
      matchScore: 0, // Will be calculated later
      distanceKm: 0, // Will be calculated later
    );
  }
}

@immutable
class ATLLabData {
  final String id;
  final String name;
  final String schoolName;
  final String address;
  final double latitude;
  final double longitude;
  final List<String> equipment;
  final String mentor;
  final String operatingHours;
  final int establishedYear;
  
  const ATLLabData({
    required this.id,
    required this.name,
    required this.schoolName,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.equipment,
    required this.mentor,
    required this.operatingHours,
    required this.establishedYear,
  });
  
  Opportunity toOpportunity(StudentProfile student) {
    return Opportunity(
      id: 'atl_$id',
      title: name,
      type: 'ATL Lab',
      tier: 2,
      category: 'Technology',
      description: 'Atal Tinkering Lab with ${equipment.join(", ")}. Mentor: $mentor',
      location: address,
      distanceKm: 0,
      matchScore: 0,
      schedule: operatingHours,
      tags: ['ATL', 'in-school', 'technology', equipment.join(',')],
    );
  }
}

@immutable
class CompetitionData {
  final String id;
  final String name;
  final String fullName;
  final CompetitionCategory category;
  final CompetitionLevel level;
  final String description;
  final DateTime startDate;
  final DateTime endDate;
  final DateTime registrationDeadline;
  final bool registrationOpen;
  final List<int> eligibleGrades;
  final List<String> eligibleStreams;
  final bool isOnline;
  final String? venue;
  final String? city;
  final String? state;
  final String? country;
  final String website;
  final String organizer;
  final List<String> prizes;
  final List<String> tags;
  final int? maxTeamSize;
  final int? minTeamSize;
  final bool individualParticipation;
  
  const CompetitionData({
    required this.id,
    required this.name,
    required this.fullName,
    required this.category,
    required this.level,
    required this.description,
    required this.startDate,
    required this.endDate,
    required this.registrationDeadline,
    required this.registrationOpen,
    required this.eligibleGrades,
    required this.eligibleStreams,
    required this.isOnline,
    this.venue,
    this.city,
    this.state,
    this.country,
    required this.website,
    required this.organizer,
    required this.prizes,
    required this.tags,
    this.maxTeamSize,
    this.minTeamSize,
    required this.individualParticipation,
  });
  
  CompetitionOpportunity toOpportunity(StudentProfile student) {
    return CompetitionOpportunity(
      id: id,
      title: name,
      fullName: fullName,
      category: category,
      level: level,
      description: description,
      startDate: startDate,
      endDate: endDate,
      registrationDeadline: registrationDeadline,
      registrationOpen: registrationOpen,
      eligibleGrades: eligibleGrades,
      eligibleStreams: eligibleStreams,
      isOnline: isOnline,
      venue: venue,
      website: website,
      organizer: organizer,
      prizes: prizes,
      tags: tags,
      maxTeamSize: maxTeamSize,
      minTeamSize: minTeamSize,
      individualParticipation: individualParticipation,
      matchScore: 0,
      distanceKm: isOnline ? 0 : null,
    );
  }
}

enum CompetitionCategory {
  science,
  mathematics,
  coding,
  research,
  innovation,
  general,
}