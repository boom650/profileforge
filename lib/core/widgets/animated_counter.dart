import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

/// ────────────────────────────────────────────────────────────────────────────
/// AnimatedCounter — Numbers that count up from 0 to target value.
/// Creates a satisfying "slot machine" feel for stat changes.
/// ────────────────────────────────────────────────────────────────────────────
class AnimatedCounter extends StatefulWidget {
  final int targetValue;
  final Duration duration;
  final TextStyle? style;
  final String prefix;
  final String suffix;

  const AnimatedCounter({
    super.key,
    required this.targetValue,
    this.duration = const Duration(milliseconds: 800),
    this.style,
    this.prefix = '',
    this.suffix = '',
  });

  @override
  State<AnimatedCounter> createState() => _AnimatedCounterState();
}

class _AnimatedCounterState extends State<AnimatedCounter>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  int _displayValue = 0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);
    _animation = Tween<double>(
      begin: 0,
      end: widget.targetValue.toDouble(),
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));

    _controller.addListener(() {
      setState(() {
        _displayValue = _animation.value.toInt();
      });
    });

    _controller.forward();
  }

  @override
  void didUpdateWidget(AnimatedCounter oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.targetValue != widget.targetValue) {
      _animation = Tween<double>(
        begin: _displayValue.toDouble(),
        end: widget.targetValue.toDouble(),
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
    return Text(
      '$prefix$_displayValue$suffix',
      style: widget.style,
    );
  }
}

/// ────────────────────────────────────────────────────────────────────────────
/// AnimatedCounterRow — A row of animated counters with labels.
/// Used for stats grids where numbers change.
/// ────────────────────────────────────────────────────────────────────────────
class AnimatedCounterRow extends StatelessWidget {
  final IconData icon;
  final int value;
  final String label;
  final Color color;
  final String suffix;

  const AnimatedCounterRow({
    super.key,
    required this.icon,
    required this.value,
    required this.label,
    required this.color,
    this.suffix = '',
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, size: 18, color: color),
        ),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AnimatedCounter(
              targetValue: value,
              suffix: suffix,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: color,
              ),
            ),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: Colors.grey[500],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
