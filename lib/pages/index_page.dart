// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:khetmti/components/bottom_nav_bar_with_draggable_sheet.dart';
import 'package:khetmti/pages/home_page.dart';
import 'package:khetmti/pages/profile_page.dart';
import 'package:khetmti/pages/settings_page.dart';

import 'menu_page.dart';

class IndexPage extends StatefulWidget {
  const IndexPage({super.key});

  @override
  State<IndexPage> createState() => _IndexPageState();
}

class _IndexPageState extends State<IndexPage> {
  final PageController _pageController = PageController();
  int _selectedIndex = 0;

  List<Widget> pages = [
    HomePage(),
    MenuPage(),
    SettingsPage(),
    ProfilePage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    _pageController.jumpToPage(index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            controller: _pageController,
            children: pages,
            onPageChanged: (index) {
              setState(() {
                _selectedIndex = index;
              });
            },
          ),
          MyDraggableSheet(
            child: Column(
              children: List.generate(3, (_) => BottomSheetDummyUI()),
            ),
          ),
        ],
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}
