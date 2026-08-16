import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:profileforge/core/theme/app_theme.dart';

/// ────────────────────────────────────────────────────────────────────────────
/// ProfileForge Chip & Tag Widgets — Premium chip/tag components.
/// ────────────────────────────────────────────────────────────────────────────

/// PfChip — Custom styled chip.
class PfChip extends StatelessWidget {
  const PfChip({
    super.key,
    required this.label,
    this.icon,
    this.onTap,
    this.onDelete,
    this.selected = false,
    this.color,
    this.size = PfChipSize.medium,
  });

  final String label;
  final IconData? icon;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;
  final bool selected;
  final Color? color;
  final PfChipSize size;

  @override
  Widget build(BuildContext context) {
    final dark = isDark(context);
    final chipColor = color ?? Palette.primary;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: _getPadding(),
        decoration: BoxDecoration(
          color: selected
              ? chipColor.withValues(alpha: 0.12)
              : (dark ? Palette.surface2 : const Color(0xFFF4ECE1)),
          borderRadius: BorderRadius.circular(_getBorderRadius()),
          border: Border.all(
            color: selected
                ? chipColor.withValues(alpha: 0.3)
                : (dark
                    ? Palette.border.withValues(alpha: 0.3)
                    : const Color(0xFFEDE3D6)),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(
                icon,
                size: _getIconSize(),
                color: selected ? chipColor : Palette.textTertiary,
              ),
              const SizedBox(width: 4),
            ],
            Text(
              label,
              style: GoogleFonts.nunito(
                fontSize: _getFontSize(),
                fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
                color: selected
                    ? chipColor
                    : (dark ? Palette.textSecondary : Palette.textTertiary),
              ),
            ),
            if (onDelete != null) ...[
              const SizedBox(width: 4),
              GestureDetector(
                onTap: onDelete,
                child: Icon(
                  Icons.close,
                  size: 14,
                  color: dark ? Palette.textTertiary : Palette.textSecondary,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  EdgeInsets _getPadding() {
    switch (size) {
      case PfChipSize.small:
        return const EdgeInsets.symmetric(horizontal: 8, vertical: 4);
      case PfChipSize.medium:
        return const EdgeInsets.symmetric(horizontal: 12, vertical: 6);
      case PfChipSize.large:
        return const EdgeInsets.symmetric(horizontal: 16, vertical: 8);
    }
  }

  double _getBorderRadius() {
    switch (size) {
      case PfChipSize.small:
        return 8;
      case PfChipSize.medium:
        return 10;
      case PfChipSize.large:
        return 12;
    }
  }

  double _getIconSize() {
    switch (size) {
      case PfChipSize.small:
        return 14;
      case PfChipSize.medium:
        return 16;
      case PfChipSize.large:
        return 18;
    }
  }

  double _getFontSize() {
    switch (size) {
      case PfChipSize.small:
        return 11;
      case PfChipSize.medium:
        return 13;
      case PfChipSize.large:
        return 15;
    }
  }
}

enum PfChipSize { small, medium, large }

/// Badge — Notification badge.
class PfBadge extends StatelessWidget {
  const PfBadge({
    super.key,
    required this.child,
    this.count,
    this.showDot = false,
    this.color,
    this.textColor,
  });

  final Widget child;
  final int? count;
  final bool showDot;
  final Color? color;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        child,
        if (showDot || (count != null && count! > 0))
          Positioned(
            top: -4,
            right: -4,
            child: Container(
              constraints: const BoxConstraints(minWidth: 18, minHeight: 18),
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
              decoration: BoxDecoration(
                color: color ?? Palette.error,
                shape: BoxShape.circle,
                border: Border.all(
                  color: isDark(context) ? Palette.surface0 : Colors.white,
                  width: 2,
                ),
              ),
              child: Center(
                child: showDot
                    ? const SizedBox(width: 6, height: 6)
                    : Text(
                        '${count!}',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: textColor ?? Colors.white,
                          height: 1,
                        ),
                      ),
              ),
            ),
          ),
      ],
    );
  }
}

/// Tag — Colored tag with text.
class PfTag extends StatelessWidget {
  const PfTag({
    super.key,
    required this.label,
    this.color,
    this.textColor,
    this.size = PfChipSize.medium,
  });

  final String label;
  final Color? color;
  final Color? textColor;
  final PfChipSize size;

  @override
  Widget build(BuildContext context) {
    final tagColor = color ?? Palette.primary;
    final tagTextColor = textColor ?? Colors.white;

    return Container(
      padding: _getPadding(),
      decoration: BoxDecoration(
        color: tagColor,
        borderRadius: BorderRadius.circular(_getBorderRadius()),
      ),
      child: Text(
        label,
        style: GoogleFonts.nunito(
          fontSize: _getFontSize(),
          fontWeight: FontWeight.w600,
          color: tagTextColor,
        ),
      ),
    );
  }

  EdgeInsets _getPadding() {
    switch (size) {
      case PfChipSize.small:
        return const EdgeInsets.symmetric(horizontal: 6, vertical: 2);
      case PfChipSize.medium:
        return const EdgeInsets.symmetric(horizontal: 8, vertical: 4);
      case PfChipSize.large:
        return const EdgeInsets.symmetric(horizontal: 12, vertical: 6);
    }
  }

  double _getBorderRadius() {
    switch (size) {
      case PfChipSize.small:
        return 6;
      case PfChipSize.medium:
        return 8;
      case PfChipSize.large:
        return 10;
    }
  }

  double _getFontSize() {
    switch (size) {
      case PfChipSize.small:
        return 10;
      case PfChipSize.medium:
        return 12;
      case PfChipSize.large:
        return 14;
    }
  }
}
