import 'package:freezed_annotation/freezed_annotation.dart';
import 'admissions_pillar.dart';

part 'skins.freezed.dart';
part 'skins.g.dart';

/// Skin tiers mapped to admissions pillars
enum SkinTier {
  explorer,           // Academic Explorer - Academics
  scholar,            // Scholar - Academics depth
  evidenceKeeper,     // Evidence Keeper - Evidence/Activities
  marathonRunner,     // Marathon Runner - Consistency/Stamina
  researcher,         // Researcher - Research pillar
  leader,             // Leader - Leadership pillar
  creator,            // Creator - Creative/Arts pillar
  changemaker,        // Changemaker - Community/Impact pillar
  trailblazer,        // Trailblazer - Trailblazer/Innovation pillar (Legendary)
}

extension SkinTierExtension on SkinTier {
  String get name => toString().split('.').last;
}

class SkinTierConverter implements JsonConverter<SkinTier, String> {
  const SkinTierConverter();

  @override
  SkinTier fromJson(String json) {
    return SkinTier.values.firstWhere(
      (e) => e.name.toLowerCase() == json.toLowerCase(),
      orElse: () => SkinTier.explorer,
    );
  }

  @override
  String toJson(SkinTier object) => object.name;
}

/// Skin rarity tiers
enum SkinRarity {
  common,      // Explorer, Scholar
  uncommon,    // Evidence Keeper, Marathon Runner
  rare,        // Researcher, Leader, Creator, Changemaker
  legendary,   // Trailblazer
}

extension SkinRarityExtension on SkinRarity {
  String get name => toString().split('.').last;
}

class SkinRarityConverter implements JsonConverter<SkinRarity, String> {
  const SkinRarityConverter();

  @override
  SkinRarity fromJson(String json) {
    return SkinRarity.values.firstWhere(
      (e) => e.name.toLowerCase() == json.toLowerCase(),
      orElse: () => SkinRarity.common,
    );
  }

  @override
  String toJson(SkinRarity object) => object.name;
}

/// Skin model with all visual and metadata properties
@freezed
abstract class Skin with _$Skin {
  const factory Skin({
    required String id,
    @SkinTierConverter() required SkinTier tier,
    required String name,
    required String displayName,
    required String description,
    required String loreDescription,
    @SkinRarityConverter() required SkinRarity rarity,
    required String previewAssetPath,
    required String unlockedAssetPath,
    required String lockedAssetPath,
    required String iconAssetPath,
    required String particleEffectPath,
    required String backgroundAssetPath,
    required int xpRequired,
    required int tierOrder,
    required Map<String, int> pillarXPRequirements,
    required List<String> unlockCriteria,
    required Map<String, dynamic> visualProperties,
    required DateTime? unlockedAt,
    required bool isUnlocked,
    required bool isEquipped,
    required DateTime? equippedAt,
  }) = _Skin;

  factory Skin.fromJson(Map<String, dynamic> json) => _$SkinFromJson(json);
}

/// Skin model with all visual and metadata properties
@freezed
abstract class PillarXPRequirements with _$PillarXPRequirements {
  const factory PillarXPRequirements({
    required int academicsXP,
    required int evidenceXP,
    required int consistencyXP,
    required int researchXP,
    required int leadershipXP,
    required int creativityXP,
    required int communityImpactXP,
  }) = _PillarXPRequirements;

  factory PillarXPRequirements.fromJson(Map<String, dynamic> json) => _$PillarXPRequirementsFromJson(json);
}

/// Predefined skin configurations
class SkinCatalog {
  static const Map<SkinTier, SkinConfig> skins = {
    SkinTier.explorer: SkinConfig(
      tier: SkinTier.explorer,
      name: 'explorer',
      displayName: 'Academic Explorer',
      description: 'First steps into academic exploration. Curiosity sparked.',
      loreDescription: 'Every journey begins with a single question. The Explorer has asked theirs.',
      rarity: SkinRarity.common,
      xpRequired: 0,
      tierOrder: 1,
      pillarXPRequirements: PillarXPRequirements(
        academicsXP: 0,
        evidenceXP: 0,
        consistencyXP: 0,
        researchXP: 0,
        leadershipXP: 0,
        creativityXP: 0,
        communityImpactXP: 0,
      ),
      unlockCriteria: [
        'Create your ProfileForge profile',
        'Add your first academic subject',
      ],
      visualProperties: {
        'primaryColor': 0xFF4A90D9,
        'secondaryColor': 0xFFE8F4FD,
        'accentColor': 0xFF2E6DA4,
        'particleType': 'sparkle',
        'backgroundPattern': 'subtle_grid',
        'glowIntensity': 0.3,
      },
      previewAsset: 'assets/skins/explorer/preview.png',
      unlockedAsset: 'assets/skins/explorer/unlocked.png',
      lockedAsset: 'assets/skins/explorer/locked.png',
      iconAsset: 'assets/skins/explorer/icon.png',
      particleEffect: 'assets/skins/explorer/particles.json',
      backgroundAsset: 'assets/skins/explorer/bg.png',
    ),
    SkinTier.scholar: SkinConfig(
      tier: SkinTier.scholar,
      name: 'scholar',
      displayName: 'Scholar',
      description: 'Deep academic commitment. Knowledge becomes second nature.',
      loreDescription: 'The Scholar doesn\'t just learn - they understand. Every subject, a new lens.',
      rarity: SkinRarity.common,
      xpRequired: 500,
      tierOrder: 2,
      pillarXPRequirements: PillarXPRequirements(
        academicsXP: 500,
        evidenceXP: 100,
        consistencyXP: 100,
        researchXP: 50,
        leadershipXP: 50,
        creativityXP: 50,
        communityImpactXP: 50,
      ),
      unlockCriteria: [
        'Earn 500 Academics XP',
        'Complete 3 academic activities',
        'Maintain 7-day study streak',
      ],
      visualProperties: {
        'primaryColor': 0xFF2E6DA4,
        'secondaryColor': 0xFFD6EAF8,
        'accentColor': 0xFF1B4F72,
        'particleType': 'book_particles',
        'backgroundPattern': 'parchment',
        'glowIntensity': 0.5,
      },
      previewAsset: 'assets/skins/scholar/preview.png',
      unlockedAsset: 'assets/skins/scholar/unlocked.png',
      lockedAsset: 'assets/skins/scholar/locked.png',
      iconAsset: 'assets/skins/scholar/icon.png',
      particleEffect: 'assets/skins/scholar/particles.json',
      backgroundAsset: 'assets/skins/scholar/bg.png',
    ),
    SkinTier.evidenceKeeper: SkinConfig(
      tier: SkinTier.evidenceKeeper,
      name: 'evidence_keeper',
      displayName: 'Evidence Keeper',
      description: 'Master of documentation. Every achievement, preserved.',
      loreDescription: 'The Evidence Keeper knows: if it isn\'t documented, it didn\'t happen. They archive greatness.',
      rarity: SkinRarity.uncommon,
      xpRequired: 1500,
      tierOrder: 3,
      pillarXPRequirements: PillarXPRequirements(
        academicsXP: 300,
        evidenceXP: 1000,
        consistencyXP: 200,
        researchXP: 100,
        leadershipXP: 100,
        creativityXP: 100,
        communityImpactXP: 100,
      ),
      unlockCriteria: [
        'Earn 1000 Evidence XP',
        'Document 10 activities with evidence',
        'Get 3 teacher verifications',
      ],
      visualProperties: {
        'primaryColor': 0xFF27AE60,
        'secondaryColor': 0xFFE8F8F5,
        'accentColor': 0xFF1E8449,
        'particleType': 'document_particles',
        'backgroundPattern': 'archive_texture',
        'glowIntensity': 0.6,
      },
      previewAsset: 'assets/skins/evidence_keeper/preview.png',
      unlockedAsset: 'assets/skins/evidence_keeper/unlocked.png',
      lockedAsset: 'assets/skins/evidence_keeper/locked.png',
      iconAsset: 'assets/skins/evidence_keeper/icon.png',
      particleEffect: 'assets/skins/evidence_keeper/particles.json',
      backgroundAsset: 'assets/skins/evidence_keeper/bg.png',
    ),
    SkinTier.marathonRunner: SkinConfig(
      tier: SkinTier.marathonRunner,
      name: 'marathon_runner',
      displayName: 'Marathon Runner',
      description: 'Consistency incarnate. Shows up every single day.',
      loreDescription: 'The Marathon Runner doesn\'t sprint. They endure. Day after day, they show up.',
      rarity: SkinRarity.uncommon,
      xpRequired: 2500,
      tierOrder: 4,
      pillarXPRequirements: PillarXPRequirements(
        academicsXP: 300,
        evidenceXP: 200,
        consistencyXP: 2000,
        researchXP: 100,
        leadershipXP: 100,
        creativityXP: 100,
        communityImpactXP: 100,
      ),
      unlockCriteria: [
        'Earn 2000 Consistency XP',
        'Maintain 30-day streak (with grace days)',
        'Complete 50 daily check-ins',
      ],
      visualProperties: {
        'primaryColor': 0xFFE67E22,
        'secondaryColor': 0xFFFDF2E9,
        'accentColor': 0xFFD35400,
        'particleType': 'endurance_trail',
        'backgroundPattern': 'track_texture',
        'glowIntensity': 0.7,
      },
      previewAsset: 'assets/skins/marathon_runner/preview.png',
      unlockedAsset: 'assets/skins/marathon_runner/unlocked.png',
      lockedAsset: 'assets/skins/marathon_runner/locked.png',
      iconAsset: 'assets/skins/marathon_runner/icon.png',
      particleEffect: 'assets/skins/marathon_runner/particles.json',
      backgroundAsset: 'assets/skins/marathon_runner/bg.png',
    ),
    SkinTier.researcher: SkinConfig(
      tier: SkinTier.researcher,
      name: 'researcher',
      displayName: 'Researcher',
      description: 'Seeker of new knowledge. Creates what didn\'t exist before.',
      loreDescription: 'The Researcher doesn\'t accept answers. They question them. Then find new ones.',
      rarity: SkinRarity.rare,
      xpRequired: 5000,
      tierOrder: 5,
      pillarXPRequirements: PillarXPRequirements(
        academicsXP: 500,
        evidenceXP: 500,
        consistencyXP: 500,
        researchXP: 3000,
        leadershipXP: 500,
        creativityXP: 500,
        communityImpactXP: 500,
      ),
      unlockCriteria: [
        'Earn 3000 Research XP',
        'Complete 1 research project',
        'Publish/present 1 finding',
      ],
      visualProperties: {
        'primaryColor': 0xFF8E44AD,
        'secondaryColor': 0xFFF5EEF8,
        'accentColor': 0xFF7D3C98,
        'particleType': 'data_particles',
        'backgroundPattern': 'lab_notes',
        'glowIntensity': 0.8,
      },
      previewAsset: 'assets/skins/researcher/preview.png',
      unlockedAsset: 'assets/skins/researcher/unlocked.png',
      lockedAsset: 'assets/skins/researcher/locked.png',
      iconAsset: 'assets/skins/researcher/icon.png',
      particleEffect: 'assets/skins/researcher/particles.json',
      backgroundAsset: 'assets/skins/researcher/bg.png',
    ),
    SkinTier.leader: SkinConfig(
      tier: SkinTier.leader,
      name: 'leader',
      displayName: 'Leader',
      description: 'Guides others. Builds teams. Creates change through others.',
      loreDescription: 'The Leader doesn\'t walk alone. They clear the path so others can follow.',
      rarity: SkinRarity.rare,
      xpRequired: 5000,
      tierOrder: 6,
      pillarXPRequirements: PillarXPRequirements(
        academicsXP: 500,
        evidenceXP: 500,
        consistencyXP: 500,
        researchXP: 500,
        leadershipXP: 3000,
        creativityXP: 500,
        communityImpactXP: 500,
      ),
      unlockCriteria: [
        'Earn 3000 Leadership XP',
        'Lead 1 team/club/organization',
        'Mentor 3+ peers',
      ],
      visualProperties: {
        'primaryColor': 0xFFC0392B,
        'secondaryColor': 0xFFFADBD8,
        'accentColor': 0xFF922B21,
        'particleType': 'leadership_aura',
        'backgroundPattern': 'banner_pattern',
        'glowIntensity': 0.8,
      },
      previewAsset: 'assets/skins/leader/preview.png',
      unlockedAsset: 'assets/skins/leader/unlocked.png',
      lockedAsset: 'assets/skins/leader/locked.png',
      iconAsset: 'assets/skins/leader/icon.png',
      particleEffect: 'assets/skins/leader/particles.json',
      backgroundAsset: 'assets/skins/leader/bg.png',
    ),
    SkinTier.creator: SkinConfig(
      tier: SkinTier.creator,
      name: 'creator',
      displayName: 'Creator',
      description: 'Makes things that didn\'t exist. Art, code, music, systems.',
      loreDescription: 'The Creator sees blank canvases everywhere. And fills them all.',
      rarity: SkinRarity.rare,
      xpRequired: 5000,
      tierOrder: 7,
      pillarXPRequirements: PillarXPRequirements(
        academicsXP: 500,
        evidenceXP: 500,
        consistencyXP: 500,
        researchXP: 500,
        leadershipXP: 500,
        creativityXP: 3000,
        communityImpactXP: 500,
      ),
      unlockCriteria: [
        'Earn 3000 Creativity XP',
        'Create 3 portfolio pieces',
        'Showcase 1 public work',
      ],
      visualProperties: {
        'primaryColor': 0xFFE74C3C,
        'secondaryColor': 0xFFFDF2F2,
        'accentColor': 0xFFC0392B,
        'particleType': 'creative_sparks',
        'backgroundPattern': 'canvas_texture',
        'glowIntensity': 0.75,
      },
      previewAsset: 'assets/skins/creator/preview.png',
      unlockedAsset: 'assets/skins/creator/unlocked.png',
      lockedAsset: 'assets/skins/creator/locked.png',
      iconAsset: 'assets/skins/creator/icon.png',
      particleEffect: 'assets/skins/creator/particles.json',
      backgroundAsset: 'assets/skins/creator/bg.png',
    ),
    SkinTier.changemaker: SkinConfig(
      tier: SkinTier.changemaker,
      name: 'changemaker',
      displayName: 'Changemaker',
      description: 'Impacts community. Solves real problems. Leaves things better.',
      loreDescription: 'The Changemaker sees problems as invitations. And RSVPs with action.',
      rarity: SkinRarity.rare,
      xpRequired: 5000,
      tierOrder: 8,
      pillarXPRequirements: PillarXPRequirements(
        academicsXP: 500,
        evidenceXP: 500,
        consistencyXP: 500,
        researchXP: 500,
        leadershipXP: 500,
        creativityXP: 500,
        communityImpactXP: 3000,
      ),
      unlockCriteria: [
        'Earn 3000 Community Impact XP',
        'Lead 1 community initiative',
        'Impact 50+ people',
      ],
      visualProperties: {
        'primaryColor': 0xFF16A085,
        'secondaryColor': 0xFFE8F8F5,
        'accentColor': 0xFF138D75,
        'particleType': 'impact_ripples',
        'backgroundPattern': 'community_mesh',
        'glowIntensity': 0.85,
      },
      previewAsset: 'assets/skins/changemaker/preview.png',
      unlockedAsset: 'assets/skins/changemaker/unlocked.png',
      lockedAsset: 'assets/skins/changemaker/locked.png',
      iconAsset: 'assets/skins/changemaker/icon.png',
      particleEffect: 'assets/skins/changemaker/particles.json',
      backgroundAsset: 'assets/skins/changemaker/bg.png',
    ),
    SkinTier.trailblazer: SkinConfig(
      tier: SkinTier.trailblazer,
      name: 'trailblazer',
      displayName: 'Trailblazer',
      description: 'Legendary. Masters all pillars. Blazes trails for others.',
      loreDescription: 'The Trailblazer doesn\'t follow paths. They forge them. Others follow the light.',
      rarity: SkinRarity.legendary,
      xpRequired: 15000,
      tierOrder: 9,
      pillarXPRequirements: PillarXPRequirements(
        academicsXP: 2000,
        evidenceXP: 2000,
        consistencyXP: 2000,
        researchXP: 2000,
        leadershipXP: 2000,
        creativityXP: 2000,
        communityImpactXP: 2000,
      ),
      unlockCriteria: [
        'Earn 2000+ XP in ALL 7 pillars',
        'Unlock all 8 previous skins',
        'Complete Trailblazer Capstone Project',
      ],
      visualProperties: {
        'primaryColor': 0xFFF39C12,
        'secondaryColor': 0xFFFEF9E7,
        'accentColor': 0xFFD4AC0D,
        'particleType': 'legendary_aura',
        'backgroundPattern': 'constellation_map',
        'glowIntensity': 1.0,
      },
      previewAsset: 'assets/skins/trailblazer/preview.png',
      unlockedAsset: 'assets/skins/trailblazer/unlocked.png',
      lockedAsset: 'assets/skins/trailblazer/locked.png',
      iconAsset: 'assets/skins/trailblazer/icon.png',
      particleEffect: 'assets/skins/trailblazer/particles.json',
      backgroundAsset: 'assets/skins/trailblazer/bg.png',
    ),
  };

  static SkinConfig getConfig(SkinTier tier) => skins[tier]!;
  
  static List<SkinTier> getOrderedTiers() {
    final entries = skins.entries.toList();
    entries.sort((a, b) => a.value.tierOrder.compareTo(b.value.tierOrder));
    return entries.map((e) => e.key).toList();
  }
}

@freezed
abstract class SkinConfig with _$SkinConfig {
  const factory SkinConfig({
    required SkinTier tier,
    required String name,
    required String displayName,
    required String description,
    required String loreDescription,
    required SkinRarity rarity,
    required int xpRequired,
    required int tierOrder,
    required PillarXPRequirements pillarXPRequirements,
    required List<String> unlockCriteria,
    required Map<String, dynamic> visualProperties,
    required String previewAsset,
    required String unlockedAsset,
    required String lockedAsset,
    required String iconAsset,
    required String particleEffect,
    required String backgroundAsset,
  }) = _SkinConfig;

  factory SkinConfig.fromJson(Map<String, dynamic> json) => _$SkinConfigFromJson(json);
}

extension SkinConfigX on SkinConfig {
  Skin toSkin({required bool unlocked, bool equipped = false}) {
    return Skin(
      id: name,
      tier: tier,
      name: name,
      displayName: displayName,
      description: description,
      loreDescription: loreDescription,
      rarity: rarity,
      previewAssetPath: previewAsset,
      unlockedAssetPath: unlockedAsset,
      lockedAssetPath: lockedAsset,
      iconAssetPath: iconAsset,
      particleEffectPath: particleEffect,
      backgroundAssetPath: backgroundAsset,
      xpRequired: xpRequired,
      tierOrder: tierOrder,
      pillarXPRequirements: Map<String, int>.from(pillarXPRequirements.toJson()),
      unlockCriteria: unlockCriteria,
      visualProperties: visualProperties,
      unlockedAt: unlocked ? DateTime.now() : null,
      isUnlocked: unlocked,
      isEquipped: equipped,
      equippedAt: equipped ? DateTime.now() : null,
    );
  }
}