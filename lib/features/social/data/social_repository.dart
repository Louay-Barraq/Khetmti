import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:khetmti/features/auth/models/app_user.dart';
import 'package:khetmti/core/cache/local_cache.dart';
import 'package:khetmti/core/utils/helpers.dart';

/// Columns other users may see. Never select '*' for other people's profiles.
const _profileColumns = 'doc_id, username, "totalXP", "readingStats", "createdAt", "lastSeen"';

/// Friends are the accepted rows of `friendships`; the database only returns
/// rows where the current user is the sender or the receiver.
class SocialRepository {
  final SupabaseClient _supabase;

  SocialRepository(this._supabase);

  String? get _currentUserId => _supabase.auth.currentUser?.id;

  // --- Friendships ---

  /// Every friendship row of the current user (the database returns only
  /// rows where they are the sender or the receiver), live. Friends, sent
  /// and received requests all come from this one subscription.
  Stream<List<DbRow>> friendshipRows() {
    return _supabase.from('friendships').stream(primaryKey: ['doc_id']);
  }

  Future<List<DbRow>> profileRows(List<String> ids) {
    return _supabase.from('users').select(_profileColumns).inFilter('doc_id', ids);
  }

  // --- Search Users ---

  /// Profiles whose name contains [query]. The friendship state of each one
  /// is read from [friendshipRows], so no second query is needed.
  Future<List<AppUser>> searchUsers(String query) async {
    final userId = _currentUserId;
    if (query.isEmpty || userId == null) return [];

    final users = await _supabase
        .from('users')
        .select(_profileColumns)
        .ilike('username', '%$query%')
        .neq('doc_id', userId)
        .limit(20);

    return users.map(AppUser.fromSupabase).toList();
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
