import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:khetmti/auth/auth_service.dart';
import 'package:khetmti/components/custom_button.dart';
import 'package:khetmti/components/custom_textfield.dart';
import 'package:khetmti/utils/helpers.dart';

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

  Future<void> updateEmailInFirestore(String userId, String newEmail) async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .update({'email': newEmail});
    } catch (e) {
      debugPrint('Error updating email in Firestore: $e');
    }
  }

  Future<void> checkEmailVerificationAndUpdateFirestore() async {
    final auth = FirebaseAuth.instance;
    await auth.currentUser?.reload();
    final user = auth.currentUser;
    if (user == null) return;

    final userData = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();

    if (userData.data()?['emailUpdated'] == true) {
      if (user.emailVerified) {
        await updateEmailInFirestore(user.uid, user.email!);
      } else {
        showWarningToast('يرجى التحقق من الإيميل ثم تسجيل الدخول مرة أخرى.');

        await FirebaseAuth.instance.signOut();
        await Future.delayed(const Duration(seconds: 2));
        if (!mounted) return;
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const LoginPage()),
          (route) => false,
        );
      }
    }
  }

  void login() async {
    if (!isValidEmail(emailController.text.trim())) {
      showErrorToast('عنوان البريد الإلكتروني غير صالح');
      return;
    }

    try {
      showLoadingDialog(context);
      var userCredential = await _authService.signInWithEmailAndPwd(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      if (!mounted) return;
      dismissLoadingDialog(context);

      if (userCredential != null) {
        emailController.clear();
        passwordController.clear();
        await checkEmailVerificationAndUpdateFirestore();

        await Future.delayed(const Duration(seconds: 1));
        if (!mounted) return;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const IndexPage()),
        );
      }
    } catch (e) {
      debugPrint('Error: $e');
      if (mounted) dismissLoadingDialog(context);
    }
  }

  void resetPassword() async {
    final email = emailController.text.trim();
    if (email.isEmpty) {
      showErrorToast('يرجى إدخال البريد الإلكتروني أولاً');
      return;
    }
    if (!isValidEmail(email)) {
      showErrorToast('عنوان البريد الإلكتروني غير صالح');
      return;
    }

    try {
      showLoadingDialog(context);
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      if (mounted) dismissLoadingDialog(context);
      showSuccessToast('تم إرسال رابط إعادة تعيين كلمة السر إلى بريدك الإلكتروني');
    } catch (e) {
      if (mounted) dismissLoadingDialog(context);
      showErrorToast('حدث خطأ أثناء إرسال الرابط: $e');
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
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
              const TopPageBox(),
              const SizedBox(height: 15),
              const Center(
                child: Text(
                  "تسجيل الدخول",
                  style: TextStyle(
                    fontFamily: 'Amiri',
                    fontWeight: FontWeight.bold,
                    fontSize: 36,
                  ),
                ),
              ),
              const SizedBox(height: 5),
              const Center(
                child: Text(
                  "(لـــديك حســـاب)",
                  style: TextStyle(
                    fontFamily: 'Amiri',
                    fontWeight: FontWeight.bold,
                    fontSize: 25,
                  ),
                ),
              ),
              const SizedBox(height: 25),
              CustomTextfield(
                fieldController: emailController,
                fieldTitle: " : البريد الإلكتروني",
                inArabic: false,
                isPassword: false,
                onlyNumber: false,
              ),
              const SizedBox(height: 40),
              CustomTextfield(
                fieldController: passwordController,
                fieldTitle: " : كلمة السر",
                inArabic: false,
                isPassword: true,
                onlyNumber: false,
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: GestureDetector(
                    onTap: resetPassword,
                    child: const Text(
                      "نسيت كلمة السر؟",
                      style: TextStyle(
                        fontFamily: 'Amiri',
                        color: Colors.redAccent,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 50),
              Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: login,
                  borderRadius: BorderRadius.circular(30),
                  child: const CustomButton(text: "تسجيل الدخول"),
                ),
              ),
              const SizedBox(height: 20),
              Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const RegisterPage()),
                    );
                  },
                  borderRadius: BorderRadius.circular(10),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.0),
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
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
