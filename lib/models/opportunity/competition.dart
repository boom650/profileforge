import 'package:flutter/material.dart';

import 'package:freezed_annotation/freezed_annotation.dart';

part 'competition.freezed.dart';
part 'competition.g.dart';

@freezed
abstract class Competition with _$Competition {
  const factory Competition({
    required String id,
    required String title,
    required String description,
    required CompetitionCategory category,
    required CompetitionLevel level,
    required DateTime startDate,
    required DateTime endDate,
    required DateTime registrationDeadline,
    required bool registrationOpen,
    required List<int> eligibleGrades,
    required List<String> eligibleStreams,
    required bool isOnline,
    required String? venue,
    required String? city,
    required String? state,
    required String? country,
    required double? latitude,
    required double? longitude,
    required String? website,
    required String? registrationUrl,
    required String organizer,
    required List<String> prizes,
    required List<String> tags,
    required String? contactEmail,
    required String? contactPhone,
    required int? maxTeamSize,
    required int? minTeamSize,
    required bool individualParticipation,
    required bool teamParticipation,
    required String? format,
    required String? syllabus,
    required List<String>? prerequisites,
    required Map<String, dynamic>? rounds,
    required DateTime? resultDate,
    required DateTime cachedAt,
    required String source,
  }) = _Competition;

  factory Competition.fromJson(Map<String, dynamic> json) => _$CompetitionFromJson(json);
}

enum CompetitionCategory {
  @JsonValue('academic')
  academic,
  @JsonValue('science')
  science,
  @JsonValue('math')
  math,
  @JsonValue('coding')
  coding,
  @JsonValue('robotics')
  robotics,
  @JsonValue('innovation')
  innovation,
  @JsonValue('research')
  research,
  @JsonValue('arts')
  arts,
  @JsonValue('sports')
  sports,
  @JsonValue('debate')
  debate,
  @JsonValue('quiz')
  quiz,
  @JsonValue('olympiad')
  olympiad,
  @JsonValue('hackathon')
  hackathon,
  @JsonValue('design')
  design,
  @JsonValue('entrepreneurship')
  entrepreneurship,
  @JsonValue('social_impact')
  socialImpact,
  @JsonValue('environment')
  environment,
  @JsonValue('language')
  language,
  @JsonValue('other')
  other,
}

enum CompetitionLevel {
  @JsonValue('school')
  school,
  @JsonValue('district')
  district,
  @JsonValue('state')
  state,
  @JsonValue('national')
  national,
  @JsonValue('international')
  international,
}

extension CompetitionExtension on Competition {
  String get categoryDisplayName {
    switch (category) {
      case CompetitionCategory.academic: return 'Academic';
      case CompetitionCategory.science: return 'Science';
      case CompetitionCategory.math: return 'Mathematics';
      case CompetitionCategory.coding: return 'Coding/Programming';
      case CompetitionCategory.robotics: return 'Robotics';
      case CompetitionCategory.innovation: return 'Innovation';
      case CompetitionCategory.research: return 'Research';
      case CompetitionCategory.arts: return 'Arts';
      case CompetitionCategory.sports: return 'Sports';
      case CompetitionCategory.debate: return 'Debate/Public Speaking';
      case CompetitionCategory.quiz: return 'Quiz';
      case CompetitionCategory.olympiad: return 'Olympiad';
      case CompetitionCategory.hackathon: return 'Hackathon';
      case CompetitionCategory.design: return 'Design';
      case CompetitionCategory.entrepreneurship: return 'Entrepreneurship';
      case CompetitionCategory.socialImpact: return 'Social Impact';
      case CompetitionCategory.environment: return 'Environment';
      case CompetitionCategory.language: return 'Language';
      case CompetitionCategory.other: return 'Other';
    }
  }
  
  String get levelDisplayName {
    switch (level) {
      case CompetitionLevel.school: return 'School Level';
      case CompetitionLevel.district: return 'District Level';
      case CompetitionLevel.state: return 'State Level';
      case CompetitionLevel.national: return 'National Level';
      case CompetitionLevel.international: return 'International';
    }
  }
  
  Color get levelColor {
    switch (level) {
      case CompetitionLevel.school: return const Color(0xFF4CAF50);
      case CompetitionLevel.district: return const Color(0xFF8BC34A);
      case CompetitionLevel.state: return const Color(0xFF2196F3);
      case CompetitionLevel.national: return const Color(0xFF9C27B0);
      case CompetitionLevel.international: return const Color(0xFFFF9800);
    }
  }
  
  IconData get categoryIcon {
    switch (category) {
      case CompetitionCategory.academic: return Icons.school;
      case CompetitionCategory.science: return Icons.science;
      case CompetitionCategory.math: return Icons.calculate;
      case CompetitionCategory.coding: return Icons.code;
      case CompetitionCategory.robotics: return Icons.smart_toy;
      case CompetitionCategory.innovation: return Icons.lightbulb;
      case CompetitionCategory.research: return Icons.biotech;
      case CompetitionCategory.arts: return Icons.palette;
      case CompetitionCategory.sports: return Icons.sports;
      case CompetitionCategory.debate: return Icons.record_voice_over;
      case CompetitionCategory.quiz: return Icons.quiz;
      case CompetitionCategory.olympiad: return Icons.emoji_events;
      case CompetitionCategory.hackathon: return Icons.hacker_mode;
      case CompetitionCategory.design: return Icons.design_services;
      case CompetitionCategory.entrepreneurship: return Icons.business;
      case CompetitionCategory.socialImpact: return Icons.volunteer_activism;
      case CompetitionCategory.environment: return Icons.eco;
      case CompetitionCategory.language: return Icons.translate;
      case CompetitionCategory.other: return Icons.category;
    }
  }
  
  String get formattedDateRange {
    if (startDate.year == endDate.year) {
      if (startDate.month == endDate.month) {
        if (startDate.day == endDate.day) {
          return _formatDate(startDate);
        }
        return '${startDate.day}-${endDate.day} ${_monthName(endDate.month)} ${endDate.year}';
      }
      return '${_formatDate(startDate)} - ${_formatDate(endDate)}';
    }
    return '${_formatDate(startDate)} - ${_formatDate(endDate)}';
  }
  
  String _formatDate(DateTime date) => '${date.day} ${_monthName(date.month)} ${date.year}';
  
  String _monthName(int month) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return months[month - 1];
  }
  
  String get registrationStatus {
    final now = DateTime.now();
    if (!registrationOpen) return 'Closed';
    if (registrationDeadline.isBefore(now)) return 'Deadline Passed';
    if (startDate.isBefore(now)) return 'Started';
    final daysLeft = registrationDeadline.difference(now).inDays;
    if (daysLeft <= 3) return 'Urgent ($daysLeft days)';
    if (daysLeft <= 7) return 'Closing Soon ($daysLeft days)';
    return 'Open ($daysLeft days)';
  }
  
  Color get registrationStatusColor {
    final now = DateTime.now();
    if (!registrationOpen) return Colors.grey;
    if (registrationDeadline.isBefore(now)) return Colors.red;
    if (startDate.isBefore(now)) return Colors.blue;
    final daysLeft = registrationDeadline.difference(now).inDays;
    if (daysLeft <= 3) return Colors.red;
    if (daysLeft <= 7) return Colors.orange;
    return Colors.green;
  }
  
  String get eligibilityDisplay {
    final grades = eligibleGrades.isNotEmpty 
        ? 'Grades ${eligibleGrades.map((g) => g.toString()).join(', ')}'
        : 'All Grades';
    final streams = eligibleStreams.isNotEmpty && !eligibleStreams.contains('All')
        ? eligibleStreams.join(', ')
        : 'All Streams';
    return '$grades | $streams';
  }
  
  String get locationDisplay {
    if (isOnline) return 'Online';
    final parts = <String>[];
    if (venue != null && venue!.isNotEmpty) parts.add(venue!);
    if (city != null && city!.isNotEmpty) parts.add(city!);
    if (state != null && state!.isNotEmpty) parts.add(state!);
    if (country != null && country!.isNotEmpty) parts.add(country!);
    return parts.isEmpty ? 'TBD' : parts.join(', ');
  }
  
  bool get isUpcoming => startDate.isAfter(DateTime.now());
  bool get isOngoing => startDate.isBefore(DateTime.now()) && endDate.isAfter(DateTime.now());
  bool get isPast => endDate.isBefore(DateTime.now());
  bool get registrationClosingSoon => registrationDeadline.difference(DateTime.now()).inDays <= 7;
  
  int get daysUntilRegistrationDeadline => registrationDeadline.difference(DateTime.now()).inDays;
  int get daysUntilStart => startDate.difference(DateTime.now()).inDays;
  
  int get relevanceScore {
    int score = 0;
    if (registrationOpen && registrationDeadline.isAfter(DateTime.now())) score += 30;
    if (isUpcoming) score += 20;
    if (level == CompetitionLevel.international) score += 25;
    else if (level == CompetitionLevel.national) score += 20;
    else if (level == CompetitionLevel.state) score += 15;
    else if (level == CompetitionLevel.district) score += 10;
    else score += 5;
    
    if (category == CompetitionCategory.science || 
        category == CompetitionCategory.coding || 
        category == CompetitionCategory.research ||
        category == CompetitionCategory.innovation) {
      score += 10;
    }
    
    if (prizes.isNotEmpty) score += prizes.length * 2;
    if (tags.contains('prestigious') || tags.contains('scholarship') || tags.contains('fellowship')) {
      score += 15;
    }
    
    return score;
  }
}