import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:khetmti/components/custom_button.dart';
import 'package:khetmti/components/custom_textfield.dart';
import 'package:khetmti/data/quran_data.dart';
import 'package:khetmti/pages/Khetma/Khetma_page.dart';
import 'package:khetmti/utils/helpers.dart';
import '../../components/introductive_component.dart';
import 'package:khetmti/components/khetmti_header.dart';
import 'package:khetmti/pages/actions/notifications_page.dart';
import '../../themes/main_theme.dart';

class KhetmaCreationPage extends StatefulWidget {
  const KhetmaCreationPage({super.key});

  @override
  State<KhetmaCreationPage> createState() => _KhetmaCreationPageState();
}

class _KhetmaCreationPageState extends State<KhetmaCreationPage> {
  final _khetmaNameController = TextEditingController();
  final _maxNumberController = TextEditingController();

  Future<String> _generateUniqueKhetmaCode() async {
    Random random = Random();
    String code = '';

    bool codeExists = true;
    while (codeExists) {
      code = (random.nextInt(90000) + 10000).toString();

      final existingKhetma = await FirebaseFirestore.instance
          .collection('khatms')
          .where('code', isEqualTo: code)
          .get();

      if (existingKhetma.docs.isEmpty) {
        codeExists = false;
      }
    }

    return code;
  }

  String _splitType = 'sura'; // 'sura' or 'juzu'

  Future<bool> _addKhetma() async {
    showLoadingDialog(context);
    final String khetmaName = _khetmaNameController.text.trim();
    final String maxNumber = _maxNumberController.text.trim();
    final String currentUserId = FirebaseAuth.instance.currentUser!.uid;

    if (khetmaName.isEmpty || maxNumber.isEmpty) {
      showErrorToast("يرجى ملء جميع الحقول");
      if (mounted) dismissLoadingDialog(context);
      return false;
    }

    final int? maxNumberInt = int.tryParse(maxNumber);
    if (maxNumberInt == null || maxNumberInt <= 0) {
      showErrorToast("يرجى إدخال عدد صحيح موجب للمشاركين");
      if (mounted) dismissLoadingDialog(context);
      return false;
    }

    try {
      String uniqueCode = await _generateUniqueKhetmaCode();

      DocumentReference khetmaRef =
          FirebaseFirestore.instance.collection('khatms').doc();

      List<String> items = _splitType == 'sura' ? sourasWithAyahs.keys.toList() : juzusList;

      Map<String, dynamic> khetmaData = {
        'name': khetmaName,
        'code': uniqueCode,
        'creatorId': currentUserId,
        'participants': [currentUserId],
        'currentParticipantsNumber': 1,
        'maxParticipantsNumber': maxNumberInt,
        'parts': getEmptyPartsMap(items),
        'splitType': _splitType,
        'completionPercent': 0.0,
        'finishedParts': 0,
        'totalParts': items.length,
        'createdAt': FieldValue.serverTimestamp(),
        'khetmaId': khetmaRef.id,
        'logs': [], // Initial empty logs
      };

      await khetmaRef.set(khetmaData);

      await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUserId)
          .update({
        'khatmsJoined': FieldValue.arrayUnion([khetmaRef.id]),
      });

      if (mounted) dismissLoadingDialog(context);

      showSuccessToast("تم إنشاء الختمة بنجاح");

      _khetmaNameController.clear();
      _maxNumberController.clear();

      await Future.delayed(const Duration(seconds: 1));

      if (!mounted) return true;
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => KhetmaPage(khetmaUid: khetmaRef.id),
        ),
      );
      return true;
    } catch (e) {
      debugPrint("Error creating khatma: $e");
      if (mounted) dismissLoadingDialog(context);
      showErrorToast("حدث خطأ أثناء إنشاء الختمة");
      return false;
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
      backgroundColor: MainTheme.backgroundColor,
      resizeToAvoidBottomInset: false,
      body: Column(
        children: [
          KhetmtiHeader(
            title: "إنــــشاء ختمــــة",
            showProfile: false,
            showBackButton: true,
            onBackTap: () => Navigator.pop(context),
            onNotificationTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const NotificationsPage()),
            ),
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
                        color: MainTheme.textPrimary,
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
                              color: _splitType == 'juzu' ? MainTheme.primaryColor : Colors.white,
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(
                                color: _splitType == 'juzu' ? MainTheme.primaryColor : MainTheme.primaryColor.withOpacity(0.3),
                              ),
                            ),
                            child: Text(
                              "أجزاء (30 جزء)",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily: 'Amiri',
                                fontWeight: FontWeight.bold,
                                color: _splitType == 'juzu' ? Colors.white : MainTheme.textPrimary,
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
                              color: _splitType == 'sura' ? MainTheme.primaryColor : Colors.white,
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(
                                color: _splitType == 'sura' ? MainTheme.primaryColor : MainTheme.primaryColor.withOpacity(0.3),
                              ),
                            ),
                            child: Text(
                              "سور (114 سورة)",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily: 'Amiri',
                                fontWeight: FontWeight.bold,
                                color: _splitType == 'sura' ? Colors.white : MainTheme.textPrimary,
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
