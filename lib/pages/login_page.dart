// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:khetmti/auth/auth_service.dart';
import 'package:khetmti/components/custom_authentication_button.dart';
import 'package:khetmti/components/custom_authentication_textfield.dart';
import 'package:khetmti/pages/register_page.dart';
import 'package:khetmti/themes/main_theme.dart';

import '../components/top_page_box.dart';
import 'index_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
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

  void login() async {
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
      var userCredential = await _authService.signInWithEmailAndPwd(
          email: emailController.text.trim(),
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
              SizedBox(height: 25),
              Center(
                child: Text(
                  "تسجيل الدخول",
                  style: TextStyle(
                    fontFamily: 'Amiri',
                    fontWeight: FontWeight.bold,
                    fontSize: 36,
                  ),
                ),
              ),
              SizedBox(height: 25),
              CustomAuthenticationTextfield(
                fieldController: emailController,
                fieldTitle: " : البريد الإلكتروني",
                inArabic: false,
                isPassword: false,
              ),
              SizedBox(height: 40),
              CustomAuthenticationTextfield(
                  fieldController: passwordController,
                  fieldTitle: " : كلمة السر",
                  inArabic: false,
                  isPassword: true),
              SizedBox(height: 50),
              GestureDetector(
                  onTap: () {
                    login();
                  },
                  child: CustomAuthenticationButton(text: "تسجيل الدخول")),
              SizedBox(height: 20),
              GestureDetector(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => RegisterPage()));
                },
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
            ],
          ),
        ),
      ),
    );
  }
}
