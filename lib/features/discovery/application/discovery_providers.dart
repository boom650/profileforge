import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:profileforge/features/discovery/data/discovery_repository.dart';
import 'package:profileforge/features/discovery/domain/discovery_models.dart';

final discoveryRepositoryProvider = Provider<DiscoveryRepository>((ref) {
  return const DiscoveryRepository();
});

final universityGuidesProvider =
    FutureProvider<List<UniversityGuide>?>((ref) {
  return ref.watch(discoveryRepositoryProvider).loadUniversityGuides();
});

final studyTipsProvider = FutureProvider<List<StudyTip>?>((ref) {
  return ref.watch(discoveryRepositoryProvider).loadStudyTips();
});

final olympiadsProvider = FutureProvider<List<Olympiad>?>((ref) {
  return ref.watch(discoveryRepositoryProvider).loadOlympiads();
});

final scholarshipsProvider = FutureProvider<List<Scholarship>?>((ref) {
  return ref.watch(discoveryRepositoryProvider).loadScholarships();
});