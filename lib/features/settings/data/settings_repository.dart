import 'package:shared_preferences/shared_preferences.dart';
import 'package:profileforge/core/ai/ai_provider.dart';
import 'package:profileforge/features/settings/domain/settings_models.dart';

/// Persists app settings. Theme/name/email/toggles live in SharedPreferences;
/// API keys stay in secure storage (AIKeyStore) — one source of truth for
/// both, so screens no longer touch the stores directly.
class SettingsRepository {
  SettingsRepository({SharedPreferences? prefs}) : _prefs = prefs;
  SharedPreferences? _prefs;

  static const _themeModeKey = 'pf_theme_mode';
  static const _userNameKey = 'pf_user_name';
  static const _userEmailKey = 'pf_user_email';
  static const _notificationsKey = 'pf_notifications';
  static const _hapticKey = 'pf_haptic_feedback';

  final AIKeyStore _keyStore = AIKeyStore();

  Future<SharedPreferences> get _instance async =>
      _prefs ??= await SharedPreferences.getInstance();

  /// ── Theme mode ──────────────────────────────────────────────────────────
  Future<void> setThemeMode(ThemeModeOption mode) async {
    final prefs = await _instance;
    await prefs.setString(_themeModeKey, mode.name);
  }

  /// ── Profile info & toggles ──────────────────────────────────────────────
  Future<AppSettings> load() async {
    final prefs = await _instance;
    final mode = prefs.getString(_themeModeKey) ?? 'system';
    return AppSettings(
      themeMode: ThemeModeOption.values.firstWhere(
        (e) => e.name == mode,
        orElse: () => ThemeModeOption.system,
      ),
      userName: prefs.getString(_userNameKey) ?? '',
      userEmail: prefs.getString(_userEmailKey) ?? '',
      notificationsEnabled: prefs.getBool(_notificationsKey) ?? true,
      hapticFeedback: prefs.getBool(_hapticKey) ?? true,
    );
  }

  Future<void> setUserName(String name) async {
    final prefs = await _instance;
    await prefs.setString(_userNameKey, name);
  }

  Future<void> setUserEmail(String email) async {
    final prefs = await _instance;
    await prefs.setString(_userEmailKey, email);
  }

  Future<void> setNotificationsEnabled(bool enabled) async {
    final prefs = await _instance;
    await prefs.setBool(_notificationsKey, enabled);
  }

  Future<void> setHapticFeedback(bool enabled) async {
    final prefs = await _instance;
    await prefs.setBool(_hapticKey, enabled);
  }

  /// Wipes all locally stored prefs (clear-all-data action).
  Future<void> clearAll() async {
    final prefs = await _instance;
    await prefs.clear();
  }

  /// ── API keys (secure storage) ───────────────────────────────────────────
  Future<String?> getApiKey(AIProviderType type) => _keyStore.getKey(type);

  Future<void> setApiKey(AIProviderType type, String key) =>
      _keyStore.setKey(type, key);

  Future<void> removeApiKey(AIProviderType type) => _keyStore.removeKey(type);
}