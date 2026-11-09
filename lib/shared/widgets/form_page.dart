import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:khetmti/core/theme/app_theme.dart';
import 'package:khetmti/shared/widgets/khetmti_header.dart';
import 'package:khetmti/shared/widgets/motion.dart';
import 'package:khetmti/shared/widgets/primary_button.dart';

/// A page with one small form: the app header, a short explanation, the
/// fields in a white card and the main button.
class FormPage extends StatelessWidget {
  final String title;
  final String? description;
  final List<Widget> fields;
  final String actionLabel;
  final IconData? actionIcon;
  final bool loading;
  final VoidCallback onSubmit;

  const FormPage({
    super.key,
    required this.title,
    this.description,
    required this.fields,
    required this.actionLabel,
    this.actionIcon,
    required this.loading,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: Column(
        children: [
          KhetmtiHeader(
            title: title,
            showProfile: false,
            showNotification: false,
            showBackButton: true,
            onBackTap: () => context.pop(),
          ),
          Expanded(
            child: SingleChildScrollView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
              child: FadeSlideIn(
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: AppTheme.cardShadow,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      if (description != null) ...[
                        Text(
                          description!,
                          textDirection: TextDirection.rtl,
                          style: const TextStyle(
                            fontFamily: 'Amiri',
                            fontSize: 16,
                            height: 1.5,
                            color: AppTheme.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 18),
                      ],
                      for (final (i, field) in fields.indexed) ...[
                        if (i > 0) const SizedBox(height: 18),
                        field,
                      ],
                      const SizedBox(height: 26),
                      PrimaryButton(
                        label: actionLabel,
                        icon: actionIcon,
                        loading: loading,
                        onPressed: onSubmit,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
