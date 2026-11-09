import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

/// The Quran text bundled with the app (assets/data/quran.json), read and
/// parsed once per run, in a background isolate, then kept in memory. Every
/// screen that shows a sura or a juz reads from this one copy; nothing is
/// ever downloaded.
class QuranApiService {
  static Future<_Quran>? _quran;

  /// Starts loading in the background so the first reader opens instantly.
  static Future<void> warmUp() => _load().then((_) {});

  /// Concurrent callers share the same load; a failed load can be retried.
  static Future<_Quran> _load() => _quran ??= rootBundle
          .loadString('assets/data/quran.json')
          .then((json) => compute(_parse, json))
          .then((quran) => quran, onError: (Object e, StackTrace st) {
        _quran = null;
        Error.throwWithStackTrace(e, st);
      });

  static Future<Map<String, dynamic>> fetchSurah(int surahId) async {
    final quran = await _load();
    if (surahId < 1 || surahId > quran.surahs.length) {
      throw Exception('Surah $surahId not found');
    }
    return quran.surahs[surahId - 1];
  }

  static Future<Map<String, dynamic>> fetchJuz(int juzId) async {
    final juz = (await _load()).juzs[juzId];
    if (juz == null) throw Exception('Juz $juzId not found');
    return juz;
  }
}

class _Quran {
  final List<Map<String, dynamic>> surahs;
  final Map<int, Map<String, dynamic>> juzs;
  const _Quran(this.surahs, this.juzs);
}

/// Runs in an isolate: decodes the file and groups the ayahs of each juz
/// once, so opening a juz is a map lookup.
_Quran _parse(String jsonString) {
  final decoded = json.decode(jsonString);
  if (decoded['code'] != 200 || decoded['status'] != 'OK') {
    throw Exception('Invalid local Quran JSON structure');
  }
  final surahs = [
    for (final s in decoded['data']['surahs'] as List) Map<String, dynamic>.from(s as Map),
  ];

  final juzAyahs = <int, List<Map<String, dynamic>>>{};
  for (final surah in surahs) {
    final info = {
      'number': surah['number'],
      'name': surah['name'],
      'englishName': surah['englishName'],
    };
    for (final ayah in surah['ayahs'] as List) {
      final a = Map<String, dynamic>.from(ayah as Map)..['surah'] = info;
      juzAyahs.putIfAbsent(a['juz'] as int, () => []).add(a);
    }
  }

  return _Quran(surahs, {
    for (final e in juzAyahs.entries) e.key: {'number': e.key, 'ayahs': e.value},
  });
}
