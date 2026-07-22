#!/usr/bin/env bash
# Run inside proot-distro ubuntu
export PATH="/data/data/com.termux/files/home/flutter/bin:/data/data/com.termux/files/home/flutter/bin/cache/dart-sdk/bin:$PATH"
export FLUTTER_STORAGE_BASE_URL="https://storage.flutter-io.cn"
export PUB_HOSTED_URL="https://pub.dev"
cd /data/data/com.termux/files/home/workspace
echo "=== dart version ==="
dart --version 2>&1
echo "=== pub get ==="
dart pub get 2>&1
echo "=== build_runner ==="
dart run build_runner build --delete-conflicting-outputs 2>&1
echo "=== DONE ==="
