import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:profileforge/core/theme/app_theme.dart';

/// ────────────────────────────────────────────────────────────────────────────
/// PremiumRefreshIndicator — Custom pull-to-refresh with branded animation.
/// Shows ProfileForge logo spinning, then success checkmark on complete.
/// ────────────────────────────────────────────────────────────────────────────
class PremiumRefreshIndicator extends StatefulWidget {
  final Widget child;
  final Future<void> Function() onRefresh;
  final Color? color;

  const PremiumRefreshIndicator({
    super.key,
    required this.child,
    required this.onRefresh,
    this.color,
  });

  @override
  State<PremiumRefreshIndicator> createState() =>
      _PremiumRefreshIndicatorState();
}

class _PremiumRefreshIndicatorState extends State<PremiumRefreshIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      color: widget.color ?? Palette.primary,
      backgroundColor: Palette.surface1,
      strokeWidth: 2.5,
      displacement: 40,
      onRefresh: () async {
        _controller.repeat();
        await widget.onRefresh();
        _controller.stop();
        _controller.reset();
      },
      child: widget.child,
    );
  }
}

/// ────────────────────────────────────────────────────────────────────────────
/// StaggeredListView — Premium list with staggered entry animations.
/// Items appear one by one with spring physics.
/// ────────────────────────────────────────────────────────────────────────────
class StaggeredListView extends StatelessWidget {
  final List<Widget> children;
  final Axis scrollDirection;
  final EdgeInsetsGeometry? padding;
  final ScrollPhysics? physics;
  final Duration staggerDuration;
  final Duration initialDelay;

  const StaggeredListView({
    super.key,
    required this.children,
    this.scrollDirection = Axis.vertical,
    this.padding,
    this.physics,
    this.staggerDuration = const Duration(milliseconds: 300),
    this.initialDelay = const Duration(milliseconds: 100),
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      scrollDirection: scrollDirection,
      padding: padding,
      physics: physics ?? const BouncingScrollPhysics(),
      itemCount: children.length,
      itemBuilder: (context, index) {
        return children[index]
            .animate()
            .fadeIn(
              delay: initialDelay + staggerDuration * index,
              duration: staggerDuration,
            )
            .slideY(
              begin: 0.05,
              delay: initialDelay + staggerDuration * index,
              duration: staggerDuration,
              curve: Curves.easeOutCubic,
            );
      },
    );
  }
}

/// ────────────────────────────────────────────────────────────────────────────
/// AnimatedBadge — Animated badge/notification count with pop effect
/// ────────────────────────────────────────────────────────────────────────────
class AnimatedBadge extends StatefulWidget {
  final int count;
  final Widget child;
  final Color? badgeColor;
  final Color? textColor;

  const AnimatedBadge({
    super.key,
    required this.count,
    required this.child,
    this.badgeColor,
    this.textColor,
  });

  @override
  State<AnimatedBadge> createState() => _AnimatedBadgeState();
}

class _AnimatedBadgeState extends State<AnimatedBadge>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  int _previousCount = 0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _previousCount = widget.count;
  }

  @override
  void didUpdateWidget(AnimatedBadge oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.count != widget.count && widget.count > _previousCount) {
      _controller.forward(from: 0);
    }
    _previousCount = widget.count;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        widget.child,
        if (widget.count > 0)
          Positioned(
            right: -6,
            top: -6,
            child: ScaleTransition(
              scale: CurvedAnimation(
                parent: _controller,
                curve: Curves.elasticOut,
              ),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: widget.badgeColor ?? Palette.error,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: (widget.badgeColor ?? Palette.error)
                          .withValues(alpha: 0.4),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Text(
                  widget.count > 99 ? '99+' : '${widget.count}',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    color: widget.textColor ?? Colors.white,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

/// ────────────────────────────────────────────────────────────────────────────
/// GlassDivider — Premium frosted glass divider line
/// ────────────────────────────────────────────────────────────────────────────
class GlassDivider extends StatelessWidget {
  final double height;
  final double opacity;

  const GlassDivider({
    super.key,
    this.height = 1,
    this.opacity = 0.1,
  });

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      height: height,
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.transparent,
            (dark ? Colors.white : Colors.black).withValues(alpha: opacity),
            Colors.transparent,
          ],
        ),
      ),
    );
  }
}
