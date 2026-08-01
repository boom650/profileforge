import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:profileforge/core/audio/sound_service.dart';

/// ────────────────────────────────────────────────────────────────────────────
/// MagneticButton — Button that subtly attracts toward the user's finger.
/// Creates an organic, premium feel on primary CTAs.
/// ────────────────────────────────────────────────────────────────────────────
class MagneticButton extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final double strength;
  final double scaleOnPress;

  const MagneticButton({
    super.key,
    required this.child,
    this.onTap,
    this.strength = 0.3,
    this.scaleOnPress = 0.95,
  });

  @override
  State<MagneticButton> createState() => _MagneticButtonState();
}

class _MagneticButtonState extends State<MagneticButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnim;
  Offset _offset = Offset.zero;
  bool _pressing = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _scaleAnim = Tween<double>(
      begin: 1.0,
      end: widget.scaleOnPress,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onPointerMove(PointerMoveEvent event) {
    if (!_pressing) return;
    final renderBox = context.findRenderObject() as RenderBox?;
    if (renderBox == null) return;
    final center = renderBox.size.center(Offset.zero);
    final local = renderBox.globalToLocal(event.position);
    setState(() {
      _offset = (local - center) * widget.strength;
    });
  }

  void _onPointerDown(PointerDownEvent event) {
    setState(() => _pressing = true);
    _controller.forward();
    HapticFeedback.lightImpact();
    SoundService.instance.tap();
  }

  void _onPointerUp(PointerUpEvent event) {
    setState(() {
      _pressing = false;
      _offset = Offset.zero;
    });
    _controller.reverse();
  }

  void _onPointerCancel(PointerCancelEvent event) {
    setState(() {
      _pressing = false;
      _offset = Offset.zero;
    });
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerMove: _onPointerMove,
      onPointerDown: _onPointerDown,
      onPointerUp: _onPointerUp,
      onPointerCancel: _onPointerCancel,
      child: AnimatedBuilder(
        animation: _scaleAnim,
        builder: (context, child) {
          return Transform.translate(
            offset: _offset,
            child: Transform.scale(
              scale: _scaleAnim.value,
              child: child,
            ),
          );
        },
        child: GestureDetector(
          onTap: widget.onTap,
          child: widget.child,
        ),
      ),
    );
  }
}
