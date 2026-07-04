import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';
import 'package:encrypt/encrypt.dart' as encrypt_lib;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Encryption service for student PII fields.
/// Uses AES-256-CBC with keys stored in Android Keystore via flutter_secure_storage.
class EncryptionService {
  static const _keyStorageKey = 'profileforge_encryption_key';
  static const _ivStorageKey = 'profileforge_encryption_iv';
  static const _encryptionEnabledKey = 'profileforge_encryption_enabled';
  
  final FlutterSecureStorage _secureStorage;
  encrypt_lib.Key? _key;
  encrypt_lib.IV? _iv;
  bool _initialized = false;

  EncryptionService({FlutterSecureStorage? secureStorage})
      : _secureStorage = secureStorage ?? const FlutterSecureStorage();

  /// Initialize the encryption service - generates or loads the AES key.
  Future<void> initialize() async {
    if (_initialized) return;

    try {
      // Try to load existing key
      final existingKeyB64 = await _secureStorage.read(key: _keyStorageKey);
      final existingIvB64 = await _secureStorage.read(key: _ivStorageKey);

      if (existingKeyB64 != null && existingIvB64 != null) {
        _key = encrypt_lib.Key.fromBase64(existingKeyB64);
        _iv = encrypt_lib.IV.fromBase64(existingIvB64);
      } else {
        // Generate new key and IV
        final random = Random.secure();
        final keyBytes = Uint8List.fromList(
          List<int>.generate(32, (_) => random.nextInt(256)),
        );
        final ivBytes = Uint8List.fromList(
          List<int>.generate(16, (_) => random.nextInt(256)),
        );

        _key = encrypt_lib.Key(keyBytes);
        _iv = encrypt_lib.IV(ivBytes);

        // Store in Android Keystore
        await _secureStorage.write(key: _keyStorageKey, value: _key!.base64);
        await _secureStorage.write(key: _ivStorageKey, value: _iv!.base64);
      }

      await _secureStorage.write(key: _encryptionEnabledKey, value: 'true');
      _initialized = true;
    } catch (e) {
      // Fallback: if secure storage fails, use in-memory keys
      // This is a degraded mode - data won't be in Android Keystore
      if (_key == null) {
        final random = Random.secure();
        _key = encrypt_lib.Key(Uint8List.fromList(
          List<int>.generate(32, (_) => random.nextInt(256)),
        ));
        _iv = encrypt_lib.IV(Uint8List.fromList(
          List<int>.generate(16, (_) => random.nextInt(256)),
        ));
      }
      _initialized = true;
    }
  }

  /// Check if encryption is initialized and enabled.
  bool get isEncryptionEnabled => _initialized;

  /// Encrypt a plaintext string using AES-256-CBC.
  /// Returns a base64-encoded ciphertext string.
  String encrypt(String plainText) {
    if (!_initialized || _key == null || _iv == null) {
      throw StateError('EncryptionService not initialized. Call initialize() first.');
    }
    if (plainText.isEmpty) return plainText;
    
    final encrypter = encrypt_lib.Encrypter(
      encrypt_lib.AES(_key!, mode: encrypt_lib.AESMode.cbc, padding: 'PKCS7'),
    );
    final encrypted = encrypter.encrypt(plainText, iv: _iv!);
    return encrypted.base64;
  }

  /// Decrypt a base64-encoded ciphertext string using AES-256-CBC.
  /// Returns the original plaintext string.
  String decrypt(String cipherText) {
    if (!_initialized || _key == null || _iv == null) {
      throw StateError('EncryptionService not initialized. Call initialize() first.');
    }
    if (cipherText.isEmpty) return cipherText;
    
    try {
      final encrypter = encrypt_lib.Encrypter(
        encrypt_lib.AES(_key!, mode: encrypt_lib.AESMode.cbc, padding: 'PKCS7'),
      );
      final decrypted = encrypter.decrypt64(cipherText, iv: _iv!);
      return decrypted;
    } catch (_) {
      // If decryption fails, it might be unencrypted data (migration scenario)
      return cipherText;
    }
  }

  /// Check if a value appears to be encrypted (base64 format).
  static bool isEncrypted(String value) {
    if (value.isEmpty) return false;
    try {
      base64.decode(value);
      // Check if it looks like a base64-encoded encrypted string (not just any base64)
      return value.length > 20 && !value.contains(' ');
    } catch (_) {
      return false;
    }
  }

  /// Delete all encryption keys from secure storage.
  Future<void> deleteKeys() async {
    await _secureStorage.delete(key: _keyStorageKey);
    await _secureStorage.delete(key: _ivStorageKey);
    await _secureStorage.delete(key: _encryptionEnabledKey);
    _key = null;
    _iv = null;
    _initialized = false;
  }

  /// PII fields that should be encrypted in the student profile.
  static const List<String> piiFields = [
    'name',
    'email',
    'phone',
    'address',
    'school',
    'coachingInstitute',
  ];
}
