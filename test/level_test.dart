import 'package:flutter_test/flutter_test.dart';
import 'package:khetmti/features/auth/models/app_user.dart';

void main() {
  test('levels start at the XP returned by xpForLevel', () {
    expect(xpForLevel(1), 0);
    expect(xpForLevel(2), 1000);
    expect(xpForLevel(3), 2200);

    for (var level = 1; level <= 40; level++) {
      final start = xpForLevel(level);
      expect(levelForXp(start), level, reason: 'first XP of level $level');
      if (level > 1) {
        expect(levelForXp(start - 1), level - 1, reason: 'last XP before $level');
      }
    }
  });

  test('zero and negative XP are level 1', () {
    expect(levelForXp(0), 1);
    expect(levelForXp(-50), 1);
  });
}
