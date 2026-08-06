/// ────────────────────────────────────────────────────────────────────────────
/// ProfileForge Formatters — Input and display formatters.
/// ────────────────────────────────────────────────────────────────────────────
import 'package:intl/intl.dart';

class PfFormat {
  PfFormat._();

  /// Format currency (e.g., $1,234.56).
  static String currency(double amount, {String symbol = '\$', int decimals = 2}) {
    final format = NumberFormat.currency(
      symbol: symbol,
      decimalDigits: decimals,
    );
    return format.format(amount);
  }

  /// Format number with commas (e.g., 1,234,567).
  static String number(int value) {
    final format = NumberFormat('#,##0');
    return format.format(value);
  }

  /// Format decimal number.
  static String decimal(double value, {int decimals = 1}) {
    final format = NumberFormat.decimalPattern()
      ..maximumFractionDigits = decimals;
    return format.format(value);
  }

  /// Format percentage.
  static String percent(double value, {int decimals = 1}) {
    return '${value.toStringAsFixed(decimals)}%';
  }

  /// Format file size.
  static String fileSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    if (bytes < 1024 * 1024 * 1024) {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    }
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
  }

  /// Format duration (e.g., "2h 30m").
  static String duration(Duration d) {
    final hours = d.inHours;
    final minutes = d.inMinutes.remainder(60);
    final seconds = d.inSeconds.remainder(60);

    if (hours > 0) return '${hours}h ${minutes}m';
    if (minutes > 0) return '${minutes}m ${seconds}s';
    return '${seconds}s';
  }

  /// Format duration in HH:MM:SS.
  static String durationPrecise(Duration d) {
    final hours = d.inHours.toString().padLeft(2, '0');
    final minutes = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$hours:$minutes:$seconds';
  }

  /// Format phone number (e.g., (555) 123-4567).
  static String phone(String number) {
    final digits = number.replaceAll(RegExp(r'\D'), '');
    if (digits.length == 10) {
      return '(${digits.substring(0, 3)}) ${digits.substring(3, 6)}-${digits.substring(6)}';
    }
    if (digits.length == 11 && digits.startsWith('1')) {
      return '+1 (${digits.substring(1, 4)}) ${digits.substring(4, 7)}-${digits.substring(7)}';
    }
    return number;
  }

  /// Format SSN (e.g., ***-**-1234).
  static String ssn(String number, {bool mask = true}) {
    final digits = number.replaceAll(RegExp(r'\D'), '');
    if (digits.length != 9) return number;
    if (mask) return '***-**-${digits.substring(5)}';
    return '${digits.substring(0, 3)}-${digits.substring(3, 5)}-${digits.substring(5)}';
  }

  /// Format credit card (e.g., 4242 4242 4242 4242).
  static String creditCard(String number) {
    final digits = number.replaceAll(RegExp(r'\D'), '');
    final buffer = StringBuffer();
    for (int i = 0; i < digits.length; i++) {
      if (i > 0 && i % 4 == 0) buffer.write(' ');
      buffer.write(digits[i]);
    }
    return buffer.toString();
  }

  /// Format GPA (e.g., 3.85).
  static String gpa(double value) => value.toStringAsFixed(2);

  /// Format SAT score (e.g., 1,450).
  static String sat(int score) => number(score);

  /// Format ACT score.
  static String act(int score) => '$score';

  /// Format ordinal (e.g., 1st, 2nd, 3rd).
  static String ordinal(int number) {
    if (number >= 11 && number <= 13) return '${number}th';
    switch (number % 10) {
      case 1: return '${number}st';
      case 2: return '${number}nd';
      case 3: return '${number}rd';
      default: return '${number}th';
    }
  }

  /// Format compact number (e.g., 1.2K, 3.4M).
  static String compact(int number) {
    if (number >= 1000000000) {
      return '${(number / 1000000000).toStringAsFixed(1)}B';
    }
    if (number >= 1000000) {
      return '${(number / 1000000).toStringAsFixed(1)}M';
    }
    if (number >= 1000) {
      return '${(number / 1000).toStringAsFixed(1)}K';
    }
    return number.toString();
  }
}
