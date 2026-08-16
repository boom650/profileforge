import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:profileforge/core/ai/ai_mission.dart';
import 'package:profileforge/core/data/app_database.dart';
import 'package:profileforge/features/missions/data/mission_repository.dart';
import 'package:profileforge/features/missions/domain/mission_models.dart';

void main() {
  late AppDatabase db;
  late MissionRepository repo;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    repo = MissionRepository(db);
  });

  tearDown(() async {
    await db.close();
  });

  group('mission farm regression (anti-refresh-farm)', () {
    test('re-upserting a period never reopens a completed mission', () async {
      const profileId = 'p1';
      final missions = MissionEngine().generateDaily(profileId);
      await repo.upsertGenerated(missions);

      for (final m in missions) {
        expect(await repo.complete(m.id), 1, reason: 'fresh mission flips');
      }

      // Simulate a refresh: same period re-generated + re-upserted.
      await repo.upsertGenerated(MissionEngine().generateDaily(profileId));

      final rows = await repo.history(profileId);
      final completed = rows.where((r) => r.done).toList();
      expect(completed.length, missions.length,
          reason: 'completed rows must survive a refresh');
      expect(rows.length, missions.length,
          reason: 'a refresh must not mint a second completable set');
    });

    test('mid-day refresh keeps open missions, never reopens completed ones',
        () async {
      const profileId = 'p2';
      final set = MissionEngine().generateDaily(profileId);
      await repo.upsertGenerated(set);

      await repo.complete(set[0].id);
      await repo.complete(set[1].id);

      await repo.deleteOpenForCadence(profileId, MissionCadence.daily);
      await repo.upsertGenerated(MissionEngine().generateDaily(profileId));

      final rows = await repo.history(profileId);
      expect(rows.where((r) => r.done).length, 2,
          reason: 'completed stay completed after refresh');
      expect(rows.where((r) => !r.done).length, set.length - 2,
          reason: 'open missions remain available, not duplicated');
    });

    test('AI mission ids are period-stable (no second mint per day)', () async {
      List<Mission> parse() => AiMission.parseMissions(
            '[{"title":"T1","description":"D1","pillar":"academics","xp":15,'
            '"priority":"high","reason":"R"}]',
            profileId: 'profile123456',
            cadence: MissionCadence.daily,
            source: 'ai',
          );

      final a = parse();
      final b = parse();
      expect(a.first.id, b.first.id,
          reason: 'same-day AI re-roll maps to the same id so upsert skips it');
      expect(a.first.id, matches(RegExp(r'^ai-profil-daily-\d{8}-0$')),
          reason: 'id is date-scoped, not a raw timestamp');
    });

    test('engine ids are deterministic within the same period', () async {
      final d1 = MissionEngine().generateDaily('p').map((m) => m.id).toSet();
      final d2 = MissionEngine().generateDaily('p').map((m) => m.id).toSet();
      expect(d1, d2, reason: 'same-day engine generation is id-deterministic');

      final w1 =
          MissionEngine().generateWeekly('p').map((m) => m.id).toSet();
      final w2 =
          MissionEngine().generateWeekly('p').map((m) => m.id).toSet();
      expect(w1, w2, reason: 'same-week engine generation is id-deterministic');
    });
  });
}
