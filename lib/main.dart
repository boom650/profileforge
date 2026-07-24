import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:profileforge/core/navigation/app_router.dart';
import 'package:profileforge/core/theme/app_theme.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:profileforge/features/notifications/notification_service.dart';

/// ProfileForge — gamified admission-journey companion.
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting();

  // Initialise local notifications for streak/quest reminders.
  final notifPlugin = FlutterLocalNotificationsPlugin();
  final notifService = NotificationService(notifPlugin);
  await notifService.initialize();
  // Schedule recurring reminders.
  await notifService.scheduleStreakReminder('default-profile');
  await notifService.scheduleQuestReminder('default-profile');

  runApp(ProviderScope(
    overrides: [
      notificationPluginProvider.overrideWithValue(notifPlugin),
      notificationServiceProvider.overrideWithValue(notifService),
    ],
    child: const ProfileForgeApp(),
  ));
}

class ProfileForgeApp extends ConsumerWidget {
  const ProfileForgeApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mode = ref.watch(themeModeProvider);
    return MaterialApp.router(
      title: 'ProfileForge',
      debugShowCheckedModeBanner: false,
      theme: lightTheme(),
      darkTheme: darkTheme(),
      themeMode: toFlutterThemeMode(mode),
      routerConfig: ref.watch(routerProvider),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('en')],
    );
  }
}
