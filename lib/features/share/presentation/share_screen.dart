import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:profileforge/features/share/application/share_providers.dart';
import 'package:profileforge/features/share/domain/share_models.dart';
import 'package:profileforge/core/theme/app_theme.dart';

/// Screen to share your progress as an image/text card.
class ShareProgressScreen extends ConsumerWidget {
  final String profileId;
  const ShareProgressScreen({super.key, required this.profileId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final snapshotAsync = ref.watch(shareSnapshotProvider(profileId));
    final snapshot = snapshotAsync.valueOrNull;
    final xp = snapshot?.xp ?? 0;
    final streak = snapshot?.streak ?? 0;
    final badges = snapshot?.badges ?? 0;
    final focusMin = snapshot?.focusMinutes ?? 0;

    return Scaffold(
      appBar: AppBar(title: const Text('Share Progress'), centerTitle: true, actions: [
        IconButton(icon: const Icon(Icons.share_rounded), onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Share feature coming — share_plus needs platform setup')));
        }),
      ]),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Progress card preview
              Container(
                width: 320,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft, end: Alignment.bottomRight,
                    colors: [theme.colorScheme.primary, theme.colorScheme.tertiary],
                  ),
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [BoxShadow(color: Palette.ink.withValues(alpha: 0.26), blurRadius: 20, offset: const Offset(0, 8))],
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('ProfileForge', style: TextStyle(color: Colors.white70, fontWeight: FontWeight.w300, fontSize: 12)),
                        Icon(Icons.auto_awesome_rounded,
                            size: 24, color: Colors.white70),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Text('My Progress', style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 16),
                    _ProgressRow(label: 'XP', value: '$xp', icon: Icons.star_rounded),
                    const SizedBox(height: 6),
                    _ProgressRow(label: 'Streak', value: '$streak days', icon: Icons.local_fire_department_rounded),
                    const SizedBox(height: 6),
                    _ProgressRow(label: 'Badges', value: '$badges', icon: Icons.emoji_events_rounded),
                    const SizedBox(height: 6),
                    _ProgressRow(label: 'Focus', value: '$focusMin min', icon: Icons.timer_outlined),
                    const SizedBox(height: 20),
                    Text('ProfileForge — Build your future', style: TextStyle(color: Colors.white54, fontSize: 10)),
                  ],
                ),
              ),

              const SizedBox(height: 24),
              Text('Share this card with friends!', style: theme.textTheme.bodyMedium),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: () {
                  final text = (snapshot ?? const ShareSnapshot(xp: 0, streak: 0, badges: 0, focusMinutes: 0))
                      .buildShareText();
                  Clipboard.setData(ClipboardData(text: text));
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text('Progress copied to clipboard!'),
                    duration: Duration(seconds: 2),
                  ));
                },
                icon: const Icon(Icons.copy_rounded),
                label: const Text('Copy to Share'),
                style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProgressRow extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  const _ProgressRow({required this.label, required this.value, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(icon, size: 18, color: Colors.white70),
            const SizedBox(width: 8),
            Text(label, style: const TextStyle(color: Colors.white70, fontSize: 14)),
          ],
        ),
        Text(value, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
      ],
    );
  }
}
