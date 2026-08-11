import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:profileforge/core/ai/ai_mission.dart';
import 'package:profileforge/core/ai/ai_provider.dart';
import 'package:profileforge/core/ai/ai_service.dart';
import 'package:profileforge/core/ai/psychological_profile.dart';
import 'package:profileforge/core/data/app_database.dart';
import 'package:profileforge/core/data/app_database_provider.dart';
import 'package:profileforge/features/missions/data/mission_repository.dart';
import 'package:profileforge/features/missions/domain/mission_models.dart';
import 'package:profileforge/features/missions/domain/mission_generator.dart';
import 'package:profileforge/features/onboarding/application/onboarding_providers.dart';
import 'package:profileforge/features/onboarding/domain/onboarding_models.dart';
import 'package:profileforge/features/streak/application/streak_providers.dart';
import 'package:profileforge/features/streak/domain/streak_state.dart';
import 'package:profileforge/features/xp/application/xp_providers.dart';
import 'package:profileforge/features/wallet/application/wallet_providers.dart';
import 'package:profileforge/features/achievements/application/achievement_providers.dart';

final missionRepositoryProvider = Provider<MissionRepository>((ref) {
  return MissionRepository(ref.watch(appDatabaseProvider));
});

/// True when at least one AI provider has a stored API key.
final aiMissionsEnabledProvider = FutureProvider<bool>((ref) async {
  final active = await AIKeyStore().getActiveProvider();
  return active != null;
});

final todaysMissionsProvider =
    FutureProvider.family<List<MissionRow>, String>((ref, profileId) async {
  // Ensure missions exist before reading (auto-generates on first open).
  await ref.watch(generateMissionsProvider(profileId).future);
  final rows = await ref
      .watch(missionRepositoryProvider)
      .listDue(profileId, DateTime.now());
  return rows.where((r) => r.cadence == MissionCadence.daily.name).toList();
});

final weeklyMissionsProvider =
    FutureProvider.family<List<MissionRow>, String>((ref, profileId) async {
  await ref.watch(generateMissionsProvider(profileId).future);
  final rows = await ref
      .watch(missionRepositoryProvider)
      .listDue(profileId, DateTime.now());
  return rows.where((r) => r.cadence == MissionCadence.weekly.name).toList();
});

final monthlyMissionsProvider =
    FutureProvider.family<List<MissionRow>, String>((ref, profileId) async {
  await ref.watch(generateMissionsProvider(profileId).future);
  final rows = await ref
      .watch(missionRepositoryProvider)
      .listDue(profileId, DateTime.now());
  return rows.where((r) => r.cadence == MissionCadence.monthly.name).toList();
});

final missionHistoryProvider =
    FutureProvider.family<List<MissionRow>, String>((ref, profileId) async {
  return ref.watch(missionRepositoryProvider).history(profileId);
});

/// Special-cadence missions (e.g. the score screen's "Turn insight into
/// action" gap mission). Read DIRECTLY from the repo — deliberately NOT
/// chained through generateMissionsProvider, because regeneration deletes
/// open daily/weekly/monthly rows and would erase the gap mission before
/// the user ever saw it. Special rows survive regeneration.
final specialMissionsProvider =
    FutureProvider.family<List<MissionRow>, String>((ref, profileId) async {
  final rows = await ref
      .watch(missionRepositoryProvider)
      .listDue(profileId, DateTime.now());
  return rows
      .where((r) => r.cadence == MissionCadence.special.name)
      .toList();
});

/// Complete a mission: marks done, awards XP (×skin multiplier) + gems,
/// and records today's streak. Returns the streak event (milestone days
/// drive celebrations at call sites).
final completeMissionProvider = Provider.family<
    Future<StreakEvent?>,
    ({
      String profileId,
      String missionId,
      int xp,
      String pillar
    })>((ref, args) async {
  // Idempotent: complete() only flips NOT-done rows. An already-done
  // mission (double-tap, stale pinned card) returns 0 → skip ALL awards.
  final flipped = await ref
      .watch(missionRepositoryProvider)
      .complete(args.missionId);
  if (flipped == 0) {
    // No state change — nothing to reward, nothing to celebrate.
    ref.invalidate(specialMissionsProvider(args.profileId));
    return null;
  }
  // Award XP via the XP ledger (handles skin multiplier through provided xp).
  await ref.read(xpRepositoryProvider).add(
        args.profileId,
        args.xp,
        'mission:${args.missionId}',
      );
  // Award gems (1 gem per 5 XP, min 2).
  final gems = (args.xp / 5).ceil().clamp(2, 50);
  await ref.read(walletRepositoryProvider).add(args.profileId, gems);
  // Completing a mission = today's streak activity. The habit loop must
  // actually run — not just a manual button (gauntlet R1: "a Habitica
  // shell without the habit"). Milestone events bubble up so the UI can
  // celebrate the win (variable-reward layering, 02c-key-insights).
  StreakEvent? streakEvent;
  try {
    streakEvent =
        await ref.read(streakProvider(args.profileId).notifier).recordToday();
  } catch (_) {
    // Streak is additive; a failure here must never block the reward.
  }
  // Achievements: the core loop is the most important unlock trigger.
  // (Timer screen + quests already call checkAll; missions must too, or
  // mission-based badges stay locked no matter how many you complete.)
  try {
    await ref
        .read(achievementCheckerProvider.notifier)
        .checkAll(args.profileId);
  } catch (_) {
    // Achievement evaluation is additive; never block the reward.
  }
  ref.invalidate(todaysMissionsProvider(args.profileId));
  ref.invalidate(weeklyMissionsProvider(args.profileId));
  ref.invalidate(monthlyMissionsProvider(args.profileId));
  ref.invalidate(specialMissionsProvider(args.profileId));
  ref.invalidate(totalXpProvider(args.profileId));
  ref.invalidate(gemsProvider(args.profileId));
  return streakEvent;
});

/// ────────────────────────────────────────────────────────────────────────────
/// Mission Generation — AI → rule → engine tiering.
///
/// 1. AI: personalized daily plan from onboarding profile (needs API key).
/// 2. Rule: personalized from onboarding (MissionGenerator, no API).
/// 3. Engine: generic template pools (no onboarding data).
/// ────────────────────────────────────────────────────────────────────────────
final generateMissionsProvider =
    AsyncNotifierProviderFamily<GenerateMissionsNotifier, void, String>(
        GenerateMissionsNotifier.new);

class GenerateMissionsNotifier extends FamilyAsyncNotifier<void, String> {
  @override
  Future<void> build(String profileId) async {
    await _generate();
  }

  /// Force a fresh regeneration (refresh button / cadence rollover).
  Future<void> forceRegenerate() async {
    state = const AsyncLoading();
    await _generate();
    state = const AsyncData(null);
  }

  /// Regenerates all three cadences. Called on first load + refresh.
  Future<void> _generate() async {
    final repo = ref.read(missionRepositoryProvider);
    final onboarding = ref.read(onboardingProvider(arg)).valueOrNull;

    // Clear open missions for the cadences we're about to regenerate so a
    // refresh never stacks duplicate open rows (engine IDs are date-based).
    await repo.deleteOpenForCadence(arg, MissionCadence.daily);
    await repo.deleteOpenForCadence(arg, MissionCadence.weekly);
    await repo.deleteOpenForCadence(arg, MissionCadence.monthly);

    final missions = <Mission>[];

    // ── Daily: AI (primary) → Rule (fallback) → Engine.
    final essay = ref.read(essayContextProvider(arg)).valueOrNull;
    final psych = ref.read(psychologicalProfileProvider(arg)).valueOrNull;
    final daily = await _generateDaily(onboarding, essay, psych);
    missions.addAll(daily);

    // ── Weekly + monthly: engine templates (always available offline).
    final engine = MissionEngine();
    missions.addAll(engine.generateWeekly(arg));
    missions.addAll(engine.generateMonthly(arg));

    await repo.upsertGenerated(missions);
  }

  Future<List<Mission>> _generateDaily(OnboardingProfile? onboarding,
      EssayContext? essay, PsychologicalProfile? psych) async {
    // Tier 1: AI-authored.
    final aiMissions = await _tryAi(onboarding, essay, psych);
    if (aiMissions.isNotEmpty) return aiMissions;

    // Tier 2: rules from onboarding (psych-adapted — the no-key path must
    // still feel personal: XP sizing, framing, mission mix all adapt).
    if (onboarding != null) {
      final gen = MissionGenerator();
      final daily = gen.generateDaily(onboarding, arg, psych);
      final rules = daily.map((m) {
        final xp = m.xp;
        return Mission(
          id: m.id,
          profileId: arg,
          title: m.title,
          description: _ruleDescription(psych),
          cadence: MissionCadence.daily,
          pillar: _pillar(m.pillar),
          xpReward: xp,
          gemReward: (xp / 5).ceil().clamp(2, 10),
          dueAt: DateTime.now().add(const Duration(days: 1)),
          completed: false,
          source: 'rule',
        );
      }).toList();
      if (rules.isNotEmpty) return rules;
    }

    // Tier 3: engine templates.
    return MissionEngine().generateDaily(arg);
  }

  /// AI tier. Returns [] on any failure so callers fall back cleanly.
  Future<List<Mission>> _tryAi(OnboardingProfile? onboarding,
      EssayContext? essay, PsychologicalProfile? psych) async {
    if (onboarding == null) return const [];

    // Only attempt if the user actually has a key.
    final active = await AIKeyStore().getActiveProvider();
    if (active == null) return const [];

    try {
      final prompt = AiMission.buildUserPrompt(
        onboarding,
        essay: essay,
        personaHint: _personaFrom(essay),
        psychHint: _psychFrom(psych),
      );
      final raw = await AIService().generateJson(
        prompt: prompt,
        systemPromptOverride: AiMission.systemPrompt,
        temperature: 0.3,
        maxTokens: 2048,
      );
      if (raw == null) return const [];

      final missions = AiMission.parseMissions(
        _encode(raw),
        profileId: arg,
        cadence: MissionCadence.daily,
        source: 'ai',
      );
      return missions.isEmpty ? const [] : missions;
    } catch (e) {
      return const [];
    }
  }

  /// Re-encode a JSON list back to a string for the strict parser.
  static String _encode(List<Map<String, dynamic>> maps) {
    final items = maps.map((m) {
      final sb = StringBuffer('{');
      sb.write('"title":${_jsonEncode(m['title'])}');
      sb.write(',"description":${_jsonEncode(m['description'])}');
      sb.write(',"pillar":${_jsonEncode(m['pillar'])}');
      sb.write(',"xp":${_jsonEncode(m['xp'])}');
      sb.write(',"priority":${_jsonEncode(m['priority'])}');
      sb.write(',"reason":${_jsonEncode(m['reason'])}');
      sb.write('}');
      return sb.toString();
    });
    return '[${items.join(',')}]';
  }

  static String _jsonEncode(dynamic v) {
    final s = v?.toString() ?? '';
    return '"${s.replaceAll('\\', '\\\\').replaceAll('"', '\\"')}"';
  }
}

/// Convert captured essay material into a short persona hint for the AI
/// prompt (values + curiosity), so missions feel personal without leaking
/// private story details into every mission title.
String _personaFrom(EssayContext? essay) {
  if (essay == null) return '';
  final parts = <String>[];
  if (essay.values.isNotEmpty) parts.add('values: ${essay.values.join(", ")}');
  if (essay.curiosity.isNotEmpty)
    parts.add('curious about: ${essay.curiosity}');
  return parts.join(' · ');
}

/// Convert the persisted psychological profile into a compact style hint so
/// AI-authored missions adapt their tone and motivation framing to the student.
String _psychFrom(PsychologicalProfile? psych) {
  if (psych == null) return '';
  final parts = <String>[
    'communication: ${psych.communicationStyle.name}',
    'motivation: ${psych.motivationFrame.name}',
    'support: ${psych.supportLevel.name}',
    'structure: ${psych.structurePreference.name}',
  ];
  if (psych.growthMindset < 0.4)
    parts.add('needs growth-mindset reinforcement');
  if (psych.selfEfficacy < 0.4) parts.add('build confidence in small wins');
  return parts.join(' · ');
}

/// Psych-aware description for rule-tier missions. Feedback language must
/// serve competence (SDT): low self-efficacy → progress framing; growth
/// mindset → effort framing (Dweck, 03-as).
String _ruleDescription(PsychologicalProfile? psych) {
  if (psych == null) return 'Complete this mission to earn XP and gems.';
  final se = psych.selfEfficacy;
  if (se < 0.4) {
    return 'Small steps count. Finish this and you are one step closer — '
        'you\'ve handled harder things than this.';
  }
  if (!psych.growthMindset.isNaN && psych.growthMindset < 0.4) {
    return 'This is practice, not a test of who you are. Effort grows ability '
        '— complete it and watch the XP rise.';
  }
  return 'Complete this mission to earn XP and gems.';
}

MissionPillar _pillar(String s) {
  for (final p in MissionPillar.values) {
    if (p.name.toLowerCase() == s.toLowerCase()) return p;
  }
  return MissionPillar.academics;
}
