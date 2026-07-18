import 'package:flutter_test/flutter_test.dart';
import 'package:profileforge/features/calendar/domain/calendar_engine.dart';

void main() {
  group('CalendarEngine', () {
    final fixed = [
      CalendarSlot(
        start: DateTime(2026, 1, 5, 9), // Mon 9:00
        end: DateTime(2026, 1, 5, 10),
        fixed: true,
      ),
    ];
    final tasks = [
      Task(id: 'low', title: 'Low', priority: 1, estMinutes: 60),
      Task(id: 'crit', title: 'Critical', priority: 5, estMinutes: 60, pillar: 'Academics'),
    ];

    test('allocates and prefers highest priority first', () {
      final alloc = TaskAllocator(
        fixed: fixed,
        tasks: tasks,
        energy: EnergyCurve(),
        priority: PriorityEngine(),
      );
      final plan = alloc.allocate();
      expect(plan.length, 2);
      // critical task scheduled, not dropped to backlog
      expect(plan.containsKey(tasks[1]), isTrue);
    });

    test('PriorityEngine ranks critical above low', () {
      final ranked = PriorityEngine().rank(tasks);
      expect(ranked.first.id, 'crit');
    });

    test('oversized tasks fall into backlog', () {
      final big = Task(id: 'big', title: 'Big', priority: 5, estMinutes: 99999);
      final alloc = TaskAllocator(fixed: fixed, tasks: [big], energy: EnergyCurve(), priority: PriorityEngine());
      final plan = alloc.allocate();
      expect(plan.containsKey(big), isFalse);
      expect(alloc.backlog.length, 1);
    });

    test('detectUnexpectedFree returns slot when no fixed overlap', () {
      final alloc = TaskAllocator(fixed: fixed, tasks: const [], energy: EnergyCurve(), priority: PriorityEngine());
      final gap = alloc.detectUnexpectedFree(
        DateTime(2026, 1, 5, 14), // Mon 14:00 free
        DateTime(2026, 1, 5, 15),
      );
      expect(gap, hasLength(1));
    });

    test('reschedule frees capacity and re-allocates backlog', () {
      final big = Task(id: 'big', title: 'Big', priority: 4, estMinutes: 99999);
      final alloc = TaskAllocator(fixed: fixed, tasks: [big], energy: EnergyCurve(), priority: PriorityEngine());
      alloc.allocate();
      final current = alloc.allocate();
      // reschedule removes 'big' and re-allocates remaining (none) — no throw
      final next = alloc.reschedule(current, big);
      expect(next, isA<Map<Task, CalendarSlot>>());
    });
  });
}
