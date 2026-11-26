import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:khetmti/core/utils/helpers.dart';
import 'package:khetmti/features/auth/providers/auth_provider.dart';
import 'package:khetmti/features/settings/providers/settings_provider.dart';
import 'package:khetmti/shared/widgets/app_text_field.dart';
import 'package:khetmti/shared/widgets/form_page.dart';
import 'package:khetmti/l10n/l10n.dart';

class ChangeUsernamePage extends ConsumerStatefulWidget {
  const ChangeUsernamePage({super.key});

  @override
  ConsumerState<ChangeUsernamePage> createState() => _ChangeUsernamePageState();
}

class _ChangeUsernamePageState extends ConsumerState<ChangeUsernamePage> {
  late final _name = TextEditingController(
    text: ref.read(currentUserProvider).valueOrNull?.username ?? '',
  );
  bool _loading = false;

  Future<void> _save() async {
    final name = _name.text.trim();
    final current = ref.read(currentUserProvider).valueOrNull?.username;

    if (name.length < minUsernameLength) {
      showErrorToast(tr.nameTooShort(minUsernameLength));
      return;
    }
    if (name == current) {
      showErrorToast(tr.sameUsername);
      return;
    }

    setState(() => _loading = true);
    try {
      await ref.read(settingsRepositoryProvider).changeUsername(newUsername: name);
      if (mounted) context.pop();
    } catch (_) {
      if (mounted) setState(() => _loading = false);
      showErrorToast(tr.genericError);
    }
  }

  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FormPage(
      title: tr.changeNameTitle,
      description: tr.changeNameBody,
      actionLabel: tr.save,
      actionIcon: Icons.check_rounded,
      loading: _loading,
      onSubmit: _save,
      fields: [
        AppTextField(
          controller: _name,
          label: tr.fullName,
          icon: Icons.person_outline_rounded,
          autofocus: true,
          textInputAction: TextInputAction.done,
          onSubmitted: (_) => _save(),
        ),
      ],
    );
  }
}
