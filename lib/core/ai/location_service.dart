import 'ai_service.dart';

/// Location-aware study spot recommendations.
/// Uses AI to generate personalized study spots based on city + interests.
class LocationService {
  LocationService(this._ai);
  final AIService _ai;

  /// Get study spots personalized to the student's interests.
  Future<List<StudySpotResult>> getStudySpots({
    required String city,
    required List<String> interests,
    required String studyStyle, // library, cafe, coworking, mixed
  }) async {
    final prompt = '''
Recommend 6 study spots in $city for a student interested in ${interests.join(', ')}.
Study preference: $studyStyle

Include a mix of:
- Libraries (public, university, specialty)
- Cafes with good study vibes
- Co-working spaces
- Quiet parks or outdoor study areas
- Any unique spots specific to $city

For each spot provide:
1. Name of the place
2. Type (library/cafe/coworking/park/other)
3. Why it's great for studying (1 sentence)
4. One insider tip (best time to go, quiet corners, etc.)
5. Approximate area/neighborhood

Respond in JSON format:
[{"name":"...","type":"...","why":"...","tip":"...","area":"..."}]
''';

    final response = await _ai.generate(
      prompt: prompt,
      temperature: 0.7,
      maxTokens: 1200,
    );

    return _parseSpots(response);
  }

  /// Get city-specific prep tips for target universities.
  Future<List<String>> getCityPrepTips({
    required String city,
    required List<String> targetSchools,
  }) async {
    final schoolsStr = targetSchools.isEmpty
        ? 'top universities'
        : targetSchools.join(', ');

    final prompt = '''
Student in $city targeting $schoolsStr.

Give 4 city-specific preparation tips:
- Local competitions, olympiads, or academic events they should know about
- University prep resources available in $city
- Networking opportunities or mentorship programs
- Any city-specific advantages for college applications

Each tip should be 1-2 sentences and actionable.
''';

    final response = await _ai.generate(
      prompt: prompt,
      temperature: 0.7,
      maxTokens: 600,
    );

    return response
        .split(RegExp(r'\n\d+[\.\)]\s*'))
        .where((s) => s.trim().length > 10)
        .map((s) => s.trim().replaceAll(RegExp(r'^[\-\•\*]\s*'), ''))
        .take(4)
        .toList();
  }

  List<StudySpotResult> _parseSpots(String response) {
    try {
      final start = response.indexOf('[');
      final end = response.lastIndexOf(']');
      if (start == -1 || end == -1) return [];

      final list = (List<dynamic>.from(
        (response.substring(start, end + 1) as dynamic) as List,
      )).cast<Map<String, dynamic>>();

      return list.map((m) => StudySpotResult(
        name: m['name']?.toString() ?? '',
        type: m['type']?.toString() ?? 'other',
        why: m['why']?.toString() ?? '',
        tip: m['tip']?.toString() ?? '',
        area: m['area']?.toString() ?? '',
      )).toList();
    } catch (e) {
      return [];
    }
  }
}

class StudySpotResult {
  const StudySpotResult({
    required this.name,
    required this.type,
    required this.why,
    required this.tip,
    required this.area,
  });

  final String name;
  final String type;
  final String why;
  final String tip;
  final String area;

  String get typeEmoji {
    switch (type.toLowerCase()) {
      case 'library': return '📚';
      case 'cafe': return '☕';
      case 'coworking': return '💼';
      case 'park': return '🌳';
      default: return '📍';
    }
  }
}
