/// Auth domain — the user's real sign-in state on this device.
library;

/// The actual auth states the app decides between (see SplashScreen routing
/// and the guest/email flows): a guest, an email-verified user, or neither.
enum AuthStatus {
  /// No session decision has been made yet.
  unknown,

  /// Fresh user — not a guest, no magic-link token.
  unauthenticated,

  /// Chose "maybe later" — progress stays on-device.
  guest,

  /// Magic-link email verified (token present).
  authenticated,
}

/// The signed-in user as stored on device (SharedPreferences).
class AuthUser {
  final String? email;
  final bool isGuest;
  final String? token;

  const AuthUser({this.email, this.isGuest = false, this.token});

  AuthStatus get status {
    if (isGuest) return AuthStatus.guest;
    if (token != null && token!.isNotEmpty) return AuthStatus.authenticated;
    return AuthStatus.unauthenticated;
  }
}