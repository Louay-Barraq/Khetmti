// ignore_for_file: prefer_const_literals_to_create_immutables
import 'package:flutter/material.dart';
import 'package:khetmti/themes/main_theme.dart';

class CustomTextfield extends StatefulWidget {
  TextEditingController fieldController;
  String fieldTitle;
  bool inArabic;
  bool isPassword;
  bool onlyNumber;
  CustomTextfield(
      {super.key,
      required this.fieldController,
      required this.fieldTitle,
      required this.inArabic,
      required this.isPassword,
      required this.onlyNumber});

  @override
  State<CustomTextfield> createState() =>
      _CustomTextfieldState();
}

class _CustomTextfieldState
    extends State<CustomTextfield> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.sizeOf(context).width;
    return Center(
      child: Container(
        height: 90,
        width: screenWidth - 40,
        decoration: BoxDecoration(
          color: MainTheme.secondaryColor.withOpacity(0.75),
          borderRadius: BorderRadius.circular(15),
          boxShadow: const [
            BoxShadow(
              offset: Offset(0, 4),
              blurRadius: 4,
              spreadRadius: 2,
              color: Color(0x3F000000),
            ),
          ],
        ),
        child: Column(
          children: [
            SizedBox(
              height: 45,
              child: Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: const EdgeInsets.only(right: 20),
                  child: Text(
                    widget.fieldTitle,
                    style: TextStyle(
                        fontFamily: 'Amiri',
                        fontWeight: FontWeight.bold,
                        fontSize: 22),
                  ),
                ),
              ),
            ),
            Container(
              height: 45,
              decoration: BoxDecoration(
                color: MainTheme.greyishColor,
                borderRadius: BorderRadius.circular(15),
              ),
              child: TextFormField(
                keyboardType: widget.onlyNumber == true ? TextInputType.number : TextInputType.text,
                controller: widget.fieldController,
                textDirection: widget.inArabic == true
                    ? TextDirection.rtl
                    : TextDirection.ltr,
                obscureText: widget.isPassword == true ? true : false,
                style: TextStyle(
                  fontFamily: widget.inArabic == true ? 'Amiri' : 'Roboto',
                  fontSize: 18,
                ),
                decoration: InputDecoration(

                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  contentPadding: EdgeInsets.only(right: 20, left: 20),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
