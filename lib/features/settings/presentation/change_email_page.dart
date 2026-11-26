import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:khetmti/core/utils/helpers.dart';
import 'package:khetmti/features/auth/providers/auth_provider.dart';
import 'package:khetmti/features/settings/providers/settings_provider.dart';
import 'package:khetmti/shared/widgets/app_text_field.dart';
import 'package:khetmti/shared/widgets/form_page.dart';
import 'package:khetmti/l10n/l10n.dart';

class ChangeEmailPage extends ConsumerStatefulWidget {
  const ChangeEmailPage({super.key});

  @override
  ConsumerState<ChangeEmailPage> createState() => _ChangeEmailPageState();
}

class _ChangeEmailPageState extends ConsumerState<ChangeEmailPage> {
  final _email = TextEditingController();
  bool _loading = false;

  Future<void> _save() async {
    final email = _email.text.trim();
    final current = ref.read(authRepositoryProvider).currentUser?.email;

    if (!isValidEmail(email)) {
      showErrorToast(tr.invalidEmail);
      return;
    }
    if (email == current) {
      showErrorToast(tr.sameEmail);
      return;
    }

    setState(() => _loading = true);
    try {
      await ref.read(settingsRepositoryProvider).changeEmail(newEmail: email);
      showSuccessToast(tr.emailConfirmSent);
      if (mounted) context.pop();
    } catch (_) {
      if (mounted) setState(() => _loading = false);
      showErrorToast(tr.changeEmailError);
    }
  }

  @override
  void dispose() {
    _email.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final current = ref.watch(authRepositoryProvider).currentUser?.email ?? '';
    return FormPage(
      title: tr.changeEmailTitle,
      description: tr.changeEmailBody(current),
      actionLabel: tr.sendConfirmLink,
      actionIcon: Icons.send_rounded,
      loading: _loading,
      onSubmit: _save,
      fields: [
        AppTextField(
          controller: _email,
          label: tr.newEmail,
          icon: Icons.alternate_email_rounded,
          latin: true,
          autofocus: true,
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.send,
          onSubmitted: (_) => _save(),
        ),
      ],
    );
  }
}
