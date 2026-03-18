import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:khetmti/components/khetmti_header.dart';
import 'package:khetmti/themes/main_theme.dart';
import 'package:khetmti/utils/helpers.dart';

class FriendRequestsPage extends StatefulWidget {
  const FriendRequestsPage({super.key});

  @override
  State<FriendRequestsPage> createState() => _FriendRequestsPageState();
}

class _FriendRequestsPageState extends State<FriendRequestsPage> {
  final String _currentUserId = FirebaseAuth.instance.currentUser!.uid;

  Stream<List<Map<String, dynamic>>> _fetchFriendRequests() {
    return FirebaseFirestore.instance
        .collection('friendships')
        .where('receiver', isEqualTo: _currentUserId)
        .where('status', isEqualTo: 'pending')
        .snapshots()
        .asyncMap((snapshot) async {
      List<Map<String, dynamic>> requests = [];
      for (var doc in snapshot.docs) {
        final data = doc.data();
        final senderId = data['sender'];
        
        // Fetch sender details
        final userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(senderId)
            .get();
        
        if (userDoc.exists) {
          final userData = userDoc.data()!;
          requests.add({
            'requestId': doc.id,
            'senderId': senderId,
            'username': userData['username'] ?? 'Unknown',
            'email': userData['email'] ?? '',
          });
        }
      }
      return requests;
    });
  }

  Future<void> _acceptRequest(String requestId, String senderId) async {
    try {
      showLoadingDialog(context);
      
      // 1. Delete the request
      await FirebaseFirestore.instance
          .collection('friendships')
          .doc(requestId)
          .delete();

      // 2. Add to friendships collection (confirmed friends)
      await FirebaseFirestore.instance.collection('friendships').add({
        'users': [_currentUserId, senderId],
        'timestamp': FieldValue.serverTimestamp(),
      });

      // 3. Update both users' friends lists
      await FirebaseFirestore.instance.collection('users').doc(_currentUserId).update({
        'friends': FieldValue.arrayUnion([senderId]),
      });
      await FirebaseFirestore.instance.collection('users').doc(senderId).update({
        'friends': FieldValue.arrayUnion([_currentUserId]),
      });

      if (mounted) dismissLoadingDialog(context);
      showSuccessToast("تم قبول طلب الصداقة بنجاح");
    } catch (e) {
      if (mounted) dismissLoadingDialog(context);
      showErrorToast("حدث خطأ أثناء قبول الطلب");
      debugPrint("Error accepting friend request: $e");
    }
  }

  Future<void> _declineRequest(String requestId) async {
    try {
      showLoadingDialog(context);
      await FirebaseFirestore.instance
          .collection('friendships')
          .doc(requestId)
          .delete();

      if (mounted) dismissLoadingDialog(context);
      showSuccessToast("تم رفض طلب الصداقة");
    } catch (e) {
      if (mounted) dismissLoadingDialog(context);
      showErrorToast("حدث خطأ أثناء رفض الطلب");
      debugPrint("Error declining friend request: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MainTheme.backgroundColor,
      body: Column(
        children: [
          KhetmtiHeader(
            title: "طلبات الصداقة",
            showProfile: false,
            showBackButton: true,
          ),
          Expanded(
            child: StreamBuilder<List<Map<String, dynamic>>>(
              stream: _fetchFriendRequests(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                
                final requests = snapshot.data ?? [];
                
                if (requests.isEmpty) {
                  return const Center(
                    child: Text(
                      "لا توجد طلبات صداقة حالياً",
                      style: TextStyle(
                        fontFamily: 'Amiri',
                        fontSize: 18,
                        color: MainTheme.textSecondary,
                      ),
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  itemCount: requests.length,
                  itemBuilder: (context, index) {
                    final request = requests[index];
                    return _buildRequestCard(request);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRequestCard(Map<String, dynamic> request) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            textDirection: TextDirection.rtl,
            children: [
              CircleAvatar(
                radius: 25,
                backgroundColor: MainTheme.primaryColor.withOpacity(0.1),
                child: Text(
                  request['username'][0].toUpperCase(),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: MainTheme.primaryColor,
                  ),
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      request['username'],
                      style: const TextStyle(
                        fontFamily: 'Amiri',
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: MainTheme.textPrimary,
                      ),
                    ),
                    Text(
                      request['email'],
                      style: const TextStyle(
                        fontSize: 13,
                        color: MainTheme.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          Row(
            textDirection: TextDirection.rtl,
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () => _acceptRequest(request['requestId'], request['senderId']),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: MainTheme.primaryColor,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    "قبول",
                    style: TextStyle(fontFamily: 'Amiri', fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: OutlinedButton(
                  onPressed: () => _declineRequest(request['requestId']),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.red,
                    side: const BorderSide(color: Colors.red),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    "رفض",
                    style: TextStyle(fontFamily: 'Amiri', fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
