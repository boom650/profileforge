import 'dart:math' as math;
import 'package:flutter/material.dart';

/// ────────────────────────────────────────────────────────────────────────────
/// AnimatedCounter — Smooth number counting animation.
/// Used for XP, gems, streaks, scores. Counts up with easing.
/// ────────────────────────────────────────────────────────────────────────────
class AnimatedCounter extends StatefulWidget {
  final int value;
  final TextStyle? style;
  final Duration duration;
  final String prefix;
  final String suffix;
  final bool showPlus;
  final Color? color;
  final bool animate;

  const AnimatedCounter({
    super.key,
    required this.value,
    this.style,
    this.duration = const Duration(milliseconds: 800),
    this.prefix = '',
    this.suffix = '',
    this.showPlus = false,
    this.color,
    this.animate = true,
  });

  @override
  State<AnimatedCounter> createState() => _AnimatedCounterState();
}

class _AnimatedCounterState extends State<AnimatedCounter>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  int _previousValue = 0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );
    _animation = Tween<double>(
      begin: _previousValue.toDouble(),
      end: widget.value.toDouble(),
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    ));
    if (widget.animate) {
      _controller.forward();
    }
  }

  @override
  void didUpdateWidget(AnimatedCounter oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) {
      _previousValue = _animation.value.toInt();
      _animation = Tween<double>(
        begin: _previousValue.toDouble(),
        end: widget.value.toDouble(),
      ).animate(CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOutCubic,
      ));
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
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        final current = _animation.value.round();
        final prefix = widget.showPlus && widget.value > _previousValue ? '+' : '';
        return Text(
          '$prefix${widget.prefix}$current${widget.suffix}',
          style: (widget.style ?? const TextStyle()).copyWith(
            color: widget.color,
            fontFeatures: const [FontFeature.tabularFigures()],
          ),
        );
      },
    );
  }
}

/// ────────────────────────────────────────────────────────────────────────────
/// PulseCounter — Animated counter with pulse effect on value change.
/// Used for streak count, live scores.
/// ────────────────────────────────────────────────────────────────────────────
class PulseCounter extends StatefulWidget {
  final int value;
  final TextStyle? style;
  final Widget? icon;
  final String label;
  final Color? color;

  const PulseCounter({
    super.key,
    required this.value,
    this.style,
    this.icon,
    this.label = '',
    this.color,
  });

  @override
  State<PulseCounter> createState() => _PulseCounterState();
}

class _PulseCounterState extends State<PulseCounter>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseScale;
  int _previousValue = 0;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _pulseScale = Tween<double>(begin: 1, end: 1.15).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.elasticOut),
    );
  }

  @override
  void didUpdateWidget(PulseCounter oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value && widget.value > _previousValue) {
      _pulseController.forward(from: 0);
    }
    _previousValue = widget.value;
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _pulseScale,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (widget.icon != null) ...[
            widget.icon!,
            const SizedBox(width: 6),
          ],
          AnimatedCounter(
            value: widget.value,
            style: widget.style,
            color: widget.color,
            showPlus: true,
          ),
          if (widget.label.isNotEmpty) ...[
            const SizedBox(width: 4),
            Text(
              widget.label,
              style: widget.style?.copyWith(
                color: widget.style?.color?.withValues(alpha: 0.6),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// ────────────────────────────────────────────────────────────────────────────
/// CircularProgress — Premium circular progress with gradient and glow.
/// Used for timer, profile completion, weekly goals.
/// ────────────────────────────────────────────────────────────────────────────
class AnimatedCircularProgress extends StatefulWidget {
  final double progress; // 0.0 to 1.0
  final double size;
  final double strokeWidth;
  final Widget? child;
  final List<Color>? gradientColors;
  final bool showGlow;
  final Duration duration;
  final String? label;

  const AnimatedCircularProgress({
    super.key,
    required this.progress,
    this.size = 100,
    this.strokeWidth = 8,
    this.child,
    this.gradientColors,
    this.showGlow = true,
    this.duration = const Duration(milliseconds: 1000),
    this.label,
  });

  @override
  State<AnimatedCircularProgress> createState() =>
      _AnimatedCircularProgressState();
}

class _AnimatedCircularProgressState extends State<AnimatedCircularProgress>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );
    _animation = Tween<double>(
      begin: 0,
      end: widget.progress,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    ));
    _controller.forward();
  }

  @override
  void didUpdateWidget(AnimatedCircularProgress oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.progress != widget.progress) {
      _animation = Tween<double>(
        begin: _animation.value,
        end: widget.progress,
      ).animate(CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOutCubic,
      ));
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
    final colors = widget.gradientColors ??
        const [Color(0xFF6366F1), Color(0xFF8B5CF6)];

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return SizedBox(
          width: widget.size,
          height: widget.size,
          child: CustomPaint(
            painter: _CircularProgressPainter(
              progress: _animation.value,
              strokeWidth: widget.strokeWidth,
              colors: colors,
              showGlow: widget.showGlow,
            ),
            child: Center(child: widget.child),
          ),
        );
      },
    );
  }
}

class _CircularProgressPainter extends CustomPainter {
  final double progress;
  final double strokeWidth;
  final List<Color> colors;
  final bool showGlow;

  _CircularProgressPainter({
    required this.progress,
    required this.strokeWidth,
    required this.colors,
    required this.showGlow,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;

    // Background track.
    final bgPaint = Paint()
      ..color = colors[0].withValues(alpha: 0.1)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;
    canvas.drawCircle(center, radius, bgPaint);

    // Glow effect.
    if (showGlow && progress > 0) {
      final glowPaint = Paint()
        ..shader = SweepGradient(
          startAngle: -math.pi / 2,
          endAngle: -math.pi / 2 + 2 * math.pi * progress,
          colors: colors.map((c) => c.withValues(alpha: 0.3)).toList(),
        ).createShader(Rect.fromCircle(center: center, radius: radius))
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth + 8
        ..strokeCap = StrokeCap.round
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6);
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        -math.pi / 2,
        2 * math.pi * progress,
        false,
        glowPaint,
      );
    }

    // Progress arc.
    final progressPaint = Paint()
      ..shader = SweepGradient(
        startAngle: -math.pi / 2,
        endAngle: -math.pi / 2 + 2 * math.pi * progress,
        colors: colors,
      ).createShader(Rect.fromCircle(center: center, radius: radius))
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2,
      2 * math.pi * progress,
      false,
      progressPaint,
    );

    // End cap dot.
    if (progress > 0.01) {
      final endAngle = -math.pi / 2 + 2 * math.pi * progress;
      final dotCenter = Offset(
        center.dx + radius * math.cos(endAngle),
        center.dy + radius * math.sin(endAngle),
      );
      final dotPaint = Paint()
        ..color = colors.last
        ..style = PaintingStyle.fill;
      canvas.drawCircle(dotCenter, strokeWidth / 2 + 1, dotPaint);
    }
  }

  @override
  bool shouldRepaint(_CircularProgressPainter old) =>
      old.progress != progress;
}
