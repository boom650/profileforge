import 'package:flutter_riverpod/flutter_riverpod.dart';

class UDISchool {
  final String id;
  final String name;
  final String district;
  final String state;
  const UDISchool({required this.id, required this.name, required this.district, required this.state});
}

class UDISESchoolService {
  Future<List<UDISchool>> searchSchools(String query) async => [];
  Future<UDISchool?> getSchool(String udiseCode) async => null;
}

final udiseSchoolServiceProvider = Provider<UDISESchoolService>((ref) => UDISESchoolService());
