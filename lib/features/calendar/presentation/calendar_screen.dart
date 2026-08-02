import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:profileforge/core/theme/app_theme.dart';
import 'package:profileforge/core/widgets/premium_widgets.dart';
import 'package:profileforge/features/calendar/application/calendar_providers.dart';

class CalendarScreen extends ConsumerWidget {
  const CalendarScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dark = isDark(context);
    final plan = ref.watch(weeklyPlanProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Smart Schedule'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: plan.length,
        itemBuilder: (context, i) {
          final entry = plan.entries.elementAt(i);
          final task = entry.key;
          final slot = entry.value;
          final hour = slot.start.hour;
          final isMorning = hour >= 6 && hour < 12;
          final isAfternoon = hour >= 12 && hour < 17;
          final timeIcon = isMorning ? '🌅' : isAfternoon ? '☀️' : '🌙';
          final priorityColor = task.priority >= 4
              ? Palette.error
              : task.priority >= 3
                  ? Palette.accentOrange
                  : Palette.accentTeal;

          return Semantics(
            label: '${task.title} scheduled at ${slot.start.hour}:00',
            child: GlassCard(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  // Time column
                  Column(
                    children: [
                      Text(timeIcon, style: TextStyle(fontSize: 20)),
                      const SizedBox(height: 4),
                      Text(
                        '${slot.start.hour}:00',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w800,
                          color: Palette.textPrimary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 14),

                  // Divider
                  Container(
                    width: 2,
                    height: 44,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          priorityColor.withValues(alpha: 0.1),
                          priorityColor.withValues(alpha: 0.5),
                          priorityColor.withValues(alpha: 0.1),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(1),
                    ),
                  ),
                  const SizedBox(width: 14),

                  // Task details
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          task.title,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: Palette.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            _Tag(
                              label: '${task.estMinutes} min',
                              color: Palette.accentBlue,
                              dark: dark,
                            ),
                            const SizedBox(width: 6),
                            _Tag(
                              label: 'P${task.priority}',
                              color: priorityColor,
                              dark: dark,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Chevron
                  Icon(
                    Icons.chevron_right,
                    color: Palette.textMuted,
                    size: 20,
                  ),
                ],
              ),
            ).animate().fadeIn(delay: (i * 60).ms).slideX(
              begin: 0.06,
              duration: 400.ms,
              curve: Curves.easeOutCubic,
            ),
          );
        },
      ),
    );
  }
}

class _Tag extends StatelessWidget {
  final String label;
  final Color color;
  final bool dark;

  const _Tag({
    required this.label,
    required this.color,
    required this.dark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: color,
        ),
      ),
    );
  }
}
