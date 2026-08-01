import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shimmer/shimmer.dart';
import 'package:profileforge/core/widgets/premium_widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:profileforge/core/theme/app_theme.dart';
import 'package:profileforge/core/widgets/poppy.dart';

class DiscoverScreen extends ConsumerWidget {
  const DiscoverScreen({super.key, required this.profileId});
  final String profileId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final tabs = ['Universities', 'Study', 'Competitions', 'Funding'];

    return DefaultTabController(
      length: tabs.length,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Discover'),
          bottom: TabBar(
            isScrollable: true,
            tabs: tabs.map((t) => Tab(text: t)).toList(),
          ),
        ),
        bottomNavigationBar: appBottomNav(context, '/discover'),
        body: TabBarView(
          children: [
            _UniversityList(),
            _StudyList(),
            _CompetitionList(),
            _FundingList(),
          ],
        ),
      ),
    );
  }
}

/// Attempts to load and decode a JSON asset; returns null on any failure.
Future<Map<String, dynamic>?> _loadJson(String path) async {
  try {
    final raw = await rootBundle.loadString(path);
    return jsonDecode(raw) as Map<String, dynamic>;
  } catch (_) {
    return null;
  }
}

/// Fallback widget shown when data fails to load or is empty.
Widget _emptyState(String message, {String emoji = '📭'}) {
  return Center(
    child: Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(emoji, style: const TextStyle(fontSize: 48)),
          const SizedBox(height: 12),
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 15, color: Colors.grey),
          ),
        ],
      ),
    ),
  );
}

class _UniversityList extends StatelessWidget {
  @override
  Widget build(BuildContext context) => FutureBuilder<Map<String, dynamic>?>(
        future: _loadJson('assets/content_pack.json'),
        builder: (ctx, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return Center(
            child: MissionListSkeleton(),
          );
          }
          final data = snap.data;
          if (data == null || !data.containsKey('university_guides')) {
            return _emptyState('Could not load university guides. Pull latest data via sync.',
                emoji: '🏛️');
          }
          final guides = (data['university_guides'] as Map).cast<String, dynamic>();
          if (guides.isEmpty) {
            return _emptyState('No university guides available yet.', emoji: '🏛️');
          }
          return ListView(
            padding: const EdgeInsets.all(16),
            children: guides.entries.map((e) {
              final g = e.value as Map;
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Palette.blue.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(e.key,
                        style: const TextStyle(
                            fontWeight: FontWeight.w900, fontSize: 18)),
                    const SizedBox(height: 6),
                    Text(g['overview'] as String? ?? ''),
                    const SizedBox(height: 8),
                    ...(g['what_matters'] is List
                        ? (g['what_matters'] as List).map((m) => Padding(
                              padding: const EdgeInsets.only(bottom: 3),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('• ',
                                      style:
                                          TextStyle(fontWeight: FontWeight.w900)),
                                  Expanded(child: Text(m.toString())),
                                ],
                              ),
                            ))
                        : []),
                  ],
                ),
              ).animate().fadeIn();
            }).toList(),
          );
        },
      );
}

class _StudyList extends StatelessWidget {
  @override
  Widget build(BuildContext context) => FutureBuilder<Map<String, dynamic>?>(
        future: _loadJson('assets/facts.json'),
        builder: (ctx, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return Center(
            child: MissionListSkeleton(),
          );
          }
          final data = snap.data;
          if (data == null || !data.containsKey('study_tips')) {
            return _emptyState('Study tips not loaded yet.', emoji: '💡');
          }
          final tips = (data['study_tips'] as List?)?.cast<String>() ?? [];
          if (tips.isEmpty) {
            return _emptyState('No study tips available.', emoji: '💡');
          }
          return ListView(
            padding: const EdgeInsets.all(16),
            children: tips
                .map((t) => Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Palette.green.withValues(alpha: 0.10),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Row(
                        children: [
                          const Text('💡', style: TextStyle(fontSize: 20)),
                          const SizedBox(width: 10),
                          Expanded(child: Text(t)),
                        ],
                      ),
                    ))
                .toList(),
          );
        },
      );
}

class _CompetitionList extends StatelessWidget {
  @override
  Widget build(BuildContext context) => FutureBuilder<Map<String, dynamic>?>(
        future: _loadJson('assets/extra_content.json'),
        builder: (ctx, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return Center(
            child: MissionListSkeleton(),
          );
          }
          final data = snap.data;
          if (data == null || !data.containsKey('olympiads')) {
            return _emptyState('Competition data could not be loaded.', emoji: '🏆');
          }
          final list = (data['olympiads'] as List?)?.cast<Map>() ?? [];
          if (list.isEmpty) {
            return _emptyState('No competitions listed yet.', emoji: '🏆');
          }
          return ListView(
            padding: const EdgeInsets.all(16),
            children: list
                .map((o) => Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Palette.purple.withValues(alpha: 0.10),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Row(
                        children: [
                          const Text('🏆', style: TextStyle(fontSize: 20)),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                                '${o['name']} — ${o['subject']} (${o['region']})'),
                          ),
                        ],
                      ),
                    ))
                .toList(),
          );
        },
      );
}

class _FundingList extends StatelessWidget {
  @override
  Widget build(BuildContext context) => FutureBuilder<Map<String, dynamic>?>(
        future: _loadJson('assets/extra_content.json'),
        builder: (ctx, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return Center(
            child: MissionListSkeleton(),
          );
          }
          final data = snap.data;
          if (data == null || !data.containsKey('scholarships')) {
            return _emptyState('Scholarship data missing. Sync to update.', emoji: '💰');
          }
          final list = (data['scholarships'] as List?)?.cast<Map>() ?? [];
          if (list.isEmpty) {
            return _emptyState('No scholarships listed yet.', emoji: '💰');
          }
          return ListView(
            padding: const EdgeInsets.all(16),
            children: list
                .map((o) => Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Palette.yellow.withValues(alpha: 0.14),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Row(
                        children: [
                          const Text('💰', style: TextStyle(fontSize: 20)),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(o['name'].toString(),
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w800)),
                                Text(o['note'].toString(),
                                    style:
                                        const TextStyle(fontSize: 12)),
                              ],
                            ),
                          ),
                          Text(o['region'].toString(),
                              style: const TextStyle(
                                  fontWeight: FontWeight.w700, fontSize: 12)),
                        ],
                      ),
                    ))
                .toList(),
          );
        },
      );
}
