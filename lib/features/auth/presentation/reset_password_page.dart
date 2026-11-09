import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:khetmti/core/utils/helpers.dart';
import 'package:khetmti/features/auth/presentation/widgets/auth_scaffold.dart';
import 'package:khetmti/features/auth/providers/auth_provider.dart';
import 'package:khetmti/shared/widgets/app_text_field.dart';
import 'package:khetmti/shared/widgets/primary_button.dart';

/// Opened by the link in the "reset password" email. Supabase has already
/// signed the user in with a recovery session; this page sets the password.
class ResetPasswordPage extends ConsumerStatefulWidget {
  const ResetPasswordPage({super.key});

  @override
  ConsumerState<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends ConsumerState<ResetPasswordPage> {
  final _password = TextEditingController();
  final _confirm = TextEditingController();
  bool _loading = false;

  Future<void> _save() async {
    if (_password.text.length < minPasswordLength) {
      showErrorToast(
          'يجب أن تتكون كلمة السر من $minPasswordLength أحرف على الأقل');
      return;
    }
    if (_password.text != _confirm.text) {
      showErrorToast('كلمتا السر غير متطابقتين');
      return;
    }

    setState(() => _loading = true);
    try {
      await ref.read(authRepositoryProvider).setNewPassword(_password.text);
      showSuccessToast('تم تغيير كلمة السر بنجاح');
      if (mounted) context.go('/home');
    } catch (_) {
      if (mounted) setState(() => _loading = false);
      showErrorToast('انتهت صلاحية الرابط، اطلب رابطاً جديداً');
    }
  }

  @override
  void dispose() {
    _password.dispose();
    _confirm.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AuthScaffold(
      title: 'كلمة سر جديدة',
      subtitle: 'اختر كلمة سر جديدة لحسابك',
      children: [
        AppTextField(
          controller: _password,
          label: 'كلمة السر الجديدة',
          hint: '$minPasswordLength أحرف على الأقل',
          icon: Icons.lock_outline_rounded,
          isPassword: true,
          autofocus: true,
          textInputAction: TextInputAction.next,
          autofillHints: const [AutofillHints.newPassword],
        ),
        const SizedBox(height: 18),
        AppTextField(
          controller: _confirm,
          label: 'تأكيد كلمة السر',
          icon: Icons.lock_reset_rounded,
          isPassword: true,
          textInputAction: TextInputAction.done,
          onSubmitted: (_) => _save(),
        ),
        const SizedBox(height: 26),
        PrimaryButton(
          label: 'حفظ كلمة السر',
          icon: Icons.check_rounded,
          loading: _loading,
          onPressed: _save,
        ),
      ],
    );
  }
}
