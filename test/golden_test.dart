import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// Small deterministic widgets exercised by golden tests.
/// Kept dependency-free so the goldens stay stable across platforms.
class _Badge extends StatelessWidget {
  const _Badge(this.label, {this.color = const Color(0xFF6750A4)});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        label,
        style: const TextStyle(color: Colors.white, fontSize: 12),
      ),
    );
  }
}

class _ProgressRow extends StatelessWidget {
  const _ProgressRow({this.pct = 0.62});

  final double pct;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: LinearProgressIndicator(
            value: pct,
            minHeight: 8,
            backgroundColor: const Color(0xFFE6E0E9),
            color: const Color(0xFF6750A4),
          ),
        ),
        const SizedBox(width: 8),
        Text('${(pct * 100).round()}%'),
      ],
    );
  }
}

void main() {
  testWidgets('golden: badge renders pill with label', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: Center(child: _Badge('First win')),
        ),
      ),
    );
    await expectLater(
      find.byType(_Badge),
      matchesGoldenFile('goldens/badge.png'),
    );
  });

  testWidgets('golden: progress row renders proportionally', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: Padding(
            padding: EdgeInsets.all(16),
            child: _ProgressRow(pct: 0.62),
          ),
        ),
      ),
    );
    await expectLater(
      find.byType(_ProgressRow),
      matchesGoldenFile('goldens/progress_row.png'),
    );
  });
}