import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:khetmti/core/cache/local_cache.dart';
import 'package:khetmti/core/providers/supabase_providers.dart';
import 'package:khetmti/features/auth/models/app_user.dart';
import 'package:khetmti/features/auth/providers/auth_provider.dart';
import 'package:khetmti/features/khetma/data/khetma_repository.dart';
import 'package:khetmti/features/khetma/models/khetma.dart';

final khetmaRepositoryProvider = Provider<KhetmaRepository>((ref) {
  return KhetmaRepository(ref.watch(supabaseClientProvider));
});

final _joinedKhetmaIdsProvider = StreamProvider<List<String>>((ref) {
  final userId = ref.watch(currentUserIdProvider);
  if (userId == null) return Stream.value(const []);
  return ref.watch(khetmaRepositoryProvider).joinedKhetmaIdsStream(userId);
});

/// Every khatma the user takes part in, live, from one subscription that the
/// home page, the profile page and the khatma page all share. The last list
/// is cached on the device, so it shows at once on the next launch.
final _userKhetmasProvider = StreamProvider<List<Khetma>>((ref) {
  final uid = ref.watch(currentUserIdProvider);
  if (uid == null) return Stream.value(const []);

  // Comparing a sorted string keeps the khatma stream open when the
  // membership stream re-emits the same ids (e.g. after a reconnect).
  final ids = ref.watch(_joinedKhetmaIdsProvider
      .select((a) => a.valueOrNull == null ? null : ([...a.value!]..sort()).join(',')));

  final cache = ref.watch(localCacheProvider);
  final key = 'khatms.$uid';
  if (ids == null) return cache.cachedOnly(key, Khetma.fromSupabase);
  if (ids.isEmpty) {
    cache.writeRows(key, const []);
    return Stream.value(const []);
  }
  return cache.rows(
    key,
    ref.watch(khetmaRepositoryProvider).khetmaRows(ids.split(',')),
    Khetma.fromSupabase,
  );
});

/// The current user's in-progress khetmas (completed: false)
/// or completed ones (completed: true), newest first.
final userKhetmasProvider =
    Provider.family<AsyncValue<List<Khetma>>, bool>((ref, completed) {
  return ref.watch(_userKhetmasProvider).whenData(
        (khetmas) => khetmas.where((k) => k.isCompleted == completed).toList()
          ..sort((a, b) => (b.createdAt ?? DateTime(0))
              .compareTo(a.createdAt ?? DateTime(0))),
      );
});

final _otherKhetmaProvider =
    StreamProvider.autoDispose.family<Khetma, String>((ref, khetmaId) {
  return ref.watch(khetmaRepositoryProvider).khetmaStream(khetmaId);
});

/// One khatma, live. A khatma the user is in comes from the shared list, so
/// opening it is instant and costs no new subscription; any other khatma gets
/// its own stream, closed when the page closes.
final khetmaProvider =
    Provider.autoDispose.family<AsyncValue<Khetma>, String>((ref, khetmaId) {
  final mine = ref.watch(_userKhetmasProvider);
  final own = mine.valueOrNull?.where((k) => k.khetmaId == khetmaId).firstOrNull;
  if (own != null) return AsyncData(own);
  if (!mine.hasValue) return const AsyncLoading();
  return ref.watch(_otherKhetmaProvider(khetmaId));
});

/// Members of a khatma, fetched when its participants tab is opened.
final khetmaParticipantsProvider =
    FutureProvider.autoDispose.family<List<AppUser>, String>((ref, khetmaId) {
  return ref.watch(khetmaRepositoryProvider).participants(khetmaId);
});
