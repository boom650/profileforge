import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'ui/theme/app_theme.dart';
import 'ui/screens/onboarding/onboarding_flow.dart';
import 'ui/screens/home/home_screen.dart';
import 'providers/app_providers.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    const ProviderScope(
      child: ProfileForgeApp(),
    ),
  );
}

class ProfileForgeApp extends ConsumerWidget {
  const ProfileForgeApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isOnboarded = ref.watch(onboardingCompletedProvider);

    return MaterialApp(
      title: 'ProfileForge',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      home: isOnboarded.when(
        data: (onboarded) => onboarded
            ? const HomeScreen()
            : const OnboardingFlow(),
        loading: () => const Scaffold(
          body: Center(child: CircularProgressIndicator()),
        ),
        error: (_, __) => const OnboardingFlow(),
      ),
    );
  }
}
