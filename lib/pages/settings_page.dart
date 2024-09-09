// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:khetmti/components/introductive_component.dart';
import 'package:khetmti/components/settings_component.dart';
import 'package:khetmti/pages/login_page.dart';
import 'package:khetmti/themes/main_theme.dart';
import '../auth/auth_service.dart';
import '../components/top_page_box.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            TopPageBox(),
            SizedBox(height: 25),
            IntroductiveComponent(text: "الإعدادات القابلة للتغييــــر"),
            SizedBox(height: 20),
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return ListView(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 5.0),
                        child: SettingsComponent(
                            title: "تغيــــر إسم المستخدم",
                            imagePath:
                                "assets/icons/Change_Username-Filled.png"),
                      ),
                      SettingsComponent(
                          title: "تغيــــر البريد الإلكتروني",
                          imagePath: "assets/icons/Change_Email-Filled.png"),
                      SettingsComponent(
                          title: "تغيــــر كلمة السر",
                          imagePath: "assets/icons/Change_Password-Filled.png"),
                      SettingsComponent(
                          title: "تغيــــر الصورة الشخصية",
                          imagePath: "assets/icons/Change_Photo-Filled.png"),
                      GestureDetector(
                        onTap: () {
                          AuthService().logout();
                          Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(builder: (context) => LoginPage()),
                                (route) => false,
                          );
                          },
                        child: SettingsComponent(
                            title: "تسجيـــل الخــروج",
                            imagePath: "assets/icons/Logout-Filled.png"),
                      ),
                      SizedBox(height: 40),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
