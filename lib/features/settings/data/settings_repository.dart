import 'package:khetmti/core/config/deep_links.dart';
import 'package:khetmti/core/utils/helpers.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Input is validated by the settings pages before these are called.
class SettingsRepository {
  final SupabaseClient _supabase;

  SettingsRepository(this._supabase);

  Future<void> changeUsername({required String newUsername}) async {
    final user = _supabase.auth.currentUser;
    if (user == null) return;

    await _supabase.auth.updateUser(
      UserAttributes(data: {'username': newUsername}),
    );
    await _supabase.from('users').update({
      'username': newUsername,
    }).eq('doc_id', user.id);

    showSuccessToast('تم تـــغيير إسم المستخــدم بنجـــاح');
  }

  /// Supabase emails a confirmation link (opening the app); the login email
  /// changes once the user clicks it.
  Future<void> changeEmail({required String newEmail}) async {
    await _supabase.auth.updateUser(
      UserAttributes(email: newEmail),
      emailRedirectTo: DeepLinks.emailChanged,
    );
  }

  /// Throws [AuthException] when [currentPassword] is wrong.
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    await _supabase.auth.signInWithPassword(
      email: _supabase.auth.currentUser!.email!,
      password: currentPassword,
    );
    await _supabase.auth.updateUser(UserAttributes(password: newPassword));
    showSuccessToast('تم تغيير كلمة السر بنجاح');
  }
}
