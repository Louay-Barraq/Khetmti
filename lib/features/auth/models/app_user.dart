import 'dart:math';

/// XP needed to reach [level]. Level 1 starts at 0 XP; each level needs 20% more.
int xpForLevel(int level) => (5000 * (pow(1.2, level - 1) - 1)).round();

/// The level a user with [xp] has reached.
int levelForXp(int xp) {
  var level = 1;
  while (xp >= xpForLevel(level + 1)) {
    level++;
  }
  return level;
}

class AppUser {
  final String uid;
  final String username;
  final int totalXP;
  final Map<String, int> readingStats;
  final DateTime createdAt;
  final DateTime? lastSeen;

  const AppUser({
    required this.uid,
    required this.username,
    this.totalXP = 0,
    this.readingStats = const {},
    required this.createdAt,
    this.lastSeen,
  });

  int get level => levelForXp(totalXP);

  factory AppUser.fromSupabase(Map<String, dynamic> data) {
    final rawStats = data['readingStats'];
    Map<String, int> parsedStats = {};
    if (rawStats is Map) {
      parsedStats = rawStats.map((k, v) => MapEntry(k.toString(), (v as num).toInt()));
    }

    return AppUser(
      uid: data['doc_id'] ?? '',
      username: data['username'] ?? '',
      totalXP: data['totalXP'] ?? 0,
      readingStats: parsedStats,
      createdAt: DateTime.tryParse('${data['createdAt'] ?? ''}') ?? DateTime.now(),
      lastSeen: DateTime.tryParse('${data['lastSeen'] ?? ''}'),
    );
  }
}
