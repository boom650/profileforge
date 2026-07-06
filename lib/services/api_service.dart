/// Backend API Service
/// Handles communication between Flutter app and backend server

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Backend URL - localhost for local server
const String backendUrl = 'http://localhost:8080';

/// API Service Provider
final apiServiceProvider = Provider<ApiService>((ref) {
  return ApiService();
});

class ApiService {
  final http.Client _client = http.Client();

  // ═══════════════════════════════════════════════════════════════════════════
  // USER ENDPOINTS
  // ═══════════════════════════════════════════════════════════════════════════

  /// Create a new user
  Future<Map<String, dynamic>> createUser({
    required String name,
    String? email,
    int? grade,
    String? board,
    String? stream,
  }) async {
    final response = await _client.post(
      Uri.parse('$backendUrl/api/users'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'name': name,
        'email': email,
        'grade': grade,
        'board': board,
        'stream': stream,
      }),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to create user: ${response.body}');
    }
  }

  /// Get user by ID
  Future<Map<String, dynamic>> getUser(String userId) async {
    final response = await _client.get(
      Uri.parse('$backendUrl/api/users/$userId'),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('User not found');
    }
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // LOCATION ENDPOINTS
  // ═══════════════════════════════════════════════════════════════════════════

  /// Update user's GPS coordinates
  Future<void> updateLocation({
    required String userId,
    required double latitude,
    required double longitude,
    String? city,
    String? state,
    String? country,
  }) async {
    final response = await _client.post(
      Uri.parse('$backendUrl/api/users/$userId/location'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'latitude': latitude,
        'longitude': longitude,
        'city': city,
        'state': state,
        'country': country,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update location');
    }
  }

  /// Update user's city (manual entry)
  Future<void> updateCity({
    required String userId,
    required String city,
  }) async {
    final response = await _client.post(
      Uri.parse('$backendUrl/api/users/$userId/city'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(city),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update city');
    }
  }

  /// Get user's location
  Future<Map<String, dynamic>?> getLocation(String userId) async {
    final response = await _client.get(
      Uri.parse('$backendUrl/api/users/$userId/location'),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      return null;
    }
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // TASK ENDPOINTS
  // ═══════════════════════════════════════════════════════════════════════════

  /// Get tasks for a user
  Future<List<Map<String, dynamic>>> getTasks(String userId, {String? status}) async {
    final uri = status != null
        ? Uri.parse('$backendUrl/api/tasks/$userId?status=$status')
        : Uri.parse('$backendUrl/api/tasks/$userId');

    final response = await _client.get(uri);

    if (response.statusCode == 200) {
      return List<Map<String, dynamic>>.from(jsonDecode(response.body));
    } else {
      throw Exception('Failed to fetch tasks');
    }
  }

  /// Complete a task and award XP
  Future<Map<String, dynamic>> completeTask(String taskId) async {
    final response = await _client.post(
      Uri.parse('$backendUrl/api/tasks/$taskId/complete'),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to complete task');
    }
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // EVALUATION ENDPOINTS
  // ═══════════════════════════════════════════════════════════════════════════

  /// Evaluate uploaded document
  Future<Map<String, dynamic>> evaluateDocument({
    required String userId,
    required String taskId,
    required List<int> fileBytes,
    required String fileName,
    required String contentType,
  }) async {
    var request = http.MultipartRequest(
      'POST',
      Uri.parse('$backendUrl/api/evaluate?user_id=$userId&task_id=$taskId'),
    );

    request.files.add(http.MultipartFile.fromBytes(
      'file',
      fileBytes,
      filename: fileName,
    ));

    final streamedResponse = await _client.send(request);
    final response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Evaluation failed');
    }
  }

  /// Evaluate text content
  Future<Map<String, dynamic>> evaluateText({
    required String userId,
    required String taskId,
    required String text,
  }) async {
    final response = await _client.post(
      Uri.parse('$backendUrl/api/evaluate/text?user_id=$userId&task_id=$taskId'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(text),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Evaluation failed');
    }
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // XP ENDPOINTS
  // ═══════════════════════════════════════════════════════════════════════════

  /// Get XP state
  Future<Map<String, dynamic>> getXPState(String userId) async {
    final response = await _client.get(
      Uri.parse('$backendUrl/api/xp/$userId'),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to fetch XP state');
    }
  }

  /// Get XP history
  Future<List<Map<String, dynamic>>> getXPHistory(String userId, {int limit = 50}) async {
    final response = await _client.get(
      Uri.parse('$backendUrl/api/xp/$userId/history?limit=$limit'),
    );

    if (response.statusCode == 200) {
      return List<Map<String, dynamic>>.from(jsonDecode(response.body));
    } else {
      throw Exception('Failed to fetch XP history');
    }
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // OPPORTUNITY ENDPOINTS
  // ═══════════════════════════════════════════════════════════════════════════

  /// Get opportunities near user
  Future<List<Map<String, dynamic>>> getOpportunities(String userId) async {
    final response = await _client.get(
      Uri.parse('$backendUrl/api/opportunities/$userId'),
    );

    if (response.statusCode == 200) {
      return List<Map<String, dynamic>>.from(jsonDecode(response.body));
    } else {
      throw Exception('Failed to fetch opportunities');
    }
  }

  /// Search opportunities by city
  Future<List<Map<String, dynamic>>> searchOpportunities(String city) async {
    final response = await _client.get(
      Uri.parse('$backendUrl/api/opportunities/search?city=$city'),
    );

    if (response.statusCode == 200) {
      return List<Map<String, dynamic>>.from(jsonDecode(response.body));
    } else {
      throw Exception('Failed to search opportunities');
    }
  }
}
