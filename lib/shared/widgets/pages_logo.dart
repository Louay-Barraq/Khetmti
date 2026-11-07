import 'package:flutter/material.dart';

class PagesLogo extends StatelessWidget {
  const PagesLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 125,
      width: 125,
      decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: const [
            BoxShadow(
              blurStyle: BlurStyle.normal,
              offset: Offset(0, 0),
              blurRadius: 5,
              spreadRadius: 6,
              color: Color(0x7F000000),
            )
          ]),
      child: Image.asset(
        "assets/icons/Coran-Filled-100.png",
        height: 55,
        width: 61,
      ),
    );
  }
}
