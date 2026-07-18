import 'package:freezed_annotation/freezed_annotation.dart';

part 'skin_definitions.freezed.dart';

/// Rarity tiers for cosmetic skins. Drives unlock difficulty and visual weight.
enum SkinRarity {
  common,
  rare,
  epic,
  legendary,
  mythic;

  double get multiplier {
    switch (this) {
      case SkinRarity.common:
        return 1.0;
      case SkinRarity.rare:
        return 1.05;
      case SkinRarity.epic:
        return 1.1;
      case SkinRarity.legendary:
        return 1.2;
      case SkinRarity.mythic:
        return 1.35;
    }
  }
}

/// The nine progression skins, each mapped to a university-admission pillar.
enum SkinPillar {
  academics,
  leadership,
  research,
  creativity,
  community,
  service,
  athletics,
  character,
  global,
}

/// A cosmetic skin definition. Pure data — no Flutter dependency.
@freezed
class Skin with _$Skin {
  const factory Skin({
    required String id,
    required String name,
    required SkinRarity rarity,
    required SkinPillar pillar,
    /// Primary Material 3 seed color (hex int).
    required int seedColor,
    /// Secondary/brightness accent.
    required int accentColor,
    required String description,
    /// XP threshold required to unlock.
    required int xpThreshold,
    /// Optional pillar this skin synergizes with (bonus when active).
    SkinPillar? synergyPillar,
  }) = _Skin;

  const Skin._();

  /// Multiplier applied to XP gain when this skin is equipped.
  double get xpMultiplier => rarity.multiplier;

  /// Whether the user's XP qualifies them to unlock this skin.
  bool isUnlockedAt(int totalXp) => totalXp >= xpThreshold;
}

/// The canonical nine skins aligned to admission pillars.
const List<Skin> kSkins = [
  Skin(
    id: 'scholar',
    name: 'Scholar',
    rarity: SkinRarity.common,
    pillar: SkinPillar.academics,
    seedColor: 0xFF1565C0,
    accentColor: 0xFF90CAF9,
    description: 'Steady academic grind. The foundation of every application.',
    xpThreshold: 0,
  ),
  Skin(
    id: 'captain',
    name: 'Captain',
    rarity: SkinRarity.rare,
    pillar: SkinPillar.leadership,
    seedColor: 0xFF2E7D32,
    accentColor: 0xFFA5D6A7,
    description: 'For those who lead clubs, teams, and movements.',
    xpThreshold: 1500,
    synergyPillar: SkinPillar.community,
  ),
  Skin(
    id: 'investigator',
    name: 'Investigator',
    rarity: SkinRarity.epic,
    pillar: SkinPillar.research,
    seedColor: 0xFF6A1B9A,
    accentColor: 0xFFCE93D8,
    description: 'Lab coats and late nights. Research pedigree unlocked.',
    xpThreshold: 4000,
    synergyPillar: SkinPillar.academics,
  ),
  Skin(
    id: 'maker',
    name: 'Maker',
    rarity: SkinRarity.epic,
    pillar: SkinPillar.creativity,
    seedColor: 0xFFC2185B,
    accentColor: 0xFFF48FB1,
    description: 'Builders, artists, and founders of things that did not exist.',
    xpThreshold: 5500,
    synergyPillar: SkinPillar.leadership,
  ),
  Skin(
    id: 'citizen',
    name: 'Citizen',
    rarity: SkinRarity.rare,
    pillar: SkinPillar.community,
    seedColor: 0xFF00838F,
    accentColor: 0xFF80DEEA,
    description: 'Service to others compounds. Community impact unlocked.',
    xpThreshold: 2500,
    synergyPillar: SkinPillar.service,
  ),
  Skin(
    id: 'guardian',
    name: 'Guardian',
    rarity: SkinRarity.epic,
    pillar: SkinPillar.service,
    seedColor: 0xFFEF6C00,
    accentColor: 0xFFFFCC80,
    description: 'Volunteer hours and quiet impact. The unsung pillar.',
    xpThreshold: 3500,
    synergyPillar: SkinPillar.community,
  ),
  Skin(
    id: 'athlete',
    name: 'Athlete',
    rarity: SkinRarity.rare,
    pillar: SkinPillar.athletics,
    seedColor: 0xFFD32F2F,
    accentColor: 0xFFEF9A9A,
    description: 'Discipline of the body sharpens the mind.',
    xpThreshold: 2000,
    synergyPillar: SkinPillar.character,
  ),
  Skin(
    id: 'paragon',
    name: 'Paragon',
    rarity: SkinRarity.legendary,
    pillar: SkinPillar.character,
    seedColor: 0xFF37474F,
    accentColor: 0xFFB0BEC5,
    description: 'Integrity, resilience, and the long game. Mythic character.',
    xpThreshold: 9000,
    synergyPillar: SkinPillar.global,
  ),
  Skin(
    id: 'diplomat',
    name: 'Diplomat',
    rarity: SkinRarity.mythic,
    pillar: SkinPillar.global,
    seedColor: 0xFF00897B,
    accentColor: 0xFF80CBC4,
    description: 'A global citizen. The rarest admission advantage.',
    xpThreshold: 15000,
    synergyPillar: SkinPillar.research,
  ),
];

/// Resolve a skin by id (falls back to the first/common skin).
Skin skinById(String id) => kSkins.firstWhere((s) => s.id == id, orElse: () => kSkins.first);

/// Synergy bonus: if equipped skin's synergyPillar matches the activity pillar,
/// return the bonus multiplier; otherwise 1.0.
double synergyBonus(Skin equipped, SkinPillar activityPillar) {
  if (equipped.synergyPillar == activityPillar) return 1.1;
  return 1.0;
}
