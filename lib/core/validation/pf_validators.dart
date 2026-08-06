/// ────────────────────────────────────────────────────────────────────────────
/// ProfileForge Form Validation — Reusable validators.
/// ────────────────────────────────────────────────────────────────────────────
import 'package:flutter/material.dart';

/// Validate a field with a list of validators.
/// Returns the first error message or null if valid.
String? validate(String? value, List<FormFieldValidator<String>> validators) {
  for (final validator in validators) {
    final error = validator(value);
    if (error != null) return error;
  }
  return null;
}

/// Required field validator.
FormFieldValidator<String> requiredField([String? message]) {
  return (value) {
    if (value == null || value.trim().isEmpty) {
      return message ?? 'This field is required';
    }
    return null;
  };
}

/// Email validator.
FormFieldValidator<String> validateEmail([String? message]) {
  return (value) {
    if (value == null || value.trim().isEmpty) {
      return message ?? 'Email is required';
    }
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value.trim())) {
      return message ?? 'Please enter a valid email';
    }
    return null;
  };
}

/// Password validator with strength requirements.
FormFieldValidator<String> validatePassword({
  int minLength = 8,
  bool requireUppercase = true,
  bool requireLowercase = true,
  bool requireDigit = true,
  bool requireSpecialChar = false,
  String? message,
}) {
  return (value) {
    if (value == null || value.isEmpty) {
      return message ?? 'Password is required';
    }
    if (value.length < minLength) {
      return message ?? 'Password must be at least $minLength characters';
    }
    if (requireUppercase && !value.contains(RegExp(r'[A-Z]'))) {
      return message ?? 'Password must contain an uppercase letter';
    }
    if (requireLowercase && !value.contains(RegExp(r'[a-z]'))) {
      return message ?? 'Password must contain a lowercase letter';
    }
    if (requireDigit && !value.contains(RegExp(r'[0-9]'))) {
      return message ?? 'Password must contain a digit';
    }
    if (requireSpecialChar && !value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
      return message ?? 'Password must contain a special character';
    }
    return null;
  };
}

/// Confirm password validator.
FormFieldValidator<String> validateConfirmPassword(
  String password, {
  String? message,
}) {
  return (value) {
    if (value == null || value.isEmpty) {
      return message ?? 'Please confirm your password';
    }
    if (value != password) {
      return message ?? 'Passwords do not match';
    }
    return null;
  };
}

/// Phone number validator.
FormFieldValidator<String> validatePhone([String? message]) {
  return (value) {
    if (value == null || value.trim().isEmpty) {
      return null; // Phone is optional
    }
    final phoneRegex = RegExp(r'^\+?[0-9]{10,15}$');
    if (!phoneRegex.hasMatch(value.replaceAll(RegExp(r'[\s\-\(\)]'), ''))) {
      return message ?? 'Please enter a valid phone number';
    }
    return null;
  };
}

/// URL validator.
FormFieldValidator<String> validateUrl([String? message]) {
  return (value) {
    if (value == null || value.trim().isEmpty) {
      return null; // URL is optional
    }
    final urlRegex = RegExp(
      r'^https?:\/\/(www\.)?[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b([-a-zA-Z0-9()@:%_\+.~#?&//=]*)$',
    );
    if (!urlRegex.hasMatch(value.trim())) {
      return message ?? 'Please enter a valid URL';
    }
    return null;
  };
}

/// Min length validator.
FormFieldValidator<String> validateMinLength(int minLength, [String? message]) {
  return (value) {
    if (value == null || value.length < minLength) {
      return message ?? 'Must be at least $minLength characters';
    }
    return null;
  };
}

/// Max length validator.
FormFieldValidator<String> validateMaxLength(int maxLength, [String? message]) {
  return (value) {
    if (value != null && value.length > maxLength) {
      return message ?? 'Must be at most $maxLength characters';
    }
    return null;
  };
}

/// Name validator (letters, spaces, hyphens only).
FormFieldValidator<String> validateName([String? message]) {
  return (value) {
    if (value == null || value.trim().isEmpty) {
      return message ?? 'Name is required';
    }
    final nameRegex = RegExp(r'^[a-zA-Z\s\-]+$');
    if (!nameRegex.hasMatch(value.trim())) {
      return message ?? 'Name can only contain letters, spaces, and hyphens';
    }
    return null;
  };
}

/// GPA validator.
FormFieldValidator<String> validateGPA([String? message]) {
  return (value) {
    if (value == null || value.trim().isEmpty) {
      return null; // GPA is optional
    }
    final gpa = double.tryParse(value.trim());
    if (gpa == null || gpa < 0 || gpa > 4.0) {
      return message ?? 'GPA must be between 0.0 and 4.0';
    }
    return null;
  };
}

/// SAT score validator.
FormFieldValidator<String> validateSAT([String? message]) {
  return (value) {
    if (value == null || value.trim().isEmpty) {
      return null; // SAT is optional
    }
    final score = int.tryParse(value.trim());
    if (score == null || score < 400 || score > 1600) {
      return message ?? 'SAT score must be between 400 and 1600';
    }
    return null;
  };
}

/// ACT score validator.
FormFieldValidator<String> validateACT([String? message]) {
  return (value) {
    if (value == null || value.trim().isEmpty) {
      return null; // ACT is optional
    }
    final score = int.tryParse(value.trim());
    if (score == null || score < 1 || score > 36) {
      return message ?? 'ACT score must be between 1 and 36';
    }
    return null;
  };
}

/// Year validator.
FormFieldValidator<String> validateYear([String? message]) {
  return (value) {
    if (value == null || value.trim().isEmpty) {
      return null;
    }
    final year = int.tryParse(value.trim());
    if (year == null || year < 2020 || year > 2030) {
      return message ?? 'Please enter a valid year (2020-2030)';
    }
    return null;
  };
}

/// Combine multiple validators.
FormFieldValidator<String> compose(List<FormFieldValidator<String>> validators) {
  return (value) {
    for (final validator in validators) {
      final error = validator(value);
      if (error != null) return error;
    }
    return null;
  };
}
