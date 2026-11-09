import 'package:flutter_test/flutter_test.dart';
import 'package:khetmti/core/utils/helpers.dart';
import 'package:khetmti/features/khetma/models/khetma.dart';

void main() {
  test('a database row becomes a khatma with its parts and log', () {
    final k = Khetma.fromSupabase({
      'doc_id': 'k1',
      'name': 'شعب فلسطين',
      'code': '48213',
      'creatorId': 'u1',
      'splitType': 'sura',
      'currentParticipantsNumber': 5,
      'maxParticipantsNumber': 10,
      'completionPercent': 0.25,
      'finishedParts': 1,
      'totalParts': 4,
      'createdAt': '2026-11-08T10:00:00+00:00',
      'parts': {
        'الفاتحة': {'status': 'finished', 'uid': 'u1', 'username': 'محمد'},
        'البقرة': {'status': 'available', 'uid': null},
      },
      'logs': [
        {
          'username': 'محمد',
          'uid': 'u1',
          'part': 'الفاتحة',
          'action': 'أتم القراءة',
          'timestamp': '2026-11-08T10:05:00+00:00',
        },
      ],
    });

    expect(k.khetmaId, 'k1');
    expect(k.parts['الفاتحة']!.isFinished, isTrue);
    expect(k.parts['الفاتحة']!.username, 'محمد');
    expect(k.parts['البقرة']!.isAvailable, isTrue);
    expect(k.logs.single.part, 'الفاتحة');
    expect(k.createdAt, DateTime.utc(2026, 11, 8, 10));
    expect(k.isCompleted, isFalse);
  });

  test('missing fields fall back to safe defaults', () {
    final k = Khetma.fromSupabase({'doc_id': 'k2'});
    expect(k.parts, isEmpty);
    expect(k.logs, isEmpty);
    expect(k.completionPercent, 0);
    expect(k.createdAt, isNull);
  });

  test('a khatma is completed at 100%', () {
    expect(Khetma.fromSupabase({'completionPercent': 1}).isCompleted, isTrue);
  });

  test('toArabicDigits and isValidEmail', () {
    expect(toArabicDigits(0), '٠');
    expect(toArabicDigits(286), '٢٨٦');
    expect(isValidEmail('a.b@khetmti.app'), isTrue);
    expect(isValidEmail('not an email'), isFalse);
  });
}
