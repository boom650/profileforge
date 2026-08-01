import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:profileforge/core/theme/app_theme.dart';

/// ────────────────────────────────────────────────────────────────────────────
/// ParallaxHeader — Sliver header that moves at 0.5x scroll speed.
/// Creates a premium depth effect on the home page.
/// ────────────────────────────────────────────────────────────────────────────
class ParallaxHeader extends StatelessWidget {
  final double scrollOffset;
  final Widget child;

  const ParallaxHeader({
    super.key,
    required this.scrollOffset,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return SliverPersistentHeader(
      pinned: false,
      delegate: _ParallaxDelegate(
        scrollOffset: scrollOffset,
        child: child,
      ),
    );
  }
}

class _ParallaxDelegate extends SliverPersistentHeaderDelegate {
  final double scrollOffset;
  final Widget child;

  _ParallaxDelegate({required this.scrollOffset, required this.child});

  @override
  double get minExtent => 0;
  @override
  double get maxExtent => 120;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    final parallaxOffset = shrinkOffset * 0.5;
    return Transform.translate(
      offset: Offset(0, -parallaxOffset),
      child: Opacity(
        opacity: (1 - shrinkOffset / maxExtent).clamp(0.0, 1.0),
        child: child,
      ),
    );
  }

  @override
  bool shouldRebuild(_ParallaxDelegate oldDelegate) =>
      oldDelegate.scrollOffset != scrollOffset;
}

/// ────────────────────────────────────────────────────────────────────────────
/// AnimatedBackground — Subtle animated gradient background.
/// Creates a living, breathing feel to the app.
/// ────────────────────────────────────────────────────────────────────────────
class AnimatedBackground extends StatefulWidget {
  final Widget child;

  const AnimatedBackground({super.key, required this.child});

  @override
  State<AnimatedBackground> createState() => _AnimatedBackgroundState();
}

class _AnimatedBackgroundState extends State<AnimatedBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final t = _controller.value;
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment(
                -0.5 + t * 0.3,
                -0.8 + t * 0.2,
              ),
              end: Alignment(
                0.5 - t * 0.3,
                0.8 - t * 0.2,
              ),
              colors: const [
                Palette.surface0,
                Palette.black,
                Palette.surface0,
              ],
            ),
          ),
          child: widget.child,
        );
      },
    );
  }
}

/// ────────────────────────────────────────────────────────────────────────────
/// FloatingOrbs — Ambient floating orbs for background depth.
/// Creates a premium, immersive atmosphere.
/// ────────────────────────────────────────────────────────────────────────────
class FloatingOrbs extends StatefulWidget {
  final int orbCount;

  const FloatingOrbs({super.key, this.orbCount = 3});

  @override
  State<FloatingOrbs> createState() => _FloatingOrbsState();
}

class _FloatingOrbsState extends State<FloatingOrbs>
    with TickerProviderStateMixin {
  late List<AnimationController> _controllers;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(widget.orbCount, (i) {
      return AnimationController(
        vsync: this,
        duration: Duration(seconds: 6 + i * 2),
      )..repeat();
    });
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
    final colors = [
      Palette.primary.withValues(alpha: 0.08),
      Palette.accent.withValues(alpha: 0.06),
      Palette.info.withValues(alpha: 0.05),
    ];

    return Stack(
      children: List.generate(widget.orbCount, (i) {
        return AnimatedBuilder(
          animation: _controllers[i],
          builder: (context, child) {
            final t = _controllers[i].value;
            final size = 150.0 + i * 50;
            final x = MediaQuery.of(context).size.width * (0.2 + i * 0.3) +
                math.sin(t * math.pi * 2) * 30;
            final y = MediaQuery.of(context).size.height * (0.3 + i * 0.2) +
                math.cos(t * math.pi * 2) * 20;

            return Positioned(
              left: x - size / 2,
              top: y - size / 2,
              child: Container(
                width: size,
                height: size,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      colors[i % colors.length],
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
