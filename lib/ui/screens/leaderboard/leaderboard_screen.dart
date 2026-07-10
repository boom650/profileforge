// Leaderboard Screen — Weekly/All-Time XP rankings with animated medal tiers
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/app_theme.dart';

// ─── Data ────────────────────────────────────────────────────────────────

class LeaderboardEntry {
  final int rank;
  final String name;
  final int xp;
  final int level;
  final int streak;
  final bool isCurrentUser;
  const LeaderboardEntry({
    required this.rank, required this.name, required this.xp,
    required this.level, required this.streak, this.isCurrentUser = false,
  });
}

/// Pagination controller state.
class PaginationState {
  final int page;
  final int pageSize;
  final bool hasMore;
  final bool isLoading;

  const PaginationState({
    this.page = 1,
    this.pageSize = 20,
    this.hasMore = true,
    this.isLoading = false,
  });

  PaginationState copyWith({
    int? page,
    int? pageSize,
    bool? hasMore,
    bool? isLoading,
  }) {
    return PaginationState(
      page: page ?? this.page,
      pageSize: pageSize ?? this.pageSize,
      hasMore: hasMore ?? this.hasMore,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

/// Pagination notifier for infinite scroll / load more.
class PaginationNotifier extends StateNotifier<PaginationState> {
  PaginationNotifier() : super(const PaginationState());

  void loadMore() {
    if (!state.hasMore || state.isLoading) return;
    state = state.copyWith(page: state.page + 1, isLoading: true);
  }

  void setLoading(bool loading) {
    state = state.copyWith(isLoading: loading);
  }

  void setHasMore(bool hasMore) {
    state = state.copyWith(hasMore: hasMore);
  }

  void reset() {
    state = const PaginationState();
  }
}

final paginationProvider = StateNotifierProvider<PaginationNotifier, PaginationState>((ref) {
  return PaginationNotifier();
});
  return PaginationController(pageSize: 20);
});

/// Generates a page of leaderboard entries on demand.
List<LeaderboardEntry> _generatePage(int tab, int page, int pageSize) {
  const names = [
    'Aarav','Vivaan','Aditya','Arjun','Sai','Reyansh','Krishna',
    'Ishaan','Shaurya','Advaith','Vihaan','Arin','Darsh','Kabir',
    'Ayaan','Dhruv','Rohan','Kiran','Meera','Priya',
    'Arnav','Atharv','Kiaan','Aadi','Vivaan','Rudra','Aarush',
    'Vihaan','Dhruv','Aditya','Ishaan',
  ];
  const allTimeXp = [12450,11200,10800,9750,9200,8900,8350,7800,7400,6950,
    6500,6100,5750,5300,4900,4500,4100,3700,3300,2900,
    2600,2300,2000,1800,1600,1450,1300,1200];
  const weeklyXp = [2450,2100,1950,1800,1650,1500,1350,1200,1100,950,
    850,750,650,550,480,400,350,300,250,200,
    180,160,145,130,120,110,100,90];
  final xpList = tab == 0 ? weeklyXp : allTimeXp;
  final start = (page - 1) * pageSize;
  final end = (start + pageSize).clamp(0, xpList.length);
  if (start >= xpList.length) return [];
  return List.generate(end - start, (i) {
    final idx = start + i;
    return LeaderboardEntry(
      rank: idx + 1,
      name: names[idx % names.length],
      xp: xpList[idx],
      level: (xpList[idx] ~/ (tab == 0 ? 150 : 800)) + 1,
      streak: xpList.length - idx + (tab == 0 ? 2 : 5),
      isCurrentUser: names[idx % names.length] == 'Aarav',
    );
  });
}

final leaderboardProvider = Provider.family<List<LeaderboardEntry>, int>((ref, page) {
  final tab = ref.watch(leaderboardTabProvider);
  final controller = ref.watch(paginationProvider);
  controller.pageSize = 20;
  return _generatePage(tab, page, controller.pageSize);
});

// ─── Screen ──────────────────────────────────────────────────────────────────

class LeaderboardScreen extends ConsumerStatefulWidget {
  const LeaderboardScreen({super.key});
  @override
  ConsumerState<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends ConsumerState<LeaderboardScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tab;

  @override
  void initState() {
    super.initState();
    _tab = TabController(length: 2, vsync: this);
    _tab.addListener(() {
      if (!_tab.indexIsChanging) {
        ref.read(leaderboardTabProvider.notifier).state = _tab.index;
      }
    });
  }

  @override
  void dispose() { _tab.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    final controller = ref.watch(paginationProvider);
    final page1 = ref.watch(leaderboardProvider(1));
    final user = page1.firstWhere((e) => e.isCurrentUser, orElse: () => page1.first);

    return Scaffold(
      backgroundColor: dark ? AppTheme.surfaceDark : AppTheme.surfaceWhite,
      body: Column(children: [
        _header(context, dark, user),
        _tabs(context, dark),
        Expanded(
            child: RefreshIndicator(
                onRefresh: () async {
                  controller.reset();
                  ref.invalidate(leaderboardProvider(1));
                  await Future.delayed(const Duration(milliseconds: 1200));
                },
                color: AppTheme.accentPurple,
                child: _paginatedList(context, dark))),
      ]),
    );
  }

  // ── Header ──────────────────────────────────────────────────────────────

  Widget _header(BuildContext ctx, bool dark, LeaderboardEntry user) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(gradient: dark ? AppTheme.gradientPrimaryDark : AppTheme.gradientPrimary),
      child: SafeArea(bottom: false, child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
        child: Column(children: [
          Row(children: [
            IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 20),
              onPressed: () => Navigator.pop(ctx), 
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
              semanticLabel: 'Go back',
            ),
            const SizedBox(width: 12),
            Text('Leaderboard', style: GoogleFonts.inter(
              fontSize: 22, fontWeight: FontWeight.w700, color: Colors.white, letterSpacing: -0.3)),
          ]),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppTheme.surfaceWhite.withOpacity(0.15),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppTheme.surfaceWhite.withOpacity(0.25)),
            ),
            child: Row(children: [
              Container(
                width: 48, height: 48,
                decoration: BoxDecoration(
                  gradient: AppTheme.gradientGold, shape: BoxShape.circle,
                  boxShadow: [BoxShadow(color: AppTheme.accentGold.withOpacity(0.4),
                    blurRadius: 12, offset: const Offset(0, 4),
                    spreadRadius: -4)],
                ),
                child: Center(child: Text('#${user.rank}',
                  style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w800, color: Colors.white))),
              ),
              const SizedBox(width: 14),
              Expanded(child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(user.name, style: GoogleFonts.inter(
                    fontSize: 18, fontWeight: FontWeight.w700, color: AppTheme.surfaceWhite)),
                  const SizedBox(height: 2),
                  Text('Your rank this week', style: GoogleFonts.inter(
                    fontSize: 12, color: AppTheme.surfaceWhite.withOpacity(0.7))),
                ],
              )),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: AppTheme.surfaceWhite.withOpacity(0.2), borderRadius: BorderRadius.circular(20)),
                child: Row(children: [
                  const Icon(Icons.bolt_rounded, color: AppTheme.accentGold, size: 18),
                  const SizedBox(width: 4),
                  Text('${user.xp} XP', style: GoogleFonts.inter(
                    fontSize: 15, fontWeight: FontWeight.w700, color: Colors.white)),
                ]),
              ),
            ]),
          ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.15),
        ]),
      )),
    );
  }

  // ── Tabs ────────────────────────────────────────────────────────────────

  Widget _tabs(BuildContext ctx, bool dark) {
    return Container(
      color: dark ? AppTheme.surfaceDark : AppTheme.surfaceWhite,
      child: TabBar(controller: _tab, tabs: const [Tab(text: 'This Week'), Tab(text: 'All Time')]),
    );
  }

  // ── List ────────────────────────────────────────────────────────────────

  Widget _paginatedList(BuildContext ctx, bool dark) {
    final controller = ref.watch(paginationProvider);
    final allEntries = <LeaderboardEntry>[];

    for (var i = 1; i <= controller.page; i++) {
      final pageEntries = ref.watch(leaderboardProvider(i));
      allEntries.addAll(pageEntries);
      if (pageEntries.isEmpty) {
        controller.hasMore = false;
        break;
      }
    }

    if (allEntries.isEmpty) {
      return _emptyState(ctx, dark);
    }

    final top3 = allEntries.take(3).toList();
    final rest = allEntries.skip(3).toList();
    final textMuted = dark ? const Color(0xFF64748B) : AppTheme.textMuted;

    return NotificationListener<ScrollNotification>(
      onNotification: (ScrollNotification info) {
        if (info.metrics.pixels > info.metrics.maxScrollExtent - 100 &&
            controller.hasMore &&
            !controller.isLoading) {
          controller.isLoading = true;
          ref.read(paginationProvider.notifier).state = controller..loadMore();
          Future.delayed(const Duration(milliseconds: 500), () {
            controller.isLoading = false;
            ref.read(paginationProvider.notifier).state = controller;
          });
        }
        return false;
      },
      child: CustomScrollView(
        physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
        slivers: [
          SliverToBoxAdapter(child: _podium(ctx, dark, top3)),
          SliverToBoxAdapter(child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Container(height: 1, decoration: BoxDecoration(gradient: LinearGradient(
              colors: [
                Colors.transparent,
                (dark ? const Color(0xFF334155) : const Color(0xFFE2D5C8)).withOpacity(0.6),
                Colors.transparent
              ]
            ))),
          )),
          SliverToBoxAdapter(child: _columnHeaders(textMuted)),
          SliverList(delegate: SliverChildBuilderDelegate(
            (ctx, i) => _row(ctx, dark, rest[i])
                .animate().fadeIn(delay: Duration(milliseconds: 60 * (i + 3)), duration: 300.ms)
                .slideX(begin: 0.05, duration: 300.ms),
            childCount: rest.length,
          )),
          if (controller.isLoading)
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Center(child: CircularProgressIndicator()),
              ),
            ),
          const SliverToBoxAdapter(child: SizedBox(height: 80)),
        ],
      ),
    );
  }

  Widget _columnHeaders(Color textMuted) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 14, 20, 6),
      child: Row(children: [
        SizedBox(width: 36, child: Text('RANK', style: GoogleFonts.inter(
          fontSize: 10, fontWeight: FontWeight.w700, color: textMuted, letterSpacing: 1.2))),
        const SizedBox(width: 10),
        Expanded(child: Text('STUDENT', style: GoogleFonts.inter(
          fontSize: 10, fontWeight: FontWeight.w700, color: textMuted, letterSpacing: 1.2))),
        SizedBox(width: 52, child: Text('LVL', textAlign: TextAlign.center, style: GoogleFonts.inter(
          fontSize: 10, fontWeight: FontWeight.w700, color: textMuted, letterSpacing: 1.2))),
        const SizedBox(width: 12),
        const SizedBox(width: 48, child: Text('🔥', textAlign: TextAlign.center, style: TextStyle(fontSize: 11))),
        const SizedBox(width: 8),
        SizedBox(width: 72, child: Text('XP', textAlign: TextAlign.right, style: GoogleFonts.inter(
          fontSize: 10, fontWeight: FontWeight.w700, color: textMuted, letterSpacing: 1.2))),
      ]),
    );
  }

  // ── Podium ──────────────────────────────────────────────────────────────

  Widget _podium(BuildContext ctx, bool dark, List<LeaderboardEntry> top3) {
    if (top3.length < 3) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
      child: SizedBox(height: 200, child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(child: _podiumCard(ctx, dark, top3[1], AppTheme.accentSilver, 160, '🥈', delay: 300)),
          const SizedBox(width: 8),
          Expanded(child: _podiumCard(ctx, dark, top3[0], AppTheme.accentGold, 200, '🏆', isFirst: true, delay: 100)),
          const SizedBox(width: 8),
          Expanded(child: _podiumCard(ctx, dark, top3[2], AppTheme.accentBronze, 130, '🥉', delay: 500)),
        ],
      )),
    );
  }

  Widget _podiumCard(BuildContext ctx, bool dark, LeaderboardEntry e, Color medal,
      double h, String emoji, {bool isFirst = false, required int delay}) {
    final bg = dark ? AppTheme.surfaceDark : AppTheme.surfaceWhite;
    final hlBorder = e.isCurrentUser ? AppTheme.accentPurple : medal;
    final cardDecoration = BoxDecoration(
      color: bg,
      borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
      border: Border.all(color: hlBorder.withOpacity(e.isCurrentUser ? 0.8 : 0.3), width: e.isCurrentUser ? 2 : 1),
      boxShadow: isFirst ? [BoxShadow(color: medal.withOpacity(0.15), blurRadius: 20, offset: const Offset(0, 4))] : null,
    );

    return Column(mainAxisAlignment: MainAxisAlignment.end, children: [
      Stack(clipBehavior: Clip.none, alignment: Alignment.center, children: [
        Container(
          width: isFirst ? 64 : 56, height: isFirst ? 64 : 56,
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: [medal, medal.withValues(alpha: 0.7)]),
            shape: BoxShape.circle,
            boxShadow: [BoxShadow(color: medal.withValues(alpha: 0.35), blurRadius: 16, offset: const Offset(0, 6))],
          ),
          child: Center(child: Text(e.name[0], style: GoogleFonts.inter(
            fontSize: isFirst ? 24 : 20, fontWeight: FontWeight.w800, color: Colors.white))),
        ),
        Positioned(bottom: -6, child: Container(
          width: 28, height: 28,
          decoration: BoxDecoration(
            color: bg, shape: BoxShape.circle, border: Border.all(color: hlBorder, width: 2)),
          child: Center(child: Text(emoji, style: const TextStyle(fontSize: 14))),
        )),
      ]),
      const SizedBox(height: 14),
      Text(e.name, style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w700,
        color: dark ? Colors.white : AppTheme.textPrimary), maxLines: 1, overflow: TextOverflow.ellipsis),
      const SizedBox(height: 4),
      Text('${e.xp} XP', style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600, color: medal)),
      const SizedBox(height: 8),
      Container(width: double.infinity, height: h, decoration: cardDecoration,
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Text('#${e.rank}', style: GoogleFonts.inter(fontSize: isFirst ? 28 : 24,
            fontWeight: FontWeight.w800, color: medal)),
          if (e.isCurrentUser) Container(
            margin: const EdgeInsets.only(top: 4),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(color: AppTheme.accentPurple.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(8)),
            child: Text('YOU', style: GoogleFonts.inter(fontSize: 9, fontWeight: FontWeight.w800,
              color: AppTheme.accentPurple, letterSpacing: 1.5)),
          ),
        ]),
      ),
    ]).animate().fadeIn(delay: Duration(milliseconds: delay)).slideY(begin: 0.2, duration: 400.ms, curve: Curves.easeOutCubic);
  }

  // ── Row ─────────────────────────────────────────────────────────────────

  Widget _row(BuildContext ctx, bool dark, LeaderboardEntry e) {
    final isUser = e.isCurrentUser;
    final bg = dark ? AppTheme.surfaceDark : AppTheme.surfaceWhite;
    final border = dark ? AppTheme.surfaceDark : AppTheme.surfaceWhite;
    final textPri = dark ? AppTheme.textPrimary : AppTheme.textPrimary;
    final textSec = dark ? AppTheme.textSecondary : AppTheme.textSecondary;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: isUser ? AppTheme.accentPurple.withOpacity(dark ? 0.15 : 0.1) : bg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isUser ? AppTheme.accentPurple.withOpacity(0.6) : border,
          width: isUser ? 1.5 : 1),
        boxShadow: isUser ? [BoxShadow(color: AppTheme.accentPurple.withOpacity(0.15),
          blurRadius: 12, offset: const Offset(0, 4))] : null,
      ),
      child: Row(children: [
        SizedBox(width: 36, child: Text('${e.rank}', style: GoogleFonts.inter(
          fontSize: 16, fontWeight: FontWeight.w800, color: textSec))),
        const SizedBox(width: 10),
        Container(
          width: 40, height: 40,
          decoration: BoxDecoration(gradient: _avatarGradient(e.name), shape: BoxShape.circle),
          child: Center(child: Text(e.name[0], style: GoogleFonts.inter(
            fontSize: 17, fontWeight: FontWeight.w700, color: Colors.white))),
        ),
        const SizedBox(width: 12),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Flexible(child: Text(e.name, style: GoogleFonts.inter(fontSize: 15,
              fontWeight: isUser ? FontWeight.w700 : FontWeight.w600,
              color: isUser ? AppTheme.accentPurple : textPri), maxLines: 1, overflow: TextOverflow.ellipsis)),
            if (isUser) ...[
              const SizedBox(width: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                decoration: BoxDecoration(color: AppTheme.accentPurple.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(6)),
                child: Text('YOU', style: GoogleFonts.inter(fontSize: 8, fontWeight: FontWeight.w800,
                  color: AppTheme.accentPurple, letterSpacing: 1.0)),
              ),
            ],
          ]),
          const SizedBox(height: 2),
          Text('Lvl ${e.level}', style: GoogleFonts.inter(fontSize: 11, color: textSec)),
        ])),
        SizedBox(width: 52, child: Center(child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: dark ? AppTheme.surfaceDark.withOpacity(0.5) : AppTheme.surfaceLight,
            borderRadius: BorderRadius.circular(8)),
          child: Text('${e.level}', style: GoogleFonts.inter(
            fontSize: 13, fontWeight: FontWeight.w700, color: textSec))))),
        const SizedBox(width: 12),
        SizedBox(width: 48, child: Center(child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Text('🔥', style: TextStyle(fontSize: e.streak > 10 ? 14 : 12)),
          const SizedBox(width: 2),
          Text('${e.streak}', style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600,
            color: e.streak >= 7 ? AppTheme.accentOrange : textSec)),
        ]))),
        const SizedBox(width: 8),
        SizedBox(width: 72, child: Text(_formatXp(e.xp), textAlign: TextAlign.right,
          style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w700,
            color: isUser ? AppTheme.accentPurple : (dark ? Colors.white : AppTheme.textPrimary)))),
      ]),
    );
  }

  // ── Empty State ─────────────────────────────────────────────────────────

  Widget _emptyState(BuildContext ctx, bool dark) {
    return Center(child: Padding(
      padding: const EdgeInsets.all(40),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Container(width: 80, height: 80,
          decoration: BoxDecoration(color: AppTheme.accentPurple.withValues(alpha: 0.1), shape: BoxShape.circle),
          child: const Icon(Icons.leaderboard_rounded, size: 40, color: AppTheme.accentPurple)),
        const SizedBox(height: 20),
        Text('No Rankings Yet', style: GoogleFonts.inter(fontSize: 20, fontWeight: FontWeight.w700,
          color: dark ? Colors.white : AppTheme.textPrimary)),
        const SizedBox(height: 8),
        Text('Complete missions and earn XP to climb\nthe leaderboard!', textAlign: TextAlign.center,
          style: GoogleFonts.inter(fontSize: 14, color: dark ? AppTheme.textMuted : AppTheme.textSecondary, height: 1.5)),
        const SizedBox(height: 24),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          decoration: BoxDecoration(gradient: AppTheme.gradientPrimary, borderRadius: BorderRadius.circular(12)),
          child: Text('Start Earning XP', style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white)),
        ),
      ]),
    )).animate().fadeIn(duration: 500.ms).scale(begin: const Offset(0.9, 0.9), duration: 400.ms, curve: Curves.easeOutCubic);
  }

  // ── Helpers ─────────────────────────────────────────────────────────────

  String _formatXp(int xp) => xp >= 10000 ? '${(xp / 1000).toStringAsFixed(1)}k' : xp.toString();

  Color _avatarColor(String name) {
    return AppTheme.categoryColors.values.toList()[name.hashCode.abs() % AppTheme.categoryColors.length];
  }

  LinearGradient _avatarGradient(String name) {
    final color = _avatarColor(name);
    return LinearGradient(
        colors: [color.withOpacity(0.9), color],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight);
  }
}

