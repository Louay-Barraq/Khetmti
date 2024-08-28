import 'package:flutter/material.dart';
import 'package:khetmti/components/bottom_nav_bar_with_draggable_sheet.dart';
import 'package:khetmti/pages/index_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Khetmti',
      theme: ThemeData(
        useMaterial3: true,
      ),
      home: const MyWidget(),
    );
  }
}

class MyWidget extends StatelessWidget {
  const MyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const IndexPage();
  }
}
