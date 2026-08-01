#!/bin/bash
# ProfileForge Asset Downloader
# Downloads verified free Mixkit sound effects and creates asset directory structure
set -e

ASSET_DIR="assets/audio"
mkdir -p "$ASSET_DIR/sfx"

echo "=== ProfileForge Asset Downloader ==="
echo "Downloading verified Mixkit sound effects..."
echo ""

# Click/tap sounds (10 IDs, all verified HTTP 200)
CLICK_SOUNDS=(1109 1110 1111 1113 1114 1117 1119 1120 1124 1125)
for id in "${CLICK_SOUNDS[@]}"; do
  echo "  Downloading click/tap $id..."
  curl -sL -o "$ASSET_DIR/sfx/click_$id.wav" "https://assets.mixkit.co/active_storage/sfx/$id/$id-preview.wav" 2>/dev/null || echo "  WARN: Failed to download click_$id"
done

# Success/ding sounds (10 IDs)
SUCCESS_SOUNDS=(235 1017 1743 1942 1951 1955 2864 3060 3068 3116)
for id in "${SUCCESS_SOUNDS[@]}"; do
  echo "  Downloading success $id..."
  curl -sL -o "$ASSET_DIR/sfx/success_$id.wav" "https://assets.mixkit.co/active_storage/sfx/$id/$id-preview.wav" 2>/dev/null || echo "  WARN: Failed to download success_$id"
done

# Game/level up sounds (10 IDs)
LEVELUP_SOUNDS=(2042 2043 2045 2047 2055 2058 2059 2060 2062 2063)
for id in "${LEVELUP_SOUNDS[@]}"; do
  echo "  Downloading levelup $id..."
  curl -sL -o "$ASSET_DIR/sfx/levelup_$id.wav" "https://assets.mixkit.co/active_storage/sfx/$id/$id-preview.wav" 2>/dev/null || echo "  WARN: Failed to download levelup_$id"
done

# Notification sounds (10 IDs)
NOTIF_SOUNDS=(2310 2317 2320 2344 2354 2356 2357 2358 2489 2573)
for id in "${NOTIF_SOUNDS[@]}"; do
  echo "  Downloading notification $id..."
  curl -sL -o "$ASSET_DIR/sfx/notif_$id.wav" "https://assets.mixkit.co/active_storage/sfx/$id/$id-preview.wav" 2>/dev/null || echo "  WARN: Failed to download notif_$id"
done

# Sparkle/achievement sounds (10 IDs)
SPARKLE_SOUNDS=(2593 2603 2985 2986 2987 2988 2989 3060 3062 3082)
for id in "${SPARKLE_SOUNDS[@]}"; do
  echo "  Downloading sparkle $id..."
  curl -sL -o "$ASSET_DIR/sfx/sparkle_$id.wav" "https://assets.mixkit.co/active_storage/sfx/$id/$id-preview.wav" 2>/dev/null || echo "  WARN: Failed to download sparkle_$id"
done

# Pop/UI feedback sounds (10 IDs)
POP_SOUNDS=(2356 2357 2358 2359 2361 2363 2364 2365 2925)
for id in "${POP_SOUNDS[@]}"; do
  echo "  Downloading pop $id..."
  curl -sL -o "$ASSET_DIR/sfx/pop_$id.wav" "https://assets.mixkit.co/active_storage/sfx/$id/$id-preview.wav" 2>/dev/null || echo "  WARN: Failed to download pop_$id"
done

echo ""
echo "=== Download Complete ==="
echo "Assets saved to: $ASSET_DIR/sfx/"
echo ""
echo "Files downloaded:"
ls -la "$ASSET_DIR/sfx/" | grep -c ".wav" | xargs -I{} echo "  {} WAV files"
echo ""
echo "Next steps:"
echo "  1. Review downloaded sounds: ls $ASSET_DIR/sfx/"
echo "  2. Pick best 5-6 sounds for ProfileForge"
echo "  3. Convert WAV to OGG/M4A for 5-8x smaller bundle"
echo "  4. Add to pubspec.yaml flutter: assets:"
