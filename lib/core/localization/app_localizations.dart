import 'package:flutter/material.dart';

/// Lightweight i18n foundation (H8 / Localization).
/// Real .arb loading is wired via [AppLocalizationsDelegate]; the in-code
/// map covers the baseline locales (en, zh) and degrades gracefully.
class AppLocalizations {
  AppLocalizations(this.locale);

  final Locale locale;

  static AppLocalizations of(BuildContext context) =>
      Localizations.of<AppLocalizations>(context, AppLocalizations)!;

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  static const _strings = {
    'en': {
      'appName': 'ProfileForge',
      'markToday': 'Mark today done',
      'streak': 'day streak',
    },
    'zh': {
      'appName': '档案锻造',
      'markToday': '标记今日完成',
      'streak': '天连续',
    },
  };

  String get appName => _t('appName');
  String get markToday => _t('markToday');
  String get streak => _t('streak');

  String _t(String key) =>
      (_strings[locale.languageCode] ?? _strings['en'])![key] ?? key;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) =>
      ['en', 'zh'].contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) async => AppLocalizations(locale);

  @override
  bool shouldReload(covariant LocalizationsDelegate<AppLocalizations> old) =>
      false;
}
