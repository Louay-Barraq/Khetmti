import 'package:flutter/material.dart';
import 'package:khetmti/core/theme/app_theme.dart';
import 'package:khetmti/shared/widgets/khetmti_header.dart';

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: Column(
        children: [
          const KhetmtiHeader(
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
                    color: AppTheme.textSecondary.withValues(alpha: 0.5),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'لا توجد إشعارات حالياً',
                    style: TextStyle(
                      fontFamily: 'Amiri',
                      fontSize: 20,
                      color: AppTheme.textSecondary,
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
