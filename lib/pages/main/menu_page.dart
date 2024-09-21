// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:khetmti/pages/actions/khetma_creation_page.dart';
import '../../components/possible_action_component.dart';
import '../../components/top_page_box.dart';
import 'package:khetmti/components/introductive_component.dart';

import '../actions/khatms_search_page.dart';
import '../actions/person_search_page.dart';

class MenuPage extends StatelessWidget {
  const MenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              TopPageBox(),
              SizedBox(height: 25),
              IntroductiveComponent(text: "الأفعــــال الممكنــــة"),
              SizedBox(height: 25),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => KhetmaCreationPage(),
                    ),
                  );
                },
                child: PossibleActionComponent(
                    actionText: "إنــــشاء ختمــــة جـــديدة"),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => KhatmsSearchPage(),
                    ),
                  );
                },
                child: PossibleActionComponent(
                    actionText: "الإنضمام لختمة موجودة"),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PersonSearchPage(),
                    ),
                  );
                },
                child:
                    PossibleActionComponent(actionText: "البــحث عـــن شخـــص"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
