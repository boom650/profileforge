import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:profileforge/core/theme/app_theme.dart';

/// ────────────────────────────────────────────────────────────────────────────
/// MagicLinkScreen — Email-based passwordless auth.
/// Clean single-field input → send magic link → success state.
/// ────────────────────────────────────────────────────────────────────────────
class MagicLinkScreen extends StatefulWidget {
  const MagicLinkScreen({super.key});

  @override
  State<MagicLinkScreen> createState() => _MagicLinkScreenState();
}

class _MagicLinkScreenState extends State<MagicLinkScreen> {
  final _emailCtrl = TextEditingController();
  final _focusNode = FocusNode();
  bool _sent = false;
  bool _loading = false;
  int _cooldown = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _focusNode.requestFocus();
  }

  @override
  void dispose() {
    _emailCtrl.dispose();
    _focusNode.dispose();
    _timer?.cancel();
    super.dispose();
  }

  bool get _isValidEmail =>
      RegExp(r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$')
          .hasMatch(_emailCtrl.text.trim());

  Future<void> _sendMagicLink() async {
    if (!_isValidEmail || _loading) return;

    setState(() {
      _loading = true;
    });

    // TODO: Replace with actual Supabase magic link
    await Future.delayed(const Duration(seconds: 1));

    if (!mounted) return;

    setState(() {
      _loading = false;
      _sent = true;
      _cooldown = 60;
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (_cooldown <= 0) {
        t.cancel();
      } else {
        setState(() => _cooldown--);
      }
    });
  }

  Future<void> _resend() async {
    if (_cooldown > 0) return;
    setState(() {
      _sent = false;
      _cooldown = 0;
    });
    await _sendMagicLink();
  }

  Future<void> _simulateVerify() async {
    // Simulate verification for demo.
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('pf_auth_token', 'demo-token');
    await prefs.setString('pf_user_email', _emailCtrl.text.trim());
    if (mounted) {
      context.go('/onboarding');
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dark = isDark(context);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () => context.pop(),
        ),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: dark
                ? [Palette.surface0, Palette.black]
                : [const Color(0xFFF8FAFC), Colors.white],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: _sent ? _buildSentState(theme, dark) : _buildInputState(theme, dark),
          ),
        ),
      ),
    );
  }

  Widget _buildInputState(ThemeData theme, bool dark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 40),

        // Icon.
        Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            color: Palette.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(16),
          ),
          child: const Icon(Icons.mail_outline, color: Palette.primary, size: 28),
        ).animate().fadeIn(duration: 300.ms).scale(
              begin: const Offset(0.8, 0.8),
              duration: 400.ms,
              curve: Curves.elasticOut,
            ),

        const SizedBox(height: 24),

        // Title.
        Text(
          'Enter your email',
          style: theme.textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ).animate().fadeIn(delay: 100.ms, duration: 400.ms).slideY(begin: 0.05),

        const SizedBox(height: 8),

        Text(
          "We'll send you a magic link to sign in.\nNo password needed.",
          style: theme.textTheme.bodyLarge?.copyWith(
            color: theme.hintColor,
            height: 1.5,
          ),
        ).animate().fadeIn(delay: 200.ms, duration: 400.ms),

        const SizedBox(height: 32),

        // Email input.
        TextField(
          controller: _emailCtrl,
          focusNode: _focusNode,
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.done,
          onSubmitted: (_) => _sendMagicLink(),
          style: const TextStyle(fontSize: 16),
          decoration: InputDecoration(
            hintText: 'you@example.com',
            prefixIcon: const Icon(Icons.alternate_email, size: 20),
          ),
        ).animate().fadeIn(delay: 300.ms, duration: 400.ms).slideY(begin: 0.05),

        const SizedBox(height: 20),

        // Send button.
        SizedBox(
          width: double.infinity,
          height: 54,
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: _isValidEmail ? Palette.gradientPrimary : null,
              color: _isValidEmail ? null : Palette.textTertiary.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(14),
              boxShadow: _isValidEmail
                  ? [
                      BoxShadow(
                        color: Palette.primary.withValues(alpha: 0.3),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ]
                  : null,
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(14),
                onTap: _isValidEmail ? _sendMagicLink : null,
                child: Center(
                  child: _loading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Text(
                          'Send Magic Link',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                ),
              ),
            ),
          ),
        ).animate().fadeIn(delay: 400.ms, duration: 400.ms).slideY(begin: 0.05),

        const Spacer(),

        // Demo: simulate verification.
        TextButton(
          onPressed: _simulateVerify,
          child: Text(
            'Demo: Skip verification',
            style: TextStyle(color: theme.hintColor, fontSize: 13),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildSentState(ThemeData theme, bool dark) {
    return Column(
      children: [
        const Spacer(flex: 2),

        // Success icon.
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: Palette.success.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.mark_email_read_outlined,
            color: Palette.success,
            size: 40,
          ),
        ).animate().scale(
              begin: const Offset(0, 0),
              duration: 500.ms,
              curve: Curves.elasticOut,
            ),

        const SizedBox(height: 24),

        Text(
          'Check your email',
          style: theme.textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ).animate().fadeIn(delay: 200.ms, duration: 400.ms),

        const SizedBox(height: 8),

        Text(
          'We sent a magic link to',
          style: theme.textTheme.bodyLarge?.copyWith(color: theme.hintColor),
        ),

        const SizedBox(height: 4),

        Text(
          _emailCtrl.text.trim(),
          style: theme.textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.w600,
            color: Palette.primary,
          ),
        ),

        const SizedBox(height: 8),

        Text(
          'Tap the link in your email to sign in.',
          style: theme.textTheme.bodyMedium?.copyWith(color: theme.hintColor),
          textAlign: TextAlign.center,
        ),

        const Spacer(flex: 2),

        // Resend button.
        if (_cooldown > 0)
          Text(
            'Resend in ${_cooldown}s',
            style: theme.textTheme.bodyMedium?.copyWith(color: theme.hintColor),
          )
        else
          TextButton(
            onPressed: _resend,
            child: const Text('Resend magic link'),
          ),

        const SizedBox(height: 12),

        // Demo: simulate verification.
        TextButton(
          onPressed: _simulateVerify,
          child: Text(
            'Demo: Skip verification',
            style: TextStyle(color: theme.hintColor, fontSize: 13),
          ),
        ),

        const SizedBox(height: 32),
      ],
    );
  }
}
