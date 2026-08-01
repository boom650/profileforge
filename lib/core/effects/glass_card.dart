import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:profileforge/core/theme/app_theme.dart';

/// ────────────────────────────────────────────────────────────────────────────
/// GlassCard — Premium frosted glass card with backdrop blur.
/// Used for cards, overlays, modals. The signature premium look.
/// ────────────────────────────────────────────────────────────────────────────
class GlassCard extends StatelessWidget {
  final Widget child;
  final double borderRadius;
  final double blur;
  final double opacity;
  final Color? borderColor;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final List<BoxShadow>? boxShadow;
  final Gradient? gradient;
  final VoidCallback? onTap;

  const GlassCard({
    super.key,
    required this.child,
    this.borderRadius = 20,
    this.blur = 20,
    this.opacity = 0.15,
    this.borderColor,
    this.padding,
    this.margin,
    this.boxShadow,
    this.gradient,
    this.onTap,
  });

  /// Standard dark glass card
  factory GlassCard.dark({
    Key? key,
    required Widget child,
    double borderRadius = 20,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    VoidCallback? onTap,
  }) {
    return GlassCard(
      key: key,
      borderRadius: borderRadius,
      opacity: 0.12,
      borderColor: Colors.white.withValues(alpha: 0.1),
      padding: padding,
      margin: margin,
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.2),
          blurRadius: 20,
          offset: const Offset(0, 8),
        ),
      ],
      onTap: onTap,
      child: child,
    );
  }

  /// Light glass card with subtle frosted effect
  factory GlassCard.light({
    Key? key,
    required Widget child,
    double borderRadius = 20,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    VoidCallback? onTap,
  }) {
    return GlassCard(
      key: key,
      borderRadius: borderRadius,
      opacity: 0.7,
      borderColor: Colors.white.withValues(alpha: 0.5),
      padding: padding,
      margin: margin,
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.05),
          blurRadius: 20,
          offset: const Offset(0, 4),
        ),
      ],
      onTap: onTap,
      child: child,
    );
  }

  /// Glass card with primary gradient accent
  factory GlassCard.primary({
    Key? key,
    required Widget child,
    double borderRadius = 20,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    VoidCallback? onTap,
  }) {
    return GlassCard(
      key: key,
      borderRadius: borderRadius,
      opacity: 0.15,
      borderColor: Palette.primary.withValues(alpha: 0.2),
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Palette.primary.withValues(alpha: 0.08),
          Palette.primary.withValues(alpha: 0.02),
        ],
      ),
      padding: padding,
      margin: margin,
      boxShadow: [
        BoxShadow(
          color: Palette.primary.withValues(alpha: 0.15),
          blurRadius: 20,
          offset: const Offset(0, 4),
        ),
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.05),
          blurRadius: 10,
          offset: const Offset(0, 2),
        ),
      ],
      onTap: onTap,
      child: child,
    );
  }

  /// Glass card with subtle noise texture
  factory GlassCard.textured({
    Key? key,
    required Widget child,
    double borderRadius = 20,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    VoidCallback? onTap,
  }) {
    return GlassCard(
      key: key,
      borderRadius: borderRadius,
      opacity: 0.1,
      borderColor: Colors.white.withValues(alpha: 0.08),
      padding: padding,
      margin: margin,
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.15),
          blurRadius: 15,
          offset: const Offset(0, 6),
        ),
      ],
      onTap: onTap,
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    final effectiveBorderColor = borderColor ??
        (dark
            ? Colors.white.withValues(alpha: 0.08)
            : Colors.black.withValues(alpha: 0.05));

    final card = ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
        child: Container(
          padding: padding ?? const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: dark
                ? Colors.white.withValues(alpha: opacity)
                : Colors.white.withValues(alpha: opacity + 0.5),
            borderRadius: BorderRadius.circular(borderRadius),
            border: Border.all(
              color: effectiveBorderColor,
              width: 0.5,
            ),
            gradient: gradient,
          ),
          child: child,
        ),
      ),
    );

    if (onTap != null) {
      return GestureDetector(
        onTap: onTap,
        child: Container(
          margin: margin,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(borderRadius),
            boxShadow: boxShadow,
          ),
          child: card,
        ),
      );
    }

    return Container(
      margin: margin,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: boxShadow,
      ),
      child: card,
    );
  }
}

/// ────────────────────────────────────────────────────────────────────────────
/// GlassAppBar — Premium app bar with blur background
/// ────────────────────────────────────────────────────────────────────────────
class GlassAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final Widget? leading;
  final Widget? trailing;
  final double blur;

  const GlassAppBar({
    super.key,
    required this.title,
    this.leading,
    this.trailing,
    this.blur = 20,
  });

  @override
  Size get preferredSize => const Size.fromHeight(60);

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
        child: Container(
          height: preferredSize.height,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: dark
                ? Palette.black.withValues(alpha: 0.7)
                : Colors.white.withValues(alpha: 0.7),
            border: Border(
              bottom: BorderSide(
                color: dark
                    ? Colors.white.withValues(alpha: 0.05)
                    : Colors.black.withValues(alpha: 0.05),
                width: 0.5,
              ),
            ),
          ),
          child: SafeArea(
            bottom: false,
            child: Row(
              children: [
                if (leading != null) ...[
                  leading!,
                  const SizedBox(width: 8),
                ],
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: dark ? Palette.textPrimary : Palette.textInverse,
                    ),
                  ),
                ),
                if (trailing != null) trailing!,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
