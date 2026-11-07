import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:khetmti/features/auth/models/app_user.dart';
import 'package:khetmti/features/auth/providers/auth_provider.dart';
import 'package:khetmti/features/social/providers/social_provider.dart';

/// The current user and their friends, highest XP first.
final rankingsProvider = FutureProvider<List<AppUser>>((ref) async {
  final me = await ref.watch(currentUserProvider.future);
  if (me == null) return [];
  final friends = await ref.watch(friendsProvider.future);

  return [me, ...friends]..sort((a, b) => b.totalXP.compareTo(a.totalXP));
});
