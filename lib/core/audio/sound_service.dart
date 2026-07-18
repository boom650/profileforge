import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/foundation.dart';

/// Lightweight sound-effects service. Plays short bundled WAVs.
/// All calls are no-ops if the asset is missing (so the app never
/// crashes on a missing sound). Respects a global mute toggle.
class SoundService {
  SoundService._();
  static final instance = SoundService._();

  final _player = AudioPlayer();
  bool _muted = false;

  bool get muted => _muted;

  Future<void> setMuted(bool v) async {
    _muted = v;
    if (v) await _player.stop();
  }

  /// Play a named effect from assets/audio/<name>.wav.
  Future<void> play(String name) async {
    if (_muted) return;
    try {
      await _player.stop();
      await _player.play(AssetSource('audio/$name.wav'),
          mode: PlayerMode.lowLatency);
    } catch (_) {
      // Missing asset — silently ignore.
    }
  void dispose() => _player.dispose();

  // Named effects (fire-and-forget; intentionally not awaited by callers).
  void tap() => play('tap');
  void success() => play('success');
  void unlock() => play('unlock');
  void levelUp() => play('level_up');
  void streak() => play('streak');
  void coin() => play('coin');
  void error() => play('error');
  void whoosh() => play('whoosh');
}
