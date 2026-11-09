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
            onProfileTap: () => context.go('/profile'),
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
                    // The router sends the signed-out user to /login.
                    onTap: () => ref.read(authRepositoryProvider).signOut(),
                  ),
                  SettingsItemCard(
                    title: "حذف الحساب",
                    icon: Icons.delete_forever,
                    textColor: Colors.red,
                    iconColor: Colors.red,
                    iconBgColor: Colors.red.withValues(alpha: 0.1),
                    onTap: () => _showDeleteAccountDialog(context, ref),
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
      builder: (_) => const _DeleteAccountDialog(),
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

/// Explains what deleting the account removes, then deletes it.
class _DeleteAccountDialog extends ConsumerStatefulWidget {
  const _DeleteAccountDialog();

  @override
  ConsumerState<_DeleteAccountDialog> createState() =>
      _DeleteAccountDialogState();
}

class _DeleteAccountDialogState extends ConsumerState<_DeleteAccountDialog> {
  bool _deleting = false;

  Future<void> _delete() async {
    setState(() => _deleting = true);
    try {
      await ref.read(authRepositoryProvider).deleteAccount();
      if (!mounted) return;
      Navigator.pop(context);
      showSuccessToast('تم حذف حسابك. نسأل الله أن يتقبل منك');
      // The router sends the signed-out user to /login.
    } catch (_) {
      if (mounted) setState(() => _deleting = false);
      showErrorToast('تعذّر حذف الحساب، حاول مرة أخرى');
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      icon: const Icon(Icons.warning_amber_rounded, color: Colors.red, size: 40),
      title: const Text('حذف الحساب نهائياً', textAlign: TextAlign.center),
      content: const Text(
        'سيُحذف حسابك وأصدقاؤك ونقاطك، وتُلغى حجوزاتك التي لم تتمها. '
        'الختمات التي أنشأتها تنتقل إلى أقدم مشارك فيها، أو تُحذف إن لم يكن فيها غيرك. '
        'لا يمكن التراجع عن هذا.',
        textAlign: TextAlign.right,
        textDirection: TextDirection.rtl,
      ),
      actionsAlignment: MainAxisAlignment.spaceBetween,
      actions: [
        TextButton(
          onPressed: _deleting ? null : () => Navigator.pop(context),
          child: const Text('إلغاء'),
        ),
        FilledButton(
          style: FilledButton.styleFrom(
            backgroundColor: Colors.red,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          ),
          onPressed: _deleting ? null : _delete,
          child: _deleting
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                )
              : const Text(
                  'احذف حسابي',
                  style: TextStyle(fontFamily: 'Amiri', fontWeight: FontWeight.bold),
                ),
        ),
      ],
    );
  }
}
