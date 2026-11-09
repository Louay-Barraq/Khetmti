import 'package:flutter_test/flutter_test.dart';
import 'package:khetmti/features/social/models/friendship.dart';

void main() {
  Friendship row(String id, String from, String to, {bool accepted = false}) =>
      Friendship.fromRow({
        'doc_id': id,
        'sender': from,
        'receiver': to,
        'status': accepted ? 'accepted' : 'pending',
      });

  final rows = [
    row('1', 'me', 'rania', accepted: true),
    row('2', 'sara', 'me', accepted: true),
    row('3', 'me', 'aljia'),
    row('4', 'ali', 'me'),
  ];

  test('each row reads the right way from my side', () {
    expect(rows[0].statusFor('me'), FriendshipStatus.friends);
    expect(rows[1].statusFor('me'), FriendshipStatus.friends);
    expect(rows[2].statusFor('me'), FriendshipStatus.pending);
    expect(rows[3].statusFor('me'), FriendshipStatus.received);
  });

  test('friendshipWith finds the row in either direction', () {
    expect(friendshipWith(rows, 'me', 'sara')?.id, '2');
    expect(friendshipWith(rows, 'me', 'aljia')?.id, '3');
    expect(friendshipWith(rows, 'me', 'youssef'), isNull);
  });

  test('profiles to load: friends and people waiting for my answer', () {
    // aljia is left out: I sent that request, so no profile is shown for it.
    expect(peopleToShow(rows, 'me'), ['ali', 'rania', 'sara']);
  });
}
