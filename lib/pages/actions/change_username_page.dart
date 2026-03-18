import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:khetmti/components/custom_button.dart';
import 'package:khetmti/components/custom_textfield.dart';
import 'package:khetmti/utils/helpers.dart';

import '../../components/introductive_component.dart';
import 'package:khetmti/components/khetmti_header.dart';
import '../../themes/main_theme.dart';

class ChangeUsernamePage extends StatefulWidget {
  const ChangeUsernamePage({super.key});

  @override
  State<ChangeUsernamePage> createState() => _ChangeUsernamePageState();
}

class _ChangeUsernamePageState extends State<ChangeUsernamePage> {
  final _oldUsernameController = TextEditingController();
  final _newUsernameController = TextEditingController();

  void changeUsername() async {
    String oldUsername = _oldUsernameController.text.trim();
    String newUsername = _newUsernameController.text.trim();

    if (oldUsername.isEmpty || newUsername.isEmpty) {
      showErrorToast("يرجى ملء جميع الحقول");
      return;
    }

    if (oldUsername == newUsername) {
      showErrorToast("إسما المستخــدم الجــديد و القــديم متطـابقـان");
      return;
    }

    if (newUsername.length < 3) {
      showErrorToast("إسم المستخــدم الجــديد قصير");
      return;
    }

    final auth = FirebaseAuth.instance;
    final currentUsername = auth.currentUser!.displayName;
    if (currentUsername != null && currentUsername != oldUsername) {
      showErrorToast("إسم المستخــدم القديـــم غير صحيح");
      return;
    }

    try {
      showLoadingDialog(context);
      final currentUser = auth.currentUser!;
      await currentUser.updateDisplayName(newUsername);

      await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser.uid)
          .update({'username': newUsername});

      if (mounted) dismissLoadingDialog(context);
      showSuccessToast("تم تـــغيير إسم المستخــدم بنجـــاح");

      _newUsernameController.clear();
      _oldUsernameController.clear();
    } catch (e) {
      if (mounted) dismissLoadingDialog(context);
      showErrorToast("حدث خطأ أثناء العملية");
    }
  }

  @override
  void dispose() {
    _oldUsernameController.dispose();
    _newUsernameController.dispose();
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
            title: "تغيــــر الإسم",
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
                    fieldController: _oldUsernameController,
                    fieldTitle: "إســـم المـــستخدم القـــديم",
                    inArabic: true,
                    isPassword: false,
                    onlyNumber: false,
                  ),
                  const SizedBox(height: 20),
                  CustomTextfield(
                    fieldController: _newUsernameController,
                    fieldTitle: "إســـم المـــستخدم الجـــديد",
                    inArabic: true,
                    isPassword: false,
                    onlyNumber: false,
                  ),
                  const SizedBox(height: 30),
                  GestureDetector(
                    onTap: changeUsername,
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
