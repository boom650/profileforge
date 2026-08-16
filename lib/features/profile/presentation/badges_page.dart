import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:profileforge/features/profile/application/profile_providers.dart';
import 'package:profileforge/core/theme/app_theme.dart';

/// Badges derived from achievements. Accessible grid.
class BadgesPage extends ConsumerWidget {
  final String profileId;
  const BadgesPage({super.key, required this.profileId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(profileProvider(profileId));
    return Scaffold(
      appBar: AppBar(title: const Text('Badges')),
      body: profile.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (p) => GridView.count(
          crossAxisCount: 3,
          padding: const EdgeInsets.all(16),
          children: [
            _badge(Icons.star, 'Profile', p.name.isNotEmpty),
            _badge(Icons.emoji_events, 'Ach ${p.achievements.length}',
                p.achievements.isNotEmpty),
            _badge(Icons.flag, 'Goal set', p.goal.isNotEmpty),
          ],
        ),
      ),
    );
  }

  Widget _badge(IconData icon, String label, bool earned) => Semantics(
        label: '$label: ${earned ? 'earned' : 'locked'}',
        child: Opacity(
          opacity: earned ? 1.0 : 0.3,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 40,
                  color: earned ? Colors.deepPurple : Palette.inkSoft),
              const SizedBox(height: 4),
              Text(label, textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 12)),
            ],
          ),
        ),
      );
}
