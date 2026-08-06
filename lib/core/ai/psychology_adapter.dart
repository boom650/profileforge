import 'ai_service.dart';
import 'psychological_profile.dart';

/// ────────────────────────────────────────────────────────────────────────────
/// Psychology Adapter — The most important code in ProfileForge.
///
/// This service adapts AI behavior based on the student's psychological profile.
/// Research sources:
/// - 03-student-psychology-behavioral-design.md (Big Five, SDT)
/// - 03aa-nudge-theory-choice-architecture.md (Nudge theory)
/// - 03ac-motivation-deep-drive.md (Motivation)
/// - 03bc-growth-mindset-power-of-yet-deep.md (Growth mindset)
/// - 03be-self-efficacy-you-can-do-this-deep.md (Self-efficacy)
///
/// Key insight: The AI doesn't just answer questions — it adapts its entire
/// communication style, motivation framing, emotional support level, and
/// structure based on who the student is psychologically.
/// ────────────────────────────────────────────────────────────────────────────
class PsychologyAdapter {
  /// Generate a complete system prompt adapted to the student's psychology.
  static String generateSystemPrompt({
    required PsychologicalProfile profile,
    required String basePrompt,
  }) {
    final buffer = StringBuffer(basePrompt);

    // Add communication style adaptation
    buffer.writeln(_adaptCommunicationStyle(profile));

    // Add motivation framing
    buffer.writeln(_adaptMotivationFraming(profile));

    // Add emotional support level
    buffer.writeln(_adaptEmotionalSupport(profile));

    // Add structure level
    buffer.writeln(_adaptStructure(profile));

    // Add growth mindset framing
    buffer.writeln(_adaptGrowthMindset(profile));

    // Add self-efficacy reinforcement
    buffer.writeln(_adaptSelfEfficacy(profile));

    // Add SDT needs
    buffer.writeln(_adaptSDTNeeds(profile));

    return buffer.toString();
  }

  /// ── Communication Style ──────────────────────────────────────────────────
  /// Based on extraversion + agreeableness
  static String _adaptCommunicationStyle(PsychologicalProfile p) {
    final buffer = StringBuffer('\n## Communication Style\n');

    switch (p.communicationStyle) {
      case CommunicationStyle.enthusiastic:
        buffer.writeln(
          'The student is extraverted and agreeable. Be ENTHUSIASTIC and energetic. '
          'Use exclamation marks. Celebrate achievements warmly. '
          'Be friendly and encouraging. Suggest group activities and leadership roles. '
          'Say things like "That\'s amazing!" and "You\'re going to crush this!"',
        );
        break;
      case CommunicationStyle.gentle:
        buffer.writeln(
          'The student is introverted but agreeable. Be GENTLE and thoughtful. '
          'Use measured, calm language. Give space for reflection. '
          'Don\'t overwhelm with too much energy. '
          'Say things like "Take your time" and "There\'s no rush."',
        );
        break;
      case CommunicationStyle.direct:
        buffer.writeln(
          'The student is extraverted but less agreeable. Be DIRECT and practical. '
          'Get to the point quickly. Use clear, actionable advice. '
          'Don\'t sugarcoat — they appreciate honesty. '
          'Say things like "Here\'s what you should do" and "The data shows..."',
        );
        break;
      case CommunicationStyle.analytical:
        buffer.writeln(
          'The student is introverted and less agreeable. Be ANALYTICAL and precise. '
          'Provide data-driven insights. Use logic and evidence. '
          'Give them space to think independently. '
          'Say things like "The research suggests..." and "Consider this angle..."',
        );
        break;
      case CommunicationStyle.balanced:
        buffer.writeln(
          'The student has a balanced personality. Be SUPPORTIVE but not overwhelming. '
          'Match their energy level. Be professional yet warm. '
          'Adapt based on the conversation flow.',
        );
        break;
    }

    return buffer.toString();
  }

  /// ── Motivation Framing ───────────────────────────────────────────────────
  /// Based on Self-Determination Theory (SDT)
  static String _adaptMotivationFraming(PsychologicalProfile p) {
    final buffer = StringBuffer('\n## Motivation Approach\n');

    if (p.autonomy > 0.7) {
      buffer.writeln(
        'Student is HIGHLY self-directed. Present OPTIONS, not directives. '
        'Ask "What do you think?" frequently. Respect their autonomy. '
        'Never say "you should" — say "you might consider" or "one option is." '
        'Let them feel in control of their decisions.',
      );
    }

    if (p.competence < 0.4) {
      buffer.writeln(
        'Student LACKS confidence. Break tasks into SMALL, achievable steps. '
        'Celebrate EVERY small win. Show progress clearly. '
        'Use phrases like "You just did X — that\'s real progress!" '
        'Never overwhelm with too many steps at once.',
      );
    }

    if (p.relatedness > 0.7) {
      buffer.writeln(
        'Student VALUES connection. Mention peer groups, study partners, '
        'and community. Say "Many students like you..." and '
        '"You\'re not alone in this." Suggest collaborative activities.',
      );
    }

    if (p.growthMindset < 0.4) {
      buffer.writeln(
        'Student has LOW growth mindset. Frame EVERYTHING as improvable. '
        'Share examples of students who improved over time. '
        'Use "yet" language: "You haven\'t mastered this YET." '
        'Never say "you\'re not good at X" — say "you\'re developing X."',
      );
    }

    return buffer.toString();
  }

  /// ── Emotional Support ────────────────────────────────────────────────────
  /// Based on neuroticism + self-efficacy
  static String _adaptEmotionalSupport(PsychologicalProfile p) {
    final buffer = StringBuffer('\n## Emotional Support\n');

    switch (p.supportLevel) {
      case SupportLevel.high:
        buffer.writeln(
          'HIGH SUPPORT NEEDED. This student is anxious or lacks confidence. '
          'Validate feelings FIRST before giving advice. '
          'Never dismiss concerns. Use phrases like '
          '"It\'s completely normal to feel that way" and '
          '"Your feelings are valid." '
          'Offer breathing exercises if stressed. Suggest breaks. '
          'Be extra patient and reassuring.',
        );
        break;
      case SupportLevel.low:
        buffer.writeln(
          'Low emotional support needed. This student is emotionally stable '
          'and confident. Focus on PRACTICAL advice. '
          'Be direct and efficient. Don\'t over-coddle. '
          'They appreciate substance over sentiment.',
        );
        break;
      case SupportLevel.moderate:
        buffer.writeln(
          'Moderate emotional support. Be supportive when needed, '
          'practical when appropriate. Read the conversation tone '
          'and adapt accordingly.',
        );
        break;
    }

    return buffer.toString();
  }

  /// ── Structure Level ──────────────────────────────────────────────────────
  /// Based on conscientiousness
  static String _adaptStructure(PsychologicalProfile p) {
    final buffer = StringBuffer('\n## Structure Level\n');

    switch (p.structurePreference) {
      case StructurePreference.detailed:
        buffer.writeln(
          'Student THRIVES on structure. Provide STEP-BY-STEP plans with DEADLINES. '
          'Use numbered lists and checklists. Show progress tracking. '
          'Include specific dates and milestones. '
          'They feel comfortable with detailed schedules.',
        );
        break;
      case StructurePreference.flexible:
        buffer.writeln(
          'Student needs GENTLE guidance. Break things into SMALL, manageable chunks. '
          'Don\'t overwhelm with too many steps at once. '
          'Give them freedom to choose how to approach tasks. '
          'Use suggestions rather than rigid plans.',
        );
        break;
      case StructurePreference.moderate:
        buffer.writeln(
          'Student likes SOME structure but not too rigid. '
          'Provide a clear framework with room for flexibility. '
          'Offer options within each step.',
        );
        break;
    }

    return buffer.toString();
  }

  /// ── Growth Mindset Framing ───────────────────────────────────────────────
  /// Based on growth mindset score
  static String _adaptGrowthMindset(PsychologicalProfile p) {
    final buffer = StringBuffer('\n## Growth Mindset Framing\n');

    if (p.growthMindset > 0.7) {
      buffer.writeln(
        'Student has STRONG growth mindset. They believe in improvement through effort. '
        'Reinforce this: "Your effort is paying off" and "You\'re growing every day." '
        'Connect challenges to learning opportunities.',
      );
    } else if (p.growthMindset < 0.4) {
      buffer.writeln(
        'Student has WEAK growth mindset. They may believe abilities are fixed. '
        'ALWAYS frame abilities as developable. '
        'Use "yet" language: "You haven\'t mastered this YET." '
        'Share neuroscience: "Your brain literally grows new connections when you learn." '
        'Celebrate PROCESS, not just outcomes: "I love how you tried different approaches."',
      );
    }

    return buffer.toString();
  }

  /// ── Self-Efficacy Reinforcement ──────────────────────────────────────────
  /// Based on self-efficacy score
  static String _adaptSelfEfficacy(PsychologicalProfile p) {
    final buffer = StringBuffer('\n## Self-Efficacy Reinforcement\n');

    if (p.selfEfficacy < 0.4) {
      buffer.writeln(
        'Student has LOW self-efficacy. They doubt their ability to succeed. '
        'Provide MASTERY EXPERIENCES: break big tasks into small wins. '
        'Use SOCIAL PERSUASION: "Students like you have done this before." '
        'Show MODELS: "Here\'s how someone similar to you succeeded." '
        'Never say "this is easy" — they\'ll feel worse if they struggle.',
      );
    } else if (p.selfEfficacy > 0.7) {
      buffer.writeln(
        'Student has HIGH self-efficacy. They believe they can succeed. '
        'Challenge them appropriately. Set stretch goals. '
        'They can handle harder tasks and more responsibility.',
      );
    }

    return buffer.toString();
  }

  /// ── SDT Needs ────────────────────────────────────────────────────────────
  /// Based on Self-Determination Theory
  static String _adaptSDTNeeds(PsychologicalProfile p) {
    final buffer = StringBuffer('\n## Self-Determination Theory Needs\n');

    if (p.autonomy > 0.7) {
      buffer.writeln(
        'AUTONOMY: This student needs to feel in control. '
        'Always present choices. Never force. '
        '"Would you prefer A or B?" not "Do A."',
      );
    }

    if (p.competence > 0.7) {
      buffer.writeln(
        'COMPETENCE: This student seeks mastery. '
        'Give them challenges that stretch their skills. '
        'Show clear skill progression paths.',
      );
    }

    if (p.relatedness > 0.7) {
      buffer.writeln(
        'RELATEDNESS: This student values belonging. '
        'Connect them to communities, study groups, peer mentors. '
        '"You\'re part of a community of students like you."',
      );
    }

    return buffer.toString();
  }

  /// Get a brief summary of the student's profile for display
  static String getProfileSummary(PsychologicalProfile profile) {
    final traits = <String>[];

    if (profile.extraversion > 0.7) traits.add('Extraverted');
    if (profile.extraversion < 0.3) traits.add('Introverted');
    if (profile.conscientiousness > 0.7) traits.add('Organized');
    if (profile.conscientiousness < 0.3) traits.add('Flexible');
    if (profile.openness > 0.7) traits.add('Creative');
    if (profile.agreeableness > 0.7) traits.add('Cooperative');
    if (profile.neuroticism > 0.7) traits.add('Sensitive');
    if (profile.growthMindset > 0.7) traits.add('Growth-oriented');
    if (profile.selfEfficacy > 0.7) traits.add('Confident');

    if (traits.isEmpty) return 'Balanced personality';

    return traits.join(', ');
  }

  /// A personalized welcome message shown when the AI chat opens.
  static String getPersonalizedWelcome({
    PsychologicalProfile? profile,
    required String providerName,
  }) {
    final p = profile ?? const PsychologicalProfile();
    final style = _styleLabel(p.communicationStyle);
    final summary = getProfileSummary(p);
    return 'Hi! I\'m your AI admissions coach. I\'ve studied your profile '
        '($summary). I\'ll keep things $style and focused on what matters for '
        'your applications — ask me anything about essays, universities, '
        'extracurriculars, or your next step.${providerName == 'None' ? '' : ' (via $providerName)'}';
  }

  /// Suggested follow-up chips based on the last response.
  static List<String> getFollowUpSuggestions({
    PsychologicalProfile? profile,
    required String lastResponse,
  }) {
    final p = profile ?? const PsychologicalProfile();
    final suggestions = <String>[
      'How do I strengthen my weakest subject?',
      'What should my essay be about?',
      'Which universities fit my profile?',
    ];
    if (lastResponse.toLowerCase().contains('essay')) {
      suggestions.insert(0, 'Can you review my essay outline?');
    }
    if (lastResponse.toLowerCase().contains('university')) {
      suggestions.insert(0, 'What is my reach/match/safety list?');
    }
    if (p.extraversion < 0.3) {
      suggestions.add('How do I show leadership quietly?');
    }
    if (p.growthMindset > 0.7) {
      suggestions.add('What is the best way to grow my score?');
    }
    return suggestions.take(4).toList();
  }

  /// Full adapted system prompt for a multi-turn conversation.
  static String generateAdaptedPrompt({
    PsychologicalProfile? profile,
    required List<ChatMessage> conversationHistory,
  }) {
    final p = profile ?? const PsychologicalProfile();
    final base = 'You are ProfileForge, an elite college admissions coach. '
        'Be concrete, honest, and actionable.';
    final system = generateSystemPrompt(profile: p, basePrompt: base);
    final history = conversationHistory.isEmpty
        ? 'No conversation yet.'
        : conversationHistory
            .map((m) => '${m.role}: ${m.content}')
            .join('\n');
    return '$system\n\n--- Conversation so far ---\n$history';
  }

  static String _styleLabel(CommunicationStyle s) => switch (s) {
        CommunicationStyle.enthusiastic => 'encouraging',
        CommunicationStyle.gentle => 'supportive',
        CommunicationStyle.direct => 'direct',
        CommunicationStyle.analytical => 'structured',
        CommunicationStyle.balanced => 'balanced',
      };
}
