import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:profileforge/core/celebration/celebrate.dart';
import 'package:profileforge/core/theme/app_theme.dart';
import 'package:profileforge/core/widgets/platypus.dart';
import 'package:profileforge/features/streak/domain/streak_state.dart';

/// Layered reward (variable-reward, 02c-key-insights): a streak MILESTONE
/// gets its own celebration on top of the XP confetti — the "7-day streak!"
/// moment Habitica does. Non-milestone events are silently ignored so the
/// regular completion flow is unchanged.
void celebrateStreakEvent(BuildContext context, StreakEvent? event) {
  final day = event?.maybeWhen(milestone: (d) => d, orElse: () => null);
  if (day == null || !context.mounted) return;
  celebrate(
    context,
    message: '$day-day streak!',
    color: Palette.warning,
  );
  HapticFeedback.heavyImpact();
}

/// Full-screen milestone dialog for streak peaks (used by the streak card).
void showStreakMilestoneDialog(BuildContext context, int day) {
  showDialog(
    context: context,
    builder: (_) => Dialog(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Percy(size: 96, pose: PlatypusPose.happy)
                .animate()
                .scale(duration: 600.ms, curve: Curves.elasticOut),
            const SizedBox(height: 12),
            Text('$day-day streak!',
                style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 8),
            Text(
              'Consistency compounds. Percy is proud of you.',
              textAlign: TextAlign.center,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(color: Palette.inkSoft),
            ),
          ],
        ),
      ),
    ),
  );
}