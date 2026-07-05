import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';
import 'package:encrypt/encrypt.dart' as encrypt_lib;
import 'package:shared_preferences/shared_preferences.dart';

/// Web-compatible encryption service.
/// Uses SharedPreferences instead of FlutterSecureStorage (which requires dart:io).
/// Provides same API as EncryptionService but stores keys in SharedPreferences.
class EncryptionServiceWeb {
  static const _keyStorageKey = 'profileforge_encryption_key';
  static const _ivStorageKey = 'profileforge_encryption_iv';
  static const _encryptionEnabledKey = 'profileforge_encryption_enabled';

  encrypt_lib.Key? _key;
  encrypt_lib.IV? _iv;
  bool _initialized = false;

  EncryptionServiceWeb();

  /// Initialize the encryption service - generates or loads the AES key.
  Future<void> initialize() async {
    if (_initialized) return;
    try {
      final prefs = await SharedPreferences.getInstance();
      final existingKeyB64 = prefs.getString(_keyStorageKey);
      final existingIvB64 = prefs.getString(_ivStorageKey);

      if (existingKeyB64 != null && existingIvB64 != null) {
        _key = encrypt_lib.Key.fromBase64(existingKeyB64);
        _iv = encrypt_lib.IV.fromBase64(existingIvB64);
      } else {
        final random = Random.secure();
        final keyBytes = Uint8List.fromList(
          List<int>.generate(32, (_) => random.nextInt(256)),
        );
        final ivBytes = Uint8List.fromList(
          List<int>.generate(16, (_) => random.nextInt(256)),
        );
        _key = encrypt_lib.Key(keyBytes);
        _iv = encrypt_lib.IV(ivBytes);

        await prefs.setString(_keyStorageKey, _key!.base64);
        await prefs.setString(_ivStorageKey, _iv!.base64);
      }

      await prefs.setBool(_encryptionEnabledKey, true);
      _initialized = true;
    } catch (e) {
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

  bool get isEncryptionEnabled => _initialized;

  String encrypt(String plainText) {
    if (!_initialized || _key == null || _iv == null) {
      throw StateError('EncryptionService not initialized.');
    }
    if (plainText.isEmpty) return plainText;
    final encrypter = encrypt_lib.Encrypter(
      encrypt_lib.AES(_key!, mode: encrypt_lib.AESMode.cbc, padding: 'PKCS7'),
    );
    return encrypter.encrypt(plainText, iv: _iv!).base64;
  }

  String decrypt(String cipherText) {
    if (!_initialized || _key == null || _iv == null) {
      throw StateError('EncryptionService not initialized.');
    }
    if (cipherText.isEmpty) return cipherText;
    try {
      final encrypter = encrypt_lib.Encrypter(
        encrypt_lib.AES(_key!, mode: encrypt_lib.AESMode.cbc, padding: 'PKCS7'),
      );
      return encrypter.decrypt64(cipherText, iv: _iv!);
    } catch (_) {
      return cipherText;
    }
  }

  static bool isEncrypted(String value) {
    if (value.isEmpty) return false;
    try {
      base64.decode(value);
      return value.length > 20 && !value.contains(' ');
    } catch (_) {
      return false;
    }
  }

  Future<void> deleteKeys() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyStorageKey);
    await prefs.remove(_ivStorageKey);
    await prefs.remove(_encryptionEnabledKey);
    _key = null;
    _iv = null;
    _initialized = false;
  }

  static const List<String> piiFields = [
    'name', 'email', 'phone', 'address', 'school', 'coachingInstitute',
  ];
}
