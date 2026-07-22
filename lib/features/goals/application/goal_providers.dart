import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:profileforge/core/data/app_database.dart';
import 'package:profileforge/core/data/app_database_provider.dart';
import 'package:profileforge/features/goals/data/goal_repository.dart';

final goalRepoProvider = Provider<GoalRepository>((ref) {
  return GoalRepository(ref.watch(appDatabaseProvider));
});

final userGoalProvider = FutureProvider.family<UserGoalRow?, String>((ref, profileId) async {
  final repo = ref.read(goalRepoProvider);
  return repo.get(profileId);
});

final primaryGoalProvider = FutureProvider.family<String, String>((ref, profileId) async {
  final repo = ref.read(goalRepoProvider);
  return repo.getPrimaryGoal(profileId);
});

final setPrimaryGoalProvider = FutureProvider.family<void, ({String profileId, String goal})>((ref, args) async {
  final repo = ref.read(goalRepoProvider);
  await repo.setPrimaryGoal(args.profileId, args.goal);
  ref.invalidate(userGoalProvider(args.profileId));
  ref.invalidate(primaryGoalProvider(args.profileId));
});
