import 'package:flutter/material.dart';

import '../themes/main_theme.dart';

class CustomAuthenticationButton extends StatelessWidget {
  String text;
  CustomAuthenticationButton({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: 50,
        width: 160,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: MainTheme.primaryColor,
          boxShadow: const [
            BoxShadow(
              offset: Offset(0, 2),
              blurRadius: 4,
              spreadRadius: 2,
              color: Color(0x3F000000),
            ),
          ],
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              fontFamily: 'Amiri',
              fontWeight: FontWeight.bold,
              fontSize: 25,
            ),
          ),
        ),
      ),
    );
  }
}
