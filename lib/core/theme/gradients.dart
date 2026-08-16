import 'package:flutter/material.dart';
import 'package:profileforge/core/theme/app_theme.dart';

/// ────────────────────────────────────────────────────────────────────────────
/// ProfileForge Gradients — Premium gradient backgrounds.
///
/// All gradients follow the Warm Bloom aesthetic.
/// Use with Container's gradient property or as backgrounds.
/// ────────────────────────────────────────────────────────────────────────────

class PfGradients {
  PfGradients._();

  // ════════════════════════════════════════════════════════════════════════════
  // PAGE BACKGROUNDS
  // ════════════════════════════════════════════════════════════════════════════

  /// Standard dark page background (warm espresso).
  static const LinearGradient darkPage = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Palette.surface0,
      Palette.surface1,
      Palette.black,
    ],
  );

  /// Standard light page background (warm cream).
  static const LinearGradient lightPage = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xFFFBF1E3),
      Palette.cream,
      Palette.creamCard,
    ],
  );

  /// Deep space gradient — for hero sections (warm cocoa).
  static const LinearGradient deepSpace = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Palette.surface0,
      Palette.surface2,
      Palette.black,
    ],
  );

  /// Ocean depth gradient (warm teal).
  static const LinearGradient oceanDepth = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Palette.surface0,
      Palette.accentTeal,
      Palette.surface0,
    ],
  );

  /// Sunset gradient (warm).
  static const LinearGradient sunset = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Palette.accentViolet,
      Palette.accentPink,
      Palette.accentOrange,
    ],
  );

  // ════════════════════════════════════════════════════════════════════════════
  // COMPONENT GRADIENTS
  // ════════════════════════════════════════════════════════════════════════════

  /// Primary button/CTA gradient (berry → amber).
  static const LinearGradient primary = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Palette.primary,
      Palette.accent,
    ],
  );

  /// Secondary button gradient (warm espresso).
  static const LinearGradient secondary = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Palette.surface2,
      Palette.surface3,
    ],
  );

  /// Success gradient (habit sage).
  static const LinearGradient success = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF3E8557),
      Palette.success,
    ],
  );

  /// Warning gradient (warm amber).
  static const LinearGradient warning = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFFD98B2B),
      Palette.warning,
    ],
  );

  /// Error gradient (tomato).
  static const LinearGradient error = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFFB93A3A),
      Palette.error,
    ],
  );

  /// Info gradient (warm sky).
  static const LinearGradient info = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF3D7FBF),
      Palette.info,
    ],
  );

  // ════════════════════════════════════════════════════════════════════════════
  // GLASS EFFECTS
  // ════════════════════════════════════════════════════════════════════════════

  /// Glass shimmer effect.
  static LinearGradient glassShimmer({
    double opacity = 0.05,
  }) {
    return LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        Colors.white.withValues(alpha: opacity),
        Colors.white.withValues(alpha: opacity * 0.5),
        Colors.white.withValues(alpha: opacity),
      ],
    );
  }

  /// Animated glow effect.
  static LinearGradient glow({
    required Color color,
    double opacity = 0.15,
  }) {
    return LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        color.withValues(alpha: opacity),
        color.withValues(alpha: opacity * 0.5),
        Colors.transparent,
      ],
    );
  }

  // ════════════════════════════════════════════════════════════════════════════
  // SCORE GRADIENTS
  // ════════════════════════════════════════════════════════════════════════════

  /// Score gradient based on value.
  static LinearGradient scoreGradient(int score) {
    if (score >= 80) return success;
    if (score >= 60) return warning;
    return error;
  }

  /// Score ring gradient.
  static LinearGradient scoreRing(int score) {
    if (score >= 80) {
      return const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFF3E8557), Color(0xFF4FA36B)],
      );
    }
    if (score >= 60) {
      return const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFFD98B2B), Color(0xFFF2A03D)],
      );
    }
    return const LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Color(0xFFB93A3A), Color(0xFFD64545)],
    );
  }

  // ════════════════════════════════════════════════════════════════════════════
  // UTILITY METHODS
  // ════════════════════════════════════════════════════════════════════════════

  /// Create a gradient between two colors.
  static LinearGradient between(Color a, Color b, {
    Alignment begin = Alignment.topLeft,
    Alignment end = Alignment.bottomRight,
  }) {
    return LinearGradient(
      begin: begin,
      end: end,
      colors: [a, b],
    );
  }

  /// Create a radial gradient from a center color.
  static RadialGradient radial({
    required Color center,
    required Color edge,
    Alignment alignment = Alignment.center,
    double radius = 1.0,
  }) {
    return RadialGradient(
      center: alignment,
      radius: radius,
      colors: [center, edge],
    );
  }

  /// Create a sweep gradient.
  static SweepGradient sweep({
    required Color start,
    required Color end,
    Alignment alignment = Alignment.center,
  }) {
    return SweepGradient(
      center: alignment,
      colors: [start, end, start],
    );
  }
}
