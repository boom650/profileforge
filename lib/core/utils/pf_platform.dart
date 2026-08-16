import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// ────────────────────────────────────────────────────────────────────────────
/// ProfileForge Platform Utilities — System-level helpers.
/// ────────────────────────────────────────────────────────────────────────────
class PfPlatform {
  PfPlatform._();

  /// Set status bar style.
  static void setStatusBarStyle(Brightness brightness) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarBrightness: brightness,
        statusBarIconBrightness: brightness,
      ),
    );
  }

  /// Set dark status bar.
  static void setDarkStatusBar() {
    setStatusBarStyle(Brightness.dark);
  }

  /// Set light status bar.
  static void setLightStatusBar() {
    setStatusBarStyle(Brightness.light);
  }

  /// Set full screen mode.
  static void setFullScreen() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  }

  /// Set immersive mode.
  static void setImmersive() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  }

  /// Restore system UI.
  static void restoreSystemUI() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  }

  /// Set preferred orientations.
  static void setPortraitOnly() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  /// Set landscape only.
  static void setLandscapeOnly() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }

  /// Allow all orientations.
  static void setAllOrientations() {
    SystemChrome.setPreferredOrientations(DeviceOrientation.values);
  }

  /// Copy text to clipboard.
  static Future<void> copyToClipboard(String text) async {
    await Clipboard.setData(ClipboardData(text: text));
  }

  /// Paste text from clipboard.
  static Future<String?> pasteFromClipboard() async {
    final data = await Clipboard.getData(Clipboard.kTextPlain);
    return data?.text;
  }

  /// Check if clipboard has text.
  static Future<bool> clipboardHasText() async {
    final data = await Clipboard.getData(Clipboard.kTextPlain);
    return data?.text != null && data!.text!.isNotEmpty;
  }

  /// Show keyboard.
  static void showKeyboard() {
    SystemChannels.textInput.invokeMethod('TextInput.show');
  }

  /// Hide keyboard.
  static void hideKeyboard() {
    SystemChannels.textInput.invokeMethod('TextInput.hide');
  }

  /// Set app theme mode.
  static void setThemeMode(ThemeMode mode) {
    // Handled by the theme provider
  }

  /// Prevent screen from turning off.
  static void preventScreenOff() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  }

  /// Allow screen to turn off.
  static void allowScreenOff() {
    // Default behavior
  }

  /// Set system overlay style for dark theme.
  static void setDarkOverlay() {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarColor: Color(0xFF1A0F0A),
        systemNavigationBarIconBrightness: Brightness.light,
      ),
    );
  }

  /// Set system overlay style for light theme.
  static void setLightOverlay() {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: Colors.white,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
    );
  }
}
