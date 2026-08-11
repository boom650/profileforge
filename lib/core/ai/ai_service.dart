import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'ai_json.dart';
import 'ai_provider.dart';
import 'package:profileforge/core/rate_app/rate_app_service.dart';

/// Core AI service — OpenAI-compatible with 3-provider fallback.
/// No external SDK dependencies, just Dio + JSON.
class AIService {
  AIService({AIKeyStore? keyStore}) : _keyStore = keyStore ?? AIKeyStore();

  final AIKeyStore _keyStore;
  final Dio _dio = Dio(BaseOptions(
    connectTimeout: const Duration(seconds: 30),
    receiveTimeout: const Duration(seconds: 60),
    headers: {'Content-Type': 'application/json'},
  ));

  /// System prompt for admissions AI.
  static const systemPrompt = '''
You are ProfileForge AI — an elite admissions architect for top universities.
You help students with:
- Personalized task recommendations based on their profile, interests, and goals
- Essay feedback and brainstorming
- Activity planning and extracurricular strategy
- University-specific preparation advice
- Study techniques and time management

Rules:
- Be specific, actionable, never vague
- Reference real admissions criteria (MIT values research, Stanford wants intellectual vitality, etc.)
- Give deadlines when possible
- Be encouraging but honest
- Format responses with bullet points and clear structure
''';

  /// Generate a completion with automatic provider fallback.
  Future<String> generate({
    required String prompt,
    String? systemPromptOverride,
    double temperature = 0.7,
    int maxTokens = 1024,
  }) async {
    final providers = AIProviders.fallbackChain;

    for (final provider in providers) {
      final apiKey = await _keyStore.getKey(provider.type);
      if (apiKey == null || apiKey.isEmpty) continue;

      try {
        return await _callProvider(
          provider: provider,
          apiKey: apiKey,
          prompt: prompt,
          systemPrompt: systemPromptOverride ?? systemPrompt,
          temperature: temperature,
          maxTokens: maxTokens,
        );
      } catch (e) {
        debugPrint('AI ${provider.name} failed: $e');
        continue;
      }
    }

    return 'No AI provider configured. Add an API key in Settings → AI.';
  }

  /// Chat-style generation (multi-turn).
  Future<String> chat({
    required List<ChatMessage> messages,
    double temperature = 0.7,
    int maxTokens = 2048,
    String? systemPromptOverride,
  }) async {
    final providers = AIProviders.fallbackChain;

    for (final provider in providers) {
      final apiKey = await _keyStore.getKey(provider.type);
      if (apiKey == null || apiKey.isEmpty) continue;

      try {
        final msgList = [
          {'role': 'system', 'content': systemPromptOverride ?? systemPrompt},
          ...messages.map((m) => {'role': m.role, 'content': m.content}),
        ];

        final response = await _dio.post(
          '${provider.baseUrl}/chat/completions',
          options: Options(headers: {'Authorization': 'Bearer $apiKey'}),
          data: {
            'model': provider.model,
            'messages': msgList,
            'temperature': temperature,
            'max_tokens': maxTokens,
          },
        );

        final data = response.data as Map<String, dynamic>;
        final choices = data['choices'] as List?;
        if (choices != null && choices.isNotEmpty) {
          // Real chat interaction — feed the AI-chats counter so the stats
          // screen shows truth (previously recordAIChat had zero call sites).
          try {
            await RateAppService.instance.recordAIChat();
          } catch (_) {
            // Counter is additive; never block the AI response.
          }
          return choices[0]['message']['content'] as String? ?? 'No response';
        }
      } catch (e) {
        debugPrint('AI ${provider.name} chat failed: $e');
        continue;
      }
    }

    return 'No AI provider configured. Add an API key in Settings → AI.';
  }

  /// Test a specific provider's connection.
  Future<bool> testProvider(AIProviderType type) async {
    final config = AIProviders.fallbackChain.firstWhere(
      (p) => p.type == type,
      orElse: () => AIProviders.openCodeZen,
    );
    final apiKey = await _keyStore.getKey(type);
    if (apiKey == null || apiKey.isEmpty) return false;

    try {
      final result = await _callProvider(
        provider: config,
        apiKey: apiKey,
        prompt: 'Say "OK" in one word.',
        systemPrompt: 'Respond with exactly one word.',
        temperature: 0,
        maxTokens: 10,
      );
      return result.isNotEmpty && !result.startsWith('AI error');
    } catch (e) {
      debugPrint('Provider test failed: $e');
      return false;
    }
  }

  /// Generate a JSON-array completion (low temperature, strict output).
  /// Returns parsed JSON list, or null if no provider worked / parse failed.
  Future<List<Map<String, dynamic>>?> generateJson({
    required String prompt,
    String? systemPromptOverride,
    double temperature = 0.3,
    int maxTokens = 2048,
  }) async {
    final raw = await generate(
      prompt: prompt,
      systemPromptOverride: systemPromptOverride,
      temperature: temperature,
      maxTokens: maxTokens,
    );
    if (raw.isEmpty || raw.startsWith('No AI provider') || raw.startsWith('No response')) {
      return null;
    }
    final list = AiJson.extractJsonArray(raw);
    return list.isEmpty ? null : list;
  }

  /// Get the name of the currently active provider.
  Future<String> getActiveProviderName() async {
    final provider = await _keyStore.getActiveProvider();
    _cachedProviderName = provider?.name ?? 'None';
    return _cachedProviderName!;
  }

  /// Get cached provider name (set after last async call).
  String getActiveProviderNameSync() {
    return _cachedProviderName ?? 'None';
  }

  String? _cachedProviderName;

  Future<String> _callProvider({
    required AIProviderConfig provider,
    required String apiKey,
    required String prompt,
    required String systemPrompt,
    required double temperature,
    required int maxTokens,
  }) async {
    final response = await _dio.post(
      '${provider.baseUrl}/chat/completions',
      options: Options(headers: {'Authorization': 'Bearer $apiKey'}),
      data: {
        'model': provider.model,
        'messages': [
          {'role': 'system', 'content': systemPrompt},
          {'role': 'user', 'content': prompt},
        ],
        'temperature': temperature,
        'max_tokens': maxTokens,
      },
    );

    final data = response.data as Map<String, dynamic>;
    final choices = data['choices'] as List?;
    if (choices != null && choices.isNotEmpty) {
      return choices[0]['message']['content'] as String? ?? 'No response';
    }
    return 'No response from AI.';
  }
}

/// Simple chat message.
class ChatMessage {
  const ChatMessage({required this.role, required this.content});
  final String role;
  final String content;
}
