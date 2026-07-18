import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:profileforge/core/data/app_database.dart';
import 'package:profileforge/core/data/app_database_provider.dart';
import 'package:profileforge/features/profile/data/profile_repository.dart';
import 'package:profileforge/features/profile/domain/profile.dart';

final profileRepositoryProvider = Provider<ProfileRepository>((ref) {
  return ProfileRepository(ref.watch(appDatabaseProvider));
});

final profileProvider =
    AsyncNotifierProviderFamily<ProfileNotifier, Profile, String>(
  ProfileNotifier.new,
);

class ProfileNotifier extends FamilyAsyncNotifier<Profile, String> {
  late final ProfileRepository _repo;
  late final String _id;

  @override
  FutureOr<Profile> build(String id) async {
    _id = id;
    _repo = ref.watch(profileRepositoryProvider);
    return _repo.get(id) ?? Profile(id: id);
  }

  Future<void> setName(String v) => _update((p) => p.copyWith(name: v));
  Future<void> setGoal(String v) => _update((p) => p.copyWith(goal: v));
  Future<void> addAchievement(String a) =>
      _update((p) => p.addAchievement(a));

  Future<void> _update(Profile Function(Profile) fn) async {
    final current = state.valueOrNull;
    final next = fn(current ?? Profile(id: _id));
    await _repo.save(next);
    state = AsyncData(next);
  }
}
