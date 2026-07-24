#!/data/data/com.termux/files/usr/bin/bash
# Setup Android SDK
set -e
export ANDROID_SDK_ROOT="$HOME/android-sdk"
export JAVA_HOME="/data/data/com.termux/files/usr/lib/jvm/java-17-openjdk"
export PATH="$JAVA_HOME/bin:$PATH"
SDKMANAGER="$ANDROID_SDK_ROOT/cmdline-tools/latest/bin/sdkmanager"

# Accept licenses non-interactively
echo "Accepting SDK licenses..."
echo "y" | "$SDKMANAGER" --licenses 2>&1 || true
echo "y" | "$SDKMANAGER" "platform-tools" 2>&1 || true
echo "y" | "$SDKMANAGER" "platforms;android-34" 2>&1 || true
echo "y" | "$SDKMANAGER" "build-tools;34.0.0" 2>&1 || true

echo "=== SDK Installed ==="
ls -la "$ANDROID_SDK_ROOT/platforms/" 2>/dev/null
ls -la "$ANDROID_SDK_ROOT/build-tools/" 2>/dev/null