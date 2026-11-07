import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:khetmti/features/auth/models/app_user.dart';
import 'package:khetmti/features/social/models/friendship.dart';
import 'package:khetmti/core/utils/helpers.dart';

class SocialRepository {
  final SupabaseClient _supabase;

  SocialRepository(this._supabase);

  String? get _currentUserId => _supabase.auth.currentUser?.id;

  // --- Friends List ---

  Stream<List<AppUser>> friendsStream() {
    final userId = _currentUserId;
    if (userId == null) return Stream.value([]);

    return _supabase
        .from('users')
        .stream(primaryKey: ['doc_id'])
        .eq('doc_id', userId)
        .asyncMap((rows) async {
      if (rows.isEmpty) return <AppUser>[];

      final friendIds = List<String>.from(rows.first['friends'] ?? []);
      if (friendIds.isEmpty) return <AppUser>[];

      final profiles = await _supabase
          .from('users')
          .select()
          .inFilter('doc_id', friendIds);

      return profiles.map<AppUser>(AppUser.fromSupabase).toList();
    });
  }

  // --- Friend Requests (pending friendships where current user is receiver) ---

  Stream<List<FriendRequest>> friendRequestsStream() {
    final userId = _currentUserId;
    if (userId == null) return Stream.value([]);

    return _supabase
        .from('friendships')
        .stream(primaryKey: ['doc_id'])
        .eq('receiver', userId)
        .asyncMap((rows) async {
      final pending = rows.where((r) => r['status'] == 'pending').toList();
      if (pending.isEmpty) return <FriendRequest>[];

      final senderIds = pending
          .map<String>((r) => r['sender'] as String)
          .toList();

      final profiles = await _supabase
          .from('users')
          .select()
          .inFilter('doc_id', senderIds);

      final profileMap = {for (var p in profiles) p['doc_id'] as String: p};

      return pending.map((r) {
        final sender = profileMap[r['sender']];
        return FriendRequest(
          requestId: r['doc_id'] ?? '',
          senderId: r['sender'] ?? '',
          username: sender?['username'] ?? 'Unknown',
          email: sender?['email'] ?? '',
        );
      }).toList();
    });
  }

  // --- Search Users ---

  Future<List<FriendSearchResult>> searchUsers(String query) async {
    if (query.isEmpty) return [];

    final currentUserId = _currentUserId;

    final users = await _supabase
        .from('users')
        .select()
        .ilike('username', '%$query%')
        .limit(20);

    if (currentUserId == null) {
      return users.map((u) => FriendSearchResult(
        uid: u['doc_id'] ?? '',
        username: u['username'] ?? '',
        email: u['email'] ?? '',
      )).toList();
    }

    // Get user's friends list
    final currentUserRow = await _supabase
        .from('users')
        .select('friends')
        .eq('doc_id', currentUserId)
        .single();
    final friendIds = Set<String>.from(currentUserRow['friends'] ?? []);

    // Get pending requests sent by current user
    final sentRequests = await _supabase
        .from('friendships')
        .select('receiver')
        .eq('sender', currentUserId)
        .eq('status', 'pending');
    final sentIds = sentRequests
        .map<String>((r) => r['receiver'] as String)
        .toSet();

    // Get pending requests received by current user
    final receivedRequests = await _supabase
        .from('friendships')
        .select('sender')
        .eq('receiver', currentUserId)
        .eq('status', 'pending');
    final receivedIds = receivedRequests
        .map<String>((r) => r['sender'] as String)
        .toSet();

    final results = <FriendSearchResult>[];
    for (final u in users) {
      final uid = u['doc_id'] as String;
      if (uid == currentUserId) continue;

      FriendshipStatus status = FriendshipStatus.none;
      if (friendIds.contains(uid)) {
        status = FriendshipStatus.friends;
      } else if (sentIds.contains(uid)) {
        status = FriendshipStatus.pending;
      } else if (receivedIds.contains(uid)) {
        status = FriendshipStatus.received;
      }

      results.add(FriendSearchResult(
        uid: uid,
        username: u['username'] ?? '',
        email: u['email'] ?? '',
        status: status,
      ));
    }

    return results;
  }

  // --- Send Friend Request ---

  Future<void> sendFriendRequest(String friendUid) async {
    try {
      final docId = _generateDocId();
      await _supabase.from('friendships').insert({
        'doc_id': docId,
        'sender': _currentUserId,
        'receiver': friendUid,
        'status': 'pending',
        'timestamp': DateTime.now().toIso8601String(),
      });
      showSuccessToast('تم إرسال طلب الصداقة!');
    } catch (e) {
      debugPrint('Error sending friend request: $e');
      showErrorToast('حدث خطأ أثناء إرسال الطلب');
    }
  }

  // --- Cancel Friend Request ---

  Future<void> cancelFriendRequest(String friendUid) async {
    try {
      await _supabase
          .from('friendships')
          .delete()
          .eq('sender', _currentUserId!)
          .eq('receiver', friendUid)
          .eq('status', 'pending');
      showErrorToast('تم إلغاء طلب الصداقة!');
    } catch (e) {
      debugPrint('Error removing friend request: $e');
    }
  }

  // --- Accept Friend Request ---

  Future<void> acceptFriendRequest(String requestId, String senderId) async {
    final userId = _currentUserId!;
    try {
      // Update friendship status to accepted
      await _supabase
          .from('friendships')
          .update({'status': 'accepted'})
          .eq('doc_id', requestId);

      // Add each user to the other's friends array
      final senderRow = await _supabase
          .from('users')
          .select('friends')
          .eq('doc_id', senderId)
          .single();
      final receiverRow = await _supabase
          .from('users')
          .select('friends')
          .eq('doc_id', userId)
          .single();

      final senderFriends = List<String>.from(senderRow['friends'] ?? []);
      final receiverFriends = List<String>.from(receiverRow['friends'] ?? []);

      if (!senderFriends.contains(userId)) senderFriends.add(userId);
      if (!receiverFriends.contains(senderId)) receiverFriends.add(senderId);

      await _supabase
          .from('users')
          .update({'friends': senderFriends})
          .eq('doc_id', senderId);
      await _supabase
          .from('users')
          .update({'friends': receiverFriends})
          .eq('doc_id', userId);

      showSuccessToast("تم قبول طلب الصداقة بنجاح");
    } catch (e) {
      debugPrint("Error accepting friend request: $e");
      showErrorToast("حدث خطأ أثناء قبول الطلب");
    }
  }

  // --- Decline Friend Request ---

  Future<void> declineFriendRequest(String requestId) async {
    try {
      await _supabase
          .from('friendships')
          .delete()
          .eq('doc_id', requestId);
      showSuccessToast("تم رفض طلب الصداقة");
    } catch (e) {
      debugPrint("Error declining friend request: $e");
      showErrorToast("حدث خطأ أثناء رفض الطلب");
    }
  }

  // --- Unfriend ---

  Future<void> unfriend(String friendUid) async {
    final userId = _currentUserId;
    if (userId == null) return;

    try {
      // Remove from both users' friends arrays
      final userRow = await _supabase
          .from('users')
          .select('friends')
          .eq('doc_id', userId)
          .single();
      final friendRow = await _supabase
          .from('users')
          .select('friends')
          .eq('doc_id', friendUid)
          .single();

      final userFriends = List<String>.from(userRow['friends'] ?? []);
      final friendFriends = List<String>.from(friendRow['friends'] ?? []);

      userFriends.remove(friendUid);
      friendFriends.remove(userId);

      await _supabase
          .from('users')
          .update({'friends': userFriends})
          .eq('doc_id', userId);
      await _supabase
          .from('users')
          .update({'friends': friendFriends})
          .eq('doc_id', friendUid);

      // Delete the friendship record (either direction)
      await _supabase
          .from('friendships')
          .delete()
          .or('and(sender.eq.$userId,receiver.eq.$friendUid),and(sender.eq.$friendUid,receiver.eq.$userId)');
    } catch (e) {
      debugPrint("Error unfriending: $e");
    }
  }

  String _generateDocId() {
    const chars = 'abcdefghijklmnopqrstuvwxyz0123456789';
    final random = Random();
    return List.generate(20, (_) => chars[random.nextInt(chars.length)]).join();
  }
}
