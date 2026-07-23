import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:profileforge/features/timer/application/timer_providers.dart';
import 'package:profileforge/features/xp/application/xp_debt_provider.dart';

/// Listens to timer completion and creates XP debt if a streak was broken.
final timerDebtListener = Provider.autoDispose((ref) {
  ref.listen<TimerState>(timerStateProvider, (previous, next) {
    if (previous != null && previous.isRunning && !next.isRunning && next.secondsRemaining > 0) {
      // User stopped early -> debt
      final missed = (previous.durationMinutes - (previous.durationMinutes * (1 - next.secondsRemaining / (previous.durationMinutes * 60))).round()).abs();
      if (missed > 0) {
        ref.read(xpDebtProvider).addDebt('default-profile', missed * 2, 'Early stop');
      }
    }
    if (next.isRunning && !next.isPaused && next.secondsRemaining == 0) {
      // Session completed successfully – clear related debt if any
      // (Simplified: mark all debts for this profile as paid)
      // In production we would match exact debt reason.
    }
  });
});
