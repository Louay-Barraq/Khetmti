import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:khetmti/core/cache/local_cache.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  late LocalCache cache;

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    cache = LocalCache();
  });

  test('rows written are read back', () async {
    await cache.writeRows('k', [
      {'doc_id': 'a', 'n': 1},
    ]);
    expect(await cache.readRows('k'), [
      {'doc_id': 'a', 'n': 1},
    ]);
  });

  test('unreadable data counts as no cache', () async {
    SharedPreferences.setMockInitialValues({'cache.k': 'not json'});
    expect(await LocalCache().readRows('k'), isNull);
  });

  test('clear removes cached rows but keeps other settings', () async {
    SharedPreferences.setMockInitialValues({'onboarding': true});
    await cache.writeRows('k', [{'x': 1}]);
    await cache.clear();
    final prefs = await SharedPreferences.getInstance();
    expect(await cache.readRows('k'), isNull);
    expect(prefs.getBool('onboarding'), isTrue);
  });

  test('rows() shows the cache first, then live data, and saves it', () async {
    await cache.writeRows('k', [{'v': 'old'}]);
    final live = StreamController<List<DbRow>>();

    final seen = <String>[];
    final sub = cache.rows('k', live.stream, (r) => r['v'] as String).listen(
          (values) => seen.addAll(values),
        );
    await pumpEventQueue();
    expect(seen, ['old']);

    live.add([{'v': 'new'}]);
    await pumpEventQueue();
    expect(seen, ['old', 'new']);
    expect(await cache.readRows('k'), [{'v': 'new'}]);

    await live.close();
    await sub.cancel();
  });

  test('cachedOnly emits nothing when there is no cache', () async {
    expect(await cache.cachedOnly('missing', (r) => r).toList(), isEmpty);
  });
}
