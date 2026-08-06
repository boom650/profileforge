import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:profileforge/core/theme/app_theme.dart';

/// ────────────────────────────────────────────────────────────────────────────
/// ProfileForge Avatar Widgets — Premium avatar components.
/// ────────────────────────────────────────────────────────────────────────────

/// PfAvatar — Premium avatar with fallback initials.
class PfAvatar extends StatelessWidget {
  const PfAvatar({
    super.key,
    this.imageUrl,
    required this.name,
    this.size = 48,
    this.backgroundColor,
    this.textColor,
    this.borderColor,
    this.borderWidth = 2,
  });

  final String? imageUrl;
  final String name;
  final double size;
  final Color? backgroundColor;
  final Color? textColor;
  final Color? borderColor;
  final double borderWidth;

  @override
  Widget build(BuildContext context) {
    final dark = isDark(context);
    final bgColor = backgroundColor ?? Palette.primary;
    final txtColor = textColor ?? Colors.white;
    final initials = _getInitials(name);

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: borderColor != null
            ? Border.all(color: borderColor!, width: borderWidth)
            : null,
      ),
      child: ClipOval(
        child: imageUrl != null && imageUrl!.isNotEmpty
            ? Image.network(
                imageUrl!,
                width: size,
                height: size,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => _buildInitials(bgColor, txtColor, initials),
              )
            : _buildInitials(bgColor, txtColor, initials),
      ),
    );
  }

  Widget _buildInitials(Color bgColor, Color txtColor, String initials) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [bgColor, bgColor.withValues(alpha: 0.8)],
        ),
      ),
      child: Center(
        child: Text(
          initials,
          style: GoogleFonts.inter(
            fontSize: size * 0.38,
            fontWeight: FontWeight.w700,
            color: txtColor,
          ),
        ),
      ),
    );
  }

  String _getInitials(String name) {
    final words = name.trim().split(RegExp(r'\s+'));
    if (words.isEmpty) return '?';
    if (words.length == 1) return words[0][0].toUpperCase();
    return '${words[0][0]}${words[1][0]}'.toUpperCase();
  }
}

/// PfAvatarGroup — Overlapping avatar group.
class PfAvatarGroup extends StatelessWidget {
  const PfAvatarGroup({
    super.key,
    required this.avatars,
    this.maxVisible = 4,
    this.size = 36,
    this.spacing = 8,
  });

  final List<PfAvatar> avatars;
  final int maxVisible;
  final double size;
  final double spacing;

  @override
  Widget build(BuildContext context) {
    final visible = avatars.take(maxVisible).toList();
    final remaining = avatars.length - maxVisible;

    return SizedBox(
      height: size,
      child: Stack(
        children: [
          ...visible.asMap().entries.map((entry) {
            final index = entry.key;
            final avatar = entry.value;

            return Positioned(
              left: index * (size - spacing),
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isDark(context) ? Palette.surface0 : Colors.white,
                    width: 2,
                  ),
                ),
                child: avatar,
              ),
            );
          }),
          if (remaining > 0)
            Positioned(
              left: visible.length * (size - spacing),
              child: Container(
                width: size,
                height: size,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Palette.surface2,
                  border: Border.all(
                    color: isDark(context) ? Palette.surface0 : Colors.white,
                    width: 2,
                  ),
                ),
                child: Center(
                  child: Text(
                    '+$remaining',
                    style: TextStyle(
                      fontSize: size * 0.3,
                      fontWeight: FontWeight.w600,
                      color: Palette.textTertiary,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// PfAvatarWithStatus — Avatar with online/offline status dot.
class PfAvatarWithStatus extends StatelessWidget {
  const PfAvatarWithStatus({
    super.key,
    this.imageUrl,
    required this.name,
    this.size = 48,
    required this.status,
  });

  final String? imageUrl;
  final String name;
  final double size;
  final PfAvatarStatus status;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        PfAvatar(
          imageUrl: imageUrl,
          name: name,
          size: size,
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: Container(
            width: size * 0.3,
            height: size * 0.3,
            decoration: BoxDecoration(
              color: _getStatusColor(),
              shape: BoxShape.circle,
              border: Border.all(
                color: isDark(context) ? Palette.surface0 : Colors.white,
                width: 2,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Color _getStatusColor() {
    switch (status) {
      case PfAvatarStatus.online:
        return Palette.success;
      case PfAvatarStatus.offline:
        return Palette.textTertiary;
      case PfAvatarStatus.away:
        return Palette.warning;
      case PfAvatarStatus.busy:
        return Palette.error;
    }
  }
}

enum PfAvatarStatus { online, offline, away, busy }
