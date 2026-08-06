import 'dart:math';

/// ────────────────────────────────────────────────────────────────────────────
/// ProfileForge Number Utilities — Common number helpers.
/// ────────────────────────────────────────────────────────────────────────────
class PfNumber {
  PfNumber._();

  /// Clamp a number between min and max.
  static double clamp(double value, double min, double max) {
    return value.clamp(min, max);
  }

  /// Linear interpolation between two values.
  static double lerp(double a, double b, double t) {
    return a + (b - a) * t;
  }

  /// Map a value from one range to another.
  static double mapRange(
    double value,
    double fromMin,
    double fromMax,
    double toMin,
    double toMax,
  ) {
    return toMin + (value - fromMin) * (toMax - toMin) / (fromMax - fromMin);
  }

  /// Round to N decimal places.
  static double roundTo(double value, int decimals) {
    final factor = pow(10, decimals).toDouble();
    return (value * factor).round() / factor;
  }

  /// Check if number is approximately equal to another.
  static bool approximately(double a, double b, {double epsilon = 0.001}) {
    return (a - b).abs() < epsilon;
  }

  /// Convert percentage to decimal.
  static double percentToDecimal(double percent) {
    return percent / 100;
  }

  /// Convert decimal to percentage.
  static double decimalToPercent(double decimal) {
    return decimal * 100;
  }

  /// Format number with commas (e.g., 1,234,567).
  static String withCommas(int number) {
    return number.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]},',
    );
  }

  /// Format as compact number (e.g., 1.2K, 3.4M).
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

  /// Format as ordinal (e.g., 1st, 2nd, 3rd).
  static String ordinal(int number) {
    if (number >= 11 && number <= 13) return '${number}th';
    switch (number % 10) {
      case 1: return '${number}st';
      case 2: return '${number}nd';
      case 3: return '${number}rd';
      default: return '${number}th';
    }
  }

  /// Generate random number in range.
  static int randomInt(int min, int max) {
    return min + Random().nextInt(max - min + 1);
  }

  /// Generate random double in range.
  static double randomDouble(double min, double max) {
    return min + Random().nextDouble() * (max - min);
  }

  /// Calculate percentage.
  static double percent(double value, double total) {
    if (total == 0) return 0;
    return (value / total) * 100;
  }

  /// Calculate difference as percentage.
  static double percentChange(double oldValue, double newValue) {
    if (oldValue == 0) return 0;
    return ((newValue - oldValue) / oldValue) * 100;
  }

  /// Normalize a value to 0-1 range.
  static double normalize(double value, double min, double max) {
    if (max == min) return 0;
    return (value - min) / (max - min);
  }

  /// Smooth step interpolation.
  static double smoothStep(double edge0, double edge1, double x) {
    final t = clamp((x - edge0) / (edge1 - edge0), 0, 1);
    return t * t * (3 - 2 * t);
  }

  /// Ease in cubic.
  static double easeInCubic(double t) {
    return t * t * t;
  }

  /// Ease out cubic.
  static double easeOutCubic(double t) {
    return 1 - pow(1 - t, 3).toDouble();
  }

  /// Ease in out cubic.
  static double easeInOutCubic(double t) {
    return t < 0.5
        ? 4 * t * t * t
        : 1 - pow(-2 * t + 2, 3).toDouble() / 2;
  }

  /// Snap to grid.
  static double snapToGrid(double value, double gridSize) {
    return (value / gridSize).round() * gridSize;
  }

  /// Wrap a number in a range.
  static double wrap(double value, double min, double max) {
    final range = max - min;
    return min + ((value - min) % range + range) % range;
  }
}
