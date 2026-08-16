import 'package:shared_preferences/shared_preferences.dart';
import 'package:profileforge/features/splash/domain/splash_models.dart';

/// First-run checks backed by SharedPreferences — decides the splash
/// destination. Keys mirror the ones written by the onboarding flow
/// (`pf_onboarded`) and the auth flow (`pf_auth_token`).
class SplashRepository {
  SplashRepository({SharedPreferences? prefs}) : _prefs = prefs;
  SharedPreferences? _prefs;

  static const _onboardedKey = 'pf_onboarded';
  static const _authTokenKey = 'pf_auth_token';

  Future<SharedPreferences> get _instance async =>
      _prefs ??= await SharedPreferences.getInstance();

  /// Whether the user completed onboarding.
  Future<bool> hasOnboarded() async {
    final prefs = await _instance;
    return prefs.getBool(_onboardedKey) ?? false;
  }

  /// Whether an auth token exists (signed up / signed in).
  Future<bool> hasAuthToken() async {
    final prefs = await _instance;
    return prefs.getString(_authTokenKey) != null;
  }

  /// Combined status used for splash routing.
  Future<SplashStatus> currentStatus() async {
    final prefs = await _instance;
    final hasOnboarded = prefs.getBool(_onboardedKey) ?? false;
    final hasAuth = prefs.getString(_authTokenKey) != null;
    if (hasOnboarded && hasAuth) return SplashStatus.fullySetUp;
    if (hasOnboarded && !hasAuth) return SplashStatus.needsAuth;
    return SplashStatus.newUser;
  }
}