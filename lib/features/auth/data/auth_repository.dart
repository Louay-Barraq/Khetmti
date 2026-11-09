import 'package:khetmti/core/cache/local_cache.dart';
import 'package:khetmti/core/config/deep_links.dart';
import 'package:khetmti/core/utils/helpers.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthRepository {
  final SupabaseClient _supabase;
  final LocalCache _cache;

  AuthRepository(this._supabase, this._cache);

  Stream<User?> authStateChanges() {
    return _supabase.auth.onAuthStateChange.map((event) => event.session?.user);
  }

  User? get currentUser => _supabase.auth.currentUser;

  /// The profile row of [uid], live.
  Stream<List<DbRow>> userRows(String uid) {
    return _supabase.from('users').stream(primaryKey: ['doc_id']).eq('doc_id', uid);
  }

  Future<AuthResponse?> signUp({
    required String email,
    required String username,
    required String password,
  }) async {
    try {
      final response = await _supabase.auth.signUp(
        email: email,
        password: password,
        data: {'username': username},
      );

      // The database creates the profile row (trigger on_auth_user_created).

      showSuccessToast('تم إنشاء الحساب بنجاح!');
      return response;
    } on AuthException catch (e) {
      _handleAuthException(e);
      return null;
    }
  }

  Future<AuthResponse?> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );
      await updateLastSeen();
      showSuccessToast('تم تسجيل الدخول بنجاح!');
      return response;
    } on AuthException catch (e) {
      _handleAuthException(e);
      return null;
    }
  }

  Future<void> signOut() async {
    try {
      await _supabase.auth.signOut();
      await _cache.clear();
      showSuccessToast('تم تسجيل الخروج بنجاح!');
    } catch (_) {
      showErrorToast('حدث خطأ أثناء تسجيل الخروج. يرجى المحاولة مرة أخرى.');
    }
  }

  /// Deletes the account and everything that belongs only to it (database
  /// function `delete_my_account`), then signs out on this device.
  Future<void> deleteAccount() async {
    await _supabase.rpc('delete_my_account');
    await _cache.clear();
    await _supabase.auth.signOut(scope: SignOutScope.local);
  }

  /// Emails a link that opens the app on the "new password" page.
  Future<void> resetPassword(String email) async {
    await _supabase.auth.resetPasswordForEmail(
      email,
      redirectTo: DeepLinks.resetPassword,
    );
  }

  /// Sets the password of the user who came back from a reset link.
  Future<void> setNewPassword(String password) async {
    await _supabase.auth.updateUser(UserAttributes(password: password));
  }

  Future<void> updateLastSeen() async {
    final user = currentUser;
    if (user == null) return;

    await _supabase.from('users').update({
      'lastSeen': DateTime.now().toIso8601String(),
    }).eq('doc_id', user.id);
  }

  void _handleAuthException(AuthException e) {
    final message = switch (e.message) {
      'Invalid login credentials' => 'البريد الإلكتروني أو كلمة السر غير صحيحة.',
      'User already registered' =>
        'عنوان البريد الإلكتروني قيد الاستخدام بالفعل بواسطة حساب آخر.',
      _ => e.message,
    };
    showErrorToast(message);
  }
}
