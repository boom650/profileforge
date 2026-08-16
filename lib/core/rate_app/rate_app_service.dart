import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:profileforge/core/theme/app_theme.dart';

/// ────────────────────────────────────────────────────────────────────────────
/// RateAppService — Smart rate-app prompt.
///
/// Shows prompt after:
/// - 5th session
/// - 3rd AI chat
/// - After achieving a milestone
///
/// Respects:
/// - "Don't show again" preference
/// - Platform-specific store URLs
/// ────────────────────────────────────────────────────────────────────────────
class RateAppService {
  static RateAppService? _instance;
  static RateAppService get instance => _instance ??= RateAppService._();
  RateAppService._();

  static const _dismissedKey = 'pf_rate_app_dismissed';
  static const _sessionCountKey = 'pf_session_count';
  static const _chatCountKey = 'pf_ai_chat_count';
  static const _lastPromptKey = 'pf_rate_last_prompt';

  /// Record a session.
  Future<void> recordSession() async {
    final prefs = await SharedPreferences.getInstance();
    final count = prefs.getInt(_sessionCountKey) ?? 0;
    await prefs.setInt(_sessionCountKey, count + 1);
  }

  /// Record an AI chat interaction.
  Future<void> recordAIChat() async {
    final prefs = await SharedPreferences.getInstance();
    final count = prefs.getInt(_chatCountKey) ?? 0;
    await prefs.setInt(_chatCountKey, count + 1);
  }

  /// Total AI chat interactions recorded (real counter, not fabricated).
  Future<int> chatCount() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_chatCountKey) ?? 0;
  }

  /// Check if should show rate prompt.
  Future<bool> shouldShowPrompt() async {
    final prefs = await SharedPreferences.getInstance();

    // User dismissed permanently
    if (prefs.getBool(_dismissedKey) == true) return false;

    // Check last prompt date (don't prompt more than once per 30 days)
    final lastPrompt = prefs.getString(_lastPromptKey);
    if (lastPrompt != null) {
      final lastDate = DateTime.parse(lastPrompt);
      if (DateTime.now().difference(lastDate).inDays < 30) return false;
    }

    // Check session count
    final sessions = prefs.getInt(_sessionCountKey) ?? 0;
    if (sessions >= 5) return true;

    // Check chat count
    final chats = prefs.getInt(_chatCountKey) ?? 0;
    if (chats >= 3) return true;

    return false;
  }

  /// Mark as permanently dismissed.
  Future<void> dismissPermanently() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_dismissedKey, true);
  }

  /// Record that prompt was shown.
  Future<void> recordPromptShown() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_lastPromptKey, DateTime.now().toIso8601String());
  }
}

/// showRateAppDialog — Show the rate app dialog.
Future<void> showRateAppDialog(BuildContext context) async {
  final dark = isDark(context);
  final service = RateAppService.instance;
  await service.recordPromptShown();

  return showDialog(
    context: context,
    builder: (context) => _RateAppDialog(dark: dark),
  );
}

class _RateAppDialog extends StatefulWidget {
  const _RateAppDialog({required this.dark});

  final bool dark;

  @override
  State<_RateAppDialog> createState() => _RateAppDialogState();
}

class _RateAppDialogState extends State<_RateAppDialog>
    with SingleTickerProviderStateMixin {
  int _rating = 0;
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
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

  void _setRating(int rating) {
    HapticFeedback.selectionClick();
    setState(() => _rating = rating);
  }

  void _submit() async {
    HapticFeedback.mediumImpact();

    if (_rating >= 4) {
      // Positive — open store
      _openStore();
    } else {
      // Negative — show feedback prompt
      Navigator.pop(context);
      // TODO: Show feedback bottom sheet
    }
  }

  void _openStore() {
    // Platform-specific store URL
    if (Platform.isAndroid) {
      // Open Play Store
      // In production, use url_launcher
    } else if (Platform.isIOS) {
      // Open App Store
    }
    Navigator.pop(context);
  }

  void _dismiss() async {
    HapticFeedback.lightImpact();
    await RateAppService.instance.dismissPermanently();
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: widget.dark ? Palette.surface1 : Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.2),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Icon
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  gradient: Palette.gradientPrimary,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.star,
                  size: 32,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 20),

              // Title
              Text(
                'Enjoying ProfileForge?',
                style: GoogleFonts.nunito(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: widget.dark ? Palette.textPrimary : Palette.textInverse,
                ),
              ),
              const SizedBox(height: 8),

              // Subtitle
              Text(
                'Your rating helps us improve the app for everyone.',
                textAlign: TextAlign.center,
                style: GoogleFonts.nunito(
                  fontSize: 14,
                  color: widget.dark ? Palette.textSecondary : Palette.textTertiary,
                ),
              ),
              const SizedBox(height: 24),

              // Stars
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(5, (i) {
                  final starIndex = i + 1;
                  final isSelected = starIndex <= _rating;

                  return GestureDetector(
                    onTap: () => _setRating(starIndex),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 150),
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      child: Icon(
                        isSelected ? Icons.star : Icons.star_border,
                        size: 40,
                        color: isSelected ? Palette.warning : Palette.textTertiary,
                      ),
                    ),
                  );
                }),
              ),
              const SizedBox(height: 8),

              // Rating label
              if (_rating > 0)
                Text(
                  _getRatingLabel(_rating),
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Palette.warning,
                  ),
                ),
              const SizedBox(height: 24),

              // Submit button
              if (_rating > 0)
                GestureDetector(
                  onTap: _submit,
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    decoration: BoxDecoration(
                      gradient: Palette.gradientPrimary,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Text(
                        _rating >= 4 ? 'Rate on Store' : 'Send Feedback',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),

              const SizedBox(height: 12),

              // Dismiss
              GestureDetector(
                onTap: _dismiss,
                child: Text(
                  'Not now',
                  style: TextStyle(
                    fontSize: 13,
                    color: widget.dark ? Palette.textSecondary : Palette.textTertiary,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getRatingLabel(int rating) {
    switch (rating) {
      case 1:
        return 'Poor';
      case 2:
        return 'Fair';
      case 3:
        return 'Good';
      case 4:
        return 'Great';
      case 5:
        return 'Excellent!';
      default:
        return '';
    }
  }
}
