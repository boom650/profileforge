import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/ai/ai_providers.dart';
import '../../../core/ai/artifact_prompts.dart';

/// Artifact types the analyzer supports
enum ArtifactType {
  research('Research Paper', Icons.science),
  essay('Personal Essay', Icons.article),
  activity('Activity Description', Icons.emoji_events),
  project('Project Portfolio', Icons.code),
  recommendation('Recommendation Letter', Icons.person);

  const ArtifactType(this.label, this.icon);
  final String label;
  final IconData icon;
}

/// Artifact analyzer state
class ArtifactAnalyzerState {
  const ArtifactAnalyzerState({
    this.analysis,
    this.isLoading = false,
    this.error,
    this.selectedType = ArtifactType.research,
  });

  final ArtifactAnalysis? analysis;
  final bool isLoading;
  final String? error;
  final ArtifactType selectedType;

  ArtifactAnalyzerState copyWith({
    ArtifactAnalysis? analysis,
    bool? isLoading,
    String? error,
    ArtifactType? selectedType,
  }) {
    return ArtifactAnalyzerState(
      analysis: analysis ?? this.analysis,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      selectedType: selectedType ?? this.selectedType,
    );
  }
}

/// Artifact analyzer notifier
class ArtifactAnalyzerNotifier extends StateNotifier<ArtifactAnalyzerState> {
  ArtifactAnalyzerNotifier(this._ref) : super(const ArtifactAnalyzerState());

  final Ref _ref;

  void setType(ArtifactType type) {
    state = state.copyWith(selectedType: type);
  }

  Future<void> analyze({
    required String title,
    required String content,
    String? targetUniversity,
    Map<String, dynamic>? studentProfile,
  }) async {
    state = state.copyWith(isLoading: true, error: null, analysis: null);

    try {
      final service = AiService.instance;
      final response = await service.generate(_buildPrompt(
        type: state.selectedType,
        title: title,
        content: content,
        targetUniversity: targetUniversity,
        studentProfile: studentProfile,
      ));

      // Parse analysis from response
      int? score;
      final scoreMatch = RegExp(
        r'(?:Overall Score|Score)[:\s]*(\d+)/10',
        caseSensitive: false,
      ).firstMatch(response);
      if (scoreMatch != null) {
        score = int.tryParse(scoreMatch.group(1) ?? '');
      }

      final analysis = ArtifactAnalysis(
        artifactType: state.selectedType.label,
        rawResponse: response,
        score: score,
        analyzedAt: DateTime.now(),
      );

      state = state.copyWith(isLoading: false, analysis: analysis);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: 'Analysis failed: $e');
    }
  }

  String _buildPrompt({
    required ArtifactType type,
    required String title,
    required String content,
    String? targetUniversity,
    Map<String, dynamic>? studentProfile,
  }) {
    switch (type) {
      case ArtifactType.research:
        return ArtifactPrompts.researchPaper(
          title: title,
          description: content,
          targetUniversity: targetUniversity,
        );
      case ArtifactType.essay:
        return ArtifactPrompts.personalEssay(
          essayText: content,
          prompt: title,
          targetUniversity: targetUniversity,
        );
      case ArtifactType.activity:
        return ArtifactPrompts.activities(
          activities: [{'name': title, 'description': content}],
          targetUniversity: targetUniversity,
        );
      case ArtifactType.project:
        return 'Analyze this project for college admissions:\n\nTitle: $title\n\nDescription: $content\n\nEvaluate technical depth, creativity, impact, and presentation quality.';
      case ArtifactType.recommendation:
        return 'Evaluate this recommendation letter content:\n\n$title\n\n$content\n\nAssess specificity, character evidence, comparison to peers, and overall strength.';
    }
  }

  void reset() {
    state = const ArtifactAnalyzerState();
  }
}

final artifactAnalyzerProvider =
    StateNotifierProvider<ArtifactAnalyzerNotifier, ArtifactAnalyzerState>((ref) {
  return ArtifactAnalyzerNotifier(ref);
});
