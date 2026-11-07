import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:khetmti/core/providers/supabase_providers.dart';
import 'package:khetmti/features/auth/providers/auth_provider.dart';
import 'package:khetmti/features/khetma/data/khetma_repository.dart';
import 'package:khetmti/features/khetma/models/khetma.dart';

final khetmaRepositoryProvider = Provider<KhetmaRepository>((ref) {
  return KhetmaRepository(ref.watch(supabaseClientProvider));
});

/// Stream a single khetma by ID.
final khetmaProvider = StreamProvider.family<Khetma, String>((ref, khetmaId) {
  return ref.watch(khetmaRepositoryProvider).khetmaStream(khetmaId);
});

final _joinedKhetmaIdsProvider = StreamProvider<List<String>>((ref) {
  final userId = ref.watch(authStateProvider).valueOrNull?.id;
  if (userId == null) return Stream.value(const []);
  return ref.watch(khetmaRepositoryProvider).joinedKhetmaIdsStream(userId);
});

final _userKhetmasProvider = StreamProvider<List<Khetma>>((ref) async* {
  final ids = await ref.watch(_joinedKhetmaIdsProvider.future);
  if (ids.isEmpty) {
    yield const [];
    return;
  }
  yield* ref.watch(khetmaRepositoryProvider).khetmasStream(ids);
});

/// The current user's in-progress khetmas (completed: false)
/// or completed ones (completed: true), live.
final userKhetmasProvider =
    Provider.family<AsyncValue<List<Khetma>>, bool>((ref, completed) {
  return ref.watch(_userKhetmasProvider).whenData(
        (khetmas) =>
            khetmas.where((k) => k.isCompleted == completed).toList(),
      );
});
