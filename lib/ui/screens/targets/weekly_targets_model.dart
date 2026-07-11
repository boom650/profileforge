import 'package:flutter/material.dart';

// ─── Models ──────────────────────────────────────────────────────────────────

class WeeklyTarget {
  final String id;
  final String userId;
  final String title;
  final String description;
  final String category;
  final String milestoneType;
  final String pillar;
  final int xpReward;
  final String status;
  final int weekNumber;
  final int year;
  final String? dueDate;
  final String? completedAt;
  final int progressPct;
  final List<TargetMilestone>? milestones;

  const WeeklyTarget({
    required this.id,
    required this.userId,
    required this.title,
    required this.description,
    required this.category,
    required this.milestoneType,
    this.pillar = '',
    this.xpReward = 10,
    required this.status,
    required this.weekNumber,
    required this.year,
    this.dueDate,
    this.completedAt,
    this.progressPct = 0,
    this.milestones,
  });

  factory WeeklyTarget.fromJson(Map<String, dynamic> json) {
    return WeeklyTarget(
      id: json['id']?.toString() ?? '',
      userId: json['user_id']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      category: json['category']?.toString() ?? 'standard',
      milestoneType: json['milestone_type']?.toString() ?? 'standard',
      pillar: json['pillar']?.toString() ?? '',
      xpReward: json['xp_reward'] is int ? json['xp_reward'] : 10,
      status: json['status']?.toString() ?? 'pending',
      weekNumber: json['week_number'] is int ? json['week_number'] : 0,
      year: json['year'] is int ? json['year'] : DateTime.now().year,
      dueDate: json['due_date']?.toString(),
      completedAt: json['completed_at']?.toString(),
      progressPct: json['progress_pct'] is int ? json['progress_pct'] : 0,
      milestones: json['milestones'] != null
          ? (json['milestones'] as List).map((m) => TargetMilestone.fromJson(m)).toList()
          : null,
    );
  }

  bool get isCompleted => status == 'completed';
  bool get isInProgress => status == 'in_progress';
  bool get isPending => status == 'pending';

  DateTime? get dueDateTime {
    if (dueDate == null || dueDate!.isEmpty) return null;
    try {
      return DateTime.parse(dueDate!);
    } catch (_) {
      return null;
    }
  }

  int? get daysUntilDue {
    final due = dueDateTime;
    if (due == null) return null;
    return due.difference(DateTime.now()).inDays;
  }
}

class TargetMilestone {
  final String id;
  final String title;
  final bool completed;

  const TargetMilestone({
    required this.id,
    required this.title,
    this.completed = false,
  });

  factory TargetMilestone.fromJson(Map<String, dynamic> json) {
    return TargetMilestone(
      id: json['id']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      completed: json['completed'] == true,
    );
  }
}

// ─── Category Metadata ───────────────────────────────────────────────────────

class CategoryMeta {
  final Color color;
  final IconData icon;
  final String label;

  const CategoryMeta(this.color, this.icon, this.label);
}

const Map<String, CategoryMeta> categoryMeta = {
  'research_paper': CategoryMeta(Color(0xFF0891B2), Icons.science_rounded, 'Research'),
  'competition': CategoryMeta(Color(0xFFE11D48), Icons.emoji_events_rounded, 'Competition'),
  'course_cert': CategoryMeta(Color(0xFF059669), Icons.school_rounded, 'Course'),
  'essay_draft': CategoryMeta(Color(0xFF7C3AED), Icons.edit_note_rounded, 'Essay'),
  'volunteer_hours': CategoryMeta(Color(0xFFDB2777), Icons.volunteer_activism_rounded, 'Volunteer'),
  'project_deliverable': CategoryMeta(Color(0xFFF59E0B), Icons.build_rounded, 'Project'),
  'standard': CategoryMeta(Color(0xFF4338CA), Icons.task_alt_rounded, 'Task'),
};

CategoryMeta getCategoryMeta(String type) {
  return categoryMeta[type] ?? categoryMeta['standard']!;
}
