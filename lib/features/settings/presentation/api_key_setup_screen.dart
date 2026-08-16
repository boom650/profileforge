import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:profileforge/core/theme/app_theme.dart';
import 'package:profileforge/core/ai/ai_provider.dart';
import 'package:profileforge/core/ai/ai_service.dart';
import 'package:profileforge/features/settings/application/settings_providers.dart';

/// ────────────────────────────────────────────────────────────────────────────
/// API Key Setup — Guided, visual setup experience for AI providers.
///
/// Features:
/// - Provider cards with icons, descriptions, pricing
/// - Secure key input with show/hide toggle
/// - Test connection with visual feedback
/// - Step-by-step guidance
/// - Premium Lusion-inspired dark theme
///
/// Based on research:
/// - 09-comprehensive-data-privacy-security.md (secure key storage)
/// - 10-cross-platform-responsive-design.md (responsive layout)
/// ────────────────────────────────────────────────────────────────────────────
class ApiKeySetupScreen extends ConsumerStatefulWidget {
  const ApiKeySetupScreen({super.key, this.onSetupComplete});

  final VoidCallback? onSetupComplete;

  @override
  ConsumerState<ApiKeySetupScreen> createState() => _ApiKeySetupScreenState();
}

class _ApiKeySetupScreenState extends ConsumerState<ApiKeySetupScreen>
    with TickerProviderStateMixin {
  final _ai = AIService();
  final _controllers = <AIProviderType, TextEditingController>{};
  final _testing = <AIProviderType, bool>{};
  final _testResults = <AIProviderType, bool?>{};
  final _showKeys = <AIProviderType, bool>{};
  late AnimationController _stepController;

  @override
  void initState() {
    super.initState();
    _stepController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    for (final p in AIProviders.fallbackChain) {
      _controllers[p.type] = TextEditingController();
      _testing[p.type] = false;
      _showKeys[p.type] = false;
    }
    _loadKeys();
  }

  @override
  void dispose() {
    for (final c in _controllers.values) {
      c.dispose();
    }
    _stepController.dispose();
    super.dispose();
  }

  Future<void> _loadKeys() async {
    final repo = ref.read(settingsRepositoryProvider);
    for (final p in AIProviders.fallbackChain) {
      final key = await repo.getApiKey(p.type);
      if (key != null && key.isNotEmpty) {
        _controllers[p.type]!.text = key;
        _testResults[p.type] = true; // Assume valid if stored
      }
    }
    if (mounted) setState(() {});
  }

  Future<void> _saveKey(AIProviderType type) async {
    final repo = ref.read(settingsRepositoryProvider);
    final key = _controllers[type]!.text.trim();
    if (key.isEmpty) {
      await repo.removeApiKey(type);
    } else {
      await repo.setApiKey(type, key);
    }
    if (mounted) {
      setState(() {});
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(key.isEmpty ? 'Key removed' : 'Key saved securely'),
          backgroundColor: Palette.success,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
    }
  }

  Future<void> _testProvider(AIProviderType type) async {
    HapticFeedback.mediumImpact();
    setState(() {
      _testing[type] = true;
      _testResults[type] = null;
    });

    // Save first, then test
    await _saveKey(type);
    final result = await _ai.testProvider(type);

    if (mounted) {
      setState(() {
        _testing[type] = false;
        _testResults[type] = result;
      });

      if (result) {
        HapticFeedback.heavyImpact();
      }
    }
  }

  bool _hasAnyKey() {
    return _testResults.values.any((r) => r == true);
  }

  @override
  Widget build(BuildContext context) {
    final dark = isDark(context);

    return Scaffold(
      backgroundColor: dark ? Palette.black : Palette.cream,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: dark
                ? [const Color(0xFF1A0F0A), Palette.surface0, Palette.black]
                : [const Color(0xFFFBF1E3), Palette.cream, Palette.creamCard],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // ── Header ──
              _buildHeader(dark),

              // ── Content ──
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  children: [
                    const SizedBox(height: 20),

                    // ── Hero Card ──
                    _buildHeroCard(dark),

                    const SizedBox(height: 28),

                    // ── Provider Cards ──
                    ...AIProviders.fallbackChain.asMap().entries.map((entry) {
                      final index = entry.key;
                      final provider = entry.value;
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: _buildProviderCard(provider, index, dark),
                      );
                    }),

                    const SizedBox(height: 16),

                    // ── Security Info ──
                    _buildSecurityInfo(dark),

                    const SizedBox(height: 20),

                    // ── Continue Button ──
                    if (_hasAnyKey())
                      _buildContinueButton(dark),

                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// ── Header ───────────────────────────────────────────────────────────────
  Widget _buildHeader(bool dark) {
    return Container(
      padding: EdgeInsets.fromLTRB(16, MediaQuery.of(context).padding.top + 8, 16, 12),
      decoration: BoxDecoration(
        color: dark
            ? Palette.surface0.withValues(alpha: 0.9)
            : Colors.white.withValues(alpha: 0.9),
        border: Border(
          bottom: BorderSide(
            color: dark ? Palette.border.withValues(alpha: 0.3) : const Color(0xFFEDE3D6),
          ),
        ),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: dark ? Palette.surface2 : const Color(0xFFF4ECE1),
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
            'Setup AI',
            style: GoogleFonts.nunito(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: dark ? Palette.textPrimary : Palette.textInverse,
            ),
          ),
        ],
      ),
    );
  }

  /// ── Hero Card ────────────────────────────────────────────────────────────
  Widget _buildHeroCard(bool dark) {
    final activeCount = _testResults.values.where((r) => r == true).length;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: Palette.gradientPrimary,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Palette.primary.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Center(
                  child: Icon(Icons.auto_awesome, size: 24, color: Colors.white),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Connect Your AI',
                      style: GoogleFonts.nunito(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '$activeCount provider${activeCount == 1 ? '' : 's'} connected',
                      style: GoogleFonts.nunito(
                        fontSize: 13,
                        color: Colors.white.withValues(alpha: 0.8),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            'Add at least one API key to start chatting with your psychology-adapted AI mentor. Free options available.',
            style: GoogleFonts.nunito(
              fontSize: 14,
              color: Colors.white.withValues(alpha: 0.85),
              height: 1.5,
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.05);
  }

  /// ── Provider Card ────────────────────────────────────────────────────────
  Widget _buildProviderCard(AIProviderConfig provider, int index, bool dark) {
    final type = provider.type;
    final testing = _testing[type] ?? false;
    final result = _testResults[type];
    final hasKey = _controllers[type]!.text.isNotEmpty;
    final showKey = _showKeys[type] ?? false;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: dark ? Palette.surface1.withValues(alpha: 0.6) : Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: result == true
              ? Palette.success
              : result == false
                  ? Palette.error
                  : dark
                      ? Palette.border.withValues(alpha: 0.4)
                      : const Color(0xFFEDE3D6),
          width: result != null ? 2 : 1,
        ),
        boxShadow: result == true
            ? [
                BoxShadow(
                  color: Palette.success.withValues(alpha: 0.15),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ]
            : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Provider Header ──
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: result == true
                      ? Palette.success.withValues(alpha: 0.12)
                      : Palette.primary.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Icon(
                    _getProviderIcon(type),
                    size: 22,
                    color: result == true ? Palette.success : Palette.primary,
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      provider.name,
                      style: GoogleFonts.nunito(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: dark ? Palette.textPrimary : Palette.textInverse,
                      ),
                    ),
                    Text(
                      provider.model,
                      style: GoogleFonts.nunito(
                        fontSize: 12,
                        color: Palette.textTertiary,
                      ),
                    ),
                  ],
                ),
              ),
              if (result != null)
                Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: result ? Palette.success : Palette.error,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    result ? Icons.check : Icons.close,
                    size: 16,
                    color: Colors.white,
                  ),
                ).animate().scale(duration: 300.ms, curve: Curves.easeOutBack),
            ],
          ),

          const SizedBox(height: 16),

          // ── Description ──
          Text(
            _getProviderDescription(type),
            style: GoogleFonts.nunito(
              fontSize: 13,
              color: Palette.textSecondary,
              height: 1.4,
            ),
          ),

          const SizedBox(height: 12),

          // ── Pricing Badge ──
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: _getProviderPricingColor(type).withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              _getProviderPricing(type),
              style: GoogleFonts.nunito(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: _getProviderPricingColor(type),
              ),
            ),
          ),

          const SizedBox(height: 16),

          // ── API Key Input ──
          Container(
            decoration: BoxDecoration(
              color: dark ? Palette.surface2 : const Color(0xFFF4ECE1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: hasKey
                    ? Palette.primary.withValues(alpha: 0.3)
                    : dark
                        ? Palette.border.withValues(alpha: 0.3)
                        : const Color(0xFFEDE3D6),
              ),
            ),
            child: TextField(
              controller: _controllers[type],
              obscureText: !showKey,
              obscuringCharacter: '•',
              style: GoogleFonts.nunito(
                fontSize: 13,
                color: dark ? Palette.textPrimary : Palette.textInverse,
              ),
              decoration: InputDecoration(
                hintText: 'Paste your API key...',
                hintStyle: GoogleFonts.nunito(
                  fontSize: 13,
                  color: Palette.textTertiary,
                ),
                prefixIcon: Icon(
                  Icons.vpn_key,
                  size: 18,
                  color: hasKey ? Palette.primary : Palette.textTertiary,
                ),
                suffixIcon: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (_controllers[type]!.text.isNotEmpty)
                      IconButton(
                        icon: Icon(
                          showKey ? Icons.visibility_off : Icons.visibility,
                          size: 18,
                          color: Palette.textTertiary,
                        ),
                        onPressed: () {
                          HapticFeedback.selectionClick();
                          setState(() => _showKeys[type] = !showKey);
                        },
                      ),
                    if (_controllers[type]!.text.isNotEmpty)
                      IconButton(
                        icon: const Icon(Icons.close, size: 18, color: Palette.textTertiary),
                        onPressed: () {
                          _controllers[type]!.clear();
                          setState(() {});
                        },
                      ),
                  ],
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
              ),
              onChanged: (_) => setState(() {}),
            ),
          ),

          const SizedBox(height: 14),

          // ── Action Buttons ──
          Row(
            children: [
              // Test button
              Expanded(
                child: GestureDetector(
                  onTap: (testing || !hasKey) ? null : () => _testProvider(type),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    height: 44,
                    decoration: BoxDecoration(
                      color: (testing || !hasKey)
                          ? (dark ? Palette.surface2 : const Color(0xFFF4ECE1))
                          : Palette.info.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: (testing || !hasKey)
                            ? Colors.transparent
                            : Palette.info.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Center(
                      child: testing
                          ? SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation(
                                  dark ? Palette.textSecondary : Palette.textTertiary,
                                ),
                              ),
                            )
                          : Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.wifi_find,
                                  size: 16,
                                  color: (!hasKey)
                                      ? Palette.textTertiary
                                      : Palette.info,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  'Test',
                                  style: GoogleFonts.nunito(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: (!hasKey)
                                        ? Palette.textTertiary
                                        : Palette.info,
                                  ),
                                ),
                              ],
                            ),
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 10),

              // Save button
              Expanded(
                child: GestureDetector(
                  onTap: !hasKey ? null : () => _saveKey(type),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    height: 44,
                    decoration: BoxDecoration(
                      gradient: hasKey ? Palette.gradientPrimary : null,
                      color: hasKey
                          ? null
                          : (dark ? Palette.surface2 : const Color(0xFFF4ECE1)),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: hasKey
                          ? [
                              BoxShadow(
                                color: Palette.primary.withValues(alpha: 0.2),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ]
                          : null,
                    ),
                    child: Center(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.save,
                            size: 16,
                            color: hasKey ? Colors.white : Palette.textTertiary,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            'Save',
                            style: GoogleFonts.nunito(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: hasKey ? Colors.white : Palette.textTertiary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),

          // ── Test Result Message ──
          if (result != null && !testing) ...[
            const SizedBox(height: 12),
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: result
                    ? Palette.success.withValues(alpha: 0.1)
                    : Palette.error.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  Icon(
                    result ? Icons.check_circle : Icons.error,
                    size: 18,
                    color: result ? Palette.success : Palette.error,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      result
                          ? 'Connection successful! This provider is ready.'
                          : 'Connection failed. Check your key and try again.',
                      style: GoogleFonts.nunito(
                        fontSize: 13,
                        color: result ? Palette.success : Palette.error,
                      ),
                    ),
                  ),
                ],
              ),
            ).animate().fadeIn(duration: 300.ms),
          ],
        ],
      ),
    ).animate().fadeIn(
      delay: Duration(milliseconds: 200 + index * 100),
      duration: 400.ms,
    );
  }

  /// ── Security Info ────────────────────────────────────────────────────────
  Widget _buildSecurityInfo(bool dark) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Palette.success.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: Palette.success.withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: Palette.success.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.shield,
              size: 18,
              color: Palette.success,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Your keys are secure',
                  style: GoogleFonts.nunito(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Palette.success,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'All API keys are stored locally on your device using encrypted storage. They are never sent to our servers.',
                  style: GoogleFonts.nunito(
                    fontSize: 12,
                    color: Palette.textSecondary,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ).animate().fadeIn(delay: 600.ms);
  }

  /// ── Continue Button ──────────────────────────────────────────────────────
  Widget _buildContinueButton(bool dark) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.mediumImpact();
        widget.onSetupComplete?.call();
        Navigator.pop(context);
      },
      child: Container(
        width: double.infinity,
        height: 52,
        decoration: BoxDecoration(
          gradient: Palette.gradientPrimary,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Palette.primary.withValues(alpha: 0.3),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Continue to Chat',
                style: GoogleFonts.nunito(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 8),
              const Icon(Icons.arrow_forward, size: 20, color: Colors.white),
            ],
          ),
        ),
      ),
    ).animate().fadeIn(delay: 700.ms).slideY(begin: 0.1);
  }

  /// ── Helpers ──────────────────────────────────────────────────────────────
  IconData _getProviderIcon(AIProviderType type) {
    switch (type) {
      case AIProviderType.openCodeZen:
        return Icons.psychology_rounded;
      case AIProviderType.router:
        return Icons.router_rounded;
      default:
        return Icons.memory_rounded;
    }
  }

  String _getProviderDescription(AIProviderType type) {
    switch (type) {
      case AIProviderType.openCodeZen:
        return 'High-quality free AI models. Best for getting started without spending.';
      case AIProviderType.router:
        return 'Free tier with multiple models. Good fallback option.';
      default:
        return 'Premium NVIDIA models. 1000 free credits included.';
    }
  }

  String _getProviderPricing(AIProviderType type) {
    switch (type) {
      case AIProviderType.openCodeZen:
        return '✨ Free';
      case AIProviderType.router:
        return '✨ Free tier';
      default:
        return '💎 1000 free credits';
    }
  }

  Color _getProviderPricingColor(AIProviderType type) {
    switch (type) {
      case AIProviderType.openCodeZen:
        return Palette.success;
      case AIProviderType.router:
        return Palette.info;
      default:
        return Palette.warning;
    }
  }
}
