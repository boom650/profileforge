import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:profileforge/core/data/app_database.dart';
import 'package:profileforge/core/data/app_database_provider.dart';
import 'package:profileforge/features/streak/data/streak_repository.dart';
import 'package:profileforge/features/streak/domain/streak_state.dart';

final streakRepositoryProvider = Provider<StreakRepository>((ref) {
  final db = ref.watch(appDatabaseProvider);
  return StreakRepository(db);
});

final streakProvider =
    AsyncNotifierProviderFamily<StreakNotifier, StreakState, String>(
  StreakNotifier.new,
);

class StreakNotifier extends FamilyAsyncNotifier<StreakState, String> {
  late final StreakRepository _repo;
  late final String _profileId;
  final StreakEngine _engine = const StreakEngine();

  @override
  FutureOr<StreakState> build(String profileId) async {
    _profileId = profileId;
    _repo = ref.watch(streakRepositoryProvider);
    return _repo.get(profileId);
  }

  /// Record today's activity; persists + emits celebration event.
  Future<StreakEvent?> recordToday() async {
    final now = DateTime.now();
    final s = state.valueOrNull ?? const StreakState();
    final result = _engine.recordActivity(s, now);
    await _repo.save(_profileId, result.state);
    state = AsyncData(result.state);
    return result.event;
  }

  /// Resolve a missed day humanely (called on app resume).
  Future<StreakEvent?> resolveMissed() async {
    final now = DateTime.now();
    final s = state.valueOrNull ?? const StreakState();
    final result = _engine.resolveMissedDay(s, now);
    await _repo.save(_profileId, result.state);
    state = AsyncData(result.state);
    return result.event;
  }

  /// Spend a freeze token to protect the streak.
  Future<void> spendFreeze() async {
    final s = state.valueOrNull ?? const StreakState();
    final next = _engine.spendFreeze(s);
    await _repo.save(_profileId, next);
    state = AsyncData(next);
  }

  /// XP mirror for downstream consumers (leagues, skins).
  int get currentStreak => state.valueOrNull?.current ?? 0;
}
