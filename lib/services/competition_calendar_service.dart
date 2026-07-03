import 'package:flutter_riverpod/flutter_riverpod.dart';

class CompetitionEvent {
  final String id;
  final String title;
  final DateTime date;
  const CompetitionEvent({required this.id, required this.title, required this.date});
}

class CompetitionCalendarService {
  Future<List<CompetitionEvent>> getUpcoming(String profileId) async => [];
  Future<void> syncCalendar(String profileId) async {}
}

final competitionCalendarServiceProvider = Provider<CompetitionCalendarService>((ref) => CompetitionCalendarService());
