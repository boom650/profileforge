import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../theme/app_theme.dart';

class EmptyStateWidget extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback? onAction;
  final String? actionLabel;

  const EmptyStateWidget({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    this.onAction,
    this.actionLabel,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 64,
              color: Palette.textSecondary,
            ),
            const SizedBox(height: 24),
            Text(
              title,
              style: theme.textTheme.headlineSmall?.copyWith(
                color: Palette.textPrimary,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: Palette.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            if (onAction != null && actionLabel != null) ...[
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: onAction,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Palette.accent,
                  foregroundColor: Colors.white,
                ),
                child: Text(actionLabel!),
              ),
            ],
          ],
        ).animate().fadeIn(duration: 400.ms).scale(
              begin: const Offset(0.95, 0.95),
              end: const Offset(1, 1),
              duration: 400.ms,
              curve: Curves.easeOut,
            ),
      ),
    );
  }
}

class EmptyStates {
  EmptyStates._();

  static EmptyStateWidget noMissions() => const EmptyStateWidget(
        icon: Icons.content_paste_outlined,
        title: 'No missions yet',
        subtitle: 'Complete onboarding to get personalized missions',
      );

  static EmptyStateWidget noAchievements() => const EmptyStateWidget(
        icon: Icons.emoji_events_outlined,
        title: 'No achievements yet',
        subtitle: 'Complete challenges to earn badges',
      );

  static EmptyStateWidget noBuddies() => const EmptyStateWidget(
        icon: Icons.people_outline,
        title: 'No buddies yet',
        subtitle: 'Add study buddies to stay accountable',
      );

  static EmptyStateWidget noGoals() => const EmptyStateWidget(
        icon: Icons.flag_outlined,
        title: 'No goals set',
        subtitle: 'Set goals to track your progress',
      );

  static EmptyStateWidget networkError(VoidCallback onRetry) =>
      EmptyStateWidget(
        icon: Icons.wifi_off_outlined,
        title: 'Connection lost',
        subtitle: 'Check your internet connection and try again',
        actionLabel: 'Retry',
        onAction: onRetry,
      );

  static EmptyStateWidget aiError(String message, VoidCallback onRetry) =>
      EmptyStateWidget(
        icon: Icons.error_outline,
        title: message,
        subtitle: 'Something went wrong with the AI',
        actionLabel: 'Retry',
        onAction: onRetry,
      );
}
