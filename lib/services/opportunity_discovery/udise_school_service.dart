import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter/foundation.dart';
import 'package:latlong2/latlong.dart' as latlong;

import '../models/opportunity/udise_school.dart';

part 'udise_school_service.g.dart';

class UDISESchoolService extends ChangeNotifier {
  static const String _baseUrl = 'https://udiseplus.gov.in/api';
  static const String _boxName = 'udise_school_cache';
  
  static const Duration _cacheDuration = Duration(days: 7);
  static const int _pageSize = 100;
  static const int _maxRetries = 3;
  
  Box<dynamic>? _cacheBox;
  bool _isInitialized = false;
  
  static final UDISESchoolService _instance = UDISESchoolService._internal();
  factory UDISESchoolService() => _instance;
  UDISESchoolService._internal();

  Future<void> initialize() async {
    if (_isInitialized) return;
    
    await Hive.initFlutter();
    if (!Hive.isAdapterRegistered(UDISESchoolAdapter().typeId)) {
      Hive.registerAdapter(UDISESchoolAdapter());
    }
    _cacheBox = await Hive.openBox<dynamic>(_boxName);
    _isInitialized = true;
  }

  Future<List<UDISESchool>> searchNearbySchools({
    required double latitude,
    required double longitude,
    double radiusKm = 10.0,
    String? state,
    String? district,
    String? block,
    SchoolCategory? category,
    SchoolManagement? management,
    int page = 1,
    bool useCache = true,
  }) async {
    await initialize();
    
    final cacheKey = _buildCacheKey(latitude, longitude, radiusKm, state, district, block, category, management, page);
    
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
    
    if (state != null) queryParams['state'] = state;
    if (district != null) queryParams['district'] = district;
    if (block != null) queryParams['block'] = block;
    if (category != null) queryParams['category'] = category.name;
    if (management != null) queryParams['management'] = management.name;

    final results = await _fetchWithRetry(queryParams);
    final schools = _parseSchoolResponse(results, latitude, longitude);
    
    if (useCache) {
      await _cacheResults(cacheKey, schools);
    }
    
    notifyListeners();
    return schools;
  }

  Future<List<UDISESchool>> searchSchoolsByUdiseCode(List<String> udiseCodes) async {
    await initialize();
    
    final schools = <UDISESchool>[];
    final uncachedCodes = <String>[];
    
    for (final code in udiseCodes) {
      final cacheKey = 'udise_school_$code';
      final cached = _getCachedResults(cacheKey);
      if (cached != null && cached.isNotEmpty) {
        schools.add(cached.first);
      } else {
        uncachedCodes.add(code);
      }
    }
    
    if (uncachedCodes.isEmpty) return schools;
    
    try {
      final queryParams = {'codes': uncachedCodes.join(',')};
      final results = await _fetchWithRetry(queryParams, endpoint: '/schools/batch');
      final fetchedSchools = _parseSchoolResponse(results, 0, 0);
      
      for (final school in fetchedSchools) {
        await _cacheResults('udise_school_${school.udiseCode}', [school]);
      }
      
      schools.addAll(fetchedSchools);
    } catch (e) {
      debugPrint('Error batch fetching schools: $e');
    }
    
    return schools;
  }

  Future<UDISESchool?> getSchoolDetails(String udiseCode) async {
    await initialize();
    
    final cacheKey = 'udise_school_$udiseCode';
    final cached = _getCachedResults(cacheKey);
    if (cached != null && cached.isNotEmpty) {
      return cached.first;
    }

    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/schools/$udiseCode'),
        headers: {'Accept': 'application/json'},
      ).timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;
        final school = UDISESchool.fromJson(data['data']);
        
        await _cacheResults(cacheKey, [school]);
        return school;
      }
    } catch (e) {
      debugPrint('Error fetching school details: $e');
    }
    return null;
  }

  Future<List<UDISESchool>> getSchoolsWithATLLab({
    required double latitude,
    required double longitude,
    double radiusKm = 25.0,
    int limit = 50,
  }) async {
    await initialize();
    
    final cacheKey = 'atl_schools_${latitude.toStringAsFixed(4)}_${longitude.toStringAsFixed(4)}_${radiusKm.toInt()}';
    
    final cached = _getCachedResults(cacheKey);
    if (cached != null && !_isCacheExpired(cached)) {
      return cached.take(limit).toList();
    }

    final queryParams = <String, String>{
      'lat': latitude.toString(),
      'lng': longitude.toString(),
      'radius': radiusKm.toString(),
      'has_atl_lab': 'true',
      'limit': limit.toString(),
    };

    final results = await _fetchWithRetry(queryParams);
    final schools = _parseSchoolResponse(results, latitude, longitude);
    
    await _cacheResults(cacheKey, schools);
    notifyListeners();
    return schools;
  }

  Future<List<UDISESchool>> getSchoolsByCategory({
    required SchoolCategory category,
    String? state,
    String? district,
    int page = 1,
    int limit = 100,
  }) async {
    await initialize();
    
    final queryParams = <String, String>{
      'category': category.name,
      'page': page.toString(),
      'limit': limit.toString(),
    };
    
    if (state != null) queryParams['state'] = state;
    if (district != null) queryParams['district'] = district;

    final results = await _fetchWithRetry(queryParams);
    return _parseSchoolResponse(results, 0, 0);
  }

  Future<List<UDISESchool>> getSchoolsByManagement({
    required SchoolManagement management,
    String? state,
    String? district,
    int page = 1,
    int limit = 100,
  }) async {
    await initialize();
    
    final queryParams = <String, String>{
      'management': management.name,
      'page': page.toString(),
      'limit': limit.toString(),
    };
    
    if (state != null) queryParams['state'] = state;
    if (district != null) queryParams['district'] = district;

    final results = await _fetchWithRetry(queryParams);
    return _parseSchoolResponse(results, 0, 0);
  }

  Future<List<UDISESchool>> getTopSchoolsByInfrastructure({
    required String state,
    String? district,
    int limit = 20,
  }) async {
    await initialize();
    
    final queryParams = <String, String>{
      'state': state,
      'sort_by': 'infrastructure_score',
      'order': 'desc',
      'limit': limit.toString(),
    };
    
    if (district != null) queryParams['district'] = district;

    final results = await _fetchWithRetry(queryParams);
    return _parseSchoolResponse(results, 0, 0);
  }

  Future<List<UDISESchool>> getSchoolsWithFacility({
    required String facility,
    required double latitude,
    required double longitude,
    double radiusKm = 15.0,
    int limit = 30,
  }) async {
    await initialize();
    
    final queryParams = <String, String>{
      'lat': latitude.toString(),
      'lng': longitude.toString(),
      'radius': radiusKm.toString(),
      'facility': facility,
      'limit': limit.toString(),
    };

    final results = await _fetchWithRetry(queryParams);
    return _parseSchoolResponse(results, latitude, longitude);
  }

  Future<Map<String, int>> getSchoolStatistics({
    String? state,
    String? district,
    String? block,
  }) async {
    await initialize();
    
    final queryParams = <String, String>{};
    if (state != null) queryParams['state'] = state;
    if (district != null) queryParams['district'] = district;
    if (block != null) queryParams['block'] = block;

    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/statistics').replace(queryParameters: queryParams),
        headers: {'Accept': 'application/json'},
      ).timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;
        return (data['statistics'] as Map<String, dynamic>)
            .map((k, v) => MapEntry(k, v as int));
      }
    } catch (e) {
      debugPrint('Error fetching statistics: $e');
    }
    
    return {};
  }

  Future<List<String>> getStates() async {
    await initialize();
    
    const cacheKey = 'udise_states';
    final cached = _getCachedResults(cacheKey);
    if (cached != null && cached.isNotEmpty) {
      return cached.first.specializations ?? [];
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
        
        final school = UDISESchool(
          udiseCode: 'states_cache',
          name: 'States Cache',
          specializations: states,
        );
        await _cacheResults(cacheKey, [school]);
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

  Future<List<String>> getBlocks(String state, String district) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/states/$state/districts/$district/blocks'),
        headers: {'Accept': 'application/json'},
      ).timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;
        return (data['blocks'] as List<dynamic>)
            .map((e) => e.toString())
            .toList();
      }
    } catch (e) {
      debugPrint('Error fetching blocks: $e');
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
    String? state, String? district, String? block,
    SchoolCategory? category, SchoolManagement? management, int page,
  ) {
    return 'udise_${lat.toStringAsFixed(4)}_${lng.toStringAsFixed(4)}_'
           '${radius.toInt()}_${state ?? 'all'}_${district ?? 'all'}_'
           '${block ?? 'all'}_${category?.name ?? 'all'}_'
           '${management?.name ?? 'all'}_p$page';
  }

  List<UDISESchool>? _getCachedResults(String key) {
    final data = _cacheBox?.get(key);
    if (data == null) return null;
    
    try {
      final list = (data as List).cast<Map<String, dynamic>>();
      return list.map((e) => UDISESchool.fromJson(e)).toList();
    } catch (e) {
      debugPrint('Cache parse error: $e');
      return null;
    }
  }

  bool _isCacheExpired(List<UDISESchool> cached) {
    if (cached.isEmpty) return true;
    final first = cached.first;
    if (first.cachedAt == null) return true;
    return DateTime.now().difference(first.cachedAt!) > _cacheDuration;
  }

  Future<void> _cacheResults(String key, List<UDISESchool> results) async {
    if (_cacheBox == null) return;
    
    final data = results.map((e) => e.toJson()).toList();
    await _cacheBox!.put(key, data);
  }

  Future<Map<String, dynamic>> _fetchWithRetry(
    Map<String, String> params, {
    String endpoint = '/schools/search',
  }) async {
    int attempt = 0;
    Exception? lastError;
    
    while (attempt < _maxRetries) {
      try {
        final uri = Uri.parse('$_baseUrl$endpoint').replace(queryParameters: params);
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

  List<UDISESchool> _parseSchoolResponse(
    Map<String, dynamic> response,
    double userLat,
    double userLng,
  ) {
    final data = response['data'] as List<dynamic>? ?? [];
    final schools = <UDISESchool>[];
    
    for (final item in data) {
      try {
        final json = item as Map<String, dynamic>;
        final school = UDISESchool.fromJson(json);
        
        if (userLat != 0 && userLng != 0 && school.latitude != null && school.longitude != null) {
          school.distanceKm = _calculateDistance(
            userLat, userLng, 
            school.latitude!, school.longitude!,
          );
        }
        
        schools.add(school);
      } catch (e) {
        debugPrint('Error parsing school: $e');
      }
    }
    
    return schools;
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