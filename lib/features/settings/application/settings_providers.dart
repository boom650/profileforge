import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:profileforge/core/theme/app_theme.dart';
import 'package:profileforge/features/settings/data/settings_repository.dart';
import 'package:profileforge/features/settings/domain/settings_models.dart';

final settingsRepositoryProvider = Provider<SettingsRepository>((ref) {
  return SettingsRepository();
});

/// Loaded app settings — read once from storage, updated through the
/// notifier so every screen stays in sync.
final settingsProvider =
    AsyncNotifierProvider<SettingsNotifier, AppSettings>(SettingsNotifier.new);

class SettingsNotifier extends AsyncNotifier<AppSettings> {
  @override
  Future<AppSettings> build() async {
    return ref.watch(settingsRepositoryProvider).load();
  }

  Future<void> setUserName(String name) async {
    await ref.read(settingsRepositoryProvider).setUserName(name);
    state = AsyncData((state.valueOrNull ?? const AppSettings()).copyWith(userName: name));
  }

  Future<void> setUserEmail(String email) async {
    await ref.read(settingsRepositoryProvider).setUserEmail(email);
    state = AsyncData((state.valueOrNull ?? const AppSettings()).copyWith(userEmail: email));
  }

  Future<void> setNotificationsEnabled(bool enabled) async {
    await ref.read(settingsRepositoryProvider).setNotificationsEnabled(enabled);
    state = AsyncData((state.valueOrNull ?? const AppSettings()).copyWith(notificationsEnabled: enabled));
  }

  Future<void> setHapticFeedback(bool enabled) async {
    await ref.read(settingsRepositoryProvider).setHapticFeedback(enabled);
    state = AsyncData((state.valueOrNull ?? const AppSettings()).copyWith(hapticFeedback: enabled));
  }
}

/// Applies a theme mode: persists it via the repository AND drives the
/// app-wide theme (themeModeProvider in main.dart).
final setThemeProvider =
    NotifierProvider<SetThemeNotifier, void>(SetThemeNotifier.new);

class SetThemeNotifier extends Notifier<void> {
  @override
  void build() {}

  Future<void> execute(ThemeModeOption mode) async {
    final repo = ref.read(settingsRepositoryProvider);
    await repo.setThemeMode(mode);
    // Apply app-wide theme immediately (persists to its own key too).
    await ref.read(themeModeProvider.notifier).set(switch (mode) {
      ThemeModeOption.system => AppThemeMode.system,
      ThemeModeOption.light => AppThemeMode.light,
      ThemeModeOption.dark => AppThemeMode.dark,
    });
    ref.invalidate(settingsProvider);
  }
}