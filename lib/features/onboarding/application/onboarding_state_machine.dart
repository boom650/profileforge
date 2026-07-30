import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// ────────────────────────────────────────────────────────────────────────────
/// OnboardingState — Real state machine for the onboarding flow.
/// Tracks: current step, completed steps, form data, validation, timestamps.
/// Persists to SharedPreferences (survives app restarts).
/// ────────────────────────────────────────────────────────────────────────────

/// The 5 onboarding steps.
enum OnboardingStep {
  goal,       // What are you aiming for?
  school,     // Target universities.
  profile,    // Who are you? (name, grade, subjects)
  schedule,   // Your schedule + energy patterns.
  launch,     // Summary + confirmation.
}

/// Complete onboarding form data.
class OnboardingData {
  final String goal;                   // 'ivy', 'top50', 'top100', 'scholarship'
  final List<String> targetUnis;       // ['Harvard', 'MIT', ...]
  final String firstName;
  final String gradeLevel;             // '9', '10', '11', '12'
  final List<String> subjects;         // ['Math HL', 'Physics', ...]
  final String learningStyle;          // 'visual', 'reading', 'hands-on', 'mixed'
  final String timezone;               // 'America/New_York', etc.
  final Map<String, double> energyPattern; // {'morning': 0.8, 'afternoon': 0.6, ...}
  final String sleepQuality;           // 'deep', 'light', 'irregular'
  final int sessionsPerDay;            // 1-6
  final int hoursPerSession;           // 1-4
  final String weeklyGoal;             // '10', '20', '30', '40' hours
  final List<String> competitionTypes; // ['olympiad', 'debate', 'research', ...]
  final DateTime createdAt;
  final DateTime updatedAt;

  const OnboardingData({
    this.goal = '',
    this.targetUnis = const [],
    this.firstName = '',
    this.gradeLevel = '',
    this.subjects = const [],
    this.learningStyle = '',
    this.timezone = '',
    this.energyPattern = const {},
    this.sleepQuality = '',
    this.sessionsPerDay = 3,
    this.hoursPerSession = 2,
    this.weeklyGoal = '20',
    this.competitionTypes = const [],
    required this.createdAt,
    required this.updatedAt,
  });

  /// Score how complete this onboarding data is (0.0 to 1.0).
  double get completeness {
    int filled = 0;
    int total = 10;

    if (goal.isNotEmpty) filled++;
    if (targetUnis.isNotEmpty) filled++;
    if (firstName.isNotEmpty) filled++;
    if (gradeLevel.isNotEmpty) filled++;
    if (subjects.isNotEmpty) filled++;
    if (learningStyle.isNotEmpty) filled++;
    if (energyPattern.isNotEmpty) filled++;
    if (sleepQuality.isNotEmpty) filled++;
    if (weeklyGoal.isNotEmpty) filled++;
    if (competitionTypes.isNotEmpty) filled++;

    return filled / total;
  }

  /// Generate a readiness score based on onboarding data quality.
  int get readinessScore {
    int score = 0;
    score += goal.isNotEmpty ? 15 : 0;
    score += targetUnis.length >= 2 ? 20 : targetUnis.length * 10;
    score += firstName.isNotEmpty ? 10 : 0;
    score += gradeLevel.isNotEmpty ? 10 : 0;
    score += subjects.length >= 3 ? 15 : subjects.length * 5;
    score += learningStyle.isNotEmpty ? 10 : 0;
    score += energyPattern.isNotEmpty ? 10 : 0;
    score += competitionTypes.isNotEmpty ? 10 : 0;
    return score.clamp(0, 100);
  }

  /// Copy with.
  OnboardingData copyWith({
    String? goal,
    List<String>? targetUnis,
    String? firstName,
    String? gradeLevel,
    List<String>? subjects,
    String? learningStyle,
    String? timezone,
    Map<String, double>? energyPattern,
    String? sleepQuality,
    int? sessionsPerDay,
    int? hoursPerSession,
    String? weeklyGoal,
    List<String>? competitionTypes,
  }) {
    return OnboardingData(
      goal: goal ?? this.goal,
      targetUnis: targetUnis ?? this.targetUnis,
      firstName: firstName ?? this.firstName,
      gradeLevel: gradeLevel ?? this.gradeLevel,
      subjects: subjects ?? this.subjects,
      learningStyle: learningStyle ?? this.learningStyle,
      timezone: timezone ?? this.timezone,
      energyPattern: energyPattern ?? this.energyPattern,
      sleepQuality: sleepQuality ?? this.sleepQuality,
      sessionsPerDay: sessionsPerDay ?? this.sessionsPerDay,
      hoursPerSession: hoursPerSession ?? this.hoursPerSession,
      weeklyGoal: weeklyGoal ?? this.weeklyGoal,
      competitionTypes: competitionTypes ?? this.competitionTypes,
      createdAt: createdAt,
      updatedAt: DateTime.now(),
    );
  }

  /// Serialize to JSON.
  Map<String, dynamic> toJson() => {
    'goal': goal,
    'targetUnis': targetUnis,
    'firstName': firstName,
    'gradeLevel': gradeLevel,
    'subjects': subjects,
    'learningStyle': learningStyle,
    'timezone': timezone,
    'energyPattern': energyPattern,
    'sleepQuality': sleepQuality,
    'sessionsPerDay': sessionsPerDay,
    'hoursPerSession': hoursPerSession,
    'weeklyGoal': weeklyGoal,
    'competitionTypes': competitionTypes,
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
  };

  /// Deserialize from JSON.
  factory OnboardingData.fromJson(Map<String, dynamic> json) {
    return OnboardingData(
      goal: json['goal'] as String? ?? '',
      targetUnis: List<String>.from(json['targetUnis'] as List? ?? []),
      firstName: json['firstName'] as String? ?? '',
      gradeLevel: json['gradeLevel'] as String? ?? '',
      subjects: List<String>.from(json['subjects'] as List? ?? []),
      learningStyle: json['learningStyle'] as String? ?? '',
      timezone: json['timezone'] as String? ?? '',
      energyPattern: Map<String, double>.from(
        (json['energyPattern'] as Map<String, dynamic>?)?.map(
              (k, v) => MapEntry(k, (v as num).toDouble()),
            ) ??
            {},
      ),
      sleepQuality: json['sleepQuality'] as String? ?? '',
      sessionsPerDay: json['sessionsPerDay'] as int? ?? 3,
      hoursPerSession: json['hoursPerSession'] as int? ?? 2,
      weeklyGoal: json['weeklyGoal'] as String? ?? '20',
      competitionTypes: List<String>.from(json['competitionTypes'] as List? ?? []),
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'] as String)
          : DateTime.now(),
    );
  }

  /// Empty state.
  factory OnboardingData.empty() => OnboardingData(
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
  );

  /// Serialize to string.
  String toJsonString() => jsonEncode(toJson());

  /// Deserialize from string.
  factory OnboardingData.fromJsonString(String s) =>
      OnboardingData.fromJson(jsonDecode(s) as Map<String, dynamic>);
}

/// ────────────────────────────────────────────────────────────────────────────
/// OnboardingState — Current state of the onboarding flow.
/// ────────────────────────────────────────────────────────────────────────────
class OnboardingState {
  final OnboardingStep currentStep;
  final OnboardingData data;
  final Set<OnboardingStep> completedSteps;
  final bool isSubmitting;
  final String? error;

  OnboardingState({
    this.currentStep = OnboardingStep.goal,
    OnboardingData? data,
    this.completedSteps = const {},
    this.isSubmitting = false,
    this.error,
  }) : data = data ?? OnboardingData(
    createdAt: DateTime(2024),
    updatedAt: DateTime(2024),
  );

  /// Whether the current step is valid.
  bool get isCurrentStepValid {
    switch (currentStep) {
      case OnboardingStep.goal:
        return data.goal.isNotEmpty;
      case OnboardingStep.school:
        return data.targetUnis.isNotEmpty;
      case OnboardingStep.profile:
        return data.firstName.isNotEmpty && data.gradeLevel.isNotEmpty;
      case OnboardingStep.schedule:
        return data.energyPattern.isNotEmpty;
      case OnboardingStep.launch:
        return true;
    }
  }

  /// Whether all steps are complete.
  bool get isComplete => completedSteps.length >= OnboardingStep.values.length;

  /// Step index (0-based).
  int get stepIndex => currentStep.index;

  /// Total steps.
  int get totalSteps => OnboardingStep.values.length;

  /// Progress (0.0 to 1.0).
  double get progress => completedSteps.length / totalSteps;

  /// Copy with.
  OnboardingState copyWith({
    OnboardingStep? currentStep,
    OnboardingData? data,
    Set<OnboardingStep>? completedSteps,
    bool? isSubmitting,
    String? error,
  }) {
    return OnboardingState(
      currentStep: currentStep ?? this.currentStep,
      data: data ?? this.data,
      completedSteps: completedSteps ?? this.completedSteps,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      error: error,
    );
  }
}

/// ────────────────────────────────────────────────────────────────────────────
/// OnboardingNotifier — State machine controller.
/// ────────────────────────────────────────────────────────────────────────────
class OnboardingNotifier extends StateNotifier<OnboardingState> {
  OnboardingNotifier() : super(OnboardingState()) {
    _loadFromStorage();
  }

  /// Load persisted state from SharedPreferences.
  Future<void> _loadFromStorage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final dataJson = prefs.getString('pf_onboarding_data');
      final currentStepIndex = prefs.getInt('pf_onboarding_step') ?? 0;
      final completedJson = prefs.getString('pf_onboarding_completed');

      if (dataJson != null) {
        final data = OnboardingData.fromJsonString(dataJson);
        final completed = completedJson != null
            ? Set<int>.from(jsonDecode(completedJson) as List)
                .map((i) => OnboardingStep.values[i])
                .toSet()
            : <OnboardingStep>{};

        state = OnboardingState(
          currentStep: OnboardingStep.values[currentStepIndex.clamp(0, OnboardingStep.values.length - 1)],
          data: data,
          completedSteps: completed,
        );
      }
    } catch (_) {
      // Ignore — start fresh.
    }
  }

  /// Persist current state.
  Future<void> _saveToStorage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('pf_onboarding_data', state.data.toJsonString());
      await prefs.setInt('pf_onboarding_step', state.stepIndex);
      await prefs.setString('pf_onboarding_completed',
          jsonEncode(state.completedSteps.map((s) => s.index).toList()));
      await prefs.setBool('pf_onboarded', state.isComplete);
    } catch (_) {
      // Ignore — non-critical.
    }
  }

  /// Update data for current step.
  void updateData(OnboardingData Function(OnboardingData) updater) {
    state = state.copyWith(data: updater(state.data));
    _saveToStorage();
  }

  /// Go to next step.
  bool nextStep() {
    if (!state.isCurrentStepValid) return false;

    final completed = {...state.completedSteps, state.currentStep};
    final nextIndex = state.stepIndex + 1;

    if (nextIndex >= OnboardingStep.values.length) {
      // All steps done.
      state = state.copyWith(
        completedSteps: completed,
        isSubmitting: true,
      );
      _completeOnboarding();
      return true;
    }

    state = state.copyWith(
      currentStep: OnboardingStep.values[nextIndex],
      completedSteps: completed,
    );
    _saveToStorage();
    return true;
  }

  /// Go to previous step.
  void previousStep() {
    if (state.stepIndex > 0) {
      state = state.copyWith(
        currentStep: OnboardingStep.values[state.stepIndex - 1],
      );
    }
  }

  /// Jump to a specific step.
  void goToStep(OnboardingStep step) {
    state = state.copyWith(currentStep: step);
  }

  /// Complete onboarding — mark as done, persist final data.
  Future<void> _completeOnboarding() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('pf_onboarded', true);
      await prefs.setString('pf_onboarding_data', state.data.toJsonString());
      await prefs.setString('pf_first_name', state.data.firstName);

      state = state.copyWith(isSubmitting: false);
    } catch (e) {
      state = state.copyWith(
        isSubmitting: false,
        error: 'Failed to save: $e',
      );
    }
  }

  /// Reset onboarding (for testing).
  Future<void> reset() async {
    state = OnboardingState();
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('pf_onboarding_data');
      await prefs.remove('pf_onboarding_step');
      await prefs.remove('pf_onboarding_completed');
      await prefs.setBool('pf_onboarded', false);
    } catch (_) {}
  }
}

/// Provider for the onboarding state machine.
final onboardingStateMachineProvider =
    StateNotifierProvider<OnboardingNotifier, OnboardingState>((ref) {
  return OnboardingNotifier();
});

/// Convenience: is onboarding complete?
final isOnboardingCompleteProvider = Provider<bool>((ref) {
  return ref.watch(onboardingStateMachineProvider).isComplete;
});
