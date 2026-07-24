#!/usr/bin/env bash
# Run Flutter/Dart locally on Termux/Android via the Ubuntu proot-distro (glibc) container.
# Flutter's Linux Dart SDK needs glibc, which Android/Bionic lacks; the Ubuntu proot provides it.
#
# Setup (one-time, already done):
#   1. Download dart-sdk-linux-arm64.zip from
#      https://storage.flutter-io.cn/flutter_infra_release/flutter/<engine.version>/dart-sdk-linux-arm64.zip
#      (engine.version = cat $HOME/flutter/bin/internal/engine.version) and unzip into
#      $HOME/flutter/bin/cache/ (overwriting the partial dart-sdk).
#   2. Copy $PREFIX/etc/tls/cert.pem -> .../proot-distro/containers/ubuntu/rootfs/etc/ssl/certs/ca-certificates.crt
#      (the Ubuntu proot ships NO CA certs, so TLS fails otherwise).
#   3. Run flutter inside proot with FLUTTER_STORAGE_BASE_URL=https://storage.flutter-io.cn and
#      PUB_HOSTED_URL=https://pub.dev (pub.flutter-io.cn is TLS-flaky).
#
# Usage:
#   ./flutter_local.sh gen            # run build_runner (generates *.g.dart / *.freezed.dart) — DO THIS BEFORE analyze
#   ./flutter_local.sh analyze        # dart analyze (fast per-file); run `gen` first
#   ./flutter_local.sh analyze-all    # full-project dart analyze (slow under proot, ~25min)
#   ./flutter_local.sh test           # flutter test
#   ./flutter_local.sh build apk      # flutter build apk
#   ./flutter_local.sh <any flutter cmd>
set -e
FLUTTER_DIR="/data/data/com.termux/files/home/flutter"
WORKSPACE="/data/data/com.termux/files/home/workspace"
LOG="/data/data/com.termux/files/home/flutter_local.log"

export FLUTTER_STORAGE_BASE_URL="https://storage.flutter-io.cn"
export PUB_HOSTED_URL="https://pub.dev"

CMD="$1"; shift || true

run_in_proot() {
  proot-distro login ubuntu -- bash -c "
    export PATH=\"$FLUTTER_DIR/bin:\$PATH\"
    export FLUTTER_STORAGE_BASE_URL=\"$FLUTTER_STORAGE_BASE_URL\"
    export PUB_HOSTED_URL=\"$PUB_HOSTED_URL\"
    cd $WORKSPACE
    $*
  " 2>&1 | tee "$LOG"
}

case "$CMD" in
  gen)
    run_in_proot "dart run build_runner build --delete-conflicting-outputs"
    ;;
  analyze)
    # Per-directory parallel analyze (fast); assumes `gen` already ran.
    run_in_proot "
      : > /data/data/com.termux/files/home/az.log
      for d in lib/core lib/features/*/; do
        out=\$(dart analyze \"\$d\" 2>&1); code=\$?
        echo \"### \$d (exit=\$code)\" >> /data/data/com.termux/files/home/az.log
        echo \"\$out\" >> /data/data/com.termux/files/home/az.log
      done
      echo ALL_DONE >> /data/data/com.termux/files/home/az.log
    "
    echo "=== errors (CI-blocking) ==="
    grep -E 'error -' /data/data/com.termux/files/home/az.log || echo "NONE"
    ;;
  analyze-all)
    run_in_proot "dart analyze"
    ;;
  *)
    run_in_proot "flutter $CMD $*"
    ;;
esac
