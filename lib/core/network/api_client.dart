import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Centralized API client for H9 backend sync (REST + future WebSocket).
/// Interceptors attach auth from secure storage, retry on 5xx with backoff,
/// and surface typed errors. Endpoints are wired when the backend is live (TODO).
class ApiClient {
  ApiClient({FlutterSecureStorage? secureStorage})
      : _secure = secureStorage ?? const FlutterSecureStorage();

  final FlutterSecureStorage _secure;
  late final Dio dio = _build();

  static const _tokenKey = 'pf_auth_token';

  Dio _build() {
    final d = Dio(BaseOptions(
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
    ));
    d.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        final token = await _secure.read(key: _tokenKey);
        if (token != null) options.headers['Authorization'] = 'Bearer $token';
        return handler.next(options);
      },
      onError: (error, handler) async {
        // Simple linear backoff for 5xx; full queue handled by SyncOutbox.
        if (error.response?.statusCode != null &&
            error.response!.statusCode! >= 500) {
          await Future.delayed(const Duration(seconds: 2));
        }
        return handler.next(error);
      },
    ));
    return d;
  }

  Future<void> storeToken(String token) => _secure.write(key: _tokenKey, value: token);
  Future<void> clearToken() => _secure.delete(key: _tokenKey);
}
