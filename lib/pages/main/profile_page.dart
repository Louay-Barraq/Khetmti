import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:khetmti/components/friend_component.dart';
import 'package:khetmti/components/khetma_component.dart';
import 'package:khetmti/components/profile_state_switch.dart';
import 'package:khetmti/components/profile_top_page_box.dart';

import '../Khetma/Khetma_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String _currentView = 'Your Friends';
  Stream<Map<String, dynamic>>? _profileTopDataStream;

  @override
  void initState() {
    super.initState();
    _profileTopDataStream = _fetchProfileTopDataStream();
  }

  Stream<Map<String, dynamic>> _fetchProfileTopDataStream() {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .snapshots()
        .map((doc) => doc.data() as Map<String, dynamic>);
  }

  Stream<List<Map<String, dynamic>>> _fetchDataStream() {
    if (_currentView == 'Your Friends') {
      return _fetchFriendsStream();
    } else {
      return _fetchKhatmsStream();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            StreamBuilder<Map<String, dynamic>>(
              stream: _profileTopDataStream,
              builder: (context, snapshot) {
                return ProfileTopPageBox(
                  userData: snapshot.data,
                  isLoading:
                      snapshot.connectionState == ConnectionState.waiting,
                );
              },
            ),
            SizedBox(height: 25),
            ProfileStateSwitch(
              onSwitchChanged: (value) {
                setState(() {
                  _currentView = value;
                });
              },
            ),
            SizedBox(height: 20),
            Expanded(
              child: StreamBuilder<List<Map<String, dynamic>>>(
                stream: _fetchDataStream(),
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
                        _currentView == 'Your Friends'
                            ? 'ليس لديك أصدقاء حاليا'
                            : 'لست مشارك في أي ختم حاليا',
                        style: TextStyle(
                            fontFamily: 'Amiri',
                            fontWeight: FontWeight.bold,
                            fontSize: 25),
                      ));
                    }

                    return ListView.builder(
                      itemCount: data.length + 1,
                      itemBuilder: (context, index) {
                        if (index == data.length) {
                          return SizedBox(height: 40);
                        }
                        if (_currentView == 'Your Friends') {
                          return FriendComponent(
                            username: data[index]['username'] ?? 'Unknown',
                            level: data[index]['level'] ?? '0',
                          );
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

Stream<List<Map<String, dynamic>>> _fetchFriendsStream() {
  final userId = FirebaseAuth.instance.currentUser?.uid;

  return FirebaseFirestore.instance
      .collection('users')
      .doc(userId)
      .snapshots()
      .asyncMap((snapshot) async {
    List<dynamic> friendsUids = snapshot.data()?['friends'] ?? [];

    if (friendsUids.isEmpty) {
      return [];
    }

    final friendsQuerySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .where(FieldPath.documentId, whereIn: friendsUids)
        .get();

    List<Map<String, dynamic>> friendsList =
        friendsQuerySnapshot.docs.map((doc) => doc.data()).toList();

    return friendsList;
  });
}

Stream<List<Map<String, dynamic>>> _fetchKhatmsStream() {
  return FirebaseFirestore.instance
      .collection('khatms')
      .where('participants',
          arrayContains: FirebaseAuth.instance.currentUser!.uid)
      .where('completionPercent', isLessThan: 1.0)
      .snapshots()
      .map((snapshot) => snapshot.docs.map((doc) => doc.data()).toList());
}
