/// Where the app should send the user after the splash animation —
/// decided from real first-run checks (onboarding flag + auth token).
enum SplashStatus {
  /// Onboarded and authenticated → home.
  fullySetUp,

  /// Onboarded but not signed up → auth prompt.
  needsAuth,

  /// New user → onboarding (Duolingo model: invest first, auth later).
  newUser,
}