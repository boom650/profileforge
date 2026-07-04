/// Spike Identification Framework
///
/// A "spike" is an unusual achievement that stands out in college admissions.
/// This service analyzes a student's activities and identifies their strongest
/// spikes based on rarity, impact, and admissions value.
library;

import '../models/student_profile.dart';

/// Categories of spikes that admissions committees look for.
enum SpikeCategory {
  academicExcellence,
  researchPublication,
  competitionWinner,
  leadership,
  socialImpact,
  uniqueTalent,
}

extension SpikeCategoryExtension on SpikeCategory {
  String get displayName {
    switch (this) {
      case SpikeCategory.academicExcellence:
        return 'Academic Excellence';
      case SpikeCategory.researchPublication:
        return 'Research Publication';
      case SpikeCategory.competitionWinner:
        return 'Competition Winner';
      case SpikeCategory.leadership:
        return 'Leadership';
      case SpikeCategory.socialImpact:
        return 'Social Impact';
      case SpikeCategory.uniqueTalent:
        return 'Unique Talent';
    }
  }

  String get icon {
    switch (this) {
      case SpikeCategory.academicExcellence:
        return '🎓';
      case SpikeCategory.researchPublication:
        return '🔬';
      case SpikeCategory.competitionWinner:
        return '🏆';
      case SpikeCategory.leadership:
        return '👑';
      case SpikeCategory.socialImpact:
        return '🌍';
      case SpikeCategory.uniqueTalent:
        return '✨';
    }
  }

  /// Color index for UI rendering (matches AppTheme category colors)
  String get colorKey {
    switch (this) {
      case SpikeCategory.academicExcellence:
        return 'courses';
      case SpikeCategory.researchPublication:
        return 'research';
      case SpikeCategory.competitionWinner:
        return 'competitions';
      case SpikeCategory.leadership:
        return 'leadership';
      case SpikeCategory.socialImpact:
        return 'volunteering';
      case SpikeCategory.uniqueTalent:
        return 'unique';
    }
  }
}

/// A detected spike — an unusual achievement that stands out.
class Spike {
  /// Which category this spike falls into.
  final SpikeCategory category;

  /// Human-readable description of the spike.
  final String description;

  /// Rarity rating (1–5 stars). Higher = more unusual / impressive.
  final int rarity;

  /// Impact score for admissions (0–100). How much this helps the profile.
  final int impactScore;

  /// The source activity (or activities) that generated this spike.
  final List<Activity> sourceActivities;

  const Spike({
    required this.category,
    required this.description,
    required this.rarity,
    required this.impactScore,
    required this.sourceActivities,
  });

  /// Convenience: star display string.
  String get starsDisplay => '★' * rarity + '☆' * (5 - rarity);
}

/// Keywords used for heuristic spike detection.
class _SpikeKeywords {
  // Tier 1 → National / International competition keywords
  static const nationalKeywords = [
    'national', 'international', 'global', 'world', 'olympiad',
    'olympics', 'state-level', 'inter-state',
  ];

  // Research / Publication keywords
  static const publicationKeywords = [
    'published', 'journal', 'paper', 'research', 'arxiv',
    'conference', 'proceedings', 'peer-reviewed', 'ieee',
    'pubmed', 'index',
  ];

  // Leadership / Founding keywords
  static const foundingKeywords = [
    'founded', 'founding', 'started', 'established', 'launched',
    'president', 'head', 'captain', 'chair',
  ];

  // Volunteer hours threshold
  static const int volunteerHoursThreshold = 500;

  // Perfect score keywords
  static const perfectScoreKeywords = [
    'perfect', '1600', '1580', '1590', '36/36', '800',
    'full marks', 'topped', 'first', 'gold medal',
  ];
}

/// Analyzes a list of activities and returns detected spikes, sorted by
/// impact score (highest first).
///
/// Detection logic:
/// - National/international competitions → high rarity
/// - Publications in journals → very high rarity
/// - Founding an organization → high rarity
/// - Volunteering 500+ hours → medium rarity
/// - Perfect test scores (via evidence) → high rarity
/// - Awards with 'national' or 'international' in name → high rarity
List<Spike> analyzeSpikes(List<Activity> activities) {
  final List<Spike> spikes = [];

  for (final activity in activities) {
    final lowerTitle = activity.title.toLowerCase();
    final lowerDescription = activity.description.toLowerCase();
    final lowerEvidence = (activity.evidence ?? '').toLowerCase();
    final combined = '$lowerTitle $lowerDescription $lowerEvidence';
    final totalHours = activity.hoursPerWeek * activity.weeksPerYear;

    // ── National / International Competition ──────────────────────────
    final isNational = _SpikeKeywords.nationalKeywords
        .any((kw) => combined.contains(kw));

    if (activity.category == ActivityCategory.competitions && isNational) {
      spikes.add(Spike(
        category: SpikeCategory.competitionWinner,
        description: 'National/International Competition: ${activity.title}',
        rarity: activity.tier == ActivityTier.tier1 ? 5 : 4,
        impactScore: _clampScore(activity.tier.weight + 20),
        sourceActivities: [activity],
      ));
    } else if (activity.category == ActivityCategory.competitions) {
      // Non-national competitions still count if high-value
      if (activity.tier == ActivityTier.tier1 || activity.tier == ActivityTier.tier2) {
        spikes.add(Spike(
          category: SpikeCategory.competitionWinner,
          description: 'Notable Competition: ${activity.title}',
          rarity: 3,
          impactScore: _clampScore(activity.tier.weight),
          sourceActivities: [activity],
        ));
      }
    }

    // ── Research Publication ──────────────────────────────────────────
    final isPublication = _SpikeKeywords.publicationKeywords
        .any((kw) => combined.contains(kw));

    if (isPublication &&
        (activity.category == ActivityCategory.research ||
         combined.contains('published'))) {
      spikes.add(Spike(
        category: SpikeCategory.researchPublication,
        description: 'Research Publication: ${activity.title}',
        rarity: 5,
        impactScore: _clampScore(activity.tier.weight + 30),
        sourceActivities: [activity],
      ));
    }

    // ── Founding / Leadership ─────────────────────────────────────────
    final isFounding = _SpikeKeywords.foundingKeywords
        .any((kw) => combined.contains(kw));

    if (isFounding &&
        (activity.category == ActivityCategory.leadership ||
         activity.category == ActivityCategory.clubs)) {
      spikes.add(Spike(
        category: SpikeCategory.leadership,
        description: 'Leadership / Founding: ${activity.title}',
        rarity: 4,
        impactScore: _clampScore(activity.tier.weight + 10),
        sourceActivities: [activity],
      ));
    }

    // ── Volunteering 500+ hours ──────────────────────────────────────
    if (activity.category == ActivityCategory.volunteering &&
        totalHours >= _SpikeKeywords.volunteerHoursThreshold) {
      final stars = totalHours >= 1000 ? 4 : 3;
      spikes.add(Spike(
        category: SpikeCategory.socialImpact,
        description:
            'Significant Volunteering: ${activity.title} ($totalHours hours)',
        rarity: stars,
        impactScore: _clampScore(50 + (totalHours ~/ 100)),
        sourceActivities: [activity],
      ));
    }

    // ── Perfect scores / awards ───────────────────────────────────────
    final hasPerfect = _SpikeKeywords.perfectScoreKeywords
        .any((kw) => combined.contains(kw));

    if (hasPerfect && activity.category == ActivityCategory.courses) {
      spikes.add(Spike(
        category: SpikeCategory.academicExcellence,
        description: 'Perfect Score / Top Performance: ${activity.title}',
        rarity: 4,
        impactScore: _clampScore(activity.tier.weight + 15),
        sourceActivities: [activity],
      ));
    }

    // ── Unique / unusual talent ───────────────────────────────────────
    if (activity.category == ActivityCategory.unique) {
      spikes.add(Spike(
        category: SpikeCategory.uniqueTalent,
        description: 'Unique Talent: ${activity.title}',
        rarity: activity.tier == ActivityTier.tier1 ? 4 : 3,
        impactScore: _clampScore(activity.tier.weight + 5),
        sourceActivities: [activity],
      ));
    }
  }

  // Deduplicate: if two spikes share the same category & description, merge
  spikes.sort((a, b) => b.impactScore.compareTo(a.impactScore));
  return _deduplicateSpikes(spikes);
}

/// Removes duplicate spikes (same category + same description) and merges
/// their source activities.
List<Spike> _deduplicateSpikes(List<Spike> spikes) {
  final Map<String, Spike> seen = {};
  for (final spike in spikes) {
    final key = '${spike.category.name}|${spike.description}';
    if (seen.containsKey(key)) {
      final existing = seen[key]!;
      seen[key] = Spike(
        category: existing.category,
        description: existing.description,
        rarity: existing.rarity,
        impactScore: existing.impactScore,
        sourceActivities: [
          ...existing.sourceActivities,
          ...spike.sourceActivities,
        ],
      );
    } else {
      seen[key] = spike;
    }
  }
  final result = seen.values.toList();
  result.sort((a, b) => b.impactScore.compareTo(a.impactScore));
  return result;
}

/// Clamps a score to 0–100.
int _clampScore(int score) => score.clamp(0, 100);
