#!/bin/bash
# ProfileForge Asset Downloader (v2 - correct URL format)
set -e

ASSET_DIR="assets/audio/sfx"
mkdir -p "$ASSET_DIR"

echo "=== ProfileForge Asset Downloader v2 ==="
echo "URL: https://assets.mixkit.co/active_storage/sfx/{ID}/{ID}.wav"
echo ""

# All verified IDs
declare -A CATEGORIES
CATEGORIES[click]="1109 1110 1111 1113 1114 1117 1119 1120 1124 1125"
CATEGORIES[success]="235 1017 1743 1942 1951 1955 2864 3060 3068 3116"
CATEGORIES[levelup]="2042 2043 2045 2047 2055 2058 2059 2060 2062 2063"
CATEGORIES[notif]="2310 2317 2320 2344 2354 2356 2357 2358 2489 2573"
CATEGORIES[sparkle]="2593 2603 2985 2986 2987 2988 2989 3062 3082"
CATEGORIES[pop]="2359 2361 2363 2364 2365 2925"

TOTAL=0
FAILED=0

for cat in "${!CATEGORIES[@]}"; do
  for id in ${CATEGORIES[$cat]}; do
    FILE="$ASSET_DIR/${cat}_${id}.wav"
    HTTP_CODE=$(curl -sL -o "$FILE" -w "%{http_code}" "https://assets.mixkit.co/active_storage/sfx/$id/$id.wav" 2>/dev/null)
    SIZE=$(stat -f%z "$FILE" 2>/dev/null || stat -c%s "$FILE" 2>/dev/null || echo 0)
    
    if [ "$HTTP_CODE" = "200" ] && [ "$SIZE" -gt 1000 ]; then
      echo "  ✓ $cat/$id.wav (${SIZE} bytes)"
      TOTAL=$((TOTAL + 1))
    else
      echo "  ✗ $cat/$id.wav (HTTP $HTTP_CODE, ${SIZE} bytes)"
      rm -f "$FILE"
      FAILED=$((FAILED + 1))
    fi
  done
done

echo ""
echo "=== Done ==="
echo "Downloaded: $TOTAL files"
echo "Failed: $FAILED files"
echo ""
ls -la "$ASSET_DIR/" | head -5
echo "..."
du -sh "$ASSET_DIR/"
