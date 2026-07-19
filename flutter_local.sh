#!/usr/bin/env bash
# Run Flutter/Dart locally on Termux/Android via the Ubuntu proot-distro (glibc) container.
# Flutter's Linux Dart SDK needs glibc, which Android/Bionic lacks; the Ubuntu proot provides it.
# Usage: ./flutter_local.sh analyze   |   ./flutter_local.sh test   |   ./flutter_local.sh build apk
set -e
FLUTTER_DIR="/data/data/com.termux/files/home/flutter"
WORKSPACE="/data/data/com.termux/files/home/workspace"
LOG="/data/data/com.termux/files/home/flutter_local.log"

export FLUTTER_STORAGE_BASE_URL="https://storage.flutter-io.cn"
export PUB_HOSTED_URL="https://pub.dev"
export PATH="$FLUTTER_DIR/bin:$PATH"

proot-distro login ubuntu -- bash -c "
  export PATH=\"$FLUTTER_DIR/bin:\$PATH\"
  export FLUTTER_STORAGE_BASE_URL=\"$FLUTTER_STORAGE_BASE_URL\"
  export PUB_HOSTED_URL=\"$PUB_HOSTED_URL\"
  cd $WORKSPACE
  flutter $*
" 2>&1 | tee "$LOG"
