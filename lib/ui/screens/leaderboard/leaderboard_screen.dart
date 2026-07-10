// Leaderboard Screen — Weekly/All-Time XP rankings with animated medal tiers
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/app_theme.dart';

// ─── Data ────────────────────────────────────────────────────────────────────

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

final leaderboardTabProvider = StateProvider<int>((ref) => 0);
final leaderboardProvider = Provider<List<LeaderboardEntry>>((ref) {
  final tab = ref.watch(leaderboardTabProvider);
  const names = [
    'Aarav','Vivaan','Aditya','Arjun','Sai','Reyansh','Krishna',
    'Ishaan','Shaurya','Advaith','Vihaan','Arin','Darsh','Kabir',
    'Ayaan','Dhruv','Rohan','Kiran','Meera','Priya',
  ];
  const allTimeXp = [12450,11200,10800,9750,9200,8900,8350,7800,7400,6950,
    6500,6100,5750,5300,4900,4500,4100,3700,3300,2900];
  const weeklyXp = [2450,2100,1950,1800,1650,1500,1350,1200,1100,950,
    850,750,650,550,480,400,350,300,250,200];
  final xpList = tab == 0 ? weeklyXp : allTimeXp;
  return List.generate(20, (i) => LeaderboardEntry(
    rank: i + 1, name: names[i], xp: xpList[i],
    level: (xpList[i] ~/ (tab == 0 ? 150 : 800)) + 1,
    streak: 20 - i + (tab == 0 ? 2 : 5),
    isCurrentUser: names[i] == 'Aarav',
  ));
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
    final entries = ref.watch(leaderboardProvider);
    final user = entries.firstWhere((e) => e.isCurrentUser, orElse: () => entries.first);

    return Scaffold(
      backgroundColor: dark ? AppTheme.surfaceDark : const Color(0xFFF8F5F0),
      body: Column(children: [
        _header(context, dark, user),
        _tabs(context, dark),
        Expanded(child: entries.isEmpty
            ? _emptyState(context, dark)
            : RefreshIndicator(
                onRefresh: () async {
                  await Future.delayed(const Duration(milliseconds: 1200));
                },
                color: AppTheme.accentPurple,
                child: _list(context, dark, entries),
              )),
      ]),
    );
  }

  // ── Header ──────────────────────────────────────────────────────────────

  Widget _header(BuildContext ctx, bool dark, LeaderboardEntry user) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: dark
            ? const LinearGradient(colors: [Color(0xFF1A1040), AppTheme.surfaceDark],
                begin: Alignment.topLeft, end: Alignment.bottomRight)
            : AppTheme.gradientPrimary,
      ),
      child: SafeArea(bottom: false, child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
        child: Column(children: [
          Row(children: [
            IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 20),
              onPressed: () => Navigator.pop(ctx), padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
            const SizedBox(width: 12),
            Text('Leaderboard', style: GoogleFonts.inter(
              fontSize: 22, fontWeight: FontWeight.w700, color: Colors.white, letterSpacing: -0.3)),
          ]),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white.withValues(alpha: 0.25)),
            ),
            child: Row(children: [
              Container(
                width: 48, height: 48,
                decoration: BoxDecoration(
                  gradient: AppTheme.gradientGold, shape: BoxShape.circle,
                  boxShadow: [BoxShadow(color: AppTheme.accentGold.withValues(alpha: 0.4),
                    blurRadius: 12, offset: const Offset(0, 4))],
                ),
                child: Center(child: Text('#${user.rank}',
                  style: GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w800, color: Colors.white))),
              ),
              const SizedBox(width: 14),
              Expanded(child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(user.name, style: GoogleFonts.inter(
                    fontSize: 18, fontWeight: FontWeight.w700, color: Colors.white)),
                  const SizedBox(height: 2),
                  Text('Your rank this week', style: GoogleFonts.inter(
                    fontSize: 12, color: Colors.white.withValues(alpha: 0.7))),
                ],
              )),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(20)),
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
      color: dark ? AppTheme.surfaceDark : const Color(0xFFF8F5F0),
      child: TabBar(
        controller: _tab, isScrollable: false,
        labelColor: AppTheme.accentPurple,
        unselectedLabelColor: dark ? const Color(0xFF94A3B8) : AppTheme.textSecondary,
        indicatorColor: AppTheme.accentPurple, indicatorWeight: 3,
        indicatorSize: TabBarIndicatorSize.label,
        labelStyle: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w700),
        unselectedLabelStyle: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w500),
        dividerColor: dark ? const Color(0xFF334155) : const Color(0xFFE2D5C8),
        dividerHeight: 1,
        tabs: const [Tab(text: 'This Week'), Tab(text: 'All Time')],
      ),
    );
  }

  // ── List ────────────────────────────────────────────────────────────────

  Widget _list(BuildContext ctx, bool dark, List<LeaderboardEntry> entries) {
    final top3 = entries.take(3).toList();
    final rest = entries.skip(3).toList();
    final textMuted = dark ? const Color(0xFF64748B) : AppTheme.textMuted;

    return CustomScrollView(
      physics: const AlwaysScrollableScrollPhysics(parent: BouncingScrollPhysics()),
      slivers: [
        SliverToBoxAdapter(child: _podium(ctx, dark, top3)),
        SliverToBoxAdapter(child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Container(height: 1, decoration: BoxDecoration(gradient: LinearGradient(
            colors: [Colors.transparent,
              (dark ? const Color(0xFF334155) : const Color(0xFFE2D5C8)).withValues(alpha: 0.6),
              Colors.transparent]))),
        )),
        SliverToBoxAdapter(child: _columnHeaders(textMuted)),
        SliverList(delegate: SliverChildBuilderDelegate(
          (ctx, i) => _row(ctx, dark, rest[i])
              .animate().fadeIn(delay: Duration(milliseconds: 60 * (i + 3)), duration: 300.ms)
              .slideX(begin: 0.05, duration: 300.ms),
          childCount: rest.length,
        )),
        const SliverToBoxAdapter(child: SizedBox(height: 80)),
      ],
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
    final bg = dark ? const Color(0xFF1E293B) : Colors.white;
    final hlBorder = e.isCurrentUser ? AppTheme.accentPurple : medal;

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
      const SizedBox(height: 2),
      Text('${e.xp} XP', style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w600, color: medal)),
      const SizedBox(height: 6),
      Container(
        width: double.infinity, height: h,
        decoration: BoxDecoration(
          color: bg, borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
          border: Border.all(color: hlBorder.withValues(alpha: e.isCurrentUser ? 0.8 : 0.3), width: e.isCurrentUser ? 2 : 1),
          boxShadow: isFirst ? [BoxShadow(color: medal.withValues(alpha: 0.15), blurRadius: 20, offset: const Offset(0, 4))] : null,
        ),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Text('#${e.rank}', style: GoogleFonts.inter(fontSize: isFirst ? 28 : 24,
            fontWeight: FontWeight.w800, color: medal.withValues(alpha: 0.25))),
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
    final bg = dark ? const Color(0xFF1E293B) : Colors.white;
    final border = dark ? const Color(0xFF334155) : const Color(0xFFE2D5C8);
    final textPri = dark ? Colors.white : AppTheme.textPrimary;
    final textSec = dark ? const Color(0xFF94A3B8) : AppTheme.textSecondary;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: isUser ? AppTheme.accentPurple.withValues(alpha: dark ? 0.12 : 0.08) : bg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isUser ? AppTheme.accentPurple.withValues(alpha: 0.5) : border,
          width: isUser ? 1.5 : 1),
        boxShadow: isUser ? [BoxShadow(color: AppTheme.accentPurple.withValues(alpha: 0.1),
          blurRadius: 12, offset: const Offset(0, 4))] : null,
      ),
      child: Row(children: [
        SizedBox(width: 36, child: Text('${e.rank}', style: GoogleFonts.inter(
          fontSize: 16, fontWeight: FontWeight.w800, color: textSec))),
        const SizedBox(width: 10),
        Container(
          width: 40, height: 40,
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: [_avatarColor(e.name).withValues(alpha: 0.9), _avatarColor(e.name)]),
            shape: BoxShape.circle),
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
            color: dark ? const Color(0xFF334155).withValues(alpha: 0.5) : const Color(0xFFF1F5F9),
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
          style: GoogleFonts.inter(fontSize: 14, color: dark ? const Color(0xFF94A3B8) : AppTheme.textSecondary, height: 1.5)),
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
    const colors = [
      AppTheme.primaryBlue, AppTheme.accentPurple, AppTheme.accentTeal,
      AppTheme.accentOrange, AppTheme.successGreen,
      Color(0xFFDB2777), Color(0xFF0891B2), Color(0xFFDC2626),
    ];
    return colors[name.hashCode.abs() % colors.length];
  }
}
