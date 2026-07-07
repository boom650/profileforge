// Centralized API configuration
// Single source of truth for all API URLs across the app.
//
// On Android emulator, use 10.0.2.2 instead of localhost.
// On a physical device, use the computer's local IP or a production URL.
// For production builds, replace with your actual backend URL.

import 'dart:io' show Platform;

/// Backend API base URL — all API calls should use this constant.
String get apiBaseUrl {
  // Platform-aware default
  if (Platform.isAndroid) {
    // 10.0.2.2 maps to host localhost on Android emulator
    return 'http://10.0.2.2:8080';
  }
  return 'http://localhost:8080';
}

/// For screens that need a static const (not available with getter).
/// Use this when const is required by the Dart language.
const String kApiBaseUrl = 'http://localhost:8080';
