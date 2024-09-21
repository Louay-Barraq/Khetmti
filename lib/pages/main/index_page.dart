// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:khetmti/components/bottom_nav_bar_with_draggable_sheet.dart';
import 'package:khetmti/pages/main/settings_page.dart';
import 'home_page.dart';
import 'menu_page.dart';
import 'profile_page.dart';

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
              children: const [
                SizedBox(height: 200),
                Center(
                  child: Text(
                    'ميــزة غيــر متاحــة حــاليا',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Amiri',
                      fontSize: 28,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
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
