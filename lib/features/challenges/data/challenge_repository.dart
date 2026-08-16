import 'dart:math';
import 'package:drift/drift.dart';
import 'package:profileforge/core/data/app_database.dart';
import 'package:profileforge/features/challenges/domain/challenge_models.dart';

class ChallengeRepository {
  final AppDatabase _db;
  ChallengeRepository(this._db);

  static final _rng = Random();

  /// Create a new solo challenge (vs AI "ghost" opponent).
  Future<FriendChallengeRow> createSolo(String profileId, int wagerXp, int days) async {
    final id = 'ch_${DateTime.now().millisecondsSinceEpoch}_${_rng.nextInt(9999)}';
    final now = DateTime.now();
    await _db.into(_db.friendChallenges).insert(FriendChallengesCompanion(
      id: Value(id),
      profileId: Value(profileId),
      opponentId: const Value('ghost'),
      wagerXp: Value(wagerXp),
      status: Value(ChallengeStatus.active.dbValue),
      expiresAt: Value(now.add(Duration(days: days))),
    ));
    return FriendChallengeRow(
      id: id, profileId: profileId, opponentId: 'ghost',
      wagerXp: wagerXp, status: ChallengeStatus.active.dbValue, expiresAt: now.add(Duration(days: days)),
      challengerScore: 0, opponentScore: 0, winnerId: '',
    );
  }

  Future<List<FriendChallengeRow>> activeChallenges(String profileId) async {
    final now = DateTime.now();
    return (_db.select(_db.friendChallenges)
          ..where((t) =>
              (t.profileId.equals(profileId) | t.opponentId.equals(profileId)) &
              t.status.equals(ChallengeStatus.active.dbValue) &
              t.expiresAt.isBiggerThanValue(now))
          ..orderBy([(t) => OrderingTerm.desc(t.expiresAt)]))
        .get();
  }

  Future<List<FriendChallengeRow>> history(String profileId) async {
    return (_db.select(_db.friendChallenges)
          ..where((t) => t.profileId.equals(profileId) | t.opponentId.equals(profileId))
          ..orderBy([(t) => OrderingTerm.desc(t.expiresAt)])
          ..limit(20))
        .get();
  }

  /// Update challenger score (XP earned since challenge start).
  Future<void> updateScore(String challengeId, int score) async {
    await (_db.update(_db.friendChallenges)
          ..where((t) => t.id.equals(challengeId)))
        .write(FriendChallengesCompanion(challengerScore: Value(score)));
  }

  /// Resolve challenge: determine winner, mark completed.
  Future<ChallengeResolution?> resolve(String challengeId) async {
    final row = await (_db.select(_db.friendChallenges)
          ..where((t) => t.id.equals(challengeId)))
        .getSingleOrNull();
    if (row == null) return null;
    if (ChallengeStatus.fromDb(row.status) != ChallengeStatus.active) {
      return null;
    }

    // Ghost opponent gets a random score between 30-100% of wager
    final ghostScore = (row.wagerXp * (0.3 + _rng.nextDouble() * 0.7)).round();
    final challengerWon = row.challengerScore >= ghostScore;
    final winnerId = challengerWon ? row.profileId : row.opponentId;

    await (_db.update(_db.friendChallenges)
          ..where((t) => t.id.equals(challengeId)))
        .write(FriendChallengesCompanion(
          status: Value(ChallengeStatus.completed.dbValue),
          opponentScore: Value(ghostScore),
          winnerId: Value(winnerId),
        ));
    return ChallengeResolution(
      winnerId: winnerId,
      challengerWon: challengerWon,
      challengerScore: row.challengerScore,
      opponentScore: ghostScore,
    );
  }
}
