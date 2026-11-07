import 'package:flutter/material.dart';
import 'package:khetmti/core/theme/app_theme.dart';

class SettingsComponent extends StatelessWidget {
  final String title;
  final String imagePath;
  const SettingsComponent({super.key, required this.title, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 0, 12, 18),
      child: Container(
        height: 90,
        decoration: BoxDecoration(
          color: AppTheme.greyishColor,
          borderRadius: BorderRadius.circular(15),
          boxShadow: const [
            BoxShadow(
              offset: Offset(0, 4),
              blurRadius: 4,
              spreadRadius: 2,
              color: Color(0x3F000000),
            )
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              title,
              style: TextStyle(
                fontFamily: 'Amiri',
                fontWeight: FontWeight.bold,
                fontSize: 28,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 20.0, left: 20),
              child: Image.asset(
                imagePath,
                height: 48,
                width: 48,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
