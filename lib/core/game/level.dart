/// Pure level system derived from total XP (Duolingo-style tiers).
class LevelEngine {
  const LevelEngine();

  /// XP required to *reach* a given level (cumulative).
  /// Gentle early curve, then steeper.
  int xpForLevel(int level) {
    if (level <= 1) return 0;
    var total = 0;
    for (var l = 1; l < level; l++) {
      total += 80 + (l - 1) * 20; // 80,100,120,...
    }
    return total;
  }

  ({int level, int intoLevel, int levelSpan, int nextLevelXp}) resolve(int totalXp) {
    var level = 1;
    while (totalXp >= xpForLevel(level + 1)) {
      level++;
      if (level > 999) break;
    }
    final base = xpForLevel(level);
    final next = xpForLevel(level + 1);
    final span = next - base;
    final into = totalXp - base;
    return (
      level: level,
      intoLevel: into,
      levelSpan: span,
      nextLevelXp: next,
    );
  }

  /// Fun title per level band (admission-journey flavored).
  String titleFor(int level) {
    if (level < 5) return 'Freshman';
    if (level < 10) return 'Scholar';
    if (level < 20) return 'Honor Student';
    if (level < 35) return 'Dean\'s List';
    if (level < 55) return 'Valedictorian';
    if (level < 80) return 'Admit';
    return 'Legend';
  }
}
