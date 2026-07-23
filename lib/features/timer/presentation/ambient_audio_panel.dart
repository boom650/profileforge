import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:profileforge/core/theme/app_theme.dart';

/// ────────────────────────────────────────────────────────────────────────────
/// Ambient Audio Player — space-themed UI for focus soundscapes.
/// Plays the bundled lofi, rain, library, and coffee-shop tracks.
/// ────────────────────────────────────────────────────────────────────────────

enum AmbientSound {
  lofi('Lo-fi Beats', '🎧', 'assets/audio/ambient/lofi_10.mb.mp3'),
  rain('Rainy Day', '🌧️', 'assets/audio/ambient/rain_10.mb.mp3'),
  library('Library', '📚', 'assets/audio/ambient/library_10.mb.mp3'),
  coffee('Coffee Shop', '☕', 'assets/audio/ambient/coffee_10.mb.mp3');

  final String label;
  final String emoji;
  final String assetPath;
  const AmbientSound(this.label, this.emoji, this.assetPath);
}

class AudioPlayerService extends ChangeNotifier {
  final _player = AudioPlayer();
  AmbientSound? _currentTrack;
  bool _playing = false;
  double _volume = 0.5;

  AmbientSound? get currentTrack => _currentTrack;
  bool get isPlaying => _playing;
  double get volume => _volume;

  Future<void> play(AmbientSound sound) async {
    // Stop current if playing
    if (_playing) {
      await _player.stop();
    }
    _currentTrack = sound;
    await _player.setSource(AssetSource(sound.assetPath.replaceFirst('assets/', '')));
    await _player.setVolume(_volume);
    await _player.resume();
    _playing = true;
    // Loop: on completed, replay.
    _player.onPlayerComplete.listen((_) async {
      if (_currentTrack != null) {
        await _player.seek(Duration.zero);
        await _player.resume();
      }
    });
    notifyListeners();
  }

  Future<void> toggle() async {
    if (_currentTrack == null) return;
    if (_playing) {
      await _player.pause();
      _playing = false;
    } else {
      await _player.resume();
      _playing = true;
    }
    notifyListeners();
  }

  Future<void> stop() async {
    await _player.stop();
    _playing = false;
    _currentTrack = null;
    notifyListeners();
  }

  Future<void> setVolume(double v) async {
    _volume = v;
    await _player.setVolume(v);
    notifyListeners();
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }
}

final audioPlayerServiceProvider = ChangeNotifierProvider<AudioPlayerService>((ref) {
  return AudioPlayerService();
});

class AmbientAudioPanel extends ConsumerWidget {
  const AmbientAudioPanel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final svc = ref.watch(audioPlayerServiceProvider);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDark
              ? [Palette.ink.withOpacity(0.6), Palette.inkSurface]
              : [Colors.white, Colors.grey.shade50],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: svc.isPlaying
              ? Palette.green.withOpacity(0.5)
              : theme.dividerColor.withOpacity(0.3),
          width: 1.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Icon(Icons.spatial_audio_off,
                  size: 18, color: svc.isPlaying ? Palette.green : theme.hintColor),
              const SizedBox(width: 8),
              Text('Ambient Sound',
                  style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
              const Spacer(),
              if (svc.currentTrack != null)
                GestureDetector(
                  onTap: () => svc.stop(),
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.stop, size: 16, color: Colors.red),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          // Track selector
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: AmbientSound.values.map((sound) {
              final selected = svc.currentTrack == sound;
              return GestureDetector(
                onTap: () => svc.play(sound),
                child: AnimatedContainer(
                  duration: 200.ms,
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    color: selected
                        ? Palette.green.withOpacity(0.2)
                        : (isDark ? Palette.inkSurface2 : Colors.grey.shade100),
                    borderRadius: BorderRadius.circular(14),
                    border: selected
                        ? Border.all(color: Palette.green.withOpacity(0.6), width: 2)
                        : null,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(sound.emoji, style: const TextStyle(fontSize: 18)),
                      const SizedBox(width: 6),
                      Text(sound.label,
                          style: TextStyle(
                              fontSize: 13,
                              fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                              color: selected ? Palette.green : null)),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
          // Volume slider & play/pause
          if (svc.currentTrack != null) ...[
            const SizedBox(height: 12),
            Row(
              children: [
                GestureDetector(
                  onTap: () => svc.toggle(),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Palette.green.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Icon(
                      svc.isPlaying ? Icons.pause : Icons.play_arrow,
                      color: Palette.green,
                      size: 20,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      overlayShape: SliderComponentShape.noThumb,
                      thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8),
                      activeTrackColor: Palette.green,
                      inactiveTrackColor: theme.disabledColor.withOpacity(0.3),
                    ),
                    child: Slider(
                      value: svc.volume,
                      onChanged: (v) => svc.setVolume(v),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    ).animate().fadeIn(duration: 400.ms).slideX(begin: 0.1);
  }
}
