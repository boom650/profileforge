import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:profileforge/core/theme/app_theme.dart';
import 'package:profileforge/features/habits/application/habit_providers.dart';

/// Real-time XP debt banner: shows the outstanding debt (early timer stops /
/// broken streaks) so the user always knows what must be earned back.
/// Hidden entirely while there is no debt.
class HabitDebtBanner extends ConsumerWidget {
  const HabitDebtBanner({super.key, required this.profileId});

  final String profileId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final debt = ref.watch(outstandingDebtProvider(profileId)).valueOrNull ?? 0;
    if (debt <= 0) return const SizedBox.shrink();

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Palette.error.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Palette.error.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          const Icon(Icons.warning_amber_rounded, size: 20, color: Palette.error),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'XP debt: -$debt — complete focus sessions to earn it back.',
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Palette.error,
              ),
            ),
          ),
        ],
      ),
    );
  }
}