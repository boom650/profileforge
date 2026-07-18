import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:profileforge/features/profile/domain/profile.dart';

/// Offline PDF export of a profile. No network, runs on-device.
Future<String> exportProfilePdf(Profile profile) async {
  final pdf = pw.Document();
  pdf.addPage(
    pw.Page(
      build: (ctx) => pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Header(level: 0, child: pw.Text('ProfileForge — ${profile.name}')),
          pw.SizedBox(height: 12),
          pw.Text('Goal: ${profile.goal.isNotEmpty ? profile.goal : '—'}'),
          pw.SizedBox(height: 16),
          pw.Text('Achievements',
              style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold)),
          pw.SizedBox(height: 6),
          ...profile.achievements.map((a) => pw.Bullet(text: a)),
          if (profile.achievements.isEmpty) pw.Text('No achievements yet.'),
        ],
      ),
    ),
  );
  final dir = await getApplicationDocumentsDirectory();
  final file =
      File('${dir.path}/profile_${profile.id}.pdf');
  await file.writeAsBytes(await pdf.save());
  return file.path;
}
