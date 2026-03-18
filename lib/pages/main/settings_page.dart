import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:khetmti/pages/actions/change_email_page.dart';
import 'package:khetmti/pages/actions/change_password_page.dart';
import 'package:khetmti/pages/actions/change_username_page.dart';
import 'package:khetmti/pages/actions/notifications_page.dart';
import 'package:khetmti/pages/authentication/login_page.dart';
import 'package:khetmti/pages/main/profile_page.dart';
import 'package:khetmti/pages/main/about_page.dart';
import 'package:khetmti/pages/main/help_page.dart';
import '../../auth/auth_service.dart';
import '../../themes/main_theme.dart';
import '../../components/settings_item_card.dart';
import '../../components/khetmti_header.dart';
import '../../utils/helpers.dart';

class SettingsPage extends StatelessWidget {
  final bool showBackButton;
  const SettingsPage({super.key, this.showBackButton = false});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MainTheme.backgroundColor,
      body: Column(
        children: [
          // Standardized Header
          KhetmtiHeader(
            title: 'الإعدادات',
            showProfile: true,
            showBackButton: showBackButton,
            onNotificationTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => NotificationsPage())),
            onProfileTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ProfilePage())),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 30, 20, 40),
              children: [
                const Text(
                  'الإعدادات القابلة للتغيير',
                  textDirection: TextDirection.rtl,
                  style: TextStyle(
                    fontFamily: 'Amiri',
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: MainTheme.textPrimary,
                  ),
                ),
                const SizedBox(height: 15),
                _buildCardGroup([
                  SettingsItemCard(
                    title: "تغيير إسم المستخدم",
                    icon: Icons.person_outline,
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const ChangeUsernamePage())),
                  ),
                  SettingsItemCard(
                    title: "تغيير البريد الإلكتروني",
                    icon: Icons.email_outlined,
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const ChangeEmailPage())),
                  ),
                  SettingsItemCard(
                    title: "تغيير كلمة السر",
                    icon: Icons.lock_outline,
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const ChangePasswordPage())),
                  ),
                  /*
                  SettingsItemCard(
                    title: "إشعارات التذكير",
                    icon: Icons.notifications_none,
                    onTap: () {},
                  ),
                  SettingsItemCard(
                    title: "المظهر (داكن/فاتح)",
                    icon: Icons.dark_mode_outlined,
                    onTap: () {},
                  ),
                  */
                  SettingsItemCard(
                    title: "تسجيل الخروج",
                    icon: Icons.logout,
                    textColor: Colors.red,
                    iconColor: Colors.red,
                    iconBgColor: Colors.red.withOpacity(0.1),
                    onTap: () {
                      AuthService().logout();
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (context) => const LoginPage()),
                        (route) => false,
                      );
                    },
                  ),
                  SettingsItemCard(
                    title: "حذف الحساب",
                    icon: Icons.delete_forever,
                    textColor: Colors.red,
                    iconColor: Colors.red,
                    iconBgColor: Colors.red.withOpacity(0.1),
                    onTap: () => _showDeleteAccountDialog(context),
                  ),
                ]),
                const SizedBox(height: 30),
                const Text(
                  'الدعم والمساعدة',
                  textDirection: TextDirection.rtl,
                  style: TextStyle(
                    fontFamily: 'Amiri',
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: MainTheme.textPrimary,
                  ),
                ),
                const SizedBox(height: 15),
                _buildCardGroup([
                  SettingsItemCard(
                    title: "مركز المساعدة",
                    icon: Icons.help_outline,
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const HelpPage())),
                  ),
                  SettingsItemCard(
                    title: "عن تطبيق ختمتي",
                    icon: Icons.info_outline,
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const AboutPage())),
                  ),
                ]),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showDeleteAccountDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('حذف الحساب', textAlign: TextAlign.right),
        content: const Text(
          'هل أنت متأكد من حذف الحساب؟ لا يمكن التراجع عن هذا الفعل.',
          textAlign: TextAlign.right,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          TextButton(
            onPressed: () async {
              try {
                final user = FirebaseAuth.instance.currentUser;
                if (user != null) {
                  await user.delete();
                  if (context.mounted) {
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (context) => const LoginPage()),
                      (route) => false,
                    );
                  }
                }
              } catch (e) {
                if (context.mounted) Navigator.pop(context);
                showErrorToast('يجب تسجيل الدخول مرة أخرى لحذف الحساب لأسباب أمنية');
              }
            },
            child: const Text('حذف', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  Widget _buildCardGroup(List<Widget> items) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            offset: const Offset(0, 4),
            blurRadius: 10,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Column(
          children: items,
        ),
      ),
    );
  }
}
