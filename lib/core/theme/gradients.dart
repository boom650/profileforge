import 'package:flutter/material.dart';

/// ────────────────────────────────────────────────────────────────────────────
/// ProfileForge Gradients — Premium gradient backgrounds.
///
/// All gradients follow the Lusion-inspired dark/glass aesthetic.
/// Use with Container's gradient property or as backgrounds.
/// ────────────────────────────────────────────────────────────────────────────

class PfGradients {
  PfGradients._();

  // ════════════════════════════════════════════════════════════════════════════
  // PAGE BACKGROUNDS
  // ════════════════════════════════════════════════════════════════════════════

  /// Standard dark page background.
  static const LinearGradient darkPage = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xFF0B1120),
      Color(0xFF0F172A),
      Color(0xFF000000),
    ],
  );

  /// Standard light page background.
  static const LinearGradient lightPage = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xFFEEF2FF),
      Color(0xFFF8FAFC),
      Colors.white,
    ],
  );

  /// Deep space gradient — for hero sections.
  static const LinearGradient deepSpace = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF0B1120),
      Color(0xFF1E1B4B),
      Color(0xFF0F172A),
    ],
  );

  /// Ocean depth gradient.
  static const LinearGradient oceanDepth = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xFF0B1120),
      Color(0xFF0C4A6E),
      Color(0xFF0B1120),
    ],
  );

  /// Sunset gradient.
  static const LinearGradient sunset = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF7C3AED),
      Color(0xFFEC4899),
      Color(0xFFF97316),
    ],
  );

  // ════════════════════════════════════════════════════════════════════════════
  // COMPONENT GRADIENTS
  // ════════════════════════════════════════════════════════════════════════════

  /// Primary button/CTA gradient (violet → indigo).
  static const LinearGradient primary = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF7C3AED),
      Color(0xFF4F46E5),
    ],
  );

  /// Secondary button gradient.
  static const LinearGradient secondary = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF1E1B4B),
      Color(0xFF312E81),
    ],
  );

  /// Success gradient.
  static const LinearGradient success = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF059669),
      Color(0xFF10B981),
    ],
  );

  /// Warning gradient.
  static const LinearGradient warning = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFFD97706),
      Color(0xFFF59E0B),
    ],
  );

  /// Error gradient.
  static const LinearGradient error = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFFDC2626),
      Color(0xFFEF4444),
    ],
  );

  /// Info gradient.
  static const LinearGradient info = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF2563EB),
      Color(0xFF3B82F6),
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
        colors: [Color(0xFF059669), Color(0xFF10B981)],
      );
    }
    if (score >= 60) {
      return const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFFD97706), Color(0xFFF59E0B)],
      );
    }
    return const LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [Color(0xFFDC2626), Color(0xFFEF4444)],
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
