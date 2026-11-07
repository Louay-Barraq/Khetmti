import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:khetmti/features/auth/models/app_user.dart';
import 'package:khetmti/features/social/models/friendship.dart';
import 'package:khetmti/core/utils/helpers.dart';

/// Columns other users may see. Never select '*' for other people's profiles.
const _profileColumns = 'doc_id, username, "totalXP", "readingStats", "createdAt", "lastSeen"';

/// Friends are the accepted rows of `friendships`; the database only returns
/// rows where the current user is the sender or the receiver.
class SocialRepository {
  final SupabaseClient _supabase;

  SocialRepository(this._supabase);

  String? get _currentUserId => _supabase.auth.currentUser?.id;

  // --- Friends List ---

  Stream<List<AppUser>> friendsStream() {
    final userId = _currentUserId;
    if (userId == null) return Stream.value([]);

    return _supabase
        .from('friendships')
        .stream(primaryKey: ['doc_id'])
        .eq('status', 'accepted')
        .asyncMap((rows) async {
      final friendIds = [
        for (final r in rows)
          if (r['sender'] == userId) r['receiver'] as String else r['sender'] as String,
      ];
      if (friendIds.isEmpty) return <AppUser>[];

      final profiles = await _supabase
          .from('users')
          .select(_profileColumns)
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

      final profiles = await _supabase
          .from('users')
          .select(_profileColumns)
          .inFilter('doc_id', [for (final r in pending) r['sender'] as String]);
      final profileMap = {
        for (final p in profiles) p['doc_id'] as String: AppUser.fromSupabase(p),
      };

      return [
        for (final r in pending)
          FriendRequest(
            requestId: r['doc_id'] as String,
            senderId: r['sender'] as String,
            username: profileMap[r['sender']]?.username ?? 'Unknown',
            level: profileMap[r['sender']]?.level ?? 1,
          ),
      ];
    });
  }

  // --- Search Users ---

  Future<List<FriendSearchResult>> searchUsers(String query) async {
    final userId = _currentUserId;
    if (query.isEmpty || userId == null) return [];

    final users = await _supabase
        .from('users')
        .select(_profileColumns)
        .ilike('username', '%$query%')
        .neq('doc_id', userId)
        .limit(20);

    // All of the current user's friendships (the database filters to them).
    final friendships =
        await _supabase.from('friendships').select('doc_id, sender, receiver, status');
    final byOtherUser = {
      for (final f in friendships)
        (f['sender'] == userId ? f['receiver'] : f['sender']) as String: f,
    };

    return [
      for (final u in users.map(AppUser.fromSupabase))
        FriendSearchResult(
          uid: u.uid,
          username: u.username,
          level: u.level,
          requestId: byOtherUser[u.uid]?['doc_id'] as String?,
          status: switch (byOtherUser[u.uid]) {
            null => FriendshipStatus.none,
            {'status': 'accepted'} => FriendshipStatus.friends,
            {'sender': final String s} when s == userId => FriendshipStatus.pending,
            _ => FriendshipStatus.received,
          },
        ),
    ];
  }

  // --- Send Friend Request ---

  Future<void> sendFriendRequest(String friendUid) async {
    try {
      await _supabase.from('friendships').insert({
        'sender': _currentUserId,
        'receiver': friendUid,
      });
      showSuccessToast('تم إرسال طلب الصداقة!');
    } on PostgrestException catch (e) {
      // 23505: a request between these two users already exists.
      showErrorToast(e.code == '23505'
          ? 'يوجد طلب صداقة بينكما بالفعل'
          : 'حدث خطأ أثناء إرسال الطلب');
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
      showSuccessToast('تم إلغاء طلب الصداقة!');
    } catch (e) {
      debugPrint('Error removing friend request: $e');
      showErrorToast('حدث خطأ أثناء إلغاء الطلب');
    }
  }

  // --- Accept Friend Request ---

  Future<void> acceptFriendRequest(String requestId) async {
    try {
      await _supabase
          .from('friendships')
          .update({'status': 'accepted'})
          .eq('doc_id', requestId);
      showSuccessToast("تم قبول طلب الصداقة بنجاح");
    } catch (e) {
      debugPrint("Error accepting friend request: $e");
      showErrorToast("حدث خطأ أثناء قبول الطلب");
    }
  }

  // --- Decline Friend Request ---

  Future<void> declineFriendRequest(String requestId) async {
    try {
      await _supabase.from('friendships').delete().eq('doc_id', requestId);
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
      await _supabase.from('friendships').delete().or(
          'and(sender.eq.$userId,receiver.eq.$friendUid),and(sender.eq.$friendUid,receiver.eq.$userId)');
    } catch (e) {
      debugPrint("Error unfriending: $e");
      showErrorToast("حدث خطأ أثناء إزالة الصديق");
    }
  }
}
