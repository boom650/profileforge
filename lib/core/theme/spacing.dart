import 'package:flutter/material.dart';

/// ────────────────────────────────────────────────────────────────────────────
/// ProfileForge Spacing — Consistent spacing system.
/// ────────────────────────────────────────────────────────────────────────────

class PfSpacing {
  PfSpacing._();

  // ════════════════════════════════════════════════════════════════════════════
  // BASE SPACING (4px grid)
  // ════════════════════════════════════════════════════════════════════════════

  static const double xxxs = 2;
  static const double xxs = 4;
  static const double xs = 8;
  static const double sm = 12;
  static const double md = 16;
  static const double lg = 20;
  static const double xl = 24;
  static const double xxl = 32;
  static const double xxxl = 40;
  static const double xxxxl = 48;
  static const double xxxxxl = 64;
  static const double xxxxxxl = 80;
  static const double xxxxxxxl = 96;

  // ════════════════════════════════════════════════════════════════════════════
  // PRESETS
  // ════════════════════════════════════════════════════════════════════════════

  /// Zero spacing.
  static const EdgeInsets zero = EdgeInsets.zero;

  /// Extra small padding (4px all sides).
  static const EdgeInsets paddingXs = EdgeInsets.all(xs);

  /// Small padding (8px all sides).
  static const EdgeInsets paddingSm = EdgeInsets.all(sm);

  /// Medium padding (16px all sides).
  static const EdgeInsets paddingMd = EdgeInsets.all(md);

  /// Large padding (20px all sides).
  static const EdgeInsets paddingLg = EdgeInsets.all(lg);

  /// Extra large padding (24px all sides).
  static const EdgeInsets paddingXl = EdgeInsets.all(xl);

  /// Double extra large padding (32px all sides).
  static const EdgeInsets paddingXxl = EdgeInsets.all(xxl);

  /// Page horizontal padding (20px left/right).
  static const EdgeInsets pageHorizontal = EdgeInsets.symmetric(horizontal: lg);

  /// Card padding (16px all sides).
  static const EdgeInsets cardPadding = EdgeInsets.all(md);

  /// Section padding (20px top/bottom, 16px left/right).
  static const EdgeInsets sectionPadding = EdgeInsets.symmetric(
    horizontal: md,
    vertical: lg,
  );

  // ════════════════════════════════════════════════════════════════════════════
  // MARGINS
  // ════════════════════════════════════════════════════════════════════════════

  /// Card margin (bottom spacing between cards).
  static const EdgeInsets cardMargin = EdgeInsets.only(bottom: sm);

  /// Section margin (vertical spacing between sections).
  static const EdgeInsets sectionMargin = EdgeInsets.only(bottom: xl);

  /// List item margin.
  static const EdgeInsets listItemMargin = EdgeInsets.only(bottom: xs);

  // ════════════════════════════════════════════════════════════════════════════
  // SIZED BOXES (for quick spacing)
  // ════════════════════════════════════════════════════════════════════════════

  static const SizedBox heightXxs = SizedBox(height: xxs);
  static const SizedBox heightXs = SizedBox(height: xs);
  static const SizedBox heightSm = SizedBox(height: sm);
  static const SizedBox heightMd = SizedBox(height: md);
  static const SizedBox heightLg = SizedBox(height: lg);
  static const SizedBox heightXl = SizedBox(height: xl);
  static const SizedBox heightXxl = SizedBox(height: xxl);
  static const SizedBox heightXxxl = SizedBox(height: xxxl);

  static const SizedBox widthXxs = SizedBox(width: xxs);
  static const SizedBox widthXs = SizedBox(width: xs);
  static const SizedBox widthSm = SizedBox(width: sm);
  static const SizedBox widthMd = SizedBox(width: md);
  static const SizedBox widthLg = SizedBox(width: lg);
  static const SizedBox widthXl = SizedBox(width: xl);
  static const SizedBox widthXxl = SizedBox(width: xxl);

  // ════════════════════════════════════════════════════════════════════════════
  // BORDER RADIUS
  // ════════════════════════════════════════════════════════════════════════════

  static const double radiusXs = 4;
  static const double radiusSm = 8;
  static const double radiusMd = 12;
  static const double radiusLg = 16;
  static const double radiusXl = 20;
  static const double radiusXxl = 24;
  static const double radiusRound = 999;

  static BorderRadius borderRadiusXs = BorderRadius.circular(radiusXs);
  static BorderRadius borderRadiusSm = BorderRadius.circular(radiusSm);
  static BorderRadius borderRadiusMd = BorderRadius.circular(radiusMd);
  static BorderRadius borderRadiusLg = BorderRadius.circular(radiusLg);
  static BorderRadius borderRadiusXl = BorderRadius.circular(radiusXl);
  static BorderRadius borderRadiusXxl = BorderRadius.circular(radiusXxl);
  static BorderRadius borderRadiusRound = BorderRadius.circular(radiusRound);

  // ════════════════════════════════════════════════════════════════════════════
  // COMMON PADDINGS
  // ════════════════════════════════════════════════════════════════════════════

  static const EdgeInsets screenPadding = EdgeInsets.symmetric(
    horizontal: lg,
    vertical: md,
  );

  static const EdgeInsets inputPadding = EdgeInsets.symmetric(
    horizontal: md,
    vertical: sm,
  );

  static const EdgeInsets buttonPadding = EdgeInsets.symmetric(
    horizontal: xl,
    vertical: sm,
  );

  static const EdgeInsets chipPadding = EdgeInsets.symmetric(
    horizontal: sm,
    vertical: xs,
  );
}
