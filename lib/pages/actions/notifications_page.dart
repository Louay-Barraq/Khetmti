import 'package:flutter/material.dart';
import '../../themes/main_theme.dart';
import '../../components/khetmti_header.dart';

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MainTheme.backgroundColor,
      body: Column(
        children: [
          KhetmtiHeader(
            title: 'الإشعارات',
            showProfile: false,
            showBackButton: true,
            showNotification: false,
          ),
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.notifications_off_outlined,
                    size: 80,
                    color: MainTheme.textSecondary.withOpacity(0.5),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'لا توجد إشعارات حالياً',
                    style: TextStyle(
                      fontFamily: 'Amiri',
                      fontSize: 20,
                      color: MainTheme.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
