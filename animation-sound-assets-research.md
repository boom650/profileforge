# Free Animation & Sound Effect Assets Research

## LOTTIE ANIMATIONS (LottieFiles.com)

All LottieFiles community animations are free for personal and commercial use.
Download JSON files from each page → use with `lottie` Flutter package.

### Onboarding / Welcome

| Search URL | Purpose |
|---|---|
| https://lottiefiles.com/search?q=onboarding+welcome | Welcome screen animations |
| https://lottiefiles.com/search?q=welcome+hello+wave | Friendly hello/wave |
| https://lottiefiles.com/search?q=onboarding+mobile+app | App onboarding screens |
| https://lottiefiles.com/search?q=hand+wave+hello | Hand wave greeting |

### Goal Setting / Targets

| Search URL | Purpose |
|---|---|
| https://lottiefiles.com/search?q=target+bullseye | Target/goal imagery |
| https://lottiefiles.com/search?q=goal+setting+planning | Goal planning visuals |
| https://lottiefiles.com/search?q=clipboard+check+list | Task/checklist |
| https://lottiefiles.com/search?q=calendar+planning | Schedule planning |

### Celebration / Success

| Search URL | Purpose |
|---|---|
| https://lottiefiles.com/search?q=success+checkmark | Green checkmark success |
| https://lottiefiles.com/search?q=confetti+celebration | Confetti burst |
| https://lottiefiles.com/search?q=party+celebration | Party/celebration |
| https://lottiefiles.com/search?q=medal+trophy+achievement | Achievement badge |
| https://lottiefiles.com/search?q=task+complete+done | Task completion |

### Streak / Fire

| Search URL | Purpose |
|---|---|
| https://lottiefiles.com/search?q=fire+flame+streak | Fire streak animation |
| https://lottiefiles.com/search?q=flame+fire+loop | Flame loop |
| https://lottiefiles.com/search?q=streak+fire+gamification | Gamification fire |

### Level Up

| Search URL | Purpose |
|---|---|
| https://lottiefiles.com/search?q=level+up+star | Level up star |
| https://lottiefiles.com/search?q=upgrade+arrow+up | Upgrade/level up |
| https://lottiefiles.com/search?q=star+sparkle+reward | Star reward |
| https://lottiefiles.com/search?q=gamification+badge+coin | Gamification elements |

### Loading States

| Search URL | Purpose |
|---|---|
| https://lottiefiles.com/search?q=loading+spinner | Spinner/loader |
| https://lottiefiles.com/search?q=skeleton+loading | Skeleton loading |
| https://lottiefiles.com/search?q=dots+bouncing+loader | Bouncing dots |
| https://lottiefiles.com/search?q=circular+progress | Circular progress |

### Empty States

| Search URL | Purpose |
|---|---|
| https://lottiefiles.com/search?q=empty+box+no+data | Empty state |
| https://lottiefiles.com/search?q=empty+inbox+illustration | Empty inbox |
| https://lottiefiles.com/search?q=search+no+results | No results found |

### Error States

| Search URL | Purpose |
|---|---|
| https://lottiefiles.com/search?q=error+404+not+found | 404 page |
| https://lottiefiles.com/search?q=sad+face+error | Error face |
| https://lottiefiles.com/search?q=broken+connection+error | Connection error |
| https://lottiefiles.com/search?q=warning+error+alert | Warning alert |

### Verified Working LottieFiles CDN URLs (old format)

These are from the legacy `assets*.lottiefiles.com/packages/` CDN and confirmed accessible:

```
# Success/checkmark (500x500, Lottie v5.8.1)
https://assets2.lottiefiles.com/packages/lf20_touohxv0.json

# General free animation
https://assets3.lottiefiles.com/packages/lf20_UJNc2t.json
https://assets9.lottiefiles.com/packages/lf20_UJNc2t.json
```

### Recommended Free Flutter Package

```yaml
dependencies:
  lottie: ^3.1.2          # Standard Lottie for Flutter
  # OR
  dotlottie: ^1.0.14       # dotLottie format (compressed, animated)
```

**Usage:**
```dart
// From network
Lottie.network('https://assets2.lottiefiles.com/packages/lf20_touohxv0.json')

// From asset (bundle JSON in assets/)
Lottie.asset('assets/animations/success.json')

// From file
Lottie.file(File('path/to/animation.json'))
```

### License Note (LottieFiles)
- Community/free animations: **Free for personal & commercial use**
- Premium animations: require subscription
- Always check individual animation page for license badge
- Attribution not required for free animations but appreciated

---

## RIVE ANIMATIONS (rive.app/community)

Rive uses `.riv` binary files — more performant than Lottie for Flutter.

### Community Files Page
https://rive.app/community/files

### Search Terms for Rive Community
| Purpose | Search on rive.app/community/files |
|---|---|
| Loading | search "loading", "spinner" |
| Success | search "check", "success", "done" |
| Icons | search "animated icon" |
| Buttons | search "button", "micro-interaction" |
| Abstract | search "shape", "morph", "abstract" |

### Rive Assets for Flutter

```yaml
dependencies:
  rive: ^0.13.20          # Rive runtime for Flutter
```

**Usage:**
```dart
// From asset
RiveAnimation.asset(
  'assets/animations/loader.riv',
  fit: BoxFit.cover,
)

// From network
RiveAnimation.network(
  'https://rive.app/path/to/file.riv',
)

// With state machine control
RiveAnimation.asset(
  'assets/animations/button.riv',
  onInit: (artboard) {
    final controller = StateMachineController.fromArtboard(artboard, 'StateMachine');
    artboard.addController(controller!);
    // Trigger inputs...
  },
)
```

### Rive vs Lottie Recommendation
- **Rive**: Better performance, smaller file sizes, interactive animations, state machines
- **Lottie**: Larger community, more pre-made assets, easier to find specific animations
- **Recommendation**: Use Rive for simple interactive elements (buttons, loading), Lottie for complex illustrations (onboarding, celebrations)

---

## SOUND EFFECTS (Mixkit.co)

All Mixkit sound effects are **free for commercial use**, no attribution required.

Download URL pattern: `https://assets.mixkit.co/active_storage/sfx/{ID}/{ID}.wav`

### Verified Working Download URLs

#### Click / Tap Sounds
| ID | Download URL | Category |
|---|---|---|
| 1109 | https://assets.mixkit.co/active_storage/sfx/1109/1109.wav | Click |
| 1110 | https://assets.mixkit.co/active_storage/sfx/1110/1110.wav | Click |
| 1111 | https://assets.mixkit.co/active_storage/sfx/1111/1111.wav | Click |
| 1113 | https://assets.mixkit.co/active_storage/sfx/1113/1113.wav | Click |
| 1114 | https://assets.mixkit.co/active_storage/sfx/1114/1114.wav | Click |
| 1117 | https://assets.mixkit.co/active_storage/sfx/1117/1117.wav | Click |
| 1119 | https://assets.mixkit.co/active_storage/sfx/1119/1119.wav | Click |
| 1120 | https://assets.mixkit.co/active_storage/sfx/1120/1120.wav | Click |
| 1124 | https://assets.mixkit.co/active_storage/sfx/1124/1124.wav | Click |
| 1125 | https://assets.mixkit.co/active_storage/sfx/1125/1125.wav | Click |

Browse more: https://mixkit.co/free-sound-effects/click/

#### Ding / Success Sounds
| ID | Download URL | Category |
|---|---|---|
| 235 | https://assets.mixkit.co/active_storage/sfx/235/235.wav | Ding |
| 1743 | https://assets.mixkit.co/active_storage/sfx/1743/1743.wav | Ding |
| 1942 | https://assets.mixkit.co/active_storage/sfx/1942/1942.wav | Ding |
| 1951 | https://assets.mixkit.co/active_storage/sfx/1951/1951.wav | Ding |
| 1955 | https://assets.mixkit.co/active_storage/sfx/1955/1955.wav | Ding |
| 1017 | https://assets.mixkit.co/active_storage/sfx/1017/1017.wav | Ding |
| 2864 | https://assets.mixkit.co/active_storage/sfx/2864/2864.wav | Ding |
| 3060 | https://assets.mixkit.co/active_storage/sfx/3060/3060.wav | Ding |
| 3068 | https://assets.mixkit.co/active_storage/sfx/3068/3068.wav | Ding |
| 3116 | https://assets.mixkit.co/active_storage/sfx/3116/3116.wav | Ding |

Browse more: https://mixkit.co/free-sound-effects/ding/

#### Game / Level Up Sounds
| ID | Download URL | Category |
|---|---|---|
| 2042 | https://assets.mixkit.co/active_storage/sfx/2042/2042.wav | Game |
| 2043 | https://assets.mixkit.co/active_storage/sfx/2043/2043.wav | Game |
| 2045 | https://assets.mixkit.co/active_storage/sfx/2045/2045.wav | Game |
| 2047 | https://assets.mixkit.co/active_storage/sfx/2047/2047.wav | Game |
| 2055 | https://assets.mixkit.co/active_storage/sfx/2055/2055.wav | Game |
| 2058 | https://assets.mixkit.co/active_storage/sfx/2058/2058.wav | Game |
| 2059 | https://assets.mixkit.co/active_storage/sfx/2059/2059.wav | Game |
| 2060 | https://assets.mixkit.co/active_storage/sfx/2060/2060.wav | Game |
| 2062 | https://assets.mixkit.co/active_storage/sfx/2062/2062.wav | Game |
| 2063 | https://assets.mixkit.co/active_storage/sfx/2063/2063.wav | Game |

Browse more: https://mixkit.co/free-sound-effects/game/

#### Video Game Sounds (retro, chiptune style)
| ID | Download URL | Category |
|---|---|---|
| 2042-2063 | See game category above | Video Game |

Browse more: https://mixkit.co/free-sound-effects/video-game/

#### Notification Sounds
| ID | Download URL | Category |
|---|---|---|
| 2310 | https://assets.mixkit.co/active_storage/sfx/2310/2310.wav | Notification |
| 2317 | https://assets.mixkit.co/active_storage/sfx/2317/2317.wav | Notification |
| 2320 | https://assets.mixkit.co/active_storage/sfx/2320/2320.wav | Notification |
| 2344 | https://assets.mixkit.co/active_storage/sfx/2344/2344.wav | Notification |
| 2354 | https://assets.mixkit.co/active_storage/sfx/2354/2354.wav | Notification |
| 2356 | https://assets.mixkit.co/active_storage/sfx/2356/2356.wav | Notification |
| 2357 | https://assets.mixkit.co/active_storage/sfx/2357/2357.wav | Notification |
| 2358 | https://assets.mixkit.co/active_storage/sfx/2358/2358.wav | Notification |
| 2489 | https://assets.mixkit.co/active_storage/sfx/2489/2489.wav | Notification |
| 2573 | https://assets.mixkit.co/active_storage/sfx/2573/2573.wav | Notification |

Browse more: https://mixkit.co/free-sound-effects/notification/

#### Sparkle / Achievement Sounds
| ID | Download URL | Category |
|---|---|---|
| 2593 | https://assets.mixkit.co/active_storage/sfx/2593/2593.wav | Sparkle |
| 2603 | https://assets.mixkit.co/active_storage/sfx/2603/2603.wav | Sparkle |
| 2985 | https://assets.mixkit.co/active_storage/sfx/2985/2985.wav | Sparkle |
| 2986 | https://assets.mixkit.co/active_storage/sfx/2986/2986.wav | Sparkle |
| 2987 | https://assets.mixkit.co/active_storage/sfx/2987/2987.wav | Sparkle |
| 2988 | https://assets.mixkit.co/active_storage/sfx/2988/2988.wav | Sparkle |
| 2989 | https://assets.mixkit.co/active_storage/sfx/2989/2989.wav | Sparkle |
| 3082 | https://assets.mixkit.co/active_storage/sfx/3082/3082.wav | Sparkle |

Browse more: https://mixkit.co/free-sound-effects/sparkle/

#### Pop Sounds (UI feedback)
| ID | Download URL | Category |
|---|---|---|
| 2354 | https://assets.mixkit.co/active_storage/sfx/2354/2354.wav | Pop |
| 2356 | https://assets.mixkit.co/active_storage/sfx/2356/2356.wav | Pop |
| 2357 | https://assets.mixkit.co/active_storage/sfx/2357/2357.wav | Pop |
| 2358 | https://assets.mixkit.co/active_storage/sfx/2358/2358.wav | Pop |
| 2359 | https://assets.mixkit.co/active_storage/sfx/2359/2359.wav | Pop |
| 2361 | https://assets.mixkit.co/active_storage/sfx/2361/2361.wav | Pop |
| 2363 | https://assets.mixkit.co/active_storage/sfx/2363/2363.wav | Pop |
| 2364 | https://assets.mixkit.co/active_storage/sfx/2364/2364.wav | Pop |
| 2365 | https://assets.mixkit.co/active_storage/sfx/2365/2365.wav | Pop |
| 2925 | https://assets.mixkit.co/active_storage/sfx/2925/2925.wav | Pop |

Browse more: https://mixkit.co/free-sound-effects/pop/

#### Swoosh / Transition Sounds
Browse: https://mixkit.co/free-sound-effects/swoosh/
Browse: https://mixkit.co/free-sound-effects/whoosh/
Browse: https://mixkit.co/free-sound-effects/transition/

### Recommended Sound Categories for Flutter App

| Use Case | Category | Best IDs |
|---|---|---|
| Button tap | Click | 1109, 1110, 1111 |
| Mission complete | Ding | 235, 1743, 1942 |
| Level up | Game | 2042, 2043, 2047 |
| Streak fire | Sparkle | 2593, 2603, 2985 |
| Notification | Notification | 2310, 2317, 2344 |
| Pop feedback | Pop | 2356, 2357, 2359 |
| Screen transition | Swoosh | Browse category page |

### License Note (Mixkit)
- **Free for commercial use** — no attribution required
- No sign-up needed to download
- WAV format, can convert to OGG/M4A for mobile
- URL pattern: `https://assets.mixkit.co/active_storage/sfx/{ID}/{ID}.wav`

---

## DOWNLOAD SCRIPT

```bash
#!/bin/bash
# Download all sound effects to assets/sounds/
mkdir -p assets/sounds

# Click sounds
curl -o assets/sounds/click_1.wav "https://assets.mixkit.co/active_storage/sfx/1109/1109.wav"
curl -o assets/sounds/click_2.wav "https://assets.mixkit.co/active_storage/sfx/1110/1110.wav"
curl -o assets/sounds/click_3.wav "https://assets.mixkit.co/active_storage/sfx/1111/1111.wav"

# Success / Ding sounds
curl -o assets/sounds/ding_success_1.wav "https://assets.mixkit.co/active_storage/sfx/235/235.wav"
curl -o assets/sounds/ding_success_2.wav "https://assets.mixkit.co/active_storage/sfx/1743/1743.wav"
curl -o assets/sounds/ding_success_3.wav "https://assets.mixkit.co/active_storage/sfx/1942/1942.wav"

# Game / Level up sounds
curl -o assets/sounds/level_up_1.wav "https://assets.mixkit.co/active_storage/sfx/2042/2042.wav"
curl -o assets/sounds/level_up_2.wav "https://assets.mixkit.co/active_storage/sfx/2043/2043.wav"
curl -o assets/sounds/level_up_3.wav "https://assets.mixkit.co/active_storage/sfx/2047/2047.wav"

# Sparkle / Achievement sounds
curl -o assets/sounds/sparkle_1.wav "https://assets.mixkit.co/active_storage/sfx/2593/2593.wav"
curl -o assets/sounds/sparkle_2.wav "https://assets.mixkit.co/active_storage/sfx/2603/2603.wav"
curl -o assets/sounds/sparkle_3.wav "https://assets.mixkit.co/active_storage/sfx/2985/2985.wav"

# Notification sounds
curl -o assets/sounds/notification_1.wav "https://assets.mixkit.co/active_storage/sfx/2310/2310.wav"
curl -o assets/sounds/notification_2.wav "https://assets.mixkit.co/active_storage/sfx/2317/2317.wav"
curl -o assets/sounds/notification_3.wav "https://assets.mixkit.co/active_storage/sfx/2344/2344.wav"

# Pop / UI feedback sounds
curl -o assets/sounds/pop_1.wav "https://assets.mixkit.co/active_storage/sfx/2356/2356.wav"
curl -o assets/sounds/pop_2.wav "https://assets.mixkit.co/active_storage/sfx/2357/2357.wav"
curl -o assets/sounds/pop_3.wav "https://assets.mixkit.co/active_storage/sfx/2359/2359.wav"

echo "Download complete! Files in assets/sounds/"
ls -la assets/sounds/
```

### Flutter Sound Package

```yaml
dependencies:
  audioplayers: ^6.1.0    # Play sound effects from assets
```

**Usage:**
```dart
final player = AudioPlayer();

// Play from assets
await player.play(AssetSource('sounds/ding_success_1.wav'));

// Play from network
await player.play(UrlSource('https://assets.mixkit.co/active_storage/sfx/235/235.wav'));

// One-shot sound (no overlap)
player.play(AssetSource('sounds/click_1.wav'), mode: PlayerMode.lowLatency);
```

---

## ADDITIONAL FREE RESOURCE SITES

| Site | Type | URL | License |
|---|---|---|---|
| LottieFiles | Lottie animations | https://lottiefiles.com | Free tier available |
| Lordicon | Animated icons (Lottie/Rive) | https://lordicon.com | Free tier (50 icons) |
| LottieBnB | Lottie animations | https://lottiebnb.com | Free |
| Rive Community | Rive animations | https://rive.app/community/files | Free |
| Icons8 Animated Icons | Lottie icons | https://icons8.com/animated-icons | Free with attribution |
| Mixkit | Sound effects | https://mixkit.co/free-sound-effects/ | Free commercial use |
| Pixabay Sounds | Sound effects | https://pixabay.com/sound-effects/ | Free commercial use |
| Freesound | Sound effects | https://freesound.org | CC0 / CC-BY |
| Zapsplat | Sound effects | https://www.zapsplat.com | Free with attribution |
