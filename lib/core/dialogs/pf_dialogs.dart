import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:profileforge/core/theme/app_theme.dart';

/// ────────────────────────────────────────────────────────────────────────────
/// ProfileForge Dialog Utilities — Premium dialog components.
/// ────────────────────────────────────────────────────────────────────────────

class PfDialogs {
  PfDialogs._();

  /// Show a premium alert dialog.
  static Future<T?> show<T>(
    BuildContext context, {
    required String title,
    required String content,
    String? confirmText,
    String? cancelText,
    VoidCallback? onConfirm,
    VoidCallback? onCancel,
    bool barrierDismissible = true,
  }) {
    final dark = Theme.of(context).brightness == Brightness.dark;

    return showDialog<T>(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (ctx) => AlertDialog(
        backgroundColor: dark ? Palette.surface1 : Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          title,
          style: GoogleFonts.inter(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: dark ? Palette.textPrimary : Palette.textInverse,
          ),
        ),
        content: Text(
          content,
          style: GoogleFonts.inter(
            fontSize: 14,
            color: dark ? Palette.textSecondary : Palette.textTertiary,
            height: 1.5,
          ),
        ),
        actions: [
          if (cancelText != null)
            TextButton(
              onPressed: () {
                onCancel?.call();
                Navigator.pop(ctx);
              },
              child: Text(
                cancelText,
                style: GoogleFonts.inter(
                  color: dark ? Palette.textSecondary : Palette.textTertiary,
                ),
              ),
            ),
          if (confirmText != null)
            TextButton(
              onPressed: () {
                onConfirm?.call();
                Navigator.pop(ctx);
              },
              child: Text(
                confirmText,
                style: GoogleFonts.inter(
                  fontWeight: FontWeight.w600,
                  color: Palette.primary,
                ),
              ),
            ),
        ],
      ),
    );
  }

  /// Show a confirmation dialog.
  static Future<bool?> showConfirm(
    BuildContext context, {
    required String title,
    required String content,
    String confirmText = 'Confirm',
    String cancelText = 'Cancel',
    Color? confirmColor,
  }) {
    final dark = Theme.of(context).brightness == Brightness.dark;

    return showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: dark ? Palette.surface1 : Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          title,
          style: GoogleFonts.inter(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: dark ? Palette.textPrimary : Palette.textInverse,
          ),
        ),
        content: Text(
          content,
          style: GoogleFonts.inter(
            fontSize: 14,
            color: dark ? Palette.textSecondary : Palette.textTertiary,
            height: 1.5,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(
              cancelText,
              style: GoogleFonts.inter(
                color: dark ? Palette.textSecondary : Palette.textTertiary,
              ),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(
              confirmText,
              style: GoogleFonts.inter(
                fontWeight: FontWeight.w600,
                color: confirmColor ?? Palette.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Show a destructive confirmation dialog.
  static Future<bool?> showDestructive(
    BuildContext context, {
    required String title,
    required String content,
    String confirmText = 'Delete',
    String cancelText = 'Cancel',
  }) {
    return showConfirm(
      context,
      title: title,
      content: content,
      confirmText: confirmText,
      cancelText: cancelText,
      confirmColor: Palette.error,
    );
  }

  /// Show a bottom sheet dialog.
  static Future<T?> showBottom<T>(
    BuildContext context, {
    required Widget child,
    bool isScrollControlled = true,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: isScrollControlled,
      backgroundColor: Colors.transparent,
      builder: (_) => child,
    );
  }

  /// Show loading dialog.
  static void showLoading(BuildContext context, {String? message}) {
    final dark = Theme.of(context).brightness == Brightness.dark;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        backgroundColor: dark ? Palette.surface1 : Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(color: Palette.primary),
            if (message != null) ...[
              const SizedBox(height: 16),
              Text(
                message,
                style: GoogleFonts.inter(
                  fontSize: 14,
                  color: dark ? Palette.textSecondary : Palette.textTertiary,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  /// Dismiss loading dialog.
  static void dismissLoading(BuildContext context) {
    Navigator.of(context, rootNavigator: true).pop();
  }
}
