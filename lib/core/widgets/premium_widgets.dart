import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:profileforge/core/theme/app_theme.dart';
import 'package:profileforge/core/widgets/platypus.dart';

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
    this.borderRadius = Clay.card,
    this.opacity = 0.7,
    this.border,
    this.gradient,
    this.onTap,
  });

  final Widget child;
  final EdgeInsets padding;
  final EdgeInsets? margin;
  final BorderRadius borderRadius;
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
          borderRadius: borderRadius,
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
                        Palette.creamCard.withValues(alpha: opacity),
                        Palette.creamDeep.withValues(alpha: opacity * 0.9),
                      ],
              ),
          border: border ??
              Border.all(
                color: dark
                    ? Palette.border.withValues(alpha: 0.5)
                    : Palette.line.withValues(alpha: 0.6),
                width: 1,
              ),
          boxShadow: [
            dark ? Palette.clayShadowDark : Palette.clayShadow,
            Palette.clayHighlight,
          ],
        ),
        child: ClipRRect(
          borderRadius: borderRadius,
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
    this.borderRadius = Clay.pill,
    this.textStyle,
    this.enabled = true,
  });

  final String label;
  final VoidCallback? onTap;
  final IconData? icon;
  final Gradient gradient;
  final double height;
  final BorderRadius borderRadius;
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
          borderRadius: borderRadius,
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
                    fontWeight: FontWeight.w700,
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
    this.borderRadius = Clay.card,
  });

  final Widget child;
  final Gradient gradient;
  final EdgeInsets padding;
  final BorderRadius borderRadius;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: padding,
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: borderRadius,
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
/// GlassIconButton — Small glass icon button for actions.
/// ────────────────────────────────────────────────────────────────────────────
class GlassIconButton extends StatelessWidget {
  const GlassIconButton({
    super.key,
    required this.icon,
    required this.onTap,
    this.size = 44,
    this.color,
    this.semanticLabel,
  });

  final IconData icon;
  final VoidCallback? onTap;
  final double size;
  final Color? color;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final dark = isDark(context);
    return Semantics(
      button: true,
      label: semanticLabel,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: dark
                ? Palette.surface2.withValues(alpha: 0.7)
                : Colors.white.withValues(alpha: 0.8),
            borderRadius: BorderRadius.circular(9999),
            border: Border.all(
              color: dark
                  ? Palette.border.withValues(alpha: 0.5)
                  : const Color(0xFFEDE3D6).withValues(alpha: 0.5),
            ),
          ),
          child: Icon(
            icon,
            size: size * 0.5,
            color: color ?? (dark ? Palette.textPrimary : Palette.primary),
          ),
        ),
      ),
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
    this.borderRadius = const BorderRadius.all(Radius.circular(8)),
  });

  final double? width;
  final double height;
  final BorderRadius borderRadius;

  @override
  Widget build(BuildContext context) {
    final dark = isDark(context);
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: dark ? Palette.surface2 : const Color(0xFFEDE3D6),
        borderRadius: borderRadius,
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
            Percy(
              size: 88,
              semanticLabel: 'Percy the platypus',
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
