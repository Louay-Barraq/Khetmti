// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:khetmti/auth/auth_service.dart';
import 'package:khetmti/components/custom_button.dart';
import 'package:khetmti/components/custom_textfield.dart';

import '../../components/top_page_box.dart';
import '../main/index_page.dart';
import 'register_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final _authService = AuthService();

  bool isValidEmail(String email) {
    final RegExp emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    return emailRegex.hasMatch(email);
  }

  void showLoadingDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  void dismissLoadingDialog() {
    Navigator.of(context).pop();
  }

  Future<void> updateEmailInFirestore(String userId, String newEmail) async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .update({'email': newEmail});
      print('Email updated in Firestore.');
    } catch (e) {
      print('Error updating email in Firestore: $e');
    }
  }

  Future<void> checkEmailVerificationAndUpdateFirestore() async {
    final auth = FirebaseAuth.instance;
    if (auth != null) {
      await auth.currentUser?.reload();
      final user = auth.currentUser;

      print("Email Verified: ${user?.emailVerified}");
      final userData = await FirebaseFirestore.instance
          .collection('users')
          .doc(user!.uid)
          .get();
      if (userData.data()?['emailUpdated'] == true) {
        if (user.emailVerified) {
          await updateEmailInFirestore(user.uid, user.email!);
          print("updated");
        } else {
          Fluttertoast.showToast(
            msg: 'يرجى التحقق من الإيميل ثم تسجيل الدخول مرة أخرى.',
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.SNACKBAR,
            backgroundColor: Colors.green,
            textColor: Colors.white,
            fontSize: 17.0,
          );

          await FirebaseAuth.instance.signOut();
          await Future.delayed(Duration(seconds: 2));
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => LoginPage()),
            (route) => false,
          );
        }
      }
    }
  }

  void login() async {
    if (!isValidEmail(emailController.text.trim())) {
      Fluttertoast.showToast(
        msg: 'عنوان البريد الإلكتروني غير صالح',
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.SNACKBAR,
        backgroundColor: Colors.redAccent,
        textColor: Colors.white,
        fontSize: 17.0,
      );
      return;
    }

    try {
      showLoadingDialog();
      var userCredential = await _authService.signInWithEmailAndPwd(
          email: emailController.text.trim(),
          password: passwordController.text.trim());
      dismissLoadingDialog();

      if (userCredential != null) {
        emailController.clear();
        passwordController.clear();
        // After login, check if email is verified and update Firestore
        await checkEmailVerificationAndUpdateFirestore();

        await Future.delayed(Duration(seconds: 1));
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => IndexPage(),
          ),
        );
      }
    } catch (e) {
      print('Error: $e');
      dismissLoadingDialog();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TopPageBox(),
              SizedBox(height: 15),
              Center(
                child: Text(
                  "تسجيل الدخول",
                  style: TextStyle(
                    fontFamily: 'Amiri',
                    fontWeight: FontWeight.bold,
                    fontSize: 36,
                  ),
                ),
              ),
              SizedBox(height: 5),
              Center(
                child: Text(
                  "(لـــديك حســـاب)",
                  style: TextStyle(
                    fontFamily: 'Amiri',
                    fontWeight: FontWeight.bold,
                    fontSize: 25,
                  ),
                ),
              ),
              SizedBox(height: 25),
              CustomTextfield(
                fieldController: emailController,
                fieldTitle: " : البريد الإلكتروني",
                inArabic: false,
                isPassword: false,
                onlyNumber: false,
              ),
              SizedBox(height: 40),
              CustomTextfield(
                fieldController: passwordController,
                fieldTitle: " : كلمة السر",
                inArabic: false,
                isPassword: true,
                onlyNumber: false,
              ),
              SizedBox(height: 50),
              GestureDetector(
                  onTap: () {
                    login();
                  },
                  child: CustomButton(text: "تسجيل الدخول")),
              SizedBox(height: 20),
              GestureDetector(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => RegisterPage()));
                },
                child: Center(
                  child: Text(
                    'ليس لديك حساب ؟ أنقر هنا',
                    style: TextStyle(
                      fontFamily: 'Amiri',
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
