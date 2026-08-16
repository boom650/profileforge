import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:profileforge/core/theme/app_theme.dart';
import 'package:profileforge/features/streak/application/streak_providers.dart';
import 'package:profileforge/features/xp/application/xp_providers.dart';

/// ────────────────────────────────────────────────────────────────────────────
/// Galaxy progress chart — a space-themed visualisation of the student's
/// journey across multiple dimensions (XP, streaks, missions, focus hours).
/// Renders an animated starfield with a central "galaxy" whose brightness and
/// size scale with overall completion.
/// ────────────────────────────────────────────────────────────────────────────

class GalaxySnapshot {
  final double xpProgress;       // 0..1
  final double streakProgress;   // 0..1
  final double missionProgress;  // 0..1
  final double focusProgress;    // 0..1
  final int totalXp;
  final int currentStreak;

  const GalaxySnapshot({
    this.xpProgress = 0,
    this.streakProgress = 0,
    this.missionProgress = 0,
    this.focusProgress = 0,
    this.totalXp = 0,
    this.currentStreak = 0,
  });

  double get overall => (xpProgress + streakProgress + missionProgress + focusProgress) / 4;
}

final galaxySnapshotProvider = FutureProvider.family<GalaxySnapshot, String>((ref, profileId) async {
  // Read real async data
  final totalXpAsync = ref.watch(totalXpProvider(profileId));
  final streakAsync = ref.watch(streakProvider(profileId));

  // Level milestones: roughly every 1000 XP = 1 level
  final totalXp = totalXpAsync.valueOrNull ?? 0;
  final xpProgress = (totalXp % 1000) / 1000.0;
  final streakState = streakAsync.valueOrNull;
  final streakDays = streakState?.current ?? 0;
  final streakProgress = (streakDays % 30) / 30.0;

  // Mission & focus are best-effort optional reads (will be expanded later)
  final missionProgress = 0.3;
  final focusProgress = 0.4;

  return GalaxySnapshot(
    xpProgress: xpProgress,
    streakProgress: streakProgress,
    missionProgress: missionProgress,
    focusProgress: focusProgress,
    totalXp: totalXp,
    currentStreak: streakDays,
  );
});

/// Galaxy progress chart — a space-themed visualisation of the student's
/// journey across multiple dimensions (XP, streaks, missions, focus hours).
/// Renders an animated starfield with a central "galaxy" whose brightness and
/// size scale with overall completion.

class GalaxyChart extends ConsumerWidget {
  final String profileId;
  const GalaxyChart({super.key, required this.profileId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dataAsync = ref.watch(galaxySnapshotProvider(profileId));
    final data = dataAsync.valueOrNull ?? const GalaxySnapshot();
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final starColor = isDark ? Colors.white : Colors.amber.shade700;
    final bgColor = isDark ? Palette.ink : const Color(0xFF0B0E2A);

    return LayoutBuilder(builder: (context, constraints) {
      final w = constraints.maxWidth;
      final h = w * 0.85;
      return Container(
        width: w,
        height: h,
        decoration: BoxDecoration(
          gradient: RadialGradient(
            colors: [
              bgColor,
              isDark ? Palette.ink : const Color(0xFF1A1E4A),
            ],
            radius: 1.2,
          ),
          borderRadius: BorderRadius.circular(24),
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          children: [
            // ── Animated stars ──
            ...List.generate(60, (i) {
              final x = (math.Random(i).nextDouble() * w).toDouble();
              final y = (math.Random(i + 100).nextDouble() * h).toDouble();
              final size = math.Random(i + 200).nextDouble() * 2.5 + 0.5;
              final opacity = math.Random(i + 300).nextDouble() * 0.7 + 0.15;
              final delay = (i % 10) * 100;
              return Positioned(
                left: x,
                top: y,
                child: Container(
                  width: size,
                  height: size,
                  decoration: BoxDecoration(
                    color: starColor.withValues(alpha: opacity),
                    shape: BoxShape.circle,
                  ),
                ).animate(onPlay: (c) => c.repeat(reverse: true)).fadeIn(
                      duration: 600.ms,
                      delay: delay.ms,
                    ),
              );
            }),

            // ── Central galaxy glow ──
            Center(
              child: Container(
                width: w * 0.55,
                height: w * 0.55,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      Palette.green.withValues(alpha: 0.3 * data.overall + 0.1),
                      Palette.blue.withValues(alpha: 0.2 * data.overall),
                      Colors.transparent,
                    ],
                    radius: 1.0,
                  ),
                ),
              ).animate().scale(
                    duration: 2.seconds,
                    curve: Curves.easeInOut,
                  ),
            ),

            // ── Orbital ring (outer) ──
            Center(
              child: CustomPaint(
                size: Size(w * 0.8, w * 0.8),
                painter: _OrbitPainter(
                  progress: data.overall,
                  color: Palette.green,
                ),
              ),
            ),

            // ── Inner orbital ring ──
            Center(
              child: CustomPaint(
                size: Size(w * 0.5, w * 0.5),
                painter: _OrbitPainter(
                  progress: data.streakProgress,
                  color: Palette.blue,
                ),
              ),
            ),

            // ── Planet markers for each dimension ──
            _OrbitalPlanet(
              angle: data.xpProgress * math.pi * 2,
              radius: w * 0.4,
              label: 'XP',
              value: '${data.totalXp}',
              color: Palette.green,
            ),
            _OrbitalPlanet(
              angle: data.streakProgress * math.pi * 2,
              radius: w * 0.25,
              label: 'Streak',
              value: '${data.currentStreak}d',
              color: Palette.blue,
            ),
            _OrbitalPlanet(
              angle: data.missionProgress * math.pi * 2,
              radius: w * 0.4,
              label: 'Missions',
              value: '${(data.missionProgress * 100).toInt()}%',
              color: Palette.yellow,
            ),
            _OrbitalPlanet(
              angle: data.focusProgress * math.pi * 2,
              radius: w * 0.25,
              label: 'Focus',
              value: '${(data.focusProgress * 100).toInt()}h',
              color: Palette.purple,
            ),

            // ── Center label ──
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('🌟',
                      style: TextStyle(fontSize: w * 0.08)).animate().shimmer(
                          duration: 2.seconds, color: Colors.white),
                  const SizedBox(height: 4),
                  Text('${(data.overall * 100).toInt()}%',
                      style: TextStyle(
                        fontSize: w * 0.07,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      )),
                  Text('complete',
                      style: TextStyle(
                        fontSize: w * 0.035,
                        color: Colors.white70,
                      )),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }
}

class _OrbitalPlanet extends StatelessWidget {
  final double angle;
  final double radius;
  final String label;
  final String value;
  final Color color;

  const _OrbitalPlanet({
    required this.angle,
    required this.radius,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final x = radius * math.cos(angle);
    final y = radius * math.sin(angle);
    return LayoutBuilder(builder: (context, constraints) {
      final cx = constraints.maxWidth / 2;
      final cy = constraints.maxHeight / 2;
      return Positioned(
        left: cx + x - 22,
        top: cy + y - 22,
        child: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(colors: [color, color.withValues(alpha: 0.3)]),
            boxShadow: [
              BoxShadow(color: color.withValues(alpha: 0.4), blurRadius: 12),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(value,
                  style: const TextStyle(
                      fontSize: 9, fontWeight: FontWeight.w700, color: Colors.white)),
              Text(label,
                  style: const TextStyle(
                      fontSize: 7, color: Colors.white70)),
            ],
          ),
        ),
      );
    });
  }
}

class _OrbitPainter extends CustomPainter {
  final double progress;
  final Color color;

  _OrbitPainter({required this.progress, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // Draw full faint orbit
    final faintPaint = Paint()
      ..color = color.withValues(alpha: 0.08)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    canvas.drawCircle(center, radius, faintPaint);

    // Draw progress arc
    if (progress > 0) {
      final progressPaint = Paint()
        ..color = color.withValues(alpha: 0.6)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.5
        ..strokeCap = StrokeCap.round;
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        -math.pi / 2,
        progress * math.pi * 2,
        false,
        progressPaint,
      );
    }

    // Small dots along the orbit
    final dotPaint = Paint()..color = color.withValues(alpha: 0.3);
    for (var i = 0; i < 12; i++) {
      final a = (i / 12) * math.pi * 2 - math.pi / 2;
      final dx = center.dx + radius * math.cos(a);
      final dy = center.dy + radius * math.sin(a);
      canvas.drawCircle(Offset(dx, dy), 2, dotPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _OrbitPainter old) => old.progress != progress;
}
