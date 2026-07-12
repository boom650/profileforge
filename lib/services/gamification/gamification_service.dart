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

  // ─── Getters (aligned with gamification_providers.dart contracts) ──────
  XPState get xpState => _xpState;
  int get totalXP => _xpState.totalXP;
  int get currentLevel => _xpState.currentLevel;
  int get xpToNextLevel => XPUtils.xpToNextLevel(_xpState.totalXP);
  SkinTier get currentSkinTier => _equippedSkin;
  String get equippedSkinId => _equippedSkin.name;
  String get equippedFrameId => _equippedFrameId;
  List<String> get equippedBadgesList => List.unmodifiable(_equippedBadges);

  Map<String, int> get pillarXP =>
      _xpState.pillarXP.map((k, v) => MapEntry(k.name, v));

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
  WeeklyMissionSet? get weeklyMissionsSet => _weeklyMissionSet;

  /// Get the player's pillar XP breakdown.
  Map<AdmissionsPillar, int> get pillarXPMap =>
      Map.unmodifiable(_xpState.pillarXP);

  bool get isWeeklySetComplete =>
      _weeklyMissionSet?.missions.every((m) => m.isCompleted) ?? false;

  int get xpToNextSkin {
    final currentTierIndex = SkinTier.values.indexOf(_equippedSkin);
    if (currentTierIndex >= SkinTier.values.length - 1) return 0;
    final nextTier = SkinTier.values[currentTierIndex + 1];
    final config = SkinCatalog.getConfig(nextTier);
    final current = _xpState.totalXP;
    if (current >= config.xpRequired) return 0;
    return config.xpRequired - current;
  }

  // ─── XP Operations ────────────────────────────────────────────────────

  Future<XPAddResult> addXP({
    required int amount,
    required AdmissionsPillar pillar,
    String? source,
    String? missionId,
  }) async {
    _resetCountersIfNeeded();

    // Mutate XP state
    _xpState = _xpState.copyWith(
      pillarXP: Map<AdmissionsPillar, int>.from(_xpState.pillarXP)
        ..update(pillar, (v) => v + amount, ifAbsent: () => amount),
      totalXP: _xpState.totalXP + amount,
      currentLevel: XPUtils.levelForXp(_xpState.totalXP + amount),
    );

    // Track daily/weekly activity
    _dailyActivityCounts.update(source ?? 'misc', (v) => v + 1, ifAbsent: () => 1);
    _weeklyActivityCounts.update(source ?? 'misc', (v) => v + 1, ifAbsent: () => 1);

    // Level up check
    final leveledUp = _xpState.currentLevel > _levelBeforeAdd;
    if (leveledUp) {
      _levelUpController.add(_xpState.currentLevel);
    }

    // Skin unlock check
    final newSkin = _checkAndUnlockSkins();

    _saveToPrefs();
    return XPAddResult(
      totalXP: _xpState.totalXP,
      pillarXP: _xpState.pillarXP[pillar] ?? 0,
      leveledUp: leveledUp,
      newLevel: _xpState.currentLevel,
      newSkinUnlocked: newSkin,
      xpToNextLevel: xpToNextLevel,
      xpToNextSkin: xpToNextSkin,
    );
  }

  // ─── Streak Operations ────────────────────────────────────────────────

  // Store level before XP add to detect level-up
  int _levelBeforeAdd = 1;

  Future<StreakActionResult> markDailyActive(
      {GraceDayReason? graceDayReason}) async {
    final today = _today();
    final yesterday = today.subtract(const Duration(days: 1));
    bool savedByGrace = false;

    // Already marked today?
    if (_isSameDay(_streak.lastActiveDate, today)) {
      return StreakActionResult.alreadyMarked(
          streak: _streak, lastMarked: _streak.lastActiveDate);
    }

    // Check if streak would be broken (missed a day)
    if (_streak.currentStreak > 0 &&
        !_isSameDay(_streak.lastActiveDate, today) &&
        !_isSameDay(_streak.lastActiveDate, yesterday)) {
      // Try grace day
      if (graceDayReason != null && _streak.freezeTokens > 0) {
        _streak = _streak.copyWith(
          freezeTokens: _streak.freezeTokens - 1,
          graceDayHistory: [
            ..._streak.graceDayHistory,
            GraceDayUsage(
              id: 'grace_${today.millisecondsSinceEpoch}',
              dateUsed: today,
              reason: graceDayReason,
              note: null,
              wasAutoApplied: false,
            ),
          ],
        );
        savedByGrace = true;
      } else {
        // Streak broken
        _streak = _streak.copyWith(
          currentStreak: 0,
          longestStreak: _streak.longestStreak,
          freezeTokens: _streak.freezeTokens,
          lastActiveDate: today,
          graceDayHistory: _streak.graceDayHistory,
        );
      }
    }

    // Update streak
    _streak = _streak.copyWith(
      currentStreak: _streak.currentStreak + 1,
      longestStreak: _streak.currentStreak + 1 > _streak.longestStreak
          ? _streak.currentStreak + 1
          : _streak.longestStreak,
      lastActiveDate: today,
    );

    // Award XP for daily activity
    final baseXP = 10;
    final streakBonus = (_streak.currentStreak ~/ 7) * 5; // +5 per week
    final earnedXP = baseXP + streakBonus;

    _levelBeforeAdd = _xpState.currentLevel;
    await addXP(
      amount: earnedXP,
      pillar: AdmissionsPillar.consistency,
      source: 'daily_streak',
    );

    // Check streak milestones
    _checkStreakMilestones();
    _saveToPrefs();

    return StreakActionResult.success(
      streak: _streak,
      savedByGrace: savedByGrace,
      xpEarned: earnedXP,
    );
  }

  void _checkStreakMilestones() {
    // ...
  }

  void _claimStreakMilestone(String milestoneId) {
    // ...
    // then award XP
    _levelBeforeAdd = _xpState.currentLevel;
    addXP(
      amount: 100, // milestone.xpReward,
      pillar: AdmissionsPillar.consistency,
      source: 'milestone:$milestoneId',
    );
    _streak = _streak.copyWith(
      freezeTokens: _streak.freezeTokens + 1,
    );
    _saveToPrefs();
  }

  // ─── Skin Operations ──────────────────────────────────────────────────

  SkinTier? _checkAndUnlockSkins() {
    for (final tier in SkinTier.values) {
      if (_ownedSkins.containsKey(tier)) continue;
      final config = SkinCatalog.getConfig(tier);
      if (_xpState.totalXP >= config.xpRequired) {
        _ownedSkins[tier] = config.toSkin(unlocked: true);
        return tier;
      }
    }
    return null;
  }

  bool unlockSkin(SkinTier tier) {
    if (_ownedSkins.containsKey(tier)) return false;
    final config = SkinCatalog.getConfig(tier);
    if (_xpState.totalXP < config.xpRequired) return false;
    _ownedSkins[tier] = config.toSkin(unlocked: true);
    _skinUnlockController.add(_ownedSkins[tier]!);
    _saveToPrefs();
    return true;
  }

  bool equipSkin(SkinTier tier) {
    if (!_ownedSkins.containsKey(tier)) return false;
    _equippedSkin = tier;
    _saveToPrefs();
    return true;
  }

  bool equipFrame(String frameId) {
    _equippedFrameId = frameId;
    _saveToPrefs();
    return true;
  }

  // ─── Mission Operations ───────────────────────────────────────────────

  void generateDailyMissions() {
    _missions.removeWhere((m) => m.type == MissionType.daily);
    final newDaily = _generateMissionsForType(MissionType.daily, count: 3);
    _missions.addAll(newDaily);
    _saveToPrefs();
  }

  void generateWeeklyMissions() {
    _missions.removeWhere((m) => m.type == MissionType.weekly);
    final newWeekly = _generateMissionsForType(MissionType.weekly, count: 5);
    _missions.addAll(newWeekly);
    _saveToPrefs();
  }

  List<Mission> _generateMissionsForType(MissionType type, {int count = 3}) {
    final now = DateTime.now();
    final missions = <Mission>[];
    for (int i = 0; i < count; i++) {
      missions.add(Mission(
        id: '${type.name}_${missions.length + i}_${now.millisecondsSinceEpoch}',
        title: '${type == MissionType.daily ? "Daily" : "Weekly"} Mission ${i + 1}',
        description: 'Complete activities to earn XP',
        type: type,
        category: MissionCategory.exploration,
        difficulty: MissionDifficulty.easy,
        xpReward: type == MissionType.daily ? 25 : 100,
        pillar: AdmissionsPillar.consistency,
        completionCriteria: {},
        prerequisites: [],
        isCompleted: false,
        isClaimed: false,
        completedAt: null,
        claimedAt: null,
        createdAt: now,
        expiresAt: null,
        metadata: null,
        progressCurrent: 0,
        progressTarget: 1,
        progressUnit: 'count',
        isRepeatable: true,
        repeatCooldownDays: 1,
        tags: [],
      ));
    }
    return missions;
  }

  Future<bool> completeMission(String missionId) async {
    final idx = _missions.indexWhere((m) => m.id == missionId);
    if (idx == -1 || _missions[idx].isCompleted) return false;

    final mission = _missions[idx];
    _missions[idx] = mission.copyWith(
      isCompleted: true,
      completedAt: DateTime.now(),
    );

    _levelBeforeAdd = _xpState.currentLevel;
    await addXP(
      amount: mission.xpReward,
      pillar: AdmissionsPillar.consistency,
      source: 'mission:${mission.type.name}',
      missionId: missionId,
    );
    _missionCompleteController.add(_missions[idx]);
    _saveToPrefs();
    return true;
  }

  void _trackMissionProgress(String missionId, int amount) {
    final idx = _missions.indexWhere((m) => m.id == missionId);
    if (idx == -1) return;
    final mission = _missions[idx];
    _missions[idx] = mission.copyWith(
      progressCurrent: (mission.progressCurrent + amount).clamp(0, mission.progressTarget),
    );
  }

  /// Claim the XP reward for a completed mission.
  ///
  /// Finds the mission by [missionId], marks it as claimed, awards its
  /// [xpReward] as XP, and persists the change.
  Future<void> claimMissionReward(String missionId) async {
    final idx = _missions.indexWhere((m) => m.id == missionId);
    if (idx == -1) return;

    final mission = _missions[idx];
    if (!mission.isCompleted || mission.isClaimed) return;

    _missions[idx] = mission.copyWith(
      isClaimed: true,
      claimedAt: DateTime.now(),
    );

    _levelBeforeAdd = _xpState.currentLevel;
    await addXP(
      amount: mission.xpReward,
      pillar: mission.pillar,
      source: 'mission_reward:${mission.type.name}',
      missionId: missionId,
    );
    _saveToPrefs();
  }

  /// Update progress on a mission, delegating to [_trackMissionProgress].
  Future<void> updateMissionProgress(String missionId, int increment) async {
    _trackMissionProgress(missionId, increment);
    _saveToPrefs();
  }

  /// Claim the weekly mission set bonus if every mission in the set is complete.
  ///
  /// Awards the set's [WeeklyMissionSet.totalXPReward] as XP, marks the bonus
  /// as claimed, and persists the change.
  Future<void> claimWeeklyBonus() async {
    final set = _weeklyMissionSet;
    if (set == null || set.isBonusClaimed) return;
    if (!isWeeklySetComplete) return;

    _weeklyMissionSet = set.copyWith(
      isBonusClaimed: true,
      bonusClaimedAt: DateTime.now(),
    );

    _levelBeforeAdd = _xpState.currentLevel;
    await addXP(
      amount: set.totalXPReward,
      pillar: AdmissionsPillar.consistency,
      source: 'weekly_bonus',
    );
    _saveToPrefs();
  }

  /// Claim the XP reward for a completed mission.
  ///
  /// Finds the mission by [missionId], marks it as claimed, awards its
  /// [xpReward] as XP, and persists the change.
  Future<void> claimMissionReward(String missionId) async {
    final idx = _missions.indexWhere((m) => m.id == missionId);
    if (idx == -1) return;

    final mission = _missions[idx];
    if (!mission.isCompleted || mission.isClaimed) return;

    _missions[idx] = mission.copyWith(
      isClaimed: true,
      claimedAt: DateTime.now(),
    );

    _levelBeforeAdd = _xpState.currentLevel;
    await addXP(
      amount: mission.xpReward,
      pillar: mission.pillar,
      source: 'mission_reward:${mission.type.name}',
      missionId: missionId,
    );
    _saveToPrefs();
  }

  /// Update progress on a mission, delegating to [_trackMissionProgress].
  Future<void> updateMissionProgress(String missionId, int increment) async {
    _trackMissionProgress(missionId, increment);
    _saveToPrefs();
  }

  /// Claim the weekly mission set bonus if every mission in the set is complete.
  ///
  /// Awards the set's [WeeklyMissionSet.totalXPReward] as XP, marks the bonus
  /// as claimed, and persists the change.
  Future<void> claimWeeklyBonus() async {
    final set = _weeklyMissionSet;
    if (set == null || set.isBonusClaimed) return;
    if (!isWeeklySetComplete) return;

    _weeklyMissionSet = set.copyWith(
      isBonusClaimed: true,
      bonusClaimedAt: DateTime.now(),
    );

    _levelBeforeAdd = _xpState.currentLevel;
    await addXP(
      amount: set.totalXPReward,
      pillar: AdmissionsPillar.consistency,
      source: 'weekly_bonus',
    );
    _saveToPrefs();
  }

  // ─── Persistence ──────────────────────────────────────────────────────

  Future<void> _saveToPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final data = {
      'xp': {
        'totalXP': _xpState.totalXP,
        'currentLevel': _xpState.currentLevel,
        'pillarXP': _xpState.pillarXP.map((k, v) => MapEntry(k.name, v)),
      },
      'streak': {
        'currentStreak': _streak.currentStreak,
        'longestStreak': _streak.longestStreak,
        'lastActiveDate': _streak.lastActiveDate?.toIso8601String(),
        'freezeTokens': _streak.freezeTokens,
        'graceDayHistory': _streak.graceDayHistory.map((g) => ({
          'date': g.dateUsed.toIso8601String(),
          'reason': g.reason.name,
        })).toList(),
      },
      'equippedSkin': _equippedSkin.name,
      'equippedFrameId': _equippedFrameId,
      'ownedSkins': _ownedSkins.keys.map((k) => k.name).toList(),
      'missions': _missions.map((m) => ({
        'id': m.id,
        'title': m.title,
        'x': 0, // Simplified - full serialization skipped for brevity
      })).toList(),
    };
    await prefs.setString(_prefsKey, jsonEncode(data));
  }

  Future<void> _loadFromPrefs() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getString(_prefsKey);
      if (raw == null) return;
      final data = jsonDecode(raw) as Map<String, dynamic>;
      _loadXpState(data['xp'] as Map<String, dynamic>?);
      _loadStreak(data['streak'] as Map<String, dynamic>?);
      _loadSkins(data);
    } catch (_) {}
  }

  void _loadXpState(Map<String, dynamic>? data) {
    if (data == null) return;
    _xpState = _xpState.copyWith(
      totalXP: data['totalXP'] as int? ?? 0,
      currentLevel: data['currentLevel'] as int? ?? 1,
      pillarXP: _loadPillarXP(data['pillarXP']),
    );
  }

  Map<AdmissionsPillar, int> _loadPillarXP(dynamic data) {
    if (data == null) return {};
    final map = <AdmissionsPillar, int>{};
    for (final entry in (data as Map).entries) {
      final pillar = AdmissionsPillar.values.where(
        (p) => p.name == entry.key,
      ).firstOrNull;
      if (pillar != null) map[pillar] = entry.value as int;
    }
    return map;
  }

  void _loadStreak(Map<String, dynamic>? data) {
    if (data == null) return;
    _streak = Streak.initial().copyWith(
      currentStreak: data['currentStreak'] as int? ?? 0,
      longestStreak: data['longestStreak'] as int? ?? 0,
      lastActiveDate: DateTime.tryParse(data['lastActiveDate'] as String? ?? '') ?? DateTime.now(),
      freezeTokens: data['freezeTokens'] as int? ?? 0,
      graceDayHistory: [],
    );
  }

  void _loadSkins(Map<String, dynamic> data) {
    final equipped = data['equippedSkin'] as String?;
    if (equipped != null) {
      _equippedSkin = SkinTier.values.where((t) => t.name == equipped).firstOrNull ?? SkinTier.explorer;
    }
    _equippedFrameId = data['equippedFrameId'] as String? ?? 'frame_default';
    final owned = data['ownedSkins'] as List<dynamic>? ?? [];
    for (final name in owned) {
      final tier = SkinTier.values.where((t) => t.name == name).firstOrNull;
      if (tier != null && !_ownedSkins.containsKey(tier)) {
        _ownedSkins[tier] = SkinCatalog.getConfig(tier).toSkin(unlocked: true);
      }
    }
  }

  // ─── Counter Reset ────────────────────────────────────────────────────

  void _resetCountersIfNeeded() {
    final today = _today();
    if (!_isSameDay(_lastDayReset, today)) {
      _dailyActivityCounts.clear();
      _lastDayReset = today;
    }
    final weekStart = _startOfWeek(DateTime.now());
    if (!_isSameDay(_lastWeekReset, weekStart)) {
      _weeklyActivityCounts.clear();
      _lastWeekReset = weekStart;
    }
  }

  // ─── Dispose ──────────────────────────────────────────────────────────

  void dispose() {
    _skinUnlockController.close();
    _levelUpController.close();
    _missionCompleteController.close();
  }

  // ── Helpers ────────────────────────────────────────────────────────────

  static DateTime _today() {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day);
  }

  bool _isSameDay(DateTime? a, DateTime? b) {
    if (a == null || b == null) return false;
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  static DateTime _startOfWeek(DateTime date) {
    final weekday = date.weekday;
    return DateTime(date.year, date.month, date.day)
        .subtract(Duration(days: weekday - 1));
  }

  // ─── Admissions Pillar Scoring ────────────────────────────────────────

  AdmissionsPillar mapCategoryToPillar(String category) {
    switch (category.toLowerCase()) {
      case 'academics': case 'study': case 'grades': case 'test_prep':
        return AdmissionsPillar.academics;
      case 'evidence': case 'activities': case 'documentation':
        return AdmissionsPillar.evidence;
      case 'consistency': case 'streak': case 'checkin': case 'daily':
        return AdmissionsPillar.consistency;
      case 'research': case 'academic_research':
        return AdmissionsPillar.research;
      case 'leadership': case 'mentor': case 'team':
        return AdmissionsPillar.leadership;
      case 'creativity': case 'art': case 'writing': case 'portfolio':
        return AdmissionsPillar.creativity;
      case 'community': case 'impact': case 'volunteer': case 'service':
        return AdmissionsPillar.communityImpact;
      default:
        return AdmissionsPillar.consistency;
    }
  }

  double calculateAdmissionsReadiness() {
    final xp = _xpState.pillarXP;
    final total = _xpState.totalXP;
    if (total == 0) return 0.0;

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
      final normalised = (pillarXP / 3000.0).clamp(0.0, 1.0);
      score += normalised * entry.value;
    }

    final values = xp.values.toList();
    if (values.isNotEmpty) {
      final mean = values.fold<int>(0, (a, b) => a + b) / values.length;
      final variance =
          values.fold<double>(0, (a, b) => a + (b - mean) * (b - mean)) /
              values.length;
      final stddev = variance > 0 ? _sqrt(variance) : 0;
      final cv = mean > 0 ? stddev / mean : 1.0;
      final balanceBonus = (1.0 - cv).clamp(0.0, 0.2);
      score += balanceBonus;
    }

    return score.clamp(0.0, 1.0);
  }

  static double _sqrt(double x) {
    if (x <= 0) return 0;
    double guess = x / 2;
    for (int i = 0; i < 20; i++) {
      guess = (guess + x / guess) / 2;
    }
    return guess;
  }

  bool isWeekend() {
    final day = DateTime.now().weekday;
    return day == DateTime.saturday || day == DateTime.sunday;
  }
}