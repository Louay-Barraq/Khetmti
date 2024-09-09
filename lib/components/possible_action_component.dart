import 'package:flutter/material.dart';
import '../themes/main_theme.dart';

class PossibleActionComponent extends StatelessWidget {
  final String actionText;

  PossibleActionComponent({super.key, required this.actionText});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 0, 12, 18),
      child: Container(
        height: 90,
        decoration: BoxDecoration(
          color: MainTheme.tertiaryColor,
          borderRadius: BorderRadius.circular(25),
          boxShadow: const [
            BoxShadow(
              offset: Offset(0, 4),
              blurRadius: 4,
              spreadRadius: 2,
              color: Color(0x3F000000),
            ),
          ],
        ),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: Container(
                height: 45,
                width: 45,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                  boxShadow: const [
                    BoxShadow(
                      offset: Offset(0, 0),
                      blurRadius: 8,
                      spreadRadius: 4,
                      color: Color(0x3F000000),
                    ),
                  ],
                ),
                child: Image.asset("assets/icons/left_arrow.png"),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(right: 22),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    actionText,
                    style: const TextStyle(
                      fontFamily: 'Amiri',
                      fontWeight: FontWeight.bold,
                      fontSize: 26,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
