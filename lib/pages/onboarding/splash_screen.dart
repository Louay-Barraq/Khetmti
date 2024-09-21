import 'dart:async';
import 'package:flutter/material.dart';
import 'package:khetmti/auth/auth_page.dart';
import 'package:khetmti/pages/onboarding/onboarding_page.dart';
import 'package:khetmti/themes/main_theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 3), () async {
      // Checking the onboarding variable
      final prefs = await SharedPreferences.getInstance();
      final onboarding = prefs.getBool("onboarding") ?? false;

      if (onboarding == true) {
        Navigator.of(context)
            .pushReplacement(MaterialPageRoute(builder: (_) => AuthPage()));
      } else {
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => OnboardingPage()));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: [MainTheme.primaryColor, MainTheme.secondaryColor],
              begin: Alignment.topRight,
              end: Alignment.bottomLeft),
        ),
      ),
    );
  }
}
