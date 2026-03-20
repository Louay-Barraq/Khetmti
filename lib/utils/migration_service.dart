import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MigrationService {
  static final _firestore = FirebaseFirestore.instance;
  static final _supabase = Supabase.instance.client;

  /// Migrates all necessary data from Firestore to Supabase.
  /// This is a "copy" operation - nothing is deleted from Firebase.
  static Future<void> migrateAll() async {
    try {
      print('Starting migration...');
      
      await _migrateProfiles();
      await _migrateKhetmas();
      await _migrateFriendships();
      await _migrateParticipants();
      
      print('Migration completed successfully!');
    } catch (e) {
      print('Migration failed: $e');
      rethrow;
    }
  }

  static Future<void> _migrateProfiles() async {
    print('Migrating profiles...');
    final snapshot = await _firestore.collection('users').get();
    
    for (var doc in snapshot.docs) {
      final data = doc.data();
      final userId = doc.id;

      try {
        final lastSeen = data['lastSeen'];
        String? lastSeenStr;
        if (lastSeen != null && lastSeen.runtimeType.toString().contains('Timestamp')) {
          lastSeenStr = (lastSeen as dynamic).toDate().toIso8601String();
        } else {
          lastSeenStr = DateTime.now().toIso8601String();
        }

        await _supabase.from('profiles').upsert({
          'id': userId,
          'name': data['username'] ?? data['displayName'] ?? 'User',
          'email': data['email'] ?? '',
          'total_xp': data['totalXP'] ?? 0,
          'last_seen': lastSeenStr,
          'created_at': DateTime.now().toIso8601String(),
        });
      } catch (e) {
        print('Failed to migrate profile $userId: $e');
      }
    }
    print('Profiles migrated: ${snapshot.docs.length}');
  }

  static Future<void> _migrateKhetmas() async {
    print('Migrating khetmas...');
    final snapshot = await _firestore.collection('khatms').get();
    
    for (var doc in snapshot.docs) {
      final data = doc.data();
      final khetmaId = doc.id;

      try {
        final createdAt = data['createdAt'];
        String? createdAtStr;
        if (createdAt != null && createdAt.runtimeType.toString().contains('Timestamp')) {
          createdAtStr = (createdAt as dynamic).toDate().toIso8601String();
        } else {
          createdAtStr = DateTime.now().toIso8601String();
        }

        await _supabase.from('khetmas').upsert({
          'id': khetmaId,
          'name': data['name'] ?? data['title'] ?? 'Khetma',
          'type': data['splitType'] ?? 'Individual',
          'creator_id': data['creatorId'],
          'completion_percent': (data['completionPercent'] ?? 0).toDouble(),
          'created_at': createdAtStr,
          'updated_at': DateTime.now().toIso8601String(),
        });
      } catch (e) {
        print('Failed to migrate khetma $khetmaId: $e');
      }
    }
    print('Khetmas migrated: ${snapshot.docs.length}');
  }

  static Future<void> _migrateFriendships() async {
    print('Migrating friendships...');
    final snapshot = await _firestore.collection('friendships').get();
    
    int count = 0;
    for (var doc in snapshot.docs) {
      final data = doc.data();
      
      if (data.containsKey('users')) {
        List users = data['users'];
        if (users.length >= 2) {
          try {
            await _supabase.from('friendships').upsert({
              'user_id': users[0],
              'friend_id': users[1],
            });
            await _supabase.from('friendships').upsert({
              'user_id': users[1],
              'friend_id': users[0],
            });
            count++;
          } catch (e) {
            print('Failed to migrate friendship: $e');
          }
        }
      }
    }
    print('Friendships migrated: $count');
  }

  static Future<void> _migrateParticipants() async {
    print('Migrating khetma participants...');
    final snapshot = await _firestore.collection('khatms').get();
    
    int count = 0;
    for (var doc in snapshot.docs) {
      final data = doc.data();
      final khetmaId = doc.id;
      final participants = data['participants'] as List? ?? [];
      
      for (var userId in participants) {
        try {
          await _supabase.from('khetma_participant_v2').upsert({
            'khetma_id': khetmaId,
            'user_id': userId,
            'progress': 0.0,
          });
          count++;
        } catch (e) {
          // Fallback to khetma_participants name
          try {
             await _supabase.from('khetma_participants').upsert({
              'khetma_id': khetmaId,
              'user_id': userId,
              'progress': 0.0,
            });
            count++;
          } catch (e2) {
            print('Failed to migrate participant $userId for $khetmaId: $e2');
          }
        }
      }
    }
    print('Participants migrated: $count');
  }
}
