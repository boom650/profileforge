import 'dart:async';

import '../../models/student_profile.dart';
import '../../models/gamification/skins.dart';
import '../../models/gamification/streak.dart';
import '../../models/gamification/xp.dart';
import '../../models/gamification/missions.dart';
import '../admissions_probability/admissions_engine.dart';

/// Gamification Service - Central coordinator for all gamification systems
/// Skin-based rewards, humane streaks, XP pillars, missions
class GamificationService {
  final AdmissionsProbabilityEngine _admissionsEngine;
  
  // State streams
  final StreamController<Skin> _skinUnlockController = StreamController.broadcast();
  final StreamController<int> _levelUpController = StreamController.broadcast();
  final StreamController<Mission> _missionCompleteController = StreamController.broadcast();
  
  // Internal state
  GamificationState _state = GamificationState.initial();
  final Map<String, int> _pillarXP = {};
  int _totalXP = 0;
  int _currentLevel = 1;
  SkinTier _currentSkinTier = SkinTier.explorer;
  String _equippedSkinId = 'explorer';
  String _equippedFrameId = 'frame_default';
  final List<String> _equippedBadges = [];
  
  // Streaks
  final Map<String, Streak> _streaks = {};
  String? _lastActiveDate;
  int _freezeTokens = 3;
  final List<DateTime> _graceDaysUsed = [];
  
  // Missions
  final List<Mission> _activeMissions = [];
  final List<Mission> _completedMissions = [];
  WeeklyMissionSet? _currentWeeklyMissions;
  DateTime? _lastMissionGeneration;
  
  GamificationService({AdmissionsProbabilityEngine? admissionsEngine})
      : _admissionsEngine = admissionsEngine ?? AdmissionsProbabilityEngine();
  
  // Stream getters
  Stream<Skin> get skinUnlockStream => _skinUnlockController.stream;
  Stream<int> get levelUpStream => _levelUpController.stream;
  Stream<Mission> get missionCompleteStream => _missionCompleteController.stream;
  
  // Getters
  GamificationState get state => _state;
  int get totalXP => _totalXP;
  int get currentLevel => _currentLevel;
  int get xpToNextLevel => _calculateXPToNextLevel(_currentLevel);
  SkinTier get currentSkinTier => _currentSkinTier;
  String get equippedSkinId => _equippedSkinId;
  String get equippedFrameId => _equippedFrameId;
  List<String> get equippedBadges => List.unmodifiable(_equippedBadges);
  Map<String, int> get pillarXP => Map.unmodifiable(_pillarXP);
  int get xpToNextSkin => _calculateXPToNextSkin();
  Skin? get currentSkin => SkinCatalog.getConfig(_currentSkinTier).toSkin(
    unlocked: true,
    equipped: true,
  );
  List<Skin> get unlockedSkins => _getUnlockedSkins();
  List<Skin> get lockedSkins => _getLockedSkins();
  Skin? get nextSkinToUnlock => _getNextSkinToUnlock();
  Streak get currentStreak => _streaks['activity'] ?? Streak.initial();
  int get freezeTokens => _freezeTokens;
  List<DateTime> get graceDaysUsed => List.unmodifiable(_graceDaysUsed);
  List<Mission> get activeMissions => List.unmodifiable(_activeMissions);
  List<Mission> get completedMissions => List.unmodifiable(_completedMissions);
  List<Mission> get dailyMissions => _activeMissions.where((m) => m.type == MissionType.daily).toList();
  List<Mission> get weeklyMissions => _activeMissions.where((m) => m.type == MissionType.weekly).toList();
  List<Mission> get milestoneMissions => _activeMissions.where((m) => m.type == MissionType.milestone).toList();
  WeeklyMissionSet? get weeklyMissionsSet => _currentWeeklyMissions;
  
  /// Initialize with saved state
  void initialize(GamificationState savedState) {
    _state = savedState;
    _totalXP = savedState.totalXP;
    _currentLevel = savedState.currentLevel;
    _pillarXP.addAll(savedState.pillarXP);
    _currentSkinTier = savedState.currentSkinTier;
    _equippedSkinId = savedState.equippedSkinId;
    _equippedFrameId = savedState.equippedFrameId;
    _equippedBadges.addAll(savedState.equippedBadges);
    _freezeTokens = savedState.freezeTokens;
    _graceDaysUsed.addAll(savedState.graceDaysUsed);
    _lastActiveDate = savedState.lastActiveDate;
    _completedMissions.addAll(savedState.completedMissionIds);
    _currentWeeklyMissions = savedState.weeklyMissions;
    _lastMissionGeneration = savedState.lastMissionGeneration;
    
    // Restore streaks
    for (final entry in savedState.streaks.entries) {
      _streaks[entry.key] = entry.value;
    }
    
    // Restore active missions
    for (final missionData in savedState.activeMissions) {
      _activeMissions.add(Mission.fromJson(missionData));
    }
    
    // Generate missions if needed
    _ensureMissionsGenerated();
  }
  
  /// Get current state for persistence
  GamificationState getState() {
    return GamificationState(
      totalXP: _totalXP,
      currentLevel: _currentLevel,
      pillarXP: Map.from(_pillarXP),
      currentSkinTier: _currentSkinTier,
      equippedSkinId: _equippedSkinId,
      equippedFrameId: _equippedFrameId,
      equippedBadges: List.from(_equippedBadges),
      freezeTokens: _freezeTokens,
      graceDaysUsed: List.from(_graceDaysUsed),
      lastActiveDate: _lastActiveDate,
      streaks: Map.from(_streaks),
      completedMissionIds: _completedMissions.map((m) => m.id).toList(),
      activeMissions: _activeMissions.map((m) => m.toJson()).toList(),
      weeklyMissions: _currentWeeklyMissions,
      lastMissionGeneration: _lastMissionGeneration,
    );
  }
  
  // MARK: - XP & Level System
  
  int _calculateXPToNextLevel(int level) {
    return 100 * level * level; // Quadratic progression
  }
  
  int _calculateXPToNextSkin() {
    final orderedTiers = SkinCatalog.getOrderedTiers();
    final currentIndex = orderedTiers.indexOf(_currentSkinTier);
    if (currentIndex >= orderedTiers.length - 1) return 0;
    
    final nextTier = orderedTiers[currentIndex + 1];
    final nextConfig = SkinCatalog.getConfig(nextTier);
    return max(0, nextConfig.xpRequired - _totalXP);
  }
  
  Future<XPAddResult> addXP({
    required int amount,
    required AdmissionsPillar pillar,
    String? source,
    String? missionId,
  }) async {
    // Add to pillar XP
    _pillarXP[pillar.name] = (_pillarXP[pillar.name] ?? 0) + amount;
    
    // Add to total XP
    _totalXP += amount;
    
    // Check level up
    final oldLevel = _currentLevel;
    while (_totalXP >= _calculateXPToNextLevel(_currentLevel)) {
      _currentLevel++;
    }
    
    final leveledUp = _currentLevel > oldLevel;
    if (leveledUp) {
      _levelUpController.add(_currentLevel);
      // Bonus freeze token every 5 levels
      if (_currentLevel % 5 == 0) {
        _freezeTokens++;
      }
    }
    
    // Check skin unlocks
    final newSkin = _checkSkinUnlocks();
    if (newSkin != null) {
      _skinUnlockController.add(newSkin);
    }
    
    // Update mission progress if missionId provided
    if (missionId != null) {
      await updateMissionProgress(missionId, amount);
    }
    
    return XPAddResult(
      totalXP: _totalXP,
      pillarXP: _pillarXP[pillar.name]!,
      leveledUp: leveledUp,
      newLevel: _currentLevel,
      newSkinUnlocked: newSkin != null ? newSkin.tier : null,
      xpToNextLevel: xpToNextLevel,
      xpToNextSkin: xpToNextSkin,
    );
  }
  
  Skin? _checkSkinUnlocks() {
    final orderedTiers = SkinCatalog.getOrderedTiers();
    
    for (final tier in orderedTiers) {
      if (tier == _currentSkinTier) continue;
      if (_isTierUnlocked(tier) && tier.index > _currentSkinTier.index) {
        _currentSkinTier = tier;
        return SkinCatalog.getConfig(tier).toSkin(unlocked: true);
      }
    }
    return null;
  }
  
  bool _isTierUnlocked(SkinTier tier) {
    final config = SkinCatalog.getConfig(tier);
    
    // Check total XP requirement
    if (_totalXP < config.xpRequired) return false;
    
    // Check pillar XP requirements
    final pillarReqs = config.pillarXPRequirements;
    if (_pillarXP[AdmissionsPillar.academics.name] ?? 0 < pillarReqs.academicsXP) return false;
    if (_pillarXP[AdmissionsPillar.evidence.name] ?? 0 < pillarReqs.evidenceXP) return false;
    if (_pillarXP[AdmissionsPillar.consistency.name] ?? 0 < pillarReqs.consistencyXP) return false;
    if (_pillarXP[AdmissionsPillar.research.name] ?? 0 < pillarReqs.researchXP) return false;
    if (_pillarXP[AdmissionsPillar.leadership.name] ?? 0 < pillarReqs.leadershipXP) return false;
    if (_pillarXP[AdmissionsPillar.creativity.name] ?? 0 < pillarReqs.creativityXP) return false;
    if (_pillarXP[AdmissionsPillar.communityImpact.name] ?? 0 < pillarReqs.communityImpactXP) return false;
    
    // Check specific unlock criteria
    for (final criterion in config.unlockCriteria) {
      if (!_checkUnlockCriterion(criterion)) return false;
    }
    
    return true;
  }
  
  bool _checkUnlockCriterion(String criterion) {
    // Parse and check specific criteria
    if (criterion.contains('Tier 1 activity')) {
      // Would check completed missions/activities
      return true; // Simplified
    }
    if (criterion.contains('streak')) {
      return currentStreak.current >= 30;
    }
    if (criterion.contains('research')) {
      return (_pillarXP[AdmissionsPillar.research.name] ?? 0) >= 3000;
    }
    if (criterion.contains('leadership')) {
      return (_pillarXP[AdmissionsPillar.leadership.name] ?? 0) >= 3000;
    }
    if (criterion.contains('creativity')) {
      return (_pillarXP[AdmissionsPillar.creativity.name] ?? 0) >= 3000;
    }
    if (criterion.contains('community') || criterion.contains('impact')) {
      return (_pillarXP[AdmissionsPillar.communityImpact.name] ?? 0) >= 3000;
    }
    if (criterion.contains('evidence')) {
      return (_pillarXP[AdmissionsPillar.evidence.name] ?? 0) >= 1000;
    }
    if (criterion.contains('academic')) {
      return (_pillarXP[AdmissionsPillar.academics.name] ?? 0) >= 500;
    }
    return true;
  }
  
  List<Skin> _getUnlockedSkins() {
    final orderedTiers = SkinCatalog.getOrderedTiers();
    return orderedTiers
        .where((tier) => tier.index <= _currentSkinTier.index)
        .map((tier) => SkinCatalog.getConfig(tier).toSkin(unlocked: true))
        .toList();
  }
  
  List<Skin> _getLockedSkins() {
    final orderedTiers = SkinCatalog.getOrderedTiers();
    return orderedTiers
        .where((tier) => tier.index > _currentSkinTier.index)
        .map((tier) => SkinCatalog.getConfig(tier).toSkin(unlocked: false))
        .toList();
  }
  
  Skin? _getNextSkinToUnlock() {
    final orderedTiers = SkinCatalog.getOrderedTiers();
    final currentIndex = orderedTiers.indexOf(_currentSkinTier);
    if (currentIndex >= orderedTiers.length - 1) return null;
    
    final nextTier = orderedTiers[currentIndex + 1];
    final config = SkinCatalog.getConfig(nextTier);
    final progress = min(_totalXP / config.xpRequired, 1.0);
    
    return config.toSkin(
      unlocked: false,
      unlockProgress: progress,
    );
  }
  
  // MARK: - Streak System
  
  Future<StreakActionResult> markDailyActive({
    GraceDayReason? graceDayReason,
  }) async {
    final today = DateTime.now();
    final todayString = _dateToString(today);
    
    // Already marked today
    if (_lastActiveDate == todayString) {
      return StreakActionResult(
        success: true,
        message: 'Already marked active today!',
        streak: currentStreak,
        xpGained: 0,
      );
    }
    
    final yesterday = today.subtract(const Duration(days: 1));
    final yesterdayString = _dateToString(yesterday);
    
    var streak = _streaks['activity'] ?? Streak.initial();
    var xpGained = 0;
    String message = '';
    
    if (_lastActiveDate == yesterdayString) {
      // Continued streak
      streak = streak.copyWith(
        current: streak.current + 1,
        longest: max(streak.longest, streak.current + 1),
        lastActiveDate: today,
      );
      xpGained = 10 + (streak.current * 2); // Bonus for longer streaks
      message = 'Streak continued! Day ${streak.current} 🔥';
    } else if (_lastActiveDate != null && _lastActiveDate != yesterdayString) {
      // Check for grace day or freeze token
      final daysMissed = today.difference(DateTime.parse(_lastActiveDate!)).inDays - 1;
      
      if (graceDayReason != null && !_graceDaysUsed.contains(today)) {
        // Use grace day
        _graceDaysUsed.add(today);
        streak = streak.copyWith(
          current: streak.current + 1,
          longest: max(streak.longest, streak.current + 1),
          lastActiveDate: today,
          graceDaysUsed: List.from(streak.graceDaysUsed)..add(today),
        );
        xpGained = 10;
        message = 'Grace day used! Streak saved 🛡️';
      } else if (_freezeTokens >= daysMissed) {
        // Use freeze tokens
        _freezeTokens -= daysMissed;
        streak = streak.copyWith(
          current: streak.current + daysMissed,
          longest: max(streak.current + daysMissed > streak.longest 
              ? streak.current + daysMissed 
              : streak.longest),
          lastActiveDate: today,
          freezeTokensUsed: streak.freezeTokensUsed + daysMissed,
        );
        xpGained = 10 * daysMissed;
        message = 'Freeze token used! Streak preserved ❄️';
      } else {
        // Streak broken
        streak = Streak(
          current: 1,
          longest: streak.longest,
          lastActiveDate: today,
          freezeTokens: streak.freezeTokens,
          graceDaysUsed: streak.graceDaysUsed,
        );
        xpGained = 10;
        message = 'Streak reset. Day 1 - fresh start! 🌱';
      }
    } else {
      // First time or very long gap
      streak = Streak(
        current: 1,
        longest: max(1, streak.longest),
        lastActiveDate: today,
        freezeTokens: streak.freezeTokens,
        graceDaysUsed: streak.graceDaysUsed,
      );
      xpGained = 10;
      message = 'Welcome back! Day 1 🌱';
    }
    
    _streaks['activity'] = streak;
    _lastActiveDate = todayString;
    
    // Add XP for daily activity
    final xpResult = await addXP(
      amount: xpGained,
      pillar: AdmissionsPillar.consistency,
      source: 'daily_streak',
    );
    
    // Check for milestone rewards
    _checkStreakMilestones(streak);
    
    return StreakActionResult(
      success: true,
      message: message,
      streak: streak,
      xpGained: xpResult.totalXP - (_totalXP - xpGained),
    );
  }
  
  void _checkStreakMilestones(Streak streak) {
    final milestones = [7, 14, 30, 60, 90, 180, 365];
    for (final milestone in milestones) {
      if (streak.current == milestone) {
        // Award milestone badge
        final badgeId = 'streak_$milestone';
        if (!_equippedBadges.contains(badgeId)) {
          _equippedBadges.add(badgeId);
          // Bonus XP for milestones
          addXP(
            amount: milestone * 5,
            pillar: AdmissionsPillar.consistency,
            source: 'streak_milestone',
          );
          // Grant freeze token at major milestones
          if ([30, 90, 180, 365].contains(milestone)) {
            _freezeTokens++;
          }
        }
      }
    }
  }
  
  void addFreezeToken() {
    _freezeTokens++;
  }
  
  void useGraceDay(GraceDayReason reason) {
    final today = DateTime.now();
    if (!_graceDaysUsed.contains(today)) {
      _graceDaysUsed.add(today);
    }
  }
  
  // MARK: - Mission System
  
  void _ensureMissionsGenerated() {
    final today = DateTime.now();
    
    // Generate new weekly missions every Sunday
    if (_lastMissionGeneration == null || 
        _isNewWeek(_lastMissionGeneration!, today)) {
      _generateWeeklyMissions();
      _lastMissionGeneration = today;
    }
    
    // Ensure daily missions exist
    _ensureDailyMissions();
  }
  
  bool _isNewWeek(DateTime lastGen, DateTime now) {
    final lastSunday = lastGen.subtract(Duration(days: lastGen.weekday % 7));
    final thisSunday = now.subtract(Duration(days: now.weekday % 7));
    return lastSunday != thisSunday;
  }
  
  void _generateWeeklyMissions() {
    final weeklyMissions = _createWeeklyMissions();
    _currentWeeklyMissions = WeeklyMissionSet(
      id: 'weekly_${DateTime.now().millisecondsSinceEpoch}',
      weekStart: DateTime.now().subtract(Duration(days: DateTime.now().weekday % 7)),
      weekEnd: DateTime.now().add(Duration(days: 7 - DateTime.now().weekday % 7)),
      missions: weeklyMissions,
      totalXPReward: weeklyMissions.fold(0, (sum, m) => sum + m.xpReward),
      isBonusClaimed: false,
      categoryCompletion: _calculateCategoryCompletion(weeklyMissions),
    );
    
    // Add to active missions
    for (final mission in weeklyMissions) {
      if (!_activeMissions.any((m) => m.id == mission.id)) {
        _activeMissions.add(mission);
      }
    }
  }
  
  List<Mission> _createWeeklyMissions() {
    final templates = MissionCatalog.getWeeklyTemplates();
    final missions = <Mission>[];
    
    // Pick 3-5 missions based on student profile
    templates.shuffle();
    final count = 3 + Random().nextInt(3); // 3-5 missions
    
    for (int i = 0; i < min(count, templates.length); i++) {
      final template = templates[i];
      missions.add(Mission.fromTemplate(
        template,
        weekStart: DateTime.now().subtract(Duration(days: DateTime.now().weekday % 7)),
      ));
    }
    
    return missions;
  }
  
  void _ensureDailyMissions() {
    final today = DateTime.now();
    final hasDaily = _activeMissions.any((m) => 
      m.type == MissionType.daily && 
      m.createdAt != null &&
      _isSameDay(m.createdAt!, today));
    
    if (!hasDaily) {
      final dailyMissions = _createDailyMissions();
      for (final mission in dailyMissions) {
        _activeMissions.add(mission);
      }
    }
  }
  
  List<Mission> _createDailyMissions() {
    final templates = MissionCatalog.getDailyTemplates();
    final missions = <Mission>[];
    
    // 1-2 daily missions
    final count = 1 + Random().nextInt(2);
    templates.shuffle();
    
    for (int i = 0; i < min(count, templates.length); i++) {
      missions.add(Mission.fromTemplate(
        templates[i],
        createdAt: DateTime.now(),
      ));
    }
    
    return missions;
  }
  
  Map<MissionCategory, int> _calculateCategoryCompletion(List<Mission> missions) {
    final completion = <MissionCategory, int>{};
    for (final mission in missions) {
      completion[mission.category] = (completion[mission.category] ?? 0) + 1;
    }
    return completion;
  }
  
  Future<void> updateMissionProgress(String missionId, int xpGained) async {
    final index = _activeMissions.indexWhere((m) => m.id == missionId);
    if (index == -1) return;
    
    final mission = _activeMissions[index];
    final newProgress = mission.progressCurrent + xpGained;
    
    if (newProgress >= mission.progressTarget) {
      // Mission completed!
      _activeMissions.removeAt(index);
      final completedMission = mission.copyWith(
        isCompleted: true,
        completedAt: DateTime.now(),
        progressCurrent: mission.progressTarget,
        isClaimed: false,
      );
      _completedMissions.add(completedMission);
      _missionCompleteController.add(completedMission);
      
      // Award bonus XP for completion
      await addXP(
        amount: 50,
        pillar: mission.pillar,
        source: 'mission_completion',
        missionId: missionId,
      );
      
      // Check for weekly bonus
      _checkWeeklyBonus();
    } else {
      _activeMissions[index] = mission.copyWith(
        progressCurrent: newProgress,
      );
    }
  }
  
  void _checkWeeklyBonus() {
    if (_currentWeeklyMissions == null || _currentWeeklyMissions!.isBonusClaimed) return;
    
    final allWeeklyCompleted = _currentWeeklyMissions!.missions
        .every((m) => _completedMissions.any((c) => c.id == m.id));
    
    if (allWeeklyCompleted) {
      // Weekly bonus available
      // User needs to claim it
    }
  }
  
  Future<void> claimWeeklyBonus() async {
    if (_currentWeeklyMissions == null || _currentWeeklyMissions!.isBonusClaimed) return;
    
    _currentWeeklyMissions = _currentWeeklyMissions!.copyWith(
      isBonusClaimed: true,
      bonusClaimedAt: DateTime.now(),
    );
    
    await addXP(
      amount: 200,
      pillar: AdmissionsPillar.consistency,
      source: 'weekly_bonus',
    );
  }
  
  Future<void> claimMissionReward(String missionId) async {
    final index = _completedMissions.indexWhere((m) => m.id == missionId);
    if (index == -1 || _completedMissions[index].isClaimed) return;
    
    _completedMissions[index] = _completedMissions[index].copyWith(
      isClaimed: true,
      claimedAt: DateTime.now(),
    );
    
    // Additional reward for claiming
    await addXP(
      amount: 20,
      pillar: _completedMissions[index].pillar,
      source: 'mission_claim',
    );
  }
  
  // MARK: - Skin Management
  
  Future<void> equipSkin(SkinTier tier) async {
    final config = SkinCatalog.getConfig(tier);
    if (!_isTierUnlocked(tier)) return;
    
    _currentSkinTier = tier;
    _equippedSkinId = config.name;
  }
  
  Future<void> equipFrame(String frameId) async {
    _equippedFrameId = frameId;
  }
  
  Future<void> addEquippedBadge(String badgeId) async {
    if (!_equippedBadges.contains(badgeId)) {
      _equippedBadges.add(badgeId);
    }
  }
  
  Future<void> removeEquippedBadge(String badgeId) async {
    _equippedBadges.remove(badgeId);
  }
  
  // MARK: - Admissions Probability Integration
  
  Future<AdmissionsProbabilityResult> calculateAdmissionsProbability(
    StudentProfile student,
  ) async {
    final universities = _buildTargetUniversities(student);
    return await _admissionsEngine.calculateProbability(
      student: student,
      universities: universities,
      activities: student.activities,
    );
  }
  
  List<TargetUniversity> _buildTargetUniversities(StudentProfile student) {
    final universities = <TargetUniversity>[];
    
    for (final uni in student.reachUniversities) {
      universities.add(TargetUniversity(
        name: uni,
        country: student.targetCountries.first,
        major: student.targetMajor,
        tier: 'reach',
      ));
    }
    for (final uni in student.matchUniversities) {
      universities.add(TargetUniversity(
        name: uni,
        country: student.targetCountries.first,
        major: student.targetMajor,
        tier: 'match',
      ));
    }
    for (final uni in student.safetyUniversities) {
      universities.add(TargetUniversity(
        name: uni,
        country: student.targetCountries.first,
        major: student.targetMajor,
        tier: 'safety',
      ));
    }
    
    return universities;
  }
  
  // MARK: - Utility
  
  String _dateToString(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }
  
  bool _isSameDay(DateTime d1, DateTime d2) {
    return d1.year == d2.year && d1.month == d2.month && d1.day == d2.day;
  }
  
  void dispose() {
    _skinUnlockController.close();
    _levelUpController.close();
    _missionCompleteController.close();
  }
}

// MARK: - Result Types

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

@immutable
class StreakActionResult {
  final bool success;
  final String message;
  final Streak streak;
  final int xpGained;
  
  const StreakActionResult({
    required this.success,
    required this.message,
    required this.streak,
    required this.xpGained,
  });
}