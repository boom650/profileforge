import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:profileforge/core/theme/app_theme.dart';
import 'package:profileforge/core/widgets/animated_widgets.dart';

/// ────────────────────────────────────────────────────────────────────────────
/// LoadingStates — Skeleton screens and loading indicators.
///
/// Based on research:
/// - 12-uiux-animation-motion-design.md (smooth transitions)
/// - 12-uiux-dark-mode-responsive-mobile.md (consistent loading states)
/// ────────────────────────────────────────────────────────────────────────────

/// SkeletonBox — Animated placeholder box.
class SkeletonBox extends StatelessWidget {
  const SkeletonBox({
    super.key,
    this.width,
    this.height = 16,
    this.borderRadius = 8,
    this.margin,
  });

  final double? width;
  final double height;
  final double borderRadius;
  final EdgeInsets? margin;

  @override
  Widget build(BuildContext context) {
    final dark = isDark(context);

    return Shimmer(
      child: Container(
        width: width,
        height: height,
        margin: margin,
        decoration: BoxDecoration(
          color: dark ? Palette.surface2 : const Color(0xFFEDE3D6),
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
    );
  }
}

/// SkeletonCircle — Animated circular placeholder.
class SkeletonCircle extends StatelessWidget {
  const SkeletonCircle({
    super.key,
    required this.size,
    this.margin,
  });

  final double size;
  final EdgeInsets? margin;

  @override
  Widget build(BuildContext context) {
    final dark = isDark(context);

    return Shimmer(
      child: Container(
        width: size,
        height: size,
        margin: margin,
        decoration: BoxDecoration(
          color: dark ? Palette.surface2 : const Color(0xFFEDE3D6),
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}

/// SkeletonCard — Card-shaped skeleton.
class SkeletonCard extends StatelessWidget {
  const SkeletonCard({
    super.key,
    this.height = 120,
    this.margin,
  });

  final double height;
  final EdgeInsets? margin;

  @override
  Widget build(BuildContext context) {
    final dark = isDark(context);

    return Container(
      height: height,
      margin: margin,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: dark
            ? Palette.surface1.withValues(alpha: 0.5)
            : Colors.white.withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: dark ? Palette.border : const Color(0xFFEDE3D6),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SkeletonBox(width: 60, height: 12, borderRadius: 6),
          const SizedBox(height: 12),
          SkeletonBox(height: 14, borderRadius: 7),
          const SizedBox(height: 8),
          SkeletonBox(
            width: MediaQuery.of(context).size.width * 0.7,
            height: 14,
            borderRadius: 7,
          ),
          const Spacer(),
          SkeletonBox(
            width: MediaQuery.of(context).size.width * 0.5,
            height: 10,
            borderRadius: 5,
          ),
        ],
      ),
    );
  }
}

/// SkeletonList — List of skeleton items.
class SkeletonList extends StatelessWidget {
  const SkeletonList({
    super.key,
    this.itemCount = 5,
    this.itemHeight = 80,
    this.padding,
  });

  final int itemCount;
  final double itemHeight;
  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: padding,
      itemCount: itemCount,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: SkeletonCard(height: itemHeight),
        );
      },
    );
  }
}

/// HomeScreenSkeleton — Skeleton for the home screen.
class HomeScreenSkeleton extends StatelessWidget {
  const HomeScreenSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          const SizedBox(height: 60),
          Row(
            children: [
              SkeletonCircle(size: 48),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SkeletonBox(width: 120, height: 16),
                  const SizedBox(height: 6),
                  SkeletonBox(width: 80, height: 12),
                ],
              ),
              const Spacer(),
              SkeletonCircle(size: 40),
            ],
          ),
          const SizedBox(height: 24),

          // Progress ring
          Center(
            child: SkeletonCircle(size: 160),
          ),
          const SizedBox(height: 24),

          // Quick actions
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(4, (i) => SkeletonCard(height: 80, margin: EdgeInsets.zero)),
          ),
          const SizedBox(height: 24),

          // AI Recommendations
          SkeletonBox(width: 140, height: 18),
          const SizedBox(height: 12),
          SkeletonCard(height: 100),
          const SizedBox(height: 24),

          // Weekly heatmap
          SkeletonBox(width: 120, height: 18),
          const SizedBox(height: 12),
          SkeletonCard(height: 80),
        ],
      ),
    );
  }
}

/// ProfileScreenSkeleton — Skeleton for the profile screen.
class ProfileScreenSkeleton extends StatelessWidget {
  const ProfileScreenSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          const SizedBox(height: 60),
          // Avatar
          Center(child: SkeletonCircle(size: 100)),
          const SizedBox(height: 16),
          // Name
          Center(child: SkeletonBox(width: 150, height: 20)),
          const SizedBox(height: 8),
          // Score
          Center(child: SkeletonBox(width: 80, height: 14)),
          const SizedBox(height: 24),
          // Score ring
          Center(child: SkeletonCircle(size: 140)),
          const SizedBox(height: 24),
          // Components
          SkeletonBox(height: 16),
          const SizedBox(height: 12),
          ...List.generate(5, (i) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: SkeletonBox(height: 48, borderRadius: 12),
          )),
        ],
      ),
    );
  }
}

/// ChatScreenSkeleton — Skeleton for the chat screen.
class ChatScreenSkeleton extends StatelessWidget {
  const ChatScreenSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          const SizedBox(height: 60),
          // Messages
          ...List.generate(6, (i) {
            final isUser = i.isEven;
            return Align(
              alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
              child: Container(
                width: MediaQuery.of(context).size.width * (0.6 + (i % 3) * 0.1),
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isUser
                      ? Palette.primary.withValues(alpha: 0.1)
                      : isDark(context)
                          ? Palette.surface1
                          : Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SkeletonBox(height: 12),
                    const SizedBox(height: 8),
                    SkeletonBox(
                      width: MediaQuery.of(context).size.width * 0.4,
                      height: 12,
                    ),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}

/// LoadingOverlay — Full-screen loading overlay.
class LoadingOverlay extends StatelessWidget {
  const LoadingOverlay({
    super.key,
    this.message,
    this.showSpinner = true,
  });

  final String? message;
  final bool showSpinner;

  @override
  Widget build(BuildContext context) {
    final dark = isDark(context);

    return Container(
      color: dark
          ? Palette.black.withValues(alpha: 0.8)
          : Colors.white.withValues(alpha: 0.8),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (showSpinner)
              SizedBox(
                width: 48,
                height: 48,
                child: CircularProgressIndicator(
                  strokeWidth: 3,
                  valueColor: AlwaysStoppedAnimation(Palette.primary),
                ),
              ),
            if (message != null) ...[
              const SizedBox(height: 16),
              Text(
                message!,
                style: GoogleFonts.nunito(
                  fontSize: 14,
                  color: dark ? Palette.textPrimary : Palette.textInverse,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// InlineLoader — Small inline loading indicator.
class InlineLoader extends StatelessWidget {
  const InlineLoader({
    super.key,
    this.size = 20,
    this.color,
  });

  final double size;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CircularProgressIndicator(
        strokeWidth: 2,
        valueColor: AlwaysStoppedAnimation(color ?? Palette.primary),
      ),
    );
  }
}

/// DotPulse — Animated dots for "typing" indicator.
class DotPulse extends StatefulWidget {
  const DotPulse({
    super.key,
    this.dotSize = 8,
    this.spacing = 4,
    this.color,
  });

  final double dotSize;
  final double spacing;
  final Color? color;

  @override
  State<DotPulse> createState() => _DotPulseState();
}

class _DotPulseState extends State<DotPulse>
    with TickerProviderStateMixin {
  late List<AnimationController> _controllers;
  late List<Animation<double>> _animations;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(3, (i) {
      return AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 600),
      );
    });

    _animations = _controllers.map((c) {
      return Tween<double>(begin: 0.4, end: 1.0).animate(
        CurvedAnimation(parent: c, curve: Curves.easeInOut),
      );
    }).toList();

    // Stagger the animations
    for (int i = 0; i < 3; i++) {
      Future.delayed(Duration(milliseconds: i * 200), () {
        if (mounted) _controllers[i].repeat(reverse: true);
      });
    }
  }

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dark = isDark(context);
    final color = widget.color ?? (dark ? Palette.textSecondary : Palette.textTertiary);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(3, (i) {
        return AnimatedBuilder(
          animation: _animations[i],
          builder: (context, child) {
            return Container(
              width: widget.dotSize,
              height: widget.dotSize,
              margin: EdgeInsets.symmetric(horizontal: widget.spacing / 2),
              decoration: BoxDecoration(
                color: color.withValues(alpha: _animations[i].value),
                shape: BoxShape.circle,
              ),
            );
          },
        );
      }),
    );
  }
}

/// ProgressStep — Step indicator for multi-step flows.
class ProgressStep extends StatelessWidget {
  const ProgressStep({
    super.key,
    required this.currentStep,
    required this.totalSteps,
    this.height = 4,
    this.activeColor,
    this.inactiveColor,
  });

  final int currentStep;
  final int totalSteps;
  final double height;
  final Color? activeColor;
  final Color? inactiveColor;

  @override
  Widget build(BuildContext context) {
    final dark = isDark(context);
    final active = activeColor ?? Palette.primary;
    final inactive = inactiveColor ?? (dark ? Palette.surface2 : const Color(0xFFEDE3D6));

    return Row(
      children: List.generate(totalSteps, (i) {
        final isActive = i < currentStep;
        final isCurrent = i == currentStep;

        return Expanded(
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            height: height,
            margin: i < totalSteps - 1 ? const EdgeInsets.only(right: 4) : null,
            decoration: BoxDecoration(
              color: isActive
                  ? active
                  : isCurrent
                      ? active.withValues(alpha: 0.5)
                      : inactive,
              borderRadius: BorderRadius.circular(height / 2),
            ),
          ),
        );
      }),
    );
  }
}
