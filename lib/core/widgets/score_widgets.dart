import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:profileforge/core/theme/app_theme.dart';

/// ────────────────────────────────────────────────────────────────────────────
/// ScoreCircle — Animated circular score display with gradient ring.
/// Shows overall profile score or individual component scores.
/// ────────────────────────────────────────────────────────────────────────────
class ScoreCircle extends StatefulWidget {
  const ScoreCircle({
    super.key,
    required this.score,
    required this.label,
    this.size = 120,
    this.strokeWidth = 8,
    this.gradient = Palette.gradientPrimary,
    this.tierColor,
    this.animate = true,
  });

  final int score;
  final String label;
  final double size;
  final double strokeWidth;
  final Gradient gradient;
  final Color? tierColor;
  final bool animate;

  @override
  State<ScoreCircle> createState() => _ScoreCircleState();
}

class _ScoreCircleState extends State<ScoreCircle>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _animation = Tween<double>(begin: 0, end: widget.score / 100).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
    );
    if (widget.animate) {
      _controller.forward();
    }
  }

  @override
  void didUpdateWidget(ScoreCircle oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.score != widget.score) {
      _animation = Tween<double>(
        begin: oldWidget.score / 100,
        end: widget.score / 100,
      ).animate(
        CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
      );
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
    final dark = isDark(context);

    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return CustomPaint(
            painter: _ScorePainter(
              progress: _animation.value,
              strokeWidth: widget.strokeWidth,
              gradient: widget.gradient,
              backgroundColor: dark ? Palette.surface2 : const Color(0xFFEDE3D6),
            ),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '${widget.score}',
                    style: TextStyle(
                      fontSize: widget.size * 0.3,
                      fontWeight: FontWeight.w700,
                      color: widget.tierColor ??
                          (dark ? Palette.textPrimary : Palette.textInverse),
                      height: 1,
                    ),
                  ),
                  Text(
                    widget.label,
                    style: TextStyle(
                      fontSize: widget.size * 0.1,
                      fontWeight: FontWeight.w500,
                      color: dark ? Palette.textSecondary : Palette.textTertiary,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _ScorePainter extends CustomPainter {
  _ScorePainter({
    required this.progress,
    required this.strokeWidth,
    required this.gradient,
    required this.backgroundColor,
  });

  final double progress;
  final double strokeWidth;
  final Gradient gradient;
  final Color backgroundColor;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;

    // Background circle
    final bgPaint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, bgPaint);

    // Progress arc
    final progressPaint = Paint()
      ..shader = gradient.createShader(
        Rect.fromCircle(center: center, radius: radius),
      )
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    final sweepAngle = 2 * pi * progress;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -pi / 2, // Start from top
      sweepAngle,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(_ScorePainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}

/// ────────────────────────────────────────────────────────────────────────────
/// PersonalityRadar — Radar chart for personality visualization.
/// Shows Big Five traits or SDT dimensions.
/// ────────────────────────────────────────────────────────────────────────────
class PersonalityRadar extends StatelessWidget {
  const PersonalityRadar({
    super.key,
    required this.values,
    required this.labels,
    this.size = 200,
    this.gradient = Palette.gradientPrimary,
    this.showLabels = true,
  });

  final List<double> values;
  final List<String> labels;
  final double size;
  final Gradient gradient;
  final bool showLabels;

  @override
  Widget build(BuildContext context) {
    final dark = isDark(context);

    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _RadarPainter(
          values: values,
          labels: labels,
          gradient: gradient,
          backgroundColor: dark ? Palette.surface1 : Colors.white,
          gridColor: dark ? Palette.border : const Color(0xFFEDE3D6),
          textColor: dark ? Palette.textSecondary : Palette.textTertiary,
          showLabels: showLabels,
        ),
      ),
    );
  }
}

class _RadarPainter extends CustomPainter {
  _RadarPainter({
    required this.values,
    required this.labels,
    required this.gradient,
    required this.backgroundColor,
    required this.gridColor,
    required this.textColor,
    required this.showLabels,
  });

  final List<double> values;
  final List<String> labels;
  final Gradient gradient;
  final Color backgroundColor;
  final Color gridColor;
  final Color textColor;
  final bool showLabels;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width / 2) * 0.7;
    final sides = values.length;

    if (sides < 3) return;

    // Draw grid circles
    final gridPaint = Paint()
      ..color = gridColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    for (int i = 1; i <= 4; i++) {
      final gridRadius = radius * (i / 4);
      canvas.drawCircle(center, gridRadius, gridPaint);
    }

    // Draw axis lines
    for (int i = 0; i < sides; i++) {
      final angle = (2 * pi * i / sides) - pi / 2;
      final endpoint = Offset(
        center.dx + radius * cos(angle),
        center.dy + radius * sin(angle),
      );
      canvas.drawLine(center, endpoint, gridPaint);
    }

    // Draw data polygon
    final path = Path();
    for (int i = 0; i < sides; i++) {
      final angle = (2 * pi * i / sides) - pi / 2;
      final value = values[i].clamp(0.0, 1.0);
      final point = Offset(
        center.dx + radius * value * cos(angle),
        center.dy + radius * value * sin(angle),
      );

      if (i == 0) {
        path.moveTo(point.dx, point.dy);
      } else {
        path.lineTo(point.dx, point.dy);
      }
    }
    path.close();

    // Fill polygon
    final fillPaint = Paint()
      ..shader = gradient.createShader(
        Rect.fromCircle(center: center, radius: radius),
      )
      ..style = PaintingStyle.fill;

    canvas.drawPath(path, fillPaint);

    // Stroke polygon
    final strokePaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.8)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    canvas.drawPath(path, strokePaint);

    // Draw data points
    final pointPaint = Paint()..color = Colors.white;
    for (int i = 0; i < sides; i++) {
      final angle = (2 * pi * i / sides) - pi / 2;
      final value = values[i].clamp(0.0, 1.0);
      final point = Offset(
        center.dx + radius * value * cos(angle),
        center.dy + radius * value * sin(angle),
      );
      canvas.drawCircle(point, 4, pointPaint);
    }

    // Draw labels
    if (showLabels) {
      final labelPainter = TextPainter(
        textDirection: TextDirection.ltr,
        textAlign: TextAlign.center,
      );

      for (int i = 0; i < sides; i++) {
        final angle = (2 * pi * i / sides) - pi / 2;
        final labelRadius = radius + 20;
        final labelPoint = Offset(
          center.dx + labelRadius * cos(angle),
          center.dy + labelRadius * sin(angle),
        );

        labelPainter.text = TextSpan(
          text: labels[i],
          style: TextStyle(
            color: textColor,
            fontSize: 10,
            fontWeight: FontWeight.w500,
          ),
        );
        labelPainter.layout();
        labelPainter.paint(
          canvas,
          Offset(
            labelPoint.dx - labelPainter.width / 2,
            labelPoint.dy - labelPainter.height / 2,
          ),
        );
      }
    }
  }

  @override
  bool shouldRepaint(_RadarPainter oldDelegate) {
    return oldDelegate.values != values;
  }
}

/// ────────────────────────────────────────────────────────────────────────────
/// TierBadge — Displays score tier with icon and label.
/// ────────────────────────────────────────────────────────────────────────────
class TierBadge extends StatelessWidget {
  const TierBadge({
    super.key,
    required this.tier,
    required this.label,
    this.size = 40,
  });

  final Color tier;
  final String label;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: tier.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(9999),
        border: Border.all(
          color: tier.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: tier,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: tier,
            ),
          ),
        ],
      ),
    );
  }
}

/// ────────────────────────────────────────────────────────────────────────────
/// TraitBar — Horizontal progress bar for personality traits.
/// ────────────────────────────────────────────────────────────────────────────
class TraitBar extends StatelessWidget {
  const TraitBar({
    super.key,
    required this.label,
    required this.value,
    required this.color,
    this.height = 6,
  });

  final String label;
  final double value;
  final Color color;
  final double height;

  @override
  Widget build(BuildContext context) {
    final dark = isDark(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: GoogleFonts.nunito(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: dark ? Palette.textSecondary : Palette.textTertiary,
              ),
            ),
            Text(
              '${(value * 100).round()}%',
              style: GoogleFonts.nunito(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Container(
          height: height,
          decoration: BoxDecoration(
            color: dark ? Palette.surface2 : const Color(0xFFEDE3D6),
            borderRadius: BorderRadius.circular(height / 2),
          ),
          child: FractionallySizedBox(
            widthFactor: value.clamp(0.0, 1.0),
            alignment: Alignment.centerLeft,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [color, color.withValues(alpha: 0.7)],
                ),
                borderRadius: BorderRadius.circular(height / 2),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// ────────────────────────────────────────────────────────────────────────────
/// InsightCard — Card for displaying AI-generated insights.
/// ────────────────────────────────────────────────────────────────────────────
class InsightCard extends StatelessWidget {
  const InsightCard({
    super.key,
    required this.icon,
    required this.title,
    required this.insight,
    this.actionLabel,
    this.onAction,
    this.gradient = Palette.gradientPrimary,
  });

  final IconData icon;
  final String title;
  final String insight;
  final String? actionLabel;
  final VoidCallback? onAction;
  final Gradient gradient;

  @override
  Widget build(BuildContext context) {
    final dark = isDark(context);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: dark
            ? Palette.surface1.withValues(alpha: 0.7)
            : Colors.white.withValues(alpha: 0.8),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: dark ? Palette.border : const Color(0xFFEDE3D6),
        ),
        boxShadow: [
          BoxShadow(
            color: dark
                ? Colors.black.withValues(alpha: 0.2)
                : Colors.black.withValues(alpha: 0.05),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  gradient: gradient,
                  borderRadius: BorderRadius.circular(9999),
                ),
                child: Icon(icon, size: 16, color: Colors.white),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: GoogleFonts.nunito(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: dark ? Palette.textPrimary : Palette.textInverse,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            insight,
            style: GoogleFonts.nunito(
              fontSize: 13,
              height: 1.5,
              color: dark ? Palette.textSecondary : Palette.textTertiary,
            ),
          ),
          if (actionLabel != null) ...[
            const SizedBox(height: 12),
            GestureDetector(
              onTap: onAction,
              child: Text(
                actionLabel!,
                style: GoogleFonts.nunito(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Palette.primary,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// ────────────────────────────────────────────────────────────────────────────
/// StreakFlame — Animated flame icon for streak display.
/// ────────────────────────────────────────────────────────────────────────────
class StreakFlame extends StatefulWidget {
  const StreakFlame({
    super.key,
    required this.streak,
    this.size = 48,
  });

  final int streak;
  final double size;

  @override
  State<StreakFlame> createState() => _StreakFlameState();
}

class _StreakFlameState extends State<StreakFlame>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
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
        return Transform.scale(
          scale: 1.0 + (_controller.value * 0.1),
          child: Container(
            width: widget.size,
            height: widget.size,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  const Color(0xFFF59E0B),
                  const Color(0xFFF97316),
                  const Color(0xFFEF4444),
                ],
              ),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFF59E0B).withValues(alpha: 0.4 + _controller.value * 0.2),
                  blurRadius: 12 + _controller.value * 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.local_fire_department,
                    size: widget.size * 0.4,
                    color: Colors.white,
                  ),
                  Text(
                    '${widget.streak}',
                    style: TextStyle(
                      fontSize: widget.size * 0.2,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      height: 1,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

/// ────────────────────────────────────────────────────────────────────────────
/// ScoreChangeIndicator — Shows score change (up/down) with animation.
/// ────────────────────────────────────────────────────────────────────────────
class ScoreChangeIndicator extends StatelessWidget {
  const ScoreChangeIndicator({
    super.key,
    required this.change,
    this.showLabel = true,
  });

  final int change;
  final bool showLabel;

  @override
  Widget build(BuildContext context) {
    if (change == 0) return const SizedBox.shrink();

    final isPositive = change > 0;
    final color = isPositive ? Palette.success : Palette.error;
    final icon = isPositive ? Icons.trending_up : Icons.trending_down;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(9999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Text(
            '${isPositive ? '+' : ''}$change',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
          if (showLabel) ...[
            const SizedBox(width: 2),
            Text(
              'pts',
              style: TextStyle(
                fontSize: 10,
                color: color.withValues(alpha: 0.7),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// ────────────────────────────────────────────────────────────────────────────
/// ScoreMini — Small score display for breakdown sections.
/// ────────────────────────────────────────────────────────────────────────────
class ScoreMini extends StatelessWidget {
  const ScoreMini({
    super.key,
    required this.label,
    required this.score,
    this.color,
    this.size = 48,
  });

  final String label;
  final int score;
  final Color? color;
  final double size;

  @override
  Widget build(BuildContext context) {
    final dark = isDark(context);
    final displayColor = color ?? Palette.primary;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: displayColor.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(9999),
          ),
          child: Center(
            child: Text(
              '$score',
              style: TextStyle(
                fontSize: size * 0.35,
                fontWeight: FontWeight.w700,
                color: displayColor,
              ),
            ),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w500,
            color: dark ? Palette.textSecondary : Palette.textTertiary,
          ),
        ),
      ],
    );
  }
}

/// ────────────────────────────────────────────────────────────────────────────
/// AnimatedButton — Interactive button with tap feedback.
/// ────────────────────────────────────────────────────────────────────────────
class AnimatedButton extends StatefulWidget {
  const AnimatedButton({
    super.key,
    required this.onTap,
    required this.child,
    this.padding = const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
    this.borderRadius = 12,
    this.gradient,
    this.enabled = true,
  });

  final VoidCallback onTap;
  final Widget child;
  final EdgeInsets padding;
  final double borderRadius;
  final Gradient? gradient;
  final bool enabled;

  @override
  State<AnimatedButton> createState() => _AnimatedButtonState();
}

class _AnimatedButtonState extends State<AnimatedButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: widget.enabled ? (_) => _controller.forward() : null,
      onTapUp: widget.enabled
          ? (_) {
              _controller.reverse();
              widget.onTap();
            }
          : null,
      onTapCancel: widget.enabled ? () => _controller.reverse() : null,
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Container(
              padding: widget.padding,
              decoration: BoxDecoration(
                gradient: widget.enabled
                    ? (widget.gradient ?? Palette.gradientPrimary)
                    : null,
                color: widget.enabled ? null : Palette.textTertiary.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(widget.borderRadius),
                boxShadow: widget.enabled
                    ? [
                        BoxShadow(
                          color: Palette.primary.withValues(alpha: 0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ]
                    : null,
              ),
              child: widget.child,
            ),
          );
        },
      ),
    );
  }
}
