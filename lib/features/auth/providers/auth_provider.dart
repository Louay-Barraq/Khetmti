import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:khetmti/core/cache/local_cache.dart';
import 'package:khetmti/core/providers/supabase_providers.dart';
import 'package:khetmti/features/auth/data/auth_repository.dart';
import 'package:khetmti/features/auth/models/app_user.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository(
    ref.watch(supabaseClientProvider),
    ref.watch(localCacheProvider),
  );
});

/// Emits on every auth event, including the hourly token refresh.
final authStateProvider = StreamProvider<User?>((ref) {
  return ref.watch(authRepositoryProvider).authStateChanges();
});

/// The signed-in user's id. Changes only on sign-in and sign-out, so the
/// streams that depend on it are not reopened on every token refresh.
final currentUserIdProvider = Provider<String?>((ref) {
  return ref.watch(authStateProvider.select((s) => s.valueOrNull?.id));
});

final currentUserProvider = StreamProvider<AppUser?>((ref) {
  final uid = ref.watch(currentUserIdProvider);
  if (uid == null) return Stream.value(null);
  return ref
      .watch(localCacheProvider)
      .rows('me.$uid', ref.watch(authRepositoryProvider).userRows(uid),
          AppUser.fromSupabase)
      .where((users) => users.isNotEmpty)
      .map((users) => users.first);
});
