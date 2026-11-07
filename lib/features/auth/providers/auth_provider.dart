import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:khetmti/core/providers/supabase_providers.dart';
import 'package:khetmti/features/auth/data/auth_repository.dart';
import 'package:khetmti/features/auth/models/app_user.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository(ref.watch(supabaseClientProvider));
});

final authStateProvider = StreamProvider<User?>((ref) {
  return ref.watch(authRepositoryProvider).authStateChanges();
});

final currentUserProvider = StreamProvider<AppUser?>((ref) {
  final authState = ref.watch(authStateProvider);
  return authState.when(
    data: (user) {
      if (user == null) return Stream.value(null);
      return ref.watch(authRepositoryProvider).userStream(user.id);
    },
    loading: () => Stream.value(null),
    error: (_, __) => Stream.value(null),
  );
});
