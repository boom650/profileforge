import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:profileforge/core/data/app_database.dart';
import 'package:profileforge/features/challenges/application/challenge_providers.dart';
import 'package:profileforge/features/xp/application/xp_providers.dart';
import 'package:profileforge/core/widgets/poppy.dart';
import 'package:profileforge/core/widgets/empty_state.dart';

class ChallengesScreen extends ConsumerStatefulWidget {
  final String profileId;
  const ChallengesScreen({super.key, required this.profileId});

  @override
  ConsumerState<ChallengesScreen> createState() => _ChallengesScreenState();
}

class _ChallengesScreenState extends ConsumerState<ChallengesScreen> {
  int _wagerXp = 100;
  int _challengeDays = 3;

  @override
  Widget build(BuildContext context) {
    final activeAsync = ref.watch(activeChallengesProvider(widget.profileId));
    final historyAsync = ref.watch(challengeHistoryProvider(widget.profileId));
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Challenges'), centerTitle: true, actions: [
        IconButton(icon: const Icon(Icons.add_rounded), onPressed: _showCreateDialog),
      ]),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Active challenges
          Text('Active Challenges', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          activeAsync.when(
            data: (active) => active.isEmpty
                ? EmptyState(
                    icon: Icons.swords_outlined,
                    title: 'No active challenges',
                    subtitle: 'Challenge yourself to earn bonus XP!',
                  )
                : Column(children: active.map((c) => _ActiveChallengeCard(
                    challenge: c, profileId: widget.profileId, onResolve: _resolve, theme: theme,
                  )).toList()),
            loading: () => const Center(child: CircularProgressIndicator(strokeWidth: 2)),
            error: (e, _) => Text('Error: $e'),
          ),
          const SizedBox(height: 24),

          // History
          Text('Past Challenges', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          historyAsync.when(
            data: (history) => history.isEmpty
                ? Text('No past challenges', style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant))
                : Column(children: history.map((c) => _HistoryTile(challenge: c, theme: theme)).toList()),
            loading: () => const Center(child: CircularProgressIndicator(strokeWidth: 2)),
            error: (e, _) => Text('Error: $e'),
          ),
        ],
      ),
    );
  }

  void _showCreateDialog() {
    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setD) => AlertDialog(
          title: const Text('New Challenge'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Challenge yourself to earn XP in a set time!'),
              const SizedBox(height: 16),
              Text('XP Goal', style: Theme.of(ctx).textTheme.labelLarge),
              Slider(
                value: _wagerXp.toDouble(),
                min: 25, max: 500, divisions: 19,
                label: '$_wagerXp XP',
                onChanged: (v) => setD(() => _wagerXp = v.round()),
              ),
              Text('$_wagerXp XP', style: Theme.of(ctx).textTheme.titleLarge?.copyWith(color: Theme.of(ctx).colorScheme.primary, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              Text('Duration', style: Theme.of(ctx).textTheme.labelLarge),
              Slider(
                value: _challengeDays.toDouble(),
                min: 1, max: 7, divisions: 6,
                label: '$_challengeDays days',
                onChanged: (v) => setD(() => _challengeDays = v.round()),
              ),
              Text('$_challengeDays days', style: Theme.of(ctx).textTheme.titleLarge?.copyWith(color: Theme.of(ctx).colorScheme.primary, fontWeight: FontWeight.bold)),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
            PoppyButton(label: 'Start Challenge!', onPressed: () {
              ref.read(createChallengeProvider(
                (profileId: widget.profileId, wagerXp: _wagerXp, days: _challengeDays),
              ).future);
              Navigator.pop(ctx);
            }),
          ],
        ),
      ),
    );
  }

  void _resolve(FriendChallengeRow challenge) async {
    final xp = await ref.read(totalXpProvider(widget.profileId).future);
    final winner = await ref.read(resolveChallengeProvider(
      (profileId: widget.profileId, challengeId: challenge.id, currentXp: xp),
    ).future);
    if (!mounted) return;
    final isWin = winner == widget.profileId;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(isWin ? '🎉 You won the challenge! +25 bonus XP!' : '😔 The ghost opponent won this time. Try again!'),
      backgroundColor: isWin ? Colors.green : Colors.orange,
    ));
  }
}

class _ActiveChallengeCard extends ConsumerWidget {
  final FriendChallengeRow challenge;
  final String profileId;
  final void Function(FriendChallengeRow) onResolve;
  final ThemeData theme;
  const _ActiveChallengeCard({required this.challenge, required this.profileId, required this.onResolve, required this.theme});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final totalXpAsync = ref.watch(totalXpProvider(profileId));
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Text('⚔️', style: TextStyle(fontSize: 24)),
                const SizedBox(width: 8),
                Text('Earn ${challenge.wagerXp} XP', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                const Spacer(),
                Text('${challenge.expiresAt.day}/${challenge.expiresAt.month}', style: theme.textTheme.bodySmall),
              ],
            ),
            const SizedBox(height: 12),
            totalXpAsync.when(
              data: (currentXp) {
                final progress = (currentXp / challenge.wagerXp).clamp(0.0, 1.0);
                return Column(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: LinearProgressIndicator(value: progress, minHeight: 8, backgroundColor: theme.colorScheme.surfaceContainerHighest),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('$currentXp / ${challenge.wagerXp} XP', style: theme.textTheme.bodySmall),
                        PoppyButton(
                          label: progress >= 1.0 ? 'Claim Reward' : 'Resolve',
                          compact: true,
                          onPressed: () => onResolve(challenge),
                        ),
                      ],
                    ),
                  ],
                );
              },
              loading: () => const LinearProgressIndicator(),
              error: (_, __) => const Text('Error'),
            ),
          ],
        ),
      ),
    );
  }
}

class _HistoryTile extends StatelessWidget {
  final FriendChallengeRow challenge;
  final ThemeData theme;
  const _HistoryTile({required this.challenge, required this.theme});

  @override
  Widget build(BuildContext context) {
    final won = challenge.winnerId == challenge.profileId;
    return Card(
      margin: const EdgeInsets.only(bottom: 4),
      child: ListTile(
        dense: true,
        leading: Text(won ? '🏆' : '💔', style: const TextStyle(fontSize: 20)),
        title: Text('Earn ${challenge.wagerXp} XP challenge', style: const TextStyle(fontSize: 14)),
        subtitle: Text(won ? 'Won! +25 bonus XP' : 'Lost to ghost opponent', style: TextStyle(fontSize: 12, color: won ? Colors.green : Colors.orange)),
        trailing: Text('${challenge.challengerScore} vs ${challenge.opponentScore}', style: theme.textTheme.bodySmall),
      ),
    );
  }
}
