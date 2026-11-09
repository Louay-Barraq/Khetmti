import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:khetmti/core/utils/helpers.dart';
import 'package:khetmti/features/settings/providers/settings_provider.dart';
import 'package:khetmti/shared/widgets/app_text_field.dart';
import 'package:khetmti/shared/widgets/form_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

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
      showErrorToast('يرجى ملء جميع الحقول');
      return;
    }
    if (_new.text.length < minPasswordLength) {
      showErrorToast(
          'يجب أن تتكون كلمة السر من $minPasswordLength أحرف على الأقل');
      return;
    }
    if (_current.text == _new.text) {
      showErrorToast('كلمة السر الجديدة مطابقة للقديمة');
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
          ? 'كلمة السر الحالية غير صحيحة'
          : 'حدث خطأ أثناء العملية');
      if (wrongPassword) _current.clear();
    } catch (_) {
      if (mounted) setState(() => _loading = false);
      showErrorToast('حدث خطأ أثناء العملية');
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
      title: 'تغيير كلمة السر',
      actionLabel: 'تغيير كلمة السر',
      actionIcon: Icons.lock_reset_rounded,
      loading: _loading,
      onSubmit: _save,
      fields: [
        AppTextField(
          controller: _current,
          label: 'كلمة السر الحالية',
          icon: Icons.lock_outline_rounded,
          isPassword: true,
          textInputAction: TextInputAction.next,
          autofillHints: const [AutofillHints.password],
        ),
        AppTextField(
          controller: _new,
          label: 'كلمة السر الجديدة',
          hint: '$minPasswordLength أحرف على الأقل',
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
