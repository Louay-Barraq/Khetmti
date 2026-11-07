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

      final user = response.user;
      if (user != null) {
        await _upsertProfile(user: user, username: username);
      }

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

  Future<void> checkEmailVerificationAndUpdate() async {
    final user = currentUser;
    if (user == null) return;

    final row = await _supabase
        .from('users')
        .select('emailUpdated')
        .eq('doc_id', user.id)
        .maybeSingle();

    if (row != null && row['emailUpdated'] == true) {
      await _supabase.from('users').update({
        'email': user.email ?? '',
        'emailUpdated': false,
      }).eq('doc_id', user.id);
    }
  }

  Future<Map<String, dynamic>> getUserData() async {
    final user = currentUser;
    if (user == null) throw Exception('No user logged in');

    return _supabase.from('users').select().eq('doc_id', user.id).single();
  }

  Future<void> _upsertProfile({
    required User user,
    required String username,
  }) async {
    await _supabase.from('users').upsert({
      'doc_id': user.id,
      'username': username,
      'email': user.email ?? '',
      'totalXP': 0,
      'level': 1,
      'lastSeen': DateTime.now().toIso8601String(),
      'createdAt': DateTime.now().toIso8601String(),
      'readingStats': {},
      'khatmsJoined': [],
      'friends': [],
    });
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
