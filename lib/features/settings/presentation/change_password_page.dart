import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:khetmti/core/theme/app_theme.dart';
import 'package:khetmti/core/utils/helpers.dart';
import 'package:khetmti/features/settings/providers/settings_provider.dart';
import 'package:khetmti/shared/widgets/custom_button.dart';
import 'package:khetmti/shared/widgets/custom_textfield.dart';
import 'package:khetmti/shared/widgets/khetmti_header.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ChangePasswordPage extends ConsumerStatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  ConsumerState<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends ConsumerState<ChangePasswordPage> {
  final _oldPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();

  void changePassword() async {
    String oldPassword = _oldPasswordController.text;
    String newPassword = _newPasswordController.text;

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

    try {
      showLoadingDialog(context);
      await ref.read(settingsRepositoryProvider).changePassword(
        currentPassword: oldPassword,
        newPassword: newPassword,
      );

      if (mounted) dismissLoadingDialog(context);

      _newPasswordController.clear();
      _oldPasswordController.clear();
    } on AuthException catch (e) {
      if (mounted) dismissLoadingDialog(context);
      if (e.message.toLowerCase().contains('password') ||
          e.message.toLowerCase().contains('credential')) {
        showErrorToast("كلمة السر القديمة غير صحيحة");
        _oldPasswordController.clear();
      } else {
        showErrorToast("حدث خطأ أثناء العملية");
      }
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
      backgroundColor: AppTheme.backgroundColor,
      resizeToAvoidBottomInset: false,
      body: Column(
        children: [
          KhetmtiHeader(
            title: "تغيــــر كلمة السر",
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
