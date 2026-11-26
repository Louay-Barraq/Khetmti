import 'package:flutter/material.dart';
import 'package:khetmti/core/theme/app_theme.dart';

class KhetmtiHeader extends StatelessWidget {
  final String title;
  final bool showNotification;
  final List<Widget>? prefixActions;
  final List<Widget>? suffixActions;
  final Widget? bottom;
  final bool showProfile;
  final bool? showBackButton;
  final VoidCallback? onBackTap;
  final VoidCallback? onNotificationTap;
  final VoidCallback? onProfileTap;
  final VoidCallback? onSearchTap;
  final IconData icon;

  const KhetmtiHeader({
    required this.title,
    this.showNotification = true,
    this.prefixActions,
    this.suffixActions,
    this.bottom,
    this.showProfile = true,
    this.showBackButton,
    this.onBackTap,
    this.onNotificationTap,
    this.onProfileTap,
    this.onSearchTap,
    this.icon = Icons.person,
    super.key,
  });

  @override
  Widget build(BuildContext context) {

    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(20, 60, 20, bottom != null ? 10 : 40),
      decoration: const BoxDecoration(
        color: AppTheme.primaryColor,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(16),
          bottomRight: Radius.circular(16),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header Row: [Prefix/Notifications] --- [Title] --- [Profile]
          Row(
            children: [
              // Right side (RTL): Back Button or Prefix Actions
              Expanded(
                flex: 1,
                child: Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (showBackButton ?? (Navigator.canPop(context)))
                          Padding(
                            padding: const EdgeInsetsDirectional.only(end: 8.0),
                            child: KhetmtiHeader.buildHeaderIcon(
                              Icons.arrow_back_ios,
                              onTap: onBackTap ?? () => Navigator.pop(context),
                            ),
                          ),
                        if (prefixActions != null) ...prefixActions!,
                        if (showNotification)
                          Padding(
                            padding: EdgeInsets.zero,
                            child: KhetmtiHeader.buildHeaderIcon(
                              Icons.notifications_none,
                              onTap: onNotificationTap,
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
              // Center: Title
              Expanded(
                flex: 2,
                child: Center(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      title,
                      style: TextStyle(
                        fontFamily: AppTheme.font,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
              // Left side (RTL): Profile or Suffix Actions
              Expanded(
                flex: 1,
                child: Align(
                  alignment: AlignmentDirectional.centerEnd,
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (suffixActions != null) ...suffixActions!,
                        if (suffixActions == null && showProfile)
                          Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: onProfileTap,
                              customBorder: const CircleBorder(),
                              child: CircleAvatar(
                                radius: 20,
                                backgroundColor: Colors.white24,
                                child: Icon(icon, color: Colors.white, size: 20),
                              ),
                            ),
                          ),
                        if (suffixActions == null && !showProfile) const SizedBox(width: 40),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          // Optional Bottom Widget (e.g., Toggle Switches)
          if (bottom != null) ...[
            const SizedBox(height: 30),
            bottom!,
          ],
        ],
      ),
    );
  }

  static Widget buildHeaderIcon(IconData icon, {double size = 24, VoidCallback? onTap}) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.2),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: Colors.white, size: size),
        ),
      ),
    );
  }
}
