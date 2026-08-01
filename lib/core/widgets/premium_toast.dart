import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:profileforge/core/theme/app_theme.dart';

/// Premium toast notification widget.
/// Shows a glass card with icon, title, and optional subtitle.
/// Auto-dismisses after [duration].
class PremiumToast {
  static OverlayEntry? _currentEntry;

  static void show(
    BuildContext context, {
    required String message,
    String? subtitle,
    required IconData icon,
    Color? iconColor,
    Duration duration = const Duration(seconds: 2),
  }) {
    _currentEntry?.remove();
    _currentEntry = OverlayEntry(
      builder: (ctx) => Positioned(
        top: MediaQuery.of(ctx).padding.top + 16,
        left: 20,
        right: 20,
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.95),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 20,
                  spreadRadius: 0,
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: (iconColor ?? Palette.primary).withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Icon(icon, size: 18, color: iconColor ?? Palette.primary),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        message,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: Palette.textPrimary,
                        ),
                      ),
                      if (subtitle != null)
                        Text(
                          subtitle,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Palette.textSecondary,
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ).animate().fadeIn(duration: 200.ms).slideY(begin: -0.3),
        ),
      ),
    );

    Overlay.of(context).insert(_currentEntry!);

    Future.delayed(duration, () {
      _currentEntry?.animate().fadeIn(duration: 200.ms).then((_) {
        _currentEntry?.remove();
        _currentEntry = null;
      });
    });
  }
}
