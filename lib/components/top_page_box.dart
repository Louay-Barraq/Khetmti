import 'package:flutter/material.dart';

import '../themes/main_theme.dart';
import 'pages_logo.dart';

class TopPageBox extends StatelessWidget {
  const TopPageBox({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.sizeOf(context).width;
    return Container(
      width: screenWidth,
      height: 180,
      decoration: BoxDecoration(
        color: MainTheme.primaryColor,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20.0),
          bottomRight: Radius.circular(20.0),
        ),
        boxShadow: const [
          BoxShadow(
            offset: Offset(0, 4),
            blurRadius: 14,
            spreadRadius: 10,
            color: Color(0x3F000000),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: const [
          PagesLogo(),
          Text(
            'ختمتـــــــي',
            style: TextStyle(
              fontFamily: 'Amiri',
              fontSize: 52,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              shadows: [
                Shadow(
                    offset: Offset(0, 4),
                    blurRadius: 2.5,
                    color: Color(0x3F000000)),
              ],
            ),
          )
        ],
      ),
    );
  }
}
