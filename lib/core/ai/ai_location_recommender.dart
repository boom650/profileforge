import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../ai/ai_providers.dart';
import '../ai/fallback_llm_client.dart';
import '../data/tables.dart';
import '../database.dart';

/// ────────────────────────────────────────────────────────────────────────────
/// AI Location Recommender — uses LLM to find opportunities near a location.
///
/// Instead of GPS + Google Places API, we ask the AI:
/// "What study spaces, competitions, volunteer work, and events exist near [city]?"
///
/// The AI returns structured JSON with real(ish) places, which we display
/// in the GeoScreen with distance estimates.
/// ────────────────────────────────────────────────────────────────────────────

class AiLocationRecommender {
  final FallbackLlmClient _llm;

  AiLocationRecommender(this._llm);

  /// Ask the AI to recommend opportunities near a location.
  Future<List<AiOpportunity>> getRecommendations({
    required String location,
    required List<String> interests,
    String? goal,
    double radiusKm = 25,
  }) async {
    final interestsStr = interests.isEmpty
        ? 'general academic improvement'
        : interests.join(', ');

    final goalStr = goal?.isNotEmpty == true
        ? '\nUser\'s primary goal: $goal'
        : '';

    final prompt = '''You are an admissions advisor helping a student find opportunities near their location.

Location: $location
Interests: $interestsStr$goalStr
Search radius: ~${radiusKm.toInt()} km

Generate a JSON array of 8-12 real or realistic opportunities near this location. Include a mix of:
- Libraries and study spaces
- Competitions and olympiads
- Volunteer organizations
- Hackathons and tech events
- Academic seminars and workshops
- Internship opportunities
- Museums and cultural centers
- Research labs or maker spaces

For EACH opportunity, provide:
{
  "title": "Place/Organization Name",
  "category": "library|hackathon|volunteer|seminar|competition|internship|museum|lab",
  "address": "Approximate address or neighborhood",
  "description": "Brief description of what they offer",
  "verified": true/false,
  "relevance": "Why this matters for college admissions"
}

IMPORTANT:
- Use REAL place names when possible (e.g., "National Library Board" for Singapore)
- If you don't know exact places, use realistic generic names for the area
- Focus on opportunities that strengthen college applications
- Return ONLY the JSON array, no other text
- Do NOT wrap in markdown code blocks

Return the JSON array now:''';

    try {
      final response = await _llm.chat(
        messages: [LlmMessage(role: 'user', content: prompt)],
        temperature: 0.7,
        maxTokens: 3000,
      );

      return _parseOpportunities(response);
    } catch (e) {
      // Fallback to seed data if AI fails
      return _seedOpportunities(location);
    }
  }

  /// Parse AI response into AiOpportunity list.
  List<AiOpportunity> _parseOpportunities(String response) {
    try {
      // Clean response — remove markdown code blocks if present
      var cleaned = response.trim();
      if (cleaned.startsWith('```')) {
        cleaned = cleaned.replaceFirst(RegExp(r'^```\w*\n?'), '');
        cleaned = cleaned.replaceFirst(RegExp(r'\n?```$'), '');
      }

      final List<dynamic> jsonList = jsonDecode(cleaned.trim());
      return jsonList.map((j) => AiOpportunity(
        title: j['title'] ?? 'Unknown',
        category: j['category'] ?? 'other',
        address: j['address'] ?? '',
        description: j['description'] ?? '',
        verified: j['verified'] ?? false,
        relevance: j['relevance'] ?? '',
      )).toList();
    } catch (e) {
      return [];
    }
  }

  /// Seed data fallback when AI is unavailable.
  List<AiOpportunity> _seedOpportunities(String location) {
    return [
      AiOpportunity(
        title: 'Public Library - Study Hall',
        category: 'library',
        address: 'Central $location',
        description: 'Quiet study spaces with free WiFi and academic resources',
        verified: true,
        relevance: 'Demonstrates self-directed learning',
      ),
      AiOpportunity(
        title: 'Community Volunteer Center',
        category: 'volunteer',
        address: 'Downtown $location',
        description: 'Local NGO offering tutoring and mentorship programs',
        verified: false,
        relevance: 'Community service hours strengthen applications',
      ),
      AiOpportunity(
        title: 'Regional Science Fair',
        category: 'competition',
        address: '$location Convention Center',
        description: 'Annual science competition for high school students',
        verified: true,
        relevance: 'Competition awards demonstrate academic excellence',
      ),
      AiOpportunity(
        title: 'Tech Hub - Hackathon Monthly',
        category: 'hackathon',
        address: 'Innovation District, $location',
        description: 'Monthly hackathons focused on social impact projects',
        verified: true,
        relevance: 'Shows initiative and technical skills',
      ),
    ];
  }
}

/// A location-based opportunity recommended by AI.
class AiOpportunity {
  final String title;
  final String category;
  final String address;
  final String description;
  final bool verified;
  final String relevance;

  const AiOpportunity({
    required this.title,
    required this.category,
    required this.address,
    required this.description,
    required this.verified,
    required this.relevance,
  });
}

/// Provider for the AI location recommender.
final aiLocationRecommenderProvider = Provider<AiLocationRecommender>((ref) {
  final llm = getFallbackClient();
  return AiLocationRecommender(llm);
});

/// Provider for AI-powered location recommendations.
final aiLocationRecommendationsProvider =
    FutureProvider.family<List<AiOpportunity>, ({String location, List<String> interests, String? goal})>(
  (ref, args) async {
    final recommender = ref.watch(aiLocationRecommenderProvider);
    return recommender.getRecommendations(
      location: args.location,
      interests: args.interests,
      goal: args.goal,
    );
  },
);
