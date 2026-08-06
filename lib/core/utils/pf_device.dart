import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// ────────────────────────────────────────────────────────────────────────────
/// ProfileForge Device Utilities — Platform and device helpers.
/// ────────────────────────────────────────────────────────────────────────────
class PfDevice {
  PfDevice._();

  /// Check if running on Android.
  static bool get isAndroid => Platform.isAndroid;

  /// Check if running on iOS.
  static bool get isIOS => Platform.isIOS;

  /// Check if running on web.
  static bool get isWeb => kIsWeb;

  /// Check if running on desktop.
  static bool get isDesktop =>
      Platform.isWindows || Platform.isMacOS || Platform.isLinux;

  /// Check if running on mobile.
  static bool get isMobile => Platform.isAndroid || Platform.isIOS;

  /// Check if running in debug mode.
  static bool get isDebug => kDebugMode;

  /// Check if running in release mode.
  static bool get isRelease => kReleaseMode;

  /// Check if running in profile mode.
  static bool get isProfile => kProfileMode;

  /// Get platform name.
  static String get platformName {
    if (isAndroid) return 'Android';
    if (isIOS) return 'iOS';
    if (isWeb) return 'Web';
    if (Platform.isWindows) return 'Windows';
    if (Platform.isMacOS) return 'macOS';
    if (Platform.isLinux) return 'Linux';
    return 'Unknown';
  }

  /// Get screen size category.
  static ScreenSize screenSize(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width < 360) return ScreenSize.small;
    if (width < 600) return ScreenSize.medium;
    if (width < 900) return ScreenSize.large;
    return ScreenSize.extraLarge;
  }

  /// Check if device is a tablet.
  static bool isTablet(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final diagonal = (size.width * size.width + size.height * size.height);
    return diagonal > 1100 * 1100;
  }

  /// Get safe area padding.
  static EdgeInsets safePadding(BuildContext context) {
    return MediaQuery.of(context).padding;
  }

  /// Get bottom safe area.
  static double bottomSafeArea(BuildContext context) {
    return MediaQuery.of(context).padding.bottom;
  }

  /// Get top safe area.
  static double topSafeArea(BuildContext context) {
    return MediaQuery.of(context).padding.top;
  }

  /// Get keyboard height.
  static double keyboardHeight(BuildContext context) {
    return MediaQuery.of(context).viewInsets.bottom;
  }

  /// Check if keyboard is visible.
  static bool isKeyboardVisible(BuildContext context) {
    return MediaQuery.of(context).viewInsets.bottom > 0;
  }

  /// Get device pixel ratio.
  static double devicePixelRatio(BuildContext context) {
    return MediaQuery.of(context).devicePixelRatio;
  }

  /// Get text scale factor.
  static double textScaleFactor(BuildContext context) {
    return MediaQuery.of(context).textScaleFactor;
  }

  /// Get orientation.
  static Orientation orientation(BuildContext context) {
    return MediaQuery.of(context).orientation;
  }

  /// Check if landscape.
  static bool isLandscape(BuildContext context) {
    return orientation(context) == Orientation.landscape;
  }

  /// Check if portrait.
  static bool isPortrait(BuildContext context) {
    return orientation(context) == Orientation.portrait;
  }
}

enum ScreenSize { small, medium, large, extraLarge }
