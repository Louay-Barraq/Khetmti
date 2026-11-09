import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:khetmti/core/theme/app_theme.dart';
import 'package:khetmti/features/social/data/social_repository.dart';
import 'package:khetmti/features/social/models/friendship.dart';
import 'package:khetmti/features/social/providers/social_provider.dart';
import 'package:khetmti/shared/widgets/khetmti_header.dart';
import 'package:khetmti/shared/widgets/motion.dart';

class FriendRequestsPage extends ConsumerStatefulWidget {
  const FriendRequestsPage({super.key});

  @override
  ConsumerState<FriendRequestsPage> createState() => _FriendRequestsPageState();
}

class _FriendRequestsPageState extends ConsumerState<FriendRequestsPage> {
  /// Requests being answered. Once the answer is saved, the live friendship
  /// rows drop the request from the list.
  final Set<String> _busy = {};

  Future<void> _answer(
    String requestId,
    Future<void> Function(SocialRepository repo) action,
  ) async {
    setState(() => _busy.add(requestId));
    await action(ref.read(socialRepositoryProvider));
    if (mounted) setState(() => _busy.remove(requestId));
  }

  @override
  Widget build(BuildContext context) {
    final requestsAsync = ref.watch(friendRequestsProvider);

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: Column(
        children: [
          const KhetmtiHeader(
            title: 'طلبات الصداقة',
            showNotification: false,
            showProfile: false,
            showBackButton: true,
          ),
          Expanded(
            child: SmoothSwitcher(
              child: requestsAsync.when(
                skipLoadingOnReload: true,
                loading: () => const Center(
                  key: ValueKey('loading'),
                  child: CircularProgressIndicator(),
                ),
                error: (_, __) => const Center(
                  key: ValueKey('error'),
                  child: Text(
                    'حدث خطأ أثناء تحميل الطلبات',
                    style: TextStyle(fontSize: 18, color: AppTheme.textSecondary),
                  ),
                ),
                data: (requests) => requests.isEmpty
                    ? const _NoRequests(key: ValueKey('empty'))
                    : ListView.builder(
                        key: const ValueKey('list'),
                        padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
                        itemCount: requests.length,
                        itemBuilder: (context, i) => FadeSlideIn(
                          key: ValueKey(requests[i].requestId),
                          index: i,
                          child: _card(requests[i]),
                        ),
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _card(FriendRequest request) {
    final busy = _busy.contains(request.requestId);
    final initial = request.username.isNotEmpty ? request.username[0] : '؟';

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: AppTheme.cardShadow,
      ),
      child: Row(
        textDirection: TextDirection.rtl,
        children: [
          CircleAvatar(
            radius: 26,
            backgroundColor: const Color(0xFFF1F5F9),
            child: Text(
              initial,
              style: const TextStyle(
                fontFamily: 'Amiri',
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppTheme.primaryColor,
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              textDirection: TextDirection.rtl,
              children: [
                Text(
                  request.username,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textDirection: TextDirection.rtl,
                  style: const TextStyle(
                    fontFamily: 'Amiri',
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textPrimary,
                  ),
                ),
                Text(
                  'المستوى ${request.level}',
                  style: const TextStyle(
                    fontFamily: 'Amiri',
                    fontSize: 14,
                    color: AppTheme.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          AnimatedSwitcher(
            duration: AppTheme.fast,
            child: busy
                ? const SizedBox(
                    key: ValueKey('busy'),
                    width: 88,
                    child: Center(
                      child: SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(strokeWidth: 2.4),
                      ),
                    ),
                  )
                : Row(
                    key: const ValueKey('actions'),
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _RoundButton(
                        icon: Icons.close_rounded,
                        tooltip: 'رفض',
                        color: AppTheme.redishColor,
                        onTap: () => _answer(request.requestId,
                            (r) => r.declineFriendRequest(request.requestId)),
                      ),
                      const SizedBox(width: 8),
                      _RoundButton(
                        icon: Icons.check_rounded,
                        tooltip: 'قبول',
                        color: AppTheme.primaryColor,
                        filled: true,
                        onTap: () => _answer(request.requestId,
                            (r) => r.acceptFriendRequest(request.requestId)),
                      ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}

class _RoundButton extends StatelessWidget {
  final IconData icon;
  final String tooltip;
  final Color color;
  final bool filled;
  final VoidCallback onTap;

  const _RoundButton({
    required this.icon,
    required this.tooltip,
    required this.color,
    required this.onTap,
    this.filled = false,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: Pressable(
        onTap: onTap,
        pressedScale: 0.9,
        child: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: filled ? color : color.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: filled ? Colors.white : color, size: 22),
        ),
      ),
    );
  }
}

class _NoRequests extends StatelessWidget {
  const _NoRequests({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(22),
            decoration: const BoxDecoration(
              color: AppTheme.softGreen,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.people_outline_rounded,
                size: 44, color: AppTheme.primaryColor),
          ),
          const SizedBox(height: 16),
          const Text(
            'لا توجد طلبات صداقة حالياً',
            style: TextStyle(fontSize: 18, color: AppTheme.textSecondary),
          ),
        ],
      ),
    );
  }
}
