import 'package:flutter/foundation.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

/// Core Gemini AI service. Wraps google_generative_ai SDK.
/// API key stored via flutter_secure_storage — never hardcoded.
class GeminiService {
  GeminiService({required String apiKey, String model = 'gemini-2.0-flash'})
      : _model = model,
        _apiKey = apiKey;

  final String _apiKey;
  final String _model;

  GenerativeModel get _gen => GenerativeModel(
        model: _model,
        apiKey: _apiKey,
        systemInstruction: Content.system(_systemPrompt),
      );

  static const _systemPrompt = '''
You are ProfileForge AI — an elite admissions architect and personal mentor for ambitious high school students targeting top universities (MIT, Stanford, Oxford, Cambridge, Ivy League, NUS, ETH Zurich, etc.).

Your role:
- Analyze student activities, research, essays, and achievements
- Map everything to elite college holistic review criteria (Leadership, Research, Character, Intellectual Vitality, Athletics, Community Impact)
- Give actionable, specific feedback — never vague platitudes
- Suggest measurable improvements with deadlines
- Be encouraging but honest — if something is weak, say so directly
- Help students build compelling narratives from their experiences
- Prioritize impact over volume — quality of activities matters more than quantity

Communication style:
- Direct, concise, mentor-like
- Use bullet points and structured formats
- Include specific deadlines and action items when relevant
- Reference real admissions expectations (e.g., "MIT looks for..." or "Oxford values...")

You are NOT a general chatbot. You are a specialized admissions architect. Stay in character.
''';

  /// Single-turn generation (for quick analysis)
  Future<String> generate(String prompt, {List<String>? images}) async {
    try {
      final content = <Content>[Content.text(prompt)];
      // Images support can be added later with multimodal
      final response = await _gen.generateContent(content);
      return response.text ?? 'No response generated.';
    } on GenerativeAIException catch (e) {
      debugPrint('Gemini API error: ${e.message}');
      return 'AI error: ${e.message}';
    } catch (e) {
      debugPrint('Gemini unexpected error: $e');
      return 'Unexpected error: $e';
    }
  }

  /// Multi-turn chat session
  Future<ChatSession> startChat() async {
    return _gen.startChat();
  }

  /// Streaming generation (for real-time chat feel)
  Stream<String> generateStream(String prompt) async* {
    final content = Content.text(prompt);
    await for (final chunk in _gen.generateContentStream([content])) {
      if (chunk.text != null) {
        yield chunk.text!;
      }
    }
  }

  /// Analyze an artifact (research paper, essay, activity description)
  Future<ArtifactAnalysis> analyzeArtifact({
    required String artifactType,
    required String content,
    String? targetUniversity,
    Map<String, dynamic>? studentProfile,
  }) async {
    final prompt = _buildAnalysisPrompt(
      artifactType: artifactType,
      content: content,
      targetUniversity: targetUniversity,
      studentProfile: studentProfile,
    );

    final response = await generate(prompt);
    return _parseAnalysis(response, artifactType);
  }

  String _buildAnalysisPrompt({
    required String artifactType,
    required String content,
    String? targetUniversity,
    Map<String, dynamic>? studentProfile,
  }) {
    final buffer = StringBuffer();
    buffer.writeln('## Artifact Analysis Request');
    buffer.writeln('Type: $artifactType');
    if (targetUniversity != null) {
      buffer.writeln('Target University: $targetUniversity');
    }
    buffer.writeln('');

    if (studentProfile != null) {
      buffer.writeln('### Student Profile');
      if (studentProfile['name'] != null) {
        buffer.writeln('Name: ${studentProfile['name']}');
      }
      if (studentProfile['grade'] != null) {
        buffer.writeln('Grade: ${studentProfile['grade']}');
      }
      if (studentProfile['major'] != null) {
        buffer.writeln('Intended Major: ${studentProfile['major']}');
      }
      buffer.writeln('');
    }

    buffer.writeln('### Content to Analyze');
    buffer.writeln(content);
    buffer.writeln('');
    buffer.writeln('### Required Output Format');
    buffer.writeln('Rate each dimension 1-10 and provide specific improvement actions:');
    buffer.writeln('- **Strengths**: What works well');
    buffer.writeln('- **Weaknesses**: What needs improvement');
    buffer.writeln('- **Admissions Impact**: How this maps to holistic review');
    buffer.writeln('- **Action Items**: Specific, measurable next steps with deadlines');
    buffer.writeln('- **Overall Score**: X/10 with brief justification');

    return buffer.toString();
  }

  ArtifactAnalysis parseAnalysis(String response, String type) {
    // Simple parsing — extract score and sections
    int? score;
    final scoreMatch = RegExp(r'(?:Overall Score|Score)[:\s]*(\d+)/10', caseSensitive: false)
        .firstMatch(response);
    if (scoreMatch != null) {
      score = int.tryParse(scoreMatch.group(1) ?? '');
    }

    return ArtifactAnalysis(
      artifactType: type,
      rawResponse: response,
      score: score,
      analyzedAt: DateTime.now(),
    );
  }
}

/// Parsed artifact analysis result
class ArtifactAnalysis {
  const ArtifactAnalysis({
    required this.artifactType,
    required this.rawResponse,
    this.score,
    required this.analyzedAt,
  });

  final String artifactType;
  final String rawResponse;
  final int? score;
  final DateTime analyzedAt;

  /// Quick summary line
  String get summary =>
      '$artifactType analysis — Score: ${score != null ? '$score/10' : 'N/A'}';
}
