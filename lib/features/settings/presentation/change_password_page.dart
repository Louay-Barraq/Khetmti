import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:khetmti/core/utils/helpers.dart';
import 'package:khetmti/features/settings/providers/settings_provider.dart';
import 'package:khetmti/shared/widgets/app_text_field.dart';
import 'package:khetmti/shared/widgets/form_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:khetmti/l10n/l10n.dart';

class ChangePasswordPage extends ConsumerStatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  ConsumerState<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends ConsumerState<ChangePasswordPage> {
  final _current = TextEditingController();
  final _new = TextEditingController();
  bool _loading = false;

  Future<void> _save() async {
    if (_current.text.isEmpty || _new.text.isEmpty) {
      showErrorToast(tr.fillAllFields);
      return;
    }
    if (_new.text.length < minPasswordLength) {
      showErrorToast(
          tr.passwordTooShort(minPasswordLength));
      return;
    }
    if (_current.text == _new.text) {
      showErrorToast(tr.samePassword);
      return;
    }

    setState(() => _loading = true);
    try {
      await ref.read(settingsRepositoryProvider).changePassword(
            currentPassword: _current.text,
            newPassword: _new.text,
          );
      if (mounted) context.pop();
    } on AuthException catch (e) {
      if (mounted) setState(() => _loading = false);
      final wrongPassword = e.message.toLowerCase().contains('credential');
      showErrorToast(wrongPassword
          ? tr.wrongCurrentPassword
          : tr.genericError);
      if (wrongPassword) _current.clear();
    } catch (_) {
      if (mounted) setState(() => _loading = false);
      showErrorToast(tr.genericError);
    }
  }

  @override
  void dispose() {
    _current.dispose();
    _new.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FormPage(
      title: tr.changePassword,
      actionLabel: tr.changePassword,
      actionIcon: Icons.lock_reset_rounded,
      loading: _loading,
      onSubmit: _save,
      fields: [
        AppTextField(
          controller: _current,
          label: tr.currentPassword,
          icon: Icons.lock_outline_rounded,
          isPassword: true,
          textInputAction: TextInputAction.next,
          autofillHints: const [AutofillHints.password],
        ),
        AppTextField(
          controller: _new,
          label: tr.newPassword,
          hint: tr.minChars(minPasswordLength),
          icon: Icons.lock_reset_rounded,
          isPassword: true,
          textInputAction: TextInputAction.done,
          onSubmitted: (_) => _save(),
          autofillHints: const [AutofillHints.newPassword],
        ),
      ],
    );
  }
}
