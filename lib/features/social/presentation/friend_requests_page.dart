import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:khetmti/core/theme/app_theme.dart';
import 'package:khetmti/core/utils/helpers.dart';
import 'package:khetmti/features/social/models/friendship.dart';
import 'package:khetmti/features/social/providers/social_provider.dart';
import 'package:khetmti/shared/widgets/khetmti_header.dart';

class FriendRequestsPage extends ConsumerStatefulWidget {
  const FriendRequestsPage({super.key});

  @override
  ConsumerState<FriendRequestsPage> createState() => _FriendRequestsPageState();
}

class _FriendRequestsPageState extends ConsumerState<FriendRequestsPage> {
  Future<void> _acceptRequest(String requestId, String senderId) async {
    try {
      showLoadingDialog(context);
      await ref.read(socialRepositoryProvider).acceptFriendRequest(requestId, senderId);
      if (mounted) dismissLoadingDialog(context);
    } catch (e) {
      if (mounted) dismissLoadingDialog(context);
      debugPrint("Error accepting friend request: $e");
    }
  }

  Future<void> _declineRequest(String requestId) async {
    try {
      showLoadingDialog(context);
      await ref.read(socialRepositoryProvider).declineFriendRequest(requestId);
      if (mounted) dismissLoadingDialog(context);
    } catch (e) {
      if (mounted) dismissLoadingDialog(context);
      debugPrint("Error declining friend request: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final requestsAsync = ref.watch(friendRequestsProvider);

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: Column(
        children: [
          KhetmtiHeader(
            title: "طلبات الصداقة",
            showProfile: false,
            showBackButton: true,
          ),
          Expanded(
            child: requestsAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(
                child: Text(
                  "حدث خطأ أثناء تحميل الطلبات",
                  style: const TextStyle(
                    fontFamily: 'Amiri',
                    fontSize: 18,
                    color: AppTheme.textSecondary,
                  ),
                ),
              ),
              data: (requests) {
                if (requests.isEmpty) {
                  return const Center(
                    child: Text(
                      "لا توجد طلبات صداقة حالياً",
                      style: TextStyle(
                        fontFamily: 'Amiri',
                        fontSize: 18,
                        color: AppTheme.textSecondary,
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

  Widget _buildRequestCard(FriendRequest request) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
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
                backgroundColor: AppTheme.primaryColor.withValues(alpha: 0.1),
                child: Text(
                  request.username[0].toUpperCase(),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppTheme.primaryColor,
                  ),
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      request.username,
                      style: const TextStyle(
                        fontFamily: 'Amiri',
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                    Text(
                      request.email,
                      style: const TextStyle(
                        fontSize: 13,
                        color: AppTheme.textSecondary,
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
                  onPressed: () => _acceptRequest(request.requestId, request.senderId),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryColor,
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
                  onPressed: () => _declineRequest(request.requestId),
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
