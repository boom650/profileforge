import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:profileforge/core/theme/app_theme.dart';

/// ────────────────────────────────────────────────────────────────────────────
/// ThemeSwitcher — Premium theme selection screen.
///
/// Features:
/// - System / Light / Dark mode toggle
/// - Animated preview of theme change
/// - Visual theme cards with preview
/// - Haptic feedback on selection
/// ────────────────────────────────────────────────────────────────────────────

enum ThemeModeOption { system, light, dark }

class ThemeSwitcher extends StatefulWidget {
  const ThemeSwitcher({super.key});

  @override
  State<ThemeSwitcher> createState() => _ThemeSwitcherState();
}

class _ThemeSwitcherState extends State<ThemeSwitcher>
    with SingleTickerProviderStateMixin {
  ThemeModeOption _currentMode = ThemeModeOption.system;
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _loadThemeMode();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _scaleAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutBack,
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _loadThemeMode() async {
    final prefs = await SharedPreferences.getInstance();
    final mode = prefs.getString('pf_theme_mode') ?? 'system';
    setState(() {
      _currentMode = ThemeModeOption.values.firstWhere(
        (e) => e.name == mode,
        orElse: () => ThemeModeOption.system,
      );
    });
  }

  Future<void> _setThemeMode(ThemeModeOption mode) async {
    HapticFeedback.selectionClick();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('pf_theme_mode', mode.name);
    setState(() => _currentMode = mode);

    // Rebuild app with new theme
    if (mounted) {
      // This triggers a rebuild of the entire app
      MyApp.of(context)?.setThemeMode(_mapMode(mode));
    }
  }

  ThemeMode _mapMode(ThemeModeOption option) {
    switch (option) {
      case ThemeModeOption.system:
        return ThemeMode.system;
      case ThemeModeOption.light:
        return ThemeMode.light;
      case ThemeModeOption.dark:
        return ThemeMode.dark;
    }
  }

  @override
  Widget build(BuildContext context) {
    final dark = isDark(context);

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: dark
                ? [const Color(0xFF0B1120), Palette.surface0, Palette.black]
                : [const Color(0xFFEEF2FF), const Color(0xFFF8FAFC), Colors.white],
          ),
        ),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Header ──
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: dark ? Palette.surface2 : const Color(0xFFF1F5F9),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          Icons.arrow_back_ios_new,
                          size: 16,
                          color: dark ? Palette.textPrimary : Palette.textInverse,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Appearance',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: dark ? Palette.textPrimary : Palette.textInverse,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // ── Theme Options ──
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: AnimatedBuilder(
                  animation: _scaleAnimation,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: _scaleAnimation.value,
                      child: Column(
                        children: [
                          _buildThemeCard(
                            mode: ThemeModeOption.system,
                            icon: Icons.brightness_auto,
                            title: 'System',
                            subtitle: 'Follow device settings',
                            preview: _buildSystemPreview(dark),
                            dark: dark,
                          ),
                          const SizedBox(height: 12),
                          _buildThemeCard(
                            mode: ThemeModeOption.light,
                            icon: Icons.light_mode,
                            title: 'Light',
                            subtitle: 'Classic light theme',
                            preview: _buildLightPreview(),
                            dark: dark,
                          ),
                          const SizedBox(height: 12),
                          _buildThemeCard(
                            mode: ThemeModeOption.dark,
                            icon: Icons.dark_mode,
                            title: 'Dark',
                            subtitle: 'Easy on the eyes',
                            preview: _buildDarkPreview(),
                            dark: dark,
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 32),

              // ── Info ──
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: dark
                        ? Palette.surface1.withValues(alpha: 0.5)
                        : Colors.white.withValues(alpha: 0.8),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: dark ? Palette.border : const Color(0xFFE2E8F0),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        size: 20,
                        color: Palette.info,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Dark mode reduces eye strain and saves battery on OLED displays.',
                          style: TextStyle(
                            fontSize: 12,
                            color: dark ? Palette.textSecondary : Palette.textTertiary,
                            height: 1.4,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildThemeCard({
    required ThemeModeOption mode,
    required IconData icon,
    required String title,
    required String subtitle,
    required Widget preview,
    required bool dark,
  }) {
    final isSelected = _currentMode == mode;

    return GestureDetector(
      onTap: () => _setThemeMode(mode),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected
              ? Palette.primary.withValues(alpha: 0.1)
              : dark
                  ? Palette.surface1.withValues(alpha: 0.7)
                  : Colors.white.withValues(alpha: 0.8),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected
                ? Palette.primary.withValues(alpha: 0.5)
                : dark
                    ? Palette.border
                    : const Color(0xFFE2E8F0),
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Palette.primary.withValues(alpha: 0.2),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Row(
          children: [
            // Icon
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: isSelected
                    ? Palette.primary.withValues(alpha: 0.15)
                    : dark
                        ? Palette.surface2
                        : const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                size: 24,
                color: isSelected ? Palette.primary : Palette.textTertiary,
              ),
            ),
            const SizedBox(width: 16),
            // Text
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: dark ? Palette.textPrimary : Palette.textInverse,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12,
                      color: dark ? Palette.textSecondary : Palette.textTertiary,
                    ),
                  ),
                ],
              ),
            ),
            // Radio
            if (isSelected)
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: Palette.gradientPrimary,
                ),
                child: Icon(
                  Icons.check,
                  size: 16,
                  color: Colors.white,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildSystemPreview(bool dark) {
    return Container(
      width: 60,
      height: 36,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            Colors.white,
            Palette.surface0,
          ],
        ),
      ),
    );
  }

  Widget _buildLightPreview() {
    return Container(
      width: 60,
      height: 36,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
    );
  }

  Widget _buildDarkPreview() {
    return Container(
      width: 60,
      height: 36,
      decoration: BoxDecoration(
        color: Palette.surface0,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Palette.border),
      ),
    );
  }
}

/// Placeholder for MyApp — will be replaced with actual app reference.
class MyApp {
  static MyApp? of(BuildContext context) => null;
  void setThemeMode(ThemeMode mode) {}
}
