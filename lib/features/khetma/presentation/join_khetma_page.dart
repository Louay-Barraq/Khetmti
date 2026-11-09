import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:khetmti/core/theme/app_theme.dart';
import 'package:khetmti/core/utils/helpers.dart';
import 'package:khetmti/features/khetma/models/khetma.dart';
import 'package:khetmti/features/khetma/providers/khetma_provider.dart';
import 'package:khetmti/shared/widgets/app_text_field.dart';
import 'package:khetmti/shared/widgets/khetmti_header.dart';
import 'package:khetmti/shared/widgets/motion.dart';
import 'package:khetmti/shared/widgets/primary_button.dart';
import 'package:khetmti/shared/widgets/sliding_segments.dart';

class JoinKhetmaPage extends ConsumerStatefulWidget {
  const JoinKhetmaPage({super.key});

  @override
  ConsumerState<JoinKhetmaPage> createState() => _JoinKhetmaPageState();
}

class _JoinKhetmaPageState extends ConsumerState<JoinKhetmaPage> {
  final _code = TextEditingController();
  final _search = TextEditingController();
  bool _byCode = true;
  bool _joining = false;
  String? _joiningId;
  bool _searching = false;
  List<Khetma>? _results;

  /// Joins, then opens the khatma in place of this page.
  Future<void> _join(Future<String?> Function() join) async {
    setState(() => _joining = true);
    try {
      final id = await join();
      if (id == null) {
        showErrorToast('الرمز غير صحيح أو الختمة غير موجودة');
      } else {
        HapticFeedback.mediumImpact();
        showSuccessToast('تم الانضمام بنجاح!');
        if (mounted) context.pushReplacement('/khetma/$id');
        return;
      }
    } catch (e) {
      showErrorToast(e.toString().replaceFirst('Exception: ', ''));
    }
    if (mounted) {
      setState(() {
        _joining = false;
        _joiningId = null;
      });
    }
  }

  void _joinByCode() {
    final code = _code.text.trim();
    if (code.length != 5) {
      showErrorToast('يرجى إدخال رمز مكون من 5 أرقام');
      return;
    }
    FocusScope.of(context).unfocus();
    _join(() => ref.read(khetmaRepositoryProvider).joinByCode(code));
  }

  void _joinById(String id) {
    setState(() => _joiningId = id);
    _join(() async {
      await ref.read(khetmaRepositoryProvider).joinKhetma(id);
      return id;
    });
  }

  Future<void> _searchByName() async {
    final name = _search.text.trim();
    if (name.isEmpty) return;
    FocusScope.of(context).unfocus();
    setState(() => _searching = true);
    try {
      final results = await ref.read(khetmaRepositoryProvider).searchByName(name);
      if (mounted) setState(() => _results = results);
    } catch (_) {
      showErrorToast('حدث خطأ أثناء البحث');
    } finally {
      if (mounted) setState(() => _searching = false);
    }
  }

  @override
  void dispose() {
    _code.dispose();
    _search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: Column(
        children: [
          KhetmtiHeader(
            title: 'الانضمام لختمة',
            showProfile: false,
            showNotification: false,
            showBackButton: true,
            onBackTap: () => context.pop(),
            bottom: SlidingSegments(
              dark: true,
              segmentWidth: 120,
              labels: const ['بالرمز', 'بالاسم'],
              selected: _byCode ? 0 : 1,
              onChanged: (i) => setState(() => _byCode = i == 0),
            ),
          ),
          Expanded(
            child: SmoothSwitcher(
              child: SingleChildScrollView(
                key: ValueKey(_byCode),
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
                child: _byCode ? _codeView() : _nameView(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _codeView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        FadeSlideIn(
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: AppTheme.cardShadow,
            ),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: const BoxDecoration(
                    color: AppTheme.softGreen,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.vpn_key_rounded,
                      size: 36, color: AppTheme.primaryColor),
                ),
                const SizedBox(height: 16),
                const Text(
                  'أدخل رمز الانضمام',
                  style: TextStyle(
                    fontFamily: 'Amiri',
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textPrimary,
                  ),
                ),
                const Text(
                  'رمز من 5 أرقام تجده في صفحة الختمة لدى أي مشارك',
                  textAlign: TextAlign.center,
                  textDirection: TextDirection.rtl,
                  style: TextStyle(
                    fontFamily: 'Amiri',
                    fontSize: 15,
                    color: AppTheme.textSecondary,
                  ),
                ),
                const SizedBox(height: 22),
                TextField(
                  controller: _code,
                  autofocus: true,
                  maxLength: 5,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  textAlign: TextAlign.center,
                  textInputAction: TextInputAction.go,
                  onSubmitted: (_) => _joinByCode(),
                  style: const TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 14,
                    color: AppTheme.textPrimary,
                  ),
                  decoration: InputDecoration(
                    counterText: '',
                    hintText: '•••••',
                    hintStyle: const TextStyle(
                      color: AppTheme.borderColor,
                      letterSpacing: 14,
                    ),
                    filled: true,
                    fillColor: AppTheme.backgroundColor,
                    contentPadding: const EdgeInsets.symmetric(vertical: 16),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(18),
                      borderSide: const BorderSide(color: AppTheme.borderColor),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(18),
                      borderSide: const BorderSide(
                          color: AppTheme.primaryColor, width: 1.6),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 24),
        FadeSlideIn(
          index: 1,
          child: PrimaryButton(
            label: 'انضم الآن',
            icon: Icons.group_add_rounded,
            loading: _joining,
            onPressed: _joinByCode,
          ),
        ),
      ],
    );
  }

  Widget _nameView() {
    final results = _results;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppTextField(
          controller: _search,
          label: 'اسم الختمة',
          hint: 'مثال: جدي رحمه الله',
          icon: Icons.search_rounded,
          autofocus: true,
          textInputAction: TextInputAction.search,
          onSubmitted: (_) => _searchByName(),
        ),
        const SizedBox(height: 20),
        if (_searching)
          const Center(child: CircularProgressIndicator())
        else if (results != null && results.isEmpty)
          const Padding(
            padding: EdgeInsets.only(top: 24),
            child: Text(
              'لا توجد ختمة بهذا الاسم',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 17, color: AppTheme.textSecondary),
            ),
          )
        else if (results != null)
          for (final (i, k) in results.indexed)
            FadeSlideIn(index: i, child: _resultTile(k)),
      ],
    );
  }

  Widget _resultTile(Khetma k) {
    final full = k.currentParticipantsNumber >= k.maxParticipantsNumber;
    final unit = k.splitType == 'sura' ? 'بالسور' : 'بالأجزاء';
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.fromLTRB(12, 12, 16, 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: AppTheme.cardShadow,
      ),
      child: Row(
        textDirection: TextDirection.rtl,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              textDirection: TextDirection.rtl,
              children: [
                Text(
                  'ختمة لفائدة ${k.name}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textDirection: TextDirection.rtl,
                  style: const TextStyle(
                    fontFamily: 'Amiri',
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textPrimary,
                  ),
                ),
                Text(
                  '${k.currentParticipantsNumber}/${k.maxParticipantsNumber} مشاركين · $unit · ${(k.completionPercent * 100).round()}%',
                  textDirection: TextDirection.rtl,
                  style: const TextStyle(
                    fontFamily: 'Amiri',
                    fontSize: 14,
                    color: AppTheme.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          SizedBox(
            width: 96,
            child: full
                ? const Center(
                    child: Text(
                      'مكتملة العدد',
                      style: TextStyle(fontSize: 14, color: AppTheme.textMuted),
                    ),
                  )
                : PrimaryButton(
                    label: 'انضمام',
                    loading: _joining && _joiningId == k.khetmaId,
                    onPressed: _joining ? null : () => _joinById(k.khetmaId),
                  ),
          ),
        ],
      ),
    );
  }
}
