import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:profileforge/core/audio/sound_service.dart';
import 'package:profileforge/core/celebration/celebrate.dart';
import 'package:profileforge/core/theme/app_theme.dart';
import 'package:profileforge/core/widgets/poppy.dart';
import 'package:profileforge/features/teams/application/team_providers.dart';

class TeamsScreen extends ConsumerWidget {
  const TeamsScreen({super.key, required this.profileId});
  final String profileId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final teams = ref.watch(myTeamsProvider(profileId));

    return Scaffold(
      appBar: AppBar(title: const Text('Teams')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          GradientBanner(
            from: Palette.blue,
            to: Palette.green,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('🚀 Study squads',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w900)),
                const SizedBox(height: 6),
                Text(
                    'Form a team, compete on the leaderboard, and push each other to finish applications.',
                    style: TextStyle(
                        color: Colors.white.withOpacity(0.92), fontSize: 13)),
              ],
            ),
          ),
          const SizedBox(height: 16),
          SectionTitle('Your teams',
              action: IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () => _createTeam(context, ref))),
          ...teams.when(
            data: (rows) => rows.isEmpty
                ? [const Text('No teams yet. Create one above!')]
                : rows.map((t) {
                    return Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: theme.cardColor,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                            color: theme.dividerColor, width: 1),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 46,
                            height: 46,
                            decoration: BoxDecoration(
                              color: Palette.blue,
                              borderRadius: BorderRadius.circular(12)),
                            child: const Icon(Icons.group,
                                color: Colors.white),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(t.name,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w800,
                                        fontSize: 16)),
                                Text('Owner: ${t.ownerProfileId}',
                                    style: TextStyle(
                                        color: theme.hintColor, fontSize: 12)),
                              ],
                            ),
                          ),
                          const Icon(Icons.emoji_events,
                              color: Palette.yellow),
                        ],
                      ),
                    ).animate().fadeIn().slideX(begin: 0.04);
                  }).toList(),
            loading: () => const [CircularProgressIndicator()],
            error: (e, _) => [Text('Error: $e')],
          ),
          const SizedBox(height: 16),
          PoppyButton(
            label: 'Invite buddies to a team',
            color: Palette.purple,
            onTap: () {
              SoundService.instance.tap();
              celebrate(context, message: 'Shared! 🤝');
            },
          ),
        ],
      ),
    );
  }

  void _createTeam(BuildContext context, WidgetRef ref) {
    final ctrl = TextEditingController();
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('New team'),
        content: TextField(
          controller: ctrl,
          decoration: const InputDecoration(
            hintText: 'Team name',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel')),
          FilledButton(
            onPressed: () {
              final name = ctrl.text.trim();
              if (name.isEmpty) return;
              ref.read(createTeamProvider((
                id: 'team-${DateTime.now().millisecondsSinceEpoch}',
                name: name,
                owner: profileId,
              )));
              SoundService.instance.success();
              Navigator.pop(context);
            },
            child: const Text('Create'),
          ),
        ],
      ),
    );
  }
}
