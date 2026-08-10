import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:profileforge/features/streak/application/streak_providers.dart';
import 'package:profileforge/features/streak/domain/streak_state.dart';
import 'package:profileforge/features/streak/presentation/streak_celebration.dart';

/// Animated streak card with humane-recovery indicators.
/// Accessible: Semantic labels + tooltips on every interactive element.
class StreakCard extends ConsumerWidget {
  const StreakCard({super.key, required this.profileId});
  final String profileId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final streak = ref.watch(streakProvider(profileId));
    return streak.when(
      loading: () => const LinearProgressIndicator(),
      error: (e, _) => Semantics(
        label: 'Streak unavailable',
        child: const Text('Streak unavailable — tap to retry.'),
      ),
      data: (s) => _StreakCardBody(state: s, profileId: profileId),
    );
  }
}

class _StreakCardBody extends ConsumerWidget {
  const _StreakCardBody({required this.state, required this.profileId});
  final StreakState state;
  final String profileId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    return MergeSemantics(
      child: Semantics(
        label: 'Current streak ${state.current} days, longest ${state.longest}',
        child: Card(
          elevation: 2,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Tooltip(
                      message: 'Your streak is burning bright',
                      child: const Icon(Icons.local_fire_department,
                              color: Colors.orange, size: 32)
                          .animate(onPlay: (c) => c.repeat())
                          .shake(duration: 1200.ms),
                    ),
                    const SizedBox(width: 8),
                    Text(state.current.toString(),
                        semanticsLabel: '${state.current} days',
                        style: theme.textTheme.headlineMedium
                            ?.copyWith(fontWeight: FontWeight.bold)),
                    const SizedBox(width: 6),
                    const Text('day streak', style: TextStyle(color: Colors.grey)),
                    const Spacer(),
                    _RecoveryChips(state: state),
                  ],
                ),
                const SizedBox(height: 8),
                Text('Longest: ${state.longest}', style: theme.textTheme.bodySmall),
                const SizedBox(height: 12),
                FilledButton.icon(
                  icon: const Icon(Icons.check_circle),
                  label: const Text('Mark today done'),
                  onPressed: () async {
                    final event = await ref
                        .read(streakProvider(profileId).notifier)
                        .recordToday();
                    final day = event?.maybeWhen(
                      milestone: (d) => d,
                      orElse: () => null,
                    );
                    if (day != null && context.mounted) {
                      showStreakMilestoneDialog(context, day);
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _RecoveryChips extends StatelessWidget {
  const _RecoveryChips({required this.state});
  final StreakState state;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 6,
      children: [
        _chip(Icons.ac_unit, '${state.freezeTokens}', 'Freeze tokens',
            'Skip a day without breaking your streak'),
        _chip(Icons.auto_awesome, '${state.weekendAmulets}', 'Weekend amulets',
            'Protect weekend streaks'),
        _chip(Icons.forum, '${state.graceDaysUsed}', 'Grace days used',
            'Late-day grace already used'),
      ],
    );
  }

  Widget _chip(IconData icon, String n, String label, String tooltip) => Tooltip(
        message: tooltip,
        child: Semantics(
          label: '$label: $n',
          child: Chip(
            avatar: Icon(icon, size: 16),
            label: Text(n, style: const TextStyle(fontSize: 12)),
          ),
        ),
      );
}
