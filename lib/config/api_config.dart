// Centralized API configuration
// Single source of truth for all API URLs across the app.
//
// On Android emulator, use 10.0.2.2 instead of localhost.
// On a physical device, use the computer's local IP or a production URL.
// For production builds, replace with your actual backend URL.
//
// Environment variables (set via --dart-define or platform-specific config):
// - API_BASE_URL: Backend API base URL (e.g., https://api.profileforge.app)
// - BRIDGE_URL: Hermes bridge URL (e.g., https://bridge.profileforge.app)

import 'dart:io' show Platform;

/// Backend API base URL — all API calls should use this constant.
String get apiBaseUrl {
  // 1. Check environment variable (set via --dart-define)
  const String envApiUrl = String.fromEnvironment('API_BASE_URL');
  if (envApiUrl.isNotEmpty) {
    return envApiUrl;
  }
  
  // 2. Platform-aware default (development only)
  if (Platform.isAndroid) {
    // 10.0.2.2 maps to host localhost on Android emulator
    return 'http://10.0.2.2:8080';
  }
  return 'http://localhost:8080';
}

/// Bridge URL for Hermes integration
String get bridgeUrl {
  const String envBridgeUrl = String.fromEnvironment('BRIDGE_URL');
  if (envBridgeUrl.isNotEmpty) {
    return envBridgeUrl;
  }
  
  if (Platform.isAndroid) {
    return 'http://10.0.2.2:8090';
  }
  return 'http://localhost:8090';
}

/// For screens that need a static const (not available with getter).
/// Use this when const is required by the Dart language.
/// Note: In production, use --dart-define=API_BASE_URL=https://your-api.com
const String kApiBaseUrl = String.fromEnvironment('API_BASE_URL', defaultValue: 'http://localhost:8080');
const String kBridgeUrl = String.fromEnvironment('BRIDGE_URL', defaultValue: 'http://localhost:8090');
