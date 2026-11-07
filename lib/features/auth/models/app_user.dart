class AppUser {
  final String uid;
  final String email;
  final String username;
  final int level;
  final int totalXP;
  final List<String> friends;
  final List<String> khatmsJoined;
  final Map<String, int> readingStats;
  final DateTime createdAt;
  final DateTime? lastSeen;
  final String? photoURL;

  const AppUser({
    required this.uid,
    required this.email,
    required this.username,
    this.level = 1,
    this.totalXP = 0,
    this.friends = const [],
    this.khatmsJoined = const [],
    this.readingStats = const {},
    required this.createdAt,
    this.lastSeen,
    this.photoURL,
  });

  factory AppUser.fromSupabase(Map<String, dynamic> data) {
    final rawStats = data['readingStats'];
    Map<String, int> parsedStats = {};
    if (rawStats is Map) {
      parsedStats = rawStats.map((k, v) => MapEntry(k.toString(), (v as num).toInt()));
    }

    return AppUser(
      uid: data['doc_id'] ?? '',
      email: data['email'] ?? '',
      username: data['username'] ?? '',
      level: data['level'] ?? 1,
      totalXP: data['totalXP'] ?? 0,
      friends: List<String>.from(data['friends'] ?? []),
      khatmsJoined: List<String>.from(data['khatmsJoined'] ?? []),
      readingStats: parsedStats,
      createdAt: DateTime.tryParse('${data['createdAt'] ?? ''}') ?? DateTime.now(),
      lastSeen: DateTime.tryParse('${data['lastSeen'] ?? ''}'),
      photoURL: data['photoUrl'],
    );
  }

  Map<String, dynamic> toSupabase() {
    return {
      'doc_id': uid,
      'email': email,
      'username': username,
      'level': level,
      'totalXP': totalXP,
      'friends': friends,
      'khatmsJoined': khatmsJoined,
      'readingStats': readingStats,
      'createdAt': createdAt.toIso8601String(),
      'lastSeen': lastSeen?.toIso8601String(),
      'photoUrl': photoURL,
    };
  }

  AppUser copyWith({
    String? uid,
    String? email,
    String? username,
    int? level,
    int? totalXP,
    List<String>? friends,
    List<String>? khatmsJoined,
    Map<String, int>? readingStats,
    DateTime? createdAt,
    DateTime? lastSeen,
    String? photoURL,
  }) {
    return AppUser(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      username: username ?? this.username,
      level: level ?? this.level,
      totalXP: totalXP ?? this.totalXP,
      friends: friends ?? this.friends,
      khatmsJoined: khatmsJoined ?? this.khatmsJoined,
      readingStats: readingStats ?? this.readingStats,
      createdAt: createdAt ?? this.createdAt,
      lastSeen: lastSeen ?? this.lastSeen,
      photoURL: photoURL ?? this.photoURL,
    );
  }
}
