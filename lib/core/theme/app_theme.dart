import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// ────────────────────────────────────────────────────────────────────────────
/// ProfileForge v2 — Lusion-inspired premium dark identity.
/// Deep blue-black surfaces, electric blue + violet accents, glassmorphism.
/// Kills the Duolingo green clone. This is a premium admission tool.
/// ────────────────────────────────────────────────────────────────────────────

/// Brand palette — Lusion-inspired.
class Palette {
  const Palette._();

  // Core brand — electric blue family.
  static const primary = Color(0xFF3B82F6);       // Electric blue
  static const primaryLight = Color(0xFF60A5FA);   // Lighter blue
  static const primaryDark = Color(0xFF2563EB);    // Deeper blue
  static const primaryGlow = Color(0x403B82F6);    // Blue glow (25% opacity)

  // Accent — violet family.
  static const accent = Color(0xFF8B5CF6);         // Violet
  static const accentLight = Color(0xFFA78BFA);    // Light violet
  static const accentGlow = Color(0x408B5CF6);     // Violet glow

  // Semantic colors.
  static const success = Color(0xFF10B981);        // Emerald
  static const warning = Color(0xFFF59E0B);        // Gold/Amber
  static const error = Color(0xFFEF4444);          // Red
  static const info = Color(0xFF06B6D4);           // Cyan

  // Surfaces — Linear-inspired dark with blue tint (never pure black).
  static const black = Color(0xFF0A0A0B);          // Near-black (Linear-style)
  static const surface0 = Color(0xFF0F1629);       // Deepest surface
  static const surface1 = Color(0xFF151D33);       // Card surface
  static const surface2 = Color(0xFF1C2541);       // Elevated surface
  static const surface3 = Color(0xFF243052);       // Highest elevation
  static const border = Color(0xFF1E293B);         // Subtle border
  static const borderLight = Color(0xFF334155);    // Lighter border

  // Text — high contrast on dark.
  static const textPrimary = Color(0xFFF8FAFC);    // Almost white
  static const textSecondary = Color(0xFF94A3B8);  // Muted
  static const textTertiary = Color(0xFF64748B);   // Dimmer
  static const textInverse = Color(0xFF0F172A);    // Dark on light

  // Gradient presets.
  static const gradientPrimary = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primary, accent],
  );

  static const gradientSurface = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [surface0, black],
  );

  // ── Backward-compatible aliases (old Duolingo-green references) ──
  // These map the old green/blue/red/yellow/purple/orange Palette names
  // to the new Lusion-inspired palette so existing screens compile.
  static const green = Color(0xFF22C55E);   // Success green
  static const blue = primary;               // Electric blue
  static const red = Color(0xFFEF4444);     // Error red
  static const yellow = Color(0xFFFACC15);  // Warning gold
  static const purple = accent;              // Violet accent
  static const orange = Color(0xFFF97316);  // Orange
  static const gray = Palette.textSecondary;
  static const pink = Color(0xFFEC4899);     // Pink
  static const ink = Color(0xFF1E293B);       // Dark ink
  static const inkSurface = Color(0xFF334155); // Ink surface
  static const inkSurface2 = Color(0xFF475569); // Ink surface 2

  static const gradientCard = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [surface1, surface2],
  );

  static const gradientGold = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFF59E0B), Color(0xFFF97316)],
  );
}

/// Pillar accent colors (missions, skins).
const Map<String, Color> kPillarColors = {
  'academics': Color(0xFF3B82F6),   // Blue
  'leadership': Color(0xFF10B981),  // Emerald
  'research': Color(0xFF8B5CF6),    // Violet
  'creativity': Color(0xFFEC4899),  // Pink
  'community': Color(0xFFF97316),   // Orange
  'service': Color(0xFFEF4444),     // Red
  'sports': Color(0xFFF59E0B),      // Gold
  'personal': Color(0xFF06B6D4),    // Cyan
  'athletics': Color(0xFFEF4444),   // Red
  'character': Color(0xFF3B82F6),   // Blue
  'global': Color(0xFF8B5CF6),      // Violet
};

/// Rarity colors for skins / drops.
const Map<String, Color> kRarityColors = {
  'common': Color(0xFF64748B),     // Slate
  'rare': Color(0xFF3B82F6),       // Blue
  'epic': Color(0xFF8B5CF6),       // Violet
  'legendary': Color(0xFFF59E0B),  // Gold
  'mythic': Color(0xFFEF4444),     // Red
};

Color pillarColor(String pillar) =>
    kPillarColors[pillar.toLowerCase()] ?? Palette.primary;

Color rarityColor(String rarity) =>
    kRarityColors[rarity.toLowerCase()] ?? Palette.primary;

/// ── Typography ──────────────────────────────────────────────────────────────
TextTheme _buildTextTheme(Brightness brightness) {
  final base = GoogleFonts.interTextTheme(
    brightness == Brightness.dark
        ? ThemeData.dark().textTheme
        : ThemeData.light().textTheme,
  );

  final Color textColor =
      brightness == Brightness.dark ? Palette.textPrimary : Palette.textInverse;
  final Color secondaryColor =
      brightness == Brightness.dark ? Palette.textSecondary : Palette.textTertiary;

  return base.copyWith(
    displayLarge: base.displayLarge?.copyWith(
      color: textColor,
      fontWeight: FontWeight.w800,
      letterSpacing: -1.5,
      fontSize: 40,
    ),
    displayMedium: base.displayMedium?.copyWith(
      color: textColor,
      fontWeight: FontWeight.w700,
      letterSpacing: -1.0,
      fontSize: 34,
    ),
    displaySmall: base.displaySmall?.copyWith(
      color: textColor,
      fontWeight: FontWeight.w700,
      letterSpacing: -0.5,
      fontSize: 28,
    ),
    headlineLarge: base.headlineLarge?.copyWith(
      color: textColor,
      fontWeight: FontWeight.w700,
      letterSpacing: -0.5,
      fontSize: 26,
    ),
    headlineMedium: base.headlineMedium?.copyWith(
      color: textColor,
      fontWeight: FontWeight.w700,
      fontSize: 22,
    ),
    headlineSmall: base.headlineSmall?.copyWith(
      color: textColor,
      fontWeight: FontWeight.w600,
      fontSize: 20,
    ),
    titleLarge: base.titleLarge?.copyWith(
      color: textColor,
      fontWeight: FontWeight.w600,
      fontSize: 18,
    ),
    titleMedium: base.titleMedium?.copyWith(
      color: textColor,
      fontWeight: FontWeight.w600,
      fontSize: 16,
    ),
    titleSmall: base.titleSmall?.copyWith(
      color: secondaryColor,
      fontWeight: FontWeight.w500,
      fontSize: 14,
    ),
    bodyLarge: base.bodyLarge?.copyWith(
      color: textColor,
      fontWeight: FontWeight.w400,
      fontSize: 16,
      height: 1.5,
    ),
    bodyMedium: base.bodyMedium?.copyWith(
      color: textColor,
      fontWeight: FontWeight.w400,
      fontSize: 14,
      height: 1.5,
    ),
    bodySmall: base.bodySmall?.copyWith(
      color: secondaryColor,
      fontWeight: FontWeight.w400,
      fontSize: 12,
      height: 1.4,
    ),
    labelLarge: base.labelLarge?.copyWith(
      color: textColor,
      fontWeight: FontWeight.w600,
      fontSize: 14,
      letterSpacing: 0.5,
    ),
    labelMedium: base.labelMedium?.copyWith(
      color: secondaryColor,
      fontWeight: FontWeight.w500,
      fontSize: 12,
    ),
    labelSmall: base.labelSmall?.copyWith(
      color: secondaryColor,
      fontWeight: FontWeight.w500,
      fontSize: 11,
      letterSpacing: 0.5,
    ),
  );
}

/// ── Light Theme ─────────────────────────────────────────────────────────────
ThemeData lightTheme() {
  const surface = Color(0xFFF8FAFC);
  const card = Colors.white;
  const border = Color(0xFFE2E8F0);

  return ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorScheme: ColorScheme.fromSeed(
      seedColor: Palette.primary,
      brightness: Brightness.light,
      primary: Palette.primary,
      secondary: Palette.accent,
      surface: surface,
      onSurface: Palette.textInverse,
      error: Palette.error,
    ),
    scaffoldBackgroundColor: surface,
    textTheme: _buildTextTheme(Brightness.light),
    cardTheme: CardThemeData(
      elevation: 0,
      color: card,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: const BorderSide(color: border, width: 1),
      ),
      margin: EdgeInsets.zero,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: false,
      titleTextStyle: GoogleFonts.inter(
        fontSize: 20,
        fontWeight: FontWeight.w700,
        color: Palette.textInverse,
      ),
      iconTheme: const IconThemeData(color: Palette.textInverse),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Colors.white,
      selectedItemColor: Palette.primary,
      unselectedItemColor: Palette.textTertiary,
      showUnselectedLabels: true,
      type: BottomNavigationBarType.fixed,
      elevation: 0,
      selectedLabelStyle: TextStyle(fontWeight: FontWeight.w600, fontSize: 11),
      unselectedLabelStyle: TextStyle(fontWeight: FontWeight.w500, fontSize: 11),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Palette.primary,
        foregroundColor: Colors.white,
        elevation: 0,
        shadowColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        textStyle: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.2,
        ),
      ),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: Palette.primary,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        textStyle: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: Palette.primary,
        side: const BorderSide(color: Palette.primary, width: 1.5),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
        textStyle: GoogleFonts.inter(
          fontSize: 15,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
    chipTheme: ChipThemeData(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      labelStyle: GoogleFonts.inter(fontWeight: FontWeight.w500, fontSize: 13),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      side: const BorderSide(color: border),
      backgroundColor: surface,
      selectedColor: Palette.primary,
      checkmarkColor: Colors.white,
      labelStyle: TextStyle(
        color: Palette.textInverse,
        fontWeight: FontWeight.w500,
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: card,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: border),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Palette.primary, width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      hintStyle: GoogleFonts.inter(color: Palette.textTertiary, fontSize: 14),
    ),
    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: Palette.primary,
      linearTrackColor: border,
    ),
    dividerTheme: const DividerThemeData(
      color: border,
      thickness: 1,
      space: 0,
    ),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: Palette.surface3,
      contentTextStyle: GoogleFonts.inter(color: Colors.white, fontSize: 14),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      behavior: SnackBarBehavior.floating,
    ),
  );
}

/// ── Dark Theme ──────────────────────────────────────────────────────────────
ThemeData darkTheme() {
  return ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: ColorScheme.fromSeed(
      seedColor: Palette.primary,
      brightness: Brightness.dark,
      primary: Palette.primaryLight,
      secondary: Palette.accentLight,
      surface: Palette.surface1,
      onSurface: Palette.textPrimary,
      error: Palette.error,
      surfaceContainerHighest: Palette.surface3,
    ),
    scaffoldBackgroundColor: Palette.black,
    textTheme: _buildTextTheme(Brightness.dark),
    cardTheme: CardThemeData(
      elevation: 0,
      color: Palette.surface1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: const BorderSide(color: Palette.border, width: 1),
      ),
      margin: EdgeInsets.zero,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: false,
      titleTextStyle: GoogleFonts.inter(
        fontSize: 20,
        fontWeight: FontWeight.w700,
        color: Palette.textPrimary,
      ),
      iconTheme: const IconThemeData(color: Palette.textPrimary),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Palette.surface0,
      selectedItemColor: Palette.primaryLight,
      unselectedItemColor: Palette.textTertiary,
      showUnselectedLabels: true,
      type: BottomNavigationBarType.fixed,
      elevation: 0,
      selectedLabelStyle: TextStyle(fontWeight: FontWeight.w600, fontSize: 11),
      unselectedLabelStyle: TextStyle(fontWeight: FontWeight.w500, fontSize: 11),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Palette.primary,
        foregroundColor: Colors.white,
        elevation: 0,
        shadowColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        textStyle: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.2,
        ),
      ),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: Palette.primary,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        textStyle: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: Palette.primaryLight,
        side: const BorderSide(color: Palette.primary, width: 1.5),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
        textStyle: GoogleFonts.inter(
          fontSize: 15,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
    chipTheme: ChipThemeData(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      labelStyle: GoogleFonts.inter(fontWeight: FontWeight.w500, fontSize: 13),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      side: const BorderSide(color: Palette.border),
      backgroundColor: Palette.surface2,
      selectedColor: Palette.primary,
      checkmarkColor: Colors.white,
      labelStyle: const TextStyle(
        color: Palette.textPrimary,
        fontWeight: FontWeight.w500,
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Palette.surface1,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Palette.border),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Palette.border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Palette.primary, width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      hintStyle: GoogleFonts.inter(color: Palette.textTertiary, fontSize: 14),
    ),
    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: Palette.primary,
      linearTrackColor: Palette.surface3,
    ),
    dividerTheme: const DividerThemeData(
      color: Palette.border,
      thickness: 1,
      space: 0,
    ),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: Palette.surface3,
      contentTextStyle: GoogleFonts.inter(color: Colors.white, fontSize: 14),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      behavior: SnackBarBehavior.floating,
    ),
  );
}

/// ── Theme-mode persistence ──────────────────────────────────────────────────
enum AppThemeMode { system, light, dark }

final themeModeProvider = StateNotifierProvider<ThemeModeNotifier, AppThemeMode>(
  (ref) => ThemeModeNotifier(),
);

class ThemeModeNotifier extends StateNotifier<AppThemeMode> {
  ThemeModeNotifier() : super(AppThemeMode.system) {
    _load();
  }

  static const _key = 'profileforge.themeMode';

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final v = prefs.getString(_key);
    if (v != null) {
      state = AppThemeMode.values.firstWhere(
        (e) => e.name == v,
        orElse: () => AppThemeMode.system,
      );
    }
  }

  Future<void> set(AppThemeMode mode) async {
    state = mode;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, mode.name);
  }
}

/// Maps our enum to Flutter's [ThemeMode].
ThemeMode toFlutterThemeMode(AppThemeMode m) => switch (m) {
      AppThemeMode.light => ThemeMode.light,
      AppThemeMode.dark => ThemeMode.dark,
      AppThemeMode.system => ThemeMode.system,
    };

/// Convenience: is the active theme dark (resolves [system] via platform).
bool isDark(BuildContext context) =>
    Theme.of(context).brightness == Brightness.dark;
