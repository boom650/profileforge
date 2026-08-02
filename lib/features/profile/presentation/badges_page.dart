import 'package:shimmer/shimmer.dart';
import package:profileforge/core/effects/shimmer_skeleton.dart;
import 'package:profileforge/core/widgets/premium_widgets.dart';
import 'package:profileforge/core/effects/error_widgets.dart';
import 'package:profileforge/core/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:profileforge/features/profile/application/profile_providers.dart';

/// Badges derived from achievements. Accessible grid.
class BadgesPage extends ConsumerWidget {
  final String profileId;
  const BadgesPage({super.key, required this.profileId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dark = isDark(context);
    final profile = ref.watch(profileProvider(profileId));
    return Scaffold(
      backgroundColor: dark ? Palette.black : const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: dark ? Palette.surface1 : Colors.white,
        elevation: 0,
        title: Text(
          'Badges',
          style: TextStyle(
            color: dark ? Palette.textPrimary : Palette.textInverse,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: SafeArea(
        child: profile.when(
          loading: () => const Center(child: ShimmerLoader.card()),
          error: (e, _) => PremiumErrorWidget(
            title: 'Failed to load badges',
            message: '$e',
            onRetry: () => ref.invalidate(profileProvider(profileId)),
          ),
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
                  color: earned ? Colors.deepPurple : Colors.grey),
              const SizedBox(height: 4),
              Text(label, textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 12)),
            ],
          ),
        ),
      );
}
