import 'package:flutter/material.dart';
import '../../../core/effects/shimmer_skeleton.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/premium_widgets.dart';
import '../../../core/widgets/tap_scale.dart';
import '../application/profile_providers.dart';
import '../pdf_export.dart';

/// ────────────────────────────────────────────────────────────────────────────
/// Profile page — Premium card-based profile editor with avatar and stats.
/// ────────────────────────────────────────────────────────────────────────────
class ProfilePage extends ConsumerWidget {
  final String profileId;
  const ProfilePage({super.key, required this.profileId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(profileProvider(profileId));
    final notifier = ref.watch(profileProvider(profileId).notifier);
    final dark = isDark(context);

    return Scaffold(
      backgroundColor: dark ? Palette.black : const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: dark ? Palette.surface1 : Colors.white,
        elevation: 0,
        title: const Text(
          'Profile Builder',
          style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.picture_as_pdf, color: Colors.white70, size: 22),
            tooltip: 'Export PDF',
            onPressed: () async {
              HapticFeedback.lightImpact();
              final p = profile.value;
              if (p == null) return;
              final path = await exportProfilePdf(p);
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('PDF ready: $path'),
                    backgroundColor: Palette.surface2,
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                );
              }
            },
          ),
        ],
      ),
      body: SafeArea(
          child: profile.when(
        loading: () => const Center(child: ShimmerLoader.profile()),
        error: (e, _) => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error_outline, color: Palette.error, size: 48),
              const SizedBox(height: 12),
              Text('Error: $e', style: TextStyle(color: Palette.textSecondary)),
            ],
          ),
        ),
        data: (p) => SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              // ── Avatar + Name Card ──
              GlassCard(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    // Avatar
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Palette.primary, Palette.accent],
                        ),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Palette.primary.withValues(alpha: 0.3),
                            blurRadius: 20,
                            spreadRadius: -4,
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          (p.name?.isNotEmpty == true ? p.name![0] : 'U').toUpperCase(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 32,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      p.name?.isNotEmpty == true ? p.name! : 'Your Name',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      p.goal?.isNotEmpty == true ? p.goal! : 'Set your admissions goal',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.6),
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ).animate().fadeIn(duration: 400.ms),
              const SizedBox(height: 24),

              // ── Edit Fields ──
              _buildField(
                label: 'Name',
                value: p.name ?? '',
                icon: Icons.person_outline,
                onChanged: notifier.setName,
                maxLength: 32,
              ),
              const SizedBox(height: 12),
              _buildField(
                label: 'Admissions Goal',
                value: p.goal ?? '',
                icon: Icons.flag_outlined,
                onChanged: notifier.setGoal,
                maxLength: 100,
              ),
              const SizedBox(height: 24),

              // ── Achievements Section ──
              Row(
                children: [
                  Icon(Icons.emoji_events, color: Palette.accent, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    'Achievements',
                    style: TextStyle(
                      color: Palette.textPrimary,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: Palette.accent.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      '${p.achievements.length}',
                      style: const TextStyle(
                        color: Palette.accent,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              if (p.achievements.isEmpty)
                GlassCard(
                  padding: const EdgeInsets.all(24),
                  child: Center(
                    child: Column(
                      children: [
                        Icon(Icons.emoji_events_outlined, color: Palette.textTertiary, size: 32),
                        const SizedBox(height: 8),
                        Text(
                          'No achievements yet',
                          style: TextStyle(color: Palette.textSecondary, fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                )
              else
                ...p.achievements.asMap().entries.map((entry) {
                  final i = entry.key;
                  final a = entry.value;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: GlassCard(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                      child: Row(
                        children: [
                          Container(
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                              color: Palette.success.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(Icons.check, color: Palette.success, size: 16),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              a,
                              style: TextStyle(
                                color: Palette.textPrimary,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ).animate().fadeIn(delay: Duration(milliseconds: i * 50), duration: 200.ms),
                  );
                }),
              const SizedBox(height: 16),

              // Add Achievement button
              TapScale(
                onTap: () async {
                  HapticFeedback.mediumImpact();
                  final ctrl = TextEditingController();
                  final v = await showDialog<String>(
                    context: context,
                    builder: (c) => AlertDialog(
                      backgroundColor: Palette.surface1,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      title: const Text('New Achievement', style: TextStyle(color: Colors.white)),
                      content: TextField(
                        controller: ctrl,
                        autofocus: true,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          hintText: 'e.g., Won Science Olympiad',
                          hintStyle: TextStyle(color: Palette.textTertiary),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Palette.border),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(color: Palette.primary),
                          ),
                        ),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(c),
                          child: Text('Cancel', style: TextStyle(color: Palette.textSecondary)),
                        ),
                        FilledButton(
                          style: FilledButton.styleFrom(backgroundColor: Palette.primary),
                          onPressed: () => Navigator.pop(c, ctrl.text),
                          child: const Text('Add'),
                        ),
                      ],
                    ),
                  );
                  if (v != null && v.trim().isNotEmpty) {
                    notifier.addAchievement(v.trim());
                  }
                },
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  decoration: BoxDecoration(
                    color: Palette.surface1,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Palette.primary.withValues(alpha: 0.3)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.add, color: Palette.primary, size: 18),
                      const SizedBox(width: 8),
                      Text(
                        'Add Achievement',
                        style: TextStyle(
                          color: Palette.primary,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // View Badges button
              TapScale(
                onTap: () {
                  HapticFeedback.lightImpact();
                  context.push('/badges');
                },
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  decoration: BoxDecoration(
                    color: Palette.surface1,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Palette.border.withValues(alpha: 0.3)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.military_tech, color: Palette.accent, size: 18),
                      const SizedBox(width: 8),
                      Text(
                        'View Badges',
                        style: TextStyle(
                          color: Palette.textPrimary,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildField({
    required String label,
    required String value,
    required IconData icon,
    required ValueChanged<String> onChanged,
    int maxLength = 100,
  }) {
    final ctrl = TextEditingController(text: value);
    return GlassCard(
      padding: const EdgeInsets.all(4),
      child: TextField(
        controller: ctrl,
        style: const TextStyle(color: Colors.white, fontSize: 14),
        maxLength: maxLength,
        buildCounter: (ctx, {required currentLength, required isFocused, required maxLength}) =>
            const SizedBox.shrink(),
        onChanged: onChanged,
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: Palette.primary, size: 20),
          labelText: label,
          labelStyle: TextStyle(color: Palette.textSecondary),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
      ),
      ),
    );
  }
}
