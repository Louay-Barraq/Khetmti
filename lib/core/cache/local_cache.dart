import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

typedef DbRow = Map<String, dynamic>;

/// The last rows the server sent, kept on the device. Screens show them
/// straight away on the next launch while the live stream connects, and
/// keep showing them when there is no connection.
class LocalCache {
  static const _prefix = 'cache.';

  Future<List<DbRow>?> readRows(String key) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString('$_prefix$key');
    if (raw == null) return null;
    try {
      return [for (final row in jsonDecode(raw) as List) DbRow.from(row as Map)];
    } catch (_) {
      return null; // Written by an older app version; the live data replaces it.
    }
  }

  Future<void> writeRows(String key, List<DbRow> rows) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('$_prefix$key', jsonEncode(rows));
  }

  /// Called on sign-out so the next account never sees this one's data.
  Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    for (final key in prefs.getKeys().where((k) => k.startsWith(_prefix))) {
      await prefs.remove(key);
    }
  }

  /// The cached rows (if any), then every live emission, saving each one.
  Stream<List<T>> rows<T>(
    String key,
    Stream<List<DbRow>> live,
    T Function(DbRow) fromRow,
  ) async* {
    final cached = await readRows(key);
    if (cached != null) yield cached.map(fromRow).toList();
    await for (final rows in live) {
      writeRows(key, rows);
      yield rows.map(fromRow).toList();
    }
  }

  /// Only the cached rows, for when the live query cannot start yet.
  Stream<List<T>> cachedOnly<T>(String key, T Function(DbRow) fromRow) async* {
    final cached = await readRows(key);
    if (cached != null) yield cached.map(fromRow).toList();
  }
}

final localCacheProvider = Provider<LocalCache>((ref) => LocalCache());
