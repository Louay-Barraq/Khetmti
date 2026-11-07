import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:khetmti/features/quran/data/quran_repository.dart';

final quranRepositoryProvider = Provider<QuranRepository>((ref) {
  return QuranRepository();
});

final stopsProvider =
    FutureProvider.family<Set<int>, String>((ref, stopsKey) {
  return ref.watch(quranRepositoryProvider).loadStops(stopsKey: stopsKey);
});
