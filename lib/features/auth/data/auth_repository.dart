import 'package:khetmti/core/utils/helpers.dart';
import 'package:khetmti/features/auth/models/app_user.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthRepository {
  final SupabaseClient _supabase;

  AuthRepository(this._supabase);

  Stream<User?> authStateChanges() {
    return _supabase.auth.onAuthStateChange.map((event) => event.session?.user);
  }

  User? get currentUser => _supabase.auth.currentUser;

  String? get currentUsername {
    final metadata = currentUser?.userMetadata;
    return metadata?['username'] as String? ?? metadata?['name'] as String?;
  }

  Stream<AppUser> userStream(String uid) {
    return _supabase
        .from('users')
        .stream(primaryKey: ['doc_id'])
        .eq('doc_id', uid)
        .map((rows) {
          if (rows.isEmpty) throw Exception('User not found');
          return AppUser.fromSupabase(rows.first);
        });
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
      showSuccessToast('تم تسجيل الخروج بنجاح!');
    } catch (_) {
      showErrorToast('حدث خطأ أثناء تسجيل الخروج. يرجى المحاولة مرة أخرى.');
    }
  }

  Future<void> deleteAccount() async {
    throw UnimplementedError(
      'Account deletion needs a Supabase Edge Function or admin backend.',
    );
  }

  Future<void> resetPassword(String email) async {
    await _supabase.auth.resetPasswordForEmail(email);
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
      'Invalid login credentials' => 'إحدى بيانات الاعتماد غير صالحة.',
      'User already registered' =>
        'عنوان البريد الإلكتروني قيد الاستخدام بالفعل بواسطة حساب آخر.',
      _ => e.message,
    };
    showErrorToast(message);
  }
}
