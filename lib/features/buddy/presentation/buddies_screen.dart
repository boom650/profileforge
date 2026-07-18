import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:profileforge/core/audio/sound_service.dart';
import 'package:profileforge/core/celebration/celebrate.dart';
import 'package:profileforge/core/theme/app_theme.dart';
import 'package:profileforge/core/widgets/poppy.dart';
import 'package:profileforge/features/buddy/application/buddy_providers.dart';

class BuddiesScreen extends ConsumerWidget {
  const BuddiesScreen({super.key, required this.profileId});
  final String profileId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final buddies = ref.watch(buddiesProvider(profileId));
    final nudge = ref.watch(buddyMotivationProvider(profileId));

    return Scaffold(
      appBar: AppBar(title: const Text('Buddies')),
      bottomNavigationBar: appBottomNav(context, '/buddies'),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          GradientBanner(
            from: Palette.pink,
            to: Palette.orange,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('🤝 Accountability partners',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w900)),
                const SizedBox(height: 6),
                Text(
                    'Add friends, check in, and keep each other on track for the admission grind.',
                    style: TextStyle(
                        color: Colors.white.withOpacity(0.92), fontSize: 13)),
              ],
            ),
          ),
          const SizedBox(height: 14),
          if (nudge.valueOrNull != null)
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Palette.orange.withOpacity(0.15),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                children: [
                  const Text('🔥', style: TextStyle(fontSize: 22)),
                  const SizedBox(width: 10),
                  Expanded(
                      child: Text(nudge.valueOrNull!,
                          style: const TextStyle(fontWeight: FontWeight.w700))),
                ],
              ),
            ).animate().shake(),
          const SizedBox(height: 16),
          SectionTitle('Your buddies',
              action: IconButton(
                icon: const Icon(Icons.person_add),
                onPressed: () => _addBuddy(context, ref),
              )),
          ...buddies.when(
            data: (rows) => rows.isEmpty
                ? [const Text('No buddies yet. Tap + to add one.')]
                : rows.map((b) {
                    final initial = (b.buddyProfileId.isNotEmpty
                          ? b.buddyProfileId[0]
                          : '?')
                        .toUpperCase();
                    final color = Palette.green;
                    return Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: theme.cardColor,
                        borderRadius: BorderRadius.circular(16),
                        border:
                            Border.all(color: theme.dividerColor, width: 1),
                      ),
                      child: Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: color,
                            child: Text(initial,
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w900)),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(b.buddyProfileId,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w800)),
                                Text('Tap to check in with them',
                                    style: TextStyle(
                                        color: theme.hintColor, fontSize: 12)),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.send, color: Palette.green),
                            onPressed: () {
                              SoundService.instance.tap();
                              ref.read(checkInProvider((
                                from: profileId,
                                to: b.buddyProfileId,
                                xp: 5,
                                note: 'Checking in — let’s both finish today’s mission!',
                              )));
                              celebrate(context, message: 'Checked in 🤝');
                            },
                          ),
                        ],
                      ),
                    ).animate().fadeIn().slideX(begin: 0.04);
                  }).toList(),
            loading: () => const [CircularProgressIndicator()],
            error: (e, _) => [Text('Error: $e')],
          ),
          const SizedBox(height: 16),
          PoppyButton(
            label: 'Find a team instead',
            color: Palette.blue,
            onTap: () => context.push('/teams'),
          ),
        ],
      ),
    );
  }

  void _addBuddy(BuildContext context, WidgetRef ref) {
    final ctrl = TextEditingController();
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Add a buddy'),
        content: TextField(
          controller: ctrl,
          decoration: const InputDecoration(
            hintText: 'Their profile id or @handle',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          FilledButton(
            onPressed: () {
              final id = ctrl.text.trim();
              if (id.isEmpty) return;
              ref.read(addBuddyProvider((me: profileId, buddyId: id)));
              SoundService.instance.success();
              Navigator.pop(context);
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }
}
