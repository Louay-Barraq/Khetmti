import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:khetmti/core/theme/app_theme.dart';
import 'package:khetmti/core/utils/helpers.dart';
import 'package:khetmti/features/auth/presentation/widgets/auth_scaffold.dart';
import 'package:khetmti/features/auth/providers/auth_provider.dart';
import 'package:khetmti/shared/widgets/app_text_field.dart';
import 'package:khetmti/shared/widgets/primary_button.dart';
import 'package:khetmti/l10n/l10n.dart';

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
      showErrorToast(tr.invalidEmail);
      return;
    }
    if (_password.text.isEmpty) {
      showErrorToast(tr.enterPassword);
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
      title: tr.loginTitle,
      subtitle: tr.loginSubtitle,
      footer: AuthFooterLink(
        question: tr.noAccount,
        action: tr.createNewAccount,
        onTap: () => context.push('/register'),
      ),
      children: [
        AutofillGroup(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AppTextField(
                controller: _email,
                label: tr.email,
                icon: Icons.alternate_email_rounded,
                latin: true,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                autofillHints: const [AutofillHints.email],
              ),
              const SizedBox(height: 18),
              AppTextField(
                controller: _password,
                label: tr.password,
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
          alignment: AlignmentDirectional.centerEnd,
          child: TextButton(
            onPressed: _forgotPassword,
            child: Text(
              tr.forgotPassword,
              style: TextStyle(color: AppTheme.primaryColor),
            ),
          ),
        ),
        const SizedBox(height: 8),
        PrimaryButton(
          label: tr.signIn,
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
      showErrorToast(tr.invalidEmail);
      return;
    }
    setState(() => _loading = true);
    try {
      await ref.read(authRepositoryProvider).resetPassword(email);
      if (!mounted) return;
      Navigator.pop(context);
      showSuccessToast(tr.resetLinkSent);
    } catch (_) {
      if (mounted) setState(() => _loading = false);
      showErrorToast(tr.resetLinkFailed);
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
              Text(
                tr.recoverPassword,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: AppTheme.font,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textPrimary,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                tr.recoverPasswordBody,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: AppTheme.font,
                  fontSize: 16,
                  color: AppTheme.textSecondary,
                ),
              ),
              const SizedBox(height: 20),
              AppTextField(
                controller: _email,
                label: tr.email,
                icon: Icons.alternate_email_rounded,
                latin: true,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.send,
                onSubmitted: (_) => _send(),
              ),
              const SizedBox(height: 22),
              PrimaryButton(
                label: tr.sendLink,
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
