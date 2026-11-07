class KhetmaPart {
  final String status;
  final String? uid;
  final String? username;

  const KhetmaPart({
    this.status = 'available',
    this.uid,
    this.username,
  });

  factory KhetmaPart.fromMap(Map<String, dynamic> data) {
    return KhetmaPart(
      status: data['status'] ?? 'available',
      uid: data['uid'],
      username: data['username'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'status': status,
      'uid': uid,
      'username': username,
    };
  }

  bool get isAvailable => status == 'available';
  bool get isReserved => status == 'reserved';
  bool get isFinished => status == 'finished';

  KhetmaPart copyWith({
    String? status,
    String? uid,
    String? username,
  }) {
    return KhetmaPart(
      status: status ?? this.status,
      uid: uid ?? this.uid,
      username: username ?? this.username,
    );
  }
}
