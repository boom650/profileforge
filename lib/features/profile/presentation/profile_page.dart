import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:profileforge/features/profile/application/profile_providers.dart';
import 'package:profileforge/features/profile/presentation/pdf_export.dart';

class ProfilePage extends ConsumerWidget {
  final String profileId;
  const ProfilePage({super.key, required this.profileId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(profileProvider(profileId));
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile Builder'),
        actions: [
          IconButton(
            icon: const Icon(Icons.picture_as_pdf),
            tooltip: 'Export PDF',
            onPressed: () async {
              final p = profile.value;
              if (p == null) return;
              final path = await exportProfilePdf(p);
              if (context.mounted) {
                // share handled by caller; show path
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('PDF ready: $path')),
                );
              }
            },
          ),
        ],
      ),
      body: profile.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (p) => ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextField(
              decoration: const InputDecoration(labelText: 'Name'),
              controller: TextEditingController(text: p.name),
              onChanged: ref.read(profileProvider(profileId).notifier).setName,
            ),
            const SizedBox(height: 12),
            TextField(
              decoration: const InputDecoration(labelText: 'Admissions Goal'),
              controller: TextEditingController(text: p.goal),
              onChanged: ref.read(profileProvider(profileId).notifier).setGoal,
            ),
            const SizedBox(height: 20),
            const Text('Achievements',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ...p.achievements.map((a) => ListTile(
                  leading: const Icon(Icons.check_circle, color: Colors.green),
                  title: Text(a),
                )),
            const SizedBox(height: 12),
            FilledButton.icon(
              icon: const Icon(Icons.add),
              label: const Text('Add Achievement'),
              onPressed: () async {
                final ctrl = TextEditingController();
                final v = await showDialog<String>(
                  context: context,
                  builder: (c) => AlertDialog(
                    title: const Text('New Achievement'),
                    content: TextField(controller: ctrl, autofocus: true),
                    actions: [
                      TextButton(
                          onPressed: () => Navigator.pop(c),
                          child: const Text('Cancel')),
                      FilledButton(
                          onPressed: () => Navigator.pop(c, ctrl.text),
                          child: const Text('Add')),
                    ],
                  ),
                );
                if (v != null && v.trim().isNotEmpty) {
                  ref.read(profileProvider(profileId).notifier).addAchievement(v.trim());
                }
              },
            ),
            const SizedBox(height: 16),
            OutlinedButton(
              onPressed: () => context.push('/badges'),
              child: const Text('View Badges'),
            ),
          ],
        ),
      ),
    );
  }
}
