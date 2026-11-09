import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:khetmti/core/theme/app_theme.dart';
import 'package:khetmti/core/utils/helpers.dart';
import 'package:khetmti/features/khetma/models/khetma.dart';
import 'package:khetmti/features/khetma/providers/khetma_provider.dart';
import 'package:khetmti/shared/widgets/khetmti_header.dart';

class JoinKhetmaPage extends ConsumerStatefulWidget {
  const JoinKhetmaPage({super.key});

  @override
  ConsumerState<JoinKhetmaPage> createState() => _JoinKhetmaPageState();
}

class _JoinKhetmaPageState extends ConsumerState<JoinKhetmaPage> {
  final TextEditingController _codeController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();
  bool _isLoading = false;
  String _joinMethod = 'code';
  List<Khetma> _searchResults = [];

  Future<void> _joinKhatma(String khetmaId) async {
    setState(() => _isLoading = true);
    showLoadingDialog(context);

    try {
      await ref.read(khetmaRepositoryProvider).joinKhetma(khetmaId);

      if (mounted) {
        dismissLoadingDialog(context);
        showSuccessToast("تم الانضمام بنجاح!");
        context.pop();
      }
    } catch (e) {
      if (mounted) {
        dismissLoadingDialog(context);
        setState(() => _isLoading = false);
      }
      showErrorToast(e.toString().replaceFirst('Exception: ', ''));
    }
  }

  Future<void> _searchByName() async {
    final name = _searchController.text.trim();
    if (name.isEmpty) return;

    setState(() => _isLoading = true);
    try {
      final results =
          await ref.read(khetmaRepositoryProvider).searchByName(name);
      setState(() {
        _searchResults = results;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      showErrorToast("حدث خطأ أثناء البحث");
    }
  }

  Future<void> _joinByCode() async {
    final code = _codeController.text.trim();
    if (code.length != 5) {
      showErrorToast("يرجى إدخال رمز مكون من 5 أرقام");
      return;
    }

    setState(() => _isLoading = true);
    showLoadingDialog(context);

    try {
      final khetmaId =
          await ref.read(khetmaRepositoryProvider).joinByCode(code);

      if (khetmaId == null) {
        if (mounted) {
          dismissLoadingDialog(context);
          setState(() => _isLoading = false);
        }
        showErrorToast("الرمز غير صحيح أو الختمة غير موجودة");
        return;
      }

      if (mounted) {
        dismissLoadingDialog(context);
        showSuccessToast("تم الانضمام بنجاح!");
        context.pop();
      }
    } catch (e) {
      if (mounted) {
        dismissLoadingDialog(context);
        setState(() => _isLoading = false);
      }
      showErrorToast(e.toString().replaceFirst('Exception: ', ''));
    }
  }

  @override
  void dispose() {
    _codeController.dispose();
    _searchController.dispose();
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
            showNotification: false,
            showProfile: false,
            showBackButton: true,
            onBackTap: () => context.pop(),
          ),
          const SizedBox(height: 20),
          _buildMethodChoice(),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: _joinMethod == 'code'
                  ? _buildCodeView()
                  : _buildNameView(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMethodChoice() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 40),
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: AppTheme.secondaryColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Expanded(child: _buildChoiceItem('بواسطة الإسم', 'name')),
          Expanded(child: _buildChoiceItem('بواسطة الرمز', 'code')),
        ],
      ),
    );
  }

  Widget _buildChoiceItem(String label, String method) {
    bool isSelected = _joinMethod == method;
    return GestureDetector(
      onTap: () => setState(() {
        _joinMethod = method;
        _searchResults = [];
      }),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.primaryColor : Colors.transparent,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              fontFamily: 'Amiri',
              fontWeight: FontWeight.bold,
              color: isSelected ? Colors.white : AppTheme.textSecondary,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCodeView() {
    return Column(
      children: [
        const SizedBox(height: 20),
        const Icon(Icons.vpn_key_outlined,
            size: 80, color: AppTheme.primaryColor),
        const SizedBox(height: 24),
        const Text(
          'أدخل رمز الانضمام',
          style: TextStyle(
              fontFamily: 'Amiri',
              fontSize: 24,
              fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        const Text(
          'الرمز مكون من 5 أرقام حصلت عليه من منشئ الختمة',
          textAlign: TextAlign.center,
          style: TextStyle(
              fontFamily: 'Amiri',
              fontSize: 16,
              color: AppTheme.textSecondary),
        ),
        const SizedBox(height: 48),
        _buildCodeInput(),
        const SizedBox(height: 48),
        _buildJoinButton(),
      ],
    );
  }

  Widget _buildNameView() {
    return Column(
      children: [
        TextField(
          controller: _searchController,
          textDirection: TextDirection.rtl,
          decoration: InputDecoration(
            hintText: 'ابحث عن اسم الختمة...',
            hintStyle: const TextStyle(fontFamily: 'Amiri'),
            prefixIcon: IconButton(
              icon:
                  const Icon(Icons.search, color: AppTheme.primaryColor),
              onPressed: _searchByName,
            ),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide.none),
          ),
          onSubmitted: (_) => _searchByName(),
        ),
        const SizedBox(height: 24),
        if (_isLoading) const CircularProgressIndicator(),
        if (!_isLoading &&
            _searchResults.isEmpty &&
            _searchController.text.isNotEmpty)
          const Text('لا توجد نتائج',
              style: TextStyle(fontFamily: 'Amiri')),
        ..._searchResults.map((khetma) {
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 5)
              ],
            ),
            child: ListTile(
              title: Text(khetma.name,
                  textDirection: TextDirection.rtl,
                  style: const TextStyle(
                      fontFamily: 'Amiri',
                      fontWeight: FontWeight.bold)),
              subtitle: Text(
                  'المشاركون: ${khetma.currentParticipantsNumber}/${khetma.maxParticipantsNumber}',
                  textDirection: TextDirection.rtl),
              trailing: ElevatedButton(
                onPressed: () => _joinKhatma(khetma.khetmaId),
                style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryColor,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10))),
                child: const Text('انضمام',
                    style: TextStyle(
                        color: Colors.white, fontFamily: 'Amiri')),
              ),
            ),
          );
        }),
      ],
    );
  }

  Widget _buildCodeInput() {
    return SizedBox(
      width: 250,
      child: TextField(
        controller: _codeController,
        maxLength: 5,
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          letterSpacing: 20,
          color: AppTheme.primaryColor,
        ),
        decoration: InputDecoration(
          counterText: "",
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(
                color: AppTheme.primaryColor.withValues(alpha: 0.3),
                width: 2),
          ),
          focusedBorder: const UnderlineInputBorder(
            borderSide:
                BorderSide(color: AppTheme.primaryColor, width: 2),
          ),
          hintText: "00000",
          hintStyle: TextStyle(
              color: AppTheme.primaryColor.withValues(alpha: 0.2)),
        ),
      ),
    );
  }

  Widget _buildJoinButton() {
    return Container(
      width: double.infinity,
      height: 60,
      decoration: BoxDecoration(
        color: AppTheme.primaryColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryColor.withValues(alpha: 0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: _isLoading ? null : _joinByCode,
          child: const Center(
            child: Text(
              'انضم الآن',
              style: TextStyle(
                fontFamily: 'Amiri',
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
