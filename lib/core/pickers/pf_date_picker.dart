import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:profileforge/core/theme/app_theme.dart';

/// ────────────────────────────────────────────────────────────────────────────
/// ProfileForge Date Picker — Premium date selection dialogs.
/// ────────────────────────────────────────────────────────────────────────────
class PfDatePicker {
  PfDatePicker._();

  /// Show a premium date picker.
  static Future<DateTime?> show(
    BuildContext context, {
    DateTime? initialDate,
    DateTime? firstDate,
    DateTime? lastDate,
    String? title,
  }) {
    final dark = Theme.of(context).brightness == Brightness.dark;

    return showDatePicker(
      context: context,
      initialDate: initialDate ?? DateTime.now(),
      firstDate: firstDate ?? DateTime(2000),
      lastDate: lastDate ?? DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.dark(
              primary: Palette.primary,
              onPrimary: Colors.white,
              surface: dark ? Palette.surface1 : Colors.white,
              onSurface: dark ? Palette.textPrimary : Palette.textInverse,
            ),
            dialogBackgroundColor: dark ? Palette.surface1 : Colors.white,
          ),
          child: child!,
        );
      },
    );
  }

  /// Show a year picker.
  static Future<int?> showYear(
    BuildContext context, {
    int? initialYear,
    int firstYear = 2000,
    int lastYear = 2030,
  }) async {
    final date = await show(
      context,
      initialDate: DateTime(initialYear ?? DateTime.now().year),
      firstDate: DateTime(firstYear),
      lastDate: DateTime(lastYear),
    );
    return date?.year;
  }

  /// Show a month picker.
  static Future<DateTime?> showMonth(
    BuildContext context, {
    DateTime? initialDate,
  }) async {
    return showDatePicker(
      context: context,
      initialDate: initialDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2030),
    );
  }
}

/// PfTimePicker — Premium time selection dialog.
class PfTimePicker {
  PfTimePicker._();

  /// Show a premium time picker.
  static Future<TimeOfDay?> show(
    BuildContext context, {
    TimeOfDay? initialTime,
  }) {
    final dark = Theme.of(context).brightness == Brightness.dark;

    return showTimePicker(
      context: context,
      initialTime: initialTime ?? TimeOfDay.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.dark(
              primary: Palette.primary,
              onPrimary: Colors.white,
              surface: dark ? Palette.surface1 : Colors.white,
              onSurface: dark ? Palette.textPrimary : Palette.textInverse,
            ),
          ),
          child: child!,
        );
      },
    );
  }
}

/// PfDateRangePicker — Premium date range selection.
class PfDateRangePicker {
  PfDateRangePicker._();

  /// Show a premium date range picker.
  static Future<DateTimeRange?> show(
    BuildContext context, {
    DateTimeRange? initialRange,
    DateTime? firstDate,
    DateTime? lastDate,
  }) {
    return showDateRangePicker(
      context: context,
      initialDateRange: initialRange,
      firstDate: firstDate ?? DateTime(2000),
      lastDate: lastDate ?? DateTime(2030),
      builder: (context, child) {
        final dark = Theme.of(context).brightness == Brightness.dark;
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.dark(
              primary: Palette.primary,
              onPrimary: Colors.white,
              surface: dark ? Palette.surface1 : Colors.white,
              onSurface: dark ? Palette.textPrimary : Palette.textInverse,
            ),
          ),
          child: child!,
        );
      },
    );
  }
}
