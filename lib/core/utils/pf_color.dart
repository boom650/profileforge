import 'package:flutter/material.dart';

/// ────────────────────────────────────────────────────────────────────────────
/// ProfileForge Color Utilities — Color manipulation helpers.
/// ────────────────────────────────────────────────────────────────────────────
class PfColor {
  PfColor._();

  /// Parse hex string to Color.
  static Color fromHex(String hex) {
    hex = hex.replaceFirst('#', '');
    if (hex.length == 6) {
      hex = 'FF$hex';
    }
    return Color(int.parse(hex, radix: 16));
  }

  /// Convert Color to hex string.
  static String toHex(Color color, {bool withHash = true}) {
    final hex = color.value.toRadixString(16).substring(2).toUpperCase();
    return withHash ? '#$hex' : hex;
  }

  /// Mix two colors.
  static Color mix(Color a, Color b, {double amount = 0.5}) {
    return Color.lerp(a, b, amount)!;
  }

  /// Lighten a color.
  static Color lighten(Color color, {double amount = 0.1}) {
    final hsl = HSLColor.fromColor(color);
    final lightened = hsl.withLightness((hsl.lightness + amount).clamp(0, 1));
    return lightened.toColor();
  }

  /// Darken a color.
  static Color darken(Color color, {double amount = 0.1}) {
    final hsl = HSLColor.fromColor(color);
    final darkened = hsl.withLightness((hsl.lightness - amount).clamp(0, 1));
    return darkened.toColor();
  }

  /// Saturate a color.
  static Color saturate(Color color, {double amount = 0.1}) {
    final hsl = HSLColor.fromColor(color);
    final saturated = hsl.withSaturation((hsl.saturation + amount).clamp(0, 1));
    return saturated.toColor();
  }

  /// Desaturate a color.
  static Color desaturate(Color color, {double amount = 0.1}) {
    final hsl = HSLColor.fromColor(color);
    final desaturated = hsl.withSaturation((hsl.saturation - amount).clamp(0, 1));
    return desaturated.toColor();
  }

  /// Rotate hue of a color.
  static Color rotateHue(Color color, {double degrees = 180}) {
    final hsl = HSLColor.fromColor(color);
    final rotated = hsl.withHue((hsl.hue + degrees) % 360);
    return rotated.toColor();
  }

  /// Set alpha of a color.
  static Color withAlpha(Color color, double alpha) {
    return color.withValues(alpha: alpha);
  }

  /// Get contrasting text color (black or white).
  static Color contrastingTextColor(Color backgroundColor) {
    final luminance = backgroundColor.computeLuminance();
    return luminance > 0.5 ? Colors.black : Colors.white;
  }

  /// Check if color is light.
  static bool isLight(Color color) {
    return color.computeLuminance() > 0.5;
  }

  /// Check if color is dark.
  static bool isDark(Color color) {
    return color.computeLuminance() <= 0.5;
  }

  /// Convert Color to HSV.
  static HSVColor toHSV(Color color) {
    return HSVColor.fromColor(color);
  }

  /// Convert Color to HSL.
  static HSLColor toHSL(Color color) {
    return HSLColor.fromColor(color);
  }

  /// Generate a palette from a base color.
  static List<Color> palette(Color base, {int count = 5}) {
    final hsl = HSLColor.fromColor(base);
    final colors = <Color>[];

    for (int i = 0; i < count; i++) {
      final lightness = 0.2 + (0.6 * i / (count - 1));
      colors.add(hsl.withLightness(lightness).toColor());
    }

    return colors;
  }

  /// Generate complementary colors.
  static List<Color> complementary(Color base) {
    final hsl = HSLColor.fromColor(base);
    return [
      base,
      hsl.withHue((hsl.hue + 180) % 360).toColor(),
    ];
  }

  /// Generate analogous colors.
  static List<Color> analogous(Color base) {
    final hsl = HSLColor.fromColor(base);
    return [
      hsl.withHue((hsl.hue - 30) % 360).toColor(),
      base,
      hsl.withHue((hsl.hue + 30) % 360).toColor(),
    ];
  }

  /// Generate triadic colors.
  static List<Color> triadic(Color base) {
    final hsl = HSLColor.fromColor(base);
    return [
      base,
      hsl.withHue((hsl.hue + 120) % 360).toColor(),
      hsl.withHue((hsl.hue + 240) % 360).toColor(),
    ];
  }

  /// Create gradient between two colors.
  static LinearGradient gradient(Color a, Color b, {
    Alignment begin = Alignment.topLeft,
    Alignment end = Alignment.bottomRight,
  }) {
    return LinearGradient(
      begin: begin,
      end: end,
      colors: [a, b],
    );
  }

  /// Create radial gradient from a color.
  static RadialGradient radialGradient(Color center, Color edge, {
    double radius = 1.0,
  }) {
    return RadialGradient(
      radius: radius,
      colors: [center, edge],
    );
  }
}
