import 'package:khetmti/core/utils/helpers.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SettingsRepository {
  final SupabaseClient _supabase;

  SettingsRepository(this._supabase);

  User? get _currentUser => _supabase.auth.currentUser;

  Future<void> changeUsername({
    required String oldUsername,
    required String newUsername,
  }) async {
    if (oldUsername.isEmpty || newUsername.isEmpty) {
      showErrorToast('يرجى ملء جميع الحقول');
      return;
    }
    if (oldUsername == newUsername) {
      showErrorToast('إسما المستخــدم الجــديد و القــديم متطـابقـان');
      return;
    }
    if (newUsername.length < 3) {
      showErrorToast('إسم المستخــدم الجــديد قصير');
      return;
    }

    final user = _currentUser;
    if (user == null) return;

    final currentProfile = await _supabase
        .from('users')
        .select('username')
        .eq('doc_id', user.id)
        .maybeSingle();
    final currentUsername =
        currentProfile?['username'] as String? ??
        user.userMetadata?['username'] as String?;

    if (currentUsername != null && currentUsername != oldUsername) {
      showErrorToast('إسم المستخــدم القديـــم غير صحيح');
      return;
    }

    await _supabase.auth.updateUser(
      UserAttributes(data: {'username': newUsername}),
    );
    await _supabase.from('users').update({
      'username': newUsername,
    }).eq('doc_id', user.id);

    showSuccessToast('تم تـــغيير إسم المستخــدم بنجـــاح');
  }

  Future<void> changeEmail({
    required String newEmail,
  }) async {
    await _supabase.auth.updateUser(UserAttributes(email: newEmail));
    final userId = _currentUser?.id;
    if (userId != null) {
      await _supabase.from('users').update({
        'email': newEmail,
        'emailUpdated': true,
      }).eq('doc_id', userId);
    }

    showSuccessToast(
      'تم إرسال رابط التحقق إلى $newEmail. يرجى التحقق من بريدك الإلكتروني.',
    );
  }

  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    await _supabase.auth.updateUser(UserAttributes(password: newPassword));
    showSuccessToast('تم تغيير كلمة السر بنجاح');
  }
}
