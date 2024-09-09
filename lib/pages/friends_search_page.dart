// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:khetmti/components/friend_addition_component.dart';
import 'package:khetmti/components/introductive_component.dart';
import 'package:khetmti/components/top_page_box.dart';
import '../themes/main_theme.dart';

class FriendsSearchPage extends StatefulWidget {
  const FriendsSearchPage({super.key});

  @override
  _FriendsSearchPageState createState() => _FriendsSearchPageState();
}

class _FriendsSearchPageState extends State<FriendsSearchPage> {
  final _controller = TextEditingController();
  List _searchResults = [];
  bool _isLoading = false;

  Future _searchForFriends() async {
    final searchQuery = _controller.text.trim();

    if (searchQuery.isEmpty) {
      // Show a toast message asking for valid input
      Fluttertoast.showToast(
        msg: 'الرجاء إدخال اسم صحيح قبل البحث!',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.SNACKBAR,
        backgroundColor: Colors.orange,
        textColor: Colors.white,
        fontSize: 17.0,
      );

      _searchResults = [];

      return; // Stop the search
    }

      setState(() {
        _isLoading = true;
      });

    final currentUserId = FirebaseAuth.instance.currentUser?.uid;

    try {
      final userSearchResults = await FirebaseFirestore.instance
          .collection('users')
          .where('username', isGreaterThanOrEqualTo: searchQuery)
          .where('username', isLessThanOrEqualTo: '${searchQuery}\uf8ff')
          .get();

      final List results = [];

      for (var userDoc in userSearchResults.docs) {
        final userData = userDoc.data();
        final uid = userDoc.id;

        if (uid == currentUserId) continue; // Skip own user

        // Check if they are already friends
        final friendsSnapshot = await FirebaseFirestore.instance
            .collection('friendships')
            .where('users', arrayContains: currentUserId)
            .get();

        bool areFriends = false;
        bool hasSentRequest = false;
        bool hasReceivedRequest = false;

        for (var doc in friendsSnapshot.docs) {
          final data = doc.data();

          if (data['users'].contains(uid)) {
            areFriends = true;
            break;
          }
        }

        // Check for pending requests
        if (!areFriends) {
          final sentRequestsSnapshot = await FirebaseFirestore.instance
              .collection('friendships')
              .where('sender', isEqualTo: currentUserId)
              .where('receiver', isEqualTo: uid)
              .where('status', isEqualTo: 'pending')
              .get();

          final receivedRequestsSnapshot = await FirebaseFirestore.instance
              .collection('friendships')
              .where('sender', isEqualTo: uid)
              .where('receiver', isEqualTo: currentUserId)
              .where('status', isEqualTo: 'pending')
              .get();

          hasSentRequest = sentRequestsSnapshot.docs.isNotEmpty;
          hasReceivedRequest = receivedRequestsSnapshot.docs.isNotEmpty;
        }

        // Determine the status to show in the UI
        String status = 'none';

        if (areFriends) {
          status = 'friends';
        } else if (hasSentRequest) {
          status = 'pending';
        } else if (hasReceivedRequest) {
          status = 'received';
        }

        results.add({
          'uid': uid,
          'username': userData['username'],
          'email': userData['email'],
          'status': status,
        });
      }

      setState(() {
        _searchResults = results;
      });
    } catch (e) {
      print('Error searching for friends: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
  
  Future _handleAddFriend(String friendUid) async {
    final currentUserId = FirebaseAuth.instance.currentUser?.uid;

    try {
      await FirebaseFirestore.instance.collection('friendships').add({
        'sender': currentUserId,
        'receiver': friendUid,
        'status': 'pending',
        'timestamp': FieldValue.serverTimestamp(),
      });

      Fluttertoast.showToast(
        msg: 'تم إرسال طلب الصداقة!',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.SNACKBAR,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 17.0,
      );

      _searchForFriends();
    } catch (e) {
      print('Error sending friend request: $e');
    }
  }

  Future _handleRemoveRequest(String friendUid) async {
    final currentUserId = FirebaseAuth.instance.currentUser?.uid;

    try {
      final requestSnapshot = await FirebaseFirestore.instance
          .collection('friendships')
          .where('sender', isEqualTo: currentUserId)
          .where('receiver', isEqualTo: friendUid)
          .where('status', isEqualTo: 'pending')
          .get();

      for (var doc in requestSnapshot.docs) {
        await doc.reference.delete();
      }

      Fluttertoast.showToast(
        msg: 'تم إلغاء طلب الصداقة!',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.SNACKBAR,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 17.0,
      );

      _searchForFriends();
    } catch (e) {
      print('Error removing friend request: $e');
    }
  }

  Future _handleAcceptRequest(String friendUid) async {
    final currentUserId = FirebaseAuth.instance.currentUser?.uid;

    try {
      // Step 1: Remove the pending friend request
      final requestSnapshot = await FirebaseFirestore.instance
          .collection('friendships')
          .where('sender', isEqualTo: friendUid)
          .where('receiver', isEqualTo: currentUserId)
          .where('status', isEqualTo: 'pending')
          .get();

      for (var doc in requestSnapshot.docs) {
        await doc.reference.delete();
      }

      // Step 2: Add both users to the friendships collection
      await FirebaseFirestore.instance.collection('friendships').add({
        'users': [currentUserId, friendUid],
        'timestamp': FieldValue.serverTimestamp(),
      });

      try {
        // Add the current user to the friend's 'friends' array
        await FirebaseFirestore.instance.collection('users').doc(friendUid).update({
          'friends': FieldValue.arrayUnion([currentUserId]),
          'updatedAt': Timestamp.now(),
        });
      } catch (e) {
        print('Error updating friend array for friendUid: $friendUid, Error: $e');
      }

      try {
        // Add the friend to the current user's 'friends' array
        await FirebaseFirestore.instance.collection('users').doc(currentUserId).update({
          'friends': FieldValue.arrayUnion([friendUid]),
          'updatedAt': Timestamp.now(),
        });
      } catch (e) {
        print('Error updating friend array for currentUserId: $currentUserId, Error: $e');
      }

      Fluttertoast.showToast(
        msg: 'تم قبول طلب الصداقة!',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.SNACKBAR,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 17.0,
      );

      // Refresh the search results after accepting the request
      _searchForFriends();
    } catch (e) {
      print('Error accepting friend request: $e');
    }
  }


  Future _handleDeclineRequest(String friendUid) async {
    final currentUserId = FirebaseAuth.instance.currentUser?.uid;

    try {
      final requestSnapshot = await FirebaseFirestore.instance
          .collection('friendships')
          .where('sender', isEqualTo: friendUid)
          .where('receiver', isEqualTo: currentUserId)
          .where('status', isEqualTo: 'pending')
          .get();

      for (var doc in requestSnapshot.docs) {
        await doc.reference.delete();
      }

      Fluttertoast.showToast(
        msg: 'تم رفض طلب الصداقة',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.SNACKBAR,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 17.0,
      );

      _searchForFriends();
    } catch (e) {
      print('Error declining friend request: $e');
    }
  }

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
              Center(child: IntroductiveComponent(text: "البــحث عـــن صــديق(ة)")),
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
                      onPressed: _searchForFriends,
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
                            'لا يوجد شخص بهذا الاسم',
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
                    return FriendAdditionComponent(
                      username: friendData['username'] ?? 'Username',
                      email: friendData['email'] ?? '',
                      status: friendData['status'] ?? 'none',
                      onAdd: () => _handleAddFriend(friendData['uid']),
                      onRemove: () => _handleRemoveRequest(friendData['uid']),
                      onAccept: () => _handleAcceptRequest(friendData['uid']),
                      onDecline: () =>
                          _handleDeclineRequest(friendData['uid']),
                    );
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
