import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

const double _size = 1024;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await _render('/data/data/com.termux/files/home/workspace/assets/images/app_icon_foreground.png');
  exit(0);
}

void _drawOwl(Canvas canvas, double s) {
  final body = Paint()..color = const Color(0xFF58CC02);
  canvas.drawCircle(Offset(200 * s, 160 * s), 80 * s, body);

  for (final cx in [170.0, 230.0]) {
    canvas.drawCircle(Offset(cx * s, 140 * s), 18 * s, Paint()..color = Colors.white);
  }
  for (final cx in [170.0, 230.0]) {
    canvas.drawCircle(Offset(cx * s, 140 * s), 9 * s, Paint()..color = const Color(0xFF0F1419));
  }

  final smile = Path()
    ..moveTo(170 * s, 200 * s)
    ..quadraticBezierTo(200 * s, 230 * s, 230 * s, 200 * s);
  canvas.drawPath(
    smile,
    Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6 * s
      ..strokeCap = StrokeCap.round,
  );

  final beak = Path()
    ..moveTo(160 * s, 100 * s)
    ..lineTo(200 * s, 40 * s)
    ..lineTo(240 * s, 100 * s)
    ..close();
  canvas.drawPath(beak, Paint()..color = const Color(0xFFFFC800));
}

Future<void> _render(String outPath) async {
  final recorder = ui.PictureRecorder();
  final canvas = Canvas(recorder);
  final s = _size / 400.0 * 0.55;
  final offsetX = (_size - 400.0 * s) / 2;
  final offsetY = (_size - 320.0 * s) / 2;
  canvas.translate(offsetX, offsetY);
  _drawOwl(canvas, s);

  final picture = recorder.endRecording();
  final image = await picture.toImage(_size.toInt(), _size.toInt());
  final bytes = await image.toByteData(format: ui.ImageByteFormat.png);
  File(outPath).writeAsBytesSync(bytes!.buffer.asUint8List());
  stdout.writeln('wrote $outPath');
}