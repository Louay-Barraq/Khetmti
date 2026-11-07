enum FriendshipStatus { none, pending, received, friends }

class FriendSearchResult {
  final String uid;
  final String username;
  final String email;
  final FriendshipStatus status;

  const FriendSearchResult({
    required this.uid,
    required this.username,
    required this.email,
    this.status = FriendshipStatus.none,
  });
}

class FriendRequest {
  final String requestId;
  final String senderId;
  final String username;
  final String email;

  const FriendRequest({
    required this.requestId,
    required this.senderId,
    required this.username,
    required this.email,
  });

  factory FriendRequest.fromSupabase(Map<String, dynamic> data) {
    return FriendRequest(
      requestId: data['doc_id'] ?? '',
      senderId: data['sender'] ?? '',
      username: data['username'] ?? 'Unknown',
      email: data['email'] ?? '',
    );
  }
}
