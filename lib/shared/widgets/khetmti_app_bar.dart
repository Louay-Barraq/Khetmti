import 'package:flutter/material.dart';
import 'package:khetmti/core/theme/app_theme.dart';

/// Shared AppBar used across sub-pages.
class KhetmtiAppBar extends StatelessWidget implements PreferredSizeWidget {
  const KhetmtiAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppTheme.primaryColor,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () => Navigator.pop(context),
      ),
      title: const Text(
        "ختمتـــــــي",
        style: TextStyle(
          fontFamily: 'Amiri',
          fontWeight: FontWeight.bold,
          fontSize: 28,
          color: Colors.white,
          shadows: [
            Shadow(
              offset: Offset(0, 4),
              blurRadius: 2.5,
              color: Color(0x3F000000),
            ),
          ],
        ),
      ),
      centerTitle: true,
    );
  }
}
