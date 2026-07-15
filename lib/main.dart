import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:profileforge/ui/screens/chat/chat_screen.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/app_localizations.dart';
import 'ui/theme/app_theme.dart';
import 'ui/screens/onboarding/age_gate.dart';
import 'package:profileforge/models/age_verification.dart';
import 'ui/screens/onboarding/onboarding_flow.dart';
import 'ui/screens/home/home_screen.dart';
import 'providers/providers.dart';
import 'db/database.dart';
import 'core/errors/error_boundary.dart';
import 'core/connectivity/connectivity_service.dart';
import 'core/connectivity/offline_banner.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Zone guard for uncaught async errors
  runZonedGuarded(() async {
    final db = AppDatabase();

    runApp(
      ProviderScope(
        child: ProfileForgeApp(db: db),
      ),
    );
  }, (error, stackTrace) {
    // Log uncaught async errors
    debugPrint('Uncaught async error: $error');
    debugPrint('Stack trace: $stackTrace');
    // TODO: Report to Sentry when enabled
    // reportError(error, stackTrace);
  });
}

class ProfileForgeApp extends ConsumerWidget {
  final AppDatabase db;
  const ProfileForgeApp({required this.db, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ageStatus = ref.watch(ageVerificationProvider);
    final theme = ThemeProvider.getTheme(context);

    // Wrap the entire app with connectivity monitoring and ErrorBoundary
    return ErrorBoundary(
      onError: (details) {
        debugPrint('App-level ErrorBoundary caught: ${details.exception}');
        debugPrint('Stack: ${details.stack}');
        // TODO: Report to Sentry when enabled
      },
      child: ConnectivityStatusWatcher(
        child: MaterialApp(
          title: 'ProfileForge',
          theme: theme,
          builder: (context, child) {
            return MediaQuery(
              data: MediaQuery.of(context).copyWith(
                textScaler: TextScaler.linear(
                  MediaQuery.of(context).textScaleFactor.clamp(0.8, 1.5),
                ),
              ),
              child: child!,
            );
          },
          locale: const Locale('en'),
          localizationsDelegates: const [
            AppLocalizations.delegate,
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
            data: (status) => status == AgeVerificationStatus.notVerified
                ? const OnboardingFlow()
                : const HomeScreen(),
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
        ),
      ),
    );
  }
}