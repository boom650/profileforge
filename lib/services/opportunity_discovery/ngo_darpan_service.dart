import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter/foundation.dart';

import 'package:profileforge/lib/models/opportunity/ngo_opportunity.dart';
import 'package:profileforge/lib/models/user/user_profile.dart';

part 'ngo_darpan_service.g.dart';

class NGODarpanService extends ChangeNotifier {
  static const String _baseUrl = 'https://ngodarpan.gov.in/api';
  static const String _boxName = 'ngo_darpan_cache';
  
  static const Duration _cacheDuration = Duration(days: 1);
  static const int _pageSize = 50;
  static const int _maxRetries = 3;
  
  Box<dynamic>? _cacheBox;
  bool _isInitialized = false;
  
  static final NGODarpanService _instance = NGODarpanService._internal();
  factory NGODarpanService() => _instance;
  NGODarpanService._internal();

  Future<void> initialize() async {
    if (_isInitialized) return;
    
    await Hive.initFlutter();
    if (!Hive.isAdapterRegistered(NGOOpportunityAdapter().typeId)) {
      Hive.registerAdapter(NGOOpportunityAdapter());
    }
    _cacheBox = await Hive.openBox<dynamic>(_boxName);
    _isInitialized = true;
  }

  Future<List<NGOOpportunity>> searchNearbyNGOs({
    required UserProfile userProfile,
    required double latitude,
    required double longitude,
    double radiusKm = 25.0,
    String? sector,
    int page = 1,
    bool useCache = true,
  }) async {
    await initialize();
    
    final cacheKey = _buildCacheKey(latitude, longitude, radiusKm, sector, page);
    
    if (useCache) {
      final cached = _getCachedResults(cacheKey);
      if (cached != null && !_isCacheExpired(cached)) {
        notifyListeners();
        return cached;
      }
    }

    final queryParams = <String, String>{
      'lat': latitude.toString(),
      'lng': longitude.toString(),
      'radius': radiusKm.toString(),
      'page': page.toString(),
      'limit': _pageSize.toString(),
    };
    
    if (sector != null && sector.isNotEmpty) {
      queryParams['sector'] = sector;
    }

    if (userProfile.interests.isNotEmpty) {
      queryParams['interests'] = userProfile.interests.join(',');
    }
    
    if (userProfile.grade != null) {
      queryParams['grade'] = userProfile.grade.toString();
    }

    final results = await _fetchWithRetry(queryParams);
    final opportunities = _parseNGOResponse(results, latitude, longitude);
    
    if (useCache) {
      await _cacheResults(cacheKey, opportunities);
    }
    
    notifyListeners();
    return opportunities;
  }

  Future<List<NGOOpportunity>> searchBySector({
    required String sector,
    required String state,
    String? district,
    int page = 1,
  }) async {
    await initialize();
    
    final queryParams = <String, String>{
      'sector': sector,
      'state': state,
      'page': page.toString(),
      'limit': _pageSize.toString(),
    };
    
    if (district != null) {
      queryParams['district'] = district;
    }

    final results = await _fetchWithRetry(queryParams);
    return _parseNGOResponse(results, 0, 0);
  }

  Future<NGOOpportunity?> getNGODetails(String ngoId) async {
    await initialize();
    
    final cacheKey = 'ngo_detail_$ngoId';
    final cached = _getCachedResults(cacheKey);
    if (cached != null && cached.isNotEmpty) {
      return cached.first;
    }

    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/ngo/$ngoId'),
        headers: {'Accept': 'application/json'},
      ).timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;
        final opportunity = NGOOpportunity.fromJson(data['data']);
        
        await _cacheResults('ngo_detail_$ngoId', [opportunity]);
        return opportunity;
      }
    } catch (e) {
      debugPrint('Error fetching NGO details: $e');
    }
    return null;
  }

  Future<List<NGOOpportunity>> getVolunteerOpportunities({
    required UserProfile userProfile,
    required double latitude,
    required double longitude,
    int limit = 20,
  }) async {
    await initialize();
    
    final opportunities = await searchNearbyNGOs(
      userProfile: userProfile,
      latitude: latitude,
      longitude: longitude,
      radiusKm: 25.0,
      page: 1,
    );
    
    final volunteerOps = opportunities
        .where((ngo) => ngo.hasVolunteerOpportunities)
        .take(limit)
        .toList();
    
    return volunteerOps;
  }

  Future<List<NGOOpportunity>> getInternshipOpportunities({
    required UserProfile userProfile,
    required double latitude,
    required double longitude,
    int limit = 10,
  }) async {
    await initialize();
    
    final opportunities = await searchNearbyNGOs(
      userProfile: userProfile,
      latitude: latitude,
      longitude: longitude,
      radiusKm: 50.0,
      page: 1,
    );
    
    final internships = opportunities
        .where((ngo) => ngo.hasInternshipOpportunities)
        .take(limit)
        .toList();
    
    return internships;
  }

  Future<List<String>> getAvailableSectors() async {
    await initialize();
    
    const cacheKey = 'ngo_sectors';
    final cached = _getCachedResults(cacheKey);
    if (cached != null && cached.isNotEmpty) {
      return cached.first.sectors ?? [];
    }
    
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/sectors'),
        headers: {'Accept': 'application/json'},
      ).timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;
        final sectors = (data['sectors'] as List<dynamic>)
            .map((e) => e.toString())
            .toList();
        
        final opportunity = NGOOpportunity(
          id: 'sectors_cache',
          name: 'Sectors Cache',
          sectors: sectors,
        );
        await _cacheResults(cacheKey, [opportunity]);
        return sectors;
      }
    } catch (e) {
      debugPrint('Error fetching sectors: $e');
    }
    
    return _getDefaultSectors();
  }

  Future<List<String>> getStates() async {
    await initialize();
    
    const cacheKey = 'ngo_states';
    final cached = _getCachedResults(cacheKey);
    if (cached != null && cached.isNotEmpty) {
      return cached.first.sectors ?? [];
    }
    
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/states'),
        headers: {'Accept': 'application/json'},
      ).timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;
        final states = (data['states'] as List<dynamic>)
            .map((e) => e.toString())
            .toList();
        
        final opportunity = NGOOpportunity(
          id: 'states_cache',
          name: 'States Cache',
          sectors: states,
        );
        await _cacheResults(cacheKey, [opportunity]);
        return states;
      }
    } catch (e) {
      debugPrint('Error fetching states: $e');
    }
    
    return _getDefaultStates();
  }

  Future<List<String>> getDistricts(String state) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/states/$state/districts'),
        headers: {'Accept': 'application/json'},
      ).timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;
        return (data['districts'] as List<dynamic>)
            .map((e) => e.toString())
            .toList();
      }
    } catch (e) {
      debugPrint('Error fetching districts: $e');
    }
    
    return [];
  }

  Future<void> refreshCache() async {
    await initialize();
    await _cacheBox?.clear();
    notifyListeners();
  }

  Future<void> clearCache() async {
    await _cacheBox?.clear();
  }

  String _buildCacheKey(
    double lat, double lng, double radius, 
    String? sector, int page
  ) {
    return 'ngo_${lat.toStringAsFixed(4)}_${lng.toStringAsFixed(4)}_'
           '${radius.toInt()}_${sector ?? 'all'}_p$page';
  }

  List<NGOOpportunity>? _getCachedResults(String key) {
    final data = _cacheBox?.get(key);
    if (data == null) return null;
    
    try {
      final list = (data as List).cast<Map<String, dynamic>>();
      return list.map((e) => NGOOpportunity.fromJson(e)).toList();
    } catch (e) {
      debugPrint('Cache parse error: $e');
      return null;
    }
  }

  bool _isCacheExpired(List<NGOOpportunity> cached) {
    if (cached.isEmpty) return true;
    final first = cached.first;
    if (first.cachedAt == null) return true;
    return DateTime.now().difference(first.cachedAt!) > _cacheDuration;
  }

  Future<void> _cacheResults(String key, List<NGOOpportunity> results) async {
    if (_cacheBox == null) return;
    
    final data = results.map((e) => e.toJson()).toList();
    await _cacheBox!.put(key, data);
  }

  Future<Map<String, dynamic>> _fetchWithRetry(Map<String, String> params) async {
    int attempt = 0;
    Exception? lastError;
    
    while (attempt < _maxRetries) {
      try {
        final uri = Uri.parse('$_baseUrl/search').replace(queryParameters: params);
        final response = await http.get(
          uri,
          headers: {
            'Accept': 'application/json',
            'User-Agent': 'ProfileForge/1.0',
          },
        ).timeout(const Duration(seconds: 30));

        if (response.statusCode == 200) {
          return json.decode(response.body) as Map<String, dynamic>;
        } else if (response.statusCode == 429) {
          await Future.delayed(Duration(seconds: 2 * (attempt + 1)));
          attempt++;
          continue;
        }
        
        throw Exception('HTTP ${response.statusCode}: ${response.body}');
      } catch (e) {
        lastError = e is Exception ? e : Exception(e.toString());
        attempt++;
        if (attempt < _maxRetries) {
          await Future.delayed(Duration(seconds: attempt * 2));
        }
      }
    }
    
    throw lastError ?? Exception('Max retries exceeded');
  }

  List<NGOOpportunity> _parseNGOResponse(
    Map<String, dynamic> response, 
    double userLat, 
    double userLng,
  ) {
    final data = response['data'] as List<dynamic>? ?? [];
    final opportunities = <NGOOpportunity>[];
    
    for (final item in data) {
      try {
        final json = item as Map<String, dynamic>;
        final ngo = NGOOpportunity.fromJson(json);
        
        if (userLat != 0 && userLng != 0 && ngo.latitude != null && ngo.longitude != null) {
          ngo.distanceKm = _calculateDistance(
            userLat, userLng, 
            ngo.latitude!, ngo.longitude!,
          );
        }
        
        opportunities.add(ngo);
      } catch (e) {
        debugPrint('Error parsing NGO: $e');
      }
    }
    
    return opportunities;
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

  List<String> _getDefaultSectors() => [
    'Education', 'Health', 'Women Empowerment', 'Child Welfare',
    'Environment', 'Rural Development', 'Disability', 'Elderly Care',
    'Disaster Relief', 'Animal Welfare', 'Arts & Culture', 'Sports',
    'Youth Affairs', 'Science & Technology', 'Legal Aid', 'Human Rights',
  ];

  List<String> _getDefaultStates() => [
    'Andhra Pradesh', 'Arunachal Pradesh', 'Assam', 'Bihar', 'Chhattisgarh',
    'Goa', 'Gujarat', 'Haryana', 'Himachal Pradesh', 'Jharkhand',
    'Karnataka', 'Kerala', 'Madhya Pradesh', 'Maharashtra', 'Manipur',
    'Meghalaya', 'Mizoram', 'Nagaland', 'Odisha', 'Punjab',
    'Rajasthan', 'Sikkim', 'Tamil Nadu', 'Telangana', 'Tripura',
    'Uttar Pradesh', 'Uttarakhand', 'West Bengal',
    'Andaman and Nicobar', 'Chandigarh', 'Dadra and Nagar Haveli',
    'Daman and Diu', 'Delhi', 'Jammu and Kashmir', 'Ladakh',
    'Lakshadweep', 'Puducherry',
  ];

  @override
  void dispose() {
    _cacheBox?.close();
    super.dispose();
  }
}