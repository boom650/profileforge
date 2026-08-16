import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:profileforge/core/theme/app_theme.dart';
import 'package:profileforge/features/discovery/application/discovery_providers.dart';

class DiscoverScreen extends ConsumerWidget {
  const DiscoverScreen({super.key, required this.profileId});
  final String profileId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
        body: TabBarView(
          children: [
            const _UniversityList(),
            const _StudyList(),
            const _CompetitionList(),
            const _FundingList(),
          ],
        ),
      ),
    );
  }
}

/// Fallback widget shown when data fails to load or is empty.
Widget _emptyState(String message, {IconData icon = Icons.inbox_rounded}) {
  return Center(
    child: Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 48, color: Palette.inkSoft),
          const SizedBox(height: 12),
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 15, color: Palette.inkSoft),
          ),
        ],
      ),
    ),
  );
}

class _UniversityList extends ConsumerWidget {
  const _UniversityList();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(universityGuidesProvider).when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (_, __) => _emptyState(
            'Could not load university guides. Pull latest data via sync.',
            icon: Icons.flag_rounded,
          ),
          data: (guides) {
            if (guides == null) {
              return _emptyState(
                'Could not load university guides. Pull latest data via sync.',
                icon: Icons.flag_rounded,
              );
            }
            if (guides.isEmpty) {
              return _emptyState('No university guides available yet.',
                  icon: Icons.flag_rounded);
            }
            return ListView(
              padding: const EdgeInsets.all(16),
              children: guides.map((g) {
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
                      Text(g.name,
                          style: const TextStyle(
                              fontWeight: FontWeight.w700, fontSize: 18)),
                      const SizedBox(height: 6),
                      Text(g.overview),
                      const SizedBox(height: 8),
                      ...g.whatMatters.map((m) => Padding(
                            padding: const EdgeInsets.only(bottom: 3),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('• ',
                                    style:
                                        TextStyle(fontWeight: FontWeight.w700)),
                                Expanded(child: Text(m)),
                              ],
                            ),
                          )),
                    ],
                  ),
                ).animate().fadeIn();
              }).toList(),
            );
          },
        );
  }
}

class _StudyList extends ConsumerWidget {
  const _StudyList();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(studyTipsProvider).when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (_, __) => _emptyState('Study tips not loaded yet.',
              icon: Icons.tips_and_updates_rounded),
          data: (tips) {
            if (tips == null) {
              return _emptyState('Study tips not loaded yet.',
                  icon: Icons.tips_and_updates_rounded);
            }
            if (tips.isEmpty) {
              return _emptyState('No study tips available.',
                  icon: Icons.tips_and_updates_rounded);
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
                            const Icon(Icons.tips_and_updates_rounded,
                                size: 20, color: Palette.green),
                            const SizedBox(width: 10),
                            Expanded(child: Text(t.text)),
                          ],
                        ),
                      ))
                  .toList(),
            );
          },
        );
  }
}

class _CompetitionList extends ConsumerWidget {
  const _CompetitionList();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(olympiadsProvider).when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (_, __) => _emptyState('Competition data could not be loaded.',
              icon: Icons.emoji_events_rounded),
          data: (list) {
            if (list == null) {
              return _emptyState('Competition data could not be loaded.',
                  icon: Icons.emoji_events_rounded);
            }
            if (list.isEmpty) {
              return _emptyState('No competitions listed yet.',
                  icon: Icons.emoji_events_rounded);
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
                            const Icon(Icons.emoji_events_rounded,
                                size: 20, color: Palette.accentYellow),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text('${o.name} — ${o.subject} (${o.region})'),
                            ),
                          ],
                        ),
                      ))
                  .toList(),
            );
          },
        );
  }
}

class _FundingList extends ConsumerWidget {
  const _FundingList();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(scholarshipsProvider).when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (_, __) => _emptyState('Scholarship data missing. Sync to update.',
              icon: Icons.school_rounded),
          data: (list) {
            if (list == null) {
              return _emptyState('Scholarship data missing. Sync to update.',
                  icon: Icons.school_rounded);
            }
            if (list.isEmpty) {
              return _emptyState('No scholarships listed yet.',
                  icon: Icons.school_rounded);
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
                            const Icon(Icons.school_rounded,
                                size: 20, color: Palette.yellow),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(o.name,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w700)),
                                  Text(o.note,
                                      style:
                                          const TextStyle(fontSize: 12)),
                                ],
                              ),
                            ),
                            Text(o.region,
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
}