import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter/services.dart';

/// Game-feel celebration helpers: confetti burst + floating "+XP" popup.
/// No external deps — confetti is a custom [CustomPainter].

final _rand = math.Random();

/// Show a transient confetti burst + optional center message.
void celebrate(
  BuildContext context, {
  String? message,
  Color color = const Color(0xFF58CC02),
}) {
  final overlay = Overlay.of(context);
  late final OverlayEntry entry;
  entry = OverlayEntry(
    builder: (_) => _CelebrateLayer(
      onDone: () => entry.remove(),
      message: message,
      color: color,
    ),
  );
  overlay.insert(entry);
  HapticFeedback.mediumImpact();
}

class _CelebrateLayer extends StatefulWidget {
  const _CelebrateLayer({
    required this.onDone,
    this.message,
    this.color = const Color(0xFF58CC02),
  });
  final VoidCallback onDone;
  final String? message;
  final Color color;

  @override
  State<_CelebrateLayer> createState() => _CelebrateLayerState();
}

class _CelebrateLayerState extends State<_CelebrateLayer>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl =
      AnimationController(vsync: this, duration: 1400.ms);
  final List<_Confetto> _pieces = [];

  @override
  void initState() {
    super.initState();
    const colors = [
      Color(0xFF58CC02),
      Color(0xFFFFC800),
      Color(0xFF1CB0F6),
      Color(0xFFFF4B4B),
      Color(0xFFCE82FF),
      Color(0xFFFF66C4),
    ];
    for (var i = 0; i < 90; i++) {
      _pieces.add(_Confetto(
        color: colors[_rand.nextInt(colors.length)],
        angle: -math.pi / 2 + (_rand.nextDouble() - 0.5) * 2.2,
        speed: 380 + _rand.nextDouble() * 360,
        spin: _rand.nextDouble() * 6,
        size: 8 + _rand.nextDouble() * 10,
        delay: _rand.nextDouble() * 0.15,
      ));
    }
    _ctrl.forward().whenComplete(widget.onDone);
    Future.delayed(1600.ms, widget.onDone);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: IgnorePointer(
            child: AnimatedBuilder(
              animation: _ctrl,
              builder: (_, __) => CustomPaint(
                painter: _ConfettiPainter(_ctrl.value, _pieces),
                child: const SizedBox.expand(),
              ),
            ),
          ),
        ),
        if (widget.message != null)
          Center(
            child: TweenAnimationBuilder<double>(
              tween: Tween(begin: 0.4, end: 1.0),
              duration: 500.ms,
              curve: Curves.elasticOut,
              builder: (_, v, __) => Opacity(
                opacity: v.clamp(0.0, 1.0),
                child: Transform.scale(
                  scale: v,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 14),
                    decoration: BoxDecoration(
                      color: widget.color,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.25),
                          blurRadius: 18,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Text(
                      widget.message!,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 26,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class _Confetto {
  _Confetto({
    required this.color,
    required this.angle,
    required this.speed,
    required this.spin,
    required this.size,
    required this.delay,
  });
  final Color color;
  final double angle;
  final double speed;
  final double spin;
  final double size;
  final double delay;
}

class _ConfettiPainter extends CustomPainter {
  _ConfettiPainter(this.progress, this.pieces);
  final double progress;
  final List<_Confetto> pieces;

  @override
  void paint(Canvas canvas, Size size) {
    final h = size.height;
    for (final p in pieces) {
      final t = ((progress - p.delay) / (1 - p.delay)).clamp(0.0, 1.0);
      if (t <= 0) continue;
      final dist = p.speed * t;
      final x = size.width / 2 + math.cos(p.angle) * dist;
      // gravity
      final y = h * 0.32 + math.sin(p.angle) * dist + 520 * t * t;
      final a = p.spin * t * 6;
      canvas.save();
      canvas.translate(x, y);
      canvas.rotate(a);
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromCenter(
              center: Offset.zero, width: p.size, height: p.size * 0.6),
          Radius.circular(p.size * 0.25),
        ),
        Paint()..color = p.color.withOpacity(1 - t * 0.3),
      );
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant _ConfettiPainter old) => true;
}

/// Floating "+N XP" pill that rises and fades.
void showXpPopup(BuildContext context, int xp, {int gems = 0}) {
  final overlay = Overlay.of(context);
  late final OverlayEntry entry;
  entry = OverlayEntry(
    builder: (_) => _XpPopup(
      xp: xp,
      gems: gems,
      onDone: () => entry.remove(),
    ),
  );
  overlay.insert(entry);
}

class _XpPopup extends StatefulWidget {
  const _XpPopup(
      {required this.xp, required this.gems, required this.onDone});
  final int xp;
  final int gems;
  final VoidCallback onDone;

  @override
  State<_XpPopup> createState() => _XpPopupState();
}

class _XpPopupState extends State<_XpPopup>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c =
      AnimationController(vsync: this, duration: 1100.ms);

  @override
  void initState() {
    super.initState();
    _c.forward();
    Future.delayed(1200.ms, widget.onDone);
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final top = MediaQuery.of(context).size.height * 0.4;
    return Positioned(
      left: 0,
      right: 0,
      top: top,
      child: IgnorePointer(
        child: AnimatedBuilder(
          animation: _c,
          builder: (_, __) => Transform.translate(
            offset: Offset(0, -40 * _c.value),
            child: Opacity(
              opacity: (1 - _c.value).clamp(0.0, 1.0),
              child: Center(
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFC800),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('+${widget.xp} XP',
                          style: const TextStyle(
                              fontWeight: FontWeight.w900,
                              fontSize: 20,
                              color: Colors.white)),
                      if (widget.gems > 0) ...[
                        const SizedBox(width: 8),
                        const Icon(Icons.diamond, color: Colors.white, size: 18),
                        Text('+${widget.gems}',
                            style: const TextStyle(
                                fontWeight: FontWeight.w900,
                                fontSize: 18,
                                color: Colors.white)),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
