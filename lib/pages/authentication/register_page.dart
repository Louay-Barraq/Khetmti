// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:khetmti/auth/auth_service.dart';
import 'package:khetmti/pages/main/index_page.dart';
import 'package:khetmti/pages/authentication/login_page.dart';
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

  bool isValidEmail(String email) {
    final RegExp emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    return emailRegex.hasMatch(email);
  }

  void showLoadingDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  void dismissLoadingDialog() {
    Navigator.of(context).pop();
  }

  void register() async {
    if (usernameController.text.trim().length < 5) {
      Fluttertoast.showToast(
        msg: 'يجب أن يتكون طول اسم المستخدم من 5 أحرف على الأقل',
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.SNACKBAR,
        backgroundColor: Colors.redAccent,
        textColor: Colors.white,
        fontSize: 17.0,
      );
      return;
    }

    if (!isValidEmail(emailController.text.trim())) {
      Fluttertoast.showToast(
        msg: 'عنوان البريد الإلكتروني غير صالح',
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.SNACKBAR,
        backgroundColor: Colors.redAccent,
        textColor: Colors.white,
        fontSize: 17.0,
      );
      return;
    }

    try {
      showLoadingDialog();
      var userCredential = await _authService.signUpWithEmailAndPwd(
          email: emailController.text.trim(),
          username: usernameController.text.trim(),
          password: passwordController.text.trim());
      dismissLoadingDialog();
      if (userCredential != null) {
        await Future.delayed(Duration(seconds: 1));
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => IndexPage(),
          ),
        );
      }
    } catch (e) {
      print('Error: $e');
    }
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
              TopPageBox(),
              SizedBox(height: 15),
              Center(
                child: Text(
                  "إنشاء حساب جديد",
                  style: TextStyle(
                    fontFamily: 'Amiri',
                    fontWeight: FontWeight.bold,
                    fontSize: 36,
                  ),
                ),
              ),
              Center(
                child: Text(
                  "(لـــيس لـــديك حســـاب)",
                  style: TextStyle(
                    fontFamily: 'Amiri',
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                  ),
                ),
              ),
              SizedBox(height: 15),
              CustomTextfield(
                fieldController: usernameController,
                fieldTitle: "الإسم و اللقب : ( بالعربية ) ",
                inArabic: true,
                isPassword: false,
                onlyNumber: false,
              ),
              SizedBox(height: 20),
              CustomTextfield(
                fieldController: emailController,
                fieldTitle: " : البريد الإلكتروني",
                inArabic: false,
                isPassword: false,
                onlyNumber: false,
              ),
              SizedBox(height: 20),
              CustomTextfield(
                fieldController: passwordController,
                fieldTitle: " : كلمة السر",
                inArabic: false,
                isPassword: true,
                onlyNumber: false,
              ),
              SizedBox(height: 20),
              GestureDetector(
                onTap: () {
                  register();
                },
                child: CustomButton(text: "إنشاء حساب"),
              ),
              SizedBox(height: 18),
              GestureDetector(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => LoginPage()));
                },
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
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
