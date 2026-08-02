import 'package:flutter/material.dart';
import ../../../core/effects/shimmer_skeleton.dart;
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';

import 'package:shimmer/shimmer.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/premium_widgets.dart';
import '../../../core/widgets/tap_scale.dart';
import '../application/challenge_providers.dart';

/// ────────────────────────────────────────────────────────────────────────────
/// Challenges screen — Premium challenge cards with time remaining and rewards.
/// ────────────────────────────────────────────────────────────────────────────
class ChallengesScreen extends ConsumerWidget {
  final String profileId;
  const ChallengesScreen({super.key, required this.profileId});

  static const _challengeGradients = [
    [Color(0xFF3B82F6), Color(0xFF60A5FA)],  // Blue
    [Color(0xFFF59E0B), Color(0xFFFBBF24)],  // Amber
    [Color(0xFF8B5CF6), Color(0xFFA78BFA)],  // Violet
    [Color(0xFF10B981), Color(0xFF34D399)],  // Emerald
    [Color(0xFFEF4444), Color(0xFFF87171)],  // Red
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final challengesAsync = ref.watch(challengeListProvider(profileId));
    final dark = isDark(context);

    return Scaffold(
      backgroundColor: dark ? Palette.black : const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: dark ? Palette.surface1 : Colors.white,
        elevation: 0,
        title: const Text(
          'Challenges',
          style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
          child: challengesAsync.when(
        data: (challenges) {
          if (challenges.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.emoji_events_outlined, color: Palette.textTertiary, size: 48),
                  const SizedBox(height: 12),
                  Text(
                    'No challenges yet',
                    style: TextStyle(color: Palette.textPrimary, fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Challenges will appear as you progress',
                    style: TextStyle(color: Palette.textSecondary, fontSize: 13),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(20),
            itemCount: challenges.length,
            itemBuilder: (context, i) {
              final c = challenges[i];
              final gradient = _challengeGradients[i % _challengeGradients.length];
              final progress = c.progress ?? 0;
              final target = c.targetCount ?? 1;
              final pct = target > 0 ? (progress / target).clamp(0.0, 1.0) : 0.0;
              final completed = pct >= 1.0;

              // Time remaining
              String timeLeft = '';
              if (c.deadline != null) {
                final diff = c.deadline!.difference(DateTime.now());
                if (diff.isNegative) {
                  timeLeft = 'Expired';
                } else if (diff.inDays > 0) {
                  timeLeft = '${diff.inDays}d left';
                } else if (diff.inHours > 0) {
                  timeLeft = '${diff.inHours}h left';
                } else {
                  timeLeft = '${diff.inMinutes}m left';
                }
              }

              return Padding(
                padding: const EdgeInsets.only(bottom: 14),
                child: TapScale(
                  onTap: () => HapticFeedback.mediumImpact(),
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: gradient.map((c) => c.withValues(alpha: completed ? 0.25 : 0.12)).toList(),
                      ),
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(
                        color: gradient[0].withValues(alpha: completed ? 0.5 : 0.2),
                      ),
                    ),
                    padding: const EdgeInsets.all(18),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            // Challenge icon
                            Container(
                              width: 48,
                              height: 48,
                              decoration: BoxDecoration(
                                color: gradient[0].withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Icon(
                                completed ? Icons.check_circle : Icons.emoji_events,
                                color: completed ? Palette.success : gradient[0],
                                size: 24,
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    c.title ?? 'Challenge',
                                    style: TextStyle(
                                      color: Palette.textPrimary,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  if (c.description?.isNotEmpty == true)
                                    Text(
                                      c.description!,
                                      style: TextStyle(
                                        color: Palette.textSecondary,
                                        fontSize: 12,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),

                        // Progress bar
                        ClipRRect(
                          borderRadius: BorderRadius.circular(6),
                          child: LinearProgressIndicator(
                            value: pct,
                            minHeight: 8,
                            backgroundColor: Palette.surface2,
                            valueColor: AlwaysStoppedAnimation(
                              completed ? Palette.success : gradient[0],
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),

                        // Bottom row: progress, time, reward
                        Row(
                          children: [
                            Text(
                              '$progress/$target',
                              style: TextStyle(
                                color: Palette.textSecondary,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            if (timeLeft.isNotEmpty) ...[
                              const SizedBox(width: 12),
                              Icon(Icons.schedule, color: Palette.warning, size: 12),
                              const SizedBox(width: 4),
                              Text(
                                timeLeft,
                                style: TextStyle(
                                  color: Palette.warning,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                            const Spacer(),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: Palette.accent.withValues(alpha: 0.12),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                '+${c.xpReward ?? 0} XP',
                                style: const TextStyle(
                                  color: Palette.accent,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ).animate().fadeIn(delay: Duration(milliseconds: i * 80), duration: 300.ms)
                 .slideY(begin: 0.05),
              );
            },
          );
        },
        loading: () => const Center(child: ShimmerLoader.missions()),
        error: (e, _) => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error_outline, color: Palette.error, size: 48),
              const SizedBox(height: 12),
              Text('Error: $e', style: TextStyle(color: Palette.textSecondary)),
            ],
          ),
        ),
      ),
      ),
    );
  }
}
