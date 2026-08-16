import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:profileforge/core/theme/app_theme.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:profileforge/features/timer/application/timer_providers.dart';

enum BuddyState { idle, focusing, paused, success, sad }

class BodyDoubleWidget extends ConsumerWidget {
  const BodyDoubleWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final timerState = ref.watch(timerStateProvider);
    
    BuddyState state;
    if (timerState.isRunning && !timerState.isPaused) {
      state = BuddyState.focusing;
    } else if (timerState.isPaused) {
      state = BuddyState.paused;
    } else {
      state = BuddyState.idle;
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _BuddyVisual(state: state),
        const SizedBox(height: 8),
        _BuddySpeech(state: state),
      ],
    );
  }
}

class _BuddyVisual extends StatelessWidget {
  final BuddyState state;
  const _BuddyVisual({required this.state});

  @override
  Widget build(BuildContext context) {
    final IconData icon;
    switch (state) {
      case BuddyState.focusing: icon = Icons.edit_rounded; break;
      case BuddyState.paused: icon = Icons.local_cafe_rounded; break;
      case BuddyState.success: icon = Icons.celebration_rounded; break;
      case BuddyState.sad: icon = Icons.sentiment_dissatisfied_rounded; break;
      case BuddyState.idle: icon = Icons.waving_hand_rounded; break;
    }

    return Container(
      width: 80, height: 80,
      decoration: BoxDecoration(
        color: Palette.accentBlue.withValues(alpha: 0.1),
        shape: BoxShape.circle,
        border: Border.all(color: Palette.accentBlue.withValues(alpha: 0.3), width: 2),
      ),
      child: Center(
          child: Icon(icon, size: 40, color: Palette.accentBlue)),
    ).animate(target: state == BuddyState.focusing ? 1 : 0)
     .shimmer(duration: 2.seconds)
     .shake(duration: 1.seconds);
  }
}

class _BuddySpeech extends StatelessWidget {
  final BuddyState state;
  const _BuddySpeech({required this.state});

  @override
  Widget build(BuildContext context) {
    String text;
    switch (state) {
      case BuddyState.focusing: text = "I'm studying with you!"; break;
      case BuddyState.paused: text = "Ready when you are."; break;
      case BuddyState.success: text = "We crushed it!"; break;
      case BuddyState.sad: text = "Let's pay that debt."; break;
      case BuddyState.idle: text = "Ready for a session?"; break;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(color: Palette.ink.withValues(alpha: 0.54), borderRadius: BorderRadius.circular(12)),
      child: Text(text, style: const TextStyle(color: Colors.white, fontSize: 11)),
    );
  }
}
