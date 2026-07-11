import '../../models/gamification/xp.dart';
import '../../models/gamification/admissions_pillar.dart';
import '../../models/gamification/skins.dart';

mixin XPService on GamificationService {
  /// Add XP with streak multiplier and weekend bonus.
  ///
  /// - Streak bonus: +5 % per 7 days of streak (max +50 %)
  /// - Weekend bonus: +10 % on Sat / Sun
  /// - XP is attributed to the specified [pillar]
  Future<XPAddResult> addXP({
    required int amount,
    required AdmissionsPillar pillar,
    String? source,
    String? missionId,
  }) async {
    resetCountersIfNeeded();

    // ── Apply multipliers ──
    final int adjustedAmount = XPUtils.calculateXPWithBonus(
      baseXP: amount,
      currentStreak: streak.currentStreak,
      isWeekend: isWeekend(),
    );

    // ── Update XP state ──
    final previousLevel = xpState.currentLevel;
    final newTotalXP = xpState.totalXP + adjustedAmount;
    final newPillarXP = Map<AdmissionsPillar, int>.from(xpState.pillarXP);
    newPillarXP[pillar] = (newPillarXP[pillar] ?? 0) + adjustedAmount;

    final newLevel = XPUtils.levelFromXP(newTotalXP);
    final newPillarLevels = Map<AdmissionsPillar, int>.from(xpState.pillarLevels);
    newPillarLevels[pillar] = XPUtils.pillarLevel(newPillarXP[pillar]!);

    xpState = xpState.copyWith(
      totalXP: newTotalXP,
      pillarXP: newPillarXP,
      currentLevel: newLevel,
      xpToNextLevel: XPUtils.xpToNextLevel(newTotalXP),
      pillarLevels: newPillarLevels,
      lastUpdated: DateTime.now(),
      lifetimeXPEarned: xpState.lifetimeXPEarned + adjustedAmount,
    );

    // ── Transaction log ──
    final transaction = XPTransaction(
      id: 'txn_${DateTime.now().millisecondsSinceEpoch}',
      amount: adjustedAmount,
      pillar: pillar,
      type: source != null
          ? sourceTypeToTransactionType(source)
          : XPTransactionType.activity,
      source: source ?? 'unknown',
      description: 'Earned $adjustedAmount XP in ${pillar.name}',
      timestamp: DateTime.now(),
      metadata: missionId != null ? {'missionId': missionId} : null,
    );
    xpState = xpState.copyWith(
      transactionHistory: [...xpState.transactionHistory, transaction],
    );

    // ── Level-up detection ──
    final bool leveledUp = newLevel > previousLevel;
    if (leveledUp) {
      levelUpController.add(newLevel);
    }

    // ── Check for newly unlocked skins ──
    final SkinTier? newSkin = checkAndUnlockSkins();

    saveToPrefs();

    return XPAddResult(
      totalXP: xpState.totalXP,
      pillarXP: newPillarXP[pillar]!,
      leveledUp: leveledUp,
      newLevel: newLevel,
      newSkinUnlocked: newSkin,
      xpToNextLevel: XPUtils.xpToNextLevel(xpState.totalXP),
      xpToNextSkin: xpToNextSkin,
    );
  }

  /// Find the next skin the player can unlock (by tierOrder).
  SkinTier? nextSkinToUnlockTier() {
    final ordered = SkinCatalog.getOrderedTiers();
    for (final tier in ordered) {
      if (!ownedSkins.containsKey(tier)) return tier;
    }
    return null;
  }

  int get xpToNextSkin {
    final next = nextSkinToUnlockTier();
    if (next == null) return 0;
    final config = SkinCatalog.getConfig(next);
    final remaining = config.xpRequired - xpState.totalXP;
    return remaining > 0 ? remaining : 0;
  }

  /// Transaction type mapping.
  XPTransactionType sourceTypeToTransactionType(String source) {
    if (source.contains('mission')) return XPTransactionType.mission;
    if (source.contains('streak')) return XPTransactionType.streak;
    if (source.contains('verify')) return XPTransactionType.verification;
    if (source.contains('bonus')) return XPTransactionType.bonus;
    if (source.contains('milestone')) return XPTransactionType.milestone;
    return XPTransactionType.activity;
  }

  // ── Reset counters ────────────────────────────────────────────────────

  void resetCountersIfNeeded() {
    final now = _today();
    if (!_isSameDay(lastDayReset, now)) {
      dailyActivityCounts.clear();
      lastDayReset = now;

      // Check for weekly reset
      final weekStart = _startOfWeek(now);
      if (weekStart.isAfter(lastWeekReset)) {
        weeklyActivityCounts.clear();
        lastWeekReset = weekStart;
        streak = streak.copyWith(
          weeklyCheckInsCompleted: 0,
          graceDaysUsedThisWeek: 0,
        );
      }

      saveToPrefs();
    }
  }
}