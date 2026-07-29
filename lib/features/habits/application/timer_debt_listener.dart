import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:profileforge/features/timer/application/timer_providers.dart';
import 'package:profileforge/features/xp/application/xp_debt_provider.dart';

/// Listens to timer completion and creates XP debt if a streak was broken.
final timerDebtListener = Provider.autoDispose.family<void, String>((ref, profileId) {
  ref.listen<TimerSnapshot>(timerStateProvider, (previous, next) {
    if (previous != null && previous.isRunning && !next.isRunning && next.secondsRemaining > 0) {
      // User stopped early -> debt
      final missed = (previous.durationMinutes - (previous.durationMinutes * (1 - next.secondsRemaining / (previous.durationMinutes * 60))).round()).abs();
      if (missed > 0) {
        ref.read(xpDebtProvider).addDebt(profileId, missed * 2, 'Early stop');
      }
    }
  });
});
