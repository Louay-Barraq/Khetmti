// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AuthService {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  final _storage = FirebaseStorage.instance;

  Future<UserCredential?> signUpWithEmailAndPwd(
      {required String email,
      required String username,
      required String password}) async {
    try {
      var userCredential = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);

      await updateUsernameAndCreateUserDocument(
          user: userCredential.user!, username: username);

      Fluttertoast.showToast(
        msg: 'تم إنشاء الحساب بنجاح!',
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.SNACKBAR,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 17.0,
      );

      return userCredential;
    } on FirebaseAuthException catch (e) {
      _handleAuthException(e);
      return null;
    }
  }

  Future<UserCredential?> signInWithEmailAndPwd(
      {required String email, required String password}) async {
    try {
      var userCredential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);

      Fluttertoast.showToast(
        msg: 'تم تسجيل الدخول بنجاح!',
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.SNACKBAR,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 17.0,
      );

      return userCredential;
    } on FirebaseAuthException catch (e) {
      _handleAuthException(e);
      return null;
    }
  }

  Future<void> logout() async {
    try {
      await _auth.signOut();
      Fluttertoast.showToast(
        msg: 'تم تسجيل الخروج بنجاح!',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.SNACKBAR,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 17.0,
      );
    } catch (e) {
      Fluttertoast.showToast(
        msg: 'حدث خطأ أثناء تسجيل الخروج. يرجى المحاولة مرة أخرى.',
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.SNACKBAR,
        backgroundColor: Colors.redAccent,
        textColor: Colors.white,
        fontSize: 17.0,
      );
    }
  }

  Future<void> updateUsernameAndCreateUserDocument(
      {required User user, required String username}) async {
    try {
      await user.updateDisplayName(username);
      // the user data to be stored
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
      Fluttertoast.showToast(
        msg: 'حدث خطأ أثناء إنشاء مستند المستخدم. يرجى المحاولة مرة أخرى.',
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.SNACKBAR,
        backgroundColor: Colors.redAccent,
        textColor: Colors.white,
        fontSize: 17.0,
      );
    }
  }

  Future<Map<String, dynamic>> getUserData() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      DocumentSnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
          .instance
          .collection('users')
          .doc(user.uid)
          .get();

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
    String message = '';
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
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.SNACKBAR,
      backgroundColor: Colors.redAccent,
      textColor: Colors.white,
      fontSize: 17.0,
    );
  }
}
