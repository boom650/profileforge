import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../tables/all_tables.dart';

class StringListConverter extends TypeConverter<List<String>, String> {
  const StringListConverter();

  @override
  List<String> fromSql(String fromDb) {
    if (fromDb.isEmpty) return [];
    try {
      return List<String>.from(jsonDecode(fromDb));
    } catch (_) {
      return fromDb.split(',').where((s) => s.isNotEmpty).toList();
    }
  }

  @override
  String toSql(List<String> value) {
    return jsonEncode(value);
  }
}

class MapStringStringConverter extends TypeConverter<Map<String, String>, String> {
  const MapStringStringConverter();

  @override
  Map<String, String> fromSql(String fromDb) {
    if (fromDb.isEmpty) return {};
    try {
      final Map<String, dynamic> decoded = jsonDecode(fromDb);
      return decoded.map((k, v) => MapEntry(k, v.toString()));
    } catch (_) {
      return {};
    }
  }

  @override
  String toSql(Map<String, String> value) {
    return jsonEncode(value);
  }
}

class MapStringDoubleConverter extends TypeConverter<Map<String, double>, String> {
  const MapStringDoubleConverter();

  @override
  Map<String, double> fromSql(String fromDb) {
    if (fromDb.isEmpty) return {};
    try {
      final Map<String, dynamic> decoded = jsonDecode(fromDb);
      return decoded.map((k, v) => MapEntry(k, (v as num).toDouble()));
    } catch (_) {
      return {};
    }
  }

  @override
  String toSql(Map<String, double> value) {
    return jsonEncode(value);
  }
}

class ActivityCategoryConverter extends TypeConverter<ActivityCategory, String> {
  const ActivityCategoryConverter();

  @override
  ActivityCategory fromSql(String fromDb) {
    return ActivityCategory.values.firstWhere(
      (e) => e.name == fromDb,
      orElse: () => ActivityCategory.unique,
    );
  }

  @override
  String toSql(ActivityCategory value) {
    return value.name;
  }
}

class ActivityTierConverter extends TypeConverter<ActivityTier, String> {
  const ActivityTierConverter();

  @override
  ActivityTier fromSql(String fromDb) {
    return ActivityTier.values.firstWhere(
      (e) => e.name == fromDb,
      orElse: () => ActivityTier.tier4,
    );
  }

  @override
  String toSql(ActivityTier value) {
    return value.name;
  }
}

class MissionCategoryConverter extends TypeConverter<MissionCategory, String> {
  const MissionCategoryConverter();

  @override
  MissionCategory fromSql(String fromDb) {
    return MissionCategory.values.firstWhere(
      (e) => e.name == fromDb,
      orElse: () => MissionCategory.daily,
    );
  }

  @override
  String toSql(MissionCategory value) {
    return value.name;
  }
}

class MissionTypeConverter extends TypeConverter<MissionType, String> {
  const MissionTypeConverter();

  @override
  MissionType fromSql(String fromDb) {
    return MissionType.values.firstWhere(
      (e) => e.name == fromDb,
      orElse: () => MissionType.recurring,
    );
  }

  @override
  String toSql(MissionType value) {
    return value.name;
  }
}

class MissionFrequencyConverter extends TypeConverter<MissionFrequency, String> {
  const MissionFrequencyConverter();

  @override
  MissionFrequency fromSql(String fromDb) {
    return MissionFrequency.values.firstWhere(
      (e) => e.name == fromDb,
      orElse: () => MissionFrequency.daily,
    );
  }

  @override
  String toSql(MissionFrequency value) {
    return value.name;
  }
}

class MissionDifficultyConverter extends TypeConverter<MissionDifficulty, String> {
  const MissionDifficultyConverter();

  @override
  MissionDifficulty fromSql(String fromDb) {
    return MissionDifficulty.values.firstWhere(
      (e) => e.name == fromDb,
      orElse: () => MissionDifficulty.easy,
    );
  }

  @override
  String toSql(MissionDifficulty value) {
    return value.name;
  }
}

enum OpportunityCategory {
  competition,
  scholarship,
  summerProgram,
  research,
  internship,
  academic,
  entrepreneurship,
  leadership,
  volunteering,
  arts,
  sports,
}

enum OpportunityType {
  competition,
  scholarship,
  research,
  internship,
  academic,
  summerProgram,
  entrepreneurship,
  leadership,
  volunteering,
}

enum OpportunityDifficulty {
  easy,
  medium,
  hard,
  expert,
  legendary,
}

enum OpportunityPrestige {
  common,
  uncommon,
  rare,
  epic,
  legendary,
}

class OpportunityCategoryConverter extends TypeConverter<OpportunityCategory, String> {
  const OpportunityCategoryConverter();

  @override
  OpportunityCategory fromSql(String fromDb) {
    return OpportunityCategory.values.firstWhere(
      (e) => e.name == fromDb,
      orElse: () => OpportunityCategory.competition,
    );
  }

  @override
  String toSql(OpportunityCategory value) {
    return value.name;
  }
}

class OpportunityTypeConverter extends TypeConverter<OpportunityType, String> {
  const OpportunityTypeConverter();

  @override
  OpportunityType fromSql(String fromDb) {
    return OpportunityType.values.firstWhere(
      (e) => e.name == fromDb,
      orElse: () => OpportunityType.competition,
    );
  }

  @override
  String toSql(OpportunityType value) {
    return value.name;
  }
}

class OpportunityDifficultyConverter extends TypeConverter<OpportunityDifficulty, String> {
  const OpportunityDifficultyConverter();

  @override
  OpportunityDifficulty fromSql(String fromDb) {
    return OpportunityDifficulty.values.firstWhere(
      (e) => e.name == fromDb,
      orElse: () => OpportunityDifficulty.medium,
    );
  }

  @override
  String toSql(OpportunityDifficulty value) {
    return value.name;
  }
}

class OpportunityPrestigeConverter extends TypeConverter<OpportunityPrestige, String> {
  const OpportunityPrestigeConverter();

  @override
  OpportunityPrestige fromSql(String fromDb) {
    return OpportunityPrestige.values.firstWhere(
      (e) => e.name == fromDb,
      orElse: () => OpportunityPrestige.common,
    );
  }

  @override
  String toSql(OpportunityPrestige value) {
    return value.name;
  }
}

class SkinRarityConverter extends TypeConverter<SkinRarity, String> {
  const SkinRarityConverter();

  @override
  SkinRarity fromSql(String fromDb) {
    return SkinRarity.values.firstWhere(
      (e) => e.name == fromDb,
      orElse: () => SkinRarity.common,
    );
  }

  @override
  String toSql(SkinRarity value) {
    return value.name;
  }
}

class SkinCategoryConverter extends TypeConverter<SkinCategory, String> {
  const SkinCategoryConverter();

  @override
  SkinCategory fromSql(String fromDb) {
    return SkinCategory.values.firstWhere(
      (e) => e.name == fromDb,
      orElse: () => SkinCategory.profile,
    );
  }

  @override
  String toSql(SkinCategory value) {
    return value.name;
  }
}

enum UniversityCategory {
  reach,
  match,
  safety,
  dream,
  target,
}

class UniversityCategoryConverter extends TypeConverter<UniversityCategory, String> {
  const UniversityCategoryConverter();

  @override
  UniversityCategory fromSql(String fromDb) {
    return UniversityCategory.values.firstWhere(
      (e) => e.name == fromDb,
      orElse: () => UniversityCategory.target,
    );
  }

  @override
  String toSql(UniversityCategory value) {
    return value.name;
  }
}