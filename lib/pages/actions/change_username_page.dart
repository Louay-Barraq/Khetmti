// ignore_for_file: prefer_const_literals_to_create_immutables, avoid_print, no_leading_underscores_for_local_identifiers

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:khetmti/components/custom_button.dart';
import 'package:khetmti/components/custom_textfield.dart';

import '../../components/introductive_component.dart';
import '../../themes/main_theme.dart';

class ChangeUsernamePage extends StatefulWidget {
  const ChangeUsernamePage({super.key});

  @override
  State<ChangeUsernamePage> createState() => _ChangeUsernamePageState();
}

class _ChangeUsernamePageState extends State<ChangeUsernamePage> {
  final _oldUsernameController = TextEditingController();
  final _newUsernameController = TextEditingController();

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

  void changeUsername() async {
    String oldUsername = _oldUsernameController.text.trim();
    String newUsername = _newUsernameController.text.trim();

    if (oldUsername.isEmpty || newUsername.isEmpty) {
      Fluttertoast.showToast(
        msg: "يرجى ملء جميع الحقول",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.SNACKBAR,
        backgroundColor: Colors.redAccent,
        textColor: Colors.white,
      );
      return;
    }

    if (oldUsername == newUsername) {
      Fluttertoast.showToast(
        msg: "إسما المستخــدم الجــديد و القــديم متطـابقـان",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.SNACKBAR,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
      return;
    }

    if (newUsername.length < 3) {
      Fluttertoast.showToast(
        msg: "إسم المستخــدم الجــديد قصير",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.SNACKBAR,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
      return;
    }

    final auth = FirebaseAuth.instance;

    final currentUsername = auth.currentUser!.displayName;
    if (currentUsername != null && currentUsername != oldUsername) {
      print("Username C: $currentUsername}");
      print("Username N: $newUsername}");
      Fluttertoast.showToast(
        msg: "إسم المستخــدم القديـــم غير صحيح",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.SNACKBAR,
        backgroundColor: Colors.redAccent,
        textColor: Colors.white,
      );
      return;
    }

    try {
      showLoadingDialog();
      final _currentUser = auth.currentUser;
      await _currentUser!.updateDisplayName(newUsername);

      await FirebaseFirestore.instance
          .collection('users')
          .doc(_currentUser.uid)
          .update({'username': newUsername});

      dismissLoadingDialog();
      Fluttertoast.showToast(
        msg: "تم تـــغيير إسم المستخــدم بنجـــاح",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.SNACKBAR,
        backgroundColor: Colors.green,
        textColor: Colors.white,
      );

      _newUsernameController.clear();
      _oldUsernameController.clear();
    } catch (e) {
      dismissLoadingDialog();
      Fluttertoast.showToast(
        msg: "حدث خطأ أثناء العملية",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.SNACKBAR,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    }
  }

  @override
  void dispose() {
    super.dispose();
    _oldUsernameController.dispose();
    _newUsernameController.dispose();
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
                  child: IntroductiveComponent(text: "تغيــــر إسم المستخدم")),
              SizedBox(height: 20),
              CustomTextfield(
                  fieldController: _oldUsernameController,
                  fieldTitle: "إســـم المـــستخدم القـــديم",
                  inArabic: true,
                  isPassword: false,
                  onlyNumber: false),
              SizedBox(height: 20),
              CustomTextfield(
                  fieldController: _newUsernameController,
                  fieldTitle: "إســـم المـــستخدم الجـــديد",
                  inArabic: true,
                  isPassword: false,
                  onlyNumber: false),
              SizedBox(height: 20),
              GestureDetector(
                  onTap: () => changeUsername(),
                  child: CustomButton(text: "تـــغيير")),
            ],
          ),
        ),
      ),
    );
  }
}
