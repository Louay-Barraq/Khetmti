import 'package:shared_preferences/shared_preferences.dart';

class QuranRepository {
  Future<Set<int>> loadStops({
    required String stopsKey,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final stopsList = prefs.getStringList(stopsKey) ?? [];
    return stopsList.map((e) => int.parse(e)).toSet();
  }

  Future<void> saveStops({
    required String stopsKey,
    required Set<int> stops,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
      stopsKey,
      stops.map((e) => e.toString()).toList(),
    );
  }
}
