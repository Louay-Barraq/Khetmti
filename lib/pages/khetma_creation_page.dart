// ignore_for_file: prefer_final_fields

import 'package:flutter/material.dart';
import 'package:khetmti/components/custom_button.dart';
import 'package:khetmti/components/custom_textfield.dart';

import '../components/introductive_component.dart';
import '../themes/main_theme.dart';

class KhetmaCreationPage extends StatefulWidget {
  const KhetmaCreationPage({super.key});

  @override
  State<KhetmaCreationPage> createState() => _KhetmaCreationPageState();
}

class _KhetmaCreationPageState extends State<KhetmaCreationPage> {
  final _khetmaNameController = TextEditingController();
  final _maxNumberController = TextEditingController();
  List _searchResults = [];
  bool _isLoading = false;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: MainTheme.primaryColor,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white,),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text("ختمتـــــــي",
          style: TextStyle(
            fontFamily: 'Amiri',
            fontWeight: FontWeight.bold,
            fontSize: 28,
            color: Colors.white,
            shadows: const [
              Shadow(
                  offset: Offset(0, 4),
                  blurRadius: 2.5,
                  color: Color(0x3F000000)),
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
              Center(child: IntroductiveComponent(text: "إنــــشاء ختمــــة جـــديدة")),
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
              CustomButton(text: "إنــــشاء"),
            ],
          ),
        ),
      ),
    );
  }
}
