import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:profileforge/core/audio/sound_service.dart';
import 'package:profileforge/core/celebration/celebrate.dart';
import 'package:profileforge/core/theme/app_theme.dart';
import 'package:profileforge/core/widgets/premium_widgets.dart';
import 'package:profileforge/features/teams/application/team_providers.dart';

class TeamsScreen extends ConsumerWidget {
  const TeamsScreen({super.key, required this.profileId});
  final String profileId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dark = isDark(context);
    final teams = ref.watch(myTeamsProvider(profileId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Teams'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Hero
          GlassCard(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('🚀', style: TextStyle(fontSize: 32)),
                const SizedBox(height: 12),
                Text(
                  'Study Squads',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                    color: Palette.textPrimary,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Form a team, compete on the leaderboard, and push each other to finish applications.',
                  style: TextStyle(
                    fontSize: 13,
                    color: Palette.textSecondary,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ).animate().fadeIn().slideY(begin: 0.1),

          const SizedBox(height: 24),

          // Header + add button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Your Teams',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: Palette.textPrimary,
                ),
              ),
              GlassIconButton(
                icon: Icons.add,
                onTap: () {
                  HapticFeedback.lightImpact();
                  _createTeam(context, ref);
                },
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Team list
          ...teams.when(
            data: (rows) => rows.isEmpty
                ? [
                    GlassCard(
                      padding: const EdgeInsets.all(24),
                      opacity: 0.04,
                      child: Center(
                        child: Column(
                          children: [
                            Text('👥', style: TextStyle(fontSize: 40)),
                            const SizedBox(height: 12),
                            Text(
                              'No teams yet',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: Palette.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Tap + to create one',
                              style: TextStyle(
                                fontSize: 13,
                                color: Palette.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ]
                : rows.map((t) => _TeamCard(
                      team: t,
                      dark: dark,
                      index: rows.indexOf(t),
                    )),
            loading: () => [
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(32),
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
            ],
            error: (e, _) => [
              GlassCard(
                padding: const EdgeInsets.all(16),
                child: Text('Error: $e',
                    style: TextStyle(color: Palette.error)),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Invite button
          GlassCard(
            padding: const EdgeInsets.all(0),
            border: Palette.accentBlue,
            borderWidth: 1.5,
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: () {
                  HapticFeedback.lightImpact();
                  SoundService.instance.tap();
                  celebrate(context, message: 'Shared! 🤝');
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  child: Center(
                    child: Text(
                      'Invite buddies to a team',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                        color: Palette.accentBlue,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(height: 16),
        ],
      ),
    );
  }

  void _createTeam(BuildContext context, WidgetRef ref) {
    final ctrl = TextEditingController();
    final dark = isDark(context);
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: Palette.surface1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Text(
          'New team',
          style: TextStyle(
            fontWeight: FontWeight.w800,
            color: Palette.textPrimary,
          ),
        ),
        content: TextField(
          controller: ctrl,
          decoration: InputDecoration(
            hintText: 'Team name',
            hintStyle: TextStyle(color: Palette.textMuted),
            filled: true,
            fillColor: Palette.surface2,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Palette.border),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Palette.border),
            ),
          ),
          style: TextStyle(color: Palette.textPrimary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: TextStyle(color: Palette.textSecondary),
            ),
          ),
          FilledButton(
            onPressed: () {
              final name = ctrl.text.trim();
              if (name.isEmpty) return;
              ref.read(createTeamProvider((
                id: 'team-${DateTime.now().millisecondsSinceEpoch}',
                name: name,
                owner: profileId,
              )));
              HapticFeedback.lightImpact();
              SoundService.instance.success();
              Navigator.pop(context);
            },
            style: FilledButton.styleFrom(
              backgroundColor: Palette.accentViolet,
            ),
            child: const Text('Create'),
          ),
        ],
      ),
    );
  }
}

class _TeamCard extends StatelessWidget {
  final dynamic team;
  final bool dark;
  final int index;

  const _TeamCard({
    required this.team,
    required this.dark,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: const EdgeInsets.all(14),
      child: Row(
        children: [
          // Team avatar
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Palette.accentViolet, Palette.accentBlue],
              ),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Center(
              child: Text('👥', style: TextStyle(fontSize: 22)),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  team.name,
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 15,
                    color: Palette.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Owner: ${team.ownerProfileId}',
                  style: TextStyle(
                    color: Palette.textMuted,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          // Trophy icon
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Palette.accentYellow.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text('🏆', style: TextStyle(fontSize: 16)),
          ),
        ],
      ),
    ).animate().fadeIn(delay: (index * 80).ms).slideX(
      begin: 0.05,
      duration: 400.ms,
      curve: Curves.easeOutCubic,
    );
  }
}
