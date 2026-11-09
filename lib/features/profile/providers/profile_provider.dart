import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:khetmti/features/auth/models/app_user.dart';
import 'package:khetmti/features/auth/providers/auth_provider.dart';
import 'package:khetmti/features/social/providers/social_provider.dart';

/// The current user and their friends, highest XP first.
final rankingsProvider = Provider<AsyncValue<List<AppUser>>>((ref) {
  final me = ref.watch(currentUserProvider);
  final friends = ref.watch(friendsProvider);
  if (me.hasValue && friends.hasValue) {
    return AsyncData([if (me.value != null) me.value!, ...friends.value!]
      ..sort((a, b) => b.totalXP.compareTo(a.totalXP)));
  }
  if (me.hasError) return AsyncError(me.error!, me.stackTrace!);
  return const AsyncLoading();
});
