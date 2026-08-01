import 'dart:convert';
import 'dart:math' as math;

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// ────────────────────────────────────────────────────────────────────────────
/// FallbackLlmClient — Multi-provider LLM client with automatic failover.
///
/// Strategy:
/// 1. Try primary provider (OpenCode Zen — free models)
/// 2. If fails → try Nvidia NIM (free tier)
/// 3. If fails → try 9Router (aggregated free models)
/// 4. If all fail → return error message
///
/// Each provider has a list of free models tried in priority order.
/// On 429 (rate limit) or 5xx, immediately moves to next provider.
/// On 401 (auth error), marks provider as unavailable for 5 minutes.
/// ────────────────────────────────────────────────────────────────────────────

/// Configuration for a single LLM provider.
class LlmProviderConfig {
  const LlmProviderConfig({
    required this.name,
    required this.baseUrl,
    required this.apiKey,
    required this.freeModels,
    this.defaultHeaders = const {},
    this.cooldownMinutes = 5,
  });

  final String name;
  final String baseUrl;
  final String apiKey;
  final List<String> freeModels;
  final Map<String, String> defaultHeaders;
  final int cooldownMinutes;
}

/// Result from an LLM call.
class LlmResult {
  const LlmResult({
    required this.content,
    required this.providerName,
    required this.modelUsed,
    this.isFromCache = false,
  });

  final String content;
  final String providerName;
  final String modelUsed;
  final bool isFromCache;
}

/// Tracks provider health and cooldowns.
class _ProviderHealth {
  _ProviderHealth({required this.config})
      : lastError = null,
        cooldownUntil = DateTime.fromMillisecondsSinceEpoch(0),
        consecutiveFailures = 0;

  final LlmProviderConfig config;
  String? lastError;
  DateTime cooldownUntil;
  int consecutiveFailures;

  bool get isOnCooldown => DateTime.now().isBefore(cooldownUntil);

  void recordFailure(String error, {bool isRateLimit = false, bool isAuthError = false}) {
    lastError = error;
    consecutiveFailures++;
    if (isAuthError) {
      // Auth errors → long cooldown
      cooldownUntil = DateTime.now().add(Duration(minutes: config.cooldownMinutes * 6));
    } else if (isRateLimit) {
      // Rate limit → short cooldown
      cooldownUntil = DateTime.now().add(Duration(seconds: 30 * consecutiveFailures));
    } else if (consecutiveFailures >= 3) {
      // Repeated failures → medium cooldown
      cooldownUntil = DateTime.now().add(Duration(minutes: config.cooldownMinutes));
    }
  }

  void recordSuccess() {
    lastError = null;
    consecutiveFailures = 0;
    cooldownUntil = DateTime.fromMillisecondsSinceEpoch(0);
  }
}

/// Multi-provider fallback LLM client.
class FallbackLlmClient {
  FallbackLlmClient({
    required this.providers,
    this.systemPrompt = _defaultSystemPrompt,
    this.preferredProvider,
  }) : assert(providers.isNotEmpty, 'At least one provider required') {
    _health.addAll(providers.map((p) => _ProviderHealth(config: p)));
  }

  final List<LlmProviderConfig> providers;
  final String systemPrompt;
  final String? preferredProvider;

  final List<_ProviderHealth> _health = [];
  final Dio _dio = Dio(BaseOptions(
    connectTimeout: const Duration(seconds: 15),
    receiveTimeout: const Duration(seconds: 60),
  ));

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

  /// Get providers in priority order (preferred first, then others).
  List<_ProviderHealth> _orderedProviders() {
    final ordered = <_ProviderHealth>[];
    
    // Put preferred provider first if available and not on cooldown.
    if (preferredProvider != null) {
      final preferred = _health.firstWhere(
        (h) => h.config.name == preferredProvider && !h.isOnCooldown,
        orElse: () => _health[0],
      );
      ordered.add(preferred);
    }
    
    // Add remaining providers (skip duplicates and those on cooldown).
    for (final h in _health) {
      if (!ordered.contains(h) && !h.isOnCooldown) {
        ordered.add(h);
      }
    }
    
    return ordered;
  }

  /// Single-turn generation with automatic fallback.
  Future<LlmResult> generate(String prompt, {List<Map<String, String>>? history}) async {
    final ordered = _orderedProviders();
    
    if (ordered.isEmpty) {
      // All providers on cooldown — try anyway with shortest cooldown.
      final shortest = _health
        ..sort((a, b) => a.cooldownUntil.compareTo(b.cooldownUntil));
      ordered.add(shortest.first);
    }

    DioException? lastDioError;
    String? lastError;

    for (final health in ordered) {
      for (final model in health.config.freeModels) {
        try {
          debugPrint('[LLM] Trying ${health.config.name} / $model');
          
          final messages = [
            {'role': 'system', 'content': systemPrompt},
            if (history != null) ...history,
            {'role': 'user', 'content': prompt},
          ];

          final response = await _dio.post(
            '${health.config.baseUrl}/chat/completions',
            data: {
              'model': model,
              'messages': messages,
              'temperature': 0.7,
              'max_tokens': 2048,
            },
            options: Options(
              headers: {
                'Authorization': 'Bearer ${health.config.apiKey}',
                'Content-Type': 'application/json',
                ...health.config.defaultHeaders,
              },
            ),
          );

          final choices = response.data['choices'] as List?;
          if (choices != null && choices.isNotEmpty) {
            final content = choices[0]['message']['content'] ?? '';
            if (content.isNotEmpty) {
              health.recordSuccess();
              debugPrint('[LLM] ✅ ${health.config.name} / $model succeeded');
              return LlmResult(
                content: content,
                providerName: health.config.name,
                modelUsed: model,
              );
            }
          }
          // Empty response — try next model.
          lastError = 'Empty response from ${health.config.name}/$model';
        } on DioException catch (e) {
          lastDioError = e;
          final statusCode = e.response?.statusCode;
          
          if (statusCode == 401 || statusCode == 403) {
            debugPrint('[LLM] ❌ ${health.config.name} auth error ($statusCode)');
            health.recordFailure('Auth error $statusCode', isAuthError: true);
            break; // Skip all models for this provider.
          } else if (statusCode == 429) {
            debugPrint('[LLM] ⏳ ${health.config.name} rate limited');
            health.recordFailure('Rate limited', isRateLimit: true);
            break; // Try next provider.
          } else if (statusCode != null && statusCode >= 500) {
            debugPrint('[LLM] 🔥 ${health.config.name} server error ($statusCode)');
            health.recordFailure('Server error $statusCode');
            break; // Try next provider.
          } else {
            debugPrint('[LLM] ⚠️ ${health.config.name} network error: ${e.message}');
            lastError = e.message ?? 'Network error';
            // Network errors → try next model with this provider.
          }
        } catch (e) {
          debugPrint('[LLM] 💥 ${health.config.name} unexpected: $e');
          lastError = e.toString();
          health.recordFailure(e.toString());
          break;
        }
      }
    }

    // All providers failed.
    final providerStatus = _health.map((h) => 
      '${h.config.name}: ${h.isOnCooldown ? "cooldown" : h.lastError ?? "no models"}'
    ).join(', ');
    
    return LlmResult(
      content: 'AI unavailable. Providers: $providerStatus',
      providerName: 'none',
      modelUsed: 'none',
    );
  }

  /// Multi-turn chat with automatic fallback.
  Future<LlmResult> chat(List<Map<String, String>> messages) async {
    final ordered = _orderedProviders();
    
    if (ordered.isEmpty) {
      final shortest = _health
        ..sort((a, b) => a.cooldownUntil.compareTo(b.cooldownUntil));
      ordered.add(shortest.first);
    }

    for (final health in ordered) {
      for (final model in health.config.freeModels) {
        try {
          debugPrint('[LLM] Trying ${health.config.name} / $model (chat)');
          
          final fullMessages = [
            {'role': 'system', 'content': systemPrompt},
            ...messages,
          ];

          final response = await _dio.post(
            '${health.config.baseUrl}/chat/completions',
            data: {
              'model': model,
              'messages': fullMessages,
              'temperature': 0.7,
              'max_tokens': 2048,
            },
            options: Options(
              headers: {
                'Authorization': 'Bearer ${health.config.apiKey}',
                'Content-Type': 'application/json',
                ...health.config.defaultHeaders,
              },
            ),
          );

          final choices = response.data['choices'] as List?;
          if (choices != null && choices.isNotEmpty) {
            final content = choices[0]['message']['content'] ?? '';
            if (content.isNotEmpty) {
              health.recordSuccess();
              return LlmResult(
                content: content,
                providerName: health.config.name,
                modelUsed: model,
              );
            }
          }
        } on DioException catch (e) {
          final statusCode = e.response?.statusCode;
          if (statusCode == 401 || statusCode == 403) {
            health.recordFailure('Auth error', isAuthError: true);
            break;
          } else if (statusCode == 429) {
            health.recordFailure('Rate limited', isRateLimit: true);
            break;
          } else if (statusCode != null && statusCode >= 500) {
            health.recordFailure('Server error $statusCode');
            break;
          }
        } catch (e) {
          health.recordFailure(e.toString());
          break;
        }
      }
    }

    return LlmResult(
      content: 'AI unavailable. All providers exhausted.',
      providerName: 'none',
      modelUsed: 'none',
    );
  }

  /// Streaming generation with automatic fallback.
  Stream<LlmResult> generateStream(String prompt) async* {
    final ordered = _orderedProviders();
    
    if (ordered.isEmpty) {
      final shortest = _health
        ..sort((a, b) => a.cooldownUntil.compareTo(b.cooldownUntil));
      ordered.add(shortest.first);
    }

    for (final health in ordered) {
      for (final model in health.config.freeModels) {
        try {
          debugPrint('[LLM] Trying ${health.config.name} / $model (stream)');
          
          final response = await _dio.post(
            '${health.config.baseUrl}/chat/completions',
            data: {
              'model': model,
              'messages': [
                {'role': 'system', 'content': systemPrompt},
                {'role': 'user', 'content': prompt},
              ],
              'temperature': 0.7,
              'max_tokens': 2048,
              'stream': true,
            },
            options: Options(
              responseType: ResponseType.stream,
              headers: {
                'Authorization': 'Bearer ${health.config.apiKey}',
                'Content-Type': 'application/json',
                ...health.config.defaultHeaders,
              },
            ),
          );

          final stream = response.data as Stream;
          String buffer = '';
          bool hasContent = false;

          await for (final chunk in stream) {
            final text = String.fromCharCodes(chunk);
            buffer += text;

            final lines = buffer.split('\n');
            buffer = lines.removeLast();

            for (final line in lines) {
              if (line.startsWith('data: ')) {
                final data = line.substring(6).trim();
                if (data == '[DONE]') {
                  health.recordSuccess();
                  return;
                }
                try {
                  final json = jsonDecode(data) as Map<String, dynamic>;
                  final delta = json['choices']?[0]?['delta']?['content'];
                  if (delta != null && delta.isNotEmpty) {
                    hasContent = true;
                    yield LlmResult(
                      content: delta,
                      providerName: health.config.name,
                      modelUsed: model,
                    );
                  }
                } catch (_) {}
              }
            }
          }

          if (hasContent) {
            health.recordSuccess();
            return;
          }
        } on DioException catch (e) {
          final statusCode = e.response?.statusCode;
          if (statusCode == 401 || statusCode == 403) {
            health.recordFailure('Auth error', isAuthError: true);
            break;
          } else if (statusCode == 429) {
            health.recordFailure('Rate limited', isRateLimit: true);
            break;
          }
        } catch (e) {
          health.recordFailure(e.toString());
          break;
        }
      }
    }

    yield LlmResult(
      content: 'AI stream unavailable.',
      providerName: 'none',
      modelUsed: 'none',
    );
  }

  /// Get current health status of all providers.
  List<Map<String, dynamic>> getHealthStatus() {
    return _health.map((h) => {
      'name': h.config.name,
      'isOnCooldown': h.isOnCooldown,
      'consecutiveFailures': h.consecutiveFailures,
      'lastError': h.lastError,
      'cooldownUntil': h.cooldownUntil.toIso8601String(),
      'models': h.config.freeModels,
    }).toList();
  }

  void dispose() {
    _dio.close();
  }
}

/// ────────────────────────────────────────────────────────────────────────────
/// Secure storage for multiple API keys.
/// ────────────────────────────────────────────────────────────────────────────
class ApiKeyStore {
  static const _storage = FlutterSecureStorage();
  static const _prefix = 'llm_api_key_';

  /// Save an API key for a provider.
  static Future<void> saveKey(String providerName, String apiKey) async {
    await _storage.write(key: '$_prefix$providerName', value: apiKey);
  }

  /// Read an API key for a provider.
  static Future<String?> readKey(String providerName) async {
    return await _storage.read(key: '$_prefix$providerName');
  }

  /// Delete an API key for a provider.
  static Future<void> deleteKey(String providerName) async {
    await _storage.delete(key: '$_prefix$providerName');
  }

  /// Delete all API keys.
  static Future<void> deleteAll() async {
    await _storage.deleteAll();
  }
}
