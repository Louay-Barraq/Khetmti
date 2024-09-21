import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:khetmti/components/khetma_component.dart';
import 'package:khetmti/components/state_switch.dart';
import 'package:khetmti/components/top_page_box.dart';
import 'package:khetmti/pages/Khetma/Khetma_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _currentView = 'In Progress';

  @override
  void initState() {
    super.initState();
  }

  Stream<List<Map<String, dynamic>>> _getKhatmsStream() {
    final userId = FirebaseAuth.instance.currentUser?.uid;

    if (_currentView == 'In Progress') {
      return FirebaseFirestore.instance
          .collection('khatms')
          .where('participants', arrayContains: userId)
          .where('completionPercent', isLessThan: 1.0)
          .snapshots()
          .map((snapshot) => snapshot.docs.map((doc) => doc.data()).toList());
    } else {
      // Query all khatms and manually filter out the ones that the user has joined
      return FirebaseFirestore.instance
          .collection('khatms')
          .where('completionPercent',
              isLessThan: 1.0) // Only get in-progress khatms
          .snapshots()
          .map((snapshot) {
        final allKhatms = snapshot.docs.map((doc) => doc.data()).toList();

        // Filter out khatms the user has already joined
        return allKhatms.where((khetma) {
          final participants = khetma['participants'] as List<dynamic>? ?? [];
          return !participants
              .contains(userId); // Exclude if user is a participant
        }).toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            TopPageBox(),
            SizedBox(height: 25),
            StateSwitch(
              onSwitchChanged: (value) {
                setState(() {
                  _currentView = value;
                });
              },
            ),
            SizedBox(height: 20),
            Expanded(
              child: StreamBuilder<List<Map<String, dynamic>>>(
                stream: _getKhatmsStream(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text("Error loading data"));
                  } else if (snapshot.hasData) {
                    final data = snapshot.data!;
                    if (data.isEmpty) {
                      return Center(
                        child: Text(
                          _currentView == 'In Progress'
                              ? 'لست مشارك في أي ختم حاليا'
                              : 'لا توجد ختومات متاحة للانضمام حاليا',
                          style: TextStyle(
                              fontFamily: 'Amiri',
                              fontWeight: FontWeight.bold,
                              fontSize: 25),
                        ),
                      );
                    }
                    return ListView.builder(
                      itemCount: data.length + 1,
                      itemBuilder: (context, index) {
                        if (index == data.length) {
                          return SizedBox(height: 40);
                        } else {
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => KhetmaPage(
                                          khetmaUid: data[index]['khetmaId']
                                                  ?.toString() ??
                                              '')));
                            },
                            child: KhetmaComponent(
                              title: data[index]['name'] ?? 'Unknown',
                              progress:
                                  (data[index]['completionPercent'] as num?)
                                          ?.toDouble() ??
                                      0.0,
                              participantsCount:
                                  data[index]['currentParticipantsNumber'] ?? 0,
                            ),
                          );
                        }
                      },
                    );
                  } else {
                    return Center(child: Text("No data available"));
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
