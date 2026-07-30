import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:profileforge/core/audio/sound_service.dart';
import 'package:profileforge/core/celebration/celebrate.dart';
import 'package:profileforge/core/theme/app_theme.dart';
import 'package:profileforge/core/widgets/premium_widgets.dart';
import 'package:profileforge/features/buddy/application/buddy_providers.dart';

class BuddiesScreen extends ConsumerWidget {
  const BuddiesScreen({super.key, required this.profileId});
  final String profileId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dark = isDark(context);
    final buddies = ref.watch(buddiesProvider(profileId));
    final nudge = ref.watch(buddyMotivationProvider(profileId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Buddies'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      bottomNavigationBar: appBottomNav(context, '/buddies'),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Hero
          GlassCard(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('🤝', style: TextStyle(fontSize: 32)),
                const SizedBox(height: 12),
                Text(
                  'Accountability Partners',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                    color: Palette.textPrimary(dark),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Add friends, check in, and keep each other on track for the admission grind.',
                  style: TextStyle(
                    fontSize: 13,
                    color: Palette.textSecondary(dark),
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ).animate().fadeIn().slideY(begin: 0.1),

          const SizedBox(height: 16),

          // Nudge card
          if (nudge.valueOrNull != null)
            GlassCard(
              padding: const EdgeInsets.all(14),
              border: Palette.accentOrange,
              child: Row(
                children: [
                  Text('🔥', style: TextStyle(fontSize: 22)),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      nudge.valueOrNull!,
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                        color: Palette.textPrimary(dark),
                      ),
                    ),
                  ),
                ],
              ),
            ).animate().shake(delay: 200.ms),

          const SizedBox(height: 20),

          // Header + add
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Your Buddies',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: Palette.textPrimary(dark),
                ),
              ),
              GlassIconButton(
                icon: Icons.person_add,
                onTap: () {
                  HapticFeedback.lightImpact();
                  _addBuddy(context, ref);
                },
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Buddy list
          ...buddies.when(
            data: (rows) => rows.isEmpty
                ? [
                    GlassCard(
                      padding: const EdgeInsets.all(24),
                      opacity: 0.04,
                      child: Center(
                        child: Column(
                          children: [
                            Text('🧑‍🤝‍🧑', style: TextStyle(fontSize: 40)),
                            const SizedBox(height: 12),
                            Text(
                              'No buddies yet',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: Palette.textPrimary(dark),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Tap + to add one',
                              style: TextStyle(
                                fontSize: 13,
                                color: Palette.textSecondary(dark),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ]
                : rows.map((b) {
                    final initial = (b.buddyProfileId.isNotEmpty
                            ? b.buddyProfileId[0]
                            : '?')
                        .toUpperCase();
                    return _BuddyCard(
                      buddyId: b.buddyProfileId,
                      initial: initial,
                      dark: dark,
                      index: rows.indexOf(b),
                      onCheckIn: () {
                        HapticFeedback.lightImpact();
                        SoundService.instance.tap();
                        ref.read(checkInProvider((
                          from: profileId,
                          to: b.buddyProfileId,
                          xp: 5,
                          note: 'Checking in — let\'s both finish today\'s mission!',
                        )));
                        celebrate(context, message: 'Checked in 🤝');
                      },
                    );
                  }),
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

          // Teams link
          GlassCard(
            padding: const EdgeInsets.all(0),
            border: Palette.accentBlue,
            borderWidth: 1.5,
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: () => context.push('/teams'),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  child: Center(
                    child: Text(
                      'Find a team instead →',
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

  void _addBuddy(BuildContext context, WidgetRef ref) {
    final ctrl = TextEditingController();
    final dark = isDark(context);
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: Palette.surface1(dark),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Text(
          'Add a buddy',
          style: TextStyle(
            fontWeight: FontWeight.w800,
            color: Palette.textPrimary(dark),
          ),
        ),
        content: TextField(
          controller: ctrl,
          decoration: InputDecoration(
            hintText: 'Their profile id or @handle',
            hintStyle: TextStyle(color: Palette.textMuted(dark)),
            filled: true,
            fillColor: Palette.surface2(dark),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Palette.border(dark)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Palette.border(dark)),
            ),
          ),
          style: TextStyle(color: Palette.textPrimary(dark)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: TextStyle(color: Palette.textSecondary(dark)),
            ),
          ),
          FilledButton(
            onPressed: () {
              final id = ctrl.text.trim();
              if (id.isEmpty) return;
              ref.read(addBuddyProvider((me: profileId, buddyId: id)));
              HapticFeedback.lightImpact();
              SoundService.instance.success();
              Navigator.pop(context);
            },
            style: FilledButton.styleFrom(
              backgroundColor: Palette.accentBlue,
            ),
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }
}

class _BuddyCard extends StatelessWidget {
  final String buddyId;
  final String initial;
  final bool dark;
  final int index;
  final VoidCallback onCheckIn;

  const _BuddyCard({
    required this.buddyId,
    required this.initial,
    required this.dark,
    required this.index,
    required this.onCheckIn,
  });

  @override
  Widget build(BuildContext context) {
    final colors = [Palette.accentViolet, Palette.accentBlue, Palette.accentTeal];
    final avatarColor = colors[index % colors.length];

    return GlassCard(
      padding: const EdgeInsets.all(14),
      child: Row(
        children: [
          // Avatar
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [avatarColor, avatarColor.withValues(alpha: 0.6)],
              ),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Center(
              child: Text(
                initial,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                  fontSize: 18,
                ),
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  buddyId,
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 14,
                    color: Palette.textPrimary(dark),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Tap check-in to nudge them',
                  style: TextStyle(
                    color: Palette.textMuted(dark),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          // Check-in button
          GlassIconButton(
            icon: Icons.send,
            onTap: onCheckIn,
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
