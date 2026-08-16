/// Theme appearance preference (persisted by the settings repository).
enum ThemeModeOption { system, light, dark }

/// App preferences persisted locally. Theme mode drives the app-wide
/// appearance; the rest are feature toggles + profile info.
class AppSettings {
  final ThemeModeOption themeMode;
  final String userName;
  final String userEmail;
  final bool notificationsEnabled;
  final bool hapticFeedback;

  const AppSettings({
    this.themeMode = ThemeModeOption.system,
    this.userName = '',
    this.userEmail = '',
    this.notificationsEnabled = true,
    this.hapticFeedback = true,
  });

  AppSettings copyWith({
    ThemeModeOption? themeMode,
    String? userName,
    String? userEmail,
    bool? notificationsEnabled,
    bool? hapticFeedback,
  }) {
    return AppSettings(
      themeMode: themeMode ?? this.themeMode,
      userName: userName ?? this.userName,
      userEmail: userEmail ?? this.userEmail,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      hapticFeedback: hapticFeedback ?? this.hapticFeedback,
    );
  }
}