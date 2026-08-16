import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:profileforge/core/data/app_database.dart';
import 'package:profileforge/core/data/app_database_provider.dart';
import 'package:profileforge/features/challenges/data/challenge_repository.dart';
import 'package:profileforge/features/challenges/domain/challenge_models.dart';
import 'package:profileforge/features/xp/application/xp_providers.dart';

final challengeRepoProvider = Provider<ChallengeRepository>((ref) {
  return ChallengeRepository(ref.watch(appDatabaseProvider));
});

final activeChallengesProvider = FutureProvider.family<List<FriendChallengeRow>, String>((ref, profileId) async {
  final repo = ref.read(challengeRepoProvider);
  return repo.activeChallenges(profileId);
});

final challengeHistoryProvider = FutureProvider.family<List<FriendChallengeRow>, String>((ref, profileId) async {
  final repo = ref.read(challengeRepoProvider);
  return repo.history(profileId);
});

final createChallengeProvider = FutureProvider.family<FriendChallengeRow, ({String profileId, int wagerXp, int days})>((ref, args) async {
  final repo = ref.read(challengeRepoProvider);
  final challenge = await repo.createSolo(args.profileId, args.wagerXp, args.days);
  ref.invalidate(activeChallengesProvider(args.profileId));
  return challenge;
});

final resolveChallengeProvider = FutureProvider.family<ChallengeResolution?, ({String profileId, String challengeId, int currentXp})>((ref, args) async {
  final repo = ref.read(challengeRepoProvider);
  await repo.updateScore(args.challengeId, args.currentXp);
  final resolution = await repo.resolve(args.challengeId);
  if (resolution?.challengerWon == true) {
    // Winner gets XP bonus
    await ref.read(addXpProvider.notifier).execute(args.profileId, 25, 'challenge_win');
  }
  ref.invalidate(activeChallengesProvider(args.profileId));
  ref.invalidate(challengeHistoryProvider(args.profileId));
  return resolution;
});
