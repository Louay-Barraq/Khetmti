import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:khetmti/components/friend_addition_component.dart';
import 'package:khetmti/components/introductive_component.dart';
import 'package:khetmti/utils/helpers.dart';
import '../../components/khetmti_header.dart';
import '../../themes/main_theme.dart';

class PersonSearchPage extends StatefulWidget {
  const PersonSearchPage({super.key});

  @override
  _PersonSearchPageState createState() => _PersonSearchPageState();
}

class _PersonSearchPageState extends State<PersonSearchPage> {
  final _controller = TextEditingController();
  String _searchQuery = "";

  Stream<QuerySnapshot> _friendsStream() {
    final query = _controller.text.trim();

    if (query.isEmpty) {
      return const Stream.empty();
    }

    return FirebaseFirestore.instance
        .collection('users')
        .where('username', isGreaterThanOrEqualTo: query)
        .where('username', isLessThanOrEqualTo: '$query\uf8ff')
        .snapshots();
  }

  Future<List<Map<String, dynamic>>> _processSearchResults(
      AsyncSnapshot<QuerySnapshot> snapshot) async {
    final currentUserId = FirebaseAuth.instance.currentUser?.uid;
    List<Map<String, dynamic>> results = [];

    // Get all relevant friendships at once to avoid n+1 queries in the loop
    // Note: for very large friend lists this might need optimization, but typically it's fine.
    final friendshipDocs = await FirebaseFirestore.instance
        .collection('friendships')
        .get();

    for (var userDoc in snapshot.data!.docs) {
      final userData = userDoc.data() as Map<String, dynamic>;
      final uid = userDoc.id;

      if (uid == currentUserId) continue;

      String status = 'none';

      for (var doc in friendshipDocs.docs) {
        final data = doc.data();
        if (data.containsKey('users')) {
          List users = data['users'];
          if (users.contains(currentUserId) && users.contains(uid)) {
            status = 'friends';
            break;
          }
        } else {
          final sender = data['sender'];
          final receiver = data['receiver'];
          final reqStatus = data['status'];
          if (sender == currentUserId && receiver == uid && reqStatus == 'pending') {
            status = 'pending';
            break;
          } else if (sender == uid && receiver == currentUserId && reqStatus == 'pending') {
            status = 'received';
            break;
          }
        }
      }

      results.add({
        'uid': uid,
        'username': userData['username'],
        'email': userData['email'],
        'status': status,
      });
    }

    return results;
  }

  Future<void> _handleAddFriend(String friendUid) async {
    final currentUserId = FirebaseAuth.instance.currentUser?.uid;

    try {
      await FirebaseFirestore.instance.collection('friendships').add({
        'sender': currentUserId,
        'receiver': friendUid,
        'status': 'pending',
        'timestamp': FieldValue.serverTimestamp(),
      });

      showSuccessToast('تم إرسال طلب الصداقة!');
      setState(() {}); // Refresh view
    } catch (e) {
      debugPrint('Error sending friend request: $e');
      showErrorToast('حدث خطأ أثناء إرسال الطلب');
    }
  }

  Future<void> _handleRemoveRequest(String friendUid) async {
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

      showErrorToast('تم إلغاء طلب الصداقة!');
      setState(() {});
    } catch (e) {
      debugPrint('Error removing friend request: $e');
    }
  }

  Future<void> _handleAcceptRequest(String friendUid) async {
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

      await FirebaseFirestore.instance.collection('friendships').add({
        'users': [currentUserId, friendUid],
        'timestamp': FieldValue.serverTimestamp(),
      });

      // Update both user docs
      await FirebaseFirestore.instance.collection('users').doc(friendUid).update({
        'friends': FieldValue.arrayUnion([currentUserId]),
      });
      await FirebaseFirestore.instance.collection('users').doc(currentUserId).update({
        'friends': FieldValue.arrayUnion([friendUid]),
      });

      showSuccessToast('تم قبول طلب الصداقة!');
      setState(() {});
    } catch (e) {
      debugPrint('Error accepting friend request: $e');
    }
  }

  Future<void> _handleDeclineRequest(String friendUid) async {
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

      showErrorToast('تم رفض طلب الصداقة');
      setState(() {});
    } catch (e) {
      debugPrint('Error declining friend request: $e');
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MainTheme.backgroundColor,
      body: Column(
        children: [
          KhetmtiHeader(
            title: 'البحث عن صديق',
            showProfile: false,
            showBackButton: true,
            onBackTap: () => Navigator.pop(context),
          ),
          const SizedBox(height: 20),
          _searchField(),
          const SizedBox(height: 10),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _friendsStream(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  if (_controller.text.isEmpty) {
                    return const Center(
                      child: Text(
                        'ابدأ بالبحث عن اسم صديقك',
                        style: TextStyle(fontFamily: 'Amiri', fontSize: 18),
                      ),
                    );
                  }
                  return const Center(
                    child: Text(
                      'لا يوجد شخص بهذا الاسم',
                      style: TextStyle(fontFamily: 'Amiri', fontSize: 18),
                    ),
                  );
                }

                return FutureBuilder<List<Map<String, dynamic>>>(
                  future: _processSearchResults(snapshot),
                  builder: (context, resultSnapshot) {
                    if (!resultSnapshot.hasData) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    final searchResults = resultSnapshot.data!;
                    return ListView.builder(
                      itemCount: searchResults.length,
                      itemBuilder: (context, index) {
                        final friendData = searchResults[index];
                        return FriendAdditionComponent(
                          username: friendData['username'] ?? 'Username',
                          email: friendData['email'] ?? '',
                          status: friendData['status'] ?? 'none',
                          onAdd: () => _handleAddFriend(friendData['uid']),
                          onRemove: () => _handleRemoveRequest(friendData['uid']),
                          onAccept: () => _handleAcceptRequest(friendData['uid']),
                          onDecline: () => _handleDeclineRequest(friendData['uid']),
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _searchField() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            offset: const Offset(0, 4),
            blurRadius: 10,
          ),
        ],
      ),
      child: TextField(
        controller: _controller,
        textDirection: TextDirection.rtl,
        onChanged: (val) => setState(() {}),
        style: const TextStyle(fontFamily: 'Amiri', fontSize: 18),
        decoration: InputDecoration(
          hintText: 'ابحث عن اسم المستخدم...',
          hintStyle: const TextStyle(fontFamily: 'Amiri', color: Colors.grey),
          prefixIcon: const Icon(Icons.search, color: MainTheme.primaryColor),
          suffixIcon: _controller.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _controller.clear();
                    setState(() {});
                  },
                )
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        ),
      ),
    );
  }
}
