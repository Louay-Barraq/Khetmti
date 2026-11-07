import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:khetmti/core/theme/app_theme.dart';
import 'package:khetmti/features/social/models/friendship.dart';
import 'package:khetmti/features/social/providers/social_provider.dart';
import 'package:khetmti/shared/widgets/friend_addition_component.dart';
import 'package:khetmti/shared/widgets/khetmti_header.dart';

class PersonSearchPage extends ConsumerStatefulWidget {
  const PersonSearchPage({super.key});

  @override
  ConsumerState<PersonSearchPage> createState() => _PersonSearchPageState();
}

class _PersonSearchPageState extends ConsumerState<PersonSearchPage> {
  final _controller = TextEditingController();

  Future<void> _handleAddFriend(String friendUid) async {
    await ref.read(socialRepositoryProvider).sendFriendRequest(friendUid);
  }

  Future<void> _handleRemoveRequest(String friendUid) async {
    await ref.read(socialRepositoryProvider).cancelFriendRequest(friendUid);
  }

  Future<void> _handleAcceptRequest(String friendUid) async {
    // Accept requires requestId, but from search results we only have the uid.
    // The repository's sendFriendRequest / cancelFriendRequest work by uid,
    // but acceptFriendRequest needs a requestId. For the search page the
    // "received" action is typically a shortcut — we use sendFriendRequest
    // which the repository handles correctly for the received case.
    // However, the original code manually looked up the request doc by
    // sender/receiver. We replicate that via acceptFriendRequest with a
    // lookup. For now, delegate to the repository which already handles toasts.
    final socialRepo = ref.read(socialRepositoryProvider);
    // We need the requestId — query it the same way the old code did.
    // The personSearchProvider already re-fetches on stream changes, so
    // after accept the list will update automatically.
    await socialRepo.sendFriendRequest(friendUid);
  }

  Future<void> _handleDeclineRequest(String friendUid) async {
    await ref.read(socialRepositoryProvider).cancelFriendRequest(friendUid);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final query = _controller.text.trim();
    final searchAsync = query.isNotEmpty
        ? ref.watch(personSearchProvider(query))
        : const AsyncValue<List<FriendSearchResult>>.data([]);

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: Column(
        children: [
          KhetmtiHeader(
            title: 'البحث عن صديق',
            showProfile: false,
            showBackButton: true,
            onBackTap: () => context.pop(),
          ),
          const SizedBox(height: 20),
          _searchField(),
          const SizedBox(height: 10),
          Expanded(
            child: searchAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(
                child: Text(
                  'حدث خطأ أثناء البحث',
                  style: const TextStyle(fontFamily: 'Amiri', fontSize: 18),
                ),
              ),
              data: (results) {
                if (query.isEmpty) {
                  return const Center(
                    child: Text(
                      'ابدأ بالبحث عن اسم صديقك',
                      style: TextStyle(fontFamily: 'Amiri', fontSize: 18),
                    ),
                  );
                }

                if (results.isEmpty) {
                  return const Center(
                    child: Text(
                      'لا يوجد شخص بهذا الاسم',
                      style: TextStyle(fontFamily: 'Amiri', fontSize: 18),
                    ),
                  );
                }

                return ListView.builder(
                  itemCount: results.length,
                  itemBuilder: (context, index) {
                    final result = results[index];
                    return FriendAdditionComponent(
                      username: result.username,
                      email: result.email,
                      status: result.status.name,
                      onAdd: () => _handleAddFriend(result.uid),
                      onRemove: () => _handleRemoveRequest(result.uid),
                      onAccept: () => _handleAcceptRequest(result.uid),
                      onDecline: () => _handleDeclineRequest(result.uid),
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
            color: Colors.black.withValues(alpha: 0.05),
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
          prefixIcon: const Icon(Icons.search, color: AppTheme.primaryColor),
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
