import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter/foundation.dart';
import 'package:latlong2/latlong.dart' as latlong;

import '../models/opportunity/atl_lab.dart';

part 'atl_lab_service.g.dart';

class ATLLabService extends ChangeNotifier {
  static const String _aimBaseUrl = 'https://aim.gov.in/api';
  static const String _udiseBaseUrl = 'https://udiseplus.gov.in/api';
  static const String _boxName = 'atl_lab_cache';
  
  static const Duration _cacheDuration = Duration(days: 3);
  static const int _pageSize = 50;
  static const int _maxRetries = 3;
  
  Box<dynamic>? _cacheBox;
  bool _isInitialized = false;
  
  static final ATLLabService _instance = ATLLabService._internal();
  factory ATLLabService() => _instance;
  ATLLabService._internal();

  Future<void> initialize() async {
    if (_isInitialized) return;
    
    await Hive.initFlutter();
    if (!Hive.isAdapterRegistered(ATLLabAdapter().typeId)) {
      Hive.registerAdapter(ATLLabAdapter());
    }
    _cacheBox = await Hive.openBox<dynamic>(_boxName);
    _isInitialized = true;
  }

  Future<List<ATLLab>> searchNearbyATLLabs({
    required double latitude,
    required double longitude,
    double radiusKm = 25.0,
    String? state,
    String? district,
    ATLLabStatus? status,
    int page = 1,
    bool useCache = true,
  }) async {
    await initialize();
    
    final cacheKey = _buildCacheKey(latitude, longitude, radiusKm, state, district, status, page);
    
    if (useCache) {
      final cached = _getCachedResults(cacheKey);
      if (cached != null && !_isCacheExpired(cached)) {
        notifyListeners();
        return cached;
      }
    }

    final results = await _fetchFromMultipleSources(
      latitude, longitude, radiusKm, state, district, status, page
    );
    final labs = _parseATLResponse(results, latitude, longitude);
    
    if (useCache) {
      await _cacheResults(cacheKey, labs);
    }
    
    notifyListeners();
    return labs;
  }

  Future<List<ATLLab>> getATLLabsBySchoolUdiseCodes(List<String> udiseCodes) async {
    await initialize();
    
    final labs = <ATLLab>[];
    final uncachedCodes = <String>[];
    
    for (final code in udiseCodes) {
      final cacheKey = 'atl_lab_school_$code';
      final cached = _getCachedResults(cacheKey);
      if (cached != null && cached.isNotEmpty) {
        labs.add(cached.first);
      } else {
        uncachedCodes.add(code);
      }
    }
    
    if (uncachedCodes.isEmpty) return labs;
    
    try {
      final queryParams = {'udise_codes': uncachedCodes.join(',')};
      final results = await _fetchWithRetry(queryParams, endpoint: '/atl/schools/batch');
      final fetchedLabs = _parseATLResponse(results, 0, 0);
      
      for (final lab in fetchedLabs) {
        await _cacheResults('atl_lab_school_${lab.schoolUdiseCode}', [lab]);
      }
      
      labs.addAll(fetchedLabs);
    } catch (e) {
      debugPrint('Error batch fetching ATL labs: $e');
    }
    
    return labs;
  }

  Future<ATLLab?> getATLLabDetails(String labId) async {
    await initialize();
    
    final cacheKey = 'atl_lab_detail_$labId';
    final cached = _getCachedResults(cacheKey);
    if (cached != null && cached.isNotEmpty) {
      return cached.first;
    }

    try {
      final response = await http.get(
        Uri.parse('$_aimBaseUrl/atl/$labId'),
        headers: {'Accept': 'application/json'},
      ).timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;
        final lab = ATLLab.fromJson(data['data']);
        
        await _cacheResults(cacheKey, [lab]);
        return lab;
      }
    } catch (e) {
      debugPrint('Error fetching ATL lab details: $e');
    }
    return null;
  }

  Future<List<ATLLab>> getATLLabsWithEquipment({
    required List<String> equipment,
    required double latitude,
    required double longitude,
    double radiusKm = 30.0,
    int limit = 20,
  }) async {
    await initialize();
    
    final queryParams = <String, String>{
      'lat': latitude.toString(),
      'lng': longitude.toString(),
      'radius': radiusKm.toString(),
      'equipment': equipment.join(','),
      'limit': limit.toString(),
    };

    final results = await _fetchWithRetry(queryParams);
    return _parseATLResponse(results, latitude, longitude);
  }

  Future<List<ATLLab>> getATLLabsByProgram({
    required String program,
    String? state,
    String? district,
    int page = 1,
    int limit = 50,
  }) async {
    await initialize();
    
    final queryParams = <String, String>{
      'program': program,
      'page': page.toString(),
      'limit': limit.toString(),
    };
    
    if (state != null) queryParams['state'] = state;
    if (district != null) queryParams['district'] = district;

    final results = await _fetchWithRetry(queryParams);
    return _parseATLResponse(results, 0, 0);
  }

  Future<List<ATLLab>> getFunctionalATLLabs({
    required double latitude,
    required double longitude,
    double radiusKm = 25.0,
    int limit = 30,
  }) async {
    await initialize();
    
    final queryParams = <String, String>{
      'lat': latitude.toString(),
      'lng': longitude.toString(),
      'radius': radiusKm.toString(),
      'status': 'functional',
      'limit': limit.toString(),
    };

    final results = await _fetchWithRetry(queryParams);
    return _parseATLResponse(results, latitude, longitude);
  }

  Future<Map<String, int>> getATLStatistics({
    String? state,
    String? district,
  }) async {
    await initialize();
    
    final queryParams = <String, String>{};
    if (state != null) queryParams['state'] = state;
    if (district != null) queryParams['district'] = district;

    try {
      final response = await http.get(
        Uri.parse('$_aimBaseUrl/atl/statistics').replace(queryParameters: queryParams),
        headers: {'Accept': 'application/json'},
      ).timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;
        return (data['statistics'] as Map<String, dynamic>)
            .map((k, v) => MapEntry(k, v as int));
      }
    } catch (e) {
      debugPrint('Error fetching ATL statistics: $e');
    }
    
    return {};
  }

  Future<List<String>> getAvailableEquipment() async {
    await initialize();
    
    const cacheKey = 'atl_equipment_list';
    final cached = _getCachedResults(cacheKey);
    if (cached != null && cached.isNotEmpty) {
      return cached.first.equipmentList ?? [];
    }
    
    try {
      final response = await http.get(
        Uri.parse('$_aimBaseUrl/atl/equipment'),
        headers: {'Accept': 'application/json'},
      ).timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;
        final equipment = (data['equipment'] as List<dynamic>)
            .map((e) => e.toString())
            .toList();
        
        final lab = ATLLab(
          labId: 'equipment_cache',
          schoolName: 'Equipment Cache',
          equipmentList: equipment,
        );
        await _cacheResults(cacheKey, [lab]);
        return equipment;
      }
    } catch (e) {
      debugPrint('Error fetching equipment list: $e');
    }
    
    return _getDefaultEquipment();
  }

  Future<List<String>> getAvailablePrograms() async {
    await initialize();
    
    const cacheKey = 'atl_programs_list';
    final cached = _getCachedResults(cacheKey);
    if (cached != null && cached.isNotEmpty) {
      return cached.first.equipmentList ?? [];
    }
    
    try {
      final response = await http.get(
        Uri.parse('$_aimBaseUrl/atl/programs'),
        headers: {'Accept': 'application/json'},
      ).timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;
        final programs = (data['programs'] as List<dynamic>)
            .map((e) => e.toString())
            .toList();
        
        final lab = ATLLab(
          labId: 'programs_cache',
          schoolName: 'Programs Cache',
          equipmentList: programs,
        );
        await _cacheResults(cacheKey, [lab]);
        return programs;
      }
    } catch (e) {
      debugPrint('Error fetching programs list: $e');
    }
    
    return _getDefaultPrograms();
  }

  Future<void> refreshCache() async {
    await initialize();
    await _cacheBox?.clear();
    notifyListeners();
  }

  Future<void> clearCache() async {
    await _cacheBox?.clear();
  }

  Future<List<ATLLab>> _fetchFromMultipleSources(
    double latitude,
    double longitude,
    double radiusKm,
    String? state,
    String? district,
    ATLLabStatus? status,
    int page,
  ) async {
    final results = <Map<String, dynamic>>[];
    
    try {
      final aimParams = <String, String>{
        'lat': latitude.toString(),
        'lng': longitude.toString(),
        'radius': radiusKm.toString(),
        'page': page.toString(),
        'limit': _pageSize.toString(),
      };
      if (state != null) aimParams['state'] = state;
      if (district != null) aimParams['district'] = district;
      if (status != null) aimParams['status'] = status.name;
      
      final aimResults = await _fetchWithRetry(aimParams, endpoint: '/atl/search');
      results.add(aimResults);
    } catch (e) {
      debugPrint('AIM API error: $e');
    }
    
    try {
      final udiseParams = <String, String>{
        'lat': latitude.toString(),
        'lng': longitude.toString(),
        'radius': radiusKm.toString(),
        'has_atl_lab': 'true',
        'page': page.toString(),
        'limit': _pageSize.toString(),
      };
      if (state != null) udiseParams['state'] = state;
      if (district != null) udiseParams['district'] = district;
      
      final udiseResults = await _fetchWithRetry(udiseParams, baseUrl: _udiseBaseUrl, endpoint: '/schools/search');
      results.add(udiseResults);
    } catch (e) {
      debugPrint('UDISE API error: $e');
    }
    
    return results;
  }

  List<ATLLab> _parseATLResponse(
    dynamic responseData,
    double userLat,
    double userLng,
  ) {
    final labs = <ATLLab>[];
    final responses = responseData is List ? responseData : [responseData];
    
    for (final response in responses) {
      final data = response['data'] as List<dynamic>? ?? [];
      
      for (final item in data) {
        try {
          final json = item as Map<String, dynamic>;
          final lab = ATLLab.fromJson(json);
          
          if (userLat != 0 && userLng != 0 && lab.latitude != null && lab.longitude != null) {
            lab.distanceKm = _calculateDistance(
              userLat, userLng, 
              lab.latitude!, lab.longitude!,
            );
          }
          
          labs.add(lab);
        } catch (e) {
          debugPrint('Error parsing ATL lab: $e');
        }
      }
    }
    
    final uniqueLabs = <String, ATLLab>{};
    for (final lab in labs) {
      final key = lab.labId.isNotEmpty ? lab.labId : lab.schoolUdiseCode;
      if (key.isNotEmpty && !uniqueLabs.containsKey(key)) {
        uniqueLabs[key] = lab;
      }
    }
    
    return uniqueLabs.values.toList();
  }

  Future<Map<String, dynamic>> _fetchWithRetry(
    Map<String, String> params, {
    String baseUrl = '',
    String endpoint = '/atl/search',
  }) async {
    int attempt = 0;
    Exception? lastError;
    final url = baseUrl.isEmpty ? _aimBaseUrl : baseUrl;
    
    while (attempt < _maxRetries) {
      try {
        final uri = Uri.parse('$url$endpoint').replace(queryParameters: params);
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

  String _buildCacheKey(
    double lat, double lng, double radius,
    String? state, String? district,
    ATLLabStatus? status, int page,
  ) {
    return 'atl_${lat.toStringAsFixed(4)}_${lng.toStringAsFixed(4)}_'
           '${radius.toInt()}_${state ?? 'all'}_${district ?? 'all'}_'
           '${status?.name ?? 'all'}_p$page';
  }

  List<ATLLab>? _getCachedResults(String key) {
    final data = _cacheBox?.get(key);
    if (data == null) return null;
    
    try {
      final list = (data as List).cast<Map<String, dynamic>>();
      return list.map((e) => ATLLab.fromJson(e)).toList();
    } catch (e) {
      debugPrint('Cache parse error: $e');
      return null;
    }
  }

  bool _isCacheExpired(List<ATLLab> cached) {
    if (cached.isEmpty) return true;
    final first = cached.first;
    if (first.cachedAt == null) return true;
    return DateTime.now().difference(first.cachedAt!) > _cacheDuration;
  }

  Future<void> _cacheResults(String key, List<ATLLab> results) async {
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

  List<String> _getDefaultEquipment() => [
    '3D Printer', 'Arduino Kits', 'Raspberry Pi', 'Sensors Kit',
    'Drone Kit', 'Robotics Kit', 'Electronics Kit', 'Mechanical Tools',
    'Soldering Station', 'Multimeter', 'Oscilloscope', 'Laser Cutter',
    'CNC Machine', 'Vinyl Cutter', 'VR Headset', 'AI/ML Kit',
    'IoT Kit', 'Biotech Kit', 'Aerospace Kit', 'Automotive Kit',
  ];

  List<String> _getDefaultPrograms() => [
    'ATL Marathon', 'ATL Tinkering Fest', 'Student Innovator Program',
    'Teacher Training Program', 'Community Tinkering', 'Mentor Connect',
    'Industry Connect', 'Startup Connect', 'ATL Space Challenge',
    'ATL Water Challenge', 'ATL Health Challenge', 'ATL Agri Challenge',
  ];

  @override
  void dispose() {
    _cacheBox?.close();
    super.dispose();
  }
}