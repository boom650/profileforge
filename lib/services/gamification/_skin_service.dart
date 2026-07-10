import '../../models/gamification/skins.dart';
import '../../models/gamification/streak.dart';
import '../../models/gamification/xp.dart';
import '../../models/gamification/admissions_pillar.dart';

mixin SkinService on GamificationService {
  /// Check if any new skins should be unlocked; returns the first new tier or null.
  SkinTier? checkAndUnlockSkins() {
    SkinTier? firstNew;
    final ordered = SkinCatalog.getOrderedTiers();

    for (final tier in ordered) {
      if (ownedSkins.containsKey(tier)) continue;

      final config = SkinCatalog.getConfig(tier);
      if (meetsSkinRequirements(config)) {
        final skin = config.toSkin(unlocked: true);
        ownedSkins[tier] = skin;
        skinUnlockController.add(skin);
        firstNew ??= tier;
      }
    }
    return firstNew;
  }

  /// Check if player meets all requirements for a skin.
  bool meetsSkinRequirements(SkinConfig config) {
    // 1. Total XP requirement
    if (xpState.totalXP < config.xpRequired) return false;

    // 2. Pillar XP requirements
    final req = config.pillarXPRequirements;
    if ((xpState.pillarXP[AdmissionsPillar.academics] ?? 0) < req.academicsXP) return false;
    if ((xpState.pillarXP[AdmissionsPillar.evidence] ?? 0) < req.evidenceXP) return false;
    if ((xpState.pillarXP[AdmissionsPillar.consistency] ?? 0) < req.consistencyXP) return false;
    if ((xpState.pillarXP[AdmissionsPillar.research] ?? 0) < req.researchXP) return false;
    if ((xpState.pillarXP[AdmissionsPillar.leadership] ?? 0) < req.leadershipXP) return false;
    if ((xpState.pillarXP[AdmissionsPillar.creativity] ?? 0) < req.creativityXP) return false;
    if ((xpState.pillarXP[AdmissionsPillar.communityImpact] ?? 0) < req.communityImpactXP) return false;

    // 3. Legendary trailblazer requires all previous skins
    if (config.tier == SkinTier.trailblazer) {
      for (final other in SkinTier.values) {
        if (other == SkinTier.trailblazer) continue;
        if (!ownedSkins.containsKey(other)) return false;
      }
    }

    return true;
  }

  /// Equip a skin by tier. Only unlocked skins can be equipped.
  Future<void> equipSkin(SkinTier tier) async {
    if (ownedSkins.containsKey(tier)) {
      equippedSkinTier = tier;
      saveToPrefs();
    }
  }

  /// Equip a decorative frame by ID.
  Future<void> equipFrame(String frameId) async {
    equippedFrameId = frameId;
  }

  /// Add a badge to the equipped badge list (max 5).
  Future<void> addEquippedBadge(String badgeId) async {
    if (equippedBadges.length >= 5) return;
    if (!equippedBadges.contains(badgeId)) {
      equippedBadges.add(badgeId);
    }
  }

  /// Remove a badge from the equipped list.
  Future<void> removeEquippedBadge(String badgeId) async {
    equippedBadges.remove(badgeId);
  }
}