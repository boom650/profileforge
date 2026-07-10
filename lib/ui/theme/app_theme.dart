import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // ── Forge-themed color palette ──────────────────────────────────────────
  // Primary: Deep Indigo — distinctive, NOT Tailwind blue
  static const Color primaryBlue = Color(0xFF4338CA);
  static const Color primaryBlueLight = Color(0xFF6366F1);
  // Secondary: Molten Amber — connects to "forge" metaphor
  static const Color accentGold = Color(0xFFF59E0B);
  static const Color accentSilver = Color(0xFFC0C0C0);
  static const Color accentBronze = Color(0xFFCD7F32);
  // Status colors
  static const Color successGreen = Color(0xFF059669); // Emerald
  static const Color errorRed = Color(0xFFE11D48); // Rose
  static const Color warningAmber = Color(0xFFD97706);
  // Surfaces — warm, not Tailwind defaults
  static const Color surfaceWhite = Color(0xFFFDF8F3); // Warm White
  static const Color surfaceLight = Color(0xFFFFFBF5); // Even warmer variant
  static const Color surfaceDark = Color(0xFF0F172A); // Deep Navy (dark mode bg)
  // Text colors
  static const Color textPrimary = Color(0xFF1E293B);
  static const Color textSecondary = Color(0xFF64748B);
  static const Color textMuted = Color(0xFF94A3B8);

  // ── Semantic aliases ────────────────────────────────────────────────────
  static const Color primary = Color(0xFF4338CA); // Deep Indigo
  static const Color secondary = Color(0xFFF59E0B); // Molten Amber
  static const Color accent = Color(0xFF7C3AED); // Electric Violet
  static const Color accentPurple = Color(0xFF7C3AED);
  static const Color success = Color(0xFF059669); // Emerald
  static const Color warning = Color(0xFFD97706); // Amber
  static const Color error = Color(0xFFE11D48); // Rose

  // ── Additional palette colors ───────────────────────────────────────────
  static const Color primaryPurple = Color(0xFF7C3AED); // Electric Violet
  static const Color accentOrange = Color(0xFFF97316);
  static const Color accentTeal = Color(0xFF14B8A6);
  
  // ── Additional palette colors (onboarding/category) ────────────────────
  static const Color categoryBlue = Color(0xFF4A90D9);    // Medium Blue
  static const Color categoryViolet = Color(0xFF8B5CF6);  // Violet
  static const Color categoryRed = Color(0xFFEF4444);     // Bright Red
  static const Color categoryEmerald = Color(0xFF10B981); // Emerald
  static const Color categoryPink = Color(0xFFEC4899);    // Pink

  // ── Spacing constants (8px base grid) ───────────────────────────────────
  static const double spacingXs = 4.0;
  static const double spacingSm = 8.0;
  static const double spacingMd = 16.0;
  static const double spacingLg = 24.0;
  static const double spacingXl = 32.0;
  static const double spacingXxl = 40.0; // Header spacing

  // ── Gradients ───────────────────────────────────────────────────────────
  static const LinearGradient gradientPrimary = LinearGradient(
    colors: [Color(0xFF4338CA), Color(0xFF7C3AED)], // Deep Indigo → Electric Violet
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  static const LinearGradient gradientGold = LinearGradient(
    colors: [Color(0xFFF59E0B), Color(0xFFD4AF37)], // Amber → Gold
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  static const LinearGradient gradientSuccess = LinearGradient(
    colors: [Color(0xFF14B8A6), Color(0xFF059669)], // Teal → Emerald
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  // Dark-mode variant of the primary gradient (muted, not harsh on dark bg)
  static const LinearGradient gradientPrimaryDark = LinearGradient(
    colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)], // Softer Indigo → Softer Violet
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // ── Category colors (distinctive, non-Tailwind) ────────────────────────
  static const Map<String, Color> categoryColors = {
    'clubs': Color(0xFF4338CA), // Deep Indigo
    'sports': Color(0xFFDC2626), // Ruby Red
    'arts': Color(0xFF7C3AED), // Electric Violet
    'competitions': Color(0xFFE11D48), // Rose
    'research': Color(0xFF0891B2), // Cyan
    'volunteering': Color(0xFFDB2777), // Pink
    'leadership': Color(0xFFD97706), // Amber
    'work': Color(0xFF4F46E5), // Indigo
    'courses': Color(0xFF059669), // Emerald
    'unique': Color(0xFFEA580C), // Orange
  };

  // ── Light theme ─────────────────────────────────────────────────────────
  static ThemeData get lightTheme {
    final base = ThemeData.light();
    return base.copyWith(
      colorScheme: const ColorScheme.light(
        primary: Color(0xFF4338CA), // Deep Indigo
        secondary: Color(0xFFF59E0B), // Molten Amber
        tertiary: Color(0xFF7C3AED), // Electric Violet
        surface: Color(0xFFFDF8F3), // Warm White
        error: Color(0xFFE11D48), // Rose
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: Color(0xFF1E293B),
        onError: Colors.white,
      ),
      textTheme: GoogleFonts.interTextTheme(base.textTheme).copyWith(
        displayLarge: GoogleFonts.inter(
          fontSize: 32,
          fontWeight: FontWeight.w700,
          color: textPrimary,
          letterSpacing: -0.5,
        ),
        displayMedium: GoogleFonts.inter(
          fontSize: 28,
          fontWeight: FontWeight.w600,
          color: textPrimary,
          letterSpacing: -0.3,
        ),
        displaySmall: GoogleFonts.inter(
          fontSize: 24,
          fontWeight: FontWeight.w600,
          color: textPrimary,
        ),
        headlineLarge: GoogleFonts.inter(
          fontSize: 22,
          fontWeight: FontWeight.w600,
          color: textPrimary,
        ),
        headlineMedium: GoogleFonts.inter(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: textPrimary,
        ),
        headlineSmall: GoogleFonts.inter(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: textPrimary,
        ),
        titleLarge: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: textPrimary,
        ),
        titleMedium: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: textPrimary,
        ),
        titleSmall: GoogleFonts.inter(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: textSecondary,
        ),
        bodyLarge: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: textPrimary,
        ),
        bodyMedium: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: textPrimary,
        ),
        bodySmall: GoogleFonts.inter(
          fontSize: 12,
          fontWeight: FontWeight.w400,
          color: textSecondary,
        ),
        labelLarge: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: textPrimary,
        ),
        labelMedium: GoogleFonts.inter(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: textSecondary,
        ),
        labelSmall: GoogleFonts.inter(
          fontSize: 10,
          fontWeight: FontWeight.w500,
          color: textMuted,
        ),
      ),
      appBarTheme: const AppBarTheme(
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: Color(0xFFFDF8F3),
        foregroundColor: Color(0xFF1E293B),
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: Color(0xFF1E293B),
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: Color(0xFFE2D5C8), width: 1),
        ),
        color: const Color(0xFFFDF8F3),
        shadowColor: Colors.black.withValues(alpha: 0.05),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: const Color(0xFF4338CA), // Deep Indigo
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: const Color(0xFF4338CA),
          side: const BorderSide(color: Color(0xFF4338CA), width: 1.5),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: const Color(0xFF4338CA),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          textStyle: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFFFFFBF5),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFE2D5C8)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFE2D5C8)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF4338CA), width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFE11D48)),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        hintStyle: GoogleFonts.inter(
          fontSize: 16,
          color: textMuted,
        ),
        labelStyle: GoogleFonts.inter(
          fontSize: 14,
          color: textSecondary,
        ),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        elevation: 8,
        backgroundColor: Color(0xFFFDF8F3),
        selectedItemColor: Color(0xFF4338CA),
        unselectedItemColor: Color(0xFF94A3B8),
        type: BottomNavigationBarType.fixed,
        selectedLabelStyle: TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
        unselectedLabelStyle: TextStyle(fontWeight: FontWeight.w400, fontSize: 12),
      ),
      navigationBarTheme: NavigationBarThemeData(
        height: 72,
        backgroundColor: const Color(0xFFFDF8F3),
        elevation: 8,
        indicatorColor: const Color(0xFF4338CA).withValues(alpha: 0.1),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return GoogleFonts.inter(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF4338CA),
            );
          }
          return GoogleFonts.inter(
            fontSize: 12,
            fontWeight: FontWeight.w400,
            color: const Color(0xFF94A3B8),
          );
        }),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: const Color(0xFFFFFBF5),
        selectedColor: const Color(0xFF4338CA).withValues(alpha: 0.1),
        labelStyle: GoogleFonts.inter(fontSize: 13, color: textPrimary),
        secondaryLabelStyle: GoogleFonts.inter(fontSize: 13, color: const Color(0xFF4338CA)),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        side: const BorderSide(color: Color(0xFFE2D5C8)),
      ),
      dividerTheme: const DividerThemeData(
        color: Color(0xFFE2D5C8),
        thickness: 1,
        space: 1,
      ),
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: Color(0xFF4338CA),
        linearTrackColor: Color(0xFFE2D5C8),
        circularTrackColor: Color(0xFFE2D5C8),
      ),
      sliderTheme: SliderThemeData(
        activeTrackColor: const Color(0xFF4338CA),
        inactiveTrackColor: const Color(0xFFE2D5C8),
        thumbColor: const Color(0xFF4338CA),
        overlayColor: const Color(0xFF4338CA).withValues(alpha: 0.1),
        valueIndicatorColor: const Color(0xFF4338CA),
        valueIndicatorTextStyle: GoogleFonts.inter(color: Colors.white, fontSize: 12),
      ),
      tabBarTheme: TabBarThemeData(
        labelColor: const Color(0xFF4338CA),
        unselectedLabelColor: const Color(0xFF94A3B8),
        indicatorColor: const Color(0xFF4338CA),
        indicatorSize: TabBarIndicatorSize.label,
        labelStyle: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600),
        unselectedLabelStyle: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w400),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: const Color(0xFF0F172A),
        contentTextStyle: GoogleFonts.inter(color: Colors.white, fontSize: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        behavior: SnackBarBehavior.floating,
        elevation: 8,
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: const Color(0xFFFDF8F3),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        titleTextStyle: GoogleFonts.inter(fontSize: 20, fontWeight: FontWeight.w600, color: const Color(0xFF1E293B)),
        contentTextStyle: GoogleFonts.inter(fontSize: 16, color: const Color(0xFF1E293B)),
      ),
    );
  }

  // ── Dark theme ──────────────────────────────────────────────────────────
  static ThemeData get darkTheme {
    final base = ThemeData.dark();
    return base.copyWith(
      colorScheme: const ColorScheme.dark(
        primary: Color(0xFF818CF8), // Lighter Indigo for dark mode
        secondary: Color(0xFFFBBF24), // Lighter Amber for dark mode
        tertiary: Color(0xFFA78BFA), // Lighter Violet for dark mode
        surface: Color(0xFF1E293B),
        error: Color(0xFFFDA4AF), // Lighter Rose for dark mode
        onPrimary: Color(0xFF0F172A),
        onSecondary: Color(0xFF0F172A),
        onSurface: Color(0xFFF1F5F9),
        onError: Color(0xFF0F172A),
      ),
      textTheme: GoogleFonts.interTextTheme(base.textTheme).apply(
        bodyColor: const Color(0xFFF1F5F9),
        displayColor: const Color(0xFFF1F5F9),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: Color(0xFF334155), width: 1),
        ),
        color: const Color(0xFF1E293B),
        shadowColor: Colors.black.withValues(alpha: 0.3),
      ),
      appBarTheme: const AppBarTheme(
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: Color(0xFF0F172A), // Deep Navy
        foregroundColor: Color(0xFFF1F5F9), // Light text
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: Color(0xFFF1F5F9),
        ),
        iconTheme: IconThemeData(color: Color(0xFFF1F5F9)),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: const Color(0xFFFBBF24), // Lighter Amber (secondaryGold) on dark bg
          foregroundColor: const Color(0xFF0F172A), // Dark text on gold button
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: const Color(0xFFF1F5F9), // White text
          side: const BorderSide(color: Color(0xFFF1F5F9), width: 1.5), // White border
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFF1E293B), // Dark fill
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF334155)), // Subtle dark border
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF334155)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF818CF8), width: 2), // Lighter indigo
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFFDA4AF)), // Lighter rose
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        hintStyle: GoogleFonts.inter(
          fontSize: 16,
          color: const Color(0xFF94A3B8), // Muted text
        ),
        labelStyle: GoogleFonts.inter(
          fontSize: 14,
          color: const Color(0xFF94A3B8),
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        height: 72,
        backgroundColor: const Color(0xFF0F172A), // Deep Navy
        elevation: 8,
        indicatorColor: const Color(0xFFFBBF24).withValues(alpha: 0.15), // Gold indicator on dark
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return GoogleFonts.inter(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: const Color(0xFFFBBF24), // Gold for selected
            );
          }
          return GoogleFonts.inter(
            fontSize: 12,
            fontWeight: FontWeight.w400,
            color: const Color(0xFF94A3B8), // Muted for unselected
          );
        }),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const IconThemeData(color: Color(0xFFFBBF24), size: 24);
          }
          return const IconThemeData(color: Color(0xFF94A3B8), size: 24);
        }),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: const Color(0xFF1E293B), // Dark surface
        selectedColor: const Color(0xFFFBBF24).withValues(alpha: 0.15), // Gold tint when selected
        labelStyle: GoogleFonts.inter(fontSize: 13, color: const Color(0xFFF1F5F9)),
        secondaryLabelStyle: GoogleFonts.inter(fontSize: 13, color: const Color(0xFFFBBF24)),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        side: const BorderSide(color: Color(0xFF334155)), // Subtle dark border
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: const Color(0xFF1E293B), // Dark background
        contentTextStyle: GoogleFonts.inter(color: Colors.white, fontSize: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        behavior: SnackBarBehavior.floating,
        elevation: 8,
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: const Color(0xFF1E293B), // Dark surface
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        titleTextStyle: GoogleFonts.inter(fontSize: 20, fontWeight: FontWeight.w600, color: const Color(0xFFF1F5F9)),
        contentTextStyle: GoogleFonts.inter(fontSize: 16, color: const Color(0xFFCBD5E1)),
      ),
      dividerTheme: const DividerThemeData(
        color: Color(0xFF334155), // Subtle dark divider
        thickness: 1,
        space: 1,
      ),
      tabBarTheme: TabBarThemeData(
        labelColor: const Color(0xFFFBBF24), // Gold for selected tab
        unselectedLabelColor: const Color(0xFF94A3B8), // Muted for unselected
        indicatorColor: const Color(0xFFFBBF24), // Gold indicator
        indicatorSize: TabBarIndicatorSize.label,
        labelStyle: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600),
        unselectedLabelStyle: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w400),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: const Color(0xFF818CF8), // Lighter indigo
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          textStyle: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: Color(0xFF818CF8), // Lighter indigo
        linearTrackColor: Color(0xFF334155),
        circularTrackColor: Color(0xFF334155),
      ),
      sliderTheme: SliderThemeData(
        activeTrackColor: const Color(0xFF818CF8), // Lighter indigo
        inactiveTrackColor: const Color(0xFF334155),
        thumbColor: const Color(0xFF818CF8),
        overlayColor: const Color(0xFF818CF8).withValues(alpha: 0.1),
        valueIndicatorColor: const Color(0xFF818CF8),
        valueIndicatorTextStyle: GoogleFonts.inter(color: Colors.white, fontSize: 12),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        elevation: 8,
        backgroundColor: Color(0xFF0F172A), // Deep Navy
        selectedItemColor: Color(0xFFFBBF24), // Gold selected
        unselectedItemColor: Color(0xFF94A3B8), // Muted unselected
        type: BottomNavigationBarType.fixed,
        selectedLabelStyle: TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
        unselectedLabelStyle: TextStyle(fontWeight: FontWeight.w400, fontSize: 12),
      ),
    );
  }
}

class AppColors {
  static const Map<String, Color> tierColors = {
    'tier1': Color(0xFFD4AF37), // Rich Gold
    'tier2': Color(0xFFC0C0C0), // Silver
    'tier3': Color(0xFFCD7F32), // Bronze
    'tier4': Color(0xFF6B7280), // Slate
  };

  static const Map<String, Color> categoryColors = {
    'clubs': Color(0xFF4338CA), // Deep Indigo
    'sports': Color(0xFFDC2626), // Ruby Red
    'arts': Color(0xFF7C3AED), // Electric Violet
    'competitions': Color(0xFFE11D48), // Rose
    'research': Color(0xFF0891B2), // Cyan
    'volunteering': Color(0xFFDB2777), // Pink
    'leadership': Color(0xFFD97706), // Amber
    'work': Color(0xFF4F46E5), // Indigo
    'courses': Color(0xFF059669), // Emerald
    'unique': Color(0xFFEA580C), // Orange
  };

  static const List<Color> gradientPrimary = [
    Color(0xFF4338CA), // Deep Indigo
    Color(0xFF7C3AED), // Electric Violet
  ];

  static const List<Color> gradientGold = [
    Color(0xFFF59E0B), // Amber
    Color(0xFFD4AF37), // Gold
  ];

  static const List<Color> gradientSuccess = [
    Color(0xFF14B8A6), // Teal
    Color(0xFF059669), // Emerald
  ];
}

extension ColorExtension on Color {
  Color withAlpha(int alpha) => withValues(alpha: alpha / 255);
}

/// Extension on BuildContext to provide theme-aware color accessors.
/// Use these instead of hardcoded AppTheme constants to support dark mode.
extension ThemeColors on BuildContext {
  ColorScheme get colorScheme => Theme.of(this).colorScheme;
  bool get isDarkMode => Theme.of(this).brightness == Brightness.dark;

  /// Surface background (warm white in light, dark navy in dark)
  Color get surfaceBg => colorScheme.surface;

  /// Slightly elevated surface (card backgrounds, containers)
  Color get surfaceElevated =>
      isDarkMode ? const Color(0xFF1E293B) : const Color(0xFFFDF8F3);

  /// Primary text color
  Color get textPrimary => colorScheme.onSurface;

  /// Secondary text color (subtitles, descriptions)
  Color get textSecondary => colorScheme.onSurface.withValues(alpha: 0.7);

  /// Muted text color (hints, timestamps)
  Color get textMuted => colorScheme.onSurface.withValues(alpha: 0.5);

  /// Border color for cards and dividers
  Color get borderColor =>
      isDarkMode ? const Color(0xFF334155) : const Color(0xFFE2D5C8);
}
