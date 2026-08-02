import 'package:flutter/material.dart';
import 'package:profileforge/core/effects/shimmer_skeleton.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:profileforge/features/xp/application/xp_providers.dart';
import 'package:profileforge/features/streak/application/streak_providers.dart';
import 'package:profileforge/features/timer/application/timer_providers.dart';
import 'package:profileforge/features/achievements/application/achievement_providers.dart';

/// Screen to share your progress as an image/text card.
class ShareProgressScreen extends ConsumerWidget {
  final String profileId;
  const ShareProgressScreen({super.key, required this.profileId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final totalXpAsync = ref.watch(totalXpProvider(profileId));
    final streakAsync = ref.watch(streakProvider(profileId));
    final achCountAsync = ref.watch(achievementCountProvider(profileId));
    final focusMinAsync = ref.watch(totalFocusMinutesProvider(profileId));

    return Scaffold(
      backgroundColor: Palette.black,
      appBar: AppBar(title: const Text('Share Progress'), centerTitle: true, backgroundColor: Palette.surface1, actions: [
        IconButton(icon: const Icon(Icons.share_rounded), onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Share feature coming — share_plus needs platform setup')));
        }),
      ]),
      body: SafeArea(
        child: Center(
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
                  boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 20, offset: const Offset(0, 8))],
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('ProfileForge', style: TextStyle(color: Colors.white70, fontWeight: FontWeight.w300, fontSize: 12)),
                        Text('🌟', style: TextStyle(fontSize: 24)),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Text('My Progress', style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 16),
                    _ProgressRow(label: 'XP', value: totalXpAsync.valueOrNull?.toString() ?? '0', icon: '⭐'),
                    const SizedBox(height: 8),
                    _ProgressRow(label: 'Streak', value: '${streakAsync.valueOrNull?.current ?? 0} days', icon: '🔥'),
                    const SizedBox(height: 8),
                    _ProgressRow(label: 'Badges', value: achCountAsync.valueOrNull?.toString() ?? '0', icon: '🏆'),
                    const SizedBox(height: 8),
                    _ProgressRow(label: 'Focus', value: '${focusMinAsync.valueOrNull ?? 0} min', icon: '⏱️'),
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
                  final text = '🌟 My ProfileForge Progress:\n'
                      '⭐ XP: ${totalXpAsync.valueOrNull ?? 0}\n'
                      '🔥 Streak: ${streakAsync.valueOrNull?.current ?? 0} days\n'
                      '🏆 Badges: ${achCountAsync.valueOrNull ?? 0}\n'
                      '⏱️ Focus: ${focusMinAsync.valueOrNull ?? 0} min\n'
                      'Download ProfileForge and build YOUR future!';
                  Clipboard.setData(ClipboardData(text: text));
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text('📋 Progress copied to clipboard!'),
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
      ),
    );
  }
}

class _ProgressRow extends StatelessWidget {
  final String label;
  final String value;
  final String icon;
  const _ProgressRow({required this.label, required this.value, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Text(icon, style: const TextStyle(fontSize: 18)),
            const SizedBox(width: 8),
            Text(label, style: const TextStyle(color: Colors.white70, fontSize: 14)),
          ],
        ),
        Text(value, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
      ],
    );
  }
}
