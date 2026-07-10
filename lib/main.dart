import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:profileforge/ui/screens/chat/chat_screen.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'ui/theme/app_theme.dart';
import 'ui/screens/onboarding/age_gate.dart';
import 'ui/screens/onboarding/onboarding_flow.dart';
import 'ui/screens/home/home_screen.dart';
import 'providers/providers.dart';
import 'db/database.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final db = AppDatabase();
  await db.initialize();

  runApp(
    ProviderScope(
      child: ProfileForgeApp(db: db),
    ),
  );
}

class ProfileForgeApp extends ConsumerWidget {
  final AppDatabase db;
  const ProfileForgeApp({required this.db, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ageStatus = ref.watch(ageVerificationProvider);
    final theme = AppTheme.getTheme(context);

    return MaterialApp(
      title: 'ProfileForge',
      theme: theme,
      locale: const Locale('en'),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en', 'US'),
        Locale('hi', 'IN'),
        Locale('ta', 'IN'),
        Locale('te', 'IN'),
        Locale('bn', 'IN'),
        Locale('mr', 'IN'),
        Locale('gu', 'IN'),
        Locale('kn', 'IN'),
        Locale('ml', 'IN'),
        Locale('pa', 'IN'),
      ],
      routes: {
        '/chat': (context) => const ChatScreen(),
        // Add other named routes here
      },
      home: ageStatus.when(
        data: (isVerified) => isVerified
            ? const HomeScreen()
            : const OnboardingFlow(),
        loading: () => const Scaffold(
          body: Center(child: CircularProgressIndicator()),
        ),
        error: (error, stack) => Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 48, color: Colors.red),
                const SizedBox(height: 16),
                Text('Error: $error'),
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () => ref.invalidate(ageVerificationProvider),
                  child: const Text('Retry'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
