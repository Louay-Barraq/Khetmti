import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:khetmti/core/theme/app_theme.dart';
import 'package:khetmti/core/utils/helpers.dart';
import 'package:khetmti/features/auth/providers/auth_provider.dart';
import 'package:khetmti/shared/widgets/khetmti_header.dart';
import 'package:khetmti/shared/widgets/settings_item_card.dart';
import 'package:khetmti/l10n/l10n.dart';

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
            title: tr.settings,
            showProfile: true,
            showBackButton: showBackButton,
            onNotificationTap: () => context.push('/notifications'),
            onProfileTap: () => context.go('/profile'),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 30, 20, 40),
              children: [
                Text(
                  tr.editableSettings,
                  style: TextStyle(
                    fontFamily: AppTheme.font,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textPrimary,
                  ),
                ),
                const SizedBox(height: 15),
                _buildCardGroup([
                  SettingsItemCard(
                    title: tr.changeUsername,
                    icon: Icons.person_outline,
                    onTap: () => context.push('/settings/username'),
                  ),
                  SettingsItemCard(
                    title: tr.changeEmail,
                    icon: Icons.email_outlined,
                    onTap: () => context.push('/settings/email'),
                  ),
                  SettingsItemCard(
                    title: tr.changePassword,
                    icon: Icons.lock_outline,
                    onTap: () => context.push('/settings/password'),
                  ),
                  SettingsItemCard(
                    title: '${tr.language} · ${languageNames[L10n.locale.languageCode]}',
                    icon: Icons.translate_rounded,
                    onTap: () => _showLanguagePicker(context, ref),
                  ),
                  /*
                  SettingsItemCard(
                    title: tr.reminders,
                    icon: Icons.notifications_none,
                    onTap: () {},
                  ),
                  SettingsItemCard(
                    title: tr.appearance,
                    icon: Icons.dark_mode_outlined,
                    onTap: () {},
                  ),
                  */
                  SettingsItemCard(
                    title: tr.signOut,
                    icon: Icons.logout,
                    textColor: Colors.red,
                    iconColor: Colors.red,
                    iconBgColor: Colors.red.withValues(alpha: 0.1),
                    // The router sends the signed-out user to /login.
                    onTap: () => ref.read(authRepositoryProvider).signOut(),
                  ),
                  SettingsItemCard(
                    title: tr.deleteAccount,
                    icon: Icons.delete_forever,
                    textColor: Colors.red,
                    iconColor: Colors.red,
                    iconBgColor: Colors.red.withValues(alpha: 0.1),
                    onTap: () => _showDeleteAccountDialog(context, ref),
                  ),
                ]),
                const SizedBox(height: 30),
                Text(
                  tr.supportSection,
                  style: TextStyle(
                    fontFamily: AppTheme.font,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textPrimary,
                  ),
                ),
                const SizedBox(height: 15),
                _buildCardGroup([
                  SettingsItemCard(
                    title: tr.helpCenter,
                    icon: Icons.help_outline,
                    onTap: () => context.push('/help'),
                  ),
                  SettingsItemCard(
                    title: tr.aboutKhetmti,
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

  void _showLanguagePicker(BuildContext context, WidgetRef ref) {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (sheet) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (final e in languageNames.entries)
              ListTile(
                title: Text(e.value, style: const TextStyle(fontSize: 18)),
                trailing: L10n.locale.languageCode == e.key
                    ? const Icon(Icons.check_rounded, color: AppTheme.primaryColor)
                    : null,
                onTap: () {
                  Navigator.pop(sheet);
                  setAppLanguage(ref, e.key);
                },
              ),
            const SizedBox(height: 8),
          ],
        ),
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
      showSuccessToast(tr.accountDeleted);
      // The router sends the signed-out user to /login.
    } catch (_) {
      if (mounted) setState(() => _deleting = false);
      showErrorToast(tr.deleteAccountFailed);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      icon: const Icon(Icons.warning_amber_rounded, color: Colors.red, size: 40),
      title: Text(tr.deleteAccountTitle, textAlign: TextAlign.center),
      content: Text(
        tr.deleteAccountBody,
        textAlign: TextAlign.start,
      ),
      actionsAlignment: MainAxisAlignment.spaceBetween,
      actions: [
        TextButton(
          onPressed: _deleting ? null : () => Navigator.pop(context),
          child: Text(tr.cancel),
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
              : Text(
                  tr.deleteMyAccount,
                  style: TextStyle(fontFamily: AppTheme.font, fontWeight: FontWeight.bold),
                ),
        ),
      ],
    );
  }
}
