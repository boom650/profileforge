/// Web-specific entry point for ProfileForge.
/// Completely bypasses drift/sqlite3/FFI dependencies.
/// Uses inline providers for state — no database imports.
/// This is for testing the UI only - not production use.
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'ui/theme/app_theme.dart';
import 'ui/screens/onboarding/age_gate.dart';
import 'package:profileforge/models/age_verification.dart';
import 'ui/screens/onboarding/onboarding_flow.dart';
import 'ui/screens/home/home_screen.dart';

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
        ageVerificationProvider.overrideWith((ref) async {
          final prefs = await SharedPreferences.getInstance();
          final ageVerified = prefs.getString('age_verification') ?? 'unknown';
          switch (ageVerified) {
            case 'adult':
              return AgeVerificationStatus.adult18plus;
            case 'minor':
              return AgeVerificationStatus.minor13to17;
            case 'under13':
              return AgeVerificationStatus.under13;
            default:
              return AgeVerificationStatus.notVerified;
          }
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
    final ageStatusAsync = ref.watch(ageVerificationProvider);
    final isOnboarded = ref.watch(onboardingCompletedProvider);

    final ageStatus = ageStatusAsync.valueOrNull ?? AgeVerificationStatus.notVerified;

    return MaterialApp(
      title: 'ProfileForge',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      home: ageStatus == AgeVerificationStatus.notVerified
          ? const AgeGateScreen()
          : ageStatus == AgeVerificationStatus.under13
              ? const AgeGateScreen()
              : isOnboarded
                  ? const HomeScreen()
                  : const OnboardingFlow(),
    );
  }
}
