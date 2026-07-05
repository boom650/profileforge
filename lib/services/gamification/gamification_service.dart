import 'dart:async';
import 'package:flutter/foundation.dart';
import '../../models/gamification/skins.dart';
import '../../models/gamification/streak.dart';
import '../../models/gamification/xp.dart';
import '../../models/gamification/missions.dart';
import '../../models/gamification/admissions_pillar.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

/// XP add result — returned whenever XP is awarded.
@immutable
class XPAddResult {
  final int totalXP;
  final int pillarXP;
  final bool leveledUp;
  final int newLevel;
  final SkinTier? newSkinUnlocked;
  final int xpToNextLevel;
  final int xpToNextSkin;

  const XPAddResult({
    required this.totalXP,
    required this.pillarXP,
    required this.leveledUp,
    required this.newLevel,
    this.newSkinUnlocked,
    required this.xpToNextLevel,
    required this.xpToNextSkin,
  });
}

class GamificationService {
  static const String _prefsKey = 'gamification_state';

  GamificationService() {
    _loadFromPrefs();
  }

  // ─── Internal state ───────────────────────────────────────────────────
  XPState _xpState = XPState.initial();
  Streak _streak = Streak.initial();
  final List<Mission> _missions = [];
  WeeklyMissionSet? _weeklyMissionSet;
  StreakConfig _streakConfig = StreakConfig.defaultConfig();

  // Skin collection (starts with explorer unlocked)
  final Map<SkinTier, Skin> _ownedSkins = {
    SkinTier.explorer:
        SkinCatalog.getConfig(SkinTier.explorer).toSkin(unlocked: true),
  };
  SkinTier _equippedSkin = SkinTier.explorer;
  String _equippedFrameId = 'frame_default';
  final List<String> _equippedBadges = [];

  // Activity rate-limiting counters (reset daily / weekly)
  final Map<String, int> _dailyActivityCounts = {};
  final Map<String, int> _weeklyActivityCounts = {};
  DateTime _lastDayReset = _today();
  DateTime _lastWeekReset = _startOfWeek(DateTime.now());

  // ─── Stream controllers ───────────────────────────────────────────────
  final _skinUnlockController = StreamController<Skin>.broadcast();
  final _levelUpController = StreamController<int>.broadcast();
  final _missionCompleteController = StreamController<Mission>.broadcast();

  // ─── Public streams ───────────────────────────────────────────────────
  Stream<Skin> get skinUnlockStream => _skinUnlockController.stream;
  Stream<int> get levelUpStream => _levelUpController.stream;
  Stream<Mission> get missionCompleteStream =>
      _missionCompleteController.stream;

  // ─── Getters ──────────────────────────────────────────────────────────

  XPState get xpState => _xpState;

  int get totalXP => _xpState.totalXP;
  int get currentLevel => _xpState.currentLevel;
  int get xpToNextLevel => XPUtils.xpToNextLevel(_xpState.totalXP);
  SkinTier get currentSkinTier => _equippedSkin;
  String get equippedSkinId => _equippedSkin.name;
  String get equippedFrameId => _equippedFrameId;
  List<String> get equippedBadges => List.unmodifiable(_equippedBadges);

  Map<String, int> get pillarXP =>
      _xpState.pillarXP.map((k, v) => MapEntry(k.name, v));

  int get xpToNextSkin {
    final next = _nextSkinToUnlock();
    if (next == null) return 0;
    final config = SkinCatalog.getConfig(next);
    final remaining = config.xpRequired - _xpState.totalXP;
    return remaining > 0 ? remaining : 0;
  }

  Skin? get currentSkin => _ownedSkins[_equippedSkin];

  List<Skin> get unlockedSkins =>
      _ownedSkins.values.toList()..sort((a, b) => a.tierOrder.compareTo(b.tierOrder));

  List<Skin> get lockedSkins {
    final locked = <Skin>[];
    for (final tier in SkinTier.values) {
      if (!_ownedSkins.containsKey(tier)) {
        locked.add(SkinCatalog.getConfig(tier).toSkin(unlocked: false));
      }
    }
    return locked..sort((a, b) => a.tierOrder.compareTo(b.tierOrder));
  }

  Skin? get nextSkinToUnlock {
    final tier = _nextSkinToUnlock();
    if (tier == null) return null;
    return SkinCatalog.getConfig(tier).toSkin(unlocked: false);
  }

  Streak get currentStreak => _streak;
  int get freezeTokens => _streak.freezeTokens;
  List<DateTime> get graceDaysUsed =>
      _streak.graceDayHistory.map((g) => g.dateUsed).toList();

  List<Mission> get activeMissions =>
      _missions.where((m) => !m.isCompleted).toList();
  List<Mission> get completedMissions =>
      _missions.where((m) => m.isCompleted).toList();
  List<Mission> get dailyMissions =>
      _missions.where((m) => m.type == MissionType.daily).toList();
  List<Mission> get weeklyMissions =>
      _missions.where((m) => m.type == MissionType.weekly).toList();
  List<Mission> get milestoneMissions =>
      _missions.where((m) => m.type == MissionType.milestone).toList();
  WeeklyMissionSet? get weeklyMissionsSet => _weeklyMissionSet;

  // ─── XP System ────────────────────────────────────────────────────────

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
    _resetCountersIfNeeded();

    // ── Apply multipliers ──
    final int adjustedAmount = XPUtils.calculateXPWithBonus(
      baseXP: amount,
      currentStreak: _streak.currentStreak,
      isWeekend: _isWeekend(),
    );

    // ── Update XP state ──
    final previousLevel = _xpState.currentLevel;
    final newTotalXP = _xpState.totalXP + adjustedAmount;
    final newPillarXP = Map<AdmissionsPillar, int>.from(_xpState.pillarXP);
    newPillarXP[pillar] = (newPillarXP[pillar] ?? 0) + adjustedAmount;

    final newLevel = XPUtils.levelFromXP(newTotalXP);
    final newPillarLevels = Map<AdmissionsPillar, int>.from(_xpState.pillarLevels);
    newPillarLevels[pillar] = XPUtils.pillarLevel(newPillarXP[pillar]!);

    _xpState = _xpState.copyWith(
      totalXP: newTotalXP,
      pillarXP: newPillarXP,
      currentLevel: newLevel,
      xpToNextLevel: XPUtils.xpToNextLevel(newTotalXP),
      pillarLevels: newPillarLevels,
      lastUpdated: DateTime.now(),
      lifetimeXPEarned: _xpState.lifetimeXPEarned + adjustedAmount,
    );

    // ── Transaction log ──
    final transaction = XPTransaction(
      id: 'txn_${DateTime.now().millisecondsSinceEpoch}',
      amount: adjustedAmount,
      pillar: pillar,
      type: source != null
          ? _sourceTypeToTransactionType(source)
          : XPTransactionType.activity,
      source: source ?? 'unknown',
      description: 'Earned $adjustedAmount XP in ${pillar.name}',
      timestamp: DateTime.now(),
      metadata: missionId != null ? {'missionId': missionId} : null,
    );
    _xpState = _xpState.copyWith(
      transactionHistory: [..._xpState.transactionHistory, transaction],
    );

    // ── Level-up detection ──
    final bool leveledUp = newLevel > previousLevel;
    if (leveledUp) {
      _levelUpController.add(newLevel);
    }

    // ── Check for newly unlocked skins ──
    final SkinTier? newSkin = _checkAndUnlockSkins();

    _saveToPrefs();

    return XPAddResult(
      totalXP: _xpState.totalXP,
      pillarXP: newPillarXP[pillar]!,
      leveledUp: leveledUp,
      newLevel: newLevel,
      newSkinUnlocked: newSkin,
      xpToNextLevel: XPUtils.xpToNextLevel(_xpState.totalXP),
      xpToNextSkin: xpToNextSkin,
    );
  }

  // ─── Streak Management ────────────────────────────────────────────────

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
    _resetCountersIfNeeded();

    final today = _today();
    final lastActive = _streak.lastActiveDate;

    // ── Already marked today ──
    if (lastActive != null && _isSameDay(lastActive, today)) {
      return StreakActionResult.alreadyMarked(
        streak: _streak,
        message: "You've already checked in today — great consistency! 🌟",
      );
    }

    // ── First time / fresh start ──
    if (lastActive == null) {
      final newStreak = _streak.copyWith(
        currentStreak: 1,
        longestStreak: 1,
        totalActiveDays: _streak.totalActiveDays + 1,
        lastActiveDate: today,
        streakStartDate: today,
        weeklyCheckInsCompleted: _streak.weeklyCheckInsCompleted + 1,
        weeklyActivityPattern: _updateActivityPattern(
          _streak.weeklyActivityPattern,
          today,
        ),
      );

      // Award daily check-in XP
      final xpResult = await addXP(
        amount: 20,
        pillar: AdmissionsPillar.consistency,
        source: 'daily_checkin',
      );

      final milestones = _checkStreakMilestones(newStreak);
      _streak = _applyMilestoneRewards(newStreak, milestones);

      _saveToPrefs();

      return StreakActionResult.success(
        newStreak: _streak,
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
      final newStreakValue = _streak.currentStreak + 1;
      final newStreak = _streak.copyWith(
        currentStreak: newStreakValue,
        longestStreak:
            newStreakValue > _streak.longestStreak
                ? newStreakValue
                : _streak.longestStreak,
        totalActiveDays: _streak.totalActiveDays + 1,
        lastActiveDate: today,
        weeklyCheckInsCompleted: _streak.weeklyCheckInsCompleted + 1,
        weeklyActivityPattern: _updateActivityPattern(
          _streak.weeklyActivityPattern,
          today,
        ),
      );

      final xpResult = await addXP(
        amount: 20,
        pillar: AdmissionsPillar.consistency,
        source: 'daily_checkin',
      );

      final milestones = _checkStreakMilestones(newStreak);
      _streak = _applyMilestoneRewards(newStreak, milestones);

      _saveToPrefs();

      return StreakActionResult.success(
        newStreak: _streak,
        newMilestones: milestones,
        xpEarned: xpResult.totalXP,
        freezeTokensEarned: 0,
        graceDaysEarned: 0,
        message: _streakMessage(newStreakValue),
      );
    }

    if (daysBetween <= 0) {
      // Same day or time travel — should not happen
      return StreakActionResult.alreadyMarked(
        streak: _streak,
        message: 'Already active today.',
      );
    }

    // ── Gap of 2+ days ──
    final missedDays = daysBetween - 1; // Days missed (not counting today)

    // Try freeze tokens first
    if (_streak.freezeTokens >= missedDays) {
      final tokensUsed = missedDays;
      final newStreakValue = _streak.currentStreak + daysBetween;
      final newStreak = _streak.copyWith(
        currentStreak: newStreakValue,
        longestStreak:
            newStreakValue > _streak.longestStreak
                ? newStreakValue
                : _streak.longestStreak,
        totalActiveDays: _streak.totalActiveDays + 1,
        freezeTokens: _streak.freezeTokens - tokensUsed,
        lastActiveDate: today,
        weeklyCheckInsCompleted: _streak.weeklyCheckInsCompleted + 1,
        weeklyActivityPattern: _updateActivityPattern(
          _streak.weeklyActivityPattern,
          today,
        ),
      );
      _streak = newStreak;

      await addXP(
        amount: 20,
        pillar: AdmissionsPillar.consistency,
        source: 'daily_checkin',
      );

      _saveToPrefs();

      return StreakActionResult.freezeTokenUsed(
        newStreak: _streak,
        tokensUsed: tokensUsed,
        message:
            'Used $tokensUsed freeze token${tokensUsed > 1 ? 's' : ''} to protect your streak! 🔮',
      );
    }

    // Try grace days
    if (graceDayReason != null &&
        _streak.graceDaysRemaining > 0 &&
        _streak.graceDaysUsedThisWeek < _streakConfig.weeklyGraceDays) {
      final cost =
          _streakConfig.graceDayCosts[graceDayReason] ?? 1;
      if (_streak.graceDaysRemaining >= cost) {
        final graceUsage = GraceDayUsage(
          id: 'gd_${DateTime.now().millisecondsSinceEpoch}',
          dateUsed: today,
          reason: graceDayReason,
          note: null,
          wasAutoApplied: false,
        );
        final newStreakValue = _streak.currentStreak + daysBetween;
        final newStreak = _streak.copyWith(
          currentStreak: newStreakValue,
          longestStreak:
              newStreakValue > _streak.longestStreak
                  ? newStreakValue
                  : _streak.longestStreak,
          totalActiveDays: _streak.totalActiveDays + 1,
          graceDaysRemaining: _streak.graceDaysRemaining - cost,
          graceDaysUsedThisWeek: _streak.graceDaysUsedThisWeek + 1,
          graceDayHistory: [..._streak.graceDayHistory, graceUsage],
          lastActiveDate: today,
          weeklyCheckInsCompleted: _streak.weeklyCheckInsCompleted + 1,
          weeklyActivityPattern: _updateActivityPattern(
            _streak.weeklyActivityPattern,
            today,
          ),
        );
        _streak = newStreak;

        await addXP(
          amount: 20,
          pillar: AdmissionsPillar.consistency,
          source: 'daily_checkin',
        );

        _saveToPrefs();

        return StreakActionResult.graceDayUsed(
          newStreak: _streak,
          graceDayUsage: graceUsage,
          message: _graceDayMessage(graceDayReason),
        );
      }
    }

    // ── Streak broken ──
    final previousStreak = _streak.currentStreak;
    final newStreak = _streak.copyWith(
      currentStreak: 1,
      lastActiveDate: today,
      totalActiveDays: _streak.totalActiveDays + 1,
      weeklyCheckInsCompleted: _streak.weeklyCheckInsCompleted + 1,
      weeklyActivityPattern: _updateActivityPattern(
        _streak.weeklyActivityPattern,
        today,
      ),
    );
    _streak = newStreak;

    _saveToPrefs();

    return StreakActionResult.streakBroken(
      newStreak: _streak,
      previousStreak: previousStreak,
      message:
          'Streak of $previousStreak days ended. Starting fresh today!',
      encouragementMessage: _encouragementMessage(previousStreak),
    );
  }

  /// Add a freeze token (e.g. from league rewards, milestones).
  void addFreezeToken() {
    if (_streak.freezeTokens < _streak.maxFreezeTokens) {
      _streak = _streak.copyWith(
        freezeTokens: _streak.freezeTokens + 1,
        freezeTokensEarned: _streak.freezeTokensEarned + 1,
        lastFreezeTokenEarned: DateTime.now(),
      );
    }
  }

  /// Use a grace day manually (outside of mark flow).
  void useGraceDay(GraceDayReason reason) {
    if (_streak.graceDaysRemaining <= 0) return;
    final cost = _streakConfig.graceDayCosts[reason] ?? 1;
    if (_streak.graceDaysRemaining < cost) return;

    final usage = GraceDayUsage(
      id: 'gd_${DateTime.now().millisecondsSinceEpoch}',
      dateUsed: DateTime.now(),
      reason: reason,
      note: null,
      wasAutoApplied: false,
    );
    _streak = _streak.copyWith(
      graceDaysRemaining: _streak.graceDaysRemaining - cost,
      graceDaysUsedThisWeek: _streak.graceDaysUsedThisWeek + 1,
      graceDayHistory: [..._streak.graceDayHistory, usage],
    );
  }

  // ─── Mission System ───────────────────────────────────────────────────

  /// Update progress on a mission. When the mission's progress reaches its
  /// target, the mission is marked as completed.
  Future<void> updateMissionProgress(String missionId, int increment) async {
    final idx = _missions.indexWhere((m) => m.id == missionId);
    if (idx == -1) return;

    final mission = _missions[idx];
    if (mission.isCompleted) return;

    // Check expiry
    if (mission.expiresAt != null && DateTime.now().isAfter(mission.expiresAt!)) {
      return;
    }

    final newProgress = mission.progressCurrent + increment;
    final clampedProgress =
        newProgress > mission.progressTarget ? mission.progressTarget : newProgress;

    final updated = mission.copyWith(
      progressCurrent: clampedProgress,
      isCompleted: clampedProgress >= mission.progressTarget,
      completedAt: clampedProgress >= mission.progressTarget
          ? DateTime.now()
          : null,
    );
    _missions[idx] = updated;

    if (updated.isCompleted) {
      _missionCompleteController.add(updated);
    }

    _saveToPrefs();
  }

  /// Claim the XP reward for a completed mission.
  Future<void> claimMissionReward(String missionId) async {
    final idx = _missions.indexWhere((m) => m.id == missionId);
    if (idx == -1) return;

    final mission = _missions[idx];
    if (!mission.isCompleted || mission.isClaimed) return;

    _missions[idx] = mission.copyWith(
      isClaimed: true,
      claimedAt: DateTime.now(),
    );

    await addXP(
      amount: mission.xpReward,
      pillar: mission.pillar,
      source: '${mission.type.name}_mission',
      missionId: mission.id,
    );

    _saveToPrefs();
  }

  /// Claim the weekly mission set bonus (if all weekly missions completed).
  Future<void> claimWeeklyBonus() async {
    if (_weeklyMissionSet == null) return;
    if (_weeklyMissionSet!.isBonusClaimed) return;

    final allCompleted = _weeklyMissionSet!.missions.every(
      (m) => m.isCompleted,
    );
    if (!allCompleted) return;

    _weeklyMissionSet = _weeklyMissionSet!.copyWith(
      isBonusClaimed: true,
      bonusClaimedAt: DateTime.now(),
    );

    await addXP(
      amount: _weeklyMissionSet!.totalXPReward,
      pillar: AdmissionsPillar.consistency,
      source: 'weekly_bonus',
    );

    _saveToPrefs();
  }

  /// Check if the current weekly mission set is complete.
  bool get isWeeklySetComplete {
    if (_weeklyMissionSet == null) return false;
    return _weeklyMissionSet!.missions.every((m) => m.isCompleted);
  }

  // ─── Skin / Equipment Management ──────────────────────────────────────

  /// Equip a skin by tier. Only unlocked skins can be equipped.
  Future<void> equipSkin(SkinTier tier) async {
    if (_ownedSkins.containsKey(tier)) {
      _equippedSkin = tier;
      _saveToPrefs();
    }
  }

  /// Equip a decorative frame by ID.
  Future<void> equipFrame(String frameId) async {
    _equippedFrameId = frameId;
  }

  /// Add a badge to the equipped badge list (max 5).
  Future<void> addEquippedBadge(String badgeId) async {
    if (_equippedBadges.length >= 5) return;
    if (!_equippedBadges.contains(badgeId)) {
      _equippedBadges.add(badgeId);
    }
  }

  /// Remove a badge from the equipped list.
  Future<void> removeEquippedBadge(String badgeId) async {
    _equippedBadges.remove(badgeId);
  }

  // ─── Admissions Pillar Scoring ────────────────────────────────────────

  /// Map an activity category string to an admissions pillar.
  AdmissionsPillar mapCategoryToPillar(String category) {
    switch (category.toLowerCase()) {
      case 'academics':
      case 'study':
      case 'grades':
      case 'test_prep':
        return AdmissionsPillar.academics;
      case 'evidence':
      case 'activities':
      case 'documentation':
        return AdmissionsPillar.evidence;
      case 'consistency':
      case 'streak':
      case 'checkin':
      case 'daily':
        return AdmissionsPillar.consistency;
      case 'research':
      case 'academic_research':
        return AdmissionsPillar.research;
      case 'leadership':
      case 'mentor':
      case 'team':
        return AdmissionsPillar.leadership;
      case 'creativity':
      case 'art':
      case 'writing':
      case 'portfolio':
        return AdmissionsPillar.creativity;
      case 'community':
      case 'impact':
      case 'volunteer':
      case 'service':
        return AdmissionsPillar.communityImpact;
      default:
        return AdmissionsPillar.consistency;
    }
  }

  /// Get the player's pillar XP breakdown.
  Map<AdmissionsPillar, int> get pillarXPMap =>
      Map.unmodifiable(_xpState.pillarXP);

  /// Calculate an overall admissions readiness score (0.0 – 1.0).
  ///
  /// This is a heuristic that weighs how well the student's XP is
  /// distributed across all 7 pillars. Balanced profiles score higher.
  double calculateAdmissionsReadiness() {
    final xp = _xpState.pillarXP;
    final total = _xpState.totalXP;
    if (total == 0) return 0.0;

    // Weight each pillar based on importance (from the SkinCatalog tiers)
    const weights = {
      AdmissionsPillar.academics: 0.20,
      AdmissionsPillar.evidence: 0.15,
      AdmissionsPillar.consistency: 0.15,
      AdmissionsPillar.research: 0.15,
      AdmissionsPillar.leadership: 0.15,
      AdmissionsPillar.creativity: 0.10,
      AdmissionsPillar.communityImpact: 0.10,
    };

    double score = 0.0;
    for (final entry in weights.entries) {
      final pillarXP = xp[entry.key] ?? 0;
      // Normalise against a target of 3000 per pillar (expert level)
      final normalised = (pillarXP / 3000.0).clamp(0.0, 1.0);
      score += normalised * entry.value;
    }

    // Bonus for balance (low variance across pillars)
    final values = xp.values.toList();
    if (values.isNotEmpty) {
      final mean = values.fold<int>(0, (a, b) => a + b) / values.length;
      final variance =
          values.fold<double>(0, (a, b) => a + (b - mean) * (b - mean)) /
              values.length;
      final stddev = variance > 0 ? _sqrt(variance) : 0;
      final cv = mean > 0 ? stddev / mean : 1.0; // coefficient of variation
      final balanceBonus = (1.0 - cv).clamp(0.0, 0.2); // up to 20 %
      score += balanceBonus;
    }

    return score.clamp(0.0, 1.0);
  }

  // ─── Weekly Mission Generation ────────────────────────────────────────

  /// Generate a fresh set of missions for the current week.
  void generateWeeklyMissions() {
    _weeklyMissionSet = null; // reset
    final config = MissionGenerationConfig.defaultConfig();
    final now = DateTime.now();
    final weekStart = _startOfWeek(now);
    final weekEnd = weekStart.add(const Duration(days: 7));

    final List<Mission> weekMissions = [];
    int totalXP = 0;

    // Generate daily missions (pick 3 from templates)
    final dailyTemplates = MissionTemplates.getTemplatesForType(MissionType.daily);
    final pickedDaily = _pickRandom(dailyTemplates, config.dailyMissionsCount);
    for (final t in pickedDaily) {
      final m = _missionFromTemplate(t, now);
      weekMissions.add(m);
      totalXP += t.xpReward;
    }

    // Generate weekly missions (pick 5)
    final weeklyTemplates = MissionTemplates.getTemplatesForType(MissionType.weekly);
    final pickedWeekly = _pickRandom(weeklyTemplates, config.weeklyMissionsCount);
    for (final t in pickedWeekly) {
      final m = _missionFromTemplate(t, now);
      weekMissions.add(m);
      totalXP += t.xpReward;
    }

    // Generate 1 milestone mission
    final milestoneTemplates = MissionTemplates.getTemplatesForType(MissionType.milestone);
    if (milestoneTemplates.isNotEmpty) {
      final picked = _pickRandom(milestoneTemplates, 1);
      final m = _missionFromTemplate(picked.first, now);
      weekMissions.add(m);
      totalXP += picked.first.xpReward;
    }

    _missions
      ..removeWhere((m) => m.type == MissionType.milestone && !m.isCompleted)
      ..addAll(weekMissions);

    _weeklyMissionSet = WeeklyMissionSet(
      id: 'wm_${weekStart.millisecondsSinceEpoch}',
      weekStart: weekStart,
      weekEnd: weekEnd,
      missions: weekMissions,
      totalXPReward: (totalXP * 0.5).round(), // bonus XP for completing all
      isBonusClaimed: false,
      bonusClaimedAt: null,
      categoryCompletion: {},
    );

    _saveToPrefs();
  }

  // ─── Dispose ──────────────────────────────────────────────────────────

  void dispose() {
    _skinUnlockController.close();
    _levelUpController.close();
    _missionCompleteController.close();
  }

  // ════════════════════════════════════════════════════════════════════════
  // PRIVATE HELPERS
  // ════════════════════════════════════════════════════════════════════════

  // ── Skin unlocking ────────────────────────────────────────────────────

  /// Check if any new skins should be unlocked; returns the first new tier
  /// or null.
  SkinTier? _checkAndUnlockSkins() {
    SkinTier? firstNew;
    final ordered = SkinCatalog.getOrderedTiers();

    for (final tier in ordered) {
      if (_ownedSkins.containsKey(tier)) continue;

      final config = SkinCatalog.getConfig(tier);
      if (_meetsSkinRequirements(config)) {
        final skin = config.toSkin(unlocked: true);
        _ownedSkins[tier] = skin;
        _skinUnlockController.add(skin);
        firstNew ??= tier;
      }
    }
    return firstNew;
  }

  /// Check if player meets all requirements for a skin.
  bool _meetsSkinRequirements(SkinConfig config) {
    // 1. Total XP requirement
    if (_xpState.totalXP < config.xpRequired) return false;

    // 2. Pillar XP requirements
    final req = config.pillarXPRequirements;
    if ((_xpState.pillarXP[AdmissionsPillar.academics] ?? 0) < req.academicsXP) return false;
    if ((_xpState.pillarXP[AdmissionsPillar.evidence] ?? 0) < req.evidenceXP) return false;
    if ((_xpState.pillarXP[AdmissionsPillar.consistency] ?? 0) < req.consistencyXP) return false;
    if ((_xpState.pillarXP[AdmissionsPillar.research] ?? 0) < req.researchXP) return false;
    if ((_xpState.pillarXP[AdmissionsPillar.leadership] ?? 0) < req.leadershipXP) return false;
    if ((_xpState.pillarXP[AdmissionsPillar.creativity] ?? 0) < req.creativityXP) return false;
    if ((_xpState.pillarXP[AdmissionsPillar.communityImpact] ?? 0) < req.communityImpactXP) return false;

    // 3. Legendary trailblazer requires all previous skins
    if (config.tier == SkinTier.trailblazer) {
      for (final other in SkinTier.values) {
        if (other == SkinTier.trailblazer) continue;
        if (!_ownedSkins.containsKey(other)) return false;
      }
    }

    return true;
  }

  /// Find the next skin the player can unlock (by tierOrder).
  SkinTier? _nextSkinToUnlock() {
    final ordered = SkinCatalog.getOrderedTiers();
    for (final tier in ordered) {
      if (!_ownedSkins.containsKey(tier)) return tier;
    }
    return null;
  }

  // ── Streak helpers ────────────────────────────────────────────────────

  List<StreakMilestone> _checkStreakMilestones(Streak streak) {
    final newlyAchieved = <StreakMilestone>[];
    for (final config in _streakConfig.milestones) {
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

  Streak _applyMilestoneRewards(Streak streak, List<StreakMilestone> milestones) {
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

  String _streakMessage(int days) {
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

  String _encouragementMessage(int previousStreak) {
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

  String _graceDayMessage(GraceDayReason reason) {
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

  // ── Date helpers ──────────────────────────────────────────────────────

  static DateTime _today() {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day);
  }

  bool _isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  bool _isWeekend() {
    final day = DateTime.now().weekday;
    return day == DateTime.saturday || day == DateTime.sunday;
  }

  static DateTime _startOfWeek(DateTime date) {
    // Monday = 1
    final weekday = date.weekday;
    return DateTime(date.year, date.month, date.day)
        .subtract(Duration(days: weekday - 1));
  }

  List<int> _updateActivityPattern(List<int> pattern, DateTime day) {
    final updated = List<int>.from(pattern);
    final index = day.weekday - 1; // 0 = Mon … 6 = Sun
    if (index >= 0 && index < 7) {
      updated[index] += 1;
    }
    return updated;
  }

  /// Reset daily / weekly counters when the day or week rolls over.
  void _resetCountersIfNeeded() {
    final now = _today();
    if (!_isSameDay(_lastDayReset, now)) {
      _dailyActivityCounts.clear();
      _lastDayReset = now;

      // Check for weekly reset
      final weekStart = _startOfWeek(now);
      if (weekStart.isAfter(_lastWeekReset)) {
        _weeklyActivityCounts.clear();
        _lastWeekReset = weekStart;
        _streak = _streak.copyWith(
          weeklyCheckInsCompleted: 0,
          graceDaysUsedThisWeek: 0,
        );
      }

      _saveToPrefs();
    }
  }

  // ── Mission helpers ───────────────────────────────────────────────────

  Mission _missionFromTemplate(MissionTemplate t, DateTime now) {
    DateTime? expires;
    switch (t.type) {
      case MissionType.daily:
        expires = now.add(const Duration(days: 1));
        break;
      case MissionType.weekly:
      case MissionType.special:
        expires = now.add(const Duration(days: 7));
        break;
      default:
        break;
    }

    return Mission(
      id: '${t.id}_${now.millisecondsSinceEpoch}',
      title: t.title,
      description: t.description,
      type: t.type,
      category: t.category,
      difficulty: t.difficulty,
      xpReward: _xpForDifficulty(t.difficulty),
      pillar: t.pillar,
      completionCriteria: t.completionCriteria,
      prerequisites: t.prerequisites,
      isCompleted: false,
      isClaimed: false,
      completedAt: null,
      claimedAt: null,
      createdAt: now,
      expiresAt: expires,
      metadata: null,
      progressCurrent: 0,
      progressTarget: t.progressTarget,
      progressUnit: t.progressUnit,
      isRepeatable: t.isRepeatable,
      repeatCooldownDays: t.repeatCooldownDays,
      tags: t.tags,
    );
  }

  /// Base XP for a mission based on difficulty.
  int _xpForDifficulty(MissionDifficulty difficulty) {
    switch (difficulty) {
      case MissionDifficulty.easy:
        return 75;
      case MissionDifficulty.medium:
        return 175;
      case MissionDifficulty.hard:
        return 375;
      case MissionDifficulty.expert:
        return 750;
    }
  }

  /// Randomly pick [count] items from [list] (without replacement).
  List<T> _pickRandom<T>(List<T> list, int count) {
    if (list.length <= count) return List.from(list);
    final shuffled = List<T>.from(list)..shuffle();
    return shuffled.sublist(0, count);
  }

  // ── Transaction type mapping ──────────────────────────────────────────

  XPTransactionType _sourceTypeToTransactionType(String source) {
    if (source.contains('mission')) return XPTransactionType.mission;
    if (source.contains('streak')) return XPTransactionType.streak;
    if (source.contains('verify')) return XPTransactionType.verification;
    if (source.contains('bonus')) return XPTransactionType.bonus;
    if (source.contains('milestone')) return XPTransactionType.milestone;
    return XPTransactionType.activity;
  }

  // ── Simple integer sqrt (avoid dart:math dependency) ──────────────────
  static double _sqrt(double x) {
    if (x <= 0) return 0;
    double guess = x / 2;
    for (int i = 0; i < 20; i++) {
      guess = (guess + x / guess) / 2;
    }
    return guess;
  }

  // ─── SharedPreferences persistence ─────────────────────────────────────

  /// Fire-and-forget load from SharedPreferences.
  /// Called once at construction. Defaults are fine for first-time users.
  Future<void> _loadFromPrefs() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = prefs.getString(_prefsKey);
      if (jsonString == null) return;

      final state = jsonDecode(jsonString) as Map<String, dynamic>;

      try {
        final xpJson = state['xpState'];
        if (xpJson is Map<String, dynamic>) {
          _xpState = XPState.fromJson(xpJson);
        }
      } catch (_) {
        // Keep default XPState
      }

      try {
        final streakJson = state['streak'];
        if (streakJson is Map<String, dynamic>) {
          _streak = Streak.fromJson(streakJson);
        }
      } catch (_) {
        // Keep default Streak
      }

      try {
        final missionsJson = state['missions'];
        if (missionsJson is List) {
          _missions
            ..clear()
            ..addAll(
              missionsJson
                  .whereType<Map<String, dynamic>>()
                  .map((m) => Mission.fromJson(m)),
            );
        }
      } catch (_) {
        // Keep default (empty) missions
      }

      try {
        final wmsJson = state['weeklyMissionSet'];
        if (wmsJson is Map<String, dynamic>) {
          _weeklyMissionSet = WeeklyMissionSet.fromJson(wmsJson);
        } else {
          _weeklyMissionSet = null;
        }
      } catch (_) {
        _weeklyMissionSet = null;
      }

      try {
        final skinsJson = state['ownedSkins'];
        if (skinsJson is Map<String, dynamic>) {
          _ownedSkins.clear();
          for (final entry in skinsJson.entries) {
            try {
              final tier = SkinTier.values.firstWhere(
                (t) => t.name == entry.key,
                orElse: () => SkinTier.explorer,
              );
              if (entry.value is Map<String, dynamic>) {
                _ownedSkins[tier] = Skin.fromJson(entry.value);
              }
            } catch (_) {
              // Skip corrupt skin entry
            }
          }
          // Ensure explorer is always present
          if (!_ownedSkins.containsKey(SkinTier.explorer)) {
            _ownedSkins[SkinTier.explorer] = SkinCatalog.getConfig(
              SkinTier.explorer,
            ).toSkin(unlocked: true);
          }
        }
      } catch (_) {
        // Keep default owned skins (explorer)
      }

      try {
        final skinName = state['equippedSkin'] as String?;
        if (skinName != null) {
          _equippedSkin = SkinTier.values.firstWhere(
            (t) => t.name == skinName,
            orElse: () => SkinTier.explorer,
          );
        }
      } catch (_) {
        // Keep default equipped skin
      }

      try {
        final frameId = state['equippedFrameId'] as String?;
        if (frameId != null) {
          _equippedFrameId = frameId;
        }
      } catch (_) {
        // Keep default frame
      }

      try {
        final badges = state['equippedBadges'];
        if (badges is List) {
          _equippedBadges
            ..clear()
            ..addAll(badges.whereType<String>());
        }
      } catch (_) {
        // Keep default badges
      }

      try {
        final daily = state['dailyActivityCounts'];
        if (daily is Map<String, dynamic>) {
          _dailyActivityCounts
            ..clear()
            ..addAll(daily.map((k, v) => MapEntry(k, v as int)));
        }
      } catch (_) {
        // Keep default
      }

      try {
        final weekly = state['weeklyActivityCounts'];
        if (weekly is Map<String, dynamic>) {
          _weeklyActivityCounts
            ..clear()
            ..addAll(weekly.map((k, v) => MapEntry(k, v as int)));
        }
      } catch (_) {
        // Keep default
      }

      try {
        final dayReset = state['lastDayReset'] as String?;
        if (dayReset != null) {
          _lastDayReset = DateTime.parse(dayReset);
        }
      } catch (_) {
        // Keep default
      }

      try {
        final weekReset = state['lastWeekReset'] as String?;
        if (weekReset != null) {
          _lastWeekReset = DateTime.parse(weekReset);
        }
      } catch (_) {
        // Keep default
      }
    } catch (_) {
      // Entire load failed — defaults are fine for first-time users
    }
  }

  /// Fire-and-forget save to SharedPreferences.
  /// Serializes all state to a single JSON string.
  void _saveToPrefs() {
    try {
      final state = <String, dynamic>{
        'xpState': _xpState.toJson(),
        'streak': _streak.toJson(),
        'missions': _missions.map((m) => m.toJson()).toList(),
        'weeklyMissionSet': _weeklyMissionSet?.toJson(),
        'ownedSkins': _ownedSkins.map(
          (tier, skin) => MapEntry(tier.name, skin.toJson()),
        ),
        'equippedSkin': _equippedSkin.name,
        'equippedFrameId': _equippedFrameId,
        'equippedBadges': _equippedBadges,
        'dailyActivityCounts': _dailyActivityCounts,
        'weeklyActivityCounts': _weeklyActivityCounts,
        'lastDayReset': _lastDayReset.toIso8601String(),
        'lastWeekReset': _lastWeekReset.toIso8601String(),
      };
      SharedPreferences.getInstance().then((prefs) {
        prefs.setString(_prefsKey, jsonEncode(state));
      });
    } catch (_) {
      // Silently fail — don't crash the app for persistence issues
    }
  }
}
