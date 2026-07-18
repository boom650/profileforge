import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// ────────────────────────────────────────────────────────────────────────────
/// ProfileForge theme — "poppy" Duolingo-inspired game UI.
/// High-saturation seed colors, very round corners, soft shadows, bold type.
/// Two modes (light / dark) plus a system follow. Persisted locally.
/// ────────────────────────────────────────────────────────────────────────────

/// Brand palette (Material-3 seed colors + accent pops).
class Palette {
  const Palette._();

  // Primary brand greens (Duolingo Feather Green family).
  static const green = Color(0xFF58CC02);
  static const greenDark = Color(0xFF58A700);
  static const greenSoft = Color(0xFF89E219);

  // Pops.
  static const yellow = Color(0xFFFFC800);
  static const blue = Color(0xFF1CB0F6);
  static const red = Color(0xFFFF4B4B);
  static const purple = Color(0xFFCE82FF);
  static const orange = Color(0xFFFF9600);
  static const pink = Color(0xFFFF66C4);

  // Surfaces (dark mode).
  static const ink = Color(0xFF0F1419);
  static const inkSurface = Color(0xFF1B1F24);
  static const inkSurface2 = Color(0xFF2B313A);
  static const inkBorder = Color(0xFF3A414C);
}

/// Pillar accent colors (missions, skins).
const Map<String, Color> kPillarColors = {
  'academics': Palette.blue,
  'leadership': Palette.green,
  'research': Palette.purple,
  'creativity': Palette.pink,
  'community': Palette.orange,
  'service': Palette.red,
  'sports': Palette.yellow,
  'personal': Palette.greenSoft,
  'athletics': Palette.red,
  'character': Palette.blue,
  'global': Palette.purple,
};

/// Rarity colors for skins / drops.
const Map<String, Color> kRarityColors = {
  'common': Color(0xFF9E9E9E),
  'rare': Color(0xFF1CB0F6),
  'epic': Color(0xFFCE82FF),
  'legendary': Color(0xFFFFC800),
  'mythic': Color(0xFFFF4B4B),
};

Color pillarColor(String pillar) =>
    kPillarColors[pillar.toLowerCase()] ?? Palette.green;

Color rarityColor(String rarity) =>
    kRarityColors[rarity.toLowerCase()] ?? Palette.green;

/// ── Themes ────────────────────────────────────────────────────────────────
ThemeData lightTheme() => ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: ColorScheme.fromSeed(
        seedColor: Palette.green,
        brightness: Brightness.light,
        primary: Palette.green,
        secondary: Palette.yellow,
      ),
      scaffoldBackgroundColor: const Color(0xFFF7F8FA),
      cardTheme: CardThemeData(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: Color(0xFFE5E8EC), width: 1.5),
        ),
        color: Colors.white,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: Palette.green,
          foregroundColor: Colors.white,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
          textStyle: const TextStyle(
              fontSize: 16, fontWeight: FontWeight.w800, letterSpacing: 0.3),
          elevation: 0,
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: Palette.green,
          foregroundColor: Colors.white,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
          textStyle: const TextStyle(
              fontSize: 16, fontWeight: FontWeight.w800, letterSpacing: 0.3),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: Palette.green,
          side: const BorderSide(color: Palette.green, width: 2),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 18),
          textStyle: const TextStyle(
              fontSize: 15, fontWeight: FontWeight.w800, letterSpacing: 0.3),
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
            fontSize: 22, fontWeight: FontWeight.w900, color: Color(0xFF0F1419)),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: Colors.white,
        selectedItemColor: Palette.green,
        unselectedItemColor: const Color(0xFFAFAFAF),
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        selectedLabelStyle:
            const TextStyle(fontWeight: FontWeight.w800, fontSize: 11),
      ),
      chipTheme: ChipThemeData(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        labelStyle: const TextStyle(fontWeight: FontWeight.w700),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      ),
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: Palette.green,
        linearTrackColor: Color(0xFFE5E8EC),
      ),
      textTheme: const TextTheme(
        headlineMedium: TextStyle(fontWeight: FontWeight.w900),
        headlineSmall: TextStyle(fontWeight: FontWeight.w900),
        titleLarge: TextStyle(fontWeight: FontWeight.w800),
        bodyLarge: TextStyle(fontSize: 16),
      ),
    );

ThemeData darkTheme() => ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: ColorScheme.fromSeed(
        seedColor: Palette.greenSoft,
        brightness: Brightness.dark,
        primary: Palette.greenSoft,
        secondary: Palette.yellow,
        surface: Palette.inkSurface,
        surfaceContainer: Palette.inkSurface2,
        onSurface: Colors.white,
      ),
      scaffoldBackgroundColor: Palette.ink,
      cardTheme: CardThemeData(
        elevation: 0,
        color: Palette.inkSurface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: Palette.inkBorder, width: 1.5),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: Palette.greenSoft,
          foregroundColor: Colors.white,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
          textStyle: const TextStyle(
              fontSize: 16, fontWeight: FontWeight.w800, letterSpacing: 0.3),
          elevation: 0,
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: Palette.greenSoft,
          foregroundColor: Colors.white,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
          textStyle: const TextStyle(
              fontSize: 16, fontWeight: FontWeight.w800, letterSpacing: 0.3),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: Palette.greenSoft,
          side: const BorderSide(color: Palette.greenSoft, width: 2),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 18),
          textStyle: const TextStyle(
              fontSize: 15, fontWeight: FontWeight.w800, letterSpacing: 0.3),
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
            fontSize: 22, fontWeight: FontWeight.w900, color: Colors.white),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: Palette.inkSurface,
        selectedItemColor: Palette.greenSoft,
        unselectedItemColor: const Color(0xFF6B7280),
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        selectedLabelStyle:
            const TextStyle(fontWeight: FontWeight.w800, fontSize: 11),
      ),
      chipTheme: ChipThemeData(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        labelStyle: const TextStyle(fontWeight: FontWeight.w700),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      ),
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: Palette.greenSoft,
        linearTrackColor: Palette.inkSurface2,
      ),
      textTheme: const TextTheme(
        headlineMedium: TextStyle(fontWeight: FontWeight.w900),
        headlineSmall: TextStyle(fontWeight: FontWeight.w900),
        titleLarge: TextStyle(fontWeight: FontWeight.w800),
        bodyLarge: TextStyle(fontSize: 16, color: Colors.white),
      ),
    );

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
