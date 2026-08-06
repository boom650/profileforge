import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:profileforge/core/theme/app_theme.dart';

/// ────────────────────────────────────────────────────────────────────────────
/// AnimatedCounter — Smoothly animated number counter.
///
/// Usage:
/// ```dart
/// AnimatedCounter(target: 82, duration: Duration(seconds: 2))
/// ```
/// ────────────────────────────────────────────────────────────────────────────
class AnimatedCounter extends StatefulWidget {
  const AnimatedCounter({
    super.key,
    required this.target,
    this.duration = const Duration(milliseconds: 1500),
    this.style,
    this.prefix = '',
    this.suffix = '',
    this.decimals = 0,
    this.curve = Curves.easeOutCubic,
  });

  final double target;
  final Duration duration;
  final TextStyle? style;
  final String prefix;
  final String suffix;
  final int decimals;
  final Curve curve;

  @override
  State<AnimatedCounter> createState() => _AnimatedCounterState();
}

class _AnimatedCounterState extends State<AnimatedCounter>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  late Tween<double> _tween;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);
    _tween = Tween<double>(begin: 0, end: widget.target);
    _animation = _tween.animate(CurvedAnimation(
      parent: _controller,
      curve: widget.curve,
    ));
    _controller.forward();
  }

  @override
  void didUpdateWidget(AnimatedCounter oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.target != widget.target) {
      _tween.begin = _animation.value;
      _tween.end = widget.target;
      _controller.reset();
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        final value = _animation.value;
        final displayValue =
            value.toStringAsFixed(widget.decimals);

        return Text(
          '$widget.prefix$displayValue$widget.suffix',
          style: widget.style ??
              GoogleFonts.inter(
                fontSize: 32,
                fontWeight: FontWeight.w800,
                color: Palette.textPrimary,
              ),
        );
      },
    );
  }
}

/// ScoreAnimatedCounter — Score with color and animation.
class ScoreAnimatedCounter extends StatefulWidget {
  const ScoreAnimatedCounter({
    super.key,
    required this.target,
    this.duration = const Duration(milliseconds: 1500),
    this.size = 64,
  });

  final int target;
  final Duration duration;
  final double size;

  @override
  State<ScoreAnimatedCounter> createState() => _ScoreAnimatedCounterState();
}

class _ScoreAnimatedCounterState extends State<ScoreAnimatedCounter>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);
    _animation = Tween<double>(begin: 0, end: widget.target.toDouble()).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
    );
    _controller.forward();
  }

  @override
  void didUpdateWidget(ScoreAnimatedCounter oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.target != widget.target) {
      _animation = Tween<double>(
        begin: _animation.value,
        end: widget.target.toDouble(),
      ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));
      _controller.reset();
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        final score = _animation.value.round();
        final color = _getScoreColor(score);

        return Text(
          '$score',
          style: GoogleFonts.inter(
            fontSize: widget.size,
            fontWeight: FontWeight.w900,
            color: color,
          ),
        );
      },
    );
  }

  Color _getScoreColor(int score) {
    if (score >= 80) return Palette.success;
    if (score >= 60) return Palette.warning;
    return Palette.error;
  }
}

/// RollingDigit — Single digit with rolling animation.
class RollingDigit extends StatefulWidget {
  const RollingDigit({
    super.key,
    required this.digit,
    this.style,
  });

  final int digit;
  final TextStyle? style;

  @override
  State<RollingDigit> createState() => _RollingDigitState();
}

class _RollingDigitState extends State<RollingDigit>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  int _currentDigit = 0;

  @override
  void initState() {
    super.initState();
    _currentDigit = widget.digit;
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    );
  }

  @override
  void didUpdateWidget(RollingDigit oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.digit != widget.digit) {
      _currentDigit = oldWidget.digit;
      _controller.forward(from: 0).then((_) {
        setState(() => _currentDigit = widget.digit);
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Text(
          '$_currentDigit',
          style: widget.style,
        );
      },
    );
  }
}

/// PulsingNumber — Number with pulsing animation.
class PulsingNumber extends StatefulWidget {
  const PulsingNumber({
    super.key,
    required this.value,
    this.style,
    this.pulseColor,
  });

  final int value;
  final TextStyle? style;
  final Color? pulseColor;

  @override
  State<PulsingNumber> createState() => _PulsingNumberState();
}

class _PulsingNumberState extends State<PulsingNumber>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _scaleAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.3), weight: 40),
      TweenSequenceItem(tween: Tween(begin: 1.3, end: 1.0), weight: 60),
    ]).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
  }

  @override
  void didUpdateWidget(PulsingNumber oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) {
      _controller.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: Text(
        '${widget.value}',
        style: widget.style ??
            GoogleFonts.inter(
              fontSize: 24,
              fontWeight: FontWeight.w800,
              color: Palette.primary,
            ),
      ),
    );
  }
}
