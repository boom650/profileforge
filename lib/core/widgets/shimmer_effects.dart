import 'package:flutter/material.dart';
import 'package:profileforge/core/theme/app_theme.dart';

/// ────────────────────────────────────────────────────────────────────────────
/// ShimmerEffect — Premium shimmer loading effects.
/// ────────────────────────────────────────────────────────────────────────────

/// ShimmerContainer — Animated shimmer effect container.
class ShimmerContainer extends StatefulWidget {
  const ShimmerContainer({
    super.key,
    required this.child,
    this.baseColor,
    this.highlightColor,
    this.enabled = true,
  });

  final Widget child;
  final Color? baseColor;
  final Color? highlightColor;
  final bool enabled;

  @override
  State<ShimmerContainer> createState() => _ShimmerContainerState();
}

class _ShimmerContainerState extends State<ShimmerContainer>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();
    _animation = Tween<double>(begin: -1, end: 2).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.enabled) return widget.child;

    final dark = isDark(context);
    final baseColor = widget.baseColor ??
        (dark ? Palette.surface2 : const Color(0xFFF1F5F9));
    final highlightColor = widget.highlightColor ??
        (dark ? Palette.surface1 : Colors.white);

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return ShaderMask(
          blendMode: BlendMode.srcATop,
          shaderCallback: (bounds) {
            return LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [baseColor, highlightColor, baseColor],
              stops: [
                (_animation.value - 0.3).clamp(0.0, 1.0),
                _animation.value.clamp(0.0, 1.0),
                (_animation.value + 0.3).clamp(0.0, 1.0),
              ],
            ).createShader(bounds);
          },
          child: widget.child,
        );
      },
    );
  }
}

/// ShimmerText — Shimmer text placeholder.
class ShimmerText extends StatelessWidget {
  const ShimmerText({
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
    return ShimmerContainer(
      child: Container(
        width: width ?? double.infinity,
        height: height,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
    );
  }
}

/// ShimmerCircle — Shimmer circular placeholder.
class ShimmerCircle extends StatelessWidget {
  const ShimmerCircle({super.key, this.size = 48});

  final double size;

  @override
  Widget build(BuildContext context) {
    return ShimmerContainer(
      child: Container(
        width: size,
        height: size,
        decoration: const BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}

/// ShimmerCard — Shimmer card placeholder.
class ShimmerCard extends StatelessWidget {
  const ShimmerCard({
    super.key,
    this.height = 120,
    this.borderRadius = 16,
  });

  final double height;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    final dark = isDark(context);

    return ShimmerContainer(
      child: Container(
        height: height,
        decoration: BoxDecoration(
          color: dark ? Palette.surface2 : const Color(0xFFF1F5F9),
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const ShimmerCircle(size: 40),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ShimmerText(width: 120, height: 14),
                      const SizedBox(height: 6),
                      ShimmerText(width: 80, height: 10),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ShimmerText(height: 10),
            const SizedBox(height: 8),
            ShimmerText(width: 200, height: 10),
          ],
        ),
      ),
    );
  }
}

/// ShimmerList — Shimmer list placeholder.
class ShimmerList extends StatelessWidget {
  const ShimmerList({
    super.key,
    this.itemCount = 5,
    this.itemHeight = 72,
    this.itemSpacing = 8,
  });

  final int itemCount;
  final double itemHeight;
  final double itemSpacing;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(itemCount, (i) {
        return Padding(
          padding: EdgeInsets.only(bottom: i < itemCount - 1 ? itemSpacing : 0),
          child: ShimmerCard(height: itemHeight),
        );
      }),
    );
  }
}

/// ShimmerScoreCard — Score-specific shimmer.
class ShimmerScoreCard extends StatelessWidget {
  const ShimmerScoreCard({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = isDark(context);

    return ShimmerContainer(
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: dark ? Palette.surface2 : const Color(0xFFF1F5F9),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          children: [
            const ShimmerCircle(size: 100),
            const SizedBox(height: 16),
            ShimmerText(width: 150, height: 20),
            const SizedBox(height: 8),
            ShimmerText(width: 100, height: 14),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(3, (_) {
                return Column(
                  children: [
                    const ShimmerCircle(size: 32),
                    const SizedBox(height: 8),
                    ShimmerText(width: 60, height: 10),
                  ],
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
