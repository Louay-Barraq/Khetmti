enum FriendshipStatus { none, pending, received, friends }

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
