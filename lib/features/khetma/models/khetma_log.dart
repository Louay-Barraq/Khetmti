class KhetmaLog {
  final String username;
  final String uid;
  final String part;
  final String action;
  final DateTime timestamp;

  const KhetmaLog({
    required this.username,
    required this.uid,
    required this.part,
    required this.action,
    required this.timestamp,
  });

  factory KhetmaLog.fromMap(Map<String, dynamic> data) {
    return KhetmaLog(
      username: data['username'] ?? 'Unknown',
      uid: data['uid'] ?? '',
      part: data['part'] ?? '',
      action: data['action'] ?? '',
      timestamp: DateTime.tryParse('${data['timestamp'] ?? ''}') ?? DateTime.now(),
    );
  }
}
