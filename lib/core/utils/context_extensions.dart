import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:profileforge/core/theme/app_theme.dart';

/// ────────────────────────────────────────────────────────────────────────────
/// ProfileForge Context Extensions — Handy context shortcuts.
/// ────────────────────────────────────────────────────────────────────────────
extension BuildContextExtensions on BuildContext {
  /// Get theme data.
  ThemeData get theme => Theme.of(this);

  /// Get text theme.
  TextTheme get textTheme => Theme.of(this).textTheme;

  /// Get media query.
  MediaQueryData get mediaQuery => MediaQuery.of(this);

  /// Get screen size.
  Size get screenSize => mediaQuery.size;

  /// Get screen width.
  double get screenWidth => screenSize.width;

  /// Get screen height => screenSize.height;

  /// Get top padding (status bar).
  double get topPadding => mediaQuery.padding.top;

  /// Get bottom padding (safe area).
  double get bottomPadding => mediaQuery.padding.bottom;

  /// Get keyboard height.
  double get keyboardHeight => mediaQuery.viewInsets.bottom;

  /// Check if keyboard is visible.
  bool get isKeyboardVisible => keyboardHeight > 0;

  /// Check if dark mode.
  bool get isDarkMode => theme.brightness == Brightness.dark;

  /// Check if light mode.
  bool get isLightMode => theme.brightness == Brightness.light;

  /// Get color scheme.
  ColorScheme get colorScheme => theme.colorScheme;

  /// Pop the current route.
  void pop<T>([T? result]) => Navigator.of(this).pop(result);

  /// Push a named route.
  Future<T?> pushNamed<T>(String routeName, {Object? arguments}) {
    return Navigator.of(this).pushNamed<T>(routeName, arguments: arguments);
  }

  /// Push a replacement route.
  Future<T?> pushReplacementNamed<T>(String routeName, {Object? arguments}) {
    return Navigator.of(this).pushReplacementNamed<T, void>(
      routeName,
      arguments: arguments,
    );
  }

  /// Push and remove all routes.
  Future<T?> pushAndRemoveAll<T>(String routeName, {Object? arguments}) {
    return Navigator.of(this).pushNamedAndRemoveUntil<T>(
      routeName,
      (_) => false,
      arguments: arguments,
    );
  }

  /// Show a snackbar.
  void showSnackBar(String message, {Duration duration = const Duration(seconds: 3)}) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: duration,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  /// Show an error snackbar.
  void showErrorSnackBar(String message) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Palette.error,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  /// Show a success snackbar.
  void showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Palette.success,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  /// Show a bottom sheet.
  Future<T?> showBottomSheet<T>(Widget child) {
    return showModalBottomSheet<T>(
      context: this,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => child,
    );
  }

  /// Show an alert dialog.
  Future<bool?> showAlertDialog({
    required String title,
    required String content,
    String confirmText = 'OK',
    String? cancelText,
  }) {
    return showDialog<bool>(
      context: this,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          if (cancelText != null)
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text(cancelText),
            ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(confirmText),
          ),
        ],
      ),
    );
  }

  /// Focus the next field.
  void focusNext() {
    FocusScope.of(this).nextFocus();
  }

  /// Unfocus (dismiss keyboard).
  void unfocus() {
    FocusScope.of(this).unfocus();
  }

  /// Get text theme helper.
  TextStyle inter({
    double? fontSize,
    FontWeight? fontWeight,
    Color? color,
    double? height,
    letterSpacing,
  }) {
    return GoogleFonts.nunito(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      height: height,
      letterSpacing: letterSpacing,
    );
  }

  /// Get platform brightness.
  Brightness get platformBrightness => platformBrightnessOf(this);
}

/// Platform brightness helper.
Brightness platformBrightnessOf(BuildContext context) {
  return MediaQuery.platformBrightnessOf(context);
}
