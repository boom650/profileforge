import 'dart:async';

/// Pure Dart timer engine — no Flutter dependency.
/// Manages a countdown timer with start, pause, resume, reset.
class TimerEngine {
  TimerEngine({this.durationMinutes = 25});

  int durationMinutes;
  int _secondsRemaining = 0;
  bool _isRunning = false;
  bool _isPaused = false;
  Timer? _timer;
  DateTime? _sessionStart;

  int get secondsRemaining => _secondsRemaining;
  int get elapsedSeconds => durationMinutes * 60 - _secondsRemaining;
  bool get isRunning => _isRunning;
  bool get isPaused => _isPaused;
  bool get isComplete => _secondsRemaining <= 0 && (_isRunning || _isPaused);
  DateTime? get sessionStart => _sessionStart;

  /// Called every tick (each second).
  void Function(int secondsRemaining)? onTick;
  /// Called when the timer naturally reaches 0.
  void Function()? onComplete;

  void start() {
    if (_isRunning) return;
    _secondsRemaining = durationMinutes * 60;
    _isRunning = true;
    _isPaused = false;
    _sessionStart = DateTime.now();
    _startTimer();
  }

  void pause() {
    if (!_isRunning || _isPaused) return;
    _isPaused = true;
    _timer?.cancel();
  }

  void resume() {
    if (!_isRunning || !_isPaused) return;
    _isPaused = false;
    _startTimer();
  }

  void reset() {
    _timer?.cancel();
    _isRunning = false;
    _isPaused = false;
    _secondsRemaining = durationMinutes * 60;
    _sessionStart = null;
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (_secondsRemaining > 0) {
        _secondsRemaining--;
        onTick?.call(_secondsRemaining);
      }
      if (_secondsRemaining <= 0) {
        _timer?.cancel();
        _isRunning = false;
        _isPaused = false;
        onComplete?.call();
      }
    });
  }

  int get earnedXp {
    if (_sessionStart == null) return 0;
    final actualMinutes = durationMinutes;
    // 1 XP per minute studied, minimum 5
    return (actualMinutes * 1).clamp(5, 100);
  }

  void dispose() {
    _timer?.cancel();
  }
}
