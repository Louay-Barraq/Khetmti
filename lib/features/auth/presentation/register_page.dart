import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:khetmti/core/utils/helpers.dart';
import 'package:khetmti/features/auth/presentation/widgets/auth_scaffold.dart';
import 'package:khetmti/features/auth/providers/auth_provider.dart';
import 'package:khetmti/shared/widgets/app_text_field.dart';
import 'package:khetmti/shared/widgets/primary_button.dart';
import 'package:khetmti/l10n/l10n.dart';

class RegisterPage extends ConsumerStatefulWidget {
  const RegisterPage({super.key});

  @override
  ConsumerState<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends ConsumerState<RegisterPage> {
  final _username = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _loading = false;

  Future<void> _register() async {
    final username = _username.text.trim();
    final email = _email.text.trim();

    if (username.length < minUsernameLength) {
      showErrorToast(
          tr.usernameTooShort(minUsernameLength));
      return;
    }
    if (!isValidEmail(email)) {
      showErrorToast(tr.invalidEmail);
      return;
    }
    if (_password.text.length < minPasswordLength) {
      showErrorToast(
          tr.passwordTooShort(minPasswordLength));
      return;
    }

    FocusScope.of(context).unfocus();
    setState(() => _loading = true);
    // On success the router redirect opens /home.
    await ref.read(authRepositoryProvider).signUp(
          email: email,
          username: username,
          password: _password.text,
        );
    if (mounted) setState(() => _loading = false);
  }

  void _toLogin() {
    if (context.canPop()) {
      context.pop();
    } else {
      context.go('/login');
    }
  }

  @override
  void dispose() {
    _username.dispose();
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AuthScaffold(
      title: tr.registerTitle,
      subtitle: tr.registerSubtitle,
      onBack: context.canPop() ? _toLogin : null,
      footer: AuthFooterLink(
        question: tr.haveAccount,
        action: tr.signInLink,
        onTap: _toLogin,
      ),
      children: [
        AutofillGroup(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AppTextField(
                controller: _username,
                label: tr.fullName,
                hint: tr.fullNameHint,
                icon: Icons.person_outline_rounded,
                textInputAction: TextInputAction.next,
                autofillHints: const [AutofillHints.name],
              ),
              const SizedBox(height: 18),
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
                hint: tr.minChars(minPasswordLength),
                icon: Icons.lock_outline_rounded,
                isPassword: true,
                textInputAction: TextInputAction.done,
                onSubmitted: (_) => _register(),
                autofillHints: const [AutofillHints.newPassword],
              ),
            ],
          ),
        ),
        const SizedBox(height: 26),
        PrimaryButton(
          label: tr.createAccount,
          icon: Icons.person_add_alt_1_rounded,
          loading: _loading,
          onPressed: _register,
        ),
      ],
    );
  }
}
