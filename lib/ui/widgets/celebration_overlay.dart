import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'micro_interactions.dart';
import '../theme/app_theme.dart';

// ---------------------------------------------------------------------------
// CelebrationOverlay – A full-screen celebration widget that shows:
//   • Confetti particles when a mission completes
//   • Scale-up animation on milestone achievements
//   • Reduced motion fallback (just shows a checkmark)
// ---------------------------------------------------------------------------

/// Type of celebration to display.
enum CelebrationType {
  missionComplete,
  milestoneAchieved,
  levelUp,
  streakMilestone,
}

class CelebrationOverlay extends StatefulWidget {
  /// Whether the celebration is currently visible.
  final bool isVisible;

  /// The type of celebration – controls visuals and text.
  final CelebrationType type;

  /// Title shown during the celebration (e.g. "Mission Complete!").
  final String title;

  /// Subtitle / description (e.g. "+50 XP earned").
  final String? subtitle;

  /// Callback when the overlay is dismissed (via tap or auto-dismiss).
  final VoidCallback? onDismiss;

  /// How long the overlay stays visible before auto-dismissing.
  final Duration autoDismissDuration;

  const CelebrationOverlay({
    super.key,
    this.isVisible = false,
    this.type = CelebrationType.missionComplete,
    this.title = 'Mission Complete!',
    this.subtitle,
    this.onDismiss,
    this.autoDismissDuration = const Duration(seconds: 3),
  });

  @override
  State<CelebrationOverlay> createState() => _CelebrationOverlayState();
}

class _CelebrationOverlayState extends State<CelebrationOverlay>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scaleAnim;
  late final Animation<double> _fadeAnim;
  bool _showConfetti = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _scaleAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.elasticOut),
    );
    _fadeAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.4, curve: Curves.easeIn),
      ),
    );

    if (widget.isVisible) {
      _showCelebration();
    }
  }

  @override
  void didUpdateWidget(CelebrationOverlay oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isVisible && !oldWidget.isVisible) {
      _showCelebration();
    } else if (!widget.isVisible && oldWidget.isVisible) {
      _dismiss();
    }
  }

  void _showCelebration() {
    HapticHelper.heavy();
    setState(() => _showConfetti = true);
    _controller.forward(from: 0);

    // Auto-dismiss after the specified duration.
    Future.delayed(widget.autoDismissDuration, () {
      if (mounted && widget.isVisible) {
        _dismiss();
      }
    });
  }

  void _dismiss() {
    _controller.reverse().then((_) {
      if (mounted) {
        setState(() => _showConfetti = false);
        widget.onDismiss?.call();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.isVisible && _controller.isDismissed) {
      return const SizedBox.shrink();
    }

    final shouldReduce = ReducedMotionWrapper.shouldReduceMotion(context);

    if (shouldReduce) {
      return _buildReducedMotionFallback();
    }

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        return Stack(
          children: [
            // Semi-transparent backdrop
            Opacity(
              opacity: _fadeAnim.value * 0.6,
              child: GestureDetector(
                onTap: _dismiss,
                child: Container(
                  color: Colors.black,
                  width: double.infinity,
                  height: double.infinity,
                ),
              ),
            ),

            // Confetti layer
            if (_showConfetti)
              ConfettiBurst(
                show: _showConfetti,
                duration: const Duration(milliseconds: 1500),
                particleCount: 50,
              ),

            // Center content
            Center(
              child: Transform.scale(
                scale: _scaleAnim.value,
                child: _buildCelebrationContent(),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildCelebrationContent() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 40),
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: context.surfaceElevated,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 32,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Icon / visual
          _buildCelebrationIcon(),
          const SizedBox(height: 20),
          // Title
          Text(
            widget.title,
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: AppTheme.textPrimary,
            ),
          ),
          if (widget.subtitle != null) ...[
            const SizedBox(height: 8),
            Text(
              widget.subtitle!,
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                fontSize: 14,
                color: AppTheme.textSecondary,
              ),
            ),
          ],
          const SizedBox(height: 24),
          // Dismiss button
          TextButton(
            onPressed: () { HapticFeedback.lightImpact(); _dismiss(); },
            child: Text(
              'Continue',
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppTheme.primaryBlue,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCelebrationIcon() {
    switch (widget.type) {
      case CelebrationType.missionComplete:
        return Container(
          width: 72,
          height: 72,
          decoration: BoxDecoration(
            color: AppTheme.successGreen.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.check_rounded,
            size: 40,
            color: AppTheme.successGreen,
          ),
        );
      case CelebrationType.milestoneAchieved:
        return Container(
          width: 72,
          height: 72,
          decoration: BoxDecoration(
            color: AppTheme.accentGold.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.flag_rounded,
            size: 40,
            color: AppTheme.accentGold,
          ),
        );
      case CelebrationType.levelUp:
        return Container(
          width: 72,
          height: 72,
          decoration: BoxDecoration(
            color: AppTheme.primaryBlue.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.stars_rounded,
            size: 40,
            color: AppTheme.primaryBlue,
          ),
        );
      case CelebrationType.streakMilestone:
        return Container(
          width: 72,
          height: 72,
          decoration: BoxDecoration(
            color: AppTheme.accentOrange.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.local_fire_department_rounded,
            size: 40,
            color: AppTheme.accentOrange,
          ),
        );
    }
  }

  /// Reduced motion fallback: just shows a simple checkmark card with no
  /// animations.
  Widget _buildReducedMotionFallback() {
    return Stack(
      children: [
        GestureDetector(
          onTap: _dismiss,
          child: Container(
            color: Colors.black.withValues(alpha: 0.4),
            width: double.infinity,
            height: double.infinity,
          ),
        ),
        Center(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 40),
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: context.surfaceElevated,
              borderRadius: BorderRadius.circular(24),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  _getIconForType(widget.type),
                  size: 48,
                  color: _getColorForType(widget.type),
                ),
                const SizedBox(height: 16),
                Text(
                  widget.title,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.textPrimary,
                  ),
                ),
                if (widget.subtitle != null) ...[
                  const SizedBox(height: 8),
                  Text(
                    widget.subtitle!,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                ],
                const SizedBox(height: 20),
                TextButton(
                  onPressed: () { HapticFeedback.lightImpact(); _dismiss(); },
                  child: Text(
                    'Continue',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.primaryBlue,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  IconData _getIconForType(CelebrationType type) {
    switch (type) {
      case CelebrationType.missionComplete:
        return Icons.check_circle_rounded;
      case CelebrationType.milestoneAchieved:
        return Icons.emoji_events_rounded;
      case CelebrationType.levelUp:
        return Icons.stars_rounded;
      case CelebrationType.streakMilestone:
        return Icons.local_fire_department_rounded;
    }
  }

  Color _getColorForType(CelebrationType type) {
    switch (type) {
      case CelebrationType.missionComplete:
        return AppTheme.successGreen;
      case CelebrationType.milestoneAchieved:
        return AppTheme.accentGold;
      case CelebrationType.levelUp:
        return AppTheme.primaryBlue;
      case CelebrationType.streakMilestone:
        return AppTheme.accentOrange;
    }
  }
}

// ---------------------------------------------------------------------------
// CelebrationOverlay.show – convenience method to display a celebration
// as an overlay on the current Navigator's overlay.
// ---------------------------------------------------------------------------
class CelebrationHelper {
  CelebrationHelper._();

  /// Shows a celebration overlay on the current context.
  /// Returns a TickerProvider that can be used to dismiss early.
  static OverlayEntry show(
    BuildContext context, {
    CelebrationType type = CelebrationType.missionComplete,
    String title = 'Mission Complete!',
    String? subtitle,
    Duration autoDismissDuration = const Duration(seconds: 3),
  }) {
    late OverlayEntry entry;
    entry = OverlayEntry(
      builder: (_) => CelebrationOverlay(
        isVisible: true,
        type: type,
        title: title,
        subtitle: subtitle,
        autoDismissDuration: autoDismissDuration,
        onDismiss: () {
          entry.remove();
        },
      ),
    );
    Overlay.of(context).insert(entry);
    return entry;
  }
}
