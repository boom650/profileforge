import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:profileforge/features/calendar/data/calendar_repository.dart';

final calendarRepositoryProvider = Provider<CalendarRepository>((ref) => const CalendarRepository());

/// Provides this week's allocated plan: tasks → slots.
final weeklyPlanProvider = Provider<Map<Task, CalendarSlot>>((ref) {
  final repo = ref.watch(calendarRepositoryProvider);
  // In production these come from the device calendar + mission backlog.
  const fixed = <CalendarSlot>[];
  const tasks = <Task>[
    Task(id: 'essay', title: 'University essay draft', priority: 5, estMinutes: 60),
    Task(id: 'paper', title: 'Read research paper', priority: 3, estMinutes: 60),
  ];
  return repo.allocate(fixed: fixed, tasks: tasks, energy: EnergyCurve());
});
