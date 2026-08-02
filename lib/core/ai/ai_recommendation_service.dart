import 'dart:convert';
import 'ai_service.dart';

/// AI-powered recommendation — calls real LLM, not hardcoded strings.
class AIRecommendationService {
  AIRecommendationService(this._ai);
  final AIService _ai;

  /// Generate personalized task recommendations based on student profile.
  Future<List<AIRecommendation>> getTaskRecommendations({
    required String city,
    required List<String> interests,
    required List<String> targetSchools,
    required int grade,
    required int hoursPerWeek,
    required List<String> currentActivities,
    required Map<String, String> grades,
  }) async {
    final gradesStr = grades.entries
        .map((e) => '${e.key}: ${e.value}')
        .join(', ');
    final activitiesStr =
        currentActivities.isEmpty ? 'None yet' : currentActivities.join(', ');
    final schoolsStr =
        targetSchools.isEmpty ? 'Not decided yet' : targetSchools.join(', ');

    final prompt = '''
Student Profile:
- Location: $city
- Grade: $grade
- Target schools: $schoolsStr
- Interests: ${interests.join(', ')}
- Current activities: $activitiesStr
- Grades: $gradesStr
- Available hours/week: $hoursPerWeek

Generate 6 specific, actionable tasks this student should do THIS WEEK.
For each task, provide:
1. A short title (5-8 words)
2. A category (academics/research/creativity/leadership/service/extracurricular)
3. Why this task matters for their profile (1 sentence)
4. XP reward (10-50 based on difficulty)
5. Estimated time (e.g. "30 min", "2 hours")

Be VERY specific. Reference their actual interests and target schools.
Example good task: "Draft MIT application essay intro about your robotics research"
Example bad task: "Study hard"

Respond in this exact JSON format:
[{"title":"...","category":"...","reason":"...","xp":25,"duration":"30 min"}]
''';

    final response = await _ai.generate(
      prompt: prompt,
      temperature: 0.8,
      maxTokens: 1500,
    );

    return _parseRecommendations(response);
  }

  /// Generate study tips personalized to the student's weak subjects.
  Future<List<String>> getStudyTips({
    required Map<String, String> grades,
    required String city,
  }) async {
    final weak = grades.entries
        .where((e) {
          final pct = int.tryParse(
            e.value.replaceAll('%', '').replaceAll(RegExp(r'[^0-9]'), ''),
          );
          return pct != null && pct < 85;
        })
        .map((e) => '${e.key} (${e.value})')
        .toList();

    final weakStr = weak.isEmpty ? 'No clear weak subjects' : weak.join(', ');

    final prompt = '''
Student in $city has these weaker subjects: $weakStr
Overall grades: ${grades.entries.map((e) => '${e.key}: ${e.value}').join(', ')}

Give 4 specific study strategies to improve these subjects.
Each tip should be 1-2 sentences, actionable, and reference specific techniques
(Spaced repetition, Pomodoro, Feynman technique, practice problems, etc.)
''';

    final response = await _ai.generate(
      prompt: prompt,
      temperature: 0.7,
      maxTokens: 800,
    );

    return response
        .split(RegExp(r'\n\d+[\.\)]\s*'))
        .where((s) => s.trim().length > 10)
        .map((s) => s.trim().replaceAll(RegExp(r'^[\-\•\*]\s*'), ''))
        .take(4)
        .toList();
  }

  /// Generate location-specific study recommendations.
  Future<List<StudySpot>> getStudySpots({
    required String city,
    required List<String> interests,
  }) async {
    final prompt = '''
Recommend 5 study spots in $city for a student interested in ${interests.join(', ')}.
Include libraries, cafes, co-working spaces, and quiet study areas.

For each spot provide:
1. Name
2. Type (library/cafe/coworking/other)
3. Why it's good for studying (1 sentence)
4. One unique tip about this spot

Respond in JSON format:
[{"name":"...","type":"...","tip":"...","why":"..."}]
''';

    final response = await _ai.generate(
      prompt: prompt,
      temperature: 0.7,
      maxTokens: 1000,
    );

    return _parseStudySpots(response);
  }

  List<AIRecommendation> _parseRecommendations(String response) {
    try {
      final jsonStr = _extractJson(response);
      final list = List<Map<String, dynamic>>.from(
        (jsonStr as List).map((e) => Map<String, dynamic>.from(e as Map)),
      );
      return list.map((m) => AIRecommendation(
        title: m['title']?.toString() ?? '',
        category: m['category']?.toString() ?? 'academics',
        reason: m['reason']?.toString() ?? '',
        xp: (m['xp'] as num?)?.toInt() ?? 20,
        duration: m['duration']?.toString() ?? '30 min',
      )).toList();
    } catch (e) {
      // Fallback: split by lines and create basic recommendations.
      return response
          .split(RegExp(r'\n'))
          .where((l) => l.trim().length > 10)
          .take(6)
          .map((l) => AIRecommendation(
            title: l.replaceAll(RegExp(r'^[\d\.\-\•\*]\s*'), '').trim(),
            category: 'academics',
            reason: 'AI-generated recommendation',
            xp: 20,
            duration: '30 min',
          ))
          .toList();
    }
  }

  List<StudySpot> _parseStudySpots(String response) {
    try {
      final jsonStr = _extractJson(response);
      final list = List<Map<String, dynamic>>.from(
        (jsonStr as List).map((e) => Map<String, dynamic>.from(e as Map)),
      );
      return list.map((m) => StudySpot(
        name: m['name']?.toString() ?? '',
        type: m['type']?.toString() ?? 'other',
        tip: m['tip']?.toString() ?? '',
        why: m['why']?.toString() ?? '',
      )).toList();
    } catch (e) {
      return [];
    }
  }

  dynamic _extractJson(String response) {
    // Try to find JSON array in the response.
    final start = response.indexOf('[');
    final end = response.lastIndexOf(']');
    if (start != -1 && end != -1 && end > start) {
      return List<dynamic>.from(
        (jsonDecode(response.substring(start, end + 1)) as List)
            .map((e) => e is Map ? Map<String, dynamic>.from(e) : e),
      );
    }
    throw FormatException('No JSON array found in response');
  }
}

class AIRecommendation {
  const AIRecommendation({
    required this.title,
    required this.category,
    required this.reason,
    required this.xp,
    required this.duration,
  });

  final String title;
  final String category;
  final String reason;
  final int xp;
  final String duration;

  String get priorityLabel {
    if (xp >= 40) return 'HIGH';
    if (xp >= 25) return 'MED';
    return 'LOW';
  }
}

class StudySpot {
  const StudySpot({
    required this.name,
    required this.type,
    required this.tip,
    required this.why,
  });

  final String name;
  final String type;
  final String tip;
  final String why;

  String get typeEmoji {
    switch (type.toLowerCase()) {
      case 'library': return '📚';
      case 'cafe': return '☕';
      case 'coworking': return '💼';
      default: return '📍';
    }
  }
}
