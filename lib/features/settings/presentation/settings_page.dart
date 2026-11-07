import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:khetmti/core/theme/app_theme.dart';
import 'package:khetmti/core/utils/helpers.dart';
import 'package:khetmti/features/auth/providers/auth_provider.dart';
import 'package:khetmti/shared/widgets/khetmti_header.dart';
import 'package:khetmti/shared/widgets/settings_item_card.dart';

class SettingsPage extends ConsumerWidget {
  final bool showBackButton;
  const SettingsPage({super.key, this.showBackButton = false});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: Column(
        children: [
          // Standardized Header
          KhetmtiHeader(
            title: 'الإعدادات',
            showProfile: true,
            showBackButton: showBackButton,
            onNotificationTap: () => context.push('/notifications'),
            onProfileTap: () => context.push('/profile'),
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
                    color: AppTheme.textPrimary,
                  ),
                ),
                const SizedBox(height: 15),
                _buildCardGroup([
                  SettingsItemCard(
                    title: "تغيير إسم المستخدم",
                    icon: Icons.person_outline,
                    onTap: () => context.push('/settings/username'),
                  ),
                  SettingsItemCard(
                    title: "تغيير البريد الإلكتروني",
                    icon: Icons.email_outlined,
                    onTap: () => context.push('/settings/email'),
                  ),
                  SettingsItemCard(
                    title: "تغيير كلمة السر",
                    icon: Icons.lock_outline,
                    onTap: () => context.push('/settings/password'),
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
                    iconBgColor: Colors.red.withValues(alpha: 0.1),
                    onTap: () async {
                      await ref.read(authRepositoryProvider).signOut();
                      if (context.mounted) {
                        context.go('/login');
                      }
                    },
                  ),
                  SettingsItemCard(
                    title: "حذف الحساب",
                    icon: Icons.delete_forever,
                    textColor: Colors.red,
                    iconColor: Colors.red,
                    iconBgColor: Colors.red.withValues(alpha: 0.1),
                    onTap: () => _showDeleteAccountDialog(context, ref),
                  ),
                  const SizedBox(height: 10),
                ]),
                const SizedBox(height: 30),
                const Text(
                  'الدعم والمساعدة',
                  textDirection: TextDirection.rtl,
                  style: TextStyle(
                    fontFamily: 'Amiri',
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textPrimary,
                  ),
                ),
                const SizedBox(height: 15),
                _buildCardGroup([
                  SettingsItemCard(
                    title: "مركز المساعدة",
                    icon: Icons.help_outline,
                    onTap: () => context.push('/help'),
                  ),
                  SettingsItemCard(
                    title: "عن تطبيق ختمتي",
                    icon: Icons.info_outline,
                    onTap: () => context.push('/about'),
                  ),
                ]),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showDeleteAccountDialog(BuildContext context, WidgetRef ref) {
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
                await ref.read(authRepositoryProvider).deleteAccount();
                if (context.mounted) {
                  context.go('/login');
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
            color: Colors.black.withValues(alpha: 0.05),
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
