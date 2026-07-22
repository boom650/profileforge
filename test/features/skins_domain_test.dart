import 'package:flutter_test/flutter_test.dart';
import 'package:profileforge/features/skins/domain/skin_definitions.dart';

void main() {
  group('SkinRarity.multiplier', () {
    test('common = 1.0', () => expect(SkinRarity.common.multiplier, 1.0));
    test('rare = 1.05', () => expect(SkinRarity.rare.multiplier, 1.05));
    test('epic = 1.1', () => expect(SkinRarity.epic.multiplier, 1.1));
    test('legendary = 1.2', () => expect(SkinRarity.legendary.multiplier, 1.2));
    test('mythic = 1.35', () => expect(SkinRarity.mythic.multiplier, 1.35));
  });

  group('Skin.isUnlockedAt', () {
    test('scholar is unlocked at 0 XP', () {
      final scholar = kSkins.firstWhere((s) => s.id == 'scholar');
      expect(scholar.isUnlockedAt(0), true);
      expect(scholar.isUnlockedAt(-1), false);
    });

    test('captain unlocks at 1500 XP', () {
      final captain = kSkins.firstWhere((s) => s.id == 'captain');
      expect(captain.isUnlockedAt(1499), false);
      expect(captain.isUnlockedAt(1500), true);
      expect(captain.isUnlockedAt(10000), true);
    });

    test('investigator unlocks at 4000 XP', () {
      final inv = kSkins.firstWhere((s) => s.id == 'investigator');
      expect(inv.isUnlockedAt(3999), false);
      expect(inv.isUnlockedAt(4000), true);
    });

    test('each skin has a unique id', () {
      final ids = kSkins.map((s) => s.id).toSet();
      expect(ids.length, kSkins.length);
    });
  });

  group('Skin.xpMultiplier', () {
    test('matches rarity multiplier', () {
      for (final skin in kSkins) {
        expect(skin.xpMultiplier, skin.rarity.multiplier);
      }
    });
  });

  group('kSkins catalog', () {
    test('has at least 10 skins (current count varies)', () {
      expect(kSkins.length, greaterThanOrEqualTo(10));
    });

    test('all skins have non-empty names and descriptions', () {
      for (final skin in kSkins) {
        expect(skin.name.isNotEmpty, true, reason: 'skin ${skin.id} has empty name');
        expect(skin.description.isNotEmpty, true, reason: 'skin ${skin.id} has empty desc');
      }
    });

    test('all skins have positive seed and accent colors', () {
      for (final skin in kSkins) {
        expect(skin.seedColor, greaterThan(0));
        expect(skin.accentColor, greaterThan(0));
      }
    });

    test('all xpThresholds are non-negative', () {
      for (final skin in kSkins) {
        expect(skin.xpThreshold, greaterThanOrEqualTo(0));
      }
    });

    test('first skin is scholar at 0 XP', () {
      expect(kSkins.first.id, 'scholar');
      expect(kSkins.first.xpThreshold, 0);
    });
  });
}
