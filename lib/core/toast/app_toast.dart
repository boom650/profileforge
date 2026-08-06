import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:profileforge/core/theme/app_theme.dart';

/// ────────────────────────────────────────────────────────────────────────────
/// AppToast — Premium toast notification system.
///
/// Features:
/// - Multiple toast types (success, error, warning, info)
/// - Auto-dismiss with timer
/// - Stack multiple toasts
/// - Custom icons and colors
/// - Animation
/// ────────────────────────────────────────────────────────────────────────────

enum ToastType { success, error, warning, info }

class AppToast {
  static OverlayEntry? _currentEntry;

  /// Show a toast notification.
  static void show({
    required BuildContext context,
    required String message,
    ToastType type = ToastType.info,
    Duration duration = const Duration(seconds: 3),
    String? actionLabel,
    VoidCallback? onAction,
  }) {
    // Remove existing toast
    _currentEntry?.remove();

    final overlay = Overlay.of(context);
    _currentEntry = OverlayEntry(
      builder: (context) => _ToastWidget(
        message: message,
        type: type,
        duration: duration,
        actionLabel: actionLabel,
        onAction: onAction,
        onDismiss: () {
          _currentEntry?.remove();
          _currentEntry = null;
        },
      ),
    );

    overlay.insert(_currentEntry!);
  }

  /// Show success toast.
  static void success(BuildContext context, String message) {
    show(
      context: context,
      message: message,
      type: ToastType.success,
    );
  }

  /// Show error toast.
  static void error(BuildContext context, String message) {
    show(
      context: context,
      message: message,
      type: ToastType.error,
      duration: const Duration(seconds: 4),
    );
  }

  /// Show warning toast.
  static void warning(BuildContext context, String message) {
    show(
      context: context,
      message: message,
      type: ToastType.warning,
    );
  }

  /// Show info toast.
  static void info(BuildContext context, String message) {
    show(
      context: context,
      message: message,
      type: ToastType.info,
    );
  }

  /// Show toast with action.
  static void withAction(
    BuildContext context,
    String message,
    String actionLabel,
    VoidCallback onAction, {
    ToastType type = ToastType.info,
  }) {
    show(
      context: context,
      message: message,
      type: type,
      actionLabel: actionLabel,
      onAction: onAction,
      duration: const Duration(seconds: 5),
    );
  }
}

class _ToastWidget extends StatefulWidget {
  const _ToastWidget({
    required this.message,
    required this.type,
    required this.duration,
    required this.onDismiss,
    this.actionLabel,
    this.onAction,
  });

  final String message;
  final ToastType type;
  final Duration duration;
  final VoidCallback onDismiss;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  State<_ToastWidget> createState() => _ToastWidgetState();
}

class _ToastWidgetState extends State<_ToastWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, -0.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    ));

    _controller.forward();

    // Auto dismiss
    Future.delayed(widget.duration, () {
      if (mounted) {
        _dismiss();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _dismiss() {
    _controller.reverse().then((_) {
      widget.onDismiss();
    });
  }

  @override
  Widget build(BuildContext context) {
    final dark = isDark(context);
    final typeConfig = _getTypeConfig(widget.type);

    return Positioned(
      top: MediaQuery.of(context).padding.top + 16,
      left: 16,
      right: 16,
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: SlideTransition(
          position: _slideAnimation,
          child: GestureDetector(
            onTap: _dismiss,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: dark ? Palette.surface1 : Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: typeConfig.color.withValues(alpha: 0.3),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.15),
                    blurRadius: 16,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  // Icon
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: typeConfig.color.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      typeConfig.icon,
                      size: 18,
                      color: typeConfig.color,
                    ),
                  ),
                  const SizedBox(width: 12),

                  // Message
                  Expanded(
                    child: Text(
                      widget.message,
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: dark ? Palette.textPrimary : Palette.textInverse,
                      ),
                    ),
                  ),

                  // Action
                  if (widget.actionLabel != null)
                    GestureDetector(
                      onTap: () {
                        widget.onAction?.call();
                        _dismiss();
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8),
                        child: Text(
                          widget.actionLabel!,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: typeConfig.color,
                          ),
                        ),
                      ),
                    ),

                  // Close
                  GestureDetector(
                    onTap: _dismiss,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: Icon(
                        Icons.close,
                        size: 16,
                        color: dark ? Palette.textTertiary : Palette.textSecondary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  _TypeConfig _getTypeConfig(ToastType type) {
    switch (type) {
      case ToastType.success:
        return _TypeConfig(
          color: Palette.success,
          icon: Icons.check_circle,
        );
      case ToastType.error:
        return _TypeConfig(
          color: Palette.error,
          icon: Icons.error,
        );
      case ToastType.warning:
        return _TypeConfig(
          color: Palette.warning,
          icon: Icons.warning,
        );
      case ToastType.info:
        return _TypeConfig(
          color: Palette.info,
          icon: Icons.info_outline,
        );
    }
  }
}

class _TypeConfig {
  final Color color;
  final IconData icon;

  const _TypeConfig({required this.color, required this.icon});
}
