import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:profileforge/core/data/app_database.dart';
import 'package:profileforge/core/data/app_database_provider.dart';
import 'package:profileforge/features/buddy/data/buddy_repository.dart';

final buddyRepositoryProvider = Provider<BuddyRepository>((ref) {
  return BuddyRepository(ref.watch(appDatabaseProvider));
});

final buddiesProvider =
    FutureProvider.family<List<BuddyRow>, String>((ref, profileId) async {
  return ref.watch(buddyRepositoryProvider).listBuddies(profileId);
});

final addBuddyProvider =
    Provider.family<void, ({String me, String buddyId})>((ref, args) {
  ref.watch(buddyRepositoryProvider).addBuddy(args.me, args.buddyId);
  ref.invalidate(buddiesProvider(args.me));
});

final checkInProvider = Provider.family<
    void,
    ({String from, String to, int xp, String note})>((ref, args) {
  ref.watch(buddyRepositoryProvider).recordCheckIn(args.from, args.to, args.xp, args.note);
});

/// Returns a motivation nudge string if the buddy has been silent >48h, else null.
final buddyMotivationProvider =
    FutureProvider.family<String?, String>((ref, profileId) async {
  final engine = BuddyEngine();
  final recent = await ref.watch(buddyRepositoryProvider).recentCheckIns(profileId);
  if (recent.isEmpty) return engine.nudgeSince(null);
  return engine.nudgeSince(recent.first.at);
});
