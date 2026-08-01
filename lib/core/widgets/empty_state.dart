import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../theme/app_theme.dart';

/// Reusable empty state widget — shown when a list/section has no data.
class EmptyState extends StatelessWidget {
  const EmptyState({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    this.actionLabel,
    this.onAction,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 48),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: Palette.primary.withValues(alpha: 0.08),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 32,
                color: Palette.primary.withValues(alpha: 0.5),
              ),
            ).animate().scale(
                  delay: 100.ms,
                  duration: 400.ms,
                  curve: Curves.elasticOut,
                ),
            const SizedBox(height: 20),
            Text(
              title,
              style: TextStyle(
                color: Palette.textPrimary,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ).animate().fadeIn(delay: 200.ms),
            const SizedBox(height: 8),
            Text(
              subtitle,
              style: TextStyle(
                color: Palette.textSecondary,
                fontSize: 13,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ).animate().fadeIn(delay: 300.ms),
            if (actionLabel != null && onAction != null) ...[
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: onAction,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Palette.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(actionLabel!),
              ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.1),
            ],
          ],
        ),
      ),
    );
  }
}

/// Shimmer loading skeleton for lists.
class ListLoadingSkeleton extends StatelessWidget {
  const ListLoadingSkeleton({super.key, this.itemCount = 5});

  final int itemCount;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: itemCount,
      itemBuilder: (context, index) => Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Container(
          height: 72,
          decoration: BoxDecoration(
            color: Palette.surface2.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(14),
          ),
        ).animate(
          delay: Duration(milliseconds: index * 100),
          onComplete: (c) => c.repeat(reverse: true),
        ).shimmer(
          duration: 1200.ms,
          color: Palette.surface3.withValues(alpha: 0.3),
        ),
      ),
    );
  }
}
