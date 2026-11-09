enum FriendshipStatus { none, pending, received, friends }

/// A row of `friendships`: a request from [sender] to [receiver], which
/// becomes a friendship once accepted.
class Friendship {
  final String id;
  final String sender;
  final String receiver;
  final bool accepted;

  const Friendship({
    required this.id,
    required this.sender,
    required this.receiver,
    required this.accepted,
  });

  factory Friendship.fromRow(Map<String, dynamic> row) => Friendship(
        id: row['doc_id'] as String,
        sender: row['sender'] as String,
        receiver: row['receiver'] as String,
        accepted: row['status'] == 'accepted',
      );

  String otherThan(String userId) => sender == userId ? receiver : sender;

  /// How this row looks from [userId]'s side.
  FriendshipStatus statusFor(String userId) => accepted
      ? FriendshipStatus.friends
      : sender == userId
          ? FriendshipStatus.pending
          : FriendshipStatus.received;
}

/// The row between [me] and [other] in [friendships], if any.
Friendship? friendshipWith(List<Friendship> friendships, String me, String other) {
  for (final f in friendships) {
    if (f.otherThan(me) == other && (f.sender == me || f.receiver == me)) return f;
  }
  return null;
}

/// Ids of [me]'s friends and of the people waiting for [me] to answer
/// their request, sorted.
List<String> peopleToShow(List<Friendship> friendships, String me) => [
      for (final f in friendships)
        if (f.accepted || f.receiver == me) f.otherThan(me),
    ]..sort();

class FriendSearchResult {
  final String uid;
  final String username;
  final int level;
  final FriendshipStatus status;

  /// The friendship row between the current user and this user, if any.
  final String? requestId;

  const FriendSearchResult({
    required this.uid,
    required this.username,
    required this.level,
    this.status = FriendshipStatus.none,
    this.requestId,
  });
}

class FriendRequest {
  final String requestId;
  final String senderId;
  final String username;
  final int level;

  const FriendRequest({
    required this.requestId,
    required this.senderId,
    required this.username,
    required this.level,
  });
}
