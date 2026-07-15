import 'package:flutter/material.dart';
import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:profileforge/ui/theme/app_theme.dart';

void main() {
  group('AppTheme', () {
    testWidgets('primary color is defined', (WidgetTester tester) async {
      expect(AppTheme.primaryBlue, isA<Color>());
    });

    testWidgets('AppTheme has spacing constants', (WidgetTester tester) async {
      expect(AppTheme.spacingXs, isA<double>());
      expect(AppTheme.spacingSm, isA<double>());
      expect(AppTheme.spacingMd, isA<double>());
      expect(AppTheme.spacingLg, isA<double>());
      expect(AppTheme.spacingXl, isA<double>());
      expect(AppTheme.spacingXxl, isA<double>());
    });

    testWidgets('textMuted meets WCAG AA contrast on scaffold', (WidgetTester tester) async {
      // AA requires 4.5:1 for normal text
      final contrast = _contrastRatio(AppTheme.textMuted, AppTheme.surfaceWhite);
      expect(contrast, greaterThanOrEqualTo(4.5));
    });

    testWidgets('accentGold meets WCAG AA contrast on scaffold', (WidgetTester tester) async {
      final contrast = _contrastRatio(AppTheme.accentGold, AppTheme.surfaceWhite);
      expect(contrast, greaterThanOrEqualTo(3.0)); // Large text threshold
    });

    testWidgets('errorRed meets WCAG AA contrast on scaffold', (WidgetTester tester) async {
      final contrast = _contrastRatio(AppTheme.errorRed, AppTheme.surfaceWhite);
      expect(contrast, greaterThanOrEqualTo(4.5));
    });

    testWidgets('successGreen meets WCAG AA contrast on scaffold', (WidgetTester tester) async {
      final contrast = _contrastRatio(AppTheme.successGreen, AppTheme.surfaceWhite);
      expect(contrast, greaterThanOrEqualTo(4.5));
    });
  });
}

/// Calculate relative luminance per WCAG
double _relativeLuminance(Color color) {
  double f(double c) {
    c /= 255;
    return (c <= 0.03928 ? c / 12.92 : pow((c + 0.055) / 1.055, 2.4)) as double;
  }
  final r = f(color.red.toDouble());
  final g = f(color.green.toDouble());
  final b = f(color.blue.toDouble());
  return 0.2126 * r + 0.7152 * g + 0.0722 * b;
}

double _contrastRatio(Color fg, Color bg) {
  final l1 = _relativeLuminance(fg);
  final l2 = _relativeLuminance(bg);
  final lighter = [l1, l2].reduce((a, b) => a > b ? a : b);
  final darker = [l1, l2].reduce((a, b) => a < b ? a : b);
  return (lighter + 0.05) / (darker + 0.05);
}
