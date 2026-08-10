import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:profileforge/core/celebration/celebrate.dart';
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
    message: '$day-day streak! 🔥',
    color: const Color(0xFFFFA726),
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
            const Icon(Icons.celebration, size: 64, color: Colors.amber)
                .animate()
                .scale(duration: 500.ms, curve: Curves.elasticOut),
            const SizedBox(height: 12),
            Text('$day-day streak!',
                style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 8),
            const Text('Consistency compounds. Keep going.',
                textAlign: TextAlign.center),
          ],
        ),
      ),
    ),
  );
}