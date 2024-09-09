// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:khetmti/components/khetma_component.dart';
import 'package:khetmti/components/state_switch.dart';
import 'package:khetmti/components/top_page_box.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            TopPageBox(),
            SizedBox(height: 25),
            StateSwitch(),
            SizedBox(height: 20),
            KhetmetList(itemsList: 5),
          ],
        ),
      ),
    );
  }
}

Widget KhetmetList({required int itemsList}) {
  return Expanded(
    child: LayoutBuilder(
      builder: (context, constraints) {
        return ListView.builder(
          itemCount: itemsList + 1, // Adjust this number as needed
          itemBuilder: (context, index) {
            if (index == itemsList) {
              return SizedBox(height: 40); // Blank space
            } else if (index == 1) {
              return Padding(
                padding: const EdgeInsets.only(top: 5),
                child: KhetmaComponent(
                  title: 'Test',
                  progress: 0.50,
                  participantsCount: 20,
                ),
              );
            } else {
              return KhetmaComponent(
                title: 'Test',
                progress: 0.70,
                participantsCount: 20,
              );
            }
          },
        );
      },
    ),
  );
}
