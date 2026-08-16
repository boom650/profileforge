import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:profileforge/core/data/app_database_provider.dart';
import 'package:profileforge/features/habits/data/habit_repository.dart';
import 'package:profileforge/features/habits/domain/habit_models.dart';

final habitRepositoryProvider = Provider<HabitRepository>((ref) {
  return HabitRepository(ref.watch(appDatabaseProvider));
});

/// Live unpaid XP debts for a profile.
final unpaidDebtsProvider =
    StreamProvider.autoDispose.family<List<HabitDebt>, String>((ref, profileId) {
  return ref.watch(habitRepositoryProvider).watchUnpaidDebts(profileId);
});

/// Total outstanding XP debt (sum of all unpaid debts).
final outstandingDebtProvider =
    StreamProvider.autoDispose.family<int, String>((ref, profileId) {
  return ref
      .watch(habitRepositoryProvider)
      .watchUnpaidDebts(profileId)
      .map((debts) => debts.fold(0, (sum, d) => sum + d.amount));
});