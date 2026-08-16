import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:profileforge/core/data/app_database.dart';
import 'package:profileforge/core/data/app_database_provider.dart';
import 'package:profileforge/features/leagues/data/league_repository.dart';
import 'package:profileforge/features/leagues/domain/league_definitions.dart';

final leagueRepositoryProvider = Provider<LeagueRepository>((ref) {
  return LeagueRepository(ref.watch(appDatabaseProvider));
});

/// The active season identifier. Seasons reset weekly; for now a fixed id.
const String kActiveSeason = 'season-1';

/// Current membership + tier for a profile this season (DB-backed).
final myLeagueProvider =
    FutureProvider.family<LeagueMembership?, String>((ref, profileId) async {
  return ref.watch(leagueRepositoryProvider).mine(profileId, kActiveSeason);
});

/// Cohort standings for the user's current tier, sorted by weeklyXp desc.
final leagueStandingsProvider =
    FutureProvider.family<List<LeagueMembership>, String>((ref, profileId) async {
  final me = await ref.watch(myLeagueProvider(profileId).future);
  final tier = me == null ? LeagueTier.bronze : _tierOf(me.tier);
  final rows =
      await ref.watch(leagueRepositoryProvider).cohort(kActiveSeason, tier);
  rows.sort((a, b) => b.weeklyXp.compareTo(a.weeklyXp));
  return rows;
});

/// Resolves the week for a profile: ranks them in-cohort via [LeagueEngine],
/// persists promotion/demotion, and resets weekly XP. Returns the resolution.
final seasonResetProvider = Provider.family<Future<LeagueResolution?>, String>(
  (ref, profileId) => (() async {
    final repo = ref.read(leagueRepositoryProvider);
    final me = await repo.mine(profileId, kActiveSeason);
    if (me == null) return null;
    final tier = _tierOf(me.tier);
    final cohort = await repo.cohort(kActiveSeason, tier);
    final cohortXp = cohort.map((c) => c.weeklyXp).toList();
    final engine = LeagueEngine();
    if (engine.isSuspicious(me.weeklyXp)) {
      // Anti-cheat: flag but do not promote; just reset.
      await repo.resetWeeklyXp(kActiveSeason);
      return LeagueResolution(
        tier: tier,
        rank: cohortXp.length,
        cohortSize: cohortXp.length,
        promoted: false,
        demoted: false,
        shielded: false,
      );
    }
    final res = engine.resolve(
      tier: tier,
      cohortXp: cohortXp,
      myXp: me.weeklyXp,
      shields: me.shielded ? 1 : 0,
    );
    final newTier = res.promoted
        ? tier.promoteTo!
        : res.demoted
            ? tier.demoteTo!
            : tier;
    await repo.setTier(profileId, kActiveSeason, newTier);
    await repo.resetWeeklyXp(kActiveSeason);
    ref.invalidate(myLeagueProvider(profileId));
    ref.invalidate(leagueStandingsProvider(profileId));
    return res;
  })(),
);

LeagueTier _tierOf(String s) => leagueTierFromName(s);
