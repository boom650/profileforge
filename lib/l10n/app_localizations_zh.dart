// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get appName => '档案锻造';

  @override
  String get markTodayDone => '标记今日完成';

  @override
  String get dayStreak => '天连续';

  @override
  String get firstWin => '首次胜利！';

  @override
  String get keepConsistency => '继续前进——积累带来复利。';

  @override
  String get noGuilt => '无需自责——成长是旅程，不是一次连胜。';
}
