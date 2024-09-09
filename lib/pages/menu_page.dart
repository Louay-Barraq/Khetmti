// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:khetmti/pages/search_friends_page.dart';
import '../components/possible_action_component.dart';
import '../components/top_page_box.dart';
import 'package:khetmti/components/introductive_component.dart';

class MenuPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            TopPageBox(),
            SizedBox(height: 25),
            IntroductiveComponent(text: "الأفعــــال الممكنــــة"),
            SizedBox(height: 25),
            PossibleActionComponent(actionText: "بدء ختمــــة جـــديدة"),
            PossibleActionComponent(actionText: "الإنضمام لختمة موجودة"),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SearchFriendsPage(),
                  ),
                );
              },
              child: PossibleActionComponent(actionText: "إضــافة صــديق(ة)"),
            ),
          ],
        ),
      ),
    );
  }
}
