import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:profileforge/core/theme/app_theme.dart';
import 'ai_provider.dart';
import 'ai_service.dart';

/// AI Settings — configure API keys and test providers.
class AISettingsScreen extends StatefulWidget {
  const AISettingsScreen({super.key});
  @override
  State<AISettingsScreen> createState() => _AISettingsScreenState();
}

class _AISettingsScreenState extends State<AISettingsScreen> {
  final _keyStore = AIKeyStore();
  final _ai = AIService();
  final _controllers = <AIProviderType, TextEditingController>{};
  final _testing = <AIProviderType, bool>{};
  final _testResults = <AIProviderType, bool?>{};

  @override
  void initState() {
    super.initState();
    for (final p in AIProviders.fallbackChain) {
      _controllers[p.type] = TextEditingController();
      _testing[p.type] = false;
    }
    _loadKeys();
  }

  Future<void> _loadKeys() async {
    for (final p in AIProviders.fallbackChain) {
      final key = await _keyStore.getKey(p.type);
      if (key != null) _controllers[p.type]!.text = key;
    }
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    for (final c in _controllers.values) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _saveKey(AIProviderType type) async {
    final key = _controllers[type]!.text.trim();
    if (key.isEmpty) {
      await _keyStore.removeKey(type);
    } else {
      await _keyStore.setKey(type, key);
    }
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(key.isEmpty ? 'Key removed' : 'Key saved securely'),
          backgroundColor: Palette.success,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  Future<void> _testProvider(AIProviderType type) async {
    setState(() {
      _testing[type] = true;
      _testResults[type] = null;
    });

    // Save first, then test.
    await _saveKey(type);
    final result = await _ai.testProvider(type);

    if (mounted) {
      setState(() {
        _testing[type] = false;
        _testResults[type] = result;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final dark = isDark(context);

    return Scaffold(
      backgroundColor: dark ? Palette.black : Palette.cream,
      appBar: AppBar(
        title: const Text('AI Settings'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // Header card.
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: Palette.gradientPrimary,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '🤖 Configure AI Providers',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Add at least one API key. Free models tried first.\nAll keys stored locally via secure storage.',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.85),
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Provider cards.
          ...AIProviders.fallbackChain.map((provider) {
            final type = provider.type;
            final testing = _testing[type] ?? false;
            final result = _testResults[type];

            return Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: dark ? Palette.surface1 : Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: result == true
                        ? Palette.success
                        : result == false
                            ? Palette.error
                            : dark
                                ? Palette.border
                                : const Color(0xFFEDE3D6),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: Palette.primary.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            type == AIProviderType.openCodeZen
                                ? Icons.psychology_rounded
                                : type == AIProviderType.router
                                    ? Icons.router_rounded
                                    : Icons.memory_rounded,
                            size: 20,
                            color: Palette.primary,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                provider.name,
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 15,
                                  color: dark
                                      ? Palette.textPrimary
                                      : Palette.textInverse,
                                ),
                              ),
                              Text(
                                provider.model,
                                style: TextStyle(
                                  fontSize: 11,
                                  color: dark
                                      ? Palette.textSecondary
                                      : Palette.textTertiary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (result != null)
                          Icon(
                            result ? Icons.check_circle : Icons.error,
                            color: result ? Palette.success : Palette.error,
                            size: 20,
                          ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    // API Key field.
                    TextField(
                      controller: _controllers[type],
                      obscureText: true,
                      obscuringCharacter: '•',
                      style: TextStyle(
                        color: dark ? Palette.textPrimary : Palette.textInverse,
                        fontFamily: 'monospace',
                        fontSize: 13,
                      ),
                      decoration: InputDecoration(
                        hintText: 'Paste API key...',
                        hintStyle: TextStyle(
                          color: dark ? Palette.textTertiary : Palette.textSecondary,
                        ),
                        prefixIcon: const Icon(Icons.key, size: 18),
                        suffixIcon: _controllers[type]!.text.isNotEmpty
                            ? IconButton(
                                icon: const Icon(Icons.clear, size: 18),
                                onPressed: () {
                                  _controllers[type]!.clear();
                                  setState(() {});
                                },
                              )
                            : null,
                        filled: true,
                        fillColor: dark ? Palette.surface2 : const Color(0xFFF4ECE1),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      onChanged: (_) => setState(() {}),
                    ),

                    const SizedBox(height: 10),

                    // Actions.
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: testing ? null : () => _testProvider(type),
                            icon: testing
                                ? const SizedBox(
                                    width: 16,
                                    height: 16,
                                    child: CircularProgressIndicator(strokeWidth: 2),
                                  )
                                : const Icon(Icons.wifi_find, size: 18),
                            label: Text(testing ? 'Testing...' : 'Test Connection'),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Palette.primary,
                              side: const BorderSide(color: Palette.primary),
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () => _saveKey(type),
                            icon: const Icon(Icons.save, size: 18),
                            label: const Text('Save'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Palette.primary,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          }),

          const SizedBox(height: 20),

          // Info card.
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Palette.info.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.info_outline, size: 18, color: Palette.info),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Free models (OpenCode Zen, 9Router) are tried first. '
                    'Nvidia NIM has 1000 credits. '
                    'Keys never leave your device.',
                    style: TextStyle(
                      fontSize: 12,
                      color: dark ? Palette.textSecondary : Palette.textTertiary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
