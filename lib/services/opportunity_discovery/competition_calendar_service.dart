import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../models/opportunity/competition.dart';

part 'competition_calendar_service.g.dart';

@riverpod
CompetitionCalendarService competitionCalendarService(CompetitionCalendarServiceRef ref) {
  return CompetitionCalendarService();
}

class CompetitionCalendarService {
  static const String _boxName = 'competition_calendar_cache';
  static const Duration _cacheDuration = Duration(days: 1);
  static const int _maxRetries = 3;
  
  static const List<String> _dataSources = [
    'https://api.indiasciencefest.org/competitions',
    'https://api.scienceolympiad.in/events',
    'https://api.inspireawards.gov.in/competitions',
    'https://api.ntse.org.in/exams',
    'https://api.kvpy.org.in/exams',
    'https://api.iitb.ac.in/techfest/competitions',
    'https://api.iitk.ac.in/techkriti/events',
    'https://api.iitm.ac.in/shaastra/competitions',
    'https://api.bits-pilani.ac.in/apogee/events',
    'https://api.iisc.ac.in/pravega/competitions',
    'https://api.codechef.com/competitions',
    'https://api.hackerearth.com/challenges',
    'https://api.hackerrank.com/contests',
    'https://api.leetcode.com/contest',
    'https://api.atcoder.jp/contests',
    'https://api.google.com/codein',
    'https://api.microsoft.com/imaginecup',
    'https://api.intel.com/isef',
    'https://api.google.com/sciencefair',
    'https://api.nasa.gov/challenges',
    'https://api.isro.gov.in/competitions',
    'https://api.drdo.gov.in/competitions',
    'https://api.cbse.gov.in/competitions',
    'https://api.ncert.nic.in/competitions',
  ];
  
  Box<dynamic>? _cacheBox;
  bool _isInitialized = false;
  Timer? _refreshTimer;
  
  static final CompetitionCalendarService _instance = CompetitionCalendarService._internal();
  factory CompetitionCalendarService() => _instance;
  CompetitionCalendarService._internal();

  Future<void> initialize() async {
    if (_isInitialized) return;
    
    await Hive.initFlutter();
    if (!Hive.isAdapterRegistered(CompetitionAdapter().typeId)) {
      Hive.registerAdapter(CompetitionAdapter());
    }
    _cacheBox = await Hive.openBox<dynamic>(_boxName);
    _isInitialized = true;
    
    _startPeriodicRefresh();
  }
  
  void _startPeriodicRefresh() {
    _refreshTimer?.cancel();
    _refreshTimer = Timer.periodic(const Duration(hours: 6), (_) {
      refreshCache();
    });
  }

  Future<List<Competition>> getUpcomingCompetitions({
    int limit = 20 = 50,
    CompetitionCategory? category,
    CompetitionLevel? level,
    DateTime? fromDate,
    DateTime? toDate,
    String? state,
    bool onlineOnly = false,
    bool useCache = true,
  }) async {
    await initialize();
    
    final cacheKey = _buildCacheKey(limit, category, level, fromDate, toDate, state, onlineOnly);
    
    if (useCache) {
      final cached = _getCachedResults(cacheKey);
      if (cached != null && !_isCacheExpired(cached)) {
        return _filterAndSortCompetitions(cached, limit, category, level, fromDate, toDate, state, onlineOnly);
      }
    }

    final competitions = await _fetchAllCompetitions();
    await _cacheResults('all_competitions', competitions);
    
    return _filterAndSortCompetitions(competitions, limit, category, level, fromDate, toDate, state, onlineOnly);
  }

  Future<List<Competition>> getCompetitionsByCategory(CompetitionCategory category, {int limit = 30}) async {
    return getUpcomingCompetitions(limit: limit, category: category);
  }

  Future<List<Competition>> getCompetitionsByLevel(CompetitionLevel level, {int limit = 30}) async {
    return getUpcomingCompetitions(limit: limit, level: level);
  }

  Future<List<Competition>> getCompetitionsNearLocation({
    required double latitude,
    required double longitude,
    double radiusKm = 100.0,
    int limit = 20,
  }) async {
    final competitions = await getUpcomingCompetitions(limit: 200);
    
    return competitions
        .where((c) => c.latitude != null && c.longitude != null)
        .where((c) => _calculateDistance(latitude, longitude, c.latitude!, c.longitude!) <= radiusKm)
        .take(limit)
        .toList();
  }

  Future<List<Competition>> getOnlineCompetitions({int limit = 30}) async {
    return getUpcomingCompetitions(limit: limit, onlineOnly: true);
  }

  Future<List<Competition>> getCompetitionsForGrade(int grade, {int limit = 30}) async {
    final competitions = await getUpcomingCompetitions(limit: 200);
    
    return competitions
        .where((c) => c.eligibleGrades.contains(grade))
        .take(limit)
        .toList();
  }

  Future<List<Competition>> getCompetitionsForStream(String stream, {int limit = 30}) async {
    final competitions = await getUpcomingCompetitions(limit: 200);
    
    return competitions
        .where((c) => c.eligibleStreams.contains(stream))
        .take(limit)
        .toList();
  }

  Future<Competition?> getCompetitionDetails(String competitionId) async {
    await initialize();
    
    final cacheKey = 'competition_detail_$competitionId';
    final cached = _getCachedResults(cacheKey);
    if (cached != null && cached.isNotEmpty) {
      return cached.first;
    }

    try {
      for (final source in _dataSources) {
        final response = await http.get(
          Uri.parse('$source/$competitionId'),
          headers: {'Accept': 'application/json'},
        ).timeout(const Duration(seconds: 15));

        if (response.statusCode == 200) {
          final data = json.decode(response.body) as Map<String, dynamic>;
          final competition = Competition.fromJson(data['data']);
          
          await _cacheResults(cacheKey, [competition]);
          return competition;
        }
      }
    } catch (e) {
      debugPrint('Error fetching competition details: $e');
    }
    return null;
  }

  Future<List<Competition>> getRegistrationOpenCompetitions({int limit = 30}) async {
    final competitions = await getUpcomingCompetitions(limit: 200);
    final now = DateTime.now();
    
    return competitions
        .where((c) => c.registrationOpen && c.registrationDeadline.isAfter(now))
        .take(limit)
        .toList();
  }

  Future<List<Competition>> getDeadlineApproachingCompetitions({int days = 7, int limit = 20}) async {
    final competitions = await getUpcomingCompetitions(limit: 200);
    final deadline = DateTime.now().add(Duration(days: days));
    
    return competitions
        .where((c) => c.registrationDeadline.isBefore(deadline) && c.registrationDeadline.isAfter(DateTime.now()))
        .take(limit)
        .toList();
  }

  Future<List<Competition>> getOngoingCompetitions({int limit = 20}) async {
    final competitions = await getUpcomingCompetitions(limit: 200);
    final now = DateTime.now();
    
    return competitions
        .where((c) => c.startDate.isBefore(now) && c.endDate.isAfter(now))
        .take(limit)
        .toList();
  }

  Future<Map<CompetitionCategory, int>> getCompetitionCountsByCategory() async {
    final competitions = await getUpcomingCompetitions(limit: 500);
    final counts = <CompetitionCategory, int>{};
    
    for (final comp in competitions) {
      counts[comp.category] = (counts[comp.category] ?? 0) + 1;
    }
    
    return counts;
  }

  Future<List<String>> getAvailableCategories() async {
    final competitions = await getUpcomingCompetitions(limit: 500);
    return competitions.map((c) => c.category.name).toSet().toList();
  }

  Future<void> refreshCache() async {
    await initialize();
    
    try {
      final competitions = await _fetchAllCompetitions(forceRefresh: true);
      await _cacheResults('all_competitions', competitions);
    } catch (e) {
      debugPrint('Error refreshing competition cache: $e');
    }
  }

  Future<void> clearCache() async {
    await _cacheBox?.clear();
  }

  List<Competition> _filterAndSortCompetitions(
    List<Competition> competitions,
    int limit,
    CompetitionCategory? category,
    CompetitionLevel? level,
    DateTime? fromDate,
    DateTime? toDate,
    String? state,
    bool onlineOnly,
  ) {
    var filtered = competitions.where((c) {
      if (category != null && c.category != category) return false;
      if (level != null && c.level != level) return false;
      if (fromDate != null && c.startDate.isBefore(fromDate)) return false;
      if (toDate != null && c.startDate.isAfter(toDate)) return false;
      if (state != null && c.state != null && !c.state!.toLowerCase().contains(state.toLowerCase())) return false;
      if (onlineOnly && !c.isOnline) return false;
      return true;
    }).toList();
    
    filtered.sort((a, b) {
      final now = DateTime.now();
      final aIsUpcoming = a.startDate.isAfter(now);
      final bIsUpcoming = b.startDate.isAfter(now);
      
      if (aIsUpcoming != bIsUpcoming) {
        return aIsUpcoming ? -1 : 1;
      }
      
      if (a.registrationDeadline != b.registrationDeadline) {
        return a.registrationDeadline.compareTo(b.registrationDeadline);
      }
      
      return a.startDate.compareTo(b.startDate);
    });
    
    return filtered.take(limit).toList();
  }

  Future<List<Competition>> _fetchAllCompetitions({bool forceRefresh = false}) async {
    final allCompetitions = <Competition>[];
    
    for (final source in _dataSources) {
      try {
        final competitions = await _fetchFromSource(source);
        allCompetitions.addAll(competitions);
      } catch (e) {
        debugPrint('Error fetching from $source: $e');
      }
    }
    
    final fallbackCompetitions = _getFallbackCompetitions();
    allCompetitions.addAll(fallbackCompetitions);
    
    final uniqueCompetitions = <String, Competition>{};
    for (final comp in allCompetitions) {
      if (!uniqueCompetitions.containsKey(comp.id)) {
        uniqueCompetitions[comp.id] = comp;
      }
    }
    
    return uniqueCompetitions.values.toList();
  }

  Future<List<Competition>> _fetchFromSource(String source) async {
    int attempt = 0;
    Exception? lastError;
    
    while (attempt < _maxRetries) {
      try {
        final response = await http.get(
          Uri.parse(source),
          headers: {'Accept': 'application/json', 'User-Agent': 'ProfileForge/1.0'},
        ).timeout(const Duration(seconds: 20));

        if (response.statusCode == 200) {
          final data = json.decode(response.body) as Map<String, dynamic>;
          final results = data['data'] as List<dynamic>? ?? data['competitions'] as List<dynamic>? ?? [];
          
          return results.map((e) => Competition.fromJson(e as Map<String, dynamic>)).toList();
        } else if (response.statusCode == 429) {
          await Future.delayed(Duration(seconds: 2 * (attempt + 1)));
          attempt++;
          continue;
        }
        
        throw Exception('HTTP ${response.statusCode}');
      } catch (e) {
        lastError = e is Exception ? e : Exception(e.toString());
        attempt++;
        if (attempt < _maxRetries) {
          await Future.delayed(Duration(seconds: attempt * 2));
        }
      }
    }
    
    throw lastError ?? Exception('Max retries exceeded for $source');
  }

  String _buildCacheKey(
    int limit,
    CompetitionCategory? category,
    CompetitionLevel? level,
    DateTime? fromDate,
    DateTime? toDate,
    String? state,
    bool onlineOnly,
  ) {
    return 'comp_${limit}_${category?.name ?? 'all'}_${level?.name ?? 'all'}_'
           '${fromDate?.millisecondsSinceEpoch ?? 'none'}_'
           '${toDate?.millisecondsSinceEpoch ?? 'none'}_'
           '${state ?? 'all'}_${onlineOnly}';
  }

  List<Competition>? _getCachedResults(String key) {
    final data = _cacheBox?.get(key);
    if (data == null) return null;
    
    try {
      final list = (data as List).cast<Map<String, dynamic>>();
      return list.map((e) => Competition.fromJson(e)).toList();
    } catch (e) {
      debugPrint('Cache parse error: $e');
      return null;
    }
  }

  bool _isCacheExpired(List<Competition> cached) {
    if (cached.isEmpty) return true;
    final first = cached.first;
    if (first.cachedAt == null) return true;
    return DateTime.now().difference(first.cachedAt!) > _cacheDuration;
  }

  Future<void> _cacheResults(String key, List<Competition> results) async {
    if (_cacheBox == null) return;
    
    final data = results.map((e) => e.toJson()).toList();
    await _cacheBox!.put(key, data);
  }

  double _calculateDistance(double lat1, double lng1, double lat2, double lng2) {
    const double earthRadius = 6371.0;
    final dLat = _toRadians(lat2 - lat1);
    final dLng = _toRadians(lng2 - lng1);
    final a = (sin(dLat / 2) * sin(dLat / 2)) +
        cos(_toRadians(lat1)) * cos(_toRadians(lat2)) *
        (sin(dLng / 2) * sin(dLng / 2));
    final c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return earthRadius * c;
  }

  double _toRadians(double deg) => deg * (3.141592653589793 / 180.0);

  List<Competition> _getFallbackCompetitions() {
    final now = DateTime.now();
    return [
      Competition(
        id: 'inspire_awards_${now.year}',
        title: 'INSPIRE Awards - MANAK',
        description: 'Innovation in Science Pursuit for Inspired Research - Million Minds Augmenting National Aspiration and Knowledge',
        category: CompetitionCategory.science,
        level: CompetitionLevel.national,
        startDate: DateTime(now.year, 7, 1),
        endDate: DateTime(now.year, 10, 31),
        registrationDeadline: DateTime(now.year, 8, 31),
        registrationOpen: true,
        eligibleGrades: [6, 7, 8, 9, 10],
        eligibleStreams: ['Science'],
        isOnline: false,
        website: 'https://www.inspireawards-dst.gov.in/',
        organizer: 'Department of Science & Technology, Govt of India',
        prizes: ['₹10,000 per student', 'Mentorship', 'National Exhibition'],
        tags: ['innovation', 'science', 'research', 'school'],
        cachedAt: now,
        source: 'fallback',
      ),
      Competition(
        id: 'ntse_${now.year}',
        title: 'National Talent Search Examination (NTSE)',
        description: 'National level scholarship exam for Class 10 students',
        category: CompetitionCategory.academic,
        level: CompetitionLevel.national,
        startDate: DateTime(now.year, 11, 1),
        endDate: DateTime(now.year, 11, 30),
        registrationDeadline: DateTime(now.year, 9, 30),
        registrationOpen: true,
        eligibleGrades: [10],
        eligibleStreams: ['All'],
        isOnline: false,
        website: 'https://ncert.nic.in/ntse.php',
        organizer: 'NCERT',
        prizes: ['Scholarship ₹1250/month', 'Laptop', 'Certificate'],
        tags: ['scholarship', 'exam', 'class10', 'national'],
        cachedAt: now,
        source: 'fallback',
      ),
      Competition(
        id: 'kvpy_${now.year}',
        title: 'Kishore Vaigyanik Protsahan Yojana (KVPY)',
        description: 'National fellowship program for basic sciences',
        category: CompetitionCategory.science,
        level: CompetitionLevel.national,
        startDate: DateTime(now.year, 11, 1),
        endDate: DateTime(now.year, 11, 30),
        registrationDeadline: DateTime(now.year, 9, 15),
        registrationOpen: true,
        eligibleGrades: [11, 12],
        eligibleStreams: ['Science'],
        isOnline: true,
        website: 'https://kvpy.iisc.ac.in/',
        organizer: 'IISc Bangalore',
        prizes: ['Fellowship ₹5000-7000/month', 'Contingency grant', 'Summer camp'],
        tags: ['fellowship', 'science', 'research', 'iisc'],
        cachedAt: now,
        source: 'fallback',
      ),
      Competition(
        id: 'google_code_in_${now.year}',
        title: 'Google Code-in',
        description: 'Global online contest for pre-university students to contribute to open source',
        category: CompetitionCategory.coding,
        level: CompetitionLevel.international,
        startDate: DateTime(now.year, 12, 1),
        endDate: DateTime(now.year + 1, 1, 31),
        registrationDeadline: DateTime(now.year, 11, 15),
        registrationOpen: true,
        eligibleGrades: [9, 10, 11, 12],
        eligibleStreams: ['All'],
        isOnline: true,
        website: 'https://codein.withgoogle.com/',
        organizer: 'Google',
        prizes: ['T-shirt', 'Certificate', 'Trip to Google HQ'],
        tags: ['opensource', 'coding', 'global', 'google'],
        cachedAt: now,
        source: 'fallback',
      ),
      Competition(
        id: 'intel_isef_${now.year}',
        title: 'Regeneron International Science and Engineering Fair (ISEF)',
        description: 'World\'s largest international pre-college science competition',
        category: CompetitionCategory.research,
        level: CompetitionLevel.international,
        startDate: DateTime(now.year, 5, 1),
        endDate: DateTime(now.year, 5, 31),
        registrationDeadline: DateTime(now.year, 1, 31),
        registrationOpen: true,
        eligibleGrades: [9, 10, 11, 12],
        eligibleStreams: ['Science'],
        isOnline: false,
        website: 'https://www.societyforscience.org/isef/',
        organizer: 'Society for Science',
        prizes: ['\$75,000 top prize', 'Scholarships', 'Internships', 'Trip'],
        tags: ['research', 'science_fair', 'international', 'prestigious'],
        cachedAt: now,
        source: 'fallback',
      ),
      Competition(
        id: 'google_science_fair_${now.year}',
        title: 'Google Science Fair',
        description: 'Global online science and engineering competition for students 13-18',
        category: CompetitionCategory.science,
        level: CompetitionLevel.international,
        startDate: DateTime(now.year, 9, 1),
        endDate: DateTime(now.year, 12, 31),
        registrationDeadline: DateTime(now.year, 10, 31),
        registrationOpen: true,
        eligibleGrades: [8, 9, 10, 11, 12],
        eligibleStreams: ['Science'],
        isOnline: true,
        website: 'https://www.googlesciencefair.com/',
        organizer: 'Google',
        prizes: ['\$50,000 scholarship', 'Trip to Google', 'Mentorship'],
        tags: ['science', 'global', 'online', 'google'],
        cachedAt: now,
        source: 'fallback',
      ),
      Competition(
        id: 'cbse_science_exhibition_${now.year}',
        title: 'CBSE Science Exhibition',
        description: 'Annual science exhibition for CBSE affiliated schools',
        category: CompetitionCategory.science,
        level: CompetitionLevel.national,
        startDate: DateTime(now.year, 11, 1),
        endDate: DateTime(now.year, 12, 31),
        registrationDeadline: DateTime(now.year, 10, 15),
        registrationOpen: true,
        eligibleGrades: [6, 7, 8, 9, 10, 11, 12],
        eligibleStreams: ['Science'],
        isOnline: false,
        website: 'https://cbseacademic.nic.in/',
        organizer: 'CBSE',
        prizes: ['Certificates', 'Medals', 'Cash prizes', 'National level entry'],
        tags: ['cbse', 'school', 'exhibition', 'science'],
        cachedAt: now,
        source: 'fallback',
      ),
      Competition(
        id: 'atl_marathon_${now.year}',
        title: 'ATL Marathon',
        description: 'National level innovation challenge for ATL schools',
        category: CompetitionCategory.innovation,
        level: CompetitionLevel.national,
        startDate: DateTime(now.year, 10, 1),
        endDate: DateTime(now.year + 1, 3, 31),
        registrationDeadline: DateTime(now.year, 11, 30),
        registrationOpen: true,
        eligibleGrades: [6, 7, 8, 9, 10, 11, 12],
        eligibleStreams: ['All'],
        isOnline: true,
        website: 'https://aim.gov.in/atl-marathon',
        organizer: 'Atal Innovation Mission, NITI Aayog',
        prizes: ['Funding', 'Mentorship', 'Incubation', 'National showcase'],
        tags: ['atl', 'innovation', 'tinkering', 'aim'],
        cachedAt: now,
        source: 'fallback',
      ),
      Competition(
        id: 'codechef_snackdown_${now.year}',
        title: 'CodeChef SnackDown',
        description: 'Multi-round programming competition for students and professionals',
        category: CompetitionCategory.coding,
        level: CompetitionLevel.international,
        startDate: DateTime(now.year, 6, 1),
        endDate: DateTime(now.year, 10, 31),
        registrationDeadline: DateTime(now.year, 5, 31),
        registrationOpen: true,
        eligibleGrades: [9, 10, 11, 12],
        eligibleStreams: ['All'],
        isOnline: true,
        website: 'https://www.codechef.com/snackdown',
        organizer: 'CodeChef',
        prizes: ['Cash prizes', 'Internships', 'Job offers', 'Goodies'],
        tags: ['coding', 'programming', 'competitive', 'codechef'],
        cachedAt: now,
        source: 'fallback',
      ),
      Competition(
        id: 'hackerearth_hackathon_${now.year}',
        title: 'HackerEarth Hackathons',
        description: 'Regular online hackathons for developers and students',
        category: CompetitionCategory.hackathon,
        level: CompetitionLevel.international,
        startDate: now,
        endDate: now.add(const Duration(days: 365)),
        registrationDeadline: now.add(const Duration(days: 30)),
        registrationOpen: true,
        eligibleGrades: [9, 10, 11, 12],
        eligibleStreams: ['All'],
        isOnline: true,
        website: 'https://www.hackerearth.com/challenges/hackathon/',
        organizer: 'HackerEarth',
        prizes: ['Cash prizes', 'Job offers', 'Mentorship', 'Incubation'],
        tags: ['hackathon', 'coding', 'online', 'regular'],
        cachedAt: now,
        source: 'fallback',
      ),
    ];
  }

  void dispose() {
    _refreshTimer?.cancel();
    _cacheBox?.close();
  }
}