import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:khetmti/pages/authentication/login_page.dart';
import 'package:khetmti/utils/helpers.dart';
import '../../components/custom_button.dart';
import '../../components/custom_textfield.dart';
import '../../components/introductive_component.dart';
import 'package:khetmti/components/khetmti_header.dart';
import '../../themes/main_theme.dart';

class ChangeEmailPage extends StatefulWidget {
  const ChangeEmailPage({super.key});

  @override
  State<ChangeEmailPage> createState() => _ChangeEmailPageState();
}

class _ChangeEmailPageState extends State<ChangeEmailPage> {
  final _oldEmailController = TextEditingController();
  final _newEmailController = TextEditingController();

  void changeEmail() async {
    String oldEmail = _oldEmailController.text.trim();
    String newEmail = _newEmailController.text.trim();

    if (oldEmail.isEmpty || newEmail.isEmpty) {
      showErrorToast("يرجى ملء جميع الحقول");
      return;
    }

    if (!isValidEmail(oldEmail)) {
      showErrorToast("البريد الإلكتروني القــديم غير صالح");
      return;
    }

    if (!isValidEmail(newEmail)) {
      showErrorToast("البريد الإلكتروني الجــديد غير صالح");
      return;
    }

    if (oldEmail == newEmail) {
      showErrorToast("البـــريدان الإلكترونيـــان الجــديد و القــديم متطـابقـان");
      return;
    }

    final auth = FirebaseAuth.instance;
    final currentEmail = auth.currentUser!.email;
    if (currentEmail != null && currentEmail != oldEmail) {
      showErrorToast("البريد الإلكتروني القديـــم غير صحيح");
      return;
    }

    try {
      showLoadingDialog(context);
      final currentUser = FirebaseAuth.instance.currentUser!;
      await currentUser.verifyBeforeUpdateEmail(newEmail);

      await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser.uid)
          .update({'emailUpdated': true});

      if (mounted) dismissLoadingDialog(context);
      showSuccessToast('تم إرسال بريد إلكتروني للتحقق.');
      await Future.delayed(const Duration(seconds: 4));
      showSuccessToast('يرجى التحقق وتسجيل الدخول مرة أخرى.');

      await FirebaseAuth.instance.signOut();
      await Future.delayed(const Duration(seconds: 2));
      if (!mounted) return;
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const LoginPage()),
        (route) => false,
      );
    } catch (e) {
      if (mounted) dismissLoadingDialog(context);
      debugPrint('Error changing email: $e');
      showErrorToast("حدث خطأ أثناء تغيير البريد الإلكتروني");
    }
  }

  @override
  void dispose() {
    _oldEmailController.dispose();
    _newEmailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MainTheme.backgroundColor,
      resizeToAvoidBottomInset: false,
      body: Column(
        children: [
          KhetmtiHeader(
            title: "تغيــــر البريد",
            showProfile: false,
            showBackButton: true,
            onBackTap: () => Navigator.pop(context),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  const SizedBox(height: 30),
                  CustomTextfield(
                    fieldController: _oldEmailController,
                    fieldTitle: "البريــد الإلكتروني القـــديم",
                    inArabic: false,
                    isPassword: false,
                    onlyNumber: false,
                  ),
                  const SizedBox(height: 20),
                  CustomTextfield(
                    fieldController: _newEmailController,
                    fieldTitle: "البريــد الإلكتروني الجـــديد",
                    inArabic: false,
                    isPassword: false,
                    onlyNumber: false,
                  ),
                  const SizedBox(height: 30),
                  GestureDetector(
                    onTap: changeEmail,
                    child: const CustomButton(text: "تـــغيير"),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
