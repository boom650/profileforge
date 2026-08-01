import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:profileforge/features/timer/application/timer_providers.dart';
import 'package:profileforge/core/data/tables.dart';
import 'package:profileforge/features/xp/application/xp_providers.dart';
import 'package:profileforge/features/xp/application/variable_rewards.dart';
import 'package:profileforge/features/achievements/application/achievement_providers.dart';
import 'package:profileforge/core/audio/sound_provider.dart';
import 'package:profileforge/core/widgets/poppy.dart';
import 'package:profileforge/core/celebration/celebrate.dart';
import 'package:profileforge/features/buddy/presentation/body_double_widget.dart';
import 'package:profileforge/features/habits/application/timer_debt_listener.dart';
import 'package:flutter/services.dart';


class TimerScreen extends ConsumerStatefulWidget {
  final String profileId;
  const TimerScreen({super.key, required this.profileId});

  @override
  ConsumerState<TimerScreen> createState() => _TimerScreenState();
}

class _TimerScreenState extends ConsumerState<TimerScreen>
    with SingleTickerProviderStateMixin {
  String _selectedTag = '';
  final _tags = ['General', 'Study', 'Math', 'Science', 'Languages', 'Competition', 'Reading', 'Writing'];
  bool _showCompletion = false;
  int _earnedXp = 0;
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(vsync: this, duration: 600.ms);
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.08).animate(CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut));
    _pulseController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  void _handleComplete(int minutes) {
    final xp = minutes; // 1 XP per minute
    setState(() {
      _earnedXp = xp;
      _showCompletion = true;
    });
    // Apply variable‑ratio rewards (bonus XP + gems)
    ref.read(applyVariableRewardsProvider(ApplyRewardsArgs(
      profileId: widget.profileId,
      baseXp: xp,
    )));
    // Save session
    ref.read(saveFocusSessionProvider(
      (profileId: widget.profileId, durationMinutes: minutes, xpEarned: xp, tag: _selectedTag),
    ));
    // Check achievements
    ref.read(achievementCheckerProvider.notifier).checkAll(widget.profileId);
    // Sound
    ref.read(soundServiceProvider).success();
    // Celebrate
    celebrate(context, message: '+$xp XP');
  }

  String _formatTime(int secs) {
    final m = (secs ~/ 60).toString().padLeft(2, '0');
    final s = (secs % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  @override
  Widget build(BuildContext context) {
    // Activate debt listener – ensures early‑stop debts are recorded.
    ref.watch(timerDebtListener(widget.profileId));

    final theme = Theme.of(context);
    final notifier = ref.read(timerStateProvider.notifier);
    final timerState = ref.watch(timerStateProvider);

    // When timer completes naturally, trigger rewards & celebration.
    ref.listen<TimerSnapshot>(timerStateProvider, (prev, next) {
      if (prev != null && prev.isRunning && !next.isRunning && next.secondsRemaining == 0) {
        _handleComplete(next.durationMinutes);
      }
    });

    return Scaffold(
      appBar: AppBar(title: const Text('Focus Timer'), centerTitle: true),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                const SizedBox(height: 10),

                // Duration selector chips
                Wrap(
                  spacing: 8,
                  runSpacing: 6,
                  alignment: WrapAlignment.center,
                  children: [5, 10, 15, 25, 30, 45, 60].map((m) {
                    final selected = timerState.durationMinutes == m && !timerState.isRunning;
                    return ActionChip(
                      label: Text('${m}min', style: TextStyle(fontSize: 13, fontWeight: selected ? FontWeight.bold : FontWeight.normal)),
                      onPressed: timerState.isRunning ? null : () => notifier.setDuration(m),
                      color: WidgetStatePropertyAll(selected ? theme.colorScheme.primary : theme.colorScheme.surfaceContainerHighest),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 30),

                // Body Double widget
                const BodyDoubleWidget(),
                const SizedBox(height: 20),

                // Circular timer display
                AnimatedBuilder(
                  animation: _pulseAnimation,
                  builder: (context, child) {
                    final totalSecs = timerState.durationMinutes * 60;
                    final remaining = timerState.secondsRemaining;
                    final progress = totalSecs > 0 ? (totalSecs - remaining) / totalSecs : 0.0;
                    return Transform.scale(
                      scale: timerState.isRunning ? _pulseAnimation.value : 1.0,
                      child: SizedBox(
                        width: 260, height: 260,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Container(width: 260, height: 260,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: theme.colorScheme.surfaceContainerHighest,
                                boxShadow: timerState.isRunning ? [
                                  BoxShadow(
                                    color: (timerState.isPaused ? Colors.orange : theme.colorScheme.primary).withValues(alpha: 0.3),
                                    blurRadius: 40,
                                    spreadRadius: 8,
                                  ),
                                ] : [],
                              ),
                            ),
                            SizedBox(width: 260, height: 260, child: CustomPaint(
                              painter: _CircleProgressPainter(progress: progress, color: timerState.isRunning
                                  ? (timerState.isPaused ? Colors.orange : theme.colorScheme.primary)
                                  : theme.colorScheme.primary.withValues(alpha: 0.3)),
                            )),
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(_formatTime(timerState.secondsRemaining),
                                  style: theme.textTheme.displayLarge?.copyWith(fontWeight: FontWeight.w700, fontSize: 56, fontFamily: 'monospace'),
                                ),
                                if (timerState.label.isNotEmpty)
                                  Text(timerState.label, style: theme.textTheme.labelLarge?.copyWith(
                                    color: timerState.isPaused ? Colors.orange : theme.colorScheme.primary)),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 30),

                // Controls
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (!timerState.isRunning && timerState.secondsRemaining == timerState.durationMinutes * 60)
                      PoppyButton(label: 'Start', icon: Icons.play_arrow_rounded, onPressed: () => notifier.start())
                    else if (timerState.isRunning && !timerState.isPaused)
                      PoppyButton(label: 'Pause', icon: Icons.pause_rounded, color: Colors.orange, onPressed: () => notifier.pause())
                    else if (timerState.isPaused)
                      Row(mainAxisSize: MainAxisSize.min, children: [
                        PoppyButton(label: 'Resume', icon: Icons.play_arrow_rounded, onPressed: () => notifier.resume()),
                        const SizedBox(width: 16),
                        PoppyButton(label: 'Reset', icon: Icons.stop_rounded, color: Colors.red, onPressed: () => notifier.reset()),
                      ])
                    else
                      PoppyButton(label: 'Reset', icon: Icons.refresh_rounded, onPressed: () => notifier.reset()),
                  ],
                ),
                const SizedBox(height: 24),

                // Tag selector
                _TagSelector(tags: _tags, selected: _selectedTag, onChanged: (t) => setState(() => _selectedTag = t)),
                const SizedBox(height: 24),

                // Recent sessions header
                Row(children: [
                  Icon(Icons.history_rounded, size: 20, color: theme.colorScheme.onSurfaceVariant),
                  const SizedBox(width: 8),
                  Text('Recent Sessions', style: theme.textTheme.titleMedium),
                ]),
                const SizedBox(height: 8),
                _RecentSessionsList(profileId: widget.profileId),
                const SizedBox(height: 60),
              ],
            ),
          ),

          if (_showCompletion)
            Positioned.fill(
              child: _CompletionOverlay(xp: _earnedXp, onDismiss: () => setState(() => _showCompletion = false)),
            ),
        ],
      ),
    );
  }
}

class _CircleProgressPainter extends CustomPainter {
  final double progress; final Color color;
  _CircleProgressPainter({required this.progress, required this.color});
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 12;
    final paint = Paint()..color = color..strokeWidth = 8..style = PaintingStyle.stroke..strokeCap = StrokeCap.round;
    canvas.drawArc(Rect.fromCircle(center: center, radius: radius), -math.pi / 2, 2 * math.pi * progress, false, paint);
  }
  @override
  bool shouldRepaint(covariant _CircleProgressPainter old) => old.progress != progress;
}

class _TagSelector extends StatelessWidget {
  final List<String> tags; final String selected; final ValueChanged<String> onChanged;
  const _TagSelector({required this.tags, required this.selected, required this.onChanged});
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text('Subject Tag', style: theme.textTheme.labelLarge),
      const SizedBox(height: 8),
      Wrap(spacing: 6, runSpacing: 4, children: tags.map((t) {
        final sel = selected == t || (t == 'General' && selected.isEmpty);
        return ChoiceChip(label: Text(t, style: TextStyle(fontSize: 12, fontWeight: sel ? FontWeight.bold : FontWeight.normal)),
          selected: sel, onSelected: (_) => onChanged(t == 'General' ? '' : t));
      }).toList()),
    ]);
  }
}

class _RecentSessionsList extends ConsumerWidget {
  final String profileId;
  const _RecentSessionsList({required this.profileId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sessions = ref.watch(recentSessionsProvider(profileId));
    final theme = Theme.of(context);
    return sessions.when(
      data: (list) {
        if (list.isEmpty) return Padding(padding: const EdgeInsets.all(20),
          child: Text('No sessions yet. Start your first focus timer!', style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant), textAlign: TextAlign.center));
        return Column(children: list.take(5).map((s) => ListTile(
          dense: true,
          leading: Icon(Icons.timer_outlined, color: theme.colorScheme.primary),
          title: Text('${s.durationMinutes} min ${s.tag.isEmpty ? '' : '· ${s.tag}'}'),
          subtitle: Text('${s.xpEarned} XP • ${_formatDate(s.startedAt)}'),
          trailing: Text('+${s.xpEarned}', style: TextStyle(color: theme.colorScheme.primary, fontWeight: FontWeight.bold)),
        )).toList());
      },
      loading: () => const Center(child: CircularProgressIndicator(strokeWidth: 2)),
      error: (_, __) => const Text('Failed to load sessions'),
    );
  }

  String _formatDate(DateTime dt) {
    final diff = DateTime.now().difference(dt);
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    return '${dt.month}/${dt.day}';
  }
}

class _CompletionOverlay extends StatelessWidget {
  final int xp; final VoidCallback onDismiss;
  const _CompletionOverlay({required this.xp, required this.onDismiss});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Material(color: Colors.black54, child: Center(
      child: Container(
        margin: const EdgeInsets.all(32), padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(color: theme.colorScheme.surface, borderRadius: BorderRadius.circular(24)),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          const Text('🎯', style: TextStyle(fontSize: 64)),
          const SizedBox(height: 16),
          Text('Session Complete!', style: theme.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text('+$xp XP Earned', style: theme.textTheme.headlineSmall?.copyWith(color: theme.colorScheme.primary, fontWeight: FontWeight.bold)),
          const SizedBox(height: 24),
          PoppyButton(label: 'Awesome!', onPressed: onDismiss),
        ]),
      ).animate().scale(duration: 300.ms, begin: const Offset(0.5, 0.5), end: const Offset(1, 1), curve: Curves.elasticOut),
    ));
  }
}
