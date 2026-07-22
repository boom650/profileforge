import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:profileforge/core/data/app_database.dart';
import 'package:profileforge/core/data/app_database_provider.dart';
import 'package:profileforge/features/timer/data/focus_repository.dart';
import 'package:profileforge/features/timer/domain/timer_engine.dart';

// ── Repository Provider ──
final focusRepoProvider = Provider<FocusSessionRepository>((ref) {
  final db = ref.watch(appDatabaseProvider);
  return FocusSessionRepository(db);
});

// ── Timer State (mutable) ──
class TimerStateNotifier extends Notifier<TimerSnapshot> {
  late TimerEngine _engine;

  @override
  TimerSnapshot build() {
    _engine = TimerEngine(durationMinutes: 25);
    _engine.onTick = (secs) {
      state = TimerSnapshot(
        secondsRemaining: secs,
        durationMinutes: _engine.durationMinutes,
        isRunning: true,
        isPaused: _engine.isPaused,
        label: '',
      );
    };
    return TimerSnapshot(
      secondsRemaining: 25 * 60,
      durationMinutes: 25,
      isRunning: false,
      isPaused: false,
      label: '',
    );
  }

  void start() {
    _engine.start();
    state = TimerSnapshot(secondsRemaining: _engine.secondsRemaining, durationMinutes: _engine.durationMinutes, isRunning: true, isPaused: false, label: 'Focus');
  }

  void pause() {
    _engine.pause();
    state = TimerSnapshot(secondsRemaining: _engine.secondsRemaining, durationMinutes: _engine.durationMinutes, isRunning: true, isPaused: true, label: 'Paused');
  }

  void resume() {
    _engine.resume();
    state = TimerSnapshot(secondsRemaining: _engine.secondsRemaining, durationMinutes: _engine.durationMinutes, isRunning: true, isPaused: false, label: 'Focus');
  }

  void reset() {
    _engine.reset();
    state = TimerSnapshot(secondsRemaining: _engine.durationMinutes * 60, durationMinutes: _engine.durationMinutes, isRunning: false, isPaused: false, label: '');
  }

  void setDuration(int minutes) {
    _engine.dispose();
    _engine = TimerEngine(durationMinutes: minutes);
    _engine.onTick = (secs) {
      state = TimerSnapshot(secondsRemaining: secs, durationMinutes: minutes, isRunning: true, isPaused: _engine.isPaused, label: '');
    };
    state = TimerSnapshot(secondsRemaining: minutes * 60, durationMinutes: minutes, isRunning: false, isPaused: false, label: '');
  }

  TimerEngine get engine => _engine;
}

class TimerSnapshot {
  final int secondsRemaining;
  final int durationMinutes;
  final bool isRunning;
  final bool isPaused;
  final String label;
  const TimerSnapshot({required this.secondsRemaining, required this.durationMinutes, required this.isRunning, required this.isPaused, required this.label});
}

final timerStateProvider = NotifierProvider<TimerStateNotifier, TimerSnapshot>(TimerStateNotifier.new);

// ── Async Providers ──
final saveFocusSessionProvider = FutureProvider.family<void, ({String profileId, int durationMinutes, int xpEarned, String tag})>((ref, args) async {
  final repo = ref.read(focusRepoProvider);
  await repo.saveSession(FocusSessionsCompanion(
    profileId: Value(args.profileId),
    durationMinutes: Value(args.durationMinutes),
    xpEarned: Value(args.xpEarned),
    tag: Value(args.tag),
    completed: const Value(true),
    startedAt: Value(DateTime.now()),
  ));
});

final totalFocusMinutesProvider = FutureProvider.family<int, String>((ref, profileId) async {
  final repo = ref.read(focusRepoProvider);
  return repo.totalFocusMinutes(profileId);
});

final todayFocusMinutesProvider = FutureProvider.family<int, String>((ref, profileId) async {
  final repo = ref.read(focusRepoProvider);
  return repo.totalFocusMinutesToday(profileId);
});

final focusSessionCountProvider = FutureProvider.family<int, String>((ref, profileId) async {
  final repo = ref.read(focusRepoProvider);
  return repo.sessionCount(profileId);
});

final focusMinutesByTagProvider = FutureProvider.family<Map<String, int>, String>((ref, profileId) async {
  final repo = ref.read(focusRepoProvider);
  return repo.minutesByTag(profileId);
});

final recentSessionsProvider = FutureProvider.family<List<FocusSessionRow>, String>((ref, profileId) async {
  final repo = ref.read(focusRepoProvider);
  return repo.recentSessions(profileId);
});
