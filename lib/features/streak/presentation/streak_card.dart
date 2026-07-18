import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:profileforge/features/streak/application/streak_providers.dart';
import 'package:profileforge/features/streak/domain/streak_state.dart';

/// Animated streak card with humane-recovery indicators.
/// Accessible: Semantic labels on every interactive element.
class StreakCard extends ConsumerWidget {
  final String profileId;
  const StreakCard({super.key, required this.profileId});

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
  final StreakState state;
  final String profileId;
  const _StreakCardBody({required this.state, required this.profileId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    return Semantics(
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
                  const Icon(Icons.local_fire_department, color: Colors.orange, size: 32)
                      .animate(onPlay: (c) => c.repeat())
                      .shake(duration: 1200.ms, y: 2),
                  const SizedBox(width: 8),
                  Text('${state.current}',
                      style: theme.textTheme.headlineMedium
                          ?.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(width: 6),
                  const Text('day streak',
                      style: TextStyle(color: Colors.grey)),
                  const Spacer(),
                  _RecoveryChips(state: state),
                ],
              ),
              const SizedBox(height: 8),
              Text('Longest: ${state.longest}',
                  style: theme.textTheme.bodySmall),
              const SizedBox(height: 12),
              FilledButton.icon(
                icon: const Icon(Icons.check_circle),
                label: const Text('Mark today done'),
                onPressed: () async {
                  final event = await ref
                      .read(streakProvider(profileId).notifier)
                      .recordToday();
                  if (event is _Milestone && context.mounted) {
                    _celebrate(context, (event as _Milestone).day);
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _celebrate(BuildContext context, int day) {
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
}

class _RecoveryChips extends StatelessWidget {
  final StreakState state;
  const _RecoveryChips({required this.state});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 6,
      children: [
        _chip(Icons.ac_unit, '${state.freezeTokens}', 'Freeze tokens'),
        _chip(Icons.auto_awesome, '${state.weekendAmulets}', 'Weekend amulets'),
        _chip(Icons.forum, '${state.graceDaysUsed}', 'Grace used'),
      ],
    );
  }

  Widget _chip(IconData icon, String n, String label) => Semantics(
        label: '$label: $n',
        child: Chip(
          avatar: Icon(icon, size: 16),
          label: Text(n, style: const TextStyle(fontSize: 12)),
        ),
      );
}
