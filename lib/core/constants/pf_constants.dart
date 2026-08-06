/// ────────────────────────────────────────────────────────────────────────────
/// ProfileForge Constants — App-wide constants.
/// ────────────────────────────────────────────────────────────────────────────

class PfConstants {
  PfConstants._();

  // ════════════════════════════════════════════════════════════════════════════
  // APP INFO
  // ════════════════════════════════════════════════════════════════════════════

  static const String appName = 'ProfileForge';
  static const String appVersion = '1.0.0';
  static const String appBuildNumber = '1';
  static const String appDescription = 'AI Admissions Architect';

  // ════════════════════════════════════════════════════════════════════════════
  // API
  // ════════════════════════════════════════════════════════════════════════════

  static const String apiBaseUrl = 'https://api.profileforge.app';
  static const Duration apiTimeout = Duration(seconds: 30);
  static const int apiMaxRetries = 3;

  // ════════════════════════════════════════════════════════════════════════════
  // CACHE
  // ════════════════════════════════════════════════════════════════════════════

  static const Duration cacheExpiry = Duration(hours: 24);
  static const int maxCacheSize = 100 * 1024 * 1024; // 100MB

  // ════════════════════════════════════════════════════════════════════════════
  // SCORES
  // ════════════════════════════════════════════════════════════════════════════

  static const int minScore = 0;
  static const int maxScore = 100;
  static const int excellentThreshold = 80;
  static const int goodThreshold = 60;
  static const int fairThreshold = 40;

  // ════════════════════════════════════════════════════════════════════════════
  // LIMITS
  // ════════════════════════════════════════════════════════════════════════════

  static const int maxNameLength = 100;
  static const int maxBioLength = 500;
  static const int maxActivities = 20;
  static const int maxSchools = 10;
  static const int maxEssays = 5;

  // ════════════════════════════════════════════════════════════════════════════
  // ANIMATION
  // ════════════════════════════════════════════════════════════════════════════

  static const Duration animationFast = Duration(milliseconds: 150);
  static const Duration animationNormal = Duration(milliseconds: 300);
  static const Duration animationSlow = Duration(milliseconds: 500);
  static const Duration animationVerySlow = Duration(milliseconds: 800);

  // ════════════════════════════════════════════════════════════════════════════
  // DEBOUNCE
  // ════════════════════════════════════════════════════════════════════════════

  static const Duration searchDebounce = Duration(milliseconds: 300);
  static const Duration saveDebounce = Duration(milliseconds: 500);
  static const Duration refreshDebounce = Duration(seconds: 2);

  // ════════════════════════════════════════════════════════════════════════════
  // STORAGE KEYS
  // ════════════════════════════════════════════════════════════════════════════

  static const String keyThemeMode = 'theme_mode';
  static const String keyOnboardingComplete = 'onboarding_complete';
  static const String keyLastLogin = 'last_login';
  static const String keyUserId = 'user_id';
  static const String keyUserName = 'user_name';
  static const String keyUserEmail = 'user_email';
  static const String keyApiKey = 'api_key';

  // ════════════════════════════════════════════════════════════════════════════
  // URLS
  // ════════════════════════════════════════════════════════════════════════════

  static const String privacyPolicyUrl = 'https://profileforge.app/privacy';
  static const String termsOfServiceUrl = 'https://profileforge.app/terms';
  static const String supportUrl = 'https://profileforge.app/support';
  static const String feedbackUrl = 'https://profileforge.app/feedback';

  // ════════════════════════════════════════════════════════════════════════════
  // ROUTES
  // ════════════════════════════════════════════════════════════════════════════

  static const String routeHome = '/home';
  static const String routeProfile = '/profile';
  static const String routeSettings = '/settings';
  static const String routeOnboarding = '/onboarding';
  static const String routePsychologyOnboarding = '/psychology-onboarding';
  static const String routeAiChat = '/enhanced-ai-chat';
  static const String routeApiKeySetup = '/api-key-setup';
  static const String routeSearch = '/search';
  static const String routeNotifications = '/notifications';
  static const String routeHelp = '/help';
  static const String routeShare = '/share';
  static const String routeAchievements = '/achievements';
  static const String routeStats = '/stats';
  static const String routeCompare = '/compare';
}
