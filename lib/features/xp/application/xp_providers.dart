import 'package:flutter_riverpod/flutter_riverpod.dart';
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
  }
}
