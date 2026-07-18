import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'profile_model.dart';

/// Exports the current profile to a PDF file (on-device, offline).
/// Research basis: 'pdf' Dart lib (repos2/ related), ReportLab/WeasyPrint off-device note.
final pdfExportProvider = FutureProvider.family<String, Profile>((ref, profile) async {
  final pdf = pw.Document();
  pdf.addPage(
    pw.Page(
      build: (ctx) => pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Header(level: 0, child: pw.Text('ProfileForge — ${profile.name}')),
          pw.SizedBox(height: 12),
          pw.Text('Goal: ${profile.goal.isNotEmpty ? profile.goal : '—'}'),
          pw.SizedBox(height: 8),
          pw.Text('XP: ${profile.xp}'),
          pw.SizedBox(height: 16),
          pw.Text('Achievements', style: const pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold)),
          pw.SizedBox(height: 6),
          ...profile.achievements.map((a) => pw.Bullet(text: a)),
          if (profile.achievements.isEmpty) pw.Text('No achievements yet.'),
        ],
      ),
    ),
  );
  final dir = await getApplicationDocumentsDirectory();
  final file = File('${dir.path}/profile_${DateTime.now().millisecondsSinceEpoch}.pdf');
  await file.writeAsBytes(await pdf.save());
  return file.path;
});
