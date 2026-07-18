import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:profileforge/features/skins/application/skin_providers.dart';
import 'package:profileforge/features/skins/domain/skin_definitions.dart';

/// Skin picker screen. Shows the nine pillar skins, locked/unlocked state,
/// rarity, and an equip action with a subtle unlock animation.
class SkinsScreen extends ConsumerWidget {
  const SkinsScreen({super.key, required this.profileId});
  final String profileId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final unlocked = ref.watch(unlockedSkinsProvider(profileId));
    final equipped = ref.watch(equippedSkinProvider(profileId));
    return Scaffold(
      appBar: AppBar(title: const Text('Skins')),
      body: unlocked.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (unlockedSkins) {
          return GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 0.8,
            ),
            itemCount: kSkins.length,
            itemBuilder: (context, i) {
              final skin = kSkins[i];
              final isUnlocked = unlockedSkins.any((s) => s.id == skin.id);
              final isEquipped = equipped.when(
                data: (e) => e.id == skin.id,
                loading: () => false,
                error: (_, __) => false,
              );
              return _SkinTile(
                skin: skin,
                unlocked: isUnlocked,
                equipped: isEquipped,
                profileId: profileId,
              ).animate().fadeIn(delay: (i * 40).ms).scale();
            },
          );
        },
      ),
    );
  }
}

class _SkinTile extends ConsumerWidget {
  const _SkinTile({
    required this.skin,
    required this.unlocked,
    required this.equipped,
    required this.profileId,
  });

  final Skin skin;
  final bool unlocked;
  final bool equipped;
  final String profileId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final color = Color(skin.seedColor);
    return InkWell(
      onTap: unlocked
          ? () => ref.read(equipSkinProvider(
              (profileId: profileId, skinId: skin.id)))
          : null,
      borderRadius: BorderRadius.circular(16),
      child: Semantics(
        label: '${skin.name}, ${skin.rarity.name} skin, '
            '${unlocked ? 'unlocked' : 'locked'}'
            '${equipped ? ', equipped' : ''}',
        button: true,
        enabled: unlocked,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              colors: [color, Color(skin.accentColor)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            border: equipped
                ? Border.all(color: Colors.white, width: 3)
                : null,
          ),
          child: Stack(
            children: [
              Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      unlocked ? Icons.checkroom : Icons.lock,
                      size: 28,
                      color: Colors.white,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      skin.name,
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              if (!unlocked)
                Positioned(
                  bottom: 6,
                  left: 0,
                  right: 0,
                  child: Text(
                    '${skin.xpThreshold} XP',
                    style: const TextStyle(color: Colors.white70, fontSize: 10),
                    textAlign: TextAlign.center,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
