import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'ui/theme/app_theme.dart';
import 'ui/screens/onboarding/age_gate.dart';
import 'ui/screens/onboarding/onboarding_flow.dart';
import 'ui/screens/home/home_screen.dart';
import 'providers/app_providers.dart';
import 'db/database.dart';
import 'services/service_providers.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Create the database instance (Drift handles connection lazily)
  final database = AppDatabase();

  // Load persisted onboarding status from SharedPreferences
  final prefs = await SharedPreferences.getInstance();
  final onboardingCompleted = prefs.getBool('onboarding_completed') ?? false;

  runApp(
    ProviderScope(
      overrides: [
        // Inject the real database so all providers can access it
        databaseProvider.overrideWithValue(database),
        // Initialize the onboarding state from persisted SharedPreferences value
        onboardingCompletedProvider.overrideWith((ref) => onboardingCompleted),
      ],
      child: const ProfileForgeApp(),
    ),
  );
}

ThemeMode _getThemeMode() {
  // Read from SharedPreferences synchronously on first load
  // The settings screen updates this via the provider
  try {
    final darkMode = _SharedPreferencesCache._darkMode;
    if (darkMode == null) return ThemeMode.system;
    return darkMode ? ThemeMode.dark : ThemeMode.light;
  } catch (_) {
    return ThemeMode.system;
  }
}

class _SharedPreferencesCache {
  static bool? _darkMode;
  static Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    _darkMode = prefs.getBool('settings_dark_mode');
  }
}

class ProfileForgeApp extends ConsumerWidget {
  const ProfileForgeApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ageStatus = ref.watch(ageVerificationProvider);
    final isOnboarded = ref.watch(onboardingCompletedProvider);

    return MaterialApp(
      title: 'ProfileForge',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: _getThemeMode(),
      home: ageStatus.when(
        data: (status) {
          // COPPA: Under 13 must go through age gate again
          if (status == AgeVerificationStatus.under13) {
            return const AgeGateScreen();
          }
          // For 13-17 and 18+, check onboarding status
          return isOnboarded
              ? const HomeScreen()
              : const OnboardingFlow();
        },
        loading: () => const Scaffold(
          body: Center(child: CircularProgressIndicator()),
        ),
        error: (_, __) => const AgeGateScreen(),
      ),
    );
  }
}
