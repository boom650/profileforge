/// Encryption service — conditionally imports native or web implementation.
/// Native: uses FlutterSecureStorage (Android Keystore / iOS Keychain).
/// Web: uses SharedPreferences (no dart:io dependency).
import 'connection/encryption_native.dart'
    if (dart.library.js_interop) 'connection/encryption_web.dart';

export 'connection/encryption_native.dart'
    if (dart.library.js_interop) 'connection/encryption_web.dart';
