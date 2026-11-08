import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:khetmti/features/auth/providers/auth_provider.dart';
import 'package:khetmti/shared/widgets/custom_button.dart';
import 'package:khetmti/shared/widgets/custom_textfield.dart';
import 'package:khetmti/shared/widgets/top_page_box.dart';
import 'package:khetmti/core/utils/helpers.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  void login() async {
    if (!isValidEmail(emailController.text.trim())) {
      showErrorToast('عنوان البريد الإلكتروني غير صالح');
      return;
    }

    try {
      showLoadingDialog(context);
      final authRepository = ref.read(authRepositoryProvider);
      var userCredential = await authRepository.signIn(
        email: emailController.text.trim(),
        password: passwordController.text,
      );

      if (!mounted) return;
      dismissLoadingDialog(context);

      if (userCredential != null) {
        emailController.clear();
        passwordController.clear();
        // Router redirect handles navigation to /home when auth state updates
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
      await ref.read(authRepositoryProvider).resetPassword(email);
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
                    context.push('/register');
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
