import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:profileforge/ui/theme/app_theme.dart';

void main() {
  group('AppTheme Theme Data', () {
    testWidgets('light theme has correct primary color', (WidgetTester tester) async {
      final theme = AppTheme.lightTheme;
      expect(theme.colorScheme.primary, const Color(0xFF4338CA));
    });

    testWidgets('dark theme has correct primary color', (WidgetTester tester) async {
      final theme = AppTheme.darkTheme;
      expect(theme.colorScheme.primary, const Color(0xFF6366F1));
    });

    testWidgets('light theme scaffold background matches surfaceWhite', (WidgetTester tester) async {
      final theme = AppTheme.lightTheme;
      expect(theme.scaffoldBackgroundColor, AppTheme.surfaceWhite);
    });

    testWidgets('light theme text primary is defined', (WidgetTester tester) async {
      final theme = AppTheme.lightTheme;
      expect(theme.textTheme.bodyLarge?.color, isNotNull);
    });

    testWidgets('AppTheme category colors exist', (WidgetTester tester) async {
      expect(AppTheme.categoryColors.isNotEmpty, true);
      expect(AppTheme.categoryColors.containsKey('research'), true);
      expect(AppTheme.categoryColors.containsKey('engineering'), true);
    });

    testWidgets('spacing constants are properly ordered', (WidgetTester tester) async {
      expect(AppTheme.spacingXs < AppTheme.spacingSm, true);
      expect(AppTheme.spacingSm < AppTheme.spacingMd, true);
      expect(AppTheme.spacingMd < AppTheme.spacingLg, true);
      expect(AppTheme.spacingLg < AppTheme.spacingXl, true);
      expect(AppTheme.spacingXl < AppTheme.spacingXxl, true);
    });
  });
}
