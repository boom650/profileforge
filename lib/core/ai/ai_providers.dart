import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'fallback_llm_client.dart';
import 'provider_config.dart';

const _secureStorage = FlutterSecureStorage();
const _apiKeyStorageKey = 'llm_api_key';
const _providerStorageKey = 'llm_provider';
const _baseUrlStorageKey = 'llm_base_url';
const _modelStorageKey = 'llm_model';

// ═════════════════════════════════════════════════════════════════════════════
// LEGACY PROVIDERS (kept for backward compatibility)
// ═════════════════════════════════════════════════════════════════════════════

/// Provider for the selected LLM provider
final llmProviderTypeProvider = FutureProvider<String>((ref) async {
  final name = await _secureStorage.read(key: _providerStorageKey);
  return name ?? 'OpenCode Zen';
});

/// Provider for the API key
final llmApiKeyProvider = FutureProvider<String?>((ref) async {
  return await _secureStorage.read(key: _apiKeyStorageKey);
});

/// Provider for custom base URL
final llmBaseUrlProvider = FutureProvider<String?>((ref) async {
  return await _secureStorage.read(key: _baseUrlStorageKey);
});

/// Provider for custom model name
final llmModelProvider = FutureProvider<String?>((ref) async {
  return await _secureStorage.read(key: _modelStorageKey);
});

/// Provider for checking if AI is configured
final aiConfiguredProvider = FutureProvider<bool>((ref) async {
  // Always configured with fallback system.
  return true;
});

// ═════════════════════════════════════════════════════════════════════════════
// FALLBACK LLM CLIENT — NEW MULTI-PROVIDER SYSTEM
// ═════════════════════════════════════════════════════════════════════════════

/// Singleton fallback LLM client.
FallbackLlmClient? _fallbackClient;

/// Get or create the fallback LLM client.
FallbackLlmClient getFallbackClient({String? systemPrompt}) {
  if (_fallbackClient == null) {
    _fallbackClient = ProfileForgeLlmConfig.createClient(
      systemPrompt: systemPrompt,
    );
  }
  return _fallbackClient!;
}

/// Riverpod provider for the fallback LLM client.
final fallbackLlmProvider = Provider<FallbackLlmClient>((ref) {
  return getFallbackClient();
});

/// Provider for health status of all LLM providers.
final llmHealthProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
  final client = ref.watch(fallbackLlmProvider);
  return client.getHealthStatus();
});

// ═════════════════════════════════════════════════════════════════════════════
// HIGH-LEVEL AI SERVICE
// ═════════════════════════════════════════════════════════════════════════════

/// High-level AI service that uses the fallback client.
class AiService {
  AiService._();

  static AiService? _instance;
  static AiService get instance => _instance ??= AiService._();

  /// Generate a response with automatic provider fallback.
  Future<String> generate(String prompt, {List<Map<String, String>>? history}) async {
    final client = getFallbackClient();
    final result = await client.generate(prompt, history: history);
    return result.content;
  }

  /// Chat with automatic provider fallback.
  Future<String> chat(List<Map<String, String>> messages) async {
    final client = getFallbackClient();
    final result = await client.chat(messages);
    return result.content;
  }

  /// Stream a response with automatic provider fallback.
  Stream<String> generateStream(String prompt) async* {
    final client = getFallbackClient();
    await for (final result in client.generateStream(prompt)) {
      yield result.content;
    }
  }

  /// Analyze an artifact with automatic provider fallback.
  Future<String> analyzeArtifact({
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
    return generate(prompt);
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

  /// Get health status of all providers.
  List<Map<String, dynamic>> getHealthStatus() {
    final client = getFallbackClient();
    return client.getHealthStatus();
  }
}

// ═════════════════════════════════════════════════════════════════════════════
// LEGACY COMPAT
// ═════════════════════════════════════════════════════════════════════════════

/// Save LLM configuration (legacy — now handled by fallback client).
Future<void> saveLlmConfig({
  required String apiKey,
  required String provider,
  String? baseUrl,
  String? model,
}) async {
  await _secureStorage.write(key: _apiKeyStorageKey, value: apiKey);
  await _secureStorage.write(key: _providerStorageKey, value: provider);
  if (baseUrl != null) await _secureStorage.write(key: _baseUrlStorageKey, value: baseUrl);
  if (model != null) await _secureStorage.write(key: _modelStorageKey, value: model);
}

/// Delete all LLM config (legacy).
Future<void> deleteLlmConfig() async {
  await _secureStorage.delete(key: _apiKeyStorageKey);
  await _secureStorage.delete(key: _providerStorageKey);
  await _secureStorage.delete(key: _baseUrlStorageKey);
  await _secureStorage.delete(key: _modelStorageKey);
}
