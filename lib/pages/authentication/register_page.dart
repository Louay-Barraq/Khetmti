import 'package:flutter/material.dart';
import 'package:khetmti/auth/auth_service.dart';
import 'package:khetmti/pages/main/index_page.dart';
import 'package:khetmti/pages/authentication/login_page.dart';
import 'package:khetmti/utils/helpers.dart';
import '../../components/custom_button.dart';
import '../../components/custom_textfield.dart';
import '../../components/top_page_box.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final _authService = AuthService();

  void register() async {
    if (usernameController.text.trim().length < 5) {
      showErrorToast('يجب أن يتكون طول اسم المستخدم من 5 أحرف على الأقل');
      return;
    }

    if (!isValidEmail(emailController.text.trim())) {
      showErrorToast('عنوان البريد الإلكتروني غير صالح');
      return;
    }

    try {
      showLoadingDialog(context);
      var userCredential = await _authService.signUpWithEmailAndPwd(
        email: emailController.text.trim(),
        username: usernameController.text.trim(),
        password: passwordController.text.trim(),
      );

      if (!mounted) return;
      dismissLoadingDialog(context);

      if (userCredential != null) {
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
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LoginPage()),
                    );
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
