import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

class _UniversityList extends StatelessWidget {
  @override
  Widget build(BuildContext context) => FutureBuilder<Map<String, dynamic>>(
        future: rootBundle
            .loadString('assets/content_pack.json')
            .then((s) => jsonDecode(s) as Map<String, dynamic>),
        builder: (ctx, snap) {
          if (!snap.hasData) return const Center(child: CircularProgressIndicator());
          final guides =
              (snap.data!['university_guides'] as Map).cast<String, dynamic>();
          return ListView(
            padding: const EdgeInsets.all(16),
            children: guides.entries.map((e) {
              final g = e.value as Map;
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Palette.blue.withOpacity(0.10),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(e.key,
                        style: const TextStyle(
                            fontWeight: FontWeight.w900, fontSize: 18)),
                    const SizedBox(height: 6),
                    Text(g['overview'] as String),
                    const SizedBox(height: 8),
                    ...(g['what_matters'] as List).map((m) => Padding(
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
                        )),
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
  Widget build(BuildContext context) => FutureBuilder<Map<String, dynamic>>(
        future: rootBundle
            .loadString('assets/facts.json')
            .then((s) => jsonDecode(s) as Map<String, dynamic>),
        builder: (ctx, snap) {
          if (!snap.hasData) return const Center(child: CircularProgressIndicator());
          final tips = (snap.data!['study_tips'] as List).cast<String>();
          return ListView(
            padding: const EdgeInsets.all(16),
            children: tips
                .map((t) => Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Palette.green.withOpacity(0.10),
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
  Widget build(BuildContext context) => FutureBuilder<Map<String, dynamic>>(
        future: rootBundle
            .loadString('assets/extra_content.json')
            .then((s) => jsonDecode(s) as Map<String, dynamic>),
        builder: (ctx, snap) {
          if (!snap.hasData) return const Center(child: CircularProgressIndicator());
          final list = (snap.data!['olympiads'] as List).cast<Map>();
          return ListView(
            padding: const EdgeInsets.all(16),
            children: list
                .map((o) => Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Palette.purple.withOpacity(0.10),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Row(
                        children: [
                          const Text('🏆', style: TextStyle(fontSize: 20)),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text('${o['name']} — ${o['subject']} (${o['region']})'),
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
  Widget build(BuildContext context) => FutureBuilder<Map<String, dynamic>>(
        future: rootBundle
            .loadString('assets/extra_content.json')
            .then((s) => jsonDecode(s) as Map<String, dynamic>),
        builder: (ctx, snap) {
          if (!snap.hasData) return const Center(child: CircularProgressIndicator());
          final list = (snap.data!['scholarships'] as List).cast<Map>();
          return ListView(
            padding: const EdgeInsets.all(16),
            children: list
                .map((o) => Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Palette.yellow.withOpacity(0.14),
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
