import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:khetmti/utils/helpers.dart';

class AuthService {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  Future<UserCredential?> signUpWithEmailAndPwd({
    required String email,
    required String username,
    required String password,
  }) async {
    try {
      var userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await updateUsernameAndCreateUserDocument(
        user: userCredential.user!,
        username: username,
      );

      showSuccessToast('تم إنشاء الحساب بنجاح!');
      return userCredential;
    } on FirebaseAuthException catch (e) {
      _handleAuthException(e);
      return null;
    }
  }

  Future<UserCredential?> signInWithEmailAndPwd({
    required String email,
    required String password,
  }) async {
    try {
      var userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      showSuccessToast('تم تسجيل الدخول بنجاح!');
      return userCredential;
    } on FirebaseAuthException catch (e) {
      _handleAuthException(e);
      return null;
    }
  }

  Future<void> logout() async {
    try {
      await _auth.signOut();
      showSuccessToast('تم تسجيل الخروج بنجاح!');
    } catch (e) {
      showErrorToast('حدث خطأ أثناء تسجيل الخروج. يرجى المحاولة مرة أخرى.');
    }
  }

  Future<void> updateUsernameAndCreateUserDocument({
    required User user,
    required String username,
  }) async {
    try {
      await user.updateDisplayName(username);
      Map<String, dynamic> userData = {
        'uid': user.uid,
        'email': user.email,
        'username': username,
        'createdAt': Timestamp.now(),
        'updatedAt': Timestamp.now(),
        'photoURL': user.photoURL,
        'level': 1,
        'khatmsJoined': [],
        'friends': [],
      };

      await _firestore.collection('users').doc(user.uid).set(userData);
    } catch (e) {
      showErrorToast(
        'حدث خطأ أثناء إنشاء مستند المستخدم. يرجى المحاولة مرة أخرى.',
      );
    }
  }

  Future<Map<String, dynamic>> getUserData() async {
    final user = _auth.currentUser;

    if (user != null) {
      DocumentSnapshot<Map<String, dynamic>> snapshot =
          await _firestore.collection('users').doc(user.uid).get();

      if (snapshot.exists) {
        return snapshot.data()!;
      } else {
        throw Exception("User data not found");
      }
    } else {
      throw Exception("No user logged in");
    }
  }

  void _handleAuthException(FirebaseAuthException e) {
    String message;
    switch (e.code) {
      case 'invalid-email':
        message = 'عنوان البريد الإلكتروني غير صالح.';
        break;
      case 'invalid-credential':
        message = 'إحدى بيانات الاعتماد غير صالحة.';
        break;
      case 'user-disabled':
        message = 'تم تعطيل حساب المستخدم.';
        break;
      case 'user-not-found':
        message = 'لم يتم العثور على مستخدم لهذا البريد الإلكتروني.';
        break;
      case 'wrong-password':
        message = 'تم إدخال كلمة مرور خاطئة.';
        break;
      case 'email-already-in-use':
        message =
            'عنوان البريد الإلكتروني قيد الاستخدام بالفعل بواسطة حساب آخر.';
        break;
      case 'operation-not-allowed':
        message = 'لم يتم تمكين حسابات البريد الإلكتروني/كلمة المرور.';
        break;
      case 'weak-password':
        message = 'كلمة المرور ضعيفة جداً.';
        break;
      case 'network-request-failed':
        message = 'خطأ في الشبكة. يرجى المحاولة مرة أخرى لاحقًا.';
        break;
      default:
        message = e.code;
    }
    showErrorToast(message);
  }
}
