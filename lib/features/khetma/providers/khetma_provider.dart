import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:khetmti/core/providers/supabase_providers.dart';
import 'package:khetmti/features/khetma/data/khetma_repository.dart';
import 'package:khetmti/features/khetma/models/khetma.dart';

final khetmaRepositoryProvider = Provider<KhetmaRepository>((ref) {
  return KhetmaRepository(ref.watch(supabaseClientProvider));
});

/// Stream a single khetma by ID.
final khetmaProvider = StreamProvider.family<Khetma, String>((ref, khetmaId) {
  return ref.watch(khetmaRepositoryProvider).khetmaStream(khetmaId);
});

/// Stream the current user's in-progress khetmas (completed: false)
/// or completed ones (completed: true).
final userKhetmasProvider =
    StreamProvider.family<List<Khetma>, bool>((ref, completed) {
  return ref
      .watch(khetmaRepositoryProvider)
      .userKhetmasStream(completed: completed);
});
