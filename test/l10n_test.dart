import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:khetmti/core/utils/helpers.dart';
import 'package:khetmti/features/quran/models/quran_data.dart';
import 'package:khetmti/l10n/l10n.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));

  test('Arabic is the default and keeps Arabic names and digits', () async {
    await L10n.load();
    expect(L10n.locale.languageCode, 'ar');
    expect(tr.surahName(displaySurah('الفاتحة')), 'سورة الفاتحة');
    expect(displayJuz('الجزء الثلاثون'), 'الجزء الثلاثون');
    expect(toArabicDigits(114), '١١٤');
  });

  test('switching language changes strings, names and digits, and is saved', () async {
    await L10n.save('en');
    expect(tr.surahName(displaySurah('الناس')), 'Surah An-Nas');
    expect(displayJuz('الجزء الثلاثون'), 'Juz 30');
    expect(tr.participantsCount(1), '1 member');
    expect(toArabicDigits(114), '114');
    await L10n.save('fr');
    expect(tr.signIn, 'Se connecter');
    L10n.locale = const Locale('ar');
    await L10n.load();
    expect(L10n.locale.languageCode, 'fr');
    await L10n.save('ar');
  });

  test('every surah has a Latin name', () {
    expect(surahNamesLatin.length, sourasWithAyahs.length);
  });
}
