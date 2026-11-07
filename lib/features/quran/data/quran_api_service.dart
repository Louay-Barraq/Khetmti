import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';

Map<String, dynamic> _parseQuranJson(String jsonString) {
  final decodedData = json.decode(jsonString);
  if (decodedData['code'] == 200 && decodedData['status'] == 'OK') {
    return decodedData['data'];
  } else {
    throw Exception('Invalid local Quran JSON structure');
  }
}

class QuranApiService {
  static Map<String, dynamic>? _cachedQuranData;

  static Future<Map<String, dynamic>> _getQuranData() async {
    if (_cachedQuranData != null) return _cachedQuranData!;

    try {
      final jsonString = await rootBundle.loadString('assets/data/quran.json');
      _cachedQuranData = await compute(_parseQuranJson, jsonString);
      return _cachedQuranData!;
    } catch (e) {
      debugPrint('Error loading local Quran data: $e');
      rethrow;
    }
  }

  static Future<Map<String, dynamic>> fetchSurah(int surahId) async {
    try {
      final quranData = await _getQuranData();
      final List<dynamic> surahs = quranData['surahs'];

      final surah = surahs.firstWhere((s) => s['number'] == surahId,
          orElse: () => throw Exception('Surah $surahId not found'));

      return surah;
    } catch (e) {
      debugPrint('Error fetching Surah $surahId: $e');
      rethrow;
    }
  }

  static Future<Map<String, dynamic>> fetchJuz(int juzId) async {
    try {
      final quranData = await _getQuranData();
      final List<dynamic> surahs = quranData['surahs'];

      List<dynamic> juzAyahs = [];

      for (var surah in surahs) {
        final ayahs = surah['ayahs'] as List<dynamic>;
        for (var ayah in ayahs) {
          if (ayah['juz'] == juzId) {
            var wrappedAyah = Map<String, dynamic>.from(ayah);
            wrappedAyah['surah'] = {
              'number': surah['number'],
              'name': surah['name'],
              'englishName': surah['englishName']
            };
            juzAyahs.add(wrappedAyah);
          }
        }
      }

      if (juzAyahs.isEmpty) {
        throw Exception('Juz $juzId not found or empty');
      }

      return {
        'number': juzId,
        'ayahs': juzAyahs,
      };
    } catch (e) {
      debugPrint('Error fetching Juz $juzId: $e');
      rethrow;
    }
  }
}
