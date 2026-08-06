/// ────────────────────────────────────────────────────────────────────────────
/// ProfileForge String Utilities — Common string helpers.
/// ────────────────────────────────────────────────────────────────────────────
class PfString {
  PfString._();

  /// Capitalize first letter.
  static String capitalize(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1);
  }

  /// Title case.
  static String titleCase(String text) {
    return text.split(' ').map(capitalize).join(' ');
  }

  /// Truncate text with ellipsis.
  static String truncate(String text, int maxLength, {String suffix = '...'}) {
    if (text.length <= maxLength) return text;
    return '${text.substring(0, maxLength - suffix.length)}$suffix';
  }

  /// Remove all whitespace.
  static String removeWhitespace(String text) {
    return text.replaceAll(RegExp(r'\s+'), '');
  }

  /// Check if string is a valid email.
  static bool isEmail(String text) {
    final regex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return regex.hasMatch(text);
  }

  /// Check if string is a valid URL.
  static bool isUrl(String text) {
    final regex = RegExp(
      r'^https?:\/\/(www\.)?[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b([-a-zA-Z0-9()@:%_\+.~#?&//=]*)$',
    );
    return regex.hasMatch(text);
  }

  /// Extract initials from name.
  static String initials(String name, {int maxInitials = 2}) {
    final words = name.trim().split(RegExp(r'\s+'));
    final result = words
        .where((w) => w.isNotEmpty)
        .take(maxInitials)
        .map((w) => w[0].toUpperCase())
        .join();
    return result;
  }

  /// Pluralize a word.
  static String pluralize(String word, int count, {String suffix = 's'}) {
    return count == 1 ? word : '$word$suffix';
  }

  /// Format number with commas (e.g., 1,234,567).
  static String formatNumber(int number) {
    return number.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]},',
    );
  }

  /// Convert to slug (e.g., "Hello World" → "hello-world").
  static String slug(String text) {
    return text
        .toLowerCase()
        .replaceAll(RegExp(r'[^a-z0-9\s-]'), '')
        .replaceAll(RegExp(r'\s+'), '-')
        .replaceAll(RegExp(r'-+'), '-')
        .replaceAll(RegExp(r'^-|-$'), '');
  }

  /// Mask email for privacy (e.g., "u***@example.com").
  static String maskEmail(String email) {
    if (!email.contains('@')) return email;
    final parts = email.split('@');
    final name = parts[0];
    final domain = parts[1];
    if (name.length <= 2) return '${name[0]}***@$domain';
    return '${name[0]}***${name[name.length - 1]}@$domain';
  }

  /// Check if string contains only digits.
  static bool isNumeric(String text) {
    return RegExp(r'^\d+$').hasMatch(text);
  }

  /// Count words in text.
  static int wordCount(String text) {
    return text.trim().split(RegExp(r'\s+')).where((w) => w.isNotEmpty).length;
  }

  /// Count characters (excluding spaces).
  static int charCount(String text) {
    return text.replaceAll(RegExp(r'\s'), '').length;
  }

  /// Convert bytes to human-readable size.
  static String formatBytes(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    if (bytes < 1024 * 1024 * 1024) {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    }
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
  }

  /// Convert seconds to human-readable duration.
  static String formatDuration(int seconds) {
    if (seconds < 60) return '$seconds sec';
    if (seconds < 3600) {
      final min = seconds ~/ 60;
      final sec = seconds % 60;
      return sec > 0 ? '$min min $sec sec' : '$min min';
    }
    final hr = seconds ~/ 3600;
    final min = (seconds % 3600) ~/ 60;
    return '$hr hr $min min';
  }

  /// Check if string is a palindrome.
  static bool isPalindrome(String text) {
    final cleaned = text.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]'), '');
    return cleaned == cleaned.split('').reversed.join();
  }

  /// Reverse a string.
  static String reverse(String text) {
    return text.split('').reversed.join();
  }

  /// Count occurrences of a substring.
  static int countOccurrences(String text, String substring) {
    return RegExp(RegExp.escape(substring)).allMatches(text).length;
  }

  /// Strip HTML tags.
  static String stripHtml(String html) {
    return html.replaceAll(RegExp(r'<[^>]*>'), '');
  }

  /// Convert string to enum name.
  static String toEnumName(String text) {
    return text.split('_').map(capitalize).join();
  }
}
