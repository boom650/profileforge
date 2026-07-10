import '../../models/gamification/streak.dart';
import '../../models/gamification/admissions_pillar.dart';

mixin StreakService on GamificationService {
  /// Mark today as active.
  ///
  /// Handles:
  /// - Normal streak increment (yesterday was active)
  /// - First-ever day (streak becomes 1)
  /// - Already marked today → [StreakActionResult.alreadyMarked]
  /// - Missed day with freeze tokens available → consume token
  /// - Missed day with grace day applied
  /// - Streak break → encouraging message
  Future<StreakActionResult> markDailyActive({
    GraceDayReason? graceDayReason,
  }) async {
    resetCountersIfNeeded();

    final today = _today();
    final lastActive = streak.lastActiveDate;

    // ── Already marked today ──
    if (lastActive != null && _isSameDay(lastActive, today)) {
      return StreakActionResult.alreadyMarked(
        streak: streak,
        message: "You've already checked in today — great consistency! 🌟",
      );
    }

    // ── First time / fresh start ──
    if (lastActive == null) {
      final newStreak = streak.copyWith(
        currentStreak: 1,
        longestStreak: 1,
        totalActiveDays: streak.totalActiveDays + 1,
        lastActiveDate: today,
        streakStartDate: today,
        weeklyCheckInsCompleted: streak.weeklyCheckInsCompleted + 1,
        weeklyActivityPattern: updateActivityPattern(
          streak.weeklyActivityPattern,
          today,
        ),
      );

      // Award daily check-in XP
      final xpResult = await addXP(
        amount: 20,
        pillar: AdmissionsPillar.consistency,
        source: 'daily_checkin',
      );

      final milestones = checkStreakMilestones(newStreak);
      streak = applyMilestoneRewards(newStreak, milestones);

      saveToPrefs();

      return StreakActionResult.success(
        newStreak: streak,
        newMilestones: milestones,
        xpEarned: xpResult.totalXP,
        freezeTokensEarned: 0,
        graceDaysEarned: 0,
        message: "Welcome! Your streak journey begins today! 🚀",
      );
    }

    // ── Calculate gap ──
    final daysBetween = today.difference(lastActive).inDays;

    if (daysBetween == 1) {
      // ── Perfect consecutive day ──
      final newStreakValue = streak.currentStreak + 1;
      final newStreak = streak.copyWith(
        currentStreak: newStreakValue,
        longestStreak:
            newStreakValue > streak.longestStreak
                ? newStreakValue
                : streak.longestStreak,
        totalActiveDays: streak.totalActiveDays + 1,
        lastActiveDate: today,
        weeklyCheckInsCompleted: streak.weeklyCheckInsCompleted + 1,
        weeklyActivityPattern: updateActivityPattern(
          streak.weeklyActivityPattern,
          today,
        ),
      );

      final xpResult = await addXP(
        amount: 20,
        pillar: AdmissionsPillar.consistency,
        source: 'daily_checkin',
      );

      final milestones = checkStreakMilestones(newStreak);
      streak = applyMilestoneRewards(newStreak, milestones);

      saveToPrefs();

      return StreakActionResult.success(
        newStreak: streak,
        newMilestones: milestones,
        xpEarned: xpResult.totalXP,
        freezeTokensEarned: 0,
        graceDaysEarned: 0,
        message: streakMessage(newStreakValue),
      );
    }

    if (daysBetween <= 0) {
      // Same day or time travel — should not happen
      return StreakActionResult.alreadyMarked(
        streak: streak,
        message: 'Already active today.',
      );
    }

    // ── Gap of 2+ days ──
    final missedDays = daysBetween - 1; // Days missed (not counting today)

    // Try freeze tokens first
    if (streak.freezeTokens >= missedDays) {
      final tokensUsed = missedDays;
      final newStreakValue = streak.currentStreak + daysBetween;
      final newStreak = streak.copyWith(
        currentStreak: newStreakValue,
        longestStreak:
            newStreakValue > streak.longestStreak
                ? newStreakValue
                : streak.longestStreak,
        totalActiveDays: streak.totalActiveDays + 1,
        freezeTokens: streak.freezeTokens - tokensUsed,
        lastActiveDate: today,
        weeklyCheckInsCompleted: streak.weeklyCheckInsCompleted + 1,
        weeklyActivityPattern: updateActivityPattern(
          streak.weeklyActivityPattern,
          today,
        ),
      );
      streak = newStreak;

      await addXP(
        amount: 20,
        pillar: AdmissionsPillar.consistency,
        source: 'daily_checkin',
      );

      saveToPrefs();

      return StreakActionResult.freezeTokenUsed(
        newStreak: streak,
        tokensUsed: tokensUsed,
        message:
            'Used $tokensUsed freeze token${tokensUsed > 1 ? 's' : ''} to protect your streak! 🔮',
      );
    }

    // Try grace days
    if (graceDayReason != null &&
        streak.graceDaysRemaining > 0 &&
        streak.graceDaysUsedThisWeek < streakConfig.weeklyGraceDays) {
      final cost =
          streakConfig.graceDayCosts[graceDayReason] ?? 1;
      if (streak.graceDaysRemaining >= cost) {
        final graceUsage = GraceDayUsage(
          id: 'gd_${DateTime.now().millisecondsSinceEpoch}',
          dateUsed: today,
          reason: graceDayReason,
          note: null,
          wasAutoApplied: false,
        );
        final newStreakValue = streak.currentStreak + daysBetween;
        final newStreak = streak.copyWith(
          currentStreak: newStreakValue,
          longestStreak:
              newStreakValue > streak.longestStreak
                  ? newStreakValue
                  : streak.longestStreak,
          totalActiveDays: streak.totalActiveDays + 1,
          graceDaysRemaining: streak.graceDaysRemaining - cost,
          graceDaysUsedThisWeek: streak.graceDaysUsedThisWeek + 1,
          graceDayHistory: [...streak.graceDayHistory, graceUsage],
          lastActiveDate: today,
          weeklyCheckInsCompleted: streak.weeklyCheckInsCompleted + 1,
          weeklyActivityPattern: updateActivityPattern(
            streak.weeklyActivityPattern,
            today,
          ),
        );
        streak = newStreak;

        await addXP(
          amount: 20,
          pillar: AdmissionsPillar.consistency,
          source: 'daily_checkin',
        );

        saveToPrefs();

        return StreakActionResult.graceDayUsed(
          newStreak: streak,
          graceDayUsage: graceUsage,
          message: graceDayMessage(graceDayReason),
        );
      }
    }

    // ── Streak broken ──
    final previousStreak = streak.currentStreak;
    final newStreak = streak.copyWith(
      currentStreak: 1,
      lastActiveDate: today,
      totalActiveDays: streak.totalActiveDays + 1,
      weeklyCheckInsCompleted: streak.weeklyCheckInsCompleted + 1,
      weeklyActivityPattern: updateActivityPattern(
        streak.weeklyActivityPattern,
        today,
      ),
    );
    streak = newStreak;

    saveToPrefs();

    return StreakActionResult.streakBroken(
      newStreak: streak,
      previousStreak: previousStreak,
      message:
          'Streak of $previousStreak days ended. Starting fresh today!',
      encouragementMessage: encouragementMessage(previousStreak),
    );
  }

  /// Add a freeze token (e.g. from league rewards, milestones).
  void addFreezeToken() {
    if (streak.freezeTokens < streak.maxFreezeTokens) {
      streak = streak.copyWith(
        freezeTokens: streak.freezeTokens + 1,
        freezeTokensEarned: streak.freezeTokensEarned + 1,
        lastFreezeTokenEarned: DateTime.now(),
      );
    }
  }

  /// Use a grace day manually (outside of mark flow).
  void useGraceDay(GraceDayReason reason) {
    if (streak.graceDaysRemaining <= 0) return;
    final cost = streakConfig.graceDayCosts[reason] ?? 1;
    if (streak.graceDaysRemaining < cost) return;

    final usage = GraceDayUsage(
      id: 'gd_${DateTime.now().millisecondsSinceEpoch}',
      dateUsed: DateTime.now(),
      reason: reason,
      note: null,
      wasAutoApplied: false,
    );
    streak = streak.copyWith(
      graceDaysRemaining: streak.graceDaysRemaining - cost,
      graceDaysUsedThisWeek: streak.graceDaysUsedThisWeek + 1,
      graceDayHistory: [...streak.graceDayHistory, usage],
    );
  }

  // ── Streak helpers ────────────────────────────────────────────────────

  List<StreakMilestone> checkStreakMilestones(Streak streak) {
    final newlyAchieved = <StreakMilestone>[];
    for (final config in streakConfig.milestones) {
      // Skip if already achieved
      if (streak.milestonesAchieved.any(
        (m) => m.type == config.type,
      )) {
        continue;
      }
      if (streak.currentStreak >= config.daysRequired) {
        newlyAchieved.add(
          StreakMilestone(
            id: 'sm_${config.type.name}_${DateTime.now().millisecondsSinceEpoch}',
            type: config.type,
            daysRequired: config.daysRequired,
            title: config.title,
            description: config.description,
            xpReward: config.xpReward,
            freezeTokenReward: config.freezeTokenReward,
            graceDayReward: config.graceDayReward,
            achievedAt: DateTime.now(),
            isClaimed: false,
          ),
        );
      }
    }
    return newlyAchieved;
  }

  Streak applyMilestoneRewards(Streak streak, List<StreakMilestone> milestones) {
    if (milestones.isEmpty) return streak;

    var updated = streak;
    final allMilestones = [...streak.milestonesAchieved, ...milestones];
    int extraFreeze = 0;
    int extraGrace = 0;

    for (final m in milestones) {
      extraFreeze += m.freezeTokenReward;
      extraGrace += m.graceDayReward;
    }

    updated = updated.copyWith(
      milestonesAchieved: allMilestones,
      freezeTokens: (updated.freezeTokens + extraFreeze)
          .clamp(0, updated.maxFreezeTokens),
      graceDaysRemaining: updated.graceDaysRemaining + extraGrace,
    );

    // Award milestone XP (fire-and-forget)
    for (final m in milestones) {
      if (m.xpReward > 0) {
        addXP(
          amount: m.xpReward,
          pillar: AdmissionsPillar.consistency,
          source: 'streak_milestone',
        );
      }
    }

    return updated;
  }

  String streakMessage(int days) {
    if (days >= 365) return "An entire YEAR?! You are a legend! 👑";
    if (days >= 180) return "Half a year of dominance! Incredible! 🏆";
    if (days >= 90) return "90 days! You've built an unbreakable habit! 💪";
    if (days >= 60) return "60 days strong — a true Marathon Runner! 🏃";
    if (days >= 30) return "30 days! Science says this is now a HABIT! 🧠";
    if (days >= 21) return "21 days — habit officially FORMED! ⚡";
    if (days >= 14) return "Two weeks of consistency! You're on fire! 🔥";
    if (days >= 7) return "One full week! The streak is real! 🎉";
    if (days >= 3) return "$days days! You're building momentum! 🌟";
    return "$days days in! Keep going! 💫";
  }

  String encouragementMessage(int previousStreak) {
    if (previousStreak >= 30) {
      return "You had an incredible $previousStreak-day streak! "
          "That discipline is already inside you. Time to rebuild! 💪";
    }
    if (previousStreak >= 14) {
      return "14+ days shows real commitment. "
          "A single missed day doesn't erase that. Let's go again! 🔥";
    }
    if (previousStreak >= 7) {
      return "You proved you can do a full week! "
          "This is just a reset, not a failure. You've got this! ⭐";
    }
    return "Every expert started with day one. "
        "This is your new beginning! 🚀";
  }

  String graceDayMessage(GraceDayReason reason) {
    switch (reason) {
      case GraceDayReason.sick:
        return "Rest up and feel better! Your streak is protected. 🤗";
      case GraceDayReason.familyEmergency:
        return "Family first — always. Streak protected. ❤️";
      case GraceDayReason.travel:
        return "Enjoy the journey! Your streak is safe. ✈️";
      case GraceDayReason.exams:
        return "Focus on those exams — streak protected! 📚";
      case GraceDayReason.mentalHealth:
        return "Taking care of yourself is the bravest thing. Streak protected. 🌿";
      case GraceDayReason.technicalIssue:
        return "Tech glitches happen! Streak protected. 🔧";
      case GraceDayReason.other:
        return "Grace day used — your streak lives on! 🌟";
    }
  }

  List<int> updateActivityPattern(List<int> pattern, DateTime day) {
    final updated = List<int>.from(pattern);
    final index = day.weekday - 1; // 0 = Mon … 6 = Sun
    if (index >= 0 && index < 7) {
      updated[index] += 1;
    }
    return updated;
  }
}
