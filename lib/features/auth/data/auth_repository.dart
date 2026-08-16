import 'package:shared_preferences/shared_preferences.dart';
import 'package:profileforge/features/auth/domain/auth_models.dart';

/// Device-local auth state. Backed by SharedPreferences — the same keys the
/// auth screens and the splash gate already used.
class AuthRepository {
  static const String _guestKey = 'pf_is_guest';
  static const String _tokenKey = 'pf_auth_token';
  static const String _emailKey = 'pf_user_email';

  final SharedPreferences _prefs;
  const AuthRepository(this._prefs);

  /// "Maybe later" — keep everything on-device as a guest.
  Future<void> continueAsGuest() => _prefs.setBool(_guestKey, true);

  /// Email magic link "verification" (demo backend): stores the demo token
  /// and the entered email, exactly like the old inline flow.
  Future<AuthUser> signInWithEmail(String email) async {
    await _prefs.setString(_tokenKey, 'demo-token');
    await _prefs.setString(_emailKey, email.trim());
    return currentUser();
  }

  AuthUser currentUser() {
    return AuthUser(
      email: _prefs.getString(_emailKey),
      isGuest: _prefs.getBool(_guestKey) ?? false,
      token: _prefs.getString(_tokenKey),
    );
  }
}