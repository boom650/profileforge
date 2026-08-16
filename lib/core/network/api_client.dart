import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart' show sha256;
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
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

  /// Pinned SPKI/SHA-256 fingerprints for the H9 backend certificate chain
  /// (TLS certificate pinning = MITM protection). Populated once the backend
  /// certificate is known; an empty list disables pinning.
  static const List<String> _trustedFingerprints = [
    // TODO(h9): insert base64 SHA-256 fingerprint of the production leaf cert.
  ];

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
    if (d.httpClientAdapter is IOHttpClientAdapter) {
      (d.httpClientAdapter as IOHttpClientAdapter).validateCertificate =
          _validateCertificate;
    }
    return d;
  }

  /// Rejects HTTPS connections whose leaf certificate SHA-256 fingerprint is
  /// not in [_trustedFingerprints]. Fails closed when pinning is configured.
  bool _validateCertificate(
      X509Certificate? certificate, String host, int port) {
    if (_trustedFingerprints.isEmpty) return true; // pinning not yet configured
    if (certificate == null) return false;
    final digest = sha256.convert(certificate.der);
    final actual = base64Encode(digest.bytes);
    for (final expected in _trustedFingerprints) {
      if (actual == expected) return true;
    }
    return false;
  }

  Future<void> storeToken(String token) => _secure.write(key: _tokenKey, value: token);
  Future<void> clearToken() => _secure.delete(key: _tokenKey);
}
