import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:khetmti/core/theme/app_theme.dart';
import 'package:khetmti/core/utils/helpers.dart';
import 'package:khetmti/features/auth/presentation/widgets/auth_scaffold.dart';
import 'package:khetmti/features/auth/providers/auth_provider.dart';
import 'package:khetmti/shared/widgets/app_text_field.dart';
import 'package:khetmti/shared/widgets/primary_button.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _loading = false;

  Future<void> _login() async {
    final email = _email.text.trim();
    if (!isValidEmail(email)) {
      showErrorToast('عنوان البريد الإلكتروني غير صالح');
      return;
    }
    if (_password.text.isEmpty) {
      showErrorToast('يرجى إدخال كلمة السر');
      return;
    }

    FocusScope.of(context).unfocus();
    setState(() => _loading = true);
    // On success the router redirect opens /home.
    await ref
        .read(authRepositoryProvider)
        .signIn(email: email, password: _password.text);
    if (mounted) setState(() => _loading = false);
  }

  void _forgotPassword() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _ResetPasswordSheet(initialEmail: _email.text.trim()),
    );
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AuthScaffold(
      title: 'أهلاً بعودتك',
      subtitle: 'سجّل دخولك لمتابعة ختماتك',
      footer: AuthFooterLink(
        question: 'ليس لديك حساب؟',
        action: 'أنشئ حساباً جديداً',
        onTap: () => context.push('/register'),
      ),
      children: [
        AutofillGroup(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AppTextField(
                controller: _email,
                label: 'البريد الإلكتروني',
                icon: Icons.alternate_email_rounded,
                latin: true,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                autofillHints: const [AutofillHints.email],
              ),
              const SizedBox(height: 18),
              AppTextField(
                controller: _password,
                label: 'كلمة السر',
                icon: Icons.lock_outline_rounded,
                isPassword: true,
                textInputAction: TextInputAction.done,
                onSubmitted: (_) => _login(),
                autofillHints: const [AutofillHints.password],
              ),
            ],
          ),
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: TextButton(
            onPressed: _forgotPassword,
            child: const Text(
              'نسيت كلمة السر؟',
              style: TextStyle(color: AppTheme.primaryColor),
            ),
          ),
        ),
        const SizedBox(height: 8),
        PrimaryButton(
          label: 'تسجيل الدخول',
          icon: Icons.login_rounded,
          loading: _loading,
          onPressed: _login,
        ),
      ],
    );
  }
}

/// Asks for the email and sends the reset link.
class _ResetPasswordSheet extends ConsumerStatefulWidget {
  final String initialEmail;
  const _ResetPasswordSheet({required this.initialEmail});

  @override
  ConsumerState<_ResetPasswordSheet> createState() =>
      _ResetPasswordSheetState();
}

class _ResetPasswordSheetState extends ConsumerState<_ResetPasswordSheet> {
  late final _email = TextEditingController(text: widget.initialEmail);
  bool _loading = false;

  Future<void> _send() async {
    final email = _email.text.trim();
    if (!isValidEmail(email)) {
      showErrorToast('عنوان البريد الإلكتروني غير صالح');
      return;
    }
    setState(() => _loading = true);
    try {
      await ref.read(authRepositoryProvider).resetPassword(email);
      if (!mounted) return;
      Navigator.pop(context);
      showSuccessToast('أرسلنا رابط إعادة تعيين كلمة السر إلى بريدك');
    } catch (_) {
      if (mounted) setState(() => _loading = false);
      showErrorToast('تعذّر إرسال الرابط، حاول مرة أخرى بعد قليل');
    }
  }

  @override
  void dispose() {
    _email.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: Container(
        padding: const EdgeInsets.fromLTRB(24, 12, 24, 28),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: SafeArea(
          top: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppTheme.borderColor,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'استعادة كلمة السر',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Amiri',
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textPrimary,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'سنرسل إلى بريدك رابطاً يفتح التطبيق لتختار كلمة سر جديدة.',
                textAlign: TextAlign.center,
                textDirection: TextDirection.rtl,
                style: TextStyle(
                  fontFamily: 'Amiri',
                  fontSize: 16,
                  color: AppTheme.textSecondary,
                ),
              ),
              const SizedBox(height: 20),
              AppTextField(
                controller: _email,
                label: 'البريد الإلكتروني',
                icon: Icons.alternate_email_rounded,
                latin: true,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.send,
                onSubmitted: (_) => _send(),
              ),
              const SizedBox(height: 22),
              PrimaryButton(
                label: 'إرسال الرابط',
                icon: Icons.send_rounded,
                loading: _loading,
                onPressed: _send,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
