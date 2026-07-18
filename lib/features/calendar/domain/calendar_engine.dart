/// H10 — Calendar Intelligence Engine. Pure, deterministic scheduling logic.
///
/// Models a student's week as fixed commitments (school, exams, coaching)
/// plus flexible free slots. Allocates tasks by priority + energy fit, detects
/// unexpected free time, injects backlog when capacity allows, and supports
/// dynamic rescheduling. No Flutter/IO dependencies — fully unit-testable.
library calendar_engine;

import 'package:freezed_annotation/freezed_annotation.dart';

part 'calendar_engine.freezed.dart';

/// A fixed commitment or a free slot in the week.
class CalendarSlot {
  const CalendarSlot({required this.start, required this.end, this.fixed = false});
  final DateTime start;
  final DateTime end;
  final bool fixed;
  int get durationMinutes => end.difference(start).inMinutes;
  bool overlaps(CalendarSlot o) =>
      start.isBefore(o.end) && end.isAfter(o.start);
}

/// A schedulable unit of work mapped to an admissions pillar.
class Task {
  const Task({
    required this.id,
    required this.title,
    required this.priority, // 1 (low) .. 5 (critical)
    required this.estMinutes,
    this.pillar,
    this.energyFit = 0.6, // preferred energy level for this task
  });
  final String id;
  final String title;
  final int priority;
  final int estMinutes;
  final String? pillar;
  final double energyFit;
}

/// Energy curve: higher late morning & evening, lower post-lunch.
class EnergyCurve {
  double at(DateTime t) {
    final h = t.hour;
    if (h >= 9 && h <= 11) return 1.0;
    if (h >= 16 && h <= 20) return 0.9;
    if (h >= 12 && h <= 14) return 0.4;
    return 0.6;
  }
}

/// Scores + ranks tasks. Critical/high-pillar tasks float to the top.
class PriorityEngine {
  /// Weighted priority: base priority + pillar-weight boost + deadline pressure.
  double score(Task t, {int? daysUntilDue}) {
    var s = t.priority * 10.0;
    const pillarWeight = {
      'Academics': 3.0,
      'Research': 2.5,
      'Leadership': 2.0,
      'Creativity': 1.5,
      'Community': 1.5,
      'Service': 1.5,
      'Sports': 1.0,
      'Personal': 1.0,
    };
    if (t.pillar != null) s += pillarWeight[t.pillar] ?? 1.0;
    if (daysUntilDue != null && daysUntilDue <= 2) s += 15; // urgency
    return s;
  }

  List<Task> rank(List<Task> tasks, {Map<String, int> dueIn = const {}}) {
    final withDue = tasks.map((t) => (t, dueIn[t.id])).toList();
    withDue.sort((a, b) => score(b.$1, daysUntilDue: b.$2)
        .compareTo(score(a.$1, daysUntilDue: a.$2)));
    return withDue.map((e) => e.$1).toList();
  }
}

/// FIFO backlog of unscheduled tasks; injected when free capacity appears.
class BacklogQueue {
  final List<Task> _items = [];
  void push(Task t) => _items.add(t);
  Task? pop() => _items.isEmpty ? null : _items.removeAt(0);
  List<Task> get items => List.unmodifiable(_items);
  int get length => _items.length;
}

/// Motivator protocol: turns completed/injected tasks into nudges.
@freezed
class MotivatorMessage with _$MotivatorMessage {
  const factory MotivatorMessage({
    required String text,
    required String tone, // 'encourage' | 'celebrate' | 'nudge'
  }) = _MotivatorMessage;
}

/// Core allocator: priority-first, energy-fit placement, backlog injection.
class TaskAllocator {
  TaskAllocator({
    required this.fixed,
    required this.tasks,
    required this.energy,
    this.priority = const PriorityEngine(),
    BacklogQueue? backlog,
  }) : backlog = backlog ?? BacklogQueue();

  final List<CalendarSlot> fixed;
  final List<Task> tasks;
  final EnergyCurve energy;
  final PriorityEngine priority;
  final BacklogQueue backlog;

  List<CalendarSlot> _freeSlots() {
    final weekStart = _monday(DateTime.now());
    final out = <CalendarSlot>[];
    for (var d = 0; d < 7; d++) {
      for (var h = 7; h < 22; h++) {
        final start = weekStart.add(Duration(days: d, hours: h));
        final end = start.add(const Duration(hours: 1));
        final overlaps =
            fixed.any((f) => f.start.isBefore(end) && f.end.isAfter(start));
        if (!overlaps) out.add(CalendarSlot(start: start, end: end));
      }
    }
    return out;
  }

  /// Allocate tasks into free slots. Highest-priority task first; each is placed
  /// in the free slot whose energy best matches the task's preferred energy.
  Map<Task, CalendarSlot> allocate() {
    final free = _freeSlots();
    final ranked = priority.rank(tasks);
    final result = <Task, CalendarSlot>{};
    final remaining = [...free];
    for (final task in ranked) {
      CalendarSlot? best;
      var bestFit = -1.0;
      for (final slot in remaining) {
        if (slot.durationMinutes < task.estMinutes) continue;
        final fit = 1.0 - (energy.at(slot.start) - task.energyFit).abs();
        if (fit > bestFit) {
          bestFit = fit;
          best = slot;
        }
      }
      if (best != null) {
        result[task] = best;
        remaining.remove(best);
      } else {
        backlog.push(task); // no room this week → carry over
      }
    }
    return result;
  }

  /// Detects an unexpected gap (e.g. class cancelled) and returns the slot.
  List<CalendarSlot> detectUnexpectedFree(DateTime from, DateTime to) {
    final overlapsFixed =
        fixed.any((f) => f.start.isBefore(to) && f.end.isAfter(from));
    if (!overlapsFixed) return [CalendarSlot(start: from, end: to)];
    return const [];
  }

  /// Dynamically reschedule: drop [cancelled], free its slot, re-allocate.
  Map<Task, CalendarSlot> reschedule(
      Map<Task, CalendarSlot> current, Task cancelled) {
    final next = {...current}..remove(cancelled);
    // Re-rank remaining + backlog, allocate into freed capacity.
    final all = [...next.keys, ...backlog.items, cancelled];
    return TaskAllocator(
      fixed: fixed,
      tasks: all,
      energy: energy,
      priority: priority,
    ).allocate();
  }

  /// Produces a motivator nudge for an injected backlog task.
  MotivatorMessage motivate(Task t) => MotivatorMessage(
        text: 'Found 1h free — tackle "${t.title}" to keep your ${t.pillar ?? 'growth'} streak alive.',
        tone: 'nudge',
      );
}

DateTime _monday(DateTime d) {
  final diff = (d.weekday - DateTime.monday) % 7;
  return DateTime(d.year, d.month, d.day).subtract(Duration(days: diff));
}
