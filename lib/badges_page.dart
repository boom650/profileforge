import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'profile_model.dart';

/// Badges derived from achievements + XP. Skill-system pattern from research graph.
class BadgesPage extends ConsumerWidget {
  const BadgesPage({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final p = ref.watch(profileProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Badges')),
      body: GridView.count(
        crossAxisCount: 3,
        children: [
          _badge(Icons.star, 'XP ${p.xp}', p.xp > 0),
          _badge(Icons.emoji_events, 'Ach ${p.achievements.length}', p.achievements.isNotEmpty),
          _badge(Icons.school, 'Profile', p.name.isNotEmpty),
        ],
      ),
    );
  }
  Widget _badge(IconData icon, String label, bool earned) => Opacity(
        opacity: earned ? 1.0 : 0.3,
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Icon(icon, size: 40, color: earned ? Colors.deepPurple : Colors.grey),
          const SizedBox(height: 4),
          Text(label, textAlign: TextAlign.center, style: const TextStyle(fontSize: 12)),
        ]),
      );
}
