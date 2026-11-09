import 'package:flutter_test/flutter_test.dart';
import 'package:khetmti/features/quran/data/quran_api_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('suras and juz come from the bundled text, parsed once', () async {
    final fatiha = await QuranApiService.fetchSurah(1);
    expect(fatiha['ayahs'], hasLength(7));
    expect((await QuranApiService.fetchSurah(114))['number'], 114);

    // Juz 30 starts with An-Naba and ends with An-Nas.
    final juz30 = await QuranApiService.fetchJuz(30);
    final ayahs = juz30['ayahs'] as List;
    expect(ayahs.first['surah']['number'], 78);
    expect(ayahs.last['surah']['number'], 114);

    // Every ayah of the Quran is in exactly one juz.
    var total = 0;
    for (var j = 1; j <= 30; j++) {
      total += ((await QuranApiService.fetchJuz(j))['ayahs'] as List).length;
    }
    expect(total, 6236);

    expect(identical(await QuranApiService.fetchJuz(30), juz30), isTrue);
    expect(() => QuranApiService.fetchSurah(115), throwsException);
  });
}
