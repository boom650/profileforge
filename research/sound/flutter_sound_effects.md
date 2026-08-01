# Flutter Sound Effects Research

## 1. How to Play Short Sound Effects

### Package: audioplayers
```yaml
dependencies:
  audioplayers: ^6.1.0
```

### Basic Usage
```dart
import 'package:audioplayers/audioplayers.dart';

class SoundManager {
  static final SoundManager _instance = SoundManager._();
  factory SoundManager() => _instance;
  SoundManager._();

  final AudioPlayer _uiPlayer = AudioPlayer();  // For clicks, pops
  final AudioPlayer _musicPlayer = AudioPlayer(); // For background music

  // Short UI sound — uses low-latency mode
  Future<void> playClick() async {
    await _uiPlayer.play(
      AssetSource('sounds/click.wav'),
      mode: PlayerMode.lowLatency,
    );
  }

  // Success sound
  Future<void> playSuccess() async {
    await _uiPlayer.play(
      AssetSource('sounds/success.wav'),
      mode: PlayerMode.lowLatency,
    );
  }

  // Error sound
  Future<void> playError() async {
    await _uiPlayer.play(
      AssetSource('sounds/error.wav'),
      mode: PlayerMode.lowLatency,
    );
  }

  // Background music
  Future<void> startMusic() async {
    await _musicPlayer.play(
      AssetSource('music/background.mp3'),
      mode: PlayerMode.mediaPlayer,
    );
    await _musicPlayer.setReleaseMode(ReleaseMode.loop);
  }

  // Stop all
  void dispose() {
    _uiPlayer.dispose();
    _musicPlayer.dispose();
  }
}
```

### PlayerMode explained
| Mode | Latency | Use For |
|------|---------|---------|
| `PlayerMode.lowLatency` | ~50ms | UI sounds: click, tap, success |
| `PlayerMode.mediaPlayer` | ~200ms | Music, long audio, streaming |
| `PlayerMode.voicePlay` | ~100ms | Voice, narration |

### Important: lowLatency mode
- Plays audio immediately without full decode
- Ideal for UI feedback sounds (< 1 second)
- Cannot seek or get duration
- Use for button taps, toggles, notifications

---

## 2. Free UI Sound Effect Sources

### Mixkit.co (Best for Flutter)
- **License**: Free commercial use, no attribution required
- **Format**: WAV (convert to OGG/M4A for smaller bundle)
- **URL pattern**: `https://assets.mixkit.co/active_storage/sfx/{ID}/{ID}.wav`

### Verified Sound IDs by Category

| App Event | Category | Mixkit IDs | Suggested |
|-----------|----------|------------|-----------|
| Button tap | Click | 1109, 1110, 1111, 1113, 1114 | 1110 |
| Toggle on/off | Click | 1117, 1119, 1120 | 1119 |
| Success | Ding | 235, 1017, 1743, 1942 | 235 |
| Error | Pop | 2354, 2356, 2358 | 2358 |
| Level up | Game | 2042, 2043, 2047 | 2042 |
| Notification | Notification | 2310, 2317, 2344 | 2310 |
| Achievement | Sparkle | 2593, 2603, 2985 | 2593 |
| Pop/toggle | Pop | 2356, 2357, 2359 | 2356 |

### Download Script
```bash
#!/bin/bash
mkdir -p assets/sounds
SFX="https://assets.mixkit.co/active_storage/sfx"

curl -o assets/sounds/click.wav "$SFX/1110/1110.wav"
curl -o assets/sounds/toggle.wav "$SFX/1119/1119.wav"
curl -o assets/sounds/success.wav "$SFX/235/235.wav"
curl -o assets/sounds/error.wav "$SFX/2358/2358.wav"
curl -o assets/sounds/level_up.wav "$SFX/2042/2042.wav"
curl -o assets/sounds/notification.wav "$SFX/2310/2310.wav"
curl -o assets/sounds/achievement.wav "$SFX/2593/2593.wav"
curl -o assets/sounds/pop.wav "$SFX/2356/2356.wav"

# Convert to OGG for smaller size (Android)
for f in assets/sounds/*.wav; do
  ffmpeg -i "$f" -c:a libopus "${f%.wav}.ogg"
done
echo "Done: $(ls assets/sounds/*.ogg | wc -l) OGG files"

# Remove WAVs if OGG conversion succeeded
# rm assets/sounds/*.wav
```

### Other Sources
| Source | License | URL |
|--------|---------|-----|
| Mixkit | Free commercial | https://mixkit.co/free-sound-effects/ |
| Pixabay Sounds | Free commercial | https://pixabay.com/sound-effects/ |
| Freesound | CC0 / CC-BY | https://freesound.org |
| ZapSplat | Free (attribution) | https://www.zapsplat.com |

### Asset Declaration
```yaml
flutter:
  assets:
    - assets/sounds/
```

---

## 3. Syncing Sound with Animations

### Pattern 1: Sound triggers at animation start
```dart
class AnimatedButton extends StatefulWidget {
  @override
  State<AnimatedButton> createState() => _AnimatedButtonState();
}

class _AnimatedButtonState extends State<AnimatedButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  final _soundManager = SoundManager();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95)
      .animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) {
        _soundManager.playClick();  // Sound at tap start
        _controller.forward();
      },
      onTapUp: (_) => _controller.reverse(),
      onTapCancel: () => _controller.reverse(),
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) => Transform.scale(
          scale: _scaleAnimation.value,
          child: child,
        ),
        child: const Text('Press Me'),
      ),
    );
  }
}
```

### Pattern 2: Sound at animation completion
```dart
class SuccessAnimation extends StatefulWidget {
  @override
  State<SuccessAnimation> createState() => _SuccessAnimationState();
}

class _SuccessAnimationState extends State<SuccessAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final _soundManager = SoundManager();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    )..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _soundManager.playSuccess();  // Sound at completion
        }
      });
    _controller.forward();
  }
  // ...
}
```

### Pattern 3: Sound with Lottie
```dart
Lottie.asset(
  'assets/animations/success.json',
  onLoaded: (composition) {
    // Play sound when Lottie animation reaches the key moment
    Future.delayed(composition.duration * 0.3, () {
      _soundManager.playSuccess();
    });
  },
)
```

### Pattern 4: Sound with flutter_animate
```dart
Widget build(BuildContext context) {
  return const Text('Check!')
    .animate()
    .scale(
      duration: 300.ms,
      curve: Curves.elasticOut,
    )
    .then()  // After scale completes
    .callback(onComplete: (_) {
      _soundManager.playSuccess();
    });
}
```

---

## 4. Audio Caching for Performance

```dart
class CachedSoundManager {
  static final _cache = <String, AudioCache>{};

  static AudioCache getCache(String path) {
    _cache.putIfAbsent(path, () {
      final cache = AudioCache(prefix: 'assets/sounds/');
      return cache;
    });
    return _cache[path]!;
  }

  // Pre-load sounds at app start
  static Future<void> preload() async {
    await getCache('click').load('click.wav');
    await getCache('success').load('success.wav');
    await getCache('error').load('error.wav');
  }
}
```

---

## 5. Respecting User Preferences

```dart
class SoundManager {
  bool _soundEnabled = true;

  void setEnabled(bool enabled) {
    _soundEnabled = enabled;
  }

  Future<void> playClick() async {
    if (!_soundEnabled) return;
    await _uiPlayer.play(
      AssetSource('sounds/click.wav'),
      mode: PlayerMode.lowLatency,
    );
  }

  // Check system silent mode (iOS)
  Future<bool> isDeviceMuted() async {
    // audioplayers doesn't expose system mute state directly.
    // Use platform channel or just respect in-app toggle.
    return !_soundEnabled;
  }
}
```

### Volume control
```dart
// Set volume 0.0 to 1.0
await _uiPlayer.setVolume(0.8);

// Set playback rate (pitch adjustment)
await _uiPlayer.setPlaybackRate(1.0);
```

---

## 6. Bundle Size Optimization

| Format | Size (typical 1s click) | Platform |
|--------|------------------------|----------|
| WAV | 50-100KB | Universal |
| OGG (Opus) | 5-15KB | Android, Web |
| M4A (AAC) | 8-20KB | iOS |
| MP3 | 15-30KB | Universal |

**Recommendation**: 
- Ship OGG for Android, M4A for iOS
- Use `flutter_sound` or platform-specific assets for format selection
- Or use WAV universally if total sound budget < 500KB
- audioplayers supports WAV, OGG, MP3, M4A on all platforms

### Conditional assets (platform-specific)
```yaml
flutter:
  assets:
    - path: assets/sounds/click.ogg
      platforms: [android]
    - path: assets/sounds/click.m4a
      platforms: [ios]
```
