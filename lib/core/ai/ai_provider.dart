import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Supported AI providers (all OpenAI-compatible endpoints).
enum AIProviderType {
  openCodeZen,
  router,
  nvidiaNim,
}

/// Provider configuration.
class AIProviderConfig {
  const AIProviderConfig({
    required this.type,
    required this.name,
    required this.baseUrl,
    required this.model,
    this.apiKeyStorageKey = '',
  });

  final AIProviderType type;
  final String name;
  final String baseUrl;
  final String model;
  final String apiKeyStorageKey;
}

/// Pre-configured providers.
class AIProviders {
  static const openCodeZen = AIProviderConfig(
    type: AIProviderType.openCodeZen,
    name: 'OpenCode Zen',
    baseUrl: 'https://api.opencode.ai/v1',
    model: 'mimo-v2.5-free',
    apiKeyStorageKey: 'ai_key_opencode_zen',
  );

  static const router = AIProviderConfig(
    type: AIProviderType.router,
    name: '9Router',
    baseUrl: 'http://localhost:20128/v1',
    model: 'deepseek-v4-free',
    apiKeyStorageKey: 'ai_key_router',
  );

  static const nvidiaNim = AIProviderConfig(
    type: AIProviderType.nvidiaNim,
    name: 'Nvidia NIM',
    baseUrl: 'https://integrate.api.nvidia.com/v1',
    model: 'nvidia/llama-3.3-nemotron-super-49b-v1',
    apiKeyStorageKey: 'ai_key_nvidia',
  );

  /// Fallback order: free models first.
  static const fallbackChain = [openCodeZen, router, nvidiaNim];
}

/// Manages API keys in secure storage.
class AIKeyStore {
  AIKeyStore({FlutterSecureStorage? storage})
      : _storage = storage ?? const FlutterSecureStorage();

  final FlutterSecureStorage _storage;

  Future<String?> getKey(AIProviderType type) async {
    final config = AIProviders.fallbackChain.firstWhere(
      (p) => p.type == type,
      orElse: () => AIProviders.openCodeZen,
    );
    return _storage.read(key: config.apiKeyStorageKey);
  }

  Future<void> setKey(AIProviderType type, String key) async {
    final config = AIProviders.fallbackChain.firstWhere(
      (p) => p.type == type,
      orElse: () => AIProviders.openCodeZen,
    );
    await _storage.write(key: config.apiKeyStorageKey, value: key);
  }

  Future<void> removeKey(AIProviderType type) async {
    final config = AIProviders.fallbackChain.firstWhere(
      (p) => p.type == type,
      orElse: () => AIProviders.openCodeZen,
    );
    await _storage.delete(key: config.apiKeyStorageKey);
  }

  /// Returns the first provider with a valid API key.
  Future<AIProviderConfig?> getActiveProvider() async {
    for (final provider in AIProviders.fallbackChain) {
      final key = await _storage.read(key: provider.apiKeyStorageKey);
      if (key != null && key.isNotEmpty) return provider;
    }
    return null;
  }
}
