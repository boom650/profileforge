import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:profileforge/core/theme/app_theme.dart';
import 'package:profileforge/core/widgets/premium_widgets.dart';
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

                // Duration selector chips — premium glass design
                _DurationSelector(
                  durations: const [5, 10, 15, 25, 30, 45, 60],
                  selected: timerState.durationMinutes,
                  isRunning: timerState.isRunning,
                  onChanged: (m) => notifier.setDuration(m),
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
                      _PulsingStartButton(onPressed: () => notifier.start())
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
                const SizedBox(height: 20),

                // Today's stats summary
                _TodayStats(profileId: widget.profileId),
                const SizedBox(height: 20),

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
        return Column(children: list.take(5).toList().asMap().entries.map((entry) {
          final i = entry.key;
          final s = entry.value;
          final tagColors = {
            'Math': Palette.accentPurple,
            'Science': Palette.accentTeal,
            'English': Palette.accentPink,
            'History': Palette.accentOrange,
            '': Palette.textTertiary,
          };
          final tagColor = tagColors[s.tag] ?? Palette.primary;
          return Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: GlassCard(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              child: Row(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: tagColor.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Text(
                        s.tag.isNotEmpty ? s.tag[0].toUpperCase() : '⏱',
                        style: TextStyle(
                          fontSize: s.tag.isNotEmpty ? 14 : 16,
                          fontWeight: FontWeight.w700,
                          color: tagColor,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          s.tag.isNotEmpty ? s.tag : 'Focus Session',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: Palette.textPrimary,
                          ),
                        ),
                        Text(
                          '${s.durationMinutes} min · ${_formatDate(s.startedAt)}',
                          style: TextStyle(
                            fontSize: 11,
                            color: Palette.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Palette.green.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      '+${s.xpEarned} XP',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: Palette.green,
                      ),
                    ),
                  ),
                ],
              ),
            ).animate().fadeIn(delay: (i * 80).ms).slideX(begin: 0.05),
          );
        }).toList());
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
    return Material(
      color: Colors.black54,
      child: Stack(
        children: [
          // Confetti particles
          ...List.generate(20, (i) => Positioned(
            left: (i * 37.0) % MediaQuery.of(context).size.width,
            top: -20 - (i * 13.0) % 100,
            child: Text(
              ['🎉', '⭐', '✨', '🌟', '💫', '🎊'][i % 6],
              style: TextStyle(fontSize: 16 + (i % 4) * 4),
            ).animate(
              delay: (i * 50).ms,
              onPlay: (c) => c.repeat(),
            ).moveY(
              begin: -20,
              end: MediaQuery.of(context).size.height + 40,
              duration: Duration(milliseconds: 2000 + (i * 200)),
              curve: Curves.linear,
            ).rotate(
              begin: 0,
              end: (i % 2 == 0 ? 1 : -1) * 2 * math.pi,
              duration: Duration(milliseconds: 3000 + (i * 100)),
            ),
          )),
          // Celebration card
          Center(
            child: Container(
              margin: const EdgeInsets.all(32), padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: Palette.green.withValues(alpha: 0.3),
                    blurRadius: 40,
                    spreadRadius: 8,
                  ),
                ],
              ),
              child: Column(mainAxisSize: MainAxisSize.min, children: [
                const Text('🎯', style: TextStyle(fontSize: 64))
                    .animate().scale(duration: 500.ms, curve: Curves.elasticOut),
                const SizedBox(height: 16),
                Text('Session Complete!', style: theme.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Text('+$xp XP Earned', style: theme.textTheme.headlineSmall?.copyWith(color: Palette.green, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Text(
                  _completionMessage(),
                  style: TextStyle(fontSize: 13, color: Palette.textSecondary),
                ),
                const SizedBox(height: 24),
                PoppyButton(label: 'Awesome!', onPressed: onDismiss),
              ]),
            ).animate().scale(duration: 300.ms, begin: const Offset(0.5, 0.5), end: const Offset(1, 1), curve: Curves.elasticOut),
          ),
        ],
      ),
    );
  }

  String _completionMessage() {
    if (xp >= 50) return '🔥 Incredible focus! You\'re on fire!';
    if (xp >= 30) return '💪 Great session! Keep the momentum!';
    if (xp >= 15) return '⭐ Nice work! Every minute counts!';
    return '👏 Good start! Try longer sessions for more XP!';
  }
}

/// Today's focus stats — compact summary.
class _TodayStats extends ConsumerWidget {
  const _TodayStats({required this.profileId});
  final String profileId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sessions = ref.watch(recentSessionsProvider(profileId));
    return sessions.when(
      data: (list) {
        final now = DateTime.now();
        final today = list.where((s) =>
          s.startedAt.year == now.year &&
          s.startedAt.month == now.month &&
          s.startedAt.day == now.day
        ).toList();
        
        final totalMin = today.fold(0, (sum, s) => sum + s.durationMinutes);
        final totalXp = today.fold(0, (sum, s) => sum + s.xpEarned);
        
        if (today.isEmpty) return const SizedBox.shrink();
        
        return GlassCard(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              _TodayStatItem(
                icon: Icons.timer_outlined,
                value: '${today.length}',
                label: 'Sessions',
                color: Palette.accentBlue,
              ),
              const SizedBox(width: 16),
              _TodayStatItem(
                icon: Icons.schedule,
                value: '${totalMin}m',
                label: 'Focus',
                color: Palette.accentPurple,
              ),
              const SizedBox(width: 16),
              _TodayStatItem(
                icon: Icons.bolt,
                value: '$totalXp',
                label: 'XP',
                color: Palette.warning,
              ),
            ],
          ),
        ).animate().fadeIn(delay: 200.ms);
      },
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
    );
  }
}

class _TodayStatItem extends StatelessWidget {
  const _TodayStatItem({
    required this.icon,
    required this.value,
    required this.label,
    required this.color,
  });

  final IconData icon;
  final String value;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Icon(icon, size: 16, color: color),
            ),
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: Palette.textPrimary,
                ),
              ),
              Text(
                label,
                style: TextStyle(
                  fontSize: 11,
                  color: Palette.textSecondary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Premium duration selector with glass chips.
class _DurationSelector extends StatelessWidget {
  const _DurationSelector({
    required this.durations,
    required this.selected,
    required this.isRunning,
    required this.onChanged,
  });

  final List<int> durations;
  final int selected;
  final bool isRunning;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 6,
      alignment: WrapAlignment.center,
      children: durations.map((m) {
        final sel = selected == m && !isRunning;
        return GestureDetector(
          onTap: isRunning ? null : () => onChanged(m),
          child: AnimatedContainer(
            duration: 200.ms,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: sel
                  ? Palette.primary.withValues(alpha: 0.15)
                  : Palette.surface2,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: sel ? Palette.primary : Palette.border,
                width: sel ? 2 : 1,
              ),
              boxShadow: sel ? [
                BoxShadow(
                  color: Palette.primary.withValues(alpha: 0.2),
                  blurRadius: 8,
                  spreadRadius: 1,
                ),
              ] : [],
            ),
            child: Text(
              '${m}min',
              style: TextStyle(
                fontSize: 13,
                fontWeight: sel ? FontWeight.w700 : FontWeight.w500,
                color: sel ? Palette.primary : Palette.textSecondary,
              ),
            ),
          ),
        ).animate().scale(duration: 150.ms, begin: const Offset(0.95, 0.95), curve: Curves.easeOut);
      }).toList(),
    );
  }
}

/// Pulsing start button with glow animation.
class _PulsingStartButton extends StatefulWidget {
  const _PulsingStartButton({required this.onPressed});
  final VoidCallback onPressed;

  @override
  State<_PulsingStartButton> createState() => _PulsingStartButtonState();
}

class _PulsingStartButtonState extends State<_PulsingStartButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: 1500.ms);
    _glowAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    _controller.repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _glowAnimation,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                color: Palette.green.withValues(alpha: 0.3 * _glowAnimation.value),
                blurRadius: 20 + (10 * _glowAnimation.value),
                spreadRadius: 2 * _glowAnimation.value,
              ),
            ],
          ),
          child: PoppyButton(
            label: 'Start',
            icon: Icons.play_arrow_rounded,
            onPressed: widget.onPressed,
          ),
        );
      },
    );
  }
}
