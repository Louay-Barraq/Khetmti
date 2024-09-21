import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../components/custom_button.dart';
import '../../components/custom_textfield.dart';
import '../../components/introductive_component.dart';
import '../../themes/main_theme.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final _oldPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();

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

  void changePassword() async {
    String oldPassword = _oldPasswordController.text.trim();
    String newPassword = _newPasswordController.text.trim();

    if (newPassword.isEmpty || oldPassword.isEmpty) {
      Fluttertoast.showToast(
        msg: "يرجى ملء جميع الحقول",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.SNACKBAR,
        backgroundColor: Colors.redAccent,
        textColor: Colors.white,
      );
      return;
    }

    if (oldPassword == newPassword) {
      Fluttertoast.showToast(
        msg: "كلمتا الســـر الجــديدة و القــديمة متطـابقتـان",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.SNACKBAR,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
      return;
    }

    if (newPassword.length < 7) {
      Fluttertoast.showToast(
        msg: "كلمة الســـر الجــديدة قصيرة",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.SNACKBAR,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
      return;
    }

    final auth = FirebaseAuth.instance;
    User? user = auth.currentUser;

    try {
      showLoadingDialog();
      AuthCredential credential = EmailAuthProvider.credential(
        email: user!.email!,
        password: oldPassword,
      );

      try {
        await user.reauthenticateWithCredential(credential);
      } catch (e) {
        dismissLoadingDialog();
        print(e);
        Fluttertoast.showToast(
          msg: e.toString(),
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.SNACKBAR,
          backgroundColor: Colors.green,
          textColor: Colors.white,
        );
        _oldPasswordController.clear();
        return;
      }
      await user.updatePassword(newPassword);

      dismissLoadingDialog();
      Fluttertoast.showToast(
        msg: "تم تغيير كلمة السر بنجاح",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.SNACKBAR,
        backgroundColor: Colors.green,
        textColor: Colors.white,
      );

      _newPasswordController.clear();
      _oldPasswordController.clear();
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
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
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
              Center(child: IntroductiveComponent(text: "تغيــــر كلمة السر")),
              SizedBox(height: 20),
              CustomTextfield(
                  fieldController: _oldPasswordController,
                  fieldTitle: "كلمة السر القـــديمة",
                  inArabic: false,
                  isPassword: true,
                  onlyNumber: false),
              SizedBox(height: 20),
              CustomTextfield(
                  fieldController: _newPasswordController,
                  fieldTitle: "كلمة السر الجـــديدة",
                  inArabic: false,
                  isPassword: true,
                  onlyNumber: false),
              SizedBox(height: 20),
              GestureDetector(
                  onTap: () => changePassword(),
                  child: CustomButton(text: "تـــغيير")),
            ],
          ),
        ),
      ),
    );
  }
}
