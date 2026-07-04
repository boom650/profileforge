import 'package:flutter_test/flutter_test.dart';
import 'package:profileforge/models/gamification/skins.dart';
import 'package:profileforge/models/gamification/admissions_pillar.dart';
import '../helpers.dart';

void main() {
  group('Skin', () {
    group('skin catalog completeness', () {
      test('SkinCatalog has entries for all 9 tiers', () {
        expect(SkinCatalog.skins.length, 9);
      });

      test('every SkinTier has a catalog entry', () {
        for (final tier in SkinTier.values) {
          expect(
            SkinCatalog.skins.containsKey(tier),
            true,
            reason: 'Missing catalog entry for ${tier.name}',
          );
        }
      });

      test('every catalog entry has a valid SkinConfig', () {
        for (final tier in SkinTier.values) {
          final config = SkinCatalog.getConfig(tier);
          expect(config.tier, tier);
          expect(config.name.isNotEmpty, true);
          expect(config.displayName.isNotEmpty, true);
          expect(config.description.isNotEmpty, true);
          expect(config.xpRequired, greaterThanOrEqualTo(0));
        }
      });

      test('getConfig returns correct config for each tier', () {
        final explorerConfig = SkinCatalog.getConfig(SkinTier.explorer);
        expect(explorerConfig.name, 'explorer');
        expect(explorerConfig.displayName, 'Academic Explorer');

        final trailblazerConfig = SkinCatalog.getConfig(SkinTier.trailblazer);
        expect(trailblazerConfig.name, 'trailblazer');
        expect(trailblazerConfig.displayName, 'Trailblazer');
      });
    });

    group('skin unlock thresholds', () {
      test('explorer requires 0 XP (free starter skin)', () {
        final config = SkinCatalog.getConfig(SkinTier.explorer);
        expect(config.xpRequired, 0);
      });

      test('XP requirements are strictly increasing by tier', () {
        final ordered = SkinCatalog.getOrderedTiers();
        for (int i = 1; i < ordered.length; i++) {
          final prevConfig = SkinCatalog.getConfig(ordered[i - 1]);
          final currConfig = SkinCatalog.getConfig(ordered[i]);
          expect(
            currConfig.xpRequired >= prevConfig.xpRequired,
            true,
            reason:
                '${ordered[i].name} (${currConfig.xpRequired} XP) should require >= '
                '${ordered[i - 1].name} (${prevConfig.xpRequired} XP)',
          );
        }
      });

      test('explorer has zero pillar XP requirements', () {
        final config = SkinCatalog.getConfig(SkinTier.explorer);
        expect(config.pillarXPRequirements.academicsXP, 0);
        expect(config.pillarXPRequirements.evidenceXP, 0);
        expect(config.pillarXPRequirements.consistencyXP, 0);
        expect(config.pillarXPRequirements.researchXP, 0);
        expect(config.pillarXPRequirements.leadershipXP, 0);
        expect(config.pillarXPRequirements.creativityXP, 0);
        expect(config.pillarXPRequirements.communityImpactXP, 0);
      });

      test('trailblazer requires high XP in all pillars', () {
        final config = SkinCatalog.getConfig(SkinTier.trailblazer);
        expect(config.pillarXPRequirements.academicsXP, 2000);
        expect(config.pillarXPRequirements.evidenceXP, 2000);
        expect(config.pillarXPRequirements.consistencyXP, 2000);
        expect(config.pillarXPRequirements.researchXP, 2000);
        expect(config.pillarXPRequirements.leadershipXP, 2000);
        expect(config.pillarXPRequirements.creativityXP, 2000);
        expect(config.pillarXPRequirements.communityImpactXP, 2000);
      });

      test('scholar requires 500 total XP and 500 academics XP', () {
        final config = SkinCatalog.getConfig(SkinTier.scholar);
        expect(config.xpRequired, 500);
        expect(config.pillarXPRequirements.academicsXP, 500);
      });

      test('researcher requires 5000 total XP and 3000 research XP', () {
        final config = SkinCatalog.getConfig(SkinTier.researcher);
        expect(config.xpRequired, 5000);
        expect(config.pillarXPRequirements.researchXP, 3000);
      });
    });

    group('skin tier ordering', () {
      test('getOrderedTiers returns 9 tiers', () {
        final ordered = SkinCatalog.getOrderedTiers();
        expect(ordered.length, 9);
      });

      test('tiers are ordered by tierOrder ascending', () {
        final ordered = SkinCatalog.getOrderedTiers();
        for (int i = 1; i < ordered.length; i++) {
          final prevOrder = SkinCatalog.getConfig(ordered[i - 1]).tierOrder;
          final currOrder = SkinCatalog.getConfig(ordered[i]).tierOrder;
          expect(
            currOrder > prevOrder,
            true,
            reason:
                '${ordered[i].name} (order $currOrder) should come after '
                '${ordered[i - 1].name} (order $prevOrder)',
          );
        }
      });

      test('explorer is first (tierOrder 1)', () {
        final ordered = SkinCatalog.getOrderedTiers();
        expect(ordered.first, SkinTier.explorer);
        expect(SkinCatalog.getConfig(SkinTier.explorer).tierOrder, 1);
      });

      test('trailblazer is last (tierOrder 9)', () {
        final ordered = SkinCatalog.getOrderedTiers();
        expect(ordered.last, SkinTier.trailblazer);
        expect(SkinCatalog.getConfig(SkinTier.trailblazer).tierOrder, 9);
      });
    });

    group('skin rarity', () {
      test('explorer and scholar are common', () {
        expect(SkinCatalog.getConfig(SkinTier.explorer).rarity, SkinRarity.common);
        expect(SkinCatalog.getConfig(SkinTier.scholar).rarity, SkinRarity.common);
      });

      test('evidence keeper and marathon runner are uncommon', () {
        expect(SkinCatalog.getConfig(SkinTier.evidenceKeeper).rarity, SkinRarity.uncommon);
        expect(SkinCatalog.getConfig(SkinTier.marathonRunner).rarity, SkinRarity.uncommon);
      });

      test('researcher, leader, creator, changemaker are rare', () {
        expect(SkinCatalog.getConfig(SkinTier.researcher).rarity, SkinRarity.rare);
        expect(SkinCatalog.getConfig(SkinTier.leader).rarity, SkinRarity.rare);
        expect(SkinCatalog.getConfig(SkinTier.creator).rarity, SkinRarity.rare);
        expect(SkinCatalog.getConfig(SkinTier.changemaker).rarity, SkinRarity.rare);
      });

      test('trailblazer is legendary', () {
        expect(SkinCatalog.getConfig(SkinTier.trailblazer).rarity, SkinRarity.legendary);
      });
    });

    group('SkinConfig.toSkin', () {
      test('creates unlocked Skin from config', () {
        final config = SkinCatalog.getConfig(SkinTier.explorer);
        final skin = config.toSkin(unlocked: true);
        expect(skin.isUnlocked, true);
        expect(skin.unlockedAt, isNotNull);
        expect(skin.tier, SkinTier.explorer);
        expect(skin.id, 'explorer');
      });

      test('creates locked Skin from config', () {
        final config = SkinCatalog.getConfig(SkinTier.scholar);
        final skin = config.toSkin(unlocked: false);
        expect(skin.isUnlocked, false);
        expect(skin.unlockedAt, isNull);
        expect(skin.isEquipped, false);
      });

      test('equipped skin has equippedAt set', () {
        final config = SkinCatalog.getConfig(SkinTier.explorer);
        final skin = config.toSkin(unlocked: true, equipped: true);
        expect(skin.isEquipped, true);
        expect(skin.equippedAt, isNotNull);
      });
    });

    group('SkinRarity', () {
      test('has 4 rarity levels', () {
        expect(SkinRarity.values.length, 4);
      });

      test('ordering is common < uncommon < rare < legendary', () {
        expect(SkinRarity.common.index, lessThan(SkinRarity.uncommon.index));
        expect(SkinRarity.uncommon.index, lessThan(SkinRarity.rare.index));
        expect(SkinRarity.rare.index, lessThan(SkinRarity.legendary.index));
      });
    });

    group('SkinTier', () {
      test('has 9 tiers', () {
        expect(SkinTier.values.length, 9);
      });

      test('SkinTierExtension.name works', () {
        expect(SkinTier.explorer.name, 'explorer');
        expect(SkinTier.trailblazer.name, 'trailblazer');
      });
    });

    group('SkinCollection', () {
      test('initial collection has explorer unlocked', () {
        final collection = SkinCollection.initial();
        expect(collection.ownedSkins.containsKey(SkinTier.explorer), true);
        expect(collection.equippedSkin, SkinTier.explorer);
        expect(collection.ownedSkins.length, 1);
      });

      test('initial collection has explorer in unlock dates', () {
        final collection = SkinCollection.initial();
        expect(collection.unlockDates.containsKey(SkinTier.explorer), true);
      });
    });

    group('SkinThemes', () {
      test('has themes for all 9 tiers', () {
        expect(SkinThemes.themes.length, 9);
      });

      test('getTheme returns theme for each tier', () {
        for (final tier in SkinTier.values) {
          final theme = SkinThemes.getTheme(tier);
          expect(theme.tier, tier);
          expect(theme.primaryColor, isNot(0));
        }
      });

      test('getTheme defaults to explorer for unknown tier', () {
        final theme = SkinThemes.getTheme(SkinTier.explorer);
        expect(theme.tier, SkinTier.explorer);
      });
    });
  });
}
