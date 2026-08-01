import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter_tilt/flutter_tilt.dart';
import 'package:profileforge/core/theme/app_theme.dart';
import 'package:profileforge/core/widgets/magnetic_button.dart';

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
    return MagneticButton(
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
/// GlassIconButton — Small glass icon button for actions.
/// ────────────────────────────────────────────────────────────────────────────
class GlassIconButton extends StatelessWidget {
  const GlassIconButton({
    super.key,
    required this.icon,
    required this.onTap,
    this.size = 40,
    this.color,
  });

  final IconData icon;
  final VoidCallback? onTap;
  final double size;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final dark = isDark(context);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: dark
              ? Palette.surface2.withValues(alpha: 0.7)
              : Colors.white.withValues(alpha: 0.8),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: dark
                ? Palette.border.withValues(alpha: 0.5)
                : const Color(0xFFE2E8F0).withValues(alpha: 0.5),
          ),
        ),
        child: Icon(
          icon,
          size: size * 0.5,
          color: color ?? (dark ? Palette.textPrimary : Palette.primary),
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

/// ────────────────────────────────────────────────────────────────────────────
/// ShimmerSkeleton — Loading placeholder with shimmer effect.
/// Use instead of CircularProgressIndicator for premium feel.
/// ────────────────────────────────────────────────────────────────────────────
class ShimmerSkeleton extends StatelessWidget {
  const ShimmerSkeleton({
    super.key,
    required this.child,
    this.baseColor,
    this.highlightColor,
  });

  final Widget child;
  final Color? baseColor;
  final Color? highlightColor;

  @override
  Widget build(BuildContext context) {
    final dark = isDark(context);
    return Shimmer.fromColors(
      baseColor: baseColor ??
          (dark ? Palette.surface1 : const Color(0xFFE2E8F0)),
      highlightColor: highlightColor ??
          (dark ? Palette.surface2 : const Color(0xFFF1F5F9)),
      child: child,
    );
  }
}

/// ────────────────────────────────────────────────────────────────────────────
/// ProfileSkeleton — Shimmer loading placeholder for profile page.
/// ────────────────────────────────────────────────────────────────────────────
class ProfileSkeleton extends StatelessWidget {
  const ProfileSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return ShimmerSkeleton(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Avatar circle
            Container(
              width: 80,
              height: 80,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(height: 16),
            // Name bar
            Container(
              width: 120,
              height: 16,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            const SizedBox(height: 8),
            // Email bar
            Container(
              width: 180,
              height: 12,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(6),
              ),
            ),
            const SizedBox(height: 24),
            // Stats row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(
                3,
                (_) => Container(
                  width: 60,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            // Bio lines
            ...List.generate(
              3,
              (i) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Container(
                  width: double.infinity,
                  height: 12,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// ────────────────────────────────────────────────────────────────────────────
/// MissionListSkeleton — Shimmer loading for mission list.
/// ────────────────────────────────────────────────────────────────────────────
class MissionListSkeleton extends StatelessWidget {
  const MissionListSkeleton({super.key, this.itemCount = 4});

  final int itemCount;

  @override
  Widget build(BuildContext context) {
    return ShimmerSkeleton(
      child: Column(
        children: List.generate(
          itemCount,
          (_) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Container(
              height: 72,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// ────────────────────────────────────────────────────────────────────────────
/// StreakSkeleton — Shimmer loading for streak card.
/// ────────────────────────────────────────────────────────────────────────────
class StreakSkeleton extends StatelessWidget {
  const StreakSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return ShimmerSkeleton(
      child: Container(
        height: 100,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    );
  }
}

/// ────────────────────────────────────────────────────────────────────────────
/// LottieAnimation — Premium Lottie animation wrapper.
/// Plays animation once or loops. Used for onboarding, success, celebrations.
/// ────────────────────────────────────────────────────────────────────────────
class LottieAnimation extends StatelessWidget {
  const LottieAnimation({
    super.key,
    required this.asset,
    this.width,
    this.height,
    this.repeat = false,
    this.onComplete,
  });

  final String asset;
  final double? width;
  final double? height;
  final bool repeat;
  final VoidCallback? onComplete;

  @override
  Widget build(BuildContext context) {
    return Lottie.asset(
      asset,
      width: width,
      height: height,
      repeat: repeat,
      onLoaded: onComplete != null
          ? (composition) {
              Future.delayed(composition.duration, onComplete);
            }
          : null,
    );
  }
}

/// ────────────────────────────────────────────────────────────────────────────
/// CelebrationLottie — Lottie confetti/trophy animation for celebrations.
/// ────────────────────────────────────────────────────────────────────────────
class CelebrationLottie extends StatelessWidget {
  const CelebrationLottie({
    super.key,
    this.type = CelebrationType.checkmark,
    this.size = 120,
    this.onComplete,
  });

  final CelebrationType type;
  final double size;
  final VoidCallback? onComplete;

  String get _asset {
    switch (type) {
      case CelebrationType.checkmark:
        return 'assets/lottie/checkmark.json';
      case CelebrationType.confetti:
        return 'assets/lottie/confetti.json';
      case CelebrationType.trophy:
        return 'assets/lottie/trophy.json';
    }
  }

  @override
  Widget build(BuildContext context) {
    return LottieAnimation(
      asset: _asset,
      width: size,
      height: size,
      onComplete: onComplete,
    );
  }
}

enum CelebrationType {
  checkmark,
  confetti,
  trophy,
}

/// ────────────────────────────────────────────────────────────────────────────
/// TiltCard — Gyroscope-driven tilt/parallax effect for cards.
/// Uses flutter_tilt for premium depth feel on profile/streak cards.
/// ────────────────────────────────────────────────────────────────────────────
class TiltCard extends StatelessWidget {
  const TiltCard({
    super.key,
    required this.child,
    this.borderRadius = 20,
    this倾斜Intensity = 10,
  });

  final Widget child;
  final double borderRadius;
  final double 倾斜Intensity;

  @override
  Widget build(BuildContext context) {
    return Tilt(
      borderRadius: BorderRadius.circular(borderRadius),
      tiltConfig: const TiltConfig(
        angle: 10,
        tiltCurve: Curves.easeOutCubic,
        disable: [],
      ),
      lightConfig: LightConfig(
        color: Palette.primaryGlow,
        opacityMax: 0.15,
      ),
      shadowConfig: ShadowConfig(
        color: Colors.black,
        opacityMax: 0.3,
      ),
      child: child,
    );
  }
}

/// ────────────────────────────────────────────────────────────────────────────
/// TiltGlassCard — Tilt effect + glassmorphism combined.
/// Premium card for profile, streak, hero sections.
/// ────────────────────────────────────────────────────────────────────────────
class TiltGlassCard extends StatelessWidget {
  const TiltGlassCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(16),
    this.margin,
    this.borderRadius = 20,
  });

  final Widget child;
  final EdgeInsets padding;
  final EdgeInsets? margin;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    return TiltCard(
      borderRadius: borderRadius,
      child: GlassCard(
        padding: padding,
        margin: margin,
        borderRadius: borderRadius,
        child: child,
      ),
    );
  }
}

/// ────────────────────────────────────────────────────────────────────────────
/// AnimatedNumber — Animated counter that rolls up/down when value changes.
/// Used for XP, level, streak displays.
/// ────────────────────────────────────────────────────────────────────────────
class AnimatedNumber extends StatelessWidget {
  const AnimatedNumber({
    super.key,
    required this.value,
    this.style,
    this.duration = const Duration(milliseconds: 600),
    this.curve = Curves.easeOutCubic,
    this.prefix = '',
    this.suffix = '',
  });

  final int value;
  final TextStyle? style;
  final Duration duration;
  final Curve curve;
  final String prefix;
  final String suffix;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<int>(
      tween: Tween(begin: value, end: value),
      duration: duration,
      curve: curve,
      builder: (_, v, __) => Text(
        '$prefix$v$suffix',
        style: style,
      ),
    );
  }
}

/// ────────────────────────────────────────────────────────────────────────────
/// AnimatedXp — Animated XP counter with roll effect.
/// ────────────────────────────────────────────────────────────────────────────
class AnimatedXp extends StatelessWidget {
  const AnimatedXp({
    super.key,
    required this.xp,
    this.style,
  });

  final int xp;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: xp.toDouble(), end: xp.toDouble()),
      duration: 600.ms,
      curve: Curves.easeOutCubic,
      builder: (_, v, __) => Text(
        '${v.toInt()} XP',
        style: style,
      ),
    );
  }
}
