import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:profileforge/core/theme/app_theme.dart';

/// ────────────────────────────────────────────────────────────────────────────
/// ProfileForge Notification Components — Notification badge & list.
/// ────────────────────────────────────────────────────────────────────────────

/// NotificationBadge — Floating notification badge.
class NotificationBadge extends StatelessWidget {
  const NotificationBadge({
    super.key,
    required this.count,
    this.child,
    this.visible = true,
  });

  final int count;
  final Widget? child;
  final bool visible;

  @override
  Widget build(BuildContext context) {
    if (!visible || count <= 0) return child ?? const SizedBox.shrink();

    return Stack(
      clipBehavior: Clip.none,
      children: [
        child ?? const SizedBox.shrink(),
        Positioned(
          top: -4,
          right: -4,
          child: Container(
            constraints: const BoxConstraints(minWidth: 18, minHeight: 18),
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
            decoration: BoxDecoration(
              color: Palette.error,
              shape: BoxShape.circle,
              border: Border.all(
                color: isDark(context) ? Palette.surface0 : Colors.white,
                width: 2,
              ),
              boxShadow: [
                BoxShadow(
                  color: Palette.error.withValues(alpha: 0.3),
                  blurRadius: 4,
                ),
              ],
            ),
            child: Center(
              child: Text(
                count > 99 ? '99+' : '$count',
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
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

/// NotificationDot — Simple dot indicator.
class NotificationDot extends StatelessWidget {
  const NotificationDot({
    super.key,
    this.visible = true,
    this.color,
    this.size = 8,
  });

  final bool visible;
  final Color? color;
  final double size;

  @override
  Widget build(BuildContext context) {
    if (!visible) return const SizedBox.shrink();

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color ?? Palette.error,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: (color ?? Palette.error).withValues(alpha: 0.4),
            blurRadius: 4,
          ),
        ],
      ),
    );
  }
}

/// NotificationItem — Single notification list item.
class NotificationItem extends StatelessWidget {
  const NotificationItem({
    super.key,
    required this.title,
    required this.body,
    this.time,
    this.icon,
    this.isRead = false,
    this.onTap,
  });

  final String title;
  final String body;
  final String? time;
  final IconData? icon;
  final bool isRead;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isRead
              ? Colors.transparent
              : Palette.primary.withValues(alpha: 0.03),
          border: Border(
            bottom: BorderSide(
              color: dark
                  ? Palette.border.withValues(alpha: 0.3)
                  : const Color(0xFFF1F5F9),
            ),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Icon
            if (icon != null) ...[
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: Palette.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, size: 18, color: Palette.primary),
              ),
              const SizedBox(width: 12),
            ],

            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      if (!isRead)
                        Container(
                          width: 6,
                          height: 6,
                          margin: const EdgeInsets.only(right: 6),
                          decoration: BoxDecoration(
                            color: Palette.primary,
                            shape: BoxShape.circle,
                          ),
                        ),
                      Expanded(
                        child: Text(
                          title,
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            fontWeight: isRead ? FontWeight.w500 : FontWeight.w600,
                            color: dark
                                ? Palette.textPrimary
                                : Palette.textInverse,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    body,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      color: dark ? Palette.textSecondary : Palette.textTertiary,
                    ),
                  ),
                  if (time != null) ...[
                    const SizedBox(height: 6),
                    Text(
                      time!,
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        color: dark ? Palette.textTertiary : Palette.textSecondary,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
