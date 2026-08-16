// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'ProfileForge';

  @override
  String get markTodayDone => 'Mark today done';

  @override
  String get dayStreak => 'day streak';

  @override
  String get firstWin => 'First win!';

  @override
  String get keepConsistency => 'Keep going — consistency compounds.';

  @override
  String get noGuilt => 'No guilt — growth is a path, not a streak.';
}
