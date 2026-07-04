import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'ui/theme/app_theme.dart';
import 'ui/screens/onboarding/age_gate.dart';
import 'ui/screens/onboarding/onboarding_flow.dart';
import 'ui/screens/home/home_screen.dart';
import 'providers/app_providers.dart';
import 'db/database.dart';
import 'services/service_providers.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Create the database instance (Drift handles connection lazily)
  final database = AppDatabase();

  runApp(
    ProviderScope(
      overrides: [
        // Inject the real database so all providers can access it
        databaseProvider.overrideWithValue(database),
      ],
      child: const ProfileForgeApp(),
    ),
  );
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
      themeMode: ThemeMode.system,
      home: ageStatus.when(
        data: (status) {
          // COPPA: Under 13 must go through age gate again
          if (status == AgeVerificationStatus.under13) {
            return const AgeGateScreen();
          }
          // For 13-17 and 18+, check onboarding status
          return isOnboarded.when(
            data: (onboarded) => onboarded
                ? const HomeScreen()
                : const OnboardingFlow(),
            loading: () => const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            ),
            error: (_, __) => const OnboardingFlow(),
          );
        },
        loading: () => const Scaffold(
          body: Center(child: CircularProgressIndicator()),
        ),
        error: (_, __) => const AgeGateScreen(),
      ),
    );
  }
}
