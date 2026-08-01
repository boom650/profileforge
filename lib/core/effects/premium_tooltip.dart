import 'package:flutter/material.dart';
import 'package:profileforge/core/theme/app_theme.dart';

/// ────────────────────────────────────────────────────────────────────────────
/// PremiumTooltip — Premium tooltip with glassmorphism look.
/// Shows contextual help, tips, and hints with smooth animations.
/// ────────────────────────────────────────────────────────────────────────────
class PremiumTooltip extends StatefulWidget {
  final Widget child;
  final String message;
  final String? title;
  final IconData? icon;
  final Duration duration;
  final TooltipPosition position;
  final bool showOnFirstBuild;
  final VoidCallback? onTap;

  const PremiumTooltip({
    super.key,
    required this.child,
    required this.message,
    this.title,
    this.icon,
    this.duration = const Duration(seconds: 3),
    this.position = TooltipPosition.top,
    this.showOnFirstBuild = false,
    this.onTap,
  });

  @override
  State<PremiumTooltip> createState() => _PremiumTooltipState();
}

enum TooltipPosition { top, bottom, left, right }

class _PremiumTooltipState extends State<PremiumTooltip>
    with SingleTickerProviderStateMixin {
  OverlayEntry? _overlay;
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );
    if (widget.showOnFirstBuild) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        show();
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    hide();
    super.dispose();
  }

  void show() {
    if (_overlay != null) return;

    final renderBox = context.findRenderObject() as RenderBox;
    final overlay = Overlay.of(context);
    final position = renderBox.localToGlobal(Offset.zero);
    final size = renderBox.size;

    _overlay = OverlayEntry(
      builder: (_) => _TooltipOverlay(
        targetPosition: position,
        targetSize: size,
        message: widget.message,
        title: widget.title,
        icon: widget.icon,
        position: widget.position,
        animationController: _controller,
        onDismiss: hide,
        onTap: widget.onTap,
      ),
    );

    overlay.insert(_overlay!);
    _controller.forward();

    // Auto-dismiss
    if (widget.duration != Duration.zero) {
      Future.delayed(widget.duration, hide);
    }
  }

  void hide() {
    if (_overlay == null) return;
    _controller.reverse().then((_) {
      _overlay?.remove();
      _overlay = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (_overlay != null) {
          hide();
        } else {
          show();
        }
      },
      child: widget.child,
    );
  }
}

class _TooltipOverlay extends StatelessWidget {
  final Offset targetPosition;
  final Size targetSize;
  final String message;
  final String? title;
  final IconData? icon;
  final TooltipPosition position;
  final AnimationController animationController;
  final VoidCallback onDismiss;
  final VoidCallback? onTap;

  const _TooltipOverlay({
    required this.targetPosition,
    required this.targetSize,
    required this.message,
    this.title,
    this.icon,
    required this.position,
    required this.animationController,
    required this.onDismiss,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final tooltipWidth = screenWidth * 0.75;

    // Calculate position
    double left = targetPosition.dx + targetSize.width / 2 - tooltipWidth / 2;
    left = left.clamp(16.0, screenWidth - tooltipWidth - 16.0);

    double top;
    switch (position) {
      case TooltipPosition.top:
        top = targetPosition.dy - 10;
        break;
      case TooltipPosition.bottom:
        top = targetPosition.dy + targetSize.height + 10;
        break;
      default:
        top = targetPosition.dy - 10;
    }

    return Stack(
      children: [
        // Dismiss on tap anywhere
        GestureDetector(
          onTap: onDismiss,
          behavior: HitTestBehavior.translucent,
          child: Container(color: Colors.transparent),
        ),
        // Tooltip
        Positioned(
          left: left,
          top: position == TooltipPosition.top ? null : top,
          bottom: position == TooltipPosition.top
              ? MediaQuery.of(context).size.height - targetPosition.dy + 10
              : null,
          child: ScaleTransition(
            scale: CurvedAnimation(
              parent: animationController,
              curve: Curves.easeOutBack,
            ),
            child: FadeTransition(
              opacity: animationController,
              child: Container(
                width: tooltipWidth,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Palette.surface2.withValues(alpha: 0.95),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: Palette.primary.withValues(alpha: 0.2),
                    width: 0.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.3),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (icon != null) ...[
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Palette.primary.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(icon, color: Palette.primary, size: 18),
                      ),
                      const SizedBox(width: 12),
                    ],
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (title != null)
                            Text(
                              title!,
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: Palette.textPrimary,
                              ),
                            ),
                          if (title != null) const SizedBox(height: 4),
                          Text(
                            message,
                            style: const TextStyle(
                              fontSize: 13,
                              color: Palette.textSecondary,
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: onDismiss,
                      child: Icon(
                        Icons.close_rounded,
                        size: 16,
                        color: Palette.textTertiary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        // Arrow
        if (position == TooltipPosition.top)
          Positioned(
            left: targetPosition.dx + targetSize.width / 2 - 8,
            bottom: MediaQuery.of(context).size.height - targetPosition.dy + 2,
            child: RotationTransition(
              turns: const AlwaysStoppedAnimation(0.5),
              child: Container(
                width: 16,
                height: 8,
                child: CustomPaint(
                  painter: _TooltipArrowPainter(
                    color: Palette.surface2.withValues(alpha: 0.95),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class _TooltipArrowPainter extends CustomPainter {
  final Color color;
  _TooltipArrowPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
    final path = Path()
      ..moveTo(0, size.height)
      ..lineTo(size.width / 2, 0)
      ..lineTo(size.width, size.height)
      ..close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_TooltipArrowPainter old) => old.color != color;
}
