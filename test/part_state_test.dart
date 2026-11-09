import 'package:flutter_test/flutter_test.dart';
import 'package:khetmti/features/khetma/models/khetma_part.dart';
import 'package:khetmti/features/khetma/models/part_state.dart';

void main() {
  const me = 'me';
  const other = 'other';

  test('a part nobody holds is available, whoever looks', () {
    expect(PartState.of(const KhetmaPart(), me), PartState.available);
    expect(PartState.of(const KhetmaPart(), null), PartState.available);
  });

  test('a reserved part is mine or taken depending on who holds it', () {
    const mine = KhetmaPart(status: 'reserved', uid: me);
    const theirs = KhetmaPart(status: 'reserved', uid: other);
    expect(PartState.of(mine, me), PartState.mine);
    expect(PartState.of(theirs, me), PartState.taken);
  });

  test('a finished part tells apart my reading from someone else\'s', () {
    const mine = KhetmaPart(status: 'finished', uid: me);
    const theirs = KhetmaPart(status: 'finished', uid: other);
    expect(PartState.of(mine, me), PartState.finishedByMe);
    expect(PartState.of(theirs, me), PartState.finished);
    expect(PartState.finishedByMe.isFinished, isTrue);
    expect(PartState.finished.isFinished, isTrue);
    expect(PartState.mine.isFinished, isFalse);
  });

  test('a signed-out viewer never owns a part', () {
    const reserved = KhetmaPart(status: 'reserved', uid: me);
    expect(PartState.of(reserved, null), PartState.taken);
  });
}
