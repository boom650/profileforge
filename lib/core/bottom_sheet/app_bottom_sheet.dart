import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:profileforge/core/theme/app_theme.dart';

/// ────────────────────────────────────────────────────────────────────────────
/// ProfileForge Bottom Sheet System — Premium modal bottom sheets.
///
/// Based on research:
/// - 12-uiux-dark-mode-responsive-mobile.md
/// - 12-uiux-animation-motion-design.md
/// ────────────────────────────────────────────────────────────────────────────

/// showAppBottomSheet — Show a premium bottom sheet.
Future<T?> showAppBottomSheet<T>({
  required BuildContext context,
  required Widget child,
  String? title,
  bool isScrollControlled = true,
  bool showDragHandle = true,
  bool isDismissible = true,
  bool enableDrag = true,
}) {
  return showModalBottomSheet<T>(
    context: context,
    isScrollControlled: isScrollControlled,
    isDismissible: isDismissible,
    enableDrag: enableDrag,
    backgroundColor: Colors.transparent,
    builder: (context) {
      return _AppBottomSheet(
        title: title,
        showDragHandle: showDragHandle,
        child: child,
      );
    },
  );
}

class _AppBottomSheet extends StatelessWidget {
  const _AppBottomSheet({
    required this.child,
    this.title,
    this.showDragHandle = true,
  });

  final Widget child;
  final String? title;
  final bool showDragHandle;

  @override
  Widget build(BuildContext context) {
    final dark = isDark(context);
    final bottomPadding = MediaQuery.of(context).viewInsets.bottom;

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.85,
      ),
      margin: EdgeInsets.only(bottom: bottomPadding),
      decoration: BoxDecoration(
        color: dark ? Palette.surface1 : Colors.white,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(24),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // ── Drag Handle ──
          if (showDragHandle)
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: dark
                      ? Palette.textTertiary.withValues(alpha: 0.3)
                      : Palette.line,
                  borderRadius: BorderRadius.circular(9999),
                ),
              ),
            ),

          // ── Title ──
          if (title != null)
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      title!,
                      style: GoogleFonts.nunito(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: dark ? Palette.textPrimary : Palette.textInverse,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: dark ? Palette.surface2 : const Color(0xFFF4ECE1),
                        borderRadius: BorderRadius.circular(9999),
                      ),
                      child: Icon(
                        Icons.close,
                        size: 18,
                        color: dark ? Palette.textPrimary : Palette.textInverse,
                      ),
                    ),
                  ),
                ],
              ),
            ),

          // ── Content ──
          Flexible(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
              child: child,
            ),
          ),
        ],
      ),
    );
  }
}

/// ConfirmationBottomSheet — Confirm/deny action.
Future<bool> showConfirmationBottomSheet({
  required BuildContext context,
  required String title,
  required String message,
  String confirmLabel = 'Confirm',
  String cancelLabel = 'Cancel',
  Color confirmColor = Palette.primary,
  IconData? icon,
}) async {
  final result = await showAppBottomSheet<bool>(
    context: context,
    title: title,
    child: Column(
      children: [
        if (icon != null) ...[
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: confirmColor.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 28, color: confirmColor),
          ),
          const SizedBox(height: 16),
        ],
        Text(
          message,
          style: GoogleFonts.nunito(
            fontSize: 14,
            color: isDark(context) ? Palette.textSecondary : Palette.textTertiary,
            height: 1.5,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 24),
        Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () => Navigator.pop(context, false),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  decoration: BoxDecoration(
                    color: isDark(context) ? Palette.surface2 : const Color(0xFFF4ECE1),
                    borderRadius: BorderRadius.circular(9999),
                  ),
                  child: Center(
                    child: Text(
                      cancelLabel,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: isDark(context) ? Palette.textPrimary : Palette.textInverse,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: GestureDetector(
                onTap: () => Navigator.pop(context, true),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  decoration: BoxDecoration(
                    gradient: confirmColor == Palette.error
                        ? null
                        : Palette.gradientPrimary,
                    color: confirmColor == Palette.error ? confirmColor : null,
                    borderRadius: BorderRadius.circular(9999),
                  ),
                  child: Center(
                    child: Text(
                      confirmLabel,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    ),
  );

  return result ?? false;
}

/// SelectionBottomSheet — Select from a list of options.
Future<T?> showSelectionBottomSheet<T>({
  required BuildContext context,
  required String title,
  required List<SelectionOption<T>> options,
  T? selectedValue,
}) {
  return showAppBottomSheet<T>(
    context: context,
    title: title,
    child: Column(
      children: options.map((option) {
        final isSelected = option.value == selectedValue;

        return GestureDetector(
          onTap: () {
            HapticFeedback.selectionClick();
            Navigator.pop(context, option.value);
          },
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 14),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: isDark(context)
                      ? Palette.border.withValues(alpha: 0.3)
                      : const Color(0xFFEDE3D6),
                ),
              ),
            ),
            child: Row(
              children: [
                if (option.icon != null) ...[
                  Icon(
                    option.icon,
                    size: 20,
                    color: isSelected
                        ? Palette.primary
                        : (isDark(context) ? Palette.textSecondary : Palette.textTertiary),
                  ),
                  const SizedBox(width: 12),
                ],
                Expanded(
                  child: Text(
                    option.label,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                      color: isSelected
                          ? Palette.primary
                          : (isDark(context) ? Palette.textPrimary : Palette.textInverse),
                    ),
                  ),
                ),
                if (isSelected)
                  Icon(Icons.check, size: 20, color: Palette.primary),
              ],
            ),
          ),
        );
      }).toList(),
    ),
  );
}

class SelectionOption<T> {
  final T value;
  final String label;
  final IconData? icon;

  const SelectionOption({
    required this.value,
    required this.label,
    this.icon,
  });
}
