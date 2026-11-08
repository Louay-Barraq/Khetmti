import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:khetmti/features/auth/providers/auth_provider.dart';
import 'package:khetmti/shared/widgets/custom_button.dart';
import 'package:khetmti/shared/widgets/custom_textfield.dart';
import 'package:khetmti/shared/widgets/top_page_box.dart';
import 'package:khetmti/core/utils/helpers.dart';

class RegisterPage extends ConsumerStatefulWidget {
  const RegisterPage({super.key});

  @override
  ConsumerState<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends ConsumerState<RegisterPage> {
  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  void register() async {
    if (usernameController.text.trim().length < minUsernameLength) {
      showErrorToast('يجب أن يتكون طول اسم المستخدم من $minUsernameLength أحرف على الأقل');
      return;
    }

    if (!isValidEmail(emailController.text.trim())) {
      showErrorToast('عنوان البريد الإلكتروني غير صالح');
      return;
    }

    try {
      showLoadingDialog(context);
      var userCredential = await ref.read(authRepositoryProvider).signUp(
        email: emailController.text.trim(),
        username: usernameController.text.trim(),
        password: passwordController.text,
      );

      if (!mounted) return;
      dismissLoadingDialog(context);

      if (userCredential != null) {
        // Router redirect handles navigation to /home when auth state updates
      }
    } catch (e) {
      debugPrint('Error: $e');
      if (mounted) dismissLoadingDialog(context);
    }
  }

  @override
  void dispose() {
    usernameController.dispose();
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
                  "إنشاء حساب جديد",
                  style: TextStyle(
                    fontFamily: 'Amiri',
                    fontWeight: FontWeight.bold,
                    fontSize: 36,
                  ),
                ),
              ),
              const Center(
                child: Text(
                  "(لـــيس لـــديك حســـاب)",
                  style: TextStyle(
                    fontFamily: 'Amiri',
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                  ),
                ),
              ),
              const SizedBox(height: 15),
              CustomTextfield(
                fieldController: usernameController,
                fieldTitle: "الإسم و اللقب : ( بالعربية ) ",
                inArabic: true,
                isPassword: false,
                onlyNumber: false,
              ),
              const SizedBox(height: 20),
              CustomTextfield(
                fieldController: emailController,
                fieldTitle: " : البريد الإلكتروني",
                inArabic: false,
                isPassword: false,
                onlyNumber: false,
              ),
              const SizedBox(height: 20),
              CustomTextfield(
                fieldController: passwordController,
                fieldTitle: " : كلمة السر",
                inArabic: false,
                isPassword: true,
                onlyNumber: false,
              ),
              const SizedBox(height: 20),
              Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: register,
                  borderRadius: BorderRadius.circular(30),
                  child: const CustomButton(text: "إنشاء حساب"),
                ),
              ),
              const SizedBox(height: 18),
              Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    context.push('/login');
                  },
                  borderRadius: BorderRadius.circular(10),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.0),
                    child: Center(
                      child: Text(
                        'لديك حساب ؟ أنقر هنا',
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
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
