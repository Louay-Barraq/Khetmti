import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:khetmti/core/theme/app_theme.dart';
import 'package:khetmti/core/utils/helpers.dart';
import 'package:khetmti/features/khetma/providers/khetma_provider.dart';
import 'package:khetmti/shared/widgets/app_text_field.dart';
import 'package:khetmti/shared/widgets/khetmti_header.dart';
import 'package:khetmti/shared/widgets/motion.dart';
import 'package:khetmti/shared/widgets/primary_button.dart';
import 'package:khetmti/l10n/l10n.dart';

class KhetmaCreationPage extends ConsumerStatefulWidget {
  const KhetmaCreationPage({super.key});

  @override
  ConsumerState<KhetmaCreationPage> createState() => _KhetmaCreationPageState();
}

class _KhetmaCreationPageState extends ConsumerState<KhetmaCreationPage> {
  static const _maxAllowed = 114;

  final _name = TextEditingController();
  int _maxParticipants = 10;
  String _splitType = 'sura';
  bool _loading = false;

  Future<void> _create() async {
    final name = _name.text.trim();
    if (name.isEmpty) {
      showErrorToast(tr.khatmaForRequired);
      return;
    }

    FocusScope.of(context).unfocus();
    setState(() => _loading = true);
    try {
      final id = await ref.read(khetmaRepositoryProvider).createKhetma(
            name: name,
            splitType: _splitType,
            maxParticipants: _maxParticipants,
          );
      HapticFeedback.mediumImpact();
      showSuccessToast(tr.khatmaCreated);
      if (mounted) context.pushReplacement('/khetma/$id');
    } catch (e) {
      debugPrint('Error creating khatma: $e');
      if (mounted) setState(() => _loading = false);
      showErrorToast(tr.createKhatmaError);
    }
  }

  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: Column(
        children: [
          KhetmtiHeader(
            title: tr.createKhatmaTitle,
            showProfile: false,
            showNotification: false,
            showBackButton: true,
            onBackTap: () => context.pop(),
          ),
          Expanded(
            child: SingleChildScrollView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  FadeSlideIn(
                    child: _card(
                      AppTextField(
                        controller: _name,
                        label: tr.khatmaFor,
                        hint: tr.khatmaForHint,
                        icon: Icons.favorite_border_rounded,
                        textInputAction: TextInputAction.done,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  FadeSlideIn(index: 1, child: _card(_participantsStepper())),
                  const SizedBox(height: 16),
                  FadeSlideIn(index: 2, child: _card(_splitSelector())),
                  const SizedBox(height: 28),
                  FadeSlideIn(
                    index: 3,
                    child: PrimaryButton(
                      label: tr.createKhatmaButton,
                      icon: Icons.add_rounded,
                      loading: _loading,
                      onPressed: _create,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _card(Widget child) => Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: AppTheme.cardShadow,
        ),
        child: child,
      );

  Widget _label(String text, String hint) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            text,
            style: TextStyle(
              fontFamily: AppTheme.font,
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppTheme.textPrimary,
            ),
          ),
          Text(
            hint,
            style: TextStyle(
              fontFamily: AppTheme.font,
              fontSize: 14,
              color: AppTheme.textSecondary,
            ),
          ),
        ],
      );

  Widget _participantsStepper() {
    Widget button(IconData icon, int delta) {
      final next = _maxParticipants + delta;
      final enabled = next >= 1 && next <= _maxAllowed;
      return Pressable(
        onTap: enabled
            ? () {
                HapticFeedback.selectionClick();
                setState(() => _maxParticipants = next);
              }
            : null,
        pressedScale: 0.88,
        child: AnimatedContainer(
          duration: AppTheme.fast,
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: enabled ? AppTheme.softGreen : AppTheme.backgroundColor,
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            color: enabled ? AppTheme.primaryColor : AppTheme.textMuted,
          ),
        ),
      );
    }

    return Row(
      children: [
        Expanded(child: _label(tr.maxParticipants, tr.includingYou)),
        button(Icons.add_rounded, 1),
        SizedBox(
          width: 52,
          child: AnimatedSwitcher(
            duration: AppTheme.fast,
            transitionBuilder: (child, a) =>
                ScaleTransition(scale: a, child: child),
            child: Text(
              '$_maxParticipants',
              key: ValueKey(_maxParticipants),
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontFamily: 'Roboto',
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppTheme.textPrimary,
              ),
            ),
          ),
        ),
        button(Icons.remove_rounded, -1),
      ],
    );
  }

  Widget _splitSelector() {
    Widget option(String value, String title, String detail, IconData icon) {
      final on = _splitType == value;
      return Expanded(
        child: Pressable(
          onTap: () => setState(() => _splitType = value),
          child: AnimatedContainer(
            duration: AppTheme.fast,
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
            decoration: BoxDecoration(
              color: on ? AppTheme.softGreen : Colors.white,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: on ? AppTheme.primaryColor : AppTheme.borderColor,
                width: on ? 1.8 : 1,
              ),
            ),
            child: Column(
              children: [
                Icon(icon,
                    color: on ? AppTheme.primaryColor : AppTheme.textMuted,
                    size: 28),
                const SizedBox(height: 6),
                Text(
                  title,
                  style: TextStyle(
                    fontFamily: AppTheme.font,
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: on ? AppTheme.primaryColor : AppTheme.textPrimary,
                  ),
                ),
                Text(
                  detail,
                  style: TextStyle(
                    fontFamily: AppTheme.font,
                    fontSize: 13,
                    color: AppTheme.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _label(tr.splitKhatma, tr.splitKhatmaDesc),
        const SizedBox(height: 14),
        Row(
          children: [
            option('sura', tr.bySurah, tr.surahCount, Icons.auto_stories_outlined),
            const SizedBox(width: 12),
            option('juzu', tr.byJuz, tr.juzCount, Icons.view_agenda_outlined),
          ],
        ),
      ],
    );
  }
}
