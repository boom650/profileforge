import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/ai/ai_location_recommender.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/premium_widgets.dart';
import '../../../core/widgets/tap_scale.dart';

/// ────────────────────────────────────────────────────────────────────────────
/// Geo Screen — AI-powered location recommendations.
///
/// Shows opportunities near the user's location, recommended by AI.
/// No GPS needed — user enters their city/area in onboarding.
/// ────────────────────────────────────────────────────────────────────────────
class GeoScreen extends ConsumerWidget {
  const GeoScreen({super.key, required this.location});
  final String location;

  static const _categoryIcons = {
    'library': Icons.menu_book,
    'hackathon': Icons.code,
    'volunteer': Icons.volunteer_activism,
    'seminar': Icons.campaign,
    'competition': Icons.emoji_events,
    'internship': Icons.work,
    'museum': Icons.museum,
    'lab': Icons.science,
  };

  static const _categoryColors = {
    'library': Color(0xFF3B82F6),
    'hackathon': Color(0xFF8B5CF6),
    'volunteer': Color(0xFF10B981),
    'seminar': Color(0xFFF59E0B),
    'competition': Color(0xFFEF4444),
    'internship': Color(0xFF06B6D4),
    'museum': Color(0xFFEC4899),
    'lab': Color(0xFFF97316),
  };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dark = Theme.of(context).brightness == Brightness.dark;

    // Get recommendations from AI
    final recommendationsAsync = ref.watch(
      aiLocationRecommendationsProvider((
        location: location,
        interests: [], // Could pull from onboarding profile
        goal: null,
      )),
    );

    return Scaffold(
      backgroundColor: dark ? Palette.black : const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: dark ? Palette.surface1 : Colors.white,
        elevation: 0,
        title: Text(
          'Near $location',
          style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white70, size: 22),
            onPressed: () {
              HapticFeedback.lightImpact();
              ref.invalidate(aiLocationRecommendationsProvider);
            },
          ),
        ],
      ),
      body: recommendationsAsync.when(
        data: (opportunities) {
          if (opportunities.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.location_off, color: Palette.textTertiary, size: 48),
                  const SizedBox(height: 12),
                  Text(
                    'No recommendations found',
                    style: TextStyle(color: Palette.textPrimary, fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Try updating your location in settings',
                    style: TextStyle(color: Palette.textSecondary, fontSize: 13),
                  ),
                ],
              ),
            );
          }

          return CustomScrollView(
            slivers: [
              // Header
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.auto_awesome, color: Palette.primary, size: 18),
                          const SizedBox(width: 8),
                          Text(
                            'AI Recommendations',
                            style: TextStyle(
                              color: Palette.primary,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${opportunities.length} opportunities near $location',
                        style: TextStyle(
                          color: Palette.textPrimary,
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Personalized for your college application journey',
                        style: TextStyle(
                          color: Palette.textSecondary,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ).animate().fadeIn(duration: 300.ms),
              ),

              // Category filter chips
              SliverToBoxAdapter(
                child: SizedBox(
                  height: 48,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    children: [
                      _FilterChip(label: 'All', selected: true),
                      ..._categoryIcons.entries.map((e) =>
                        _FilterChip(label: e.key, selected: false)),
                    ],
                  ),
                ),
              ),

              // Opportunity cards
              SliverPadding(
                padding: const EdgeInsets.all(16),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, i) {
                      final o = opportunities[i];
                      final color = _categoryColors[o.category] ?? Palette.primary;
                      final icon = _categoryIcons[o.category] ?? Icons.place;

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: TapScale(
                          onTap: () => HapticFeedback.selectionClick(),
                          child: Container(
                            decoration: BoxDecoration(
                              color: dark ? Palette.surface1 : Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: color.withValues(alpha: 0.2),
                              ),
                            ),
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    // Category icon
                                    Container(
                                      width: 44,
                                      height: 44,
                                      decoration: BoxDecoration(
                                        color: color.withValues(alpha: 0.12),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Icon(icon, color: color, size: 22),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  o.title,
                                                  style: TextStyle(
                                                    color: Palette.textPrimary,
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.w700,
                                                  ),
                                                ),
                                              ),
                                              if (o.verified)
                                                Container(
                                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                                  decoration: BoxDecoration(
                                                    color: Palette.success.withValues(alpha: 0.12),
                                                    borderRadius: BorderRadius.circular(6),
                                                  ),
                                                  child: Row(
                                                    mainAxisSize: MainAxisSize.min,
                                                    children: [
                                                      Icon(Icons.verified, color: Palette.success, size: 12),
                                                      const SizedBox(width: 4),
                                                      Text(
                                                        'Verified',
                                                        style: TextStyle(
                                                          color: Palette.success,
                                                          fontSize: 10,
                                                          fontWeight: FontWeight.w600,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                            ],
                                          ),
                                          const SizedBox(height: 2),
                                          Text(
                                            o.address,
                                            style: TextStyle(
                                              color: Palette.textSecondary,
                                              fontSize: 12,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                // Description
                                Text(
                                  o.description,
                                  style: TextStyle(
                                    color: Palette.textPrimary,
                                    fontSize: 13,
                                    height: 1.4,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                // Relevance tag
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: color.withValues(alpha: 0.08),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(Icons.lightbulb_outline, color: color, size: 14),
                                      const SizedBox(width: 6),
                                      Expanded(
                                        child: Text(
                                          o.relevance,
                                          style: TextStyle(
                                            color: color,
                                            fontSize: 11,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ).animate().fadeIn(delay: Duration(milliseconds: i * 60), duration: 300.ms)
                         .slideY(begin: 0.05),
                      );
                    },
                    childCount: opportunities.length,
                  ),
                ),
              ),
            ],
          );
        },
        loading: () => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(color: Palette.primary),
              const SizedBox(height: 16),
              Text(
                'Finding opportunities near $location...',
                style: TextStyle(color: Palette.textSecondary, fontSize: 14),
              ),
            ],
          ),
        ),
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
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool selected;
  const _FilterChip({required this.label, required this.selected});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: selected ? Palette.primary : Palette.surface1,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: selected ? Palette.primary : Palette.border.withValues(alpha: 0.3),
        ),
      ),
      child: Text(
        label[0].toUpperCase() + label.substring(1),
        style: TextStyle(
          color: selected ? Colors.white : Palette.textSecondary,
          fontSize: 13,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
