/// Profile-related providers: student profile state and spike analysis.
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/student_profile.dart';
import '../services/spike_framework.dart';

// ═══════════════════════════════════════════════════════════════════════════
// STUDENT PROFILE STATE
// ═══════════════════════════════════════════════════════════════════════════

final studentProfileProvider =
    StateNotifierProvider<StudentProfileNotifier, StudentProfile?>((ref) {
  return StudentProfileNotifier();
});

class StudentProfileNotifier extends StateNotifier<StudentProfile?> {
  StudentProfileNotifier() : super(null);

  void setProfile(StudentProfile profile) {
    state = profile;
  }

  void updateProfile(StudentProfile Function(StudentProfile) updater) {
    if (state != null) {
      state = updater(state!);
    }
  }

  void clearProfile() {
    state = null;
  }
}

// ═══════════════════════════════════════════════════════════════════════════
// SPIKE FRAMEWORK
// ═══════════════════════════════════════════════════════════════════════════

/// Analyzes the student's activities and returns detected spikes.
final spikesProvider = Provider<List<Spike>>((ref) {
  final profile = ref.watch(studentProfileProvider);
  if (profile == null || profile.activities.isEmpty) return [];
  return analyzeSpikes(profile.activities);
});

/// Returns the top N spikes sorted by impact score.
final topSpikesProvider = Provider.family<List<Spike>, int>((ref, count) {
  final spikes = ref.watch(spikesProvider);
  return spikes.take(count).toList();
});
