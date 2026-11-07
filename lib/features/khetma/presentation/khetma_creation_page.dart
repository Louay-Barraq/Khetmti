import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:khetmti/core/theme/app_theme.dart';
import 'package:khetmti/core/utils/helpers.dart';
import 'package:khetmti/features/khetma/providers/khetma_provider.dart';
import 'package:khetmti/shared/widgets/custom_button.dart';
import 'package:khetmti/shared/widgets/custom_textfield.dart';
import 'package:khetmti/shared/widgets/khetmti_header.dart';

class KhetmaCreationPage extends ConsumerStatefulWidget {
  const KhetmaCreationPage({super.key});

  @override
  ConsumerState<KhetmaCreationPage> createState() =>
      _KhetmaCreationPageState();
}

class _KhetmaCreationPageState extends ConsumerState<KhetmaCreationPage> {
  final _khetmaNameController = TextEditingController();
  final _maxNumberController = TextEditingController();
  String _splitType = 'sura';

  Future<void> _addKhetma() async {
    final String khetmaName = _khetmaNameController.text.trim();
    final String maxNumber = _maxNumberController.text.trim();

    if (khetmaName.isEmpty || maxNumber.isEmpty) {
      showErrorToast("يرجى ملء جميع الحقول");
      return;
    }

    final int? maxNumberInt = int.tryParse(maxNumber);
    if (maxNumberInt == null || maxNumberInt <= 0) {
      showErrorToast("يرجى إدخال عدد صحيح موجب للمشاركين");
      return;
    }

    try {
      showLoadingDialog(context);

      final khetmaId =
          await ref.read(khetmaRepositoryProvider).createKhetma(
                name: khetmaName,
                splitType: _splitType,
                maxParticipants: maxNumberInt,
              );

      if (mounted) dismissLoadingDialog(context);

      showSuccessToast("تم إنشاء الختمة بنجاح");

      _khetmaNameController.clear();
      _maxNumberController.clear();

      await Future.delayed(const Duration(seconds: 1));

      if (!mounted) return;
      context.push('/khetma/$khetmaId');
    } catch (e) {
      debugPrint("Error creating khatma: $e");
      if (mounted) dismissLoadingDialog(context);
      showErrorToast("حدث خطأ أثناء إنشاء الختمة");
    }
  }

  @override
  void dispose() {
    _khetmaNameController.dispose();
    _maxNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      resizeToAvoidBottomInset: false,
      body: Column(
        children: [
          KhetmtiHeader(
            title: "إنــــشاء ختمــــة",
            showProfile: false,
            showBackButton: true,
            onBackTap: () => context.pop(),
            onNotificationTap: () => context.push('/notifications'),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  const SizedBox(height: 30),
                  CustomTextfield(
                    fieldController: _khetmaNameController,
                    fieldTitle: "خــــتمة لفائدة (بــالعربية)",
                    inArabic: true,
                    isPassword: false,
                    onlyNumber: false,
                  ),
                  const SizedBox(height: 20),
                  CustomTextfield(
                    fieldController: _maxNumberController,
                    fieldTitle: "العـــدد الأقـــصى للمشـــاركين",
                    inArabic: false,
                    isPassword: false,
                    onlyNumber: true,
                  ),
                  const SizedBox(height: 20),
                  const Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      "تقسيم الختمة حسب:",
                      style: TextStyle(
                        fontFamily: 'Amiri',
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () => setState(() => _splitType = 'juzu'),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            decoration: BoxDecoration(
                              color: _splitType == 'juzu'
                                  ? AppTheme.primaryColor
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(
                                color: _splitType == 'juzu'
                                    ? AppTheme.primaryColor
                                    : AppTheme.primaryColor
                                        .withValues(alpha: 0.3),
                              ),
                            ),
                            child: Text(
                              "أجزاء (30 جزء)",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily: 'Amiri',
                                fontWeight: FontWeight.bold,
                                color: _splitType == 'juzu'
                                    ? Colors.white
                                    : AppTheme.textPrimary,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: GestureDetector(
                          onTap: () => setState(() => _splitType = 'sura'),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            decoration: BoxDecoration(
                              color: _splitType == 'sura'
                                  ? AppTheme.primaryColor
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(
                                color: _splitType == 'sura'
                                    ? AppTheme.primaryColor
                                    : AppTheme.primaryColor
                                        .withValues(alpha: 0.3),
                              ),
                            ),
                            child: Text(
                              "سور (114 سورة)",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily: 'Amiri',
                                fontWeight: FontWeight.bold,
                                color: _splitType == 'sura'
                                    ? Colors.white
                                    : AppTheme.textPrimary,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: _addKhetma,
                      borderRadius: BorderRadius.circular(30),
                      child: const CustomButton(text: "إنــــشاء"),
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
}
