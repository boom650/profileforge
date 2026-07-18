import 'package:freezed_annotation/freezed_annotation.dart';

part 'team_models.freezed.dart';

enum TeamPrivacy { public, private }

@freezed
class Team with _$Team {
  const factory Team({
    required String id,
    required String name,
    required String ownerProfileId,
    required TeamPrivacy privacy,
    required DateTime createdAt,
  }) = _Team;
}

@freezed
class TeamChallenge with _$TeamChallenge {
  const factory TeamChallenge({
    required String id,
    required String teamId,
    required String title,
    required int goalXp,
    required int currentXp,
    required DateTime? endsAt,
  }) = _TeamChallenge;
}

/// Pure team mechanics: leaderboard ordering + challenge completion.
class TeamEngine {
  List<String> leaderboard(Map<String, int> memberXp) {
    final entries = memberXp.entries.toList();
    entries.sort((a, b) => b.value.compareTo(a.value));
    return entries.map((e) => e.key).toList();
  }

  bool challengeComplete(TeamChallenge c) => c.currentXp >= c.goalXp;
}
