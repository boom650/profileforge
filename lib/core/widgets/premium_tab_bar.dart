import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:profileforge/core/theme/app_theme.dart';

/// ────────────────────────────────────────────────────────────────────────────
/// PremiumTabBar — Animated segmented tab bar.
///
/// Features:
/// - Animated indicator
/// - Haptic feedback on tap
/// - Badge support
/// - Customizable colors
/// ────────────────────────────────────────────────────────────────────────────
class PremiumTabBar extends StatelessWidget {
  const PremiumTabBar({
    super.key,
    required this.tabs,
    required this.selectedIndex,
    required this.onTap,
    this.badges,
    this.height = 44,
    this.borderRadius = 12,
  });

  final List<String> tabs;
  final int selectedIndex;
  final ValueChanged<int> onTap;
  final List<int?>? badges;
  final double height;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    final dark = isDark(context);

    return Container(
      height: height,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: dark
            ? Palette.surface2.withValues(alpha: 0.5)
            : const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final tabWidth = constraints.maxWidth / tabs.length;

          return Stack(
            children: [
              // Animated indicator
              AnimatedPositioned(
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeOutCubic,
                left: tabWidth * selectedIndex,
                top: 0,
                width: tabWidth,
                height: constraints.maxHeight,
                child: Container(
                  decoration: BoxDecoration(
                    color: dark ? Palette.surface1 : Colors.white,
                    borderRadius: BorderRadius.circular(borderRadius - 4),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.08),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                ),
              ),

              // Tabs
              Row(
                children: List.generate(tabs.length, (i) {
                  final isSelected = i == selectedIndex;
                  final badgeCount = badges != null && i < badges!.length
                      ? badges![i]
                      : null;

                  return GestureDetector(
                    onTap: () {
                      HapticFeedback.selectionClick();
                      onTap(i);
                    },
                    child: SizedBox(
                      width: tabWidth,
                      height: constraints.maxHeight,
                      child: Center(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              tabs[i],
                              style: GoogleFonts.inter(
                                fontSize: 13,
                                fontWeight:
                                    isSelected ? FontWeight.w600 : FontWeight.w500,
                                color: isSelected
                                    ? (dark
                                        ? Palette.textPrimary
                                        : Palette.textInverse)
                                    : (dark
                                        ? Palette.textTertiary
                                        : Palette.textSecondary),
                              ),
                            ),
                            if (badgeCount != null && badgeCount > 0) ...[
                              const SizedBox(width: 4),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: Palette.primary,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  '$badgeCount',
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ],
          );
        },
      ),
    );
  }
}

/// PillTabBar — Pill-shaped tab selector.
class PillTabBar extends StatelessWidget {
  const PillTabBar({
    super.key,
    required this.tabs,
    required this.selectedIndex,
    required this.onTap,
    this.height = 36,
  });

  final List<String> tabs;
  final int selectedIndex;
  final ValueChanged<int> onTap;
  final double height;

  @override
  Widget build(BuildContext context) {
    final dark = isDark(context);

    return SizedBox(
      height: height,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: tabs.length,
        itemBuilder: (context, i) {
          final isSelected = i == selectedIndex;

          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: GestureDetector(
              onTap: () {
                HapticFeedback.selectionClick();
                onTap(i);
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: isSelected
                      ? Palette.primary
                      : (dark
                          ? Palette.surface2.withValues(alpha: 0.5)
                          : const Color(0xFFF1F5F9)),
                  borderRadius: BorderRadius.circular(height / 2),
                  border: Border.all(
                    color: isSelected
                        ? Palette.primary
                        : (dark
                            ? Palette.border.withValues(alpha: 0.3)
                            : const Color(0xFFE2E8F0)),
                  ),
                ),
                child: Center(
                  child: Text(
                    tabs[i],
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                      color: isSelected
                          ? Colors.white
                          : (dark
                              ? Palette.textSecondary
                              : Palette.textTertiary),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

/// IconTabBar — Tab bar with icons and labels.
class IconTabBar extends StatelessWidget {
  const IconTabBar({
    super.key,
    required this.items,
    required this.selectedIndex,
    required this.onTap,
  });

  final List<IconTabItem> items;
  final int selectedIndex;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    final dark = isDark(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: List.generate(items.length, (i) {
        final item = items[i];
        final isSelected = i == selectedIndex;

        return GestureDetector(
          onTap: () {
            HapticFeedback.selectionClick();
            onTap(i);
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: isSelected
                  ? Palette.primary.withValues(alpha: 0.12)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Icon(
                  item.icon,
                  size: 20,
                  color: isSelected
                      ? Palette.primary
                      : (dark ? Palette.textTertiary : Palette.textSecondary),
                ),
                if (isSelected) ...[
                  const SizedBox(width: 6),
                  Text(
                    item.label,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Palette.primary,
                    ),
                  ),
                ],
              ],
            ),
          ),
        );
      }),
    );
  }
}

class IconTabItem {
  final IconData icon;
  final String label;

  const IconTabItem({required this.icon, required this.label});
}
