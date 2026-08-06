/// ────────────────────────────────────────────────────────────────────────────
/// ProfileForge Validation Constants — Regex patterns and validation rules.
/// ────────────────────────────────────────────────────────────────────────────
class PfValidation {
  PfValidation._();

  // ════════════════════════════════════════════════════════════════════════════
  // REGEX PATTERNS
  // ════════════════════════════════════════════════════════════════════════════

  static final RegExp email = RegExp(
    r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
  );

  static final RegExp phone = RegExp(
    r'^\+?[0-9]{10,15}$',
  );

  static final RegExp url = RegExp(
    r'^https?:\/\/(www\.)?[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b([-a-zA-Z0-9()@:%_\+.~#?&//=]*)$',
  );

  static final RegExp numeric = RegExp(r'^[0-9]+$');

  static final RegExp alpha = RegExp(r'^[a-zA-Z]+$');

  static final RegExp alphaNumeric = RegExp(r'^[a-zA-Z0-9]+$');

  static final RegExp alphaNumericWithSpaces = RegExp(r'^[a-zA-Z0-9\s]+$');

  static final RegExp name = RegExp(r'^[a-zA-Z\s\-]+$');

  static final RegExp strongPassword = RegExp(
    r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$',
  );

  static final RegExp mediumPassword = RegExp(
    r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)[A-Za-z\d]{6,}$',
  );

  static final RegExp hexColor = RegExp(
    r'^#?([0-9A-Fa-f]{3}|[0-9A-Fa-f]{6})$',
  );

  static final RegExp ipv4 = RegExp(
    r'^((25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$',
  );

  // ════════════════════════════════════════════════════════════════════════════
  // VALIDATION RULES
  // ════════════════════════════════════════════════════════════════════════════

  static const int minPasswordLength = 8;
  static const int maxPasswordLength = 128;
  static const int minNameLength = 2;
  static const int maxNameLength = 100;
  static const int maxBioLength = 500;
  static const int maxEmailLength = 254;

  // ════════════════════════════════════════════════════════════════════════════
  // PASSWORD STRENGTH
  // ════════════════════════════════════════════════════════════════════════════

  /// Check password strength.
  static PasswordStrength checkPasswordStrength(String password) {
    int score = 0;

    if (password.length >= 8) score++;
    if (password.length >= 12) score++;
    if (password.contains(RegExp(r'[a-z]'))) score++;
    if (password.contains(RegExp(r'[A-Z]'))) score++;
    if (password.contains(RegExp(r'[0-9]'))) score++;
    if (password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) score++;

    if (score <= 2) return PasswordStrength.weak;
    if (score <= 4) return PasswordStrength.medium;
    return PasswordStrength.strong;
  }

  /// Get password strength description.
  static String getPasswordStrengthText(PasswordStrength strength) {
    switch (strength) {
      case PasswordStrength.weak:
        return 'Weak';
      case PasswordStrength.medium:
        return 'Medium';
      case PasswordStrength.strong:
        return 'Strong';
    }
  }
}

enum PasswordStrength { weak, medium, strong }
