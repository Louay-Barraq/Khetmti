import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:khetmti/core/utils/helpers.dart';
import 'package:khetmti/features/auth/providers/auth_provider.dart';
import 'package:khetmti/features/settings/providers/settings_provider.dart';
import 'package:khetmti/shared/widgets/app_text_field.dart';
import 'package:khetmti/shared/widgets/form_page.dart';

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
      showErrorToast('عنوان البريد الإلكتروني غير صالح');
      return;
    }
    if (email == current) {
      showErrorToast('هذا هو بريدك الحالي');
      return;
    }

    setState(() => _loading = true);
    try {
      await ref.read(settingsRepositoryProvider).changeEmail(newEmail: email);
      showSuccessToast('أرسلنا رابط تأكيد، افتحه لإتمام تغيير البريد');
      if (mounted) context.pop();
    } catch (_) {
      if (mounted) setState(() => _loading = false);
      showErrorToast('حدث خطأ أثناء تغيير البريد الإلكتروني');
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
      title: 'تغيير البريد',
      description: 'بريدك الحالي: $current\n'
          'سنرسل رابط تأكيد، ويتغير بريد الدخول بعد فتحه.',
      actionLabel: 'إرسال رابط التأكيد',
      actionIcon: Icons.send_rounded,
      loading: _loading,
      onSubmit: _save,
      fields: [
        AppTextField(
          controller: _email,
          label: 'البريد الإلكتروني الجديد',
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
