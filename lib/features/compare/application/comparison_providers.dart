import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:profileforge/core/application/session_provider.dart';
import 'package:profileforge/features/compare/data/comparison_repository.dart';
import 'package:profileforge/features/compare/domain/comparison_models.dart';
import 'package:profileforge/features/onboarding/application/onboarding_providers.dart';
import 'package:profileforge/features/profile/application/profile_score_loader.dart';

final comparisonRepositoryProvider = Provider<ComparisonRepository>((ref) {
  return const ComparisonRepository();
});

/// The real comparison: the user's onboarding GPA vs. every school's average.
/// Recomputed live whenever the active profile or its onboarding changes.
final comparisonProvider = FutureProvider.autoDispose<ComparisonResult>((ref) async {
  final profileId = ref.watch(activeProfileIdProvider).valueOrNull;
  final onboarding =
      profileId == null ? null : ref.watch(onboardingProvider(profileId)).valueOrNull;
  final userGpa = onboarding == null ? null : gpaFromGrades(onboarding.grades);
  return ref.watch(comparisonRepositoryProvider).computeResult(userGpa: userGpa);
});