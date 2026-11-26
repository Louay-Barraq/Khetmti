import 'package:flutter_test/flutter_test.dart';
import 'package:khetmti/features/quran/presentation/quran_view_page.dart';

void main() {
  test('strips the basmala whatever the order of the harakat', () {
    // Al-Mulk 1 as bundled: shadda before fatha
    const ayah = 'بِسْمِ ٱللَّهِ ٱلرَّحْمَٰنِ ٱلرَّحِيمِ تَبَٰرَكَ ٱلَّذِى';
    expect(stripBasmala(ayah), 'تَبَٰرَكَ ٱلَّذِى');
    expect(stripBasmala('بسم الله الرحمن الرحيم قل'), 'قل');
  });

  test('leaves other ayat untouched', () {
    expect(stripBasmala('ٱلْحَمْدُ لِلَّهِ رَبِّ ٱلْعَٰلَمِينَ'), 'ٱلْحَمْدُ لِلَّهِ رَبِّ ٱلْعَٰلَمِينَ');
  });
}
