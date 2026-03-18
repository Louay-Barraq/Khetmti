import 'package:flutter/material.dart';
import 'package:khetmti/themes/main_theme.dart';

class CustomTextfield extends StatefulWidget {
  final TextEditingController fieldController;
  final String fieldTitle;
  final bool inArabic;
  final bool isPassword;
  final bool onlyNumber;

  const CustomTextfield({
    super.key,
    required this.fieldController,
    required this.fieldTitle,
    required this.inArabic,
    required this.isPassword,
    required this.onlyNumber,
  });

  @override
  State<CustomTextfield> createState() => _CustomTextfieldState();
}

class _CustomTextfieldState extends State<CustomTextfield> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.sizeOf(context).width;
    return Center(
      child: Container(
        height: 90,
        width: screenWidth - 40,
        decoration: BoxDecoration(
          color: const Color(0xFFE0F2FE),
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
                    style: const TextStyle(
                      fontFamily: 'Amiri',
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                    ),
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
                keyboardType: widget.onlyNumber
                    ? TextInputType.number
                    : TextInputType.text,
                controller: widget.fieldController,
                textDirection:
                    widget.inArabic ? TextDirection.rtl : TextDirection.ltr,
                obscureText: widget.isPassword,
                style: TextStyle(
                  fontFamily: widget.inArabic ? 'Amiri' : 'Roboto',
                  fontSize: 18,
                ),
                decoration: const InputDecoration(
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
