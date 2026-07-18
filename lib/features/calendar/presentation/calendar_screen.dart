import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:profileforge/features/calendar/application/calendar_providers.dart';

class CalendarScreen extends ConsumerWidget {
  const CalendarScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final plan = ref.watch(weeklyPlanProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Smart Schedule')),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: plan.length,
        itemBuilder: (context, i) {
          final entry = plan.entries.elementAt(i);
          final task = entry.key;
          final slot = entry.value;
          return Semantics(
            label: '${task.title} scheduled at ${slot.start.hour}:00',
            child: Card(
              child: ListTile(
                leading: const Icon(Icons.schedule),
                title: Text(task.title),
                subtitle: Text('${slot.start.hour}:00 · ${task.estMinutes} min · '
                    'priority ${task.priority}'),
              ),
            ),
          ).animate().fadeIn(delay: (i * 40).ms).slideX(begin: 0.1);
        },
      ),
    );
  }
}
