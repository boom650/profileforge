import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// ────────────────────────────────────────────────────────────────────────────
/// DeepLinkHandler — Handles deep links and universal links.
///
/// Supports:
/// - profileforge://profile/{id}
/// - profileforge://chat
/// - profileforge://settings
/// - https://profileforge.app/profile/{id}
/// ────────────────────────────────────────────────────────────────────────────
class DeepLinkHandler {
  static DeepLinkHandler? _instance;
  static DeepLinkHandler get instance => _instance ??= DeepLinkHandler._();
  DeepLinkHandler._();

  /// Parse and handle a deep link.
  Future<void> handleDeepLink(String link, GoRouterState state, BuildContext context) async {
    final uri = Uri.parse(link);

    // Handle custom scheme: profileforge://
    if (uri.scheme == 'profileforge') {
      await _handleCustomScheme(uri, context);
      return;
    }

    // Handle HTTPS: profileforge.app/
    if (uri.scheme == 'https' && uri.host == 'profileforge.app') {
      await _handleHttpsLink(uri, context);
      return;
    }
  }

  Future<void> _handleCustomScheme(Uri uri, BuildContext context) async {
    final path = uri.path;
    final segments = path.split('/').where((s) => s.isNotEmpty).toList();

    if (segments.isEmpty) {
      // profileforge:// → home
      context.go('/home');
      return;
    }

    switch (segments[0]) {
      case 'profile':
        if (segments.length > 1) {
          // profileforge://profile/{id}
          context.push('/profile/${segments[1]}');
        } else {
          context.push('/profile');
        }
        break;

      case 'chat':
        context.push('/ai-chat');
        break;

      case 'settings':
        context.push('/settings');
        break;

      case 'score':
        if (segments.length > 1) {
          context.push('/profile-score/${segments[1]}');
        } else {
          context.push('/profile-score');
        }
        break;

      case 'onboarding':
        context.push('/psychology-onboarding');
        break;

      case 'achievements':
        context.push('/achievements');
        break;

      case 'stats':
        context.push('/stats');
        break;

      case 'search':
        context.push('/search');
        break;

      case 'notifications':
        context.push('/notifications');
        break;

      case 'help':
        context.push('/help');
        break;

      default:
        context.go('/home');
    }
  }

  Future<void> _handleHttpsLink(Uri uri, BuildContext context) async {
    final segments = uri.pathSegments.where((s) => s.isNotEmpty).toList();

    if (segments.isEmpty) {
      context.go('/home');
      return;
    }

    switch (segments[0]) {
      case 'profile':
        if (segments.length > 1) {
          context.push('/profile/${segments[1]}');
        } else {
          context.push('/profile');
        }
        break;

      case 'chat':
        context.push('/ai-chat');
        break;

      case 'settings':
        context.push('/settings');
        break;

      case 'score':
        if (segments.length > 1) {
          context.push('/profile-score/${segments[1]}');
        } else {
          context.push('/profile-score');
        }
        break;

      case 'onboarding':
        context.push('/psychology-onboarding');
        break;

      default:
        context.go('/home');
    }
  }

  /// Generate deep link for sharing.
  String generateLink(String route, {Map<String, String>? params}) {
    final buffer = StringBuffer('profileforge://');
    buffer.write(route);

    if (params != null && params.isNotEmpty) {
      buffer.write('/');
      buffer.write(params.values.join('/'));
    }

    return buffer.toString();
  }

  /// Generate shareable HTTPS link.
  String generateShareableLink(String route, {Map<String, String>? params}) {
    final buffer = StringBuffer('https://profileforge.app/');
    buffer.write(route);

    if (params != null && params.isNotEmpty) {
      buffer.write('/');
      buffer.write(params.values.join('/'));
    }

    return buffer.toString();
  }
}
