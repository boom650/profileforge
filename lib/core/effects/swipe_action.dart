import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:profileforge/core/theme/app_theme.dart';

/// ────────────────────────────────────────────────────────────────────────────
/// SwipeActionCard — Premium swipe-to-action card.
/// Reveal actions on swipe left/right with haptic feedback.
/// Used for mission completion, notification dismiss, etc.
/// ────────────────────────────────────────────────────────────────────────────
class SwipeActionCard extends StatefulWidget {
  final Widget child;
  final VoidCallback? onSwipeRight;
  final VoidCallback? onSwipeLeft;
  final Widget? rightAction;
  final Widget? leftAction;
  final double threshold;
  final bool enabled;

  const SwipeActionCard({
    super.key,
    required this.child,
    this.onSwipeRight,
    this.onSwipeLeft,
    this.rightAction,
    this.leftAction,
    this.threshold = 100,
    this.enabled = true,
  });

  @override
  State<SwipeActionCard> createState() => _SwipeActionCardState();
}

class _SwipeActionCardState extends State<SwipeActionCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _dragAnimation;
  double _dragExtent = 0;
  bool _hasTriggeredHaptic = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _dragAnimation = Tween<double>(begin: 0, end: 0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onHorizontalDragUpdate(DragUpdateDetails details) {
    if (!widget.enabled) return;

    _dragExtent += details.primaryDelta!;

    // Haptic feedback at threshold
    if (_dragExtent.abs() > widget.threshold && !_hasTriggeredHaptic) {
      HapticFeedback.mediumImpact();
      _hasTriggeredHaptic = true;
    } else if (_dragExtent.abs() <= widget.threshold) {
      _hasTriggeredHaptic = false;
    }

    setState(() {});
  }

  void _onHorizontalDragEnd(DragEndDetails details) {
    if (!widget.enabled) return;

    if (_dragExtent > widget.threshold && widget.onSwipeRight != null) {
      HapticFeedback.heavyImpact();
      widget.onSwipeRight!.call();
    } else if (_dragExtent < -widget.threshold &&
        widget.onSwipeLeft != null) {
      HapticFeedback.heavyImpact();
      widget.onSwipeLeft!.call();
    }

    _dragExtent = 0;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final clampedOffset = _dragExtent.clamp(-150.0, 150.0);

    return GestureDetector(
      onHorizontalDragUpdate: _onHorizontalDragUpdate,
      onHorizontalDragEnd: _onHorizontalDragEnd,
      child: Stack(
        children: [
          // Right action (revealed on swipe right)
          if (widget.onSwipeRight != null && widget.rightAction != null)
            Positioned.fill(
              child: Align(
                alignment: Alignment.centerRight,
                child: widget.rightAction,
              ),
            ),
          // Left action (revealed on swipe left)
          if (widget.onSwipeLeft != null && widget.leftAction != null)
            Positioned.fill(
              child: Align(
                alignment: Alignment.centerLeft,
                child: widget.leftAction,
              ),
            ),
          // Main card content
          AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            transform: Matrix4.translationValues(clampedOffset, 0, 0),
            child: widget.child,
          ),
        ],
      ),
    );
  }
}

/// ────────────────────────────────────────────────────────────────────────────
/// SwipeCompleteAction — Green checkmark action for completing items
/// ────────────────────────────────────────────────────────────────────────────
class SwipeCompleteAction extends StatelessWidget {
  final double height;

  const SwipeCompleteAction({super.key, this.height = 80});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: 80,
      margin: const EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF10B981), Color(0xFF059669)],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.check_circle_rounded, color: Colors.white, size: 28),
          SizedBox(height: 4),
          Text(
            'Done',
            style: TextStyle(
              color: Colors.white,
              fontSize: 11,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

/// ────────────────────────────────────────────────────────────────────────────
/// SwipeDeleteAction — Red trash action for removing items
/// ────────────────────────────────────────────────────────────────────────────
class SwipeDeleteAction extends StatelessWidget {
  final double height;

  const SwipeDeleteAction({super.key, this.height = 80});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: 80,
      margin: const EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFEF4444), Color(0xFFDC2626)],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.delete_outline_rounded, color: Colors.white, size: 28),
          SizedBox(height: 4),
          Text(
            'Remove',
            style: TextStyle(
              color: Colors.white,
              fontSize: 11,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
