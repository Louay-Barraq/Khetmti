import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:khetmti/utils/helpers.dart';
import '../../components/custom_button.dart';
import '../../components/custom_textfield.dart';
import '../../components/introductive_component.dart';
import 'package:khetmti/components/khetmti_header.dart';
import '../../themes/main_theme.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final _oldPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();

  void changePassword() async {
    String oldPassword = _oldPasswordController.text.trim();
    String newPassword = _newPasswordController.text.trim();

    if (newPassword.isEmpty || oldPassword.isEmpty) {
      showErrorToast("يرجى ملء جميع الحقول");
      return;
    }

    if (oldPassword == newPassword) {
      showErrorToast("كلمتا الســـر الجــديدة و القــديمة متطـابقتـان");
      return;
    }

    if (newPassword.length < 7) {
      showErrorToast("كلمة الســـر الجــديدة قصيرة");
      return;
    }

    final auth = FirebaseAuth.instance;
    User? user = auth.currentUser;

    try {
      showLoadingDialog(context);
      AuthCredential credential = EmailAuthProvider.credential(
        email: user!.email!,
        password: oldPassword,
      );

      try {
        await user.reauthenticateWithCredential(credential);
      } catch (e) {
        if (mounted) dismissLoadingDialog(context);
        showErrorToast("كلمة السر القديمة غير صحيحة");
        _oldPasswordController.clear();
        return;
      }
      await user.updatePassword(newPassword);

      if (mounted) dismissLoadingDialog(context);
      showSuccessToast("تم تغيير كلمة السر بنجاح");

      _newPasswordController.clear();
      _oldPasswordController.clear();
    } catch (e) {
      if (mounted) dismissLoadingDialog(context);
      showErrorToast("حدث خطأ أثناء العملية");
    }
  }

  @override
  void dispose() {
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
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
            title: "تغيــــر كلمة السر",
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
                    fieldController: _oldPasswordController,
                    fieldTitle: "كلمة السر القـــديمة",
                    inArabic: false,
                    isPassword: true,
                    onlyNumber: false,
                  ),
                  const SizedBox(height: 20),
                  CustomTextfield(
                    fieldController: _newPasswordController,
                    fieldTitle: "كلمة السر الجـــديدة",
                    inArabic: false,
                    isPassword: true,
                    onlyNumber: false,
                  ),
                  const SizedBox(height: 30),
                  GestureDetector(
                    onTap: changePassword,
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
