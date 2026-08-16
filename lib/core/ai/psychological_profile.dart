/// ────────────────────────────────────────────────────────────────────────────
/// Psychological Profile — The core data model that drives AI adaptation.
/// Based on Big Five (OCEAN), Self-Determination Theory (SDT), and
/// Growth Mindset research from 409 research documents.
///
/// Key insight from knowledge graph: Self-Efficacy (16 edges), SDT (11 edges),
/// and Growth Mindset (11 edges) are the most connected concepts.
/// This model captures all three.
/// ────────────────────────────────────────────────────────────────────────────
class PsychologicalProfile {
  /// Big Five Personality Traits (OCEAN model)
  /// Each value: 0.0 (low) to 1.0 (high)
  final double openness;        // Creativity, curiosity, novelty-seeking
  final double conscientiousness; // Organization, dependability, self-discipline
  final double extraversion;    // Social energy, assertiveness, positive emotions
  final double agreeableness;   // Cooperation, trust, empathy
  final double neuroticism;     // Emotional instability, anxiety, moodiness

  /// Self-Determination Theory (SDT) — Intrinsic Motivation
  /// Research: 03ba-self-determination-autonomy-framework.md
  final double autonomy;        // Self-directed, independent decision-making
  final double competence;      // Task confidence, mastery orientation
  final double relatedness;     // Social connection, belonging need

  /// Growth Mindset & Self-Efficacy
  /// Research: 03bc-growth-mindset-power-of-yet-deep.md
  /// Research: 03be-self-efficacy-you-can-do-this-deep.md
  final double growthMindset;   // Belief in improvement through effort
  final double selfEfficacy;    // Task-specific confidence

  /// Emotional Intelligence
  /// Research: 03av-emotional-intelligence-eq-matters.md
  final double emotionalIntelligence; // Self-awareness, empathy, regulation

  /// Communication Style Preferences (derived from personality)
  final CommunicationStyle communicationStyle;
  final MotivationFrame motivationFrame;
  final SupportLevel supportLevel;
  final StructurePreference structurePreference;

  const PsychologicalProfile({
    this.openness = 0.5,
    this.conscientiousness = 0.5,
    this.extraversion = 0.5,
    this.agreeableness = 0.5,
    this.neuroticism = 0.5,
    this.autonomy = 0.5,
    this.competence = 0.5,
    this.relatedness = 0.5,
    this.growthMindset = 0.5,
    this.selfEfficacy = 0.5,
    this.emotionalIntelligence = 0.5,
    this.communicationStyle = CommunicationStyle.balanced,
    this.motivationFrame = MotivationFrame.balanced,
    this.supportLevel = SupportLevel.moderate,
    this.structurePreference = StructurePreference.moderate,
  });

  /// Classify personality into communication preferences
  factory PsychologicalProfile.classify({
    required double openness,
    required double conscientiousness,
    required double extraversion,
    required double agreeableness,
    required double neuroticism,
    required double autonomy,
    required double competence,
    required double relatedness,
    required double growthMindset,
    required double selfEfficacy,
    double emotionalIntelligence = 0.5,
  }) {
    // Derive communication style from extraversion + agreeableness
    final communicationStyle = _classifyCommunication(extraversion, agreeableness);
    
    // Derive motivation frame from SDT traits
    final motivationFrame = _classifyMotivation(autonomy, competence, relatedness);
    
    // Derive support level from neuroticism + self-efficacy
    final supportLevel = _classifySupport(neuroticism, selfEfficacy);
    
    // Derive structure preference from conscientiousness
    final structurePreference = _classifyStructure(conscientiousness);

    return PsychologicalProfile(
      openness: openness,
      conscientiousness: conscientiousness,
      extraversion: extraversion,
      agreeableness: agreeableness,
      neuroticism: neuroticism,
      autonomy: autonomy,
      competence: competence,
      relatedness: relatedness,
      growthMindset: growthMindset,
      selfEfficacy: selfEfficacy,
      emotionalIntelligence: emotionalIntelligence,
      communicationStyle: communicationStyle,
      motivationFrame: motivationFrame,
      supportLevel: supportLevel,
      structurePreference: structurePreference,
    );
  }

  static CommunicationStyle _classifyCommunication(double extra, double agreeable) {
    if (extra > 0.7 && agreeable > 0.6) return CommunicationStyle.enthusiastic;
    if (extra < 0.3 && agreeable > 0.6) return CommunicationStyle.gentle;
    if (extra > 0.7 && agreeable < 0.4) return CommunicationStyle.direct;
    if (extra < 0.3 && agreeable < 0.4) return CommunicationStyle.analytical;
    return CommunicationStyle.balanced;
  }

  static MotivationFrame _classifyMotivation(double auto, double comp, double relate) {
    if (auto > 0.7) return MotivationFrame.autonomy;
    if (comp < 0.4) return MotivationFrame.mastery;
    if (relate > 0.7) return MotivationFrame.social;
    return MotivationFrame.balanced;
  }

  static SupportLevel _classifySupport(double neuro, double selfEff) {
    if (neuro > 0.7 || selfEff < 0.3) return SupportLevel.high;
    if (neuro < 0.3 && selfEff > 0.6) return SupportLevel.low;
    return SupportLevel.moderate;
  }

  static StructurePreference _classifyStructure(double consc) {
    if (consc > 0.7) return StructurePreference.detailed;
    if (consc < 0.3) return StructurePreference.flexible;
    return StructurePreference.moderate;
  }

  /// Create from onboarding responses
  factory PsychologicalProfile.fromOnboardingAnswers({
    required List<String> funActivities,
    required String workPreference,
    required String stressResponse,
    required String planningStyle,
  }) {
    // Map fun activities to Big Five
    double openness = 0.5;
    double extraversion = 0.5;
    
    for (final activity in funActivities) {
      final lower = activity.toLowerCase();
      if (lower.contains('art') || lower.contains('music') || lower.contains('write') || lower.contains('creative')) {
        openness += 0.15;
      }
      if (lower.contains('sport') || lower.contains('team') || lower.contains('social') || lower.contains('party')) {
        extraversion += 0.15;
      }
      if (lower.contains('read') || lower.contains('study') || lower.contains('code')) {
        openness += 0.1;
      }
    }
    openness = openness.clamp(0.0, 1.0);
    extraversion = extraversion.clamp(0.0, 1.0);

    // Map work preference
    double conscientiousness = 0.5;
    double agreeableness = 0.5;
    
    if (workPreference.toLowerCase().contains('alone')) {
      extraversion = (extraversion - 0.1).clamp(0.0, 1.0);
    } else if (workPreference.toLowerCase().contains('team') || workPreference.toLowerCase().contains('group')) {
      agreeableness += 0.15;
      extraversion += 0.1;
    }
    
    // Map stress response
    double neuroticism = 0.5;
    double selfEfficacy = 0.5;
    double growthMindset = 0.5;
    
    if (stressResponse.toLowerCase().contains('breathe') || stressResponse.toLowerCase().contains('calm')) {
      neuroticism = (neuroticism - 0.15).clamp(0.0, 1.0);
    } else if (stressResponse.toLowerCase().contains('worry') || stressResponse.toLowerCase().contains('panic')) {
      neuroticism += 0.2;
    }
    
    if (stressResponse.toLowerCase().contains('solve') || stressResponse.toLowerCase().contains('plan')) {
      selfEfficacy += 0.15;
      conscientiousness += 0.1;
    }

    // Map planning style
    if (planningStyle.toLowerCase().contains('plan') || planningStyle.toLowerCase().contains('list') || planningStyle.toLowerCase().contains('schedule')) {
      conscientiousness += 0.2;
    } else if (planningStyle.toLowerCase().contains('spontaneous') || planningStyle.toLowerCase().contains('wing')) {
      conscientiousness = (conscientiousness - 0.1).clamp(0.0, 1.0);
    }

    conscientiousness = conscientiousness.clamp(0.0, 1.0);
    agreeableness = agreeableness.clamp(0.0, 1.0);
    neuroticism = neuroticism.clamp(0.0, 1.0);
    selfEfficacy = selfEfficacy.clamp(0.0, 1.0);
    growthMindset = growthMindset.clamp(0.0, 1.0);

    return PsychologicalProfile.classify(
      openness: openness,
      conscientiousness: conscientiousness,
      extraversion: extraversion,
      agreeableness: agreeableness,
      neuroticism: neuroticism,
      autonomy: 0.5, // Will be refined through chat
      competence: selfEfficacy,
      relatedness: agreeableness,
      growthMindset: growthMindset,
      selfEfficacy: selfEfficacy,
    );
  }

  PsychologicalProfile copyWith({
    double? openness,
    double? conscientiousness,
    double? extraversion,
    double? agreeableness,
    double? neuroticism,
    double? autonomy,
    double? competence,
    double? relatedness,
    double? growthMindset,
    double? selfEfficacy,
    double? emotionalIntelligence,
  }) {
    return PsychologicalProfile(
      openness: openness ?? this.openness,
      conscientiousness: conscientiousness ?? this.conscientiousness,
      extraversion: extraversion ?? this.extraversion,
      agreeableness: agreeableness ?? this.agreeableness,
      neuroticism: neuroticism ?? this.neuroticism,
      autonomy: autonomy ?? this.autonomy,
      competence: competence ?? this.competence,
      relatedness: relatedness ?? this.relatedness,
      growthMindset: growthMindset ?? this.growthMindset,
      selfEfficacy: selfEfficacy ?? this.selfEfficacy,
      emotionalIntelligence: emotionalIntelligence ?? this.emotionalIntelligence,
    );
  }

  Map<String, dynamic> toJson() => {
    'openness': openness,
    'conscientiousness': conscientiousness,
    'extraversion': extraversion,
    'agreeableness': agreeableness,
    'neuroticism': neuroticism,
    'autonomy': autonomy,
    'competence': competence,
    'relatedness': relatedness,
    'growthMindset': growthMindset,
    'selfEfficacy': selfEfficacy,
    'emotionalIntelligence': emotionalIntelligence,
  };

  factory PsychologicalProfile.fromJson(Map<String, dynamic> json) {
    return PsychologicalProfile(
      openness: (json['openness'] as num?)?.toDouble() ?? 0.5,
      conscientiousness: (json['conscientiousness'] as num?)?.toDouble() ?? 0.5,
      extraversion: (json['extraversion'] as num?)?.toDouble() ?? 0.5,
      agreeableness: (json['agreeableness'] as num?)?.toDouble() ?? 0.5,
      neuroticism: (json['neuroticism'] as num?)?.toDouble() ?? 0.5,
      autonomy: (json['autonomy'] as num?)?.toDouble() ?? 0.5,
      competence: (json['competence'] as num?)?.toDouble() ?? 0.5,
      relatedness: (json['relatedness'] as num?)?.toDouble() ?? 0.5,
      growthMindset: (json['growthMindset'] as num?)?.toDouble() ?? 0.5,
      selfEfficacy: (json['selfEfficacy'] as num?)?.toDouble() ?? 0.5,
      emotionalIntelligence: (json['emotionalIntelligence'] as num?)?.toDouble() ?? 0.5,
    );
  }

  /// Get radar chart data for personality visualization
  List<double> get radarData => [
    openness,
    conscientiousness,
    extraversion,
    agreeableness,
    1.0 - neuroticism, // Invert for display (lower neuroticism = better)
  ];

  List<String> get radarLabels => [
    'Openness',
    'Conscientiousness',
    'Extraversion',
    'Agreeableness',
    'Emotional Stability',
  ];
}

/// Communication style derived from personality
enum CommunicationStyle {
  enthusiastic,  // High extraversion + high agreeableness
  gentle,        // Low extraversion + high agreeableness
  direct,        // High extraversion + low agreeableness
  analytical,    // Low extraversion + low agreeableness
  balanced,      // Middle ground
}

/// Motivation frame derived from SDT
enum MotivationFrame {
  autonomy,    // Self-directed (high autonomy)
  mastery,     // Skill-focused (low competence)
  social,      // Connection-focused (high relatedness)
  balanced,    // Mix of all
}

/// Support level derived from neuroticism + self-efficacy
enum SupportLevel {
  high,      // Needs extra reassurance
  moderate,  // Standard support
  low,       // Direct, practical advice
}

/// Structure preference derived from conscientiousness
enum StructurePreference {
  detailed,  // Step-by-step with deadlines
  moderate,  // Balanced structure
  flexible,  // Gentle guidance, small chunks
}
