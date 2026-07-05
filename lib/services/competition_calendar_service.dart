/// Indian competition calendar — hardcoded dates for major national competitions.
/// Covers: Olympiads, NTSE, KVPY, INSPIRE, ATAL, hackathons, essay contests.
/// Updated for 2025-2026 academic year.
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Competition {
  final String id;
  final String name;
  final String category; // 'olympiad', 'scholarship', 'hackathon', 'essay', 'research', 'model'
  final DateTime registrationStart;
  final DateTime registrationEnd;
  final DateTime examDate;
  final String eligibility; // 'class_9_12', 'class_11_12', 'class_9_10', etc.
  final String website;
  final String description;
  final bool isFree;

  const Competition({
    required this.id,
    required this.name,
    required this.category,
    required this.registrationStart,
    required this.registrationEnd,
    required this.examDate,
    required this.eligibility,
    required this.website,
    required this.description,
    this.isFree = true,
  });

  /// Days until registration closes.
  int get daysUntilDeadline {
    final now = DateTime.now();
    return registrationEnd.difference(now).inDays;
  }

  /// Is registration currently open?
  bool get isRegistrationOpen {
    final now = DateTime.now();
    return now.isAfter(registrationStart) && now.isBefore(registrationEnd);
  }

  /// Is this upcoming (not yet passed)?
  bool get isUpcoming => examDate.isAfter(DateTime.now());
}

class CompetitionCalendarService {
  /// Get all competitions for a given class/grade.
  List<Competition> getForGrade(int grade) {
    return _allCompetitions.where((c) {
      return _gradeMatches(grade, c.eligibility);
    }).toList();
  }

  /// Get upcoming competitions (registration still open or future).
  List<Competition> getUpcoming() {
    return _allCompetitions.where((c) => c.isUpcoming).toList()
      ..sort((a, b) => a.registrationEnd.compareTo(b.registrationEnd));
  }

  /// Get competitions by category.
  List<Competition> getByCategory(String category) {
    return _allCompetitions.where((c) => c.category == category).toList();
  }

  /// Get competitions with open registration right now.
  List<Competition> getOpenNow() {
    return _allCompetitions.where((c) => c.isRegistrationOpen).toList();
  }

  bool _gradeMatches(int grade, String eligibility) {
    switch (eligibility) {
      case 'class_9_12': return grade >= 9 && grade <= 12;
      case 'class_11_12': return grade >= 11 && grade <= 12;
      case 'class_9_10': return grade >= 9 && grade <= 10;
      case 'class_8_12': return grade >= 8 && grade <= 12;
      case 'class_6_12': return grade >= 6 && grade <= 12;
      case 'any': return true;
      default: return true;
    }
  }

  static final _allCompetitions = [
    // ═══════ OLYMPIADS ═══════
    Competition(
      id: 'o1', name: 'International Mathematics Olympiad (IMO)', category: 'olympiad',
      registrationStart: DateTime(2025, 9, 1), registrationEnd: DateTime(2025, 10, 31),
      examDate: DateTime(2025, 12, 15), eligibility: 'class_9_12',
      website: 'https://sofolympiad.org', description: 'SOF International Mathematics Olympiad — national level math competition',
    ),
    Competition(
      id: 'o2', name: 'National Science Olympiad (NSO)', category: 'olympiad',
      registrationStart: DateTime(2025, 9, 1), registrationEnd: DateTime(2025, 10, 31),
      examDate: DateTime(2025, 11, 28), eligibility: 'class_9_12',
      website: 'https://sofolympiad.org', description: 'SOF National Science Olympiad — science aptitude test',
    ),
    Competition(
      id: 'o3', name: 'Indian National Physics Olympiad (INPhO)', category: 'olympiad',
      registrationStart: DateTime(2025, 11, 1), registrationEnd: DateTime(2025, 12, 15),
      examDate: DateTime(2026, 1, 20), eligibility: 'class_11_12',
      website: 'https://olympiads.hbcse.tifr.res.in', description: 'HBCSE Physics Olympiad — first stage of IOQP',
    ),
    Competition(
      id: 'o4', name: 'Indian National Chemistry Olympiad (INChO)', category: 'olympiad',
      registrationStart: DateTime(2025, 11, 1), registrationEnd: DateTime(2025, 12, 15),
      examDate: DateTime(2026, 1, 25), eligibility: 'class_11_12',
      website: 'https://olympiads.hbcse.tifr.res.in', description: 'HBCSE Chemistry Olympiad — first stage of IOQC',
    ),
    Competition(
      id: 'o5', name: 'Indian National Astronomy Olympiad (INAO)', category: 'olympiad',
      registrationStart: DateTime(2025, 11, 1), registrationEnd: DateTime(2025, 12, 15),
      examDate: DateTime(2026, 1, 18), eligibility: 'class_11_12',
      website: 'https://olympiads.hbcse.tifr.res.in', description: 'HBCSE Astronomy Olympiad — first stage of IOQA',
    ),

    // ═══════ SCHOLARSHIPS ═══════
    Competition(
      id: 's1', name: 'KVPY (Kishore Vaigyanik Protsahan Yojana)', category: 'scholarship',
      registrationStart: DateTime(2025, 7, 15), registrationEnd: DateTime(2025, 9, 15),
      examDate: DateTime(2025, 11, 1), eligibility: 'class_11_12',
      website: 'https://kvpy.iisc.ac.in', description: 'Government scholarship for science research — prestigious fellowship',
      isFree: true,
    ),
    Competition(
      id: 's2', name: 'INSPIRE Scholarship (SHE)', category: 'scholarship',
      registrationStart: DateTime(2025, 10, 1), registrationEnd: DateTime(2025, 11, 30),
      examDate: DateTime(2026, 2, 1), eligibility: 'class_11_12',
      website: 'https://www.inspire-dst.gov.in', description: 'DST Innovation in Science Pursuit — ₹80,000/year scholarship',
      isFree: true,
    ),
    Competition(
      id: 's3', name: 'NTSE (National Talent Search Examination)', category: 'scholarship',
      registrationStart: DateTime(2025, 8, 1), registrationEnd: DateTime(2025, 10, 15),
      examDate: DateTime(2025, 11, 15), eligibility: 'class_10',
      website: 'https://ncert.nic.in', description: 'National scholarship for talented Class 10 students',
      isFree: true,
    ),

    // ═══════ HACKATHONS ═══════
    Competition(
      id: 'h1', name: 'Smart India Hackathon (SIH)', category: 'hackathon',
      registrationStart: DateTime(2025, 7, 1), registrationEnd: DateTime(2025, 8, 31),
      examDate: DateTime(2025, 11, 1), eligibility: 'class_9_12',
      website: 'https://sih.gov.in', description: 'Government hackathon — solve real-world problems',
    ),
    Competition(
      id: 'h2', name: 'ATL Tinkering Marathon', category: 'hackathon',
      registrationStart: DateTime(2025, 6, 1), registrationEnd: DateTime(2025, 9, 30),
      examDate: DateTime(2025, 12, 15), eligibility: 'class_9_12',
      website: 'https://atalinnovationmission.gov.in', description: 'Atal Innovation Mission — tinker and innovate',
    ),
    Competition(
      id: 'h3', name: 'NASA App Development Challenge', category: 'hackathon',
      registrationStart: DateTime(2025, 10, 1), registrationEnd: DateTime(2025, 12, 1),
      examDate: DateTime(2026, 2, 15), eligibility: 'class_9_12',
      website: 'https://www.nasa.gov/learning-resources', description: 'NASA coding challenge for students',
    ),

    // ═══════ ESSAY / WRITING ═══════
    Competition(
      id: 'e1', name: 'CBSE Heritage India Essay Competition', category: 'essay',
      registrationStart: DateTime(2025, 8, 15), registrationEnd: DateTime(2025, 10, 15),
      examDate: DateTime(2025, 11, 30), eligibility: 'class_9_12',
      website: 'https://cbse.gov.in', description: 'CBSE essay competition on Indian heritage',
    ),
    Competition(
      id: 'e2', name: 'UNESCO Essay Contest', category: 'essay',
      registrationStart: DateTime(2025, 6, 1), registrationEnd: DateTime(2025, 7, 31),
      examDate: DateTime(2025, 9, 15), eligibility: 'class_9_12',
      website: 'https://www.unesco.org', description: 'International essay contest on peace and sustainability',
    ),

    // ═══════ RESEARCH ═══════
    Competition(
      id: 'r1', name: 'JBNSTS Junior Scholarship', category: 'research',
      registrationStart: DateTime(2025, 9, 1), registrationEnd: DateTime(2025, 10, 15),
      examDate: DateTime(2025, 11, 20), eligibility: 'class_11_12',
      website: 'https://jbnsts.ac.in', description: 'Jawaharlal Nehru Science Talent search — West Bengal',
    ),
    Competition(
      id: 'r2', name: 'IRIS National Science Fair', category: 'research',
      registrationStart: DateTime(2025, 7, 1), registrationEnd: DateTime(2025, 9, 30),
      examDate: DateTime(2025, 12, 1), eligibility: 'class_9_12',
      website: 'https://irisnationalfair.org', description: 'Science research fair — present original projects',
    ),

    // ═══════ MODEL / ROBOTICS ═══════
    Competition(
      id: 'm1', name: 'World Robot Olympiad (WRO) India', category: 'model',
      registrationStart: DateTime(2025, 6, 15), registrationEnd: DateTime(2025, 8, 31),
      examDate: DateTime(2025, 10, 15), eligibility: 'class_6_12',
      website: 'https://wroindia.org', description: 'Robotics competition — design and program robots',
    ),
    Competition(
      id: 'm2', name: 'FIRST LEGO League India', category: 'model',
      registrationStart: DateTime(2025, 8, 1), registrationEnd: DateTime(2025, 10, 31),
      examDate: DateTime(2026, 1, 15), eligibility: 'class_6_12',
      website: 'https://firstinspires.org', description: 'LEGO robotics and innovation challenge',
    ),
  ];
}

final competitionCalendarProvider = Provider<CompetitionCalendarService>((ref) {
  return CompetitionCalendarService();
});
