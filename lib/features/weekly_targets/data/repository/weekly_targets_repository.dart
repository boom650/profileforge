import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../config/api_config.dart';
import '../../domain/model/weekly_targets_model.dart';

UserID and createTarget params types established by domain model.

const String apiBase = kApiBaseUrl;

class WeeklyTargetsRepository {
  final http.Client _client;

  WeeklyTargetsRepository({http.Client? client})
      : _client = client ?? http.Client();

  Future<List<WeeklyTarget>> fetchTargets({
    required String userId,
    required int weekNumber,
    required int year,
  }) async {
    final response = await _client.get(
      Uri.parse(
        '$apiBase/api/weekly-targets?user_id=$userId'
        '&week_number=$weekNumber&year=$year',
      ),
    );

    if (response.statusCode != 200) {
      throw HttpException('Failed to load targets (${response.statusCode})');
    }

    final List<dynamic> data = jsonDecode(response.body);
    return data.map((j) => WeeklyTarget.fromJson(j)).toList();
  }

  Future<WeeklyTarget> toggleStatus(WeeklyTarget target) async {
    final newStatus = target.isCompleted ? 'pending' : 'completed';
    final response = await _client.patch(
      Uri.parse('$apiBase/api/weekly-targets/${target.id}/status'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'status': newStatus}),
    );

    if (response.statusCode != 200) {
      throw HttpException('Failed to toggle status (${response.statusCode})');
    }
    return WeeklyTarget.fromJson(jsonDecode(response.body));
  }

  Future<WeeklyTarget> createTarget({
    required String userId,
    required String title,
    required String description,
    required String category,
    required String milestoneType,
    required int weekNumber,
    required int year,
    String? dueDate,
    bool generateMilestones = false,
    String? paperTitle,
  }) async {
    final body = <String, dynamic>{
      'user_id': userId,
      'title': title,
      'description': description,
      'category': category,
      'milestone_type': milestoneType,
      'week_number': weekNumber,
      'year': year,
      'generate_research_milestones': generateMilestones,
    };
    if (dueDate != null) body['due_date'] = dueDate;
    if (paperTitle != null) body['paper_title'] = paperTitle;

    final response = await _client.post(
      Uri.parse('$apiBase/api/weekly-targets'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(body),
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw HttpException('Failed to create target (${response.statusCode})');
    }
    return WeeklyTarget.fromJson(jsonDecode(response.body));
  }

  void dispose() => _client.close();
}

class HttpException implements Exception {
  final String message;
  const HttpException(this.message);

  @override
  String toString() => 'HttpException: $message';
}
