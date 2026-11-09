import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:khetmti/core/cache/local_cache.dart';
import 'package:khetmti/core/providers/supabase_providers.dart';
import 'package:khetmti/features/auth/models/app_user.dart';
import 'package:khetmti/features/auth/providers/auth_provider.dart';
import 'package:khetmti/features/social/data/social_repository.dart';
import 'package:khetmti/features/social/models/friendship.dart';

final socialRepositoryProvider = Provider<SocialRepository>((ref) {
  return SocialRepository(ref.watch(supabaseClientProvider));
});

/// All of the user's friendship rows, live, cached on the device.
final friendshipsProvider = StreamProvider<List<Friendship>>((ref) {
  final uid = ref.watch(currentUserIdProvider);
  if (uid == null) return Stream.value(const []);
  return ref.watch(localCacheProvider).rows(
        'friendships.$uid',
        ref.watch(socialRepositoryProvider).friendshipRows(),
        Friendship.fromRow,
      );
});

/// Profiles of the user's friends and of the people who sent them a request,
/// by id. Fetched again only when that set of people changes, not on every
/// friendship update.
final _peopleProvider = StreamProvider<Map<String, AppUser>>((ref) async* {
  final uid = ref.watch(currentUserIdProvider);
  if (uid == null) {
    yield const {};
    return;
  }
  final cache = ref.watch(localCacheProvider);
  final key = 'people.$uid';
  Map<String, AppUser> byId(List<DbRow> rows) =>
      {for (final u in rows.map(AppUser.fromSupabase)) u.uid: u};

  final cached = await cache.readRows(key);
  if (cached != null) yield byId(cached);

  final ids = await ref.watch(friendshipsProvider
      .selectAsync((list) => peopleToShow(list, uid).join(',')));
  final rows = ids.isEmpty
      ? <DbRow>[]
      : await ref.watch(socialRepositoryProvider).profileRows(ids.split(','));
  cache.writeRows(key, rows);
  yield byId(rows);
});

/// Fetches the friends' profiles again (XP, last seen); used by
/// pull-to-refresh, since they are otherwise loaded only when the set of
/// friends changes.
Future<void> refreshPeople(WidgetRef ref) =>
    ref.refresh(_peopleProvider.future);

/// Combines the friendship rows with the profiles they point to.
AsyncValue<List<T>> _withPeople<T>(
  Ref ref,
  T? Function(Friendship f, String me, Map<String, AppUser> people) pick,
) {
  final uid = ref.watch(currentUserIdProvider);
  final friendships = ref.watch(friendshipsProvider);
  final people = ref.watch(_peopleProvider);
  if (uid == null) return const AsyncData([]);
  if (friendships.hasValue && people.hasValue) {
    return AsyncData([
      for (final f in friendships.value!) pick(f, uid, people.value!),
    ].whereType<T>().toList());
  }
  if (friendships.hasError) {
    return AsyncError(friendships.error!, friendships.stackTrace!);
  }
  return const AsyncLoading();
}

final friendsProvider = Provider<AsyncValue<List<AppUser>>>((ref) {
  return _withPeople(
    ref,
    (f, me, people) => f.accepted ? people[f.otherThan(me)] : null,
  );
});

/// Requests waiting for the current user's answer.
final friendRequestsProvider = Provider<AsyncValue<List<FriendRequest>>>((ref) {
  return _withPeople(ref, (f, me, people) {
    if (f.accepted || f.receiver != me) return null;
    final sender = people[f.sender];
    return FriendRequest(
      requestId: f.id,
      senderId: f.sender,
      username: sender?.username ?? '...',
      level: sender?.level ?? 1,
    );
  });
});

final _searchProfilesProvider =
    FutureProvider.autoDispose.family<List<AppUser>, String>((ref, query) {
  return ref.watch(socialRepositoryProvider).searchUsers(query);
});

/// People whose name contains the query, each with their friendship state.
/// The state follows the live friendship rows, so the buttons update after
/// an action without searching again.
final personSearchProvider = Provider.autoDispose
    .family<AsyncValue<List<FriendSearchResult>>, String>((ref, query) {
  final uid = ref.watch(currentUserIdProvider);
  final friendships = ref.watch(friendshipsProvider).valueOrNull ?? const [];
  return ref.watch(_searchProfilesProvider(query)).whenData((users) => [
        for (final u in users)
          if (friendshipWith(friendships, uid ?? '', u.uid) case final f)
            FriendSearchResult(
              uid: u.uid,
              username: u.username,
              level: u.level,
              requestId: f?.id,
              status: f?.statusFor(uid ?? '') ?? FriendshipStatus.none,
            ),
      ]);
});
