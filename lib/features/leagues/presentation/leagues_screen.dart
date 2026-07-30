import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:profileforge/core/audio/sound_service.dart';
import 'package:profileforge/core/celebration/celebrate.dart';
import 'package:profileforge/core/theme/app_theme.dart';
import 'package:profileforge/core/widgets/premium_widgets.dart';
import 'package:profileforge/features/leagues/application/league_providers.dart';
import 'package:profileforge/features/leagues/domain/league_definitions.dart';

/// ────────────────────────────────────────────────────────────────────────────
/// LeaguesScreen v2 — Premium dark league with glassmorphism.
/// Tier ladder → standings → actions.
/// ────────────────────────────────────────────────────────────────────────────
class LeaguesScreen extends ConsumerWidget {
  const LeaguesScreen({super.key, required this.profileId});
  final String profileId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final dark = isDark(context);
    final me = ref.watch(myLeagueProvider(profileId));
    final standings = ref.watch(leagueStandingsProvider(profileId));

    return Scaffold(
      backgroundColor: dark ? Palette.black : const Color(0xFFF8FAFC),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // ── Header ──
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                child: Row(
                  children: [
                    Text(
                      'Leagues',
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const Spacer(),
                    // Back button.
                    GestureDetector(
                      onTap: () => context.pop(),
                      child: Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: dark ? Palette.surface2 : const Color(0xFFF1F5F9),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          Icons.arrow_back_ios_new,
                          size: 18,
                          color: dark ? Palette.textSecondary : Palette.textTertiary,
                        ),
                      ),
                    ),
                  ],
                ),
              ).animate().fadeIn(duration: 300.ms),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 20)),

            // ── Tier ladder ──
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: SectionTitle('Climb the ladder'),
              ),
            ),
            SliverToBoxAdapter(
              child: SizedBox(
                height: 72,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: LeagueTier.values.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 8),
                  itemBuilder: (_, i) {
                    final t = LeagueTier.values[i];
                    final isMe = me.valueOrNull?.tier == t.name;
                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        gradient: isMe ? Palette.gradientPrimary : null,
                        color: isMe ? null : dark ? Palette.surface1 : Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: isMe ? Palette.primary : (dark ? Palette.border : const Color(0xFFE2E8F0)),
                          width: isMe ? 2 : 1,
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(t.tierEmoji, style: const TextStyle(fontSize: 24)),
                          const SizedBox(height: 2),
                          Text(
                            t.tierLabel,
                            style: TextStyle(
                              color: isMe ? Colors.white : (dark ? Palette.textSecondary : Palette.textTertiary),
                              fontWeight: FontWeight.w700,
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ).animate().fadeIn(delay: (i * 50).ms);
                  },
                ),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 24)),

            // ── Standings banner ──
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: GradientBanner(
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFF8B5CF6), Color(0xFFEF4444)],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '🏆 This week\'s standings',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Top 10% get promoted, bottom 10% drop a tier.\nShields save you from demotion.',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.85),
                          fontSize: 13,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ).animate().fadeIn(delay: 100.ms).slideY(begin: 0.05),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 16)),

            // ── Standings list ──
            standings.when(
              data: (rows) {
                final sorted = [...rows]..sort((a, b) => b.weeklyXp.compareTo(a.weeklyXp));
                return SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final m = sorted[index];
                        final isMe = m.profileId == profileId;
                        final medal = index == 0
                            ? '🥇'
                            : index == 1
                                ? '🥈'
                                : index == 2
                                    ? '🥉'
                                    : '${index + 1}.';
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: GlassCard(
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                            borderColor: isMe ? Palette.primary : null,
                            borderWidth: isMe ? 2 : 1,
                            child: Row(
                              children: [
                                // Rank.
                                SizedBox(
                                  width: 30,
                                  child: Text(
                                    medal,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w800,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                // Avatar + name.
                                Container(
                                  width: 32,
                                  height: 32,
                                  decoration: BoxDecoration(
                                    color: isMe
                                        ? Palette.primary.withValues(alpha: 0.15)
                                        : dark
                                            ? Palette.surface3
                                            : const Color(0xFFE2E8F0),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Center(
                                    child: Text(
                                      isMe ? '🦉' : '👤',
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    isMe ? 'You' : m.profileId,
                                    style: TextStyle(
                                      fontWeight: isMe ? FontWeight.w800 : FontWeight.w600,
                                      fontSize: 15,
                                      color: isMe
                                          ? Palette.primary
                                          : (dark ? Palette.textPrimary : Palette.textInverse),
                                    ),
                                  ),
                                ),
                                // XP badge.
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: Palette.warning.withValues(alpha: 0.12),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    '${m.weeklyXp} XP',
                                    style: const TextStyle(
                                      color: Palette.warning,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 13,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ).animate().fadeIn(delay: (index * 30).ms).slideX(begin: 0.02);
                      },
                      childCount: sorted.length,
                    ),
                  ),
                );
              },
              loading: () => const SliverToBoxAdapter(
                child: Center(child: CircularProgressIndicator()),
              ),
              error: (e, _) => SliverToBoxAdapter(
                child: Center(child: Text('Error: $e')),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 24)),

            // ── Actions ──
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: GradientButton(
                  label: 'Resolve week & claim result',
                  icon: Icons.emoji_events_outlined,
                  gradient: Palette.gradientPrimary,
                  onTap: () async {
                    final res = await ref.read(seasonResetProvider(profileId));
                    SoundService.instance.levelUp();
                    if (res != null) {
                      final msg = res.promoted
                          ? 'Promoted! ⬆️'
                          : res.demoted
                              ? 'Demoted ⬇️'
                              : res.shielded
                                  ? 'Saved by shield 🛡️'
                                  : 'Stayed put';
                      celebrate(context, message: msg);
                    }
                  },
                ),
              ).animate().fadeIn(delay: 200.ms),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 12)),

            // ── Invite buddies ──
            SliverToBoxAdapter(
              child: Center(
                child: TextButton.icon(
                  onPressed: () => context.push('/buddies'),
                  icon: const Icon(Icons.group_add, size: 18),
                  label: const Text('Invite buddies to join your league'),
                ),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: 40)),
          ],
        ),
      ),
    );
  }
}
