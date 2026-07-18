import 'package:profileforge/features/calendar/domain/calendar_engine.dart';

/// Repository boundary for H10 calendar intelligence. Currently in-memory /
/// engine-backed; later backed by the device calendar + H9 sync outbox.
class CalendarRepository {
  const CalendarRepository();

  /// Allocate tasks into free slots for the given week.
  Map<Task, CalendarSlot> allocate({
    required List<CalendarSlot> fixed,
    required List<Task> tasks,
    required EnergyCurve energy,
  }) =>
      TaskAllocator(fixed: fixed, tasks: tasks, energy: energy).allocate();

  /// Detect unexpected free time between [from] and [to].
  List<CalendarSlot> detectUnexpectedFree(
    List<CalendarSlot> fixed,
    DateTime from,
    DateTime to,
  ) =>
      TaskAllocator(fixed: fixed, tasks: const [], energy: EnergyCurve())
          .detectUnexpectedFree(from, to);
}
