import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:profileforge/core/ai/psychological_profile.dart';
import 'package:profileforge/core/data/app_database_provider.dart';
import 'package:profileforge/features/onboarding/data/onboarding_repository.dart';
import 'package:profileforge/features/onboarding/data/psychology_repository.dart';
import 'package:profileforge/features/onboarding/domain/onboarding_models.dart';

final psychologyRepositoryProvider = Provider<PsychologyRepository>((ref) {
  return PsychologyRepository(ref.watch(appDatabaseProvider));
});

/// Persisted psychological profile (Big Five + SDT). Null until assessed.
final psychologicalProfileProvider = AsyncNotifierProviderFamily<
    PsychologyNotifier, PsychologicalProfile?, String>(PsychologyNotifier.new);

class PsychologyNotifier
    extends FamilyAsyncNotifier<PsychologicalProfile?, String> {
  @override
  Future<PsychologicalProfile?> build(String profileId) async {
    return ref.watch(psychologyRepositoryProvider).load(profileId);
  }

  Future<void> save(PsychologicalProfile p) async {
    state = const AsyncLoading();
    await ref.read(psychologyRepositoryProvider).save(p, arg);
    state = AsyncData(p);
  }

  Future<void> clear() async {
    await ref.read(psychologyRepositoryProvider).delete(arg);
    state = const AsyncData(null);
  }
}

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

/// Essay material (story seed, values, curiosity) — used to enrich the
/// AI mission prompt so missions speak to the student's actual narrative.
final essayContextProvider =
    AsyncNotifierProviderFamily<EssayNotifier, EssayContext, String>(
        EssayNotifier.new);

class EssayNotifier extends FamilyAsyncNotifier<EssayContext, String> {
  @override
  Future<EssayContext> build(String profileId) async {
    return ref.watch(onboardingRepositoryProvider).loadEssay(profileId);
  }

  Future<void> save(EssayContext e) async {
    state = const AsyncLoading();
    await ref.read(onboardingRepositoryProvider).saveEssay(e, arg);
    state = AsyncData(e);
  }
}
