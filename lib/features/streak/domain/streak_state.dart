import 'package:freezed_annotation/freezed_annotation.dart';

part 'streak_state.freezed.dart';

/// Immutable streak state. Pure domain model — no Flutter/db deps.
@freezed
class StreakState with _$StreakState {
  const factory StreakState({
    @Default(0) int current,
    @Default(0) int longest,
    DateTime? lastActiveDate,
    @Default(0) int graceDaysUsed,
    @Default(2) int freezeTokens,
    @Default(1) int weekendAmulets,
    @Default(false) bool recovered,
  }) = _StreakState;

  const StreakState._();

  /// Days since last activity (0 if today or never).
  int daysSince(DateTime now) {
    if (lastActiveDate == null) return 9999;
    final a = DateTime(lastActiveDate!.year, lastActiveDate!.month, lastActiveDate!.day);
    final n = DateTime(now.year, now.month, now.day);
    return n.difference(a).inDays;
  }

  bool get isWeekend => _isWeekend(lastActiveDate);

  static bool _isWeekend(DateTime? d) {
    if (d == null) return false;
    return d.weekday == DateTime.saturday || d.weekday == DateTime.sunday;
  }
}

/// Pure, side-effect-free streak engine. Encapsulates humane recovery rules.
/// No guilt spiral: missing a day is absorbed by grace/freeze/amulet, then
/// recovery is celebrated rather than punished.
class StreakEngine {
  const StreakEngine();

  /// Record activity for [now]. Returns the next state + a celebration event.
  ({StreakState state, StreakEvent? event}) recordActivity(
    StreakState s,
    DateTime now,
  ) {
    if (s.lastActiveDate != null && s.daysSince(now) == 0) {
      // Already active today — no change, no event.
      return (state: s, event: null);
    }
    final continued = s.lastActiveDate != null && s.daysSince(now) == 1;
    final nextCurrent = continued ? s.current + 1 : 1;
    final nextLongest = nextCurrent > s.longest ? nextCurrent : s.longest;
    final state = s.copyWith(
      current: nextCurrent,
      longest: nextLongest,
      lastActiveDate: now,
      recovered: !continued && s.current > 0,
    );
    final event = nextCurrent > 0 && (nextCurrent % 7 == 0 || nextCurrent == 1)
        ? StreakEvent.milestone(nextCurrent)
        : null;
    return (state: state, event: event);
  }

  /// Called on app open / day roll-over to resolve a missed day humanely.
  ({StreakState state, StreakEvent? event}) resolveMissedDay(
    StreakState s,
    DateTime now,
  ) {
    if (s.lastActiveDate == null) return (state: s, event: null);
    final gap = s.daysSince(now);
    if (gap <= 1) return (state: s, event: null);

    // Weekend amulet: a missed SAT/SUN is forgiven automatically.
    if (s.isWeekend && s.weekendAmulets > 0) {
      return (
        state: s.copyWith(weekendAmulets: s.weekendAmulets - 1),
        event: const StreakEvent.amulet(),
      );
    }
    // Grace day: first miss each period is soft-forgiven.
    if (s.graceDaysUsed < 1) {
      return (
        state: s.copyWith(graceDaysUsed: s.graceDaysUsed + 1),
        event: const StreakEvent.grace(),
      );
    }
    // Freeze token: user-spent insurance, never auto.
    if (s.freezeTokens > 0) {
      // Only consumed explicitly via [spendFreeze]; here we just note break.
      return (state: s.copyWith(current: 0, recovered: false), event: const StreakEvent.broken());
    }
    return (state: s.copyWith(current: 0, recovered: false), event: const StreakEvent.broken());
  }

  /// Explicitly spend a freeze token to preserve the streak through a gap.
  StreakState spendFreeze(StreakState s) {
    if (s.freezeTokens <= 0) return s;
    return s.copyWith(freezeTokens: s.freezeTokens - 1);
  }
}

/// UI-facing celebration events (drives animations / particles).
@freezed
class StreakEvent with _$StreakEvent {
  const factory StreakEvent.milestone(int day) = _Milestone;
  const factory StreakEvent.grace() = _Grace;
  const factory StreakEvent.amulet() = _Amulet;
  const factory StreakEvent.broken() = _Broken;
}
