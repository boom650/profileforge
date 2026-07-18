import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'league_definitions.freezed.dart';

/// League tiers, ordered weakest → strongest.
enum LeagueTier { bronze, silver, gold, platinum, diamond, obsidian }

extension LeagueTierX on LeagueTier {
  String get tierLabel => name[0].toUpperCase() + name.substring(1);
  String get label => tierLabel;
  Color get tierColor => switch (this) {
        LeagueTier.bronze => const Color(0xFFCD7F32),
        LeagueTier.silver => const Color(0xFF9AA0A6),
        LeagueTier.gold => const Color(0xFFFFC800),
        LeagueTier.platinum => const Color(0xFF1CB0F6),
        LeagueTier.diamond => const Color(0xFF58CC02),
        LeagueTier.obsidian => const Color(0xFF37474F),
      };
  String get tierEmoji => switch (this) {
        LeagueTier.bronze => '🥉',
        LeagueTier.silver => '🥈',
        LeagueTier.gold => '🥇',
        LeagueTier.platinum => '💎',
        LeagueTier.diamond => '💠',
        LeagueTier.obsidian => '🖤',
      };
  int get promotionThreshold => switch (this) {
        LeagueTier.bronze => 300,
        LeagueTier.silver => 700,
        LeagueTier.gold => 1200,
        LeagueTier.platinum => 2000,
        LeagueTier.diamond => 3000,
        LeagueTier.obsidian => 999999,
      };
  LeagueTier? get promoteTo => switch (this) {
        LeagueTier.bronze => LeagueTier.silver,
        LeagueTier.silver => LeagueTier.gold,
        LeagueTier.gold => LeagueTier.platinum,
        LeagueTier.platinum => LeagueTier.diamond,
        LeagueTier.diamond => LeagueTier.obsidian,
        LeagueTier.obsidian => null,
      };
  LeagueTier? get demoteTo => switch (this) {
        LeagueTier.bronze => null,
        LeagueTier.silver => LeagueTier.bronze,
        LeagueTier.gold => LeagueTier.silver,
        LeagueTier.platinum => LeagueTier.gold,
        LeagueTier.diamond => LeagueTier.platinum,
        LeagueTier.obsidian => LeagueTier.diamond,
      };
}

/// Result of a weekly league resolution.
@freezed
class LeagueResolution with _$LeagueResolution {
  const factory LeagueResolution({
    required LeagueTier tier,
    required int rank,
    required int cohortSize,
    required bool promoted,
    required bool demoted,
    required bool shielded,
  }) = _LeagueResolution;
}

/// Pure league-resolution engine. Deterministic, testable.
class LeagueEngine {
  /// Resolve a member's standing at end of week.
  /// [cohortXp] is sorted descending (highest first). [shields] reduces demotion risk.
  LeagueResolution resolve({
    required LeagueTier tier,
    required List<int> cohortXp,
    required int myXp,
    required int shields,
  }) {
    final sorted = [...cohortXp]..sort((a, b) => b.compareTo(a));
    final rank = sorted.indexOf(myXp) + 1;
    final demoteCutoff = (sorted.length * 0.9).ceil(); // bottom 10%
    final promoteCutoff = (sorted.length * 0.1).ceil(); // top 10%

    var promoted = rank <= promoteCutoff && tier.promoteTo != null;
    var demoted = rank >= demoteCutoff && tier.demoteTo != null;
    var shielded = false;

    if (demoted && shields > 0) {
      demoted = false;
      shielded = true;
    }
    return LeagueResolution(
      tier: tier,
      rank: rank,
      cohortSize: sorted.length,
      promoted: promoted,
      demoted: demoted,
      shielded: shielded,
    );
  }

  /// Anti-cheat sanity: flag impossible XP (e.g. > 24h*XP/hr ceiling).
  bool isSuspicious(int xpPerWeek) => xpPerWeek > 7 * 24 * 50; // >50 XP/hour sustained
}
