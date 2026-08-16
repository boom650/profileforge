import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:profileforge/core/theme/app_theme.dart';

/// ────────────────────────────────────────────────────────────────────────────
/// ProfileForge Progress Indicators — Premium progress visualization.
/// ────────────────────────────────────────────────────────────────────────────

/// CircularScoreProgress — Animated circular progress with score.
class CircularScoreProgress extends StatefulWidget {
  const CircularScoreProgress({
    super.key,
    required this.value,
    this.size = 120,
    this.strokeWidth = 10,
    this.backgroundColor,
    this.color,
    this.child,
  });

  final double value;
  final double size;
  final double strokeWidth;
  final Color? backgroundColor;
  final Color? color;
  final Widget? child;

  @override
  State<CircularScoreProgress> createState() => _CircularScoreProgressState();
}

class _CircularScoreProgressState extends State<CircularScoreProgress>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    _animation = Tween<double>(begin: 0, end: widget.value).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
    );
    _controller.forward();
  }

  @override
  void didUpdateWidget(CircularScoreProgress oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) {
      _animation = Tween<double>(
        begin: _animation.value,
        end: widget.value,
      ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));
      _controller
        ..reset()
        ..forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dark = isDark(context);
    final color = widget.color ?? _getScoreColor(widget.value.round());
    final bgColor = widget.backgroundColor ??
        (dark ? Palette.surface2 : const Color(0xFFEDE3D6));

    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return CustomPaint(
            painter: _CircularProgressPainter(
              progress: _animation.value / 100,
              color: color,
              backgroundColor: bgColor,
              strokeWidth: widget.strokeWidth,
            ),
            child: widget.child ??
                Center(
                  child: Text(
                    '${_animation.value.round()}',
                    style: GoogleFonts.nunito(
                      fontSize: widget.size * 0.3,
                      fontWeight: FontWeight.w700,
                      color: color,
                    ),
                  ),
                ),
          );
        },
      ),
    );
  }

  Color _getScoreColor(int score) {
    if (score >= 80) return Palette.success;
    if (score >= 60) return Palette.warning;
    return Palette.error;
  }
}

class _CircularProgressPainter extends CustomPainter {
  _CircularProgressPainter({
    required this.progress,
    required this.color,
    required this.backgroundColor,
    required this.strokeWidth,
  });

  final double progress;
  final Color color;
  final Color backgroundColor;
  final double strokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (min(size.width, size.height) - strokeWidth) / 2;

    // Background
    final bgPaint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, bgPaint);

    // Progress
    final progressPaint = Paint()
      ..shader = SweepGradient(
        startAngle: -pi / 2,
        colors: [color, color.withValues(alpha: 0.6)],
      ).createShader(Rect.fromCircle(center: center, radius: radius))
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    final sweepAngle = 2 * pi * progress;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -pi / 2,
      sweepAngle,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(_CircularProgressPainter oldDelegate) {
    return oldDelegate.progress != progress || oldDelegate.color != color;
  }
}

/// SteppedProgress — Progress with discrete steps.
class SteppedProgress extends StatelessWidget {
  const SteppedProgress({
    super.key,
    required this.totalSteps,
    required this.currentStep,
    this.labels,
    this.height = 8,
    this.color,
  });

  final int totalSteps;
  final int currentStep;
  final List<String>? labels;
  final double height;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final dark = isDark(context);
    final progressColor = color ?? Palette.primary;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Progress bar
        Row(
          children: List.generate(totalSteps, (i) {
            final isCompleted = i < currentStep;
            final isCurrent = i == currentStep - 1;

            return Expanded(
              child: Padding(
                padding: EdgeInsets.only(right: i < totalSteps - 1 ? 4 : 0),
                child: Container(
                  height: height,
                  decoration: BoxDecoration(
                    color: isCompleted
                        ? progressColor
                        : (dark ? Palette.surface2 : const Color(0xFFEDE3D6)),
                    borderRadius: BorderRadius.circular(height / 2),
                    boxShadow: isCurrent
                        ? [
                            BoxShadow(
                              color: progressColor.withValues(alpha: 0.3),
                              blurRadius: 4,
                            ),
                          ]
                        : null,
                  ),
                ),
              ),
            );
          }),
        ),

        // Labels
        if (labels != null) ...[
          const SizedBox(height: 8),
          Row(
            children: List.generate(totalSteps, (i) {
              final isCompleted = i < currentStep;
              final isCurrent = i == currentStep - 1;

              return Expanded(
                child: Text(
                  labels![i],
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: isCurrent ? FontWeight.w600 : FontWeight.w400,
                    color: isCompleted
                        ? progressColor
                        : (dark ? Palette.textTertiary : Palette.textSecondary),
                  ),
                ),
              );
            }),
          ),
        ],
      ],
    );
  }
}

/// LinearGradientProgress — Gradient linear progress bar.
class LinearGradientProgress extends StatelessWidget {
  const LinearGradientProgress({
    super.key,
    required this.value,
    this.height = 8,
    this.gradient,
    this.backgroundColor,
  });

  final double value;
  final double height;
  final Gradient? gradient;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    final dark = isDark(context);

    return ClipRRect(
      borderRadius: BorderRadius.circular(height / 2),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Stack(
            children: [
              // Background
              Container(
                height: height,
                decoration: BoxDecoration(
                  color: backgroundColor ??
                      (dark ? Palette.surface2 : const Color(0xFFEDE3D6)),
                ),
              ),
              // Fill
              AnimatedContainer(
                duration: const Duration(milliseconds: 500),
                curve: Curves.easeOutCubic,
                height: height,
                width: constraints.maxWidth * value.clamp(0.0, 1.0),
                decoration: BoxDecoration(
                  gradient: gradient ?? Palette.gradientPrimary,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

/// DotProgress — Dot-based progress indicator.
class DotProgress extends StatelessWidget {
  const DotProgress({
    super.key,
    required this.total,
    required this.current,
    this.size = 8,
    this.spacing = 6,
    this.activeColor,
    this.inactiveColor,
  });

  final int total;
  final int current;
  final double size;
  final double spacing;
  final Color? activeColor;
  final Color? inactiveColor;

  @override
  Widget build(BuildContext context) {
    final dark = isDark(context);
    final active = activeColor ?? Palette.primary;
    final inactive =
        inactiveColor ?? (dark ? Palette.surface2 : const Color(0xFFEDE3D6));

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(total, (i) {
        final isActive = i == current;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: isActive ? size * 2 : size,
          height: size,
          margin: EdgeInsets.only(right: i < total - 1 ? spacing : 0),
          decoration: BoxDecoration(
            color: isActive ? active : inactive,
            borderRadius: BorderRadius.circular(size / 2),
          ),
        );
      }),
    );
  }
}
