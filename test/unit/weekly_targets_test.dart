import 'package:flutter_test/flutter_test.dart';
import 'package:profileforge/ui/screens/targets/weekly_targets_model.dart';

void main() {
  group('WeeklyTarget', () {
    test('fromJson parses correctly', () {
      final target = WeeklyTarget.fromJson({
        'id': '1',
        'user_id': 'user-1',
        'title': 'Write essay draft',
        'description': 'Complete 500 words',
        'category': 'essay_draft',
        'milestone_type': 'standard',
        'status': 'pending',
        'week_number': 5,
        'year': 2025,
        'xp_reward': 50,
        'progress_pct': 25,
      });
      expect(target.id, '1');
      expect(target.title, 'Write essay draft');
      expect(target.isPending, true);
      expect(target.isCompleted, false);
      expect(target.xpReward, 50);
    });

    test('isCompleted returns true when status is completed', () {
      final target = WeeklyTarget.fromJson({
        'id': '2', 'user_id': 'u', 'title': 'T', 'description': 'D',
        'category': 'standard', 'milestone_type': 'standard',
        'status': 'completed', 'week_number': 1, 'year': 2025,
      });
      expect(target.isCompleted, true);
      expect(target.isInProgress, false);
      expect(target.isPending, false);
    });

    test('daysUntilDue returns null when no due date', () {
      final target = WeeklyTarget.fromJson({
        'id': '3', 'user_id': 'u', 'title': 'T', 'description': 'D',
        'category': 'standard', 'milestone_type': 'standard',
        'status': 'pending', 'week_number': 1, 'year': 2025,
      });
      expect(target.daysUntilDue, isNull);
    });
  });

  group('getCategoryMeta', () {
    test('returns correct category for essay_draft', () {
      final meta = getCategoryMeta('essay_draft');
      expect(meta.label, 'Essay');
    });

    test('returns standard as default', () {
      final meta = getCategoryMeta('unknown');
      expect(meta.label, 'Task');
    });
  });
}