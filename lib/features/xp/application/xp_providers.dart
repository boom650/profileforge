import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:profileforge/core/data/app_database.dart';
import 'package:profileforge/core/data/app_database_provider.dart';
import 'package:profileforge/features/xp/data/xp_repository.dart';

final xpRepositoryProvider = Provider<XpRepository>((ref) {
  return XpRepository(ref.watch(appDatabaseProvider));
});

/// Running total XP for a profile (single source of truth via XpEvents ledger).
final totalXpProvider = FutureProvider.family<int, String>((ref, profileId) async {
  return ref.watch(xpRepositoryProvider).totalXp(profileId);
});

/// Weekly XP earned.
final weeklyXpProvider = FutureProvider.family<int, String>((ref, profileId) async {
  final weekAgo = DateTime.now().subtract(const Duration(days: 7));
  return ref.watch(xpRepositoryProvider).xpSince(profileId, weekAgo);
});

/// XP earned per calendar day for the last [days] days (inclusive of today).
/// Powers the real activity heatmap — one entry per day from the XpEvents
/// ledger, NOT derived from the streak count (the old fake heatmap filled
/// dots from `streak.clamp(0,7)` even when nothing happened this week).
final xpByDayProvider =
    FutureProvider.family<Map<DateTime, int>, ({String profileId, int days})>(
        (ref, args) async {
  final events =
      await ref.watch(xpRepositoryProvider).history(args.profileId);
  final today = DateTime.now();
  final dayOnly = (DateTime d) => DateTime(d.year, d.month, d.day);
  final byDay = <DateTime, int>{};
  for (var i = args.days - 1; i >= 0; i--) {
    byDay[dayOnly(today.subtract(Duration(days: i)))] = 0;
  }
  for (final e in events) {
    final d = dayOnly(e.at);
    if (byDay.containsKey(d)) byDay[d] = byDay[d]! + e.amount;
  }
  return byDay;
});

/// Full XP ledger history (newest first) — powers per-source breakdowns.
final xpHistoryProvider =
    FutureProvider.family<List<XpEventRow>, String>((ref, profileId) async {
  return ref.watch(xpRepositoryProvider).history(profileId);
});

/// Add XP to a profile and invalidate caches. Use .execute(...) and await.
final addXpProvider = NotifierProvider<AddXpNotifier, void>(AddXpNotifier.new);

class AddXpNotifier extends Notifier<void> {
  @override
  void build() {}

  Future<void> execute(String profileId, int amount, String source) async {
    final repo = ref.read(xpRepositoryProvider);
    await repo.add(profileId, amount, source);
    ref.invalidate(totalXpProvider(profileId));
    ref.invalidate(weeklyXpProvider(profileId));
    ref.invalidate(
        xpByDayProvider((profileId: profileId, days: 7)));
  }
}
