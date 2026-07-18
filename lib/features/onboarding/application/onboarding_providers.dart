import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:profileforge/core/data/app_database_provider.dart';
import 'package:profileforge/features/onboarding/data/onboarding_repository.dart';
import 'package:profileforge/features/onboarding/domain/onboarding_models.dart';

final onboardingRepositoryProvider = Provider<OnboardingRepository>((ref) {
  return OnboardingRepository(ref.watch(appDatabaseProvider));
});

final onboardingProvider =
    AsyncNotifierProviderFamily<OnboardingNotifier, OnboardingProfile?, String>(
        OnboardingNotifier.new);

class OnboardingNotifier
    extends FamilyAsyncNotifier<OnboardingProfile?, String> {
  @override
  Future<OnboardingProfile?> build(String profileId) async {
    return ref.watch(onboardingRepositoryProvider).load(profileId);
  }

  Future<void> save(OnboardingProfile p) async {
    state = const AsyncLoading();
    await ref.read(onboardingRepositoryProvider).save(p);
    state = AsyncData(p);
  }
}

final saveOnboardingProvider =
    Provider.family<void, OnboardingProfile>((ref, p) {
  ref.read(onboardingProvider(p.profileId).notifier).save(p);
});
