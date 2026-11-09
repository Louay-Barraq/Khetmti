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
      showErrorToast('اكتب لمن هذه الختمة');
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
      showSuccessToast('تم إنشاء الختمة بنجاح');
      if (mounted) context.pushReplacement('/khetma/$id');
    } catch (e) {
      debugPrint('Error creating khatma: $e');
      if (mounted) setState(() => _loading = false);
      showErrorToast('حدث خطأ أثناء إنشاء الختمة');
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
            title: 'إنشاء ختمة',
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
                        label: 'ختمة لفائدة',
                        hint: 'مثال: جدي رحمه الله',
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
                      label: 'إنشاء الختمة',
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
        textDirection: TextDirection.rtl,
        children: [
          Text(
            text,
            style: const TextStyle(
              fontFamily: 'Amiri',
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppTheme.textPrimary,
            ),
          ),
          Text(
            hint,
            textDirection: TextDirection.rtl,
            style: const TextStyle(
              fontFamily: 'Amiri',
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
      textDirection: TextDirection.rtl,
      children: [
        Expanded(child: _label('العدد الأقصى للمشاركين', 'بمن فيهم أنت')),
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
                    fontFamily: 'Amiri',
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: on ? AppTheme.primaryColor : AppTheme.textPrimary,
                  ),
                ),
                Text(
                  detail,
                  style: const TextStyle(
                    fontFamily: 'Amiri',
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
        _label('تقسيم الختمة', 'كل مشارك يحجز ما سيقرؤه'),
        const SizedBox(height: 14),
        Row(
          textDirection: TextDirection.rtl,
          children: [
            option('sura', 'بالسور', '114 سورة', Icons.auto_stories_outlined),
            const SizedBox(width: 12),
            option('juzu', 'بالأجزاء', '30 جزءاً', Icons.view_agenda_outlined),
          ],
        ),
      ],
    );
  }
}
