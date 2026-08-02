import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'gemini_service.dart';

const _secureStorage = FlutterSecureStorage();
const _apiKeyStorageKey = 'gemini_api_key';

/// Provider for the Gemini API key
final geminiApiKeyProvider = FutureProvider<String?>((ref) async {
  return await _secureStorage.read(key: _apiKeyStorageKey);
});

/// Provider for GeminiService instance (null if no API key)
final geminiServiceProvider = FutureProvider<GeminiService?>((ref) async {
  final apiKey = await ref.watch(geminiApiKeyProvider.future);
  if (apiKey == null || apiKey.isEmpty) return null;
  return GeminiService(apiKey: apiKey);
});

/// Provider for checking if AI is configured
final aiConfiguredProvider = FutureProvider<bool>((ref) async {
  final service = await ref.watch(geminiServiceProvider.future);
  return service != null;
});

/// Save API key to secure storage
Future<void> saveGeminiApiKey(String apiKey) async {
  await _secureStorage.write(key: _apiKeyStorageKey, value: apiKey);
}

/// Delete API key from secure storage
Future<void> deleteGeminiApiKey() async {
  await _secureStorage.delete(key: _apiKeyStorageKey);
}
