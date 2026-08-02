import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:profileforge/core/effects/error_widgets.dart';
import 'package:profileforge/core/theme/app_theme.dart';

import '../../../core/ai/ai_providers.dart';
import '../../../core/ai/fallback_llm_client.dart';
import '../../../core/ai/provider_config.dart';
import '../../../core/widgets/premium_widgets.dart';

/// ────────────────────────────────────────────────────────────────────────────
/// AI Settings Screen — Shows fallback system status and provider health.
/// No manual configuration needed — all 3 providers are pre-configured.
/// ────────────────────────────────────────────────────────────────────────────
class AiSettingsScreen extends ConsumerStatefulWidget {
  const AiSettingsScreen({super.key});

  @override
  ConsumerState<AiSettingsScreen> createState() => _AiSettingsScreenState();
}

class _AiSettingsScreenState extends ConsumerState<AiSettingsScreen> {
  List<Map<String, dynamic>> _healthStatus = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadHealth();
  }

  Future<void> _loadHealth() async {
    final client = getFallbackClient();
    setState(() {
      _healthStatus = client.getHealthStatus();
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final dark = isDark(context);

    return Scaffold(
      backgroundColor: dark ? Palette.black : const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: dark ? Palette.surface1 : Colors.white,
        title: const Text(
          'AI Settings',
          style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600),
        ),
      ),
      body: _isLoading
          ? const Center(child: ShimmerLoader.card())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Status Banner ──
                  GlassCard(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: Palette.success.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(Icons.auto_awesome, color: Palette.success, size: 22),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'AI Active — 3 Providers',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 15,
                                ),
                              ),
                              Text(
                                'Automatic failover enabled',
                                style: TextStyle(
                                  color: Colors.white.withValues(alpha: 0.7),
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Palette.success.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Text(
                            'LIVE',
                            style: TextStyle(
                              color: Palette.success,
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ).animate().fadeIn(duration: 300.ms),
                  const SizedBox(height: 24),

                  // ── Provider List ──
                  Text(
                    'Providers (Auto-Failover)',
                    style: TextStyle(
                      color: Palette.textPrimary,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'If one fails, the next is tried automatically',
                    style: TextStyle(color: Palette.textSecondary, fontSize: 13),
                  ),
                  const SizedBox(height: 12),
                  ...List.generate(_healthStatus.length, (i) {
                    final provider = _healthStatus[i];
                    return _ProviderCard(
                      provider: provider,
                      index: i,
                    ).animate().fadeIn(delay: Duration(milliseconds: i * 100), duration: 300.ms);
                  }),
                  const SizedBox(height: 24),

                  // ── How It Works ──
                  Text(
                    'How It Works',
                    style: TextStyle(
                      color: Palette.textPrimary,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _HowItWorksTile(
                    icon: Icons.looks_one,
                    title: 'Try Primary',
                    subtitle: 'OpenCode Zen free models first',
                    color: Palette.primary,
                  ),
                  _HowItWorksTile(
                    icon: Icons.looks_two,
                    title: 'Try Backup',
                    subtitle: 'Nvidia NIM (1000 free credits)',
                    color: Palette.accent,
                  ),
                  _HowItWorksTile(
                    icon: Icons.looks_3,
                    title: 'Try Last Resort',
                    subtitle: '9Router local proxy',
                    color: Palette.info,
                  ),
                  const SizedBox(height: 24),

                  // ── Free Models ──
                  Text(
                    'Available Free Models',
                    style: TextStyle(
                      color: Palette.textPrimary,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ...ProfileForgeLlmConfig.openCodeZen.freeModels.map((model) => 
                    _ModelChip(name: model, provider: 'OpenCode Zen')
                  ),
                  const SizedBox(height: 8),
                  ...ProfileForgeLlmConfig.nvidiaNim.freeModels.map((model) => 
                    _ModelChip(name: model, provider: 'Nvidia NIM')
                  ),
                  const SizedBox(height: 8),
                  ...ProfileForgeLlmConfig.nineRouter.freeModels.map((model) => 
                    _ModelChip(name: model, provider: '9Router')
                  ),
                  const SizedBox(height: 32),

                  // ── Features ──
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
                  const SizedBox(height: 40),
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
}

/// Provider health card.
class _ProviderCard extends StatelessWidget {
  final Map<String, dynamic> provider;
  final int index;

  const _ProviderCard({required this.provider, required this.index});

  @override
  Widget build(BuildContext context) {
    final isOnCooldown = provider['isOnCooldown'] ?? false;
    final failures = provider['consecutiveFailures'] ?? 0;
    final models = List<String>.from(provider['models'] ?? []);
    
    Color statusColor;
    String statusText;
    IconData statusIcon;
    
    if (isOnCooldown) {
      statusColor = Palette.warning;
      statusText = 'Cooling down';
      statusIcon = Icons.hourglass_empty;
    } else if (failures > 0) {
      statusColor = Palette.warning;
      statusText = '$failures recent failures';
      statusIcon = Icons.warning_amber;
    } else {
      statusColor = Palette.success;
      statusText = 'Active';
      statusIcon = Icons.check_circle;
    }

    return GlassCard(
      padding: const EdgeInsets.all(14),
      margin: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // Priority badge
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: Palette.primary.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Text(
                    '${index + 1}',
                    style: const TextStyle(
                      color: Palette.primary,
                      fontWeight: FontWeight.w800,
                      fontSize: 13,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      provider['name'] ?? 'Unknown',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      '${models.length} free models',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.6),
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(statusIcon, color: statusColor, size: 12),
                    const SizedBox(width: 4),
                    Text(
                      statusText,
                      style: TextStyle(
                        color: statusColor,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          // Model list
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: models.map((m) => Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                m,
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.7),
                  fontSize: 10,
                  fontFamily: 'monospace',
                ),
              ),
            )).toList(),
          ),
        ],
      ),
    );
  }
}

/// How-it-works step tile.
class _HowItWorksTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;

  const _HowItWorksTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 18),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: TextStyle(color: Palette.textPrimary, fontSize: 14, fontWeight: FontWeight.w600)),
              Text(subtitle, style: TextStyle(color: Palette.textSecondary, fontSize: 12)),
            ],
          ),
        ],
      ),
    );
  }
}

/// Model chip.
class _ModelChip extends StatelessWidget {
  final String name;
  final String provider;

  const _ModelChip({required this.name, required this.provider});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: Palette.success,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              name,
              style: TextStyle(
                color: Palette.textPrimary,
                fontSize: 13,
                fontFamily: 'monospace',
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: Palette.surface2,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              provider,
              style: TextStyle(color: Palette.textTertiary, fontSize: 10),
            ),
          ),
        ],
      ),
    );
  }
}
