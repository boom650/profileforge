import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:profileforge/core/theme/app_theme.dart';

/// ────────────────────────────────────────────────────────────────────────────
/// PremiumErrorWidget — Reusable error state with retry button.
/// Premium look with icon, message, and retry CTA.
/// ────────────────────────────────────────────────────────────────────────────
class PremiumErrorWidget extends StatelessWidget {
  final String message;
  final String? title;
  final IconData icon;
  final VoidCallback? onRetry;
  final String retryLabel;

  const PremiumErrorWidget({
    super.key,
    this.message = 'Something went wrong',
    this.title,
    this.icon = Icons.error_outline_rounded,
    this.onRetry,
    this.retryLabel = 'Try Again',
  });

  /// Network error variant
  factory PremiumErrorWidget.network({VoidCallback? onRetry}) {
    return PremiumErrorWidget(
      icon: Icons.wifi_off_rounded,
      title: 'No Connection',
      message: 'Check your internet and try again',
      onRetry: onRetry,
    );
  }

  /// Empty state variant
  factory PremiumErrorWidget.empty({
    String? title,
    String? message,
    IconData icon = Icons.inbox_outlined,
    VoidCallback? onRetry,
  }) {
    return PremiumErrorWidget(
      icon: icon,
      title: title ?? 'Nothing here yet',
      message: message ?? 'Start by completing some activities',
      onRetry: onRetry,
    );
  }

  /// Permission error variant
  factory PremiumErrorWidget.permission({VoidCallback? onRetry}) {
    return PremiumErrorWidget(
      icon: Icons.lock_outline_rounded,
      title: 'Permission Required',
      message: 'Grant permissions to use this feature',
      onRetry: onRetry,
      retryLabel: 'Open Settings',
    );
  }

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icon with glow
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: Palette.error.withValues(alpha: 0.1),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Palette.error.withValues(alpha: 0.15),
                    blurRadius: 20,
                    spreadRadius: 4,
                  ),
                ],
              ),
              child: Icon(icon, color: Palette.error, size: 32),
            )
                .animate()
                .scale(
                  duration: 400.ms,
                  curve: Curves.elasticOut,
                ),

            const SizedBox(height: 20),

            // Title
            if (title != null)
              Text(
                title!,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: dark ? Palette.textPrimary : Palette.textInverse,
                ),
              ).animate().fadeIn(delay: 100.ms),

            const SizedBox(height: 8),

            // Message
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: dark ? Palette.textSecondary : Palette.textTertiary,
                height: 1.5,
              ),
            ).animate().fadeIn(delay: 200.ms),

            // Retry button
            if (onRetry != null) ...[
              const SizedBox(height: 24),
              GestureDetector(
                onTap: onRetry,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 24, vertical: 12),
                  decoration: BoxDecoration(
                    gradient: Palette.gradientPrimary,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Palette.primary.withValues(alpha: 0.3),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Text(
                    retryLabel,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                    ),
                  ),
                ),
              ).animate().fadeIn(delay: 300.ms).slideY(begin: 0.1),
            ],
          ],
        ),
      ),
    );
  }
}

/// ────────────────────────────────────────────────────────────────────────────
/// PremiumEmptyState — Reusable empty state with illustration.
/// Used when lists have no items.
/// ────────────────────────────────────────────────────────────────────────────
class PremiumEmptyState extends StatelessWidget {
  final String title;
  final String message;
  final IconData icon;
  final String? actionLabel;
  final VoidCallback? onAction;
  final List<String>? tips;

  const PremiumEmptyState({
    super.key,
    required this.title,
    required this.message,
    this.icon = Icons.inbox_outlined,
    this.actionLabel,
    this.onAction,
    this.tips,
  });

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icon
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: Palette.primary.withValues(alpha: 0.08),
                shape: BoxShape.circle,
                border: Border.all(
                  color: Palette.primary.withValues(alpha: 0.15),
                ),
              ),
              child: Icon(icon, color: Palette.primary, size: 36),
            ).animate().scale(
                  duration: 500.ms,
                  curve: Curves.elasticOut,
                ),

            const SizedBox(height: 24),

            // Title
            Text(
              title,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: dark ? Palette.textPrimary : Palette.textInverse,
              ),
            ).animate().fadeIn(delay: 100.ms),

            const SizedBox(height: 8),

            // Message
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
                color: dark ? Palette.textSecondary : Palette.textTertiary,
                height: 1.5,
              ),
            ).animate().fadeIn(delay: 200.ms),

            // Tips
            if (tips != null && tips!.isNotEmpty) ...[
              const SizedBox(height: 20),
              ...tips!.asMap().entries.map((entry) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.lightbulb_outline,
                        size: 16,
                        color: Palette.warning,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        entry.value,
                        style: TextStyle(
                          fontSize: 13,
                          color: dark
                              ? Palette.textSecondary
                              : Palette.textTertiary,
                        ),
                      ),
                    ],
                  ),
                ).animate().fadeIn(delay: Duration(milliseconds: 300 + entry.key * 100));
              }),
            ],

            // Action button
            if (actionLabel != null && onAction != null) ...[
              const SizedBox(height: 28),
              GestureDetector(
                onTap: onAction,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 28, vertical: 14),
                  decoration: BoxDecoration(
                    gradient: Palette.gradientPrimary,
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                        color: Palette.primary.withValues(alpha: 0.3),
                        blurRadius: 14,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Text(
                    actionLabel!,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 15,
                    ),
                  ),
                ),
              ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.1),
            ],
          ],
        ),
      ),
    );
  }
}
