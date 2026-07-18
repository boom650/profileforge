import 'package:flutter_test/flutter_test.dart';
import 'package:profileforge/features/streak/domain/streak_state.dart';

void main() {
  group('StreakEngine', () {
    final engine = StreakEngine();
    final d = DateTime(2026, 1, 5); // Mon

    test('first activity starts streak at 1', () {
      final r = engine.recordActivity(const StreakState(), d);
      expect(r.state.current, 1);
      expect(r.state.longest, 1);
    });

    test('next-day activity continues the streak', () {
      final s0 = engine.recordActivity(const StreakState(), d).state;
      final r = engine.recordActivity(s0, d.add(const Duration(days: 1)));
      expect(r.state.current, 2);
    });

    test('same-day activity is a no-op', () {
      final s0 = engine.recordActivity(const StreakState(), d).state;
      final r = engine.recordActivity(s0, d); // same day
      expect(r.state.current, 1);
      expect(r.event, isNull);
    });

    test('milestone event at 7 days', () {
      var s = const StreakState();
      StreakEvent? ev;
      for (var i = 0; i < 7; i++) {
        final r = engine.recordActivity(s, d.add(Duration(days: i)));
        s = r.state;
        ev = r.event ?? ev;
      }
      expect(s.current, 7);
      expect(ev, isNotNull);
      expect(ev!.maybeWhen(milestone: (day) => day, orElse: () => -1), 7);
    });

    test('missed day triggers grace before breaking streak', () {
      var s = const StreakState();
      for (var i = 0; i < 3; i++) {
        s = engine.recordActivity(s, d.add(Duration(days: i))).state;
      }
      // skip 2 days, then resolve missed day
      final r = engine.resolveMissedDay(s, d.add(const Duration(days: 5)));
      // grace consumed: streak preserved, no break
      expect(r.state.recovered, isFalse); // not a recovery, it was a protected gap
    });
  });
}
