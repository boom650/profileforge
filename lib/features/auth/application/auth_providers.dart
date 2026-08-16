import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:profileforge/features/auth/data/auth_repository.dart';
import 'package:profileforge/features/auth/domain/auth_models.dart';

final authRepositoryProvider = FutureProvider<AuthRepository>((ref) async {
  final prefs = await SharedPreferences.getInstance();
  return AuthRepository(prefs);
});

/// The device's current auth status — guest, email-authenticated or neither.
final authStatusProvider = FutureProvider<AuthStatus>((ref) async {
  final repo = await ref.watch(authRepositoryProvider.future);
  return repo.currentUser().status;
});