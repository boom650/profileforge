import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:profileforge/core/theme/app_theme.dart';

/// ────────────────────────────────────────────────────────────────────────────
/// FeedbackWidgets — User feedback and interaction components.
///
/// Based on research:
/// - 12-uiux-gamification-engagement.md
/// - Micro-interactions for feedback
/// - Touch-friendly sizing (48px minimum)
/// ────────────────────────────────────────────────────────────────────────────

/// FeedbackButtons — Thumb up/down feedback for AI responses.
class FeedbackButtons extends StatefulWidget {
  const FeedbackButtons({
    super.key,
    this.onFeedback,
    this.size = 28,
  });

  final Function(bool helpful)? onFeedback;
  final double size;

  @override
  State<FeedbackButtons> createState() => _FeedbackButtonsState();
}

class _FeedbackButtonsState extends State<FeedbackButtons> {
  bool? _feedback;

  @override
  Widget build(BuildContext context) {
    final dark = isDark(context);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _FeedbackButton(
          icon: Icons.thumb_up_outlined,
          activeIcon: Icons.thumb_up,
          isActive: _feedback == true,
          onTap: () {
            HapticFeedback.selectionClick();
            setState(() => _feedback = true);
            widget.onFeedback?.call(true);
          },
          color: Palette.success,
          size: widget.size,
          dark: dark,
        ),
        const SizedBox(width: 8),
        _FeedbackButton(
          icon: Icons.thumb_down_outlined,
          activeIcon: Icons.thumb_down,
          isActive: _feedback == false,
          onTap: () {
            HapticFeedback.selectionClick();
            setState(() => _feedback = false);
            widget.onFeedback?.call(false);
          },
          color: Palette.error,
          size: widget.size,
          dark: dark,
        ),
      ],
    );
  }
}

class _FeedbackButton extends StatelessWidget {
  const _FeedbackButton({
    required this.icon,
    required this.activeIcon,
    required this.isActive,
    required this.onTap,
    required this.color,
    required this.size,
    required this.dark,
  });

  final IconData icon;
  final IconData activeIcon;
  final bool isActive;
  final VoidCallback onTap;
  final Color color;
  final double size;
  final bool dark;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: isActive
              ? color.withValues(alpha: 0.15)
              : dark
                  ? Palette.surface2.withValues(alpha: 0.5)
                  : const Color(0xFFF1F5F9),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isActive
                ? color.withValues(alpha: 0.3)
                : Colors.transparent,
          ),
        ),
        child: Icon(
          isActive ? activeIcon : icon,
          size: size * 0.5,
          color: isActive
              ? color
              : (dark ? Palette.textTertiary : Palette.textSecondary),
        ),
      ),
    );
  }
}

/// CopyButton — Copy text to clipboard with feedback.
class CopyButton extends StatelessWidget {
  const CopyButton({
    super.key,
    required this.text,
    this.size = 28,
  });

  final String text;
  final double size;

  @override
  Widget build(BuildContext context) {
    final dark = isDark(context);

    return GestureDetector(
      onTap: () {
        HapticFeedback.selectionClick();
        Clipboard.setData(ClipboardData(text: text));
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Copied to clipboard'),
            backgroundColor: Palette.success,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            duration: const Duration(seconds: 1),
          ),
        );
      },
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: dark ? Palette.surface2.withValues(alpha: 0.5) : const Color(0xFFF1F5F9),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          Icons.copy,
          size: size * 0.5,
          color: dark ? Palette.textTertiary : Palette.textSecondary,
        ),
      ),
    );
  }
}

/// ShareButton — Share content with platform share sheet.
class ShareButton extends StatelessWidget {
  const ShareButton({
    super.key,
    required this.text,
    this.size = 28,
  });

  final String text;
  final double size;

  @override
  Widget build(BuildContext context) {
    final dark = isDark(context);

    return GestureDetector(
      onTap: () {
        HapticFeedback.selectionClick();
        // TODO: Implement share
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Share feature coming soon'),
            backgroundColor: Palette.info,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        );
      },
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: dark ? Palette.surface2.withValues(alpha: 0.5) : const Color(0xFFF1F5F9),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          Icons.share,
          size: size * 0.5,
          color: dark ? Palette.textTertiary : Palette.textSecondary,
        ),
      ),
    );
  }
}

/// SuccessAnimation — Animated success checkmark.
class SuccessAnimation extends StatefulWidget {
  const SuccessAnimation({
    super.key,
    this.size = 80,
    this.color = Palette.success,
    this.onComplete,
  });

  final double size;
  final Color color;
  final VoidCallback? onComplete;

  @override
  State<SuccessAnimation> createState() => _SuccessAnimationState();
}

class _SuccessAnimationState extends State<SuccessAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _checkAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _scaleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.5, curve: Curves.elasticOut),
    ));

    _checkAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.5, 1.0, curve: Curves.easeOut),
    ));

    _controller.forward().then((_) {
      widget.onComplete?.call();
    });
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
          scale: _scaleAnimation.value,
          child: Container(
            width: widget.size,
            height: widget.size,
            decoration: BoxDecoration(
              color: widget.color.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: CustomPaint(
              painter: _CheckPainter(
                progress: _checkAnimation.value,
                color: widget.color,
                strokeWidth: widget.size * 0.06,
              ),
            ),
          ),
        );
      },
    );
  }
}

class _CheckPainter extends CustomPainter {
  _CheckPainter({
    required this.progress,
    required this.color,
    required this.strokeWidth,
  });

  final double progress;
  final Color color;
  final double strokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    final path = Path();
    path.moveTo(size.width * 0.25, size.height * 0.5);
    path.lineTo(size.width * 0.45, size.height * 0.7);
    path.lineTo(size.width * 0.75, size.height * 0.35);

    final metrics = path.computeMetrics().first;
    final extractPath = metrics.extractPath(0, metrics.length * progress);

    canvas.drawPath(extractPath, paint);
  }

  @override
  bool shouldRepaint(_CheckPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}

/// ErrorAnimation — Animated error X mark.
class ErrorAnimation extends StatefulWidget {
  const ErrorAnimation({
    super.key,
    this.size = 80,
    this.color = Palette.error,
    this.onComplete,
  });

  final double size;
  final Color color;
  final VoidCallback? onComplete;

  @override
  State<ErrorAnimation> createState() => _ErrorAnimationState();
}

class _ErrorAnimationState extends State<ErrorAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _xAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _scaleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.6, curve: Curves.elasticOut),
    ));

    _xAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.4, 1.0, curve: Curves.easeOut),
    ));

    _controller.forward().then((_) {
      widget.onComplete?.call();
    });
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
          scale: _scaleAnimation.value,
          child: Container(
            width: widget.size,
            height: widget.size,
            decoration: BoxDecoration(
              color: widget.color.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: CustomPaint(
              painter: _XPainter(
                progress: _xAnimation.value,
                color: widget.color,
                strokeWidth: widget.size * 0.06,
              ),
            ),
          ),
        );
      },
    );
  }
}

class _XPainter extends CustomPainter {
  _XPainter({
    required this.progress,
    required this.color,
    required this.strokeWidth,
  });

  final double progress;
  final Color color;
  final double strokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    final path = Path();
    // First line: top-left to bottom-right
    path.moveTo(size.width * 0.3, size.height * 0.3);
    path.lineTo(size.width * 0.7, size.height * 0.7);
    // Move to second line start
    path.moveTo(size.width * 0.7, size.height * 0.3);
    path.lineTo(size.width * 0.3, size.height * 0.7);

    final metrics = path.computeMetrics().first;
    final extractPath = metrics.extractPath(0, metrics.length * progress);

    canvas.drawPath(extractPath, paint);
  }

  @override
  bool shouldRepaint(_XPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
