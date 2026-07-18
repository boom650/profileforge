import 'package:freezed_annotation/freezed_annotation.dart';

part 'buddy_models.freezed.dart';

@freezed
class BuddyLink with _$BuddyLink {
  const factory BuddyLink({
    required String myProfileId,
    required String buddyProfileId,
    required int sharedStreakGoal,
    required DateTime createdAt,
  }) = _BuddyLink;
}

@freezed
class BuddyCheckIn with _$BuddyCheckIn {
  const factory BuddyCheckIn({
    required String fromProfileId,
    required String toProfileId,
    required int xp,
    required String note,
    required DateTime at,
  }) = _BuddyCheckIn;
}

/// Pure accountability logic. No IO.
class BuddyEngine {
  /// Shared streak = the weaker partner's streak (keeps both honest).
  int sharedStreak(int myStreak, int buddyStreak) => myStreak < buddyStreak ? myStreak : buddyStreak;

  /// Returns a nudge if the buddy hasn't checked in within [hours].
  String? nudgeSince(DateTime? lastCheckIn, {int hours = 48}) {
    if (lastCheckIn == null) return 'Your buddy hasn\'t checked in yet — send a nudge!';
    final gap = DateTime.now().difference(lastCheckIn);
    if (gap.inHours >= hours) {
      return 'It\'s been ${gap.inHours}h since your buddy checked in. A quick message goes a long way.';
    }
    return null;
  }
}
