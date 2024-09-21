// ignore_for_file: prefer_final_fields

import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:khetmti/components/custom_button.dart';
import 'package:khetmti/components/custom_textfield.dart';
import 'package:khetmti/pages/Khetma/Khetma_page.dart';
import '../../components/introductive_component.dart';
import '../../themes/main_theme.dart';

class KhetmaCreationPage extends StatefulWidget {
  const KhetmaCreationPage({super.key});

  @override
  State<KhetmaCreationPage> createState() => _KhetmaCreationPageState();
}

class _KhetmaCreationPageState extends State<KhetmaCreationPage> {
  final _khetmaNameController = TextEditingController();
  final _maxNumberController = TextEditingController();

  void showLoadingDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  void dismissLoadingDialog() {
    Navigator.of(context).pop();
  }

  Future<String> _generateUniqueKhetmaCode() async {
    Random random = Random();
    String code = '';

    bool codeExists = true;
    while (codeExists) {
      code = (random.nextInt(90000) + 10000).toString();

      // Check if the code already exists in the 'khetmas' collection
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

  Future<bool> _addKhetma() async {
    showLoadingDialog();
    final String khetmaName = _khetmaNameController.text.trim();
    final String maxNumber = _maxNumberController.text.trim();
    final String currentUserId = FirebaseAuth.instance.currentUser!.uid;

    if (khetmaName.isEmpty || maxNumber.isEmpty) {
      Fluttertoast.showToast(
        msg: "يرجى ملء جميع الحقول",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.SNACKBAR,
        backgroundColor: Colors.redAccent,
        textColor: Colors.white,
      );
      dismissLoadingDialog();
      return false;
    }

    final int? maxNumberInt = int.tryParse(maxNumber);
    if (maxNumberInt == null || maxNumberInt <= 0) {
      Fluttertoast.showToast(
        msg: "يرجى إدخال عدد صحيح موجب للمشاركين",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.SNACKBAR,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
      return false;
    }

    try {
      String uniqueCode = await _generateUniqueKhetmaCode();

      DocumentReference khetmaRef =
          FirebaseFirestore.instance.collection('khatms').doc();

      Map<String, dynamic> khetmaData = {
        'name': khetmaName,
        'code': uniqueCode.toString(),
        'creatorId': currentUserId,
        'participants': [currentUserId],
        'currentParticipantsNumber': 1,
        'maxParticipantsNumber': maxNumberInt,
        'souras': souras,
        'completionPercent': 0.0,
        'finishedSouras': 0,
        'unfinishedSouras': 114,
        'finishedAyahs': 0,
        'createdAt': FieldValue.serverTimestamp(),
        'khetmaId': khetmaRef.id,
      };

      await khetmaRef.set(khetmaData);

      await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUserId)
          .update({
        'khatmsJoined': FieldValue.arrayUnion([khetmaRef.id]),
      });

      dismissLoadingDialog();

      Fluttertoast.showToast(
        msg: "تم إنشاء الختمة بنجاح",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.SNACKBAR,
        backgroundColor: Colors.green,
        textColor: Colors.white,
      );

      _khetmaNameController.clear();
      _maxNumberController.clear();

      await Future.delayed(Duration(seconds: 1));

      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => KhetmaPage(khetmaUid: khetmaRef.id)));
      return true;
    } catch (e) {
      if (kDebugMode) {
        print("Error creating khatma: $e");
      }
      Fluttertoast.showToast(
        msg: "حدث خطأ أثناء إنشاء الختمة",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.SNACKBAR,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: MainTheme.primaryColor,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "ختمتـــــــي",
          style: TextStyle(
            fontFamily: 'Amiri',
            fontWeight: FontWeight.bold,
            fontSize: 28,
            color: Colors.white,
            shadows: const [
              Shadow(
                offset: Offset(0, 4),
                blurRadius: 2.5,
                color: Color(0x3F000000),
              ),
            ],
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 20),
              Center(
                  child: IntroductiveComponent(
                      text: "إنــــشاء ختمــــة جـــديدة")),
              SizedBox(height: 20),
              CustomTextfield(
                fieldController: _khetmaNameController,
                fieldTitle: "خــــتمة لفائدة (بــالعربية)",
                inArabic: true,
                isPassword: false,
                onlyNumber: false,
              ),
              SizedBox(height: 20),
              CustomTextfield(
                fieldController: _maxNumberController,
                fieldTitle: "العـــدد الأقـــصى للمشـــاركين",
                inArabic: false,
                isPassword: false,
                onlyNumber: true,
              ),
              SizedBox(height: 20),
              GestureDetector(
                onTap: _addKhetma,
                child: CustomButton(text: "إنــــشاء"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Map<String, String?> souras = {
  "الفاتحة": null,
  "البقرة": null,
  "آل عمران": null,
  "النساء": null,
  "المائدة": null,
  "الأنعام": null,
  "الأعراف": null,
  "الأنفال": null,
  "التوبة": null,
  "يونس": null,
  "هود": null,
  "يوسف": null,
  "الرعد": null,
  "إبراهيم": null,
  "الحجر": null,
  "النحل": null,
  "الإسراء": null,
  "الكهف": null,
  "مريم": null,
  "طه": null,
  "الأنبياء": null,
  "الحج": null,
  "المؤمنون": null,
  "النور": null,
  "الفرقان": null,
  "الشعراء": null,
  "النمل": null,
  "القصص": null,
  "العنكبوت": null,
  "الروم": null,
  "لقمان": null,
  "السجدة": null,
  "الأحزاب": null,
  "سبأ": null,
  "فاطر": null,
  "يس": null,
  "الصافات": null,
  "ص": null,
  "الزمر": null,
  "غافر": null,
  "فصلت": null,
  "الشورى": null,
  "الزخرف": null,
  "الدخان": null,
  "الجاثية": null,
  "الأحقاف": null,
  "محمد": null,
  "الفتح": null,
  "الحجرات": null,
  "ق": null,
  "الذاريات": null,
  "الطور": null,
  "النجم": null,
  "القمر": null,
  "الرحمن": null,
  "الواقعة": null,
  "الحديد": null,
  "المجادلة": null,
  "الحشر": null,
  "الممتحنة": null,
  "الصف": null,
  "الجمعة": null,
  "المنافقون": null,
  "التغابن": null,
  "الطلاق": null,
  "التحريم": null,
  "الملك": null,
  "القلم": null,
  "الحاقة": null,
  "المعارج": null,
  "نوح": null,
  "الجن": null,
  "المزمل": null,
  "المدثر": null,
  "القيامة": null,
  "الإنسان": null,
  "المرسلات": null,
  "النبأ": null,
  "النازعات": null,
  "عبس": null,
  "التكوير": null,
  "الانفطار": null,
  "المطففين": null,
  "الإنشقاق": null,
  "البروج": null,
  "الطارق": null,
  "الأعلى": null,
  "الغاشية": null,
  "الفجر": null,
  "البلد": null,
  "الشمس": null,
  "الليل": null,
  "الضحى": null,
  "الشرح": null,
  "التين": null,
  "العلق": null,
  "القدر": null,
  "البينة": null,
  "الزلزلة": null,
  "العاديات": null,
  "القارعة": null,
  "التكاثر": null,
  "العصر": null,
  "الهمزة": null,
  "الفيل": null,
  "قريش": null,
  "الماعون": null,
  "الكوثر": null,
  "الكافرون": null,
  "النصر": null,
  "المسد": null,
  "الإخلاص": null,
  "الفلق": null,
  "الناس": null
};
