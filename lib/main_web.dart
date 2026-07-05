/// Web-specific entry point for ProfileForge.
/// Completely bypasses drift/sqlite3/FFI dependencies.
/// Uses inline providers for state — no database imports.
/// This is for testing the UI only - not production use.
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'ui/theme/app_theme.dart';
import 'ui/screens/onboarding/age_gate.dart';
import 'ui/screens/onboarding/onboarding_flow.dart';
import 'ui/screens/home/home_screen.dart';

// Re-declare providers that main_web needs WITHOUT importing database.dart chain

/// Age verification status - mirrors app_providers.dart
enum AgeVerificationStatus { unknown, under13, minor, adult }

final ageVerificationProvider =
    StateProvider<AgeVerificationStatus>((ref) => AgeVerificationStatus.unknown);

/// Onboarding completed - mirrors app_providers.dart  
final onboardingCompletedProvider = StateProvider<bool>((ref) => false);

/// Onboarding data - mirrors app_providers.dart
class OnboardingData {
  String firstName = '';
  String lastName = '';
  String email = '';
  String board = '';
  String stream = '';
  String grade = '';
  Map<String, int> subjectScores = {};
  String? intendedMajor;
  Set<String> targetCountries = {};
  List<String> targetUniversities = [];
  Map<String, dynamic> extracurriculars = {};
}

final onboardingDataProvider = StateProvider<OnboardingData>((ref) => OnboardingData());

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final onboardingCompleted = prefs.getBool('onboarding_completed') ?? false;
  final ageVerified = prefs.getString('age_verification') ?? 'unknown';

  runApp(
    ProviderScope(
      overrides: [
        onboardingCompletedProvider.overrideWith((ref) => onboardingCompleted),
        ageVerificationProvider.overrideWith((ref) => switch (ageVerified) {
          'adult' => AgeVerificationStatus.adult,
          'minor' => AgeVerificationStatus.minor,
          'under13' => AgeVerificationStatus.under13,
          _ => AgeVerificationStatus.unknown,
        }),
      ],
      child: const ProfileForgeWebApp(),
    ),
  );
}

class ProfileForgeWebApp extends ConsumerWidget {
  const ProfileForgeWebApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ageStatus = ref.watch(ageVerificationProvider);
    final isOnboarded = ref.watch(onboardingCompletedProvider);

    return MaterialApp(
      title: 'ProfileForge',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      home: ageStatus == AgeVerificationStatus.unknown
          ? const AgeGateScreen()
          : ageStatus == AgeVerificationStatus.under13
              ? const AgeGateScreen()
              : isOnboarded
                  ? const HomeScreen()
                  : const OnboardingFlow(),
    );
  }
}
