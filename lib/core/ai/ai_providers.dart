import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'llm_client.dart';

const _secureStorage = FlutterSecureStorage();
const _apiKeyStorageKey = 'llm_api_key';
const _providerStorageKey = 'llm_provider';
const _baseUrlStorageKey = 'llm_base_url';
const _modelStorageKey = 'llm_model';

/// Provider for the selected LLM provider
final llmProviderTypeProvider = FutureProvider<LlmProvider>((ref) async {
  final name = await _secureStorage.read(key: _providerStorageKey);
  if (name == null) return LlmProvider.opencodeZen;
  return LlmProvider.values.firstWhere(
    (p) => p.name == name,
    orElse: () => LlmProvider.opencodeZen,
  );
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

/// Provider for LlmService instance (null if no API key)
final llmServiceProvider = FutureProvider<LlmService?>((ref) async {
  final apiKey = await ref.watch(llmApiKeyProvider.future);
  if (apiKey == null || apiKey.isEmpty) return null;

  final providerType = await ref.watch(llmProviderTypeProvider.future);
  final baseUrl = await ref.watch(llmBaseUrlProvider.future);
  final model = await ref.watch(llmModelProvider.future);

  return LlmService(
    apiKey: apiKey,
    provider: providerType,
    baseUrl: providerType == LlmProvider.custom ? baseUrl : null,
    model: providerType == LlmProvider.custom ? model : null,
  );
});

/// Provider for checking if AI is configured
final aiConfiguredProvider = FutureProvider<bool>((ref) async {
  final service = await ref.watch(llmServiceProvider.future);
  return service != null;
});

/// Save LLM configuration
Future<void> saveLlmConfig({
  required String apiKey,
  required LlmProvider provider,
  String? baseUrl,
  String? model,
}) async {
  await _secureStorage.write(key: _apiKeyStorageKey, value: apiKey);
  await _secureStorage.write(key: _providerStorageKey, value: provider.name);
  if (baseUrl != null) await _secureStorage.write(key: _baseUrlStorageKey, value: baseUrl);
  if (model != null) await _secureStorage.write(key: _modelStorageKey, value: model);
}

/// Delete all LLM config
Future<void> deleteLlmConfig() async {
  await _secureStorage.delete(key: _apiKeyStorageKey);
  await _secureStorage.delete(key: _providerStorageKey);
  await _secureStorage.delete(key: _baseUrlStorageKey);
  await _secureStorage.delete(key: _modelStorageKey);
}
