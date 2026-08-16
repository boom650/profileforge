import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter/services.dart';
import 'package:profileforge/core/theme/app_theme.dart';

/// ────────────────────────────────────────────────────────────────────────────
/// AccessibilityUtilities — WCAG 2.1 compliance helpers.
///
/// Based on research:
/// - 12-uiux-accessibility-inclusive-design.md
/// - WCAG 2.1 AA compliance requirements
/// - Touch-friendly sizing (48px minimum)
/// - Color contrast requirements (4.5:1 for normal text)
/// ────────────────────────────────────────────────────────────────────────────

/// ContrastChecker — Validates color contrast ratios.
class ContrastChecker {
  /// Calculate relative luminance of a color.
  static double _relativeLuminance(Color color) {
    final r = color.r;
    final g = color.g;
    final b = color.b;

    final rs = r <= 0.03928 ? r / 12.92 : pow((r + 0.055) / 1.055, 2.4);
    final gs = g <= 0.03928 ? g / 12.92 : pow((g + 0.055) / 1.055, 2.4);
    final bs = b <= 0.03928 ? b / 12.92 : pow((b + 0.055) / 1.055, 2.4);

    return 0.2126 * rs + 0.7152 * gs + 0.0722 * bs;
  }

  /// Calculate contrast ratio between two colors.
  static double contrastRatio(Color a, Color b) {
    final l1 = _relativeLuminance(a);
    final l2 = _relativeLuminance(b);
    final lighter = l1 > l2 ? l1 : l2;
    final darker = l1 > l2 ? l2 : l1;
    return (lighter + 0.05) / (darker + 0.05);
  }

  /// Check if contrast meets WCAG AA requirements.
  static bool meetsAA(Color foreground, Color background, {bool isLargeText = false}) {
    final ratio = contrastRatio(foreground, background);
    return isLargeText ? ratio >= 3.0 : ratio >= 4.5;
  }

  /// Check if contrast meets WCAG AAA requirements.
  static bool meetsAAA(Color foreground, Color background, {bool isLargeText = false}) {
    final ratio = contrastRatio(foreground, background);
    return isLargeText ? ratio >= 4.5 : ratio >= 7.0;
  }

  /// Get a color that meets contrast requirements.
  static Color ensureContrast(Color foreground, Color background, {bool isLargeText = false}) {
    if (meetsAA(foreground, background, isLargeText: isLargeText)) {
      return foreground;
    }

    // Darken or lighten to meet requirements
    final bgLuminance = _relativeLuminance(background);
    if (bgLuminance > 0.5) {
      // Dark background, lighten foreground
      return _adjustColor(foreground, background, true);
    } else {
      // Light background, darken foreground
      return _adjustColor(foreground, background, false);
    }
  }

  static Color _adjustColor(Color foreground, Color background, bool lighten) {
    var hsl = HSLColor.fromColor(foreground);
    for (int i = 0; i < 20; i++) {
      if (lighten) {
        hsl = hsl.withLightness((hsl.lightness + 0.05).clamp(0.0, 1.0));
      } else {
        hsl = hsl.withLightness((hsl.lightness - 0.05).clamp(0.0, 1.0));
      }
      if (meetsAA(hsl.toColor(), background)) {
        return hsl.toColor();
      }
    }
    return foreground;
  }
}

/// AccessibleText — Text with semantic labels.
class AccessibleText extends StatelessWidget {
  const AccessibleText({
    super.key,
    required this.text,
    this.style,
    this.semanticsLabel,
    this.semanticsHint,
    this.textDirection,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.isButton = false,
  });

  final String text;
  final TextStyle? style;
  final String? semanticsLabel;
  final String? semanticsHint;
  final TextDirection? textDirection;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;
  final bool isButton;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: semanticsLabel ?? text,
      hint: semanticsHint,
      button: isButton,
      child: Text(
        text,
        style: style,
        textDirection: textDirection,
        textAlign: textAlign,
        maxLines: maxLines,
        overflow: overflow,
      ),
    );
  }
}

/// AccessibleButton — Button with minimum touch target and semantics.
class AccessibleButton extends StatelessWidget {
  const AccessibleButton({
    super.key,
    required this.onTap,
    required this.child,
    this.semanticsLabel,
    this.semanticsHint,
    this.minimumSize = const Size(48, 48),
    this.padding,
  });

  final VoidCallback onTap;
  final Widget child;
  final String? semanticsLabel;
  final String? semanticsHint;
  final Size minimumSize;
  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: semanticsLabel,
      hint: semanticsHint,
      button: true,
      enabled: true,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minWidth: minimumSize.width,
          minHeight: minimumSize.height,
        ),
        child: GestureDetector(
          onTap: () {
            HapticFeedback.selectionClick();
            onTap();
          },
          behavior: HitTestBehavior.opaque,
          child: Padding(
            padding: padding ?? EdgeInsets.zero,
            child: child,
          ),
        ),
      ),
    );
  }
}

/// AccessibleIcon — Icon with semantic label.
class AccessibleIcon extends StatelessWidget {
  const AccessibleIcon({
    super.key,
    required this.icon,
    required this.semanticLabel,
    this.size = 24,
    this.color,
  });

  final IconData icon;
  final String semanticLabel;
  final double size;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: semanticLabel,
      child: Icon(icon, size: size, color: color),
    );
  }
}

/// AccessibleImage — Image with semantic description.
class AccessibleImage extends StatelessWidget {
  const AccessibleImage({
    super.key,
    required this.image,
    required this.semanticLabel,
    this.semanticHint,
    this.width,
    this.height,
    this.fit,
  });

  final ImageProvider image;
  final String semanticLabel;
  final String? semanticHint;
  final double? width;
  final double? height;
  final BoxFit? fit;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: semanticLabel,
      hint: semanticHint,
      image: true,
      child: Image(
        image: image,
        width: width,
        height: height,
        fit: fit,
        semanticLabel: semanticLabel,
      ),
    );
  }
}

/// AccessibleCard — Card with semantic role and focus support.
class AccessibleCard extends StatelessWidget {
  const AccessibleCard({
    super.key,
    required this.child,
    this.onTap,
    this.semanticsLabel,
    this.semanticsHint,
    this.padding,
  });

  final Widget child;
  final VoidCallback? onTap;
  final String? semanticsLabel;
  final String? semanticsHint;
  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: semanticsLabel,
      hint: semanticsHint,
      button: onTap != null,
      child: GestureDetector(
        onTap: onTap,
        child: Padding(
          padding: padding ?? EdgeInsets.zero,
          child: child,
        ),
      ),
    );
  }
}

/// FocusIndicator — Visual focus indicator for keyboard navigation.
class FocusIndicator extends StatefulWidget {
  const FocusIndicator({
    super.key,
    required this.child,
    this.focusColor,
    this.borderRadius,
  });

  final Widget child;
  final Color? focusColor;
  final BorderRadius? borderRadius;

  @override
  State<FocusIndicator> createState() => _FocusIndicatorState();
}

class _FocusIndicatorState extends State<FocusIndicator> {
  final FocusNode _focusNode = FocusNode();
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChange);
    _focusNode.dispose();
    super.dispose();
  }

  void _onFocusChange() {
    setState(() => _isFocused = _focusNode.hasFocus);
  }

  @override
  Widget build(BuildContext context) {
    final focusColor = widget.focusColor ?? Palette.primary;

    return Focus(
      focusNode: _focusNode,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          borderRadius: widget.borderRadius,
          border: _isFocused
              ? Border.all(color: focusColor, width: 2)
              : null,
        ),
        child: widget.child,
      ),
    );
  }
}

/// ScreenReaderAnnouncer — Announces messages to screen readers.
class ScreenReaderAnnouncer {
  static void announce(BuildContext context, String message, {SemanticsRole? role}) {
    SemanticsService.announce(message, TextDirection.ltr);
  }

  static void announceAndPlay(BuildContext context, String message) {
    SemanticsService.announce(message, TextDirection.ltr);
  }
}

/// ReduceMotion — Checks if user prefers reduced motion.
class ReduceMotion {
  static bool isReduceMotion(BuildContext context) {
    return MediaQuery.of(context).disableAnimations;
  }

  static Duration getAnimationDuration(BuildContext context, Duration defaultDuration) {
    if (isReduceMotion(context)) {
      return Duration.zero;
    }
    return defaultDuration;
  }
}

/// AccessibilityWrapper — Wraps child with common accessibility features.
class AccessibilityWrapper extends StatelessWidget {
  const AccessibilityWrapper({
    super.key,
    required this.child,
    this.semanticsLabel,
    this.semanticsHint,
    this.semanticsRole,
    this.excludeSemantics = false,
  });

  final Widget child;
  final String? semanticsLabel;
  final String? semanticsHint;
  final SemanticsRole? semanticsRole;
  final bool excludeSemantics;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: semanticsLabel,
      hint: semanticsHint,
      role: semanticsRole,
      explicitChildNodes: true,
      excludeSemantics: excludeSemantics,
      child: child,
    );
  }
}
