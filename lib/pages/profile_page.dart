import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:khetmti/components/friend_component.dart';
import 'package:khetmti/components/khetma_component.dart';
import 'package:khetmti/components/profile_state_switch.dart';
import 'package:khetmti/components/profile_top_page_box.dart';
import '../auth/auth_service.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String _currentView = 'Your Friends';
  Future<Map<String, dynamic>>? _profileTopDataFuture;
  Future<List<Map<String, dynamic>>>? _dataFuture;
  bool _isProfileTopLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchProfileTopData();
    _dataFuture =
        _fetchData();
  }

  Future<void> _fetchProfileTopData() async {
    final authService = AuthService();
    try {
      final data = await authService.getUserData();
      setState(() {
        _profileTopDataFuture = Future.value(data);
        _isProfileTopLoading = false;
      });
    } catch (e) {
      print("Error fetching profile data: $e");
      setState(() {
        _profileTopDataFuture = Future.error(e);
        _isProfileTopLoading = false;
      });
    }
  }

  Future<List<Map<String, dynamic>>> _fetchData() async {
    if (_currentView == 'Your Friends') {
      return _fetchFriends();
    } else {
      return _fetchKhatms();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            FutureBuilder<Map<String, dynamic>>(
              future: _profileTopDataFuture,
              builder: (context, snapshot) {
                return ProfileTopPageBox(
                  userData: snapshot.data,
                  isLoading: _isProfileTopLoading,
                );
              },
            ),
            SizedBox(height: 25),
            ProfileStateSwitch(
              onSwitchChanged: (value) {
                setState(() {
                  _currentView = value;
                  _dataFuture =
                      _fetchData(); // Fetch data based on the selected view
                });
              },
            ),
            SizedBox(height: 20),
            Expanded(
              child: FutureBuilder<List<Map<String, dynamic>>>(
                future: _dataFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text("Error loading data"));
                  } else if (snapshot.hasData) {
                    final data = snapshot.data!;
                    if (data.isEmpty) {
                      if (_currentView == 'Your Friends') {
                        return Center(
                            child: Text(
                          'ليس لديك أصدقاء حاليا',
                          style: TextStyle(
                              fontFamily: 'Amiri',
                              fontWeight: FontWeight.bold,
                              fontSize: 25),
                        ));
                      } else {
                        return Center(
                            child: Text(
                          'لست مشارك في أي ختم حاليا',
                          style: TextStyle(
                              fontFamily: 'Amiri',
                              fontWeight: FontWeight.bold,
                              fontSize: 25),
                        ));
                      }
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
                          return KhetmaComponent(
                            title: data[index]['title'] ?? 'Unknown',
                            progress: data[index]['progress'] ?? 0.0,
                            participantsCount: data[index]['participants'] ?? 0,
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

Future<List<Map<String, dynamic>>> _fetchFriends() async {
  final userId = FirebaseAuth.instance.currentUser?.uid;
  try {
    final snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .get();

    List<dynamic> friendsUids = snapshot.data()?['friends'] ?? [];

    if (friendsUids.isEmpty) {
      return [];
    }

    List<Map<String, dynamic>> friendsList = [];
    for (String friendUid in friendsUids) {
      DocumentSnapshot friendDoc = await FirebaseFirestore.instance.collection('users').doc(friendUid).get();
      if (friendDoc.exists && friendDoc.data() != null) {
        friendsList.add(friendDoc.data() as Map<String, dynamic>);
      }
    }

    return friendsList;
  } catch (e) {
    print("Error fetching friends: $e");
    return [];
  }
}

Future<List<Map<String, dynamic>>> _fetchKhatms() async {
  final userId = FirebaseAuth.instance.currentUser?.uid;
  if (userId == null) return [];

  try {
    final snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('khatms')
        .get();

    return snapshot.docs.map((doc) => doc.data()).toList();
  } catch (e) {
    print("Error fetching khatms: $e");
    return [];
  }
}
