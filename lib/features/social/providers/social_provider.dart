import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:khetmti/core/providers/supabase_providers.dart';
import 'package:khetmti/features/auth/models/app_user.dart';
import 'package:khetmti/features/social/data/social_repository.dart';
import 'package:khetmti/features/social/models/friendship.dart';

final socialRepositoryProvider = Provider<SocialRepository>((ref) {
  return SocialRepository(ref.watch(supabaseClientProvider));
});

final friendsProvider = StreamProvider<List<AppUser>>((ref) {
  return ref.watch(socialRepositoryProvider).friendsStream();
});

final friendRequestsProvider = StreamProvider<List<FriendRequest>>((ref) {
  return ref.watch(socialRepositoryProvider).friendRequestsStream();
});

/// Search results are dropped when the search page closes; invalidate after
/// an action so the buttons show the new state.
final personSearchProvider = FutureProvider.autoDispose
    .family<List<FriendSearchResult>, String>((ref, query) {
  return ref.watch(socialRepositoryProvider).searchUsers(query);
});
