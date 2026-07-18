import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cross_file/cross_file.dart';
import 'package:share_plus/share_plus.dart';
import 'profile_model.dart';
import 'pdf_export.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(profileProvider);
    final notifier = ref.read(profileProvider.notifier);
    final exportAsync = ref.watch(pdfExportProvider(profile));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile Builder'),
        actions: [
          IconButton(
            icon: const Icon(Icons.picture_as_pdf),
            tooltip: 'Export PDF',
            onPressed: () async {
              final path = exportAsync.value;
              if (path == null) return;
              await Share.shareXFiles([XFile(path)], text: 'My ProfileForge profile');
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            TextField(
              decoration: const InputDecoration(labelText: 'Name'),
              onChanged: notifier.setName,
              controller: TextEditingController(text: profile.name),
            ),
            const SizedBox(height: 12),
            TextField(
              decoration: const InputDecoration(labelText: 'Admissions Goal'),
              onChanged: notifier.setGoal,
              controller: TextEditingController(text: profile.goal),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                const Icon(Icons.star, color: Colors.deepPurple),
                const SizedBox(width: 8),
                Text('XP: ${profile.xp}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 16),
            const Text('Achievements', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ...profile.achievements.map((a) => ListTile(
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
                      TextButton(onPressed: () => Navigator.pop(c), child: const Text('Cancel')),
                      FilledButton(onPressed: () => Navigator.pop(c, ctrl.text), child: const Text('Add')),
                    ],
                  ),
                );
                if (v != null && v.trim().isNotEmpty) notifier.addAchievement(v.trim());
              },
            ),
            const SizedBox(height: 16),
            exportAsync.when(
              data: (_) => const Text('PDF ready — tap the PDF icon to export & share.',
                  style: TextStyle(color: Colors.green)),
              loading: () => const LinearProgressIndicator(),
              error: (e, _) => Text('PDF error: $e', style: const TextStyle(color: Colors.red)),
            ),
          ],
        ),
      ),
    );
  }
}
