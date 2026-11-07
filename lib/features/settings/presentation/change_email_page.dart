import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:khetmti/core/theme/app_theme.dart';
import 'package:khetmti/core/utils/helpers.dart';
import 'package:khetmti/features/auth/providers/auth_provider.dart';
import 'package:khetmti/features/settings/providers/settings_provider.dart';
import 'package:khetmti/shared/widgets/custom_button.dart';
import 'package:khetmti/shared/widgets/custom_textfield.dart';
import 'package:khetmti/shared/widgets/khetmti_header.dart';

class ChangeEmailPage extends ConsumerStatefulWidget {
  const ChangeEmailPage({super.key});

  @override
  ConsumerState<ChangeEmailPage> createState() => _ChangeEmailPageState();
}

class _ChangeEmailPageState extends ConsumerState<ChangeEmailPage> {
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

    final authRepo = ref.read(authRepositoryProvider);
    final currentEmail = authRepo.currentUser!.email;
    if (currentEmail != null && currentEmail != oldEmail) {
      showErrorToast("البريد الإلكتروني القديـــم غير صحيح");
      return;
    }

    try {
      showLoadingDialog(context);
      await ref.read(settingsRepositoryProvider).changeEmail(newEmail: newEmail);

      if (mounted) dismissLoadingDialog(context);
      showSuccessToast('تم إرسال بريد إلكتروني للتحقق.');
      await Future.delayed(const Duration(seconds: 4));
      showSuccessToast('يرجى التحقق وتسجيل الدخول مرة أخرى.');

      await authRepo.signOut();
      await Future.delayed(const Duration(seconds: 2));
      if (!mounted) return;
      context.go('/login');
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
      backgroundColor: AppTheme.backgroundColor,
      resizeToAvoidBottomInset: false,
      body: Column(
        children: [
          KhetmtiHeader(
            title: "تغيــــر البريد",
            showProfile: false,
            showBackButton: true,
            onBackTap: () => context.pop(),
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
