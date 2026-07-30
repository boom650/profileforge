import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:profileforge/core/theme/app_theme.dart';

/// ────────────────────────────────────────────────────────────────────────────
/// GlassCard — Glassmorphism card with backdrop blur.
/// Used for all card-based UI in the app.
/// ────────────────────────────────────────────────────────────────────────────
class GlassCard extends StatelessWidget {
  const GlassCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.margin,
    this.borderRadius = 20,
    this.opacity = 0.7,
    this.border,
    this.gradient,
    this.onTap,
  });

  final Widget child;
  final EdgeInsets padding;
  final EdgeInsets? margin;
  final double borderRadius;
  final double opacity;
  final Border? border;
  final Gradient? gradient;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final dark = isDark(context);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: margin,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(borderRadius),
          gradient: gradient ??
              LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: dark
                    ? [
                        Palette.surface1.withValues(alpha: opacity),
                        Palette.surface2.withValues(alpha: opacity * 0.8),
                      ]
                    : [
                        Colors.white.withValues(alpha: opacity),
                        Colors.white.withValues(alpha: opacity * 0.9),
                      ],
              ),
          border: border ??
              Border.all(
                color: dark
                    ? Palette.border.withValues(alpha: 0.5)
                    : const Color(0xFFE2E8F0).withValues(alpha: 0.5),
                width: 1,
              ),
          boxShadow: [
            BoxShadow(
              color: dark
                  ? Colors.black.withValues(alpha: 0.3)
                  : Colors.black.withValues(alpha: 0.05),
              blurRadius: 20,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(borderRadius),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Padding(
              padding: padding,
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}

/// ────────────────────────────────────────────────────────────────────────────
/// GradientButton — Primary CTA with gradient background.
/// ────────────────────────────────────────────────────────────────────────────
class GradientButton extends StatelessWidget {
  const GradientButton({
    super.key,
    required this.label,
    required this.onTap,
    this.icon,
    this.gradient = Palette.gradientPrimary,
    this.height = 56,
    this.borderRadius = 14,
    this.textStyle,
    this.enabled = true,
  });

  final String label;
  final VoidCallback? onTap;
  final IconData? icon;
  final Gradient gradient;
  final double height;
  final double borderRadius;
  final TextStyle? textStyle;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: enabled ? onTap : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        height: height,
        decoration: BoxDecoration(
          gradient: enabled ? gradient : null,
          color: enabled ? null : Palette.textTertiary.withValues(alpha: 0.3),
          borderRadius: BorderRadius.circular(borderRadius),
          boxShadow: enabled
              ? [
                  BoxShadow(
                    color: Palette.primary.withValues(alpha: 0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                Icon(icon, color: Colors.white, size: 20),
                const SizedBox(width: 8),
              ],
              Text(
                label,
                style: textStyle ??
                    const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.3,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// ────────────────────────────────────────────────────────────────────────────
/// XpRing — Animated circular progress ring for XP/level display.
/// ────────────────────────────────────────────────────────────────────────────
class XpRing extends StatelessWidget {
  const XpRing({
    super.key,
    required this.progress,
    this.size = 64,
    this.strokeWidth = 6,
    this.color = Palette.primary,
    this.centerTop,
    this.centerBottom,
    this.color2,
  });

  final double progress;
  final double size;
  final double strokeWidth;
  final Color color;
  final String? centerTop;
  final String? centerBottom;
  final Color? color2;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Background ring.
          SizedBox(
            width: size,
            height: size,
            child: CircularProgressIndicator(
              value: 1,
              strokeWidth: strokeWidth,
              color: color.withValues(alpha: 0.15),
            ),
          ),
          // Progress ring.
          SizedBox(
            width: size,
            height: size,
            child: CircularProgressIndicator(
              value: progress.clamp(0.0, 1.0),
              strokeWidth: strokeWidth,
              color: color2 ?? color,
              strokeCap: StrokeCap.round,
            ),
          ),
          // Center text.
          if (centerTop != null)
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  centerTop!,
                  style: TextStyle(
                    fontSize: size * 0.28,
                    fontWeight: FontWeight.w800,
                    color: color,
                    height: 1,
                  ),
                ),
                if (centerBottom != null)
                  Text(
                    centerBottom!,
                    style: TextStyle(
                      fontSize: size * 0.14,
                      fontWeight: FontWeight.w600,
                      color: color.withValues(alpha: 0.7),
                      height: 1,
                    ),
                  ),
              ],
            ),
        ],
      ),
    );
  }
}

/// ────────────────────────────────────────────────────────────────────────────
/// GradientBanner — Full-width gradient card for hero sections.
/// ────────────────────────────────────────────────────────────────────────────
class GradientBanner extends StatelessWidget {
  const GradientBanner({
    super.key,
    required this.child,
    this.gradient = Palette.gradientPrimary,
    this.padding = const EdgeInsets.all(20),
    this.borderRadius = 20,
  });

  final Widget child;
  final Gradient gradient;
  final EdgeInsets padding;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: padding,
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: [
          BoxShadow(
            color: Palette.primary.withValues(alpha: 0.25),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: child,
    );
  }
}

/// ────────────────────────────────────────────────────────────────────────────
/// SectionTitle — Consistent section headers.
/// ────────────────────────────────────────────────────────────────────────────
class SectionTitle extends StatelessWidget {
  const SectionTitle(this.text, {super.key, this.action});

  final String text;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Expanded(
            child: Text(
              text,
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          if (action != null) action!,
        ],
      ),
    );
  }
}

/// ────────────────────────────────────────────────────────────────────────────
/// SkeletonLoader — Shimmer placeholder for loading states.
/// ────────────────────────────────────────────────────────────────────────────
class SkeletonLoader extends StatelessWidget {
  const SkeletonLoader({
    super.key,
    this.width,
    this.height = 16,
    this.borderRadius = 8,
  });

  final double? width;
  final double height;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    final dark = isDark(context);
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: dark ? Palette.surface2 : const Color(0xFFE2E8F0),
        borderRadius: BorderRadius.circular(borderRadius),
      ),
    );
  }
}

/// ────────────────────────────────────────────────────────────────────────────
/// EmptyState — Illustration + message for empty lists.
/// ────────────────────────────────────────────────────────────────────────────
class EmptyState extends StatelessWidget {
  const EmptyState({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    this.actionLabel,
    this.onAction,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: Palette.primary.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 36, color: Palette.primary),
            ),
            const SizedBox(height: 20),
            Text(
              title,
              style: theme.textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.hintColor,
              ),
              textAlign: TextAlign.center,
            ),
            if (actionLabel != null) ...[
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: onAction,
                child: Text(actionLabel!),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
