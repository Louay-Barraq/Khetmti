import 'package:flutter/material.dart';
import '../themes/main_theme.dart';

class SettingsItemCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;
  final Color? textColor;
  final Color? iconColor;
  final Color? iconBgColor;

  const SettingsItemCard({
    required this.title,
    required this.icon,
    required this.onTap,
    this.textColor,
    this.iconColor,
    this.iconBgColor,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
            bottom: BorderSide(
              color: Colors.grey.withOpacity(0.1),
              width: 1,
            ),
          ),
        ),
        child: Row(
          textDirection: TextDirection.rtl,
          children: [
            // Icon
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: iconBgColor ?? const Color(0xFFE8F5E9),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: iconColor ?? MainTheme.primaryColor,
                size: 22,
              ),
            ),
            const SizedBox(width: 16),
            // Title
            Expanded(
              child: Text(
                title,
                textDirection: TextDirection.rtl,
                style: TextStyle(
                  fontFamily: 'Amiri',
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: textColor ?? MainTheme.textPrimary,
                ),
              ),
            ),
            // Chevron
            const Icon(
              Icons.chevron_left,
              color: Color(0xFFCBD5E1),
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}
