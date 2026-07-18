import 'package:flutter_test/flutter_test.dart';
import 'package:profileforge/features/streak/domain/streak_state.dart';

void main() {
  group('StreakEngine', () {
    final engine = const StreakEngine();

    test('records first activity as streak 1', () {
      final now = DateTime(2026, 7, 18);
      final (state, event) = engine.recordActivity(const StreakState(), now);
      expect(state.current, 1);
      expect(state.longest, 1);
      expect(state.lastActiveDate, now);
      expect(event, isNull);
    });

    test('consecutive day increments streak', () {
      final d1 = DateTime(2026, 7, 18);
      final d2 = DateTime(2026, 7, 19);
      final (s1, _) = engine.recordActivity(const StreakState(), d1);
      final (s2, _) = engine.recordActivity(s1, d2);
      expect(s2.current, 2);
      expect(s2.longest, 2);
    });

    test('same-day activity is idempotent', () {
      final d = DateTime(2026, 7, 18, 9);
      final (s1, _) = engine.recordActivity(const StreakState(), d);
      final (s2, _) = engine.recordActivity(s1, DateTime(2026, 7, 18, 20));
      expect(s2.current, 1);
    });

    test('milestone event fires on day 7', () {
      var s = const StreakState();
      StreakEvent? ev;
      for (var i = 0; i < 7; i++) {
        final (next, e) = engine.recordActivity(
            s, DateTime(2026, 7, 18).add(Duration(days: i)));
        s = next;
        ev = e ?? ev;
      }
      expect(s.current, 7);
      expect(ev, isA<_Milestone>());
    });

    test('grace day absorbs first miss without breaking', () {
      final d1 = DateTime(2026, 7, 18);
      final d3 = DateTime(2026, 7, 20); // 2-day gap
      final (s1, _) = engine.recordActivity(const StreakState(), d1);
      final (s2, ev) = engine.resolveMissedDay(s1, d3);
      expect(s2.current, 1); // preserved via grace
      expect(ev, isA<_Grace>());
    });

    test('weekend amulet forgives a weekend miss', () {
      final sat = DateTime(2026, 7, 18); // Saturday
      final mon = DateTime(2026, 7, 20); // Monday (missed Sun)
      final (s1, _) = engine.recordActivity(const StreakState(current: 5), sat);
      final (s2, ev) = engine.resolveMissedDay(s1, mon);
      expect(s2.current, 5); // not broken
      expect(s2.weekendAmulets, 0);
      expect(ev, isA<_Amulet>());
    });

    test('broken event when no recovery available', () {
      final d1 = DateTime(2026, 7, 18);
      final d5 = DateTime(2026, 7, 22); // 4-day gap, no tokens
      final (s1, _) = engine.recordActivity(
          const StreakState(current: 9, freezeTokens: 0, weekendAmulets: 0,
              graceDaysUsed: 1),
          d1);
      final (s2, ev) = engine.resolveMissedDay(s1, d5);
      expect(s2.current, 0);
      expect(ev, isA<_Broken>());
    });
  });
}
