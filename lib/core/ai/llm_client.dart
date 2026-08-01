import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

/// Supported LLM providers — all use OpenAI-compatible chat/completions format.
enum LlmProvider {
  opencodeZen(
    'OpenCode Zen',
    'https://api.opencodezen.ai/v1',
    'mimo-v2.5-free',
  ),
  nvidiaNim(
    'Nvidia NIM',
    'https://integrate.api.nvidia.com/v1',
    'meta/llama-3.1-8b-instruct',
  ),
  groq(
    'Groq',
    'https://api.groq.com/openai/v1',
    'llama-3.1-8b-instant',
  ),
  together(
    'Together',
    'https://api.together.xyz/v1',
    'meta-llama/Meta-Llama-3.1-8B-Instruct-Turbo',
  ),
  mistral(
    'Mistral',
    'https://api.mistral.ai/v1',
    'mistral-tiny',
  ),
  custom(
    'Custom (OpenAI-compatible)',
    '',
    '',
  );

  const LlmProvider(this.displayName, this.defaultBaseUrl, this.defaultModel);
  final String displayName;
  final String defaultBaseUrl;
  final String defaultModel;
}

/// Generic LLM client — works with any OpenAI-compatible API.
/// Supports: OpenCode Zen, Nvidia NIM, Groq, Together, Mistral, custom endpoints.
class LlmService {
  LlmService({
    required this.apiKey,
    this.provider = LlmProvider.opencodeZen,
    String? baseUrl,
    String? model,
    this.systemPrompt = _defaultSystemPrompt,
  })  : _baseUrl = baseUrl ?? provider.defaultBaseUrl,
        _model = model ?? provider.defaultModel,
        _dio = Dio(BaseOptions(
          baseUrl: baseUrl ?? provider.defaultBaseUrl,
          headers: {
            'Authorization': 'Bearer $apiKey',
            'Content-Type': 'application/json',
          },
          connectTimeout: const Duration(seconds: 15),
          receiveTimeout: const Duration(seconds: 60),
        ));

  final String apiKey;
  final LlmProvider provider;
  final String _baseUrl;
  final String _model;
  final String systemPrompt;
  final Dio _dio;

  static const _defaultSystemPrompt = '''
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

  /// Single-turn generation
  Future<String> generate(String prompt) async {
    try {
      final response = await _dio.post(
        '/chat/completions',
        data: {
          'model': _model,
          'messages': [
            {'role': 'system', 'content': systemPrompt},
            {'role': 'user', 'content': prompt},
          ],
          'temperature': 0.7,
          'max_tokens': 2048,
        },
      );

      final choices = response.data['choices'] as List?;
      if (choices != null && choices.isNotEmpty) {
        return choices[0]['message']['content'] ?? 'No response generated.';
      }
      return 'No response generated.';
    } on DioException catch (e) {
      debugPrint('LLM API error: ${e.message}');
      return 'AI error: ${e.message ?? "Network error"}';
    } catch (e) {
      debugPrint('LLM unexpected error: $e');
      return 'Unexpected error: $e';
    }
  }

  /// Multi-turn chat — send full message history
  Future<String> chat(List<Map<String, String>> messages) async {
    try {
      final fullMessages = [
        {'role': 'system', 'content': systemPrompt},
        ...messages,
      ];

      final response = await _dio.post(
        '/chat/completions',
        data: {
          'model': _model,
          'messages': fullMessages,
          'temperature': 0.7,
          'max_tokens': 2048,
        },
      );

      final choices = response.data['choices'] as List?;
      if (choices != null && choices.isNotEmpty) {
        return choices[0]['message']['content'] ?? 'No response generated.';
      }
      return 'No response generated.';
    } on DioException catch (e) {
      debugPrint('LLM chat error: ${e.message}');
      return 'AI error: ${e.message ?? "Network error"}';
    } catch (e) {
      debugPrint('LLM unexpected error: $e');
      return 'Unexpected error: $e';
    }
  }

  /// Streaming generation — yields content chunks as they arrive
  Stream<String> generateStream(String prompt) async* {
    try {
      final response = await _dio.post(
        '/chat/completions',
        data: {
          'model': _model,
          'messages': [
            {'role': 'system', 'content': systemPrompt},
            {'role': 'user', 'content': prompt},
          ],
          'temperature': 0.7,
          'max_tokens': 2048,
          'stream': true,
        },
        options: Options(responseType: ResponseType.stream),
      );

      final stream = response.data as Stream;
      String buffer = '';

      await for (final chunk in stream) {
        final text = String.fromCharCodes(chunk);
        buffer += text;

        final lines = buffer.split('\n');
        buffer = lines.removeLast();

        for (final line in lines) {
          if (line.startsWith('data: ')) {
            final data = line.substring(6).trim();
            if (data == '[DONE]') return;
            try {
              final json = jsonDecode(data) as Map<String, dynamic>;
              final delta = json['choices']?[0]?['delta']?['content'];
              if (delta != null) {
                yield delta;
              }
            } catch (_) {
              // Skip malformed JSON lines
            }
          }
        }
      }
    } on DioException catch (e) {
      debugPrint('LLM stream error: ${e.message}');
      yield 'AI error: ${e.message ?? "Network error"}';
    } catch (e) {
      debugPrint('LLM stream unexpected error: $e');
      yield 'Unexpected error: $e';
    }
  }

  /// Analyze an artifact
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
    return parseAnalysis(response, artifactType);
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
      studentProfile.forEach((key, value) {
        buffer.writeln('- $key: $value');
      });
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
    int? score;
    final scoreMatch = RegExp(
      r'(?:Overall Score|Score)[:\s]*(\d+)/10',
      caseSensitive: false,
    ).firstMatch(response);
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

  String get summary =>
      '$artifactType analysis — Score: ${score != null ? '$score/10' : 'N/A'}';
}
