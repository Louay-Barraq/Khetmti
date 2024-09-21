// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:khetmti/pages/authentication/login_page.dart';

import '../../components/custom_button.dart';
import '../../components/custom_textfield.dart';
import '../../components/introductive_component.dart';
import '../../themes/main_theme.dart';

class ChangeEmailPage extends StatefulWidget {
  const ChangeEmailPage({super.key});

  @override
  State<ChangeEmailPage> createState() => _ChangeEmailPageState();
}

class _ChangeEmailPageState extends State<ChangeEmailPage> {
  final _oldEmailController = TextEditingController();
  final _newEmailController = TextEditingController();

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

  bool isValidEmail(String email) {
    final RegExp emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    return emailRegex.hasMatch(email);
  }

  void changeEmail() async {
    String oldEmail = _oldEmailController.text.trim();
    String newEmail = _newEmailController.text.trim();

    if (oldEmail.isEmpty || newEmail.isEmpty) {
      Fluttertoast.showToast(
        msg: "يرجى ملء جميع الحقول",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.SNACKBAR,
        backgroundColor: Colors.redAccent,
        textColor: Colors.white,
      );
      return;
    }

    if (isValidEmail(oldEmail) == false) {
      Fluttertoast.showToast(
        msg: "البريد الإلكتروني القــديم غير صالح",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.SNACKBAR,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
      return;
    }

    if (isValidEmail(newEmail) == false) {
      Fluttertoast.showToast(
        msg: "البريد الإلكتروني الجــديد غير صالح",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.SNACKBAR,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
      return;
    }

    if (oldEmail == newEmail) {
      Fluttertoast.showToast(
        msg: "البـــريدان الإلكترونيـــان الجــديد و القــديم متطـابقـان",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.SNACKBAR,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
      return;
    }

    final auth = FirebaseAuth.instance;

    final currentEmail = auth.currentUser!.email;
    if (currentEmail != null && currentEmail != oldEmail) {
      Fluttertoast.showToast(
        msg: "البريد الإلكتروني القديـــم غير صحيح",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.SNACKBAR,
        backgroundColor: Colors.redAccent,
        textColor: Colors.white,
      );
      return;
    }

    try {
      showLoadingDialog();
      final _currentUser = FirebaseAuth.instance.currentUser!;
      await _currentUser.verifyBeforeUpdateEmail(newEmail);

      await FirebaseFirestore.instance
          .collection('users')
          .doc(_currentUser.uid)
          .update({'emailUpdated': true});

      dismissLoadingDialog();
      Fluttertoast.showToast(
        msg: 'تم إرسال بريد إلكتروني للتحقق.',
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.SNACKBAR,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 17.0,
      );
      await Future.delayed(Duration(seconds: 4));
      Fluttertoast.showToast(
        msg: 'يرجى التحقق وتسجيل الدخول مرة أخرى.',
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.SNACKBAR,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 17.0,
      );

      await FirebaseAuth.instance.signOut();
      await Future.delayed(Duration(seconds: 2));
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => LoginPage()),
        (route) => false,
      );
    } catch (e) {
      dismissLoadingDialog();
      print(e);
    }
  }

  @override
  void dispose() {
    super.dispose();
    _oldEmailController.dispose();
    _newEmailController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: MainTheme.primaryColor,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "ختمتـــــــي",
          style: TextStyle(
            fontFamily: 'Amiri',
            fontWeight: FontWeight.bold,
            fontSize: 28,
            color: Colors.white,
            shadows: const [
              Shadow(
                offset: Offset(0, 4),
                blurRadius: 2.5,
                color: Color(0x3F000000),
              ),
            ],
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 20),
              Center(
                  child: IntroductiveComponent(
                      text: "تغيــــر البريد الإلكتروني")),
              SizedBox(height: 20),
              CustomTextfield(
                  fieldController: _oldEmailController,
                  fieldTitle: "البريــد الإلكتروني القـــديم",
                  inArabic: false,
                  isPassword: false,
                  onlyNumber: false),
              SizedBox(height: 20),
              CustomTextfield(
                  fieldController: _newEmailController,
                  fieldTitle: "البريــد الإلكتروني الجـــديد",
                  inArabic: false,
                  isPassword: false,
                  onlyNumber: false),
              SizedBox(height: 20),
              GestureDetector(
                  onTap: () => changeEmail(),
                  child: CustomButton(text: "تـــغيير")),
            ],
          ),
        ),
      ),
    );
  }
}
