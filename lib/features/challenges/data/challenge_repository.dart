import 'dart:math';
import 'package:drift/drift.dart';
import 'package:profileforge/core/data/app_database.dart';
import 'package:profileforge/core/data/tables.dart';

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
      status: const Value('active'),
      expiresAt: Value(now.add(Duration(days: days))),
    ));
    return FriendChallengeRow(
      id: id, profileId: profileId, opponentId: 'ghost',
      wagerXp: wagerXp, status: 'active', expiresAt: now.add(Duration(days: days)),
      challengerScore: 0, opponentScore: 0, winnerId: '',
    );
  }

  Future<List<FriendChallengeRow>> activeChallenges(String profileId) async {
    final now = DateTime.now();
    return (_db.select(_db.friendChallenges)
          ..where((t) =>
              (t.profileId.equals(profileId) | t.opponentId.equals(profileId)) &
              t.status.equals('active') &
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
  Future<String?> resolve(String challengeId) async {
    final row = await (_db.select(_db.friendChallenges)
          ..where((t) => t.id.equals(challengeId)))
        .getSingleOrNull();
    if (row == null) return null;
    if (row.status != 'active') return row.winnerId;

    // Ghost opponent gets a random score between 30-100% of wager
    final ghostScore = (row.wagerXp * (0.3 + _rng.nextDouble() * 0.7)).round();
    String winnerId;
    if (row.challengerScore >= ghostScore) {
      winnerId = row.profileId;
    } else {
      winnerId = row.opponentId;
    }

    await (_db.update(_db.friendChallenges)
          ..where((t) => t.id.equals(challengeId)))
        .write(FriendChallengesCompanion(
          status: const Value('completed'),
          opponentScore: Value(ghostScore),
          winnerId: Value(winnerId),
        ));
    return winnerId;
  }
}
