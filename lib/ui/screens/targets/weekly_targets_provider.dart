import 'dart:convert';
import '../api_config.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'weekly_targets_model.dart';
import 'package:flutter/foundation.dart';

// ─── State ──────────────────────────────────────────────────────────────────

class WeeklyTargetsState {
  final List<WeeklyTarget> targets;
  final bool loading;
  final String? error;
  final int weekNumber;
  final int year;

  const WeeklyTargetsState({
    this.targets = const [],
    this.loading = false,
    this.error,
    this.weekNumber = 0,
    this.year = 0,
  });

  WeeklyTargetsState copyWith({
    List<WeeklyTarget>? targets,
    bool? loading,
    String? error,
    int? weekNumber,
    int? year,
  }) {
    return WeeklyTargetsState(
      targets: targets ?? this.targets,
      loading: loading ?? this.loading,
      error: error,
      weekNumber: weekNumber ?? this.weekNumber,
      year: year ?? this.year,
    );
  }

  int get completedCount => targets.where((t) => t.isCompleted).length;
  int get totalCount => targets.length;
  int get totalXpAvailable => targets.fold(0, (sum, t) => sum + t.xpReward);
  int get totalXpEarned => targets.where((t) => t.isCompleted).fold(0, (sum, t) => sum + t.xpReward);
  double get completionPct => totalCount > 0 ? completedCount / totalCount : 0;
}

// ─── Notifier ───────────────────────────────────────────────────────────────

final String apiBase = kApiBaseUrl;

class WeeklyTargetsNotifier extends StateNotifier<WeeklyTargetsState> {
  WeeklyTargetsNotifier() : super(const WeeklyTargetsState()) {
    _initCurrentWeek();
  }

  void _initCurrentWeek() {
    final now = DateTime.now();
    final jan1 = DateTime(now.year, 1, 1);
    final days = now.difference(jan1).inDays;
    final weekNum = ((days + jan1.weekday - 1) ~/ 7) + 1;
    state = state.copyWith(weekNumber: weekNum, year: now.year);
  }

  Future<void> fetchTargets(String userId) async {
    state = state.copyWith(loading: true, error: null);
    try {
      final response = await http.get(
        Uri.parse('$apiBase/api/weekly-targets?user_id=$userId'
            '&week_number=${state.weekNumber}&year=${state.year}'),
      );
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        final targets = data.map((j) => WeeklyTarget.fromJson(j)).toList();
        state = state.copyWith(targets: targets, loading: false);
      } else {
        state = state.copyWith(
          loading: false,
          error: 'Failed to load targets (${response.statusCode})',
        );
      }
    } catch (e) {
      state = state.copyWith(loading: false, error: 'Network error: $e');
    }
  }

  void previousWeek() {
    int newWeek = state.weekNumber - 1;
    int newYear = state.year;
    if (newWeek < 1) {
      newWeek = 52;
      newYear--;
    }
    state = state.copyWith(weekNumber: newWeek, year: newYear);
  }

  void nextWeek() {
    int newWeek = state.weekNumber + 1;
    int newYear = state.year;
    if (newWeek > 52) {
      newWeek = 1;
      newYear++;
    }
    state = state.copyWith(weekNumber: newWeek, year: newYear);
  }

  Future<void> toggleStatus(WeeklyTarget target) async {
    final newStatus = target.isCompleted ? 'pending' : 'completed';
    try {
      final response = await http.patch(
        Uri.parse('$apiBase/api/weekly-targets/${target.id}/status'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'status': newStatus}),
      );
      if (response.statusCode == 200) {
        final updated = WeeklyTarget.fromJson(jsonDecode(response.body));
        final updatedList = state.targets.map((t) => t.id == updated.id ? updated : t).toList();
        state = state.copyWith(targets: updatedList);
      }
    } catch (e) { debugPrint('Error: $e'); }
  }

  Future<void> createTarget({
    required String userId,
    required String title,
    required String description,
    required String category,
    required String milestoneType,
    String? dueDate,
    bool generateMilestones = false,
    String? paperTitle,
  }) async {
    try {
      final body = {
        'user_id': userId,
        'title': title,
        'description': description,
        'category': category,
        'milestone_type': milestoneType,
        'due_date': dueDate,
        'week_number': state.weekNumber,
        'year': state.year,
        'generate_research_milestones': generateMilestones,
      };
      if (paperTitle != null) body['paper_title'] = paperTitle;

      final response = await http.post(
        Uri.parse('$apiBase/api/weekly-targets'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        final newTarget = WeeklyTarget.fromJson(jsonDecode(response.body));
        state = state.copyWith(targets: [...state.targets, newTarget]);
      }
    } catch (e) { debugPrint('Error: $e'); }
  }
}

final weeklyTargetsProvider =
    StateNotifierProvider<WeeklyTargetsNotifier, WeeklyTargetsState>((ref) {
  return WeeklyTargetsNotifier();
});
