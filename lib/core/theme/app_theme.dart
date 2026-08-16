import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// ────────────────────────────────────────────────────────────────────────────
/// ProfileForge v3 — "Warm Bloom" identity.
/// Warm poppy clay canvas: cream not white, berry-amber accents, cosy surfaces,
/// Fredoka display + Nunito body. See DESIGN.md for the full token spec.
/// ────────────────────────────────────────────────────────────────────────────

/// Brand palette — Warm Bloom. All legacy alias names are preserved so
/// existing screens keep compiling against the new warm values.
class Palette {
  const Palette._();

  // Core brand — poppy berry.
  static const primary = Color(0xFFE85D3D);       // Poppy berry
  static const primaryLight = Color(0xFFF07A5C);  // Lighter berry
  static const primaryDark = Color(0xFFC2421F);   // Deeper berry
  static const primaryGlow = Color(0x33E85D3D);   // Berry glow (20%)

  // Accent — warm amber (streaks, rewards).
  static const accent = Color(0xFFF2A03D);        // Warm amber
  static const accentLight = Color(0xFFF7B861);   // Lighter amber
  static const accentGlow = Color(0x33F2A03D);    // Amber glow

  // Semantic colors (quarantined to their meaning).
  static const success = Color(0xFF4FA36B);       // Habit sage
  static const warning = Color(0xFFF2A03D);       // Warm amber
  static const error = Color(0xFFD64545);         // Tomato
  static const info = Color(0xFF4C9BD6);          // Warm sky

  // Surfaces — warm espresso ladder (dark mode), never blue-black.
  static const black = Color(0xFF241813);         // Warm near-black
  static const surface0 = Color(0xFF2B1D17);      // Deepest surface
  static const surface1 = Color(0xFF35231B);      // Card surface
  static const surface2 = Color(0xFF3F2A20);      // Elevated surface
  static const surface3 = Color(0xFF4A3226);      // Highest elevation
  static const border = Color(0xFF3F2A20);        // Subtle border
  static const borderLight = Color(0xFF5C4637);   // Lighter border

  // Warm-light surfaces (light mode hero).
  static const cream = Color(0xFFFDF8F0);         // Canvas — never pure white
  static const creamCard = Color(0xFFFFFDF9);     // Cards, sheets, inputs
  static const creamDeep = Color(0xFFF6EDDF);     // Nested / pressed surfaces
  static const line = Color(0xFFEAD9C6);          // Warm hairline border

  // Text — dark mode (warm off-white family).
  static const textPrimary = Color(0xFFFFF3EA);
  static const textSecondary = Color(0xFFD9C4B3);
  static const textTertiary = Color(0xFFA89487);
  static const textInverse = Color(0xFF2E1F1B);   // Warm ink on light

  // Text — light mode (warm ink family).
  static const ink = Color(0xFF2E1F1B);
  static const inkSoft = Color(0xFF7A6A5F);
  static const inkFaint = Color(0xFFA89487);

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

  // ── Backward-compatible aliases (legacy screen references) ──
  static const green = Color(0xFF4FA36B);   // Habit sage
  static const blue = primary;               // Berry primary
  static const red = Color(0xFFD64545);     // Tomato
  static const yellow = Color(0xFFF2A03D);  // Warm amber
  static const purple = accent;              // Amber accent
  static const orange = Color(0xFFE85D3D);  // Berry
  static const gray = Palette.textSecondary;
  static const pink = Color(0xFFE8719E);     // Poppy pink
  static const inkSurface = Color(0xFF4A382C);   // Warm ink surface
  static const inkSurface2 = Color(0xFF5C4637);  // Warm ink surface 2

  // Named accent colors for screen use.
  static const accentViolet = Color(0xFF8B7CD8);
  static const accentBlue = Color(0xFF4C9BD6);
  static const accentTeal = Color(0xFF5FB3A0);
  static const accentOrange = Color(0xFFE85D3D);
  static const accentYellow = Color(0xFFF2A03D);
  static const accentPink = Color(0xFFE8719E);
  static const accentCyan = Color(0xFF4C9BD6);

  static const textMuted = Color(0xFF7A6A5F); // Warm muted text

  static const gradientCard = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [creamCard, creamDeep],
  );

  static const gradientGold = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFF2A03D), Color(0xFFE85D3D)],
  );

  /// Warm clay card shadow — outer soft + inner top highlight.
  static const clayShadow = BoxShadow(
    color: Color(0x2EE9A956), // rgba(233,169,86,.18)
    blurRadius: 24,
    offset: Offset(0, 8),
  );

  static const clayShadowDark = BoxShadow(
    color: Color(0x4D000000), // heavy on dark
    blurRadius: 24,
    offset: Offset(0, 8),
  );

  /// Inset top highlight — the signature clay 'top lip' catch-light.
  static const clayHighlight = BoxShadow(
    color: Color(0x33FFFFFF), // white ~20%
    blurRadius: 1,
    spreadRadius: -1,
    offset: Offset(0, -1),
  );
}

/// Pillar accent colors (missions, skins) — warm-tinted.
const Map<String, Color> kPillarColors = {
  'academics': Color(0xFF4C9BD6),   // Berry-tinted blue
  'leadership': Color(0xFF4FA36B),  // Sage
  'research': Color(0xFF8B7CD8),    // Soft violet
  'creativity': Color(0xFFE8719E),  // Poppy pink
  'community': Color(0xFFF2A03D),   // Amber
  'service': Color(0xFFD64545),     // Tomato
  'sports': Color(0xFFE85D3D),      // Berry
  'personal': Color(0xFF5FB3A0),    // Teal
  'athletics': Color(0xFFD64545),   // Tomato
  'character': Color(0xFF4C9BD6),   // Berry-tinted blue
  'global': Color(0xFF8B7CD8),      // Soft violet
};

/// Rarity colors for skins / drops — warm-tinted.
const Map<String, Color> kRarityColors = {
  'common': Color(0xFFA89487),     // Warm taupe
  'rare': Color(0xFF4C9BD6),       // Warm sky
  'epic': Color(0xFF8B7CD8),       // Soft violet
  'legendary': Color(0xFFF2A03D),  // Amber
  'mythic': Color(0xFFE85D3D),     // Berry
};

Color pillarColor(String pillar) =>
    kPillarColors[pillar.toLowerCase()] ?? Palette.primary;

/// Material icon for a mission pillar (used in place of decorative emoji).
IconData pillarIcon(String pillar) {
  switch (pillar.toLowerCase()) {
    case 'academics':
      return Icons.menu_book_rounded;
    case 'leadership':
      return Icons.groups_rounded;
    case 'research':
      return Icons.science_rounded;
    case 'creativity':
      return Icons.palette_rounded;
    case 'community':
      return Icons.volunteer_activism_rounded;
    case 'service':
      return Icons.favorite_rounded;
    case 'sports':
      return Icons.sports_soccer_rounded;
    default:
      return Icons.flag_rounded;
  }
}

Color rarityColor(String rarity) =>
    kRarityColors[rarity.toLowerCase()] ?? Palette.primary;

/// ── Typography ──────────────────────────────────────────────────────────────
TextTheme _buildTextTheme(Brightness brightness) {
  // Display lane: Fredoka. Body lane: Nunito.
  final fredoka = GoogleFonts.fredokaTextTheme(
    brightness == Brightness.dark
        ? ThemeData.dark().textTheme
        : ThemeData.light().textTheme,
  );
  final base = GoogleFonts.nunitoTextTheme(fredoka);

  final Color textColor =
      brightness == Brightness.dark ? Palette.textPrimary : Palette.ink;
  final Color secondaryColor = brightness == Brightness.dark
      ? Palette.textSecondary
      : Palette.inkSoft;

  const display = 'Fredoka';

  return base.copyWith(
    displayLarge: base.displayLarge?.copyWith(
      color: textColor,
      fontFamily: display,
      fontWeight: FontWeight.w600,
      letterSpacing: -0.3,
      fontSize: 40,
      height: 1.1,
    ),
    displayMedium: base.displayMedium?.copyWith(
      color: textColor,
      fontFamily: display,
      fontWeight: FontWeight.w600,
      letterSpacing: -0.3,
      fontSize: 34,
      height: 1.1,
    ),
    displaySmall: base.displaySmall?.copyWith(
      color: textColor,
      fontFamily: display,
      fontWeight: FontWeight.w600,
      letterSpacing: -0.3,
      fontSize: 28,
      height: 1.15,
    ),
    headlineLarge: base.headlineLarge?.copyWith(
      color: textColor,
      fontFamily: display,
      fontWeight: FontWeight.w600,
      letterSpacing: -0.2,
      fontSize: 26,
      height: 1.15,
    ),
    headlineMedium: base.headlineMedium?.copyWith(
      color: textColor,
      fontFamily: display,
      fontWeight: FontWeight.w600,
      fontSize: 22,
      height: 1.2,
    ),
    headlineSmall: base.headlineSmall?.copyWith(
      color: textColor,
      fontFamily: display,
      fontWeight: FontWeight.w500,
      fontSize: 20,
      height: 1.2,
    ),
    titleLarge: base.titleLarge?.copyWith(
      color: textColor,
      fontFamily: display,
      fontWeight: FontWeight.w500,
      fontSize: 18,
      height: 1.2,
    ),
    titleMedium: base.titleMedium?.copyWith(
      color: textColor,
      fontFamily: display,
      fontWeight: FontWeight.w500,
      fontSize: 16,
      height: 1.25,
    ),
    titleSmall: base.titleSmall?.copyWith(
      color: secondaryColor,
      fontWeight: FontWeight.w600,
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
      fontFamily: display,
      fontWeight: FontWeight.w600,
      fontSize: 15,
      letterSpacing: 0.2,
    ),
    labelMedium: base.labelMedium?.copyWith(
      color: secondaryColor,
      fontWeight: FontWeight.w600,
      fontSize: 12,
    ),
    labelSmall: base.labelSmall?.copyWith(
      color: secondaryColor,
      fontWeight: FontWeight.w600,
      fontSize: 11,
      letterSpacing: 0.5,
    ),
  );
}

/// Clay shape — pill buttons, 24px cards, 16px nested surfaces.
class Clay {
  const Clay._();

  static const card = BorderRadius.all(Radius.circular(24));
  static const nested = BorderRadius.all(Radius.circular(16));
  static const pill = BorderRadius.all(Radius.circular(9999));
  static const field = BorderRadius.all(Radius.circular(16));
}

/// ── Light Theme (Warm Bloom hero) ─────────────────────────────────────────
ThemeData lightTheme() {
  return ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorScheme: ColorScheme.fromSeed(
      seedColor: Palette.primary,
      brightness: Brightness.light,
      primary: Palette.primary,
      secondary: Palette.accent,
      surface: Palette.creamCard,
      onSurface: Palette.ink,
      error: Palette.error,
      outline: Palette.line,
    ),
    scaffoldBackgroundColor: Palette.cream,
    textTheme: _buildTextTheme(Brightness.light),
    cardTheme: CardThemeData(
      elevation: 0,
      color: Palette.creamCard,
      shape: RoundedRectangleBorder(
        borderRadius: Clay.card,
        side: const BorderSide(color: Palette.line, width: 2),
      ),
      margin: EdgeInsets.zero,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: false,
      titleTextStyle: GoogleFonts.fredoka(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: Palette.ink,
      ),
      iconTheme: const IconThemeData(color: Palette.ink),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Palette.creamCard,
      selectedItemColor: Palette.primary,
      unselectedItemColor: Palette.inkFaint,
      showUnselectedLabels: true,
      type: BottomNavigationBarType.fixed,
      elevation: 0,
      selectedLabelStyle: TextStyle(fontWeight: FontWeight.w700, fontSize: 11),
      unselectedLabelStyle: TextStyle(fontWeight: FontWeight.w600, fontSize: 11),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Palette.primary,
        foregroundColor: Colors.white,
        elevation: 0,
        shadowColor: Colors.transparent,
        shape: const RoundedRectangleBorder(borderRadius: Clay.pill),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        textStyle: GoogleFonts.nunito(
          fontSize: 16,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.2,
        ),
      ),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: Palette.primary,
        foregroundColor: Colors.white,
        shape: const RoundedRectangleBorder(borderRadius: Clay.pill),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        textStyle: GoogleFonts.nunito(
          fontSize: 16,
          fontWeight: FontWeight.w700,
        ),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: Palette.primaryDark,
        side: const BorderSide(color: Palette.primary, width: 2),
        shape: const RoundedRectangleBorder(borderRadius: Clay.pill),
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
        textStyle: GoogleFonts.nunito(
          fontSize: 15,
          fontWeight: FontWeight.w700,
        ),
      ),
    ),
    chipTheme: ChipThemeData(
      shape: const RoundedRectangleBorder(borderRadius: Clay.pill),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      side: const BorderSide(color: Palette.line),
      backgroundColor: Palette.creamDeep,
      selectedColor: Palette.primary,
      checkmarkColor: Colors.white,
      labelStyle: TextStyle(
        color: Palette.ink,
        fontWeight: FontWeight.w600,
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Palette.creamCard,
      border: OutlineInputBorder(
        borderRadius: Clay.field,
        borderSide: const BorderSide(color: Palette.line),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: Clay.field,
        borderSide: const BorderSide(color: Palette.line),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: Clay.field,
        borderSide: const BorderSide(color: Palette.primary, width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      hintStyle: GoogleFonts.nunito(color: Palette.inkFaint, fontSize: 14),
    ),
    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: Palette.primary,
      linearTrackColor: Palette.line,
    ),
    dividerTheme: const DividerThemeData(
      color: Palette.line,
      thickness: 1,
      space: 0,
    ),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: Palette.ink,
      contentTextStyle: GoogleFonts.nunito(color: Palette.cream, fontSize: 14),
      shape: const RoundedRectangleBorder(borderRadius: Clay.nested),
      behavior: SnackBarBehavior.floating,
    ),
    dialogTheme: DialogThemeData(
      backgroundColor: Palette.creamCard,
      shape: RoundedRectangleBorder(borderRadius: Clay.card),
    ),
  );
}

/// ── Dark Theme (warm espresso) ─────────────────────────────────────────────
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
        borderRadius: Clay.card,
        side: const BorderSide(color: Palette.border, width: 1),
      ),
      margin: EdgeInsets.zero,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: false,
      titleTextStyle: GoogleFonts.fredoka(
        fontSize: 20,
        fontWeight: FontWeight.w600,
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
      selectedLabelStyle: TextStyle(fontWeight: FontWeight.w700, fontSize: 11),
      unselectedLabelStyle: TextStyle(fontWeight: FontWeight.w600, fontSize: 11),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Palette.primary,
        foregroundColor: Colors.white,
        elevation: 0,
        shadowColor: Colors.transparent,
        shape: const RoundedRectangleBorder(borderRadius: Clay.pill),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        textStyle: GoogleFonts.nunito(
          fontSize: 16,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.2,
        ),
      ),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: Palette.primary,
        foregroundColor: Colors.white,
        shape: const RoundedRectangleBorder(borderRadius: Clay.pill),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        textStyle: GoogleFonts.nunito(
          fontSize: 16,
          fontWeight: FontWeight.w700,
        ),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: Palette.primaryLight,
        side: const BorderSide(color: Palette.primaryLight, width: 2),
        shape: const RoundedRectangleBorder(borderRadius: Clay.pill),
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
        textStyle: GoogleFonts.nunito(
          fontSize: 15,
          fontWeight: FontWeight.w700,
        ),
      ),
    ),
    chipTheme: ChipThemeData(
      shape: const RoundedRectangleBorder(borderRadius: Clay.pill),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      side: const BorderSide(color: Palette.border),
      backgroundColor: Palette.surface2,
      selectedColor: Palette.primary,
      checkmarkColor: Colors.white,
      labelStyle: const TextStyle(
        color: Palette.textPrimary,
        fontWeight: FontWeight.w600,
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Palette.surface1,
      border: OutlineInputBorder(
        borderRadius: Clay.field,
        borderSide: const BorderSide(color: Palette.border),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: Clay.field,
        borderSide: const BorderSide(color: Palette.border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: Clay.field,
        borderSide: const BorderSide(color: Palette.primaryLight, width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      hintStyle: GoogleFonts.nunito(color: Palette.textTertiary, fontSize: 14),
    ),
    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: Palette.primaryLight,
      linearTrackColor: Palette.surface3,
    ),
    dividerTheme: const DividerThemeData(
      color: Palette.border,
      thickness: 1,
      space: 0,
    ),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: Palette.surface3,
      contentTextStyle: GoogleFonts.nunito(
          color: Palette.textPrimary, fontSize: 14),
      shape: const RoundedRectangleBorder(borderRadius: Clay.nested),
      behavior: SnackBarBehavior.floating,
    ),
    dialogTheme: DialogThemeData(
      backgroundColor: Palette.surface1,
      shape: RoundedRectangleBorder(borderRadius: Clay.card),
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
