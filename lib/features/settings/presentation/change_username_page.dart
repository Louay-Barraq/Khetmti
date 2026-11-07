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

class ChangeUsernamePage extends ConsumerStatefulWidget {
  const ChangeUsernamePage({super.key});

  @override
  ConsumerState<ChangeUsernamePage> createState() => _ChangeUsernamePageState();
}

class _ChangeUsernamePageState extends ConsumerState<ChangeUsernamePage> {
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

    final currentUsername = ref.read(authRepositoryProvider).currentUsername;
    if (currentUsername != null && currentUsername != oldUsername) {
      showErrorToast("إسم المستخــدم القديـــم غير صحيح");
      return;
    }

    try {
      showLoadingDialog(context);
      await ref
          .read(settingsRepositoryProvider)
          .changeUsername(newUsername: newUsername);

      if (mounted) dismissLoadingDialog(context);

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
      backgroundColor: AppTheme.backgroundColor,
      resizeToAvoidBottomInset: false,
      body: Column(
        children: [
          KhetmtiHeader(
            title: "تغيــــر الإسم",
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
