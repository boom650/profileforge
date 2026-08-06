import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:profileforge/core/theme/app_theme.dart';

/// ────────────────────────────────────────────────────────────────────────────
/// SettingsItem — Reusable settings row with icon, label, and action.
///
/// Supports:
/// - Icon + label + value/trailing
/// - Toggle switch
/// - Chevron navigation
/// - Destructive style
/// ────────────────────────────────────────────────────────────────────────────
class SettingsItem extends StatelessWidget {
  const SettingsItem({
    super.key,
    required this.icon,
    required this.label,
    this.subtitle,
    this.value,
    this.trailing,
    this.onTap,
    this.destructive = false,
    this.enabled = true,
  });

  final IconData icon;
  final String label;
  final String? subtitle;
  final String? value;
  final Widget? trailing;
  final VoidCallback? onTap;
  final bool destructive;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final dark = isDark(context);
    final color = destructive
        ? Palette.error
        : (dark ? Palette.textPrimary : Palette.textInverse);
    final subColor = dark ? Palette.textTertiary : Palette.textSecondary;

    return GestureDetector(
      onTap: enabled ? onTap : null,
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            // Icon
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: destructive
                    ? Palette.error.withValues(alpha: 0.1)
                    : Palette.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                icon,
                size: 18,
                color: destructive ? Palette.error : Palette.primary,
              ),
            ),
            const SizedBox(width: 14),

            // Label + subtitle
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: GoogleFonts.inter(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: enabled ? color : subColor,
                    ),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      subtitle!,
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: subColor,
                      ),
                    ),
                  ],
                ],
              ),
            ),

            // Value or trailing
            if (trailing != null)
              trailing!
            else if (value != null)
              Text(
                value!,
                style: GoogleFonts.inter(
                  fontSize: 14,
                  color: subColor,
                ),
              ),

            // Chevron
            if (onTap != null && trailing == null && value == null) ...[
              const SizedBox(width: 8),
              Icon(
                Icons.chevron_right,
                size: 18,
                color: dark ? Palette.textTertiary : Palette.textSecondary,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// SettingsToggle — Settings row with a toggle switch.
class SettingsToggle extends StatelessWidget {
  const SettingsToggle({
    super.key,
    required this.icon,
    required this.label,
    this.subtitle,
    required this.value,
    required this.onChanged,
    this.destructive = false,
  });

  final IconData icon;
  final String label;
  final String? subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;
  final bool destructive;

  @override
  Widget build(BuildContext context) {
    final dark = isDark(context);
    final color = destructive
        ? Palette.error
        : (dark ? Palette.textPrimary : Palette.textInverse);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: destructive
                  ? Palette.error.withValues(alpha: 0.1)
                  : Palette.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              icon,
              size: 18,
              color: destructive ? Palette.error : Palette.primary,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: GoogleFonts.inter(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: color,
                  ),
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    subtitle!,
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: dark ? Palette.textTertiary : Palette.textSecondary,
                    ),
                  ),
                ],
              ],
            ),
          ),
          Transform.scale(
            scale: 0.85,
            child: Switch(
              value: value,
              onChanged: onChanged,
              activeColor: Colors.white,
              activeTrackColor: Palette.primary,
              inactiveThumbColor: dark ? Palette.surface1 : Colors.white,
              inactiveTrackColor: dark ? Palette.surface2 : const Color(0xFFE2E8F0),
            ),
          ),
        ],
      ),
    );
  }
}

/// SettingsSection — Section header for settings.
class SettingsSection extends StatelessWidget {
  const SettingsSection({
    super.key,
    required this.title,
    required this.children,
  });

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final dark = isDark(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
          child: Text(
            title.toUpperCase(),
            style: GoogleFonts.inter(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.2,
              color: dark ? Palette.textTertiary : Palette.textSecondary,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: dark
                ? Palette.surface1.withValues(alpha: 0.7)
                : Colors.white.withValues(alpha: 0.9),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: dark
                  ? Palette.border.withValues(alpha: 0.3)
                  : const Color(0xFFE2E8F0),
            ),
          ),
          child: Column(
            children: List.generate(children.length * 2 - 1, (i) {
              if (i.isOdd) {
                return Divider(
                  height: 1,
                  indent: 66,
                  color: dark
                      ? Palette.border.withValues(alpha: 0.3)
                      : const Color(0xFFF1F5F9),
                );
              }
              return children[i ~/ 2];
            }),
          ),
        ),
      ],
    );
  }
}
