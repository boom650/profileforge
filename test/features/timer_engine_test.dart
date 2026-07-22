import 'dart:async';
import 'package:flutter_test/flutter_test.dart';
import 'package:profileforge/features/timer/domain/timer_engine.dart';

void main() {
  group('TimerEngine state machine', () {
    test('initial state: not running, not paused, seconds = 0 (not started)', () {
      final engine = TimerEngine(durationMinutes: 25);
      expect(engine.isRunning, false);
      expect(engine.isPaused, false);
      expect(engine.secondsRemaining, 0); // hasn't been started
      expect(engine.earnedXp, 0); // no sessionStart
      engine.dispose();
    });

    test('start() sets running, sets seconds to duration*60', () {
      final engine = TimerEngine(durationMinutes: 10);
      engine.start();
      expect(engine.isRunning, true);
      expect(engine.isPaused, false);
      expect(engine.secondsRemaining, 10 * 60);
      expect(engine.elapsedSeconds, 0);
      expect(engine.sessionStart, isNotNull);
      engine.dispose();
    });

    test('start() is idempotent — calling twice does nothing', () {
      final engine = TimerEngine(durationMinutes: 5);
      engine.start();
      final firstStart = engine.sessionStart;
      engine.start(); // should be no-op
      expect(engine.sessionStart, firstStart);
      engine.dispose();
    });

    test('pause() stops ticking', () async {
      final engine = TimerEngine(durationMinutes: 1);
      engine.start();
      await Future.delayed(const Duration(milliseconds: 1100));
      final beforePause = engine.secondsRemaining;
      engine.pause();
      expect(engine.isPaused, true);
      expect(engine.isRunning, true);
      await Future.delayed(const Duration(seconds: 2));
      expect(engine.secondsRemaining, beforePause);
      engine.dispose();
    });

    test('resume() continues from paused state', () async {
      final engine = TimerEngine(durationMinutes: 1);
      engine.start();
      await Future.delayed(const Duration(milliseconds: 1100));
      engine.pause();
      final atPause = engine.secondsRemaining;
      engine.resume();
      expect(engine.isPaused, false);
      await Future.delayed(const Duration(seconds: 2));
      expect(engine.secondsRemaining, lessThan(atPause));
      engine.dispose();
    });

    test('resume() is no-op when not paused', () {
      final engine = TimerEngine(durationMinutes: 5);
      engine.start();
      engine.resume(); // not paused, should be no-op
      expect(engine.isRunning, true);
      expect(engine.isPaused, false);
      engine.dispose();
    });

    test('pause() is no-op when not running', () {
      final engine = TimerEngine(durationMinutes: 5);
      engine.pause();
      expect(engine.isPaused, false);
      engine.dispose();
    });

    test('reset() returns to initial state', () async {
      final engine = TimerEngine(durationMinutes: 5);
      engine.start();
      await Future.delayed(const Duration(seconds: 2));
      engine.reset();
      expect(engine.isRunning, false);
      expect(engine.isPaused, false);
      expect(engine.secondsRemaining, 5 * 60);
      expect(engine.sessionStart, null);
      expect(engine.earnedXp, 0);
      engine.dispose();
    });

    test('onComplete fires when timer reaches 0', () async {
      final engine = TimerEngine(durationMinutes: 0);
      var completed = false;
      engine.onComplete = () { completed = true; };
      engine.start();
      await Future.delayed(const Duration(seconds: 2)); // wait for periodic timer
      expect(completed, true);
      expect(engine.isRunning, false);
      expect(engine.secondsRemaining, 0);
      engine.dispose();
    });

    test('onTick fires each second', () async {
      final engine = TimerEngine(durationMinutes: 1);
      final ticks = <int>[];
      engine.onTick = (sec) { ticks.add(sec); };
      engine.start();
      await Future.delayed(const Duration(seconds: 3));
      expect(ticks.length, greaterThanOrEqualTo(2));
      expect(ticks.first, greaterThan(ticks.last));
      engine.dispose();
    });

    test('earnedXp = durationMinutes (1 xp/min, min 5)', () {
      final e1 = TimerEngine(durationMinutes: 30);
      e1.start();
      expect(e1.earnedXp, 30);
      e1.dispose();

      final e2 = TimerEngine(durationMinutes: 3);
      e2.start();
      expect(e2.earnedXp, 5); // clamped to min 5
      e2.dispose();

      final e3 = TimerEngine(durationMinutes: 100);
      e3.start();
      expect(e3.earnedXp, 100); // clamped to max 100
      e3.dispose();
    });

    test('durationMinutes can be changed when not running', () {
      final engine = TimerEngine(durationMinutes: 25);
      engine.durationMinutes = 45;
      expect(engine.durationMinutes, 45);
      engine.dispose();
    });
  });

  group('TimerEdge cases', () {
    test('zero-duration timer completes after first tick', () async {
      final engine = TimerEngine(durationMinutes: 0);
      var completed = false;
      engine.onComplete = () { completed = true; };
      engine.start();
      await Future.delayed(const Duration(seconds: 2));
      expect(completed, true);
      engine.dispose();
    });

    test('dispose cancels timer without error', () {
      final engine = TimerEngine(durationMinutes: 25);
      engine.start();
      engine.dispose();
    });
  });
}
