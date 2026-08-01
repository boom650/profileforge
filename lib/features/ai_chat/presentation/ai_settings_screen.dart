import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/ai/ai_providers.dart';
import '../../../core/ai/llm_client.dart';
import '../../../core/theme/app_theme.dart';

/// Settings screen for AI configuration — supports multiple providers
class AiSettingsScreen extends ConsumerStatefulWidget {
  const AiSettingsScreen({super.key});

  @override
  ConsumerState<AiSettingsScreen> createState() => _AiSettingsScreenState();
}

class _AiSettingsScreenState extends ConsumerState<AiSettingsScreen> {
  final _keyController = TextEditingController();
  final _baseUrlController = TextEditingController();
  final _modelController = TextEditingController();
  bool _obscureKey = true;
  bool _saved = false;
  LlmProvider _selectedProvider = LlmProvider.opencodeZen;

  @override
  void initState() {
    super.initState();
    _loadConfig();
  }

  Future<void> _loadConfig() async {
    final key = await ref.read(llmApiKeyProvider.future);
    final provider = await ref.read(llmProviderTypeProvider.future);
    final baseUrl = await ref.read(llmBaseUrlProvider.future);
    final model = await ref.read(llmModelProvider.future);

    if (mounted) {
      setState(() {
        if (key != null) _keyController.text = key;
        _selectedProvider = provider;
        if (baseUrl != null) _baseUrlController.text = baseUrl;
        if (model != null) _modelController.text = model;
      });
    }
  }

  @override
  void dispose() {
    _keyController.dispose();
    _baseUrlController.dispose();
    _modelController.dispose();
    super.dispose();
  }

  Future<void> _saveConfig() async {
    final key = _keyController.text.trim();
    if (key.isEmpty) {
      await deleteLlmConfig();
    } else {
      await saveLlmConfig(
        apiKey: key,
        provider: _selectedProvider,
        baseUrl: _selectedProvider == LlmProvider.custom
            ? _baseUrlController.text.trim()
            : null,
        model: _selectedProvider == LlmProvider.custom
            ? _modelController.text.trim()
            : null,
      );
    }

    // Invalidate all AI providers
    ref.invalidate(llmApiKeyProvider);
    ref.invalidate(llmProviderTypeProvider);
    ref.invalidate(llmBaseUrlProvider);
    ref.invalidate(llmModelProvider);
    ref.invalidate(llmServiceProvider);
    ref.invalidate(aiConfiguredProvider);

    setState(() => _saved = true);
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) setState(() => _saved = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    final aiConfigured = ref.watch(aiConfiguredProvider);

    return Scaffold(
      backgroundColor: Palette.black,
      appBar: AppBar(
        backgroundColor: Palette.surface1,
        title: const Text(
          'AI Settings',
          style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Status indicator
            aiConfigured.when(
              data: (configured) => Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: configured
                      ? Palette.success.withValues(alpha: 0.1)
                      : Palette.warning.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: configured
                        ? Palette.success.withValues(alpha: 0.3)
                        : Palette.warning.withValues(alpha: 0.3),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      configured ? Icons.check_circle : Icons.warning_amber,
                      color: configured ? Palette.success : Palette.warning,
                      size: 20,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      configured ? 'AI is configured and ready' : 'AI not configured',
                      style: TextStyle(
                        color: configured ? Palette.success : Palette.warning,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              loading: () => const SizedBox.shrink(),
              error: (_, __) => const SizedBox.shrink(),
            ),
            const SizedBox(height: 24),

            // Provider selector
            Text(
              'AI Provider',
              style: TextStyle(
                color: Palette.textPrimary,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Choose which AI service to use',
              style: TextStyle(color: Palette.textSecondary, fontSize: 13),
            ),
            const SizedBox(height: 12),
            ...LlmProvider.values.map((p) => _providerTile(p)),
            const SizedBox(height: 24),

            // API Key
            Text(
              'API Key',
              style: TextStyle(
                color: Palette.textPrimary,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              _getKeyHint(),
              style: TextStyle(color: Palette.textSecondary, fontSize: 13),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _keyController,
              obscureText: _obscureKey,
              style: TextStyle(color: Palette.textPrimary, fontSize: 14),
              decoration: InputDecoration(
                hintText: _getKeyPlaceholder(),
                hintStyle: TextStyle(color: Palette.textTertiary),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Palette.border),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Palette.border),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Palette.primary),
                ),
                filled: true,
                fillColor: Palette.surface1,
                suffixIcon: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(
                        _obscureKey ? Icons.visibility : Icons.visibility_off,
                        color: Palette.textSecondary,
                      ),
                      onPressed: () => setState(() => _obscureKey = !_obscureKey),
                    ),
                    if (_keyController.text.isNotEmpty)
                      IconButton(
                        icon: Icon(Icons.clear, color: Palette.textSecondary),
                        onPressed: () {
                          _keyController.clear();
                          _saveConfig();
                        },
                      ),
                  ],
                ),
              ),
            ),

            // Custom provider fields
            if (_selectedProvider == LlmProvider.custom) ...[
              const SizedBox(height: 16),
              TextField(
                controller: _baseUrlController,
                style: TextStyle(color: Palette.textPrimary, fontSize: 14),
                decoration: InputDecoration(
                  hintText: 'https://your-api.com/v1',
                  hintStyle: TextStyle(color: Palette.textTertiary),
                  labelText: 'Base URL',
                  labelStyle: TextStyle(color: Palette.textSecondary),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Palette.border),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Palette.border),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Palette.primary),
                  ),
                  filled: true,
                  fillColor: Palette.surface1,
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _modelController,
                style: TextStyle(color: Palette.textPrimary, fontSize: 14),
                decoration: InputDecoration(
                  hintText: 'e.g., gpt-4, claude-3-opus',
                  hintStyle: TextStyle(color: Palette.textTertiary),
                  labelText: 'Model name',
                  labelStyle: TextStyle(color: Palette.textSecondary),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Palette.border),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Palette.border),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Palette.primary),
                  ),
                  filled: true,
                  fillColor: Palette.surface1,
                ),
              ),
            ],

            const SizedBox(height: 20),

            // Save button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _saveConfig,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Palette.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  _saved ? '✓ Saved!' : 'Save Configuration',
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
            ),
            const SizedBox(height: 32),

            // Features list
            Text(
              'AI Features',
              style: TextStyle(
                color: Palette.textPrimary,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            _featureTile(Icons.chat_bubble_outline, 'AI Chat', 'Ask anything about your college application'),
            _featureTile(Icons.analytics_outlined, 'Artifact Analyzer', 'Analyze research papers, essays, and activities'),
            _featureTile(Icons.flag_outlined, 'Daily AI Missions', 'Personalized tasks based on your goals'),
            _featureTile(Icons.assessment_outlined, 'Readiness Check', 'Score your admissions readiness'),
          ],
        ),
      ),
    );
  }

  Widget _providerTile(LlmProvider provider) {
    final isSelected = provider == _selectedProvider;
    return GestureDetector(
      onTap: () => setState(() => _selectedProvider = provider),
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isSelected ? Palette.primary.withValues(alpha: 0.1) : Palette.surface1,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? Palette.primary : Palette.border,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
              color: isSelected ? Palette.primary : Palette.textTertiary,
              size: 20,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    provider.displayName,
                    style: TextStyle(
                      color: Palette.textPrimary,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                  if (provider.defaultBaseUrl.isNotEmpty)
                    Text(
                      provider.defaultBaseUrl,
                      style: TextStyle(color: Palette.textTertiary, fontSize: 11),
                    ),
                ],
              ),
            ),
            if (provider.defaultModel.isNotEmpty)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Palette.surface2,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  provider.defaultModel.split('/').last,
                  style: TextStyle(color: Palette.textSecondary, fontSize: 10),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _featureTile(IconData icon, String title, String subtitle) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Palette.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: Palette.primary, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(color: Palette.textPrimary, fontSize: 14, fontWeight: FontWeight.w500)),
                Text(subtitle, style: TextStyle(color: Palette.textSecondary, fontSize: 12)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getKeyHint() {
    switch (_selectedProvider) {
      case LlmProvider.opencodeZen:
        return 'Get your key from opencodezen.ai';
      case LlmProvider.nvidiaNim:
        return 'Get your free key from build.nvidia.com';
      case LlmProvider.groq:
        return 'Get your free key from console.groq.com';
      case LlmProvider.together:
        return 'Get your key from api.together.xyz';
      case LlmProvider.mistral:
        return 'Get your key from console.mistral.ai';
      case LlmProvider.custom:
        return 'Enter your API key';
    }
  }

  String _getKeyPlaceholder() {
    switch (_selectedProvider) {
      case LlmProvider.opencodeZen:
        return 'sk-...';
      case LlmProvider.nvidiaNim:
        return 'nvapi-...';
      case LlmProvider.groq:
        return 'gsk_...';
      case LlmProvider.together:
        return 'tok_...';
      case LlmProvider.mistral:
        return 'mist-...';
      case LlmProvider.custom:
        return 'Enter API key';
    }
  }
}
