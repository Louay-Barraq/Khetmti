// ignore_for_file: avoid_print, prefer_final_fields

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:khetmti/components/friend_addition_component.dart';
import 'package:khetmti/components/introductive_component.dart';
import 'package:khetmti/components/top_page_box.dart';
import '../themes/main_theme.dart';

class KhatmsSearchPage extends StatefulWidget {
  const KhatmsSearchPage({super.key});

  @override
  _KhatmsSearchPageState createState() => _KhatmsSearchPageState();
}

class _KhatmsSearchPageState extends State<KhatmsSearchPage> {
  final _controller = TextEditingController();
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
              Center(child: IntroductiveComponent(text: "البــحث عـــن خــتمة موجودة")),
              SizedBox(height: 20),
              Container(
                width: MediaQuery.of(context).size.width - 40,
                height: 45,
                decoration: BoxDecoration(
                  color: MainTheme.greyishColor,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: TextFormField(
                  controller: _controller,
                  textDirection: TextDirection.rtl,
                  style: TextStyle(
                    fontFamily: 'Amiri',
                    fontSize: 18,
                  ),
                  decoration: InputDecoration(
                    contentPadding:
                    EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    prefixIcon: IconButton(
                      icon: Icon(Icons.search),
                      onPressed: () {},
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              _isLoading
                  ? Center(child: CircularProgressIndicator())
                  : SizedBox(
                height: MediaQuery.of(context).size.height * 0.6, // Adjust for the keyboard
                child: ListView.builder(
                  itemCount: _searchResults.length + 1,
                  itemBuilder: (context, index) {
                    if (_searchResults.isEmpty) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        child: Center(
                          child: Text(
                            'لا توجد ختمة بهذا الاسم',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: 'Amiri',
                              fontSize: 24,
                              color: Colors.black54,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      );
                    }
                    if (index == _searchResults.length) {
                      return SizedBox(height: 80);
                    }
                    final friendData = _searchResults[index];
                    return Container();
                  },
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}
