import 'package:flutter/material.dart';

class ProfilePageLogo extends StatefulWidget {
  const ProfilePageLogo({super.key});

  @override
  State<ProfilePageLogo> createState() => _ProfilePageLogoState();
}

class _ProfilePageLogoState extends State<ProfilePageLogo> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.sizeOf(context).width;
    return Container(
      height: screenWidth / 4,
      width: screenWidth / 4,
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
        ],
      ),
      child: Icon(
        Icons.person,
        size: screenWidth / 5,
      ),
    );
  }
}
