import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:khetmti/core/theme/app_theme.dart';
import 'package:khetmti/features/social/data/social_repository.dart';
import 'package:khetmti/features/social/models/friendship.dart';
import 'package:khetmti/features/social/providers/social_provider.dart';
import 'package:khetmti/shared/widgets/friend_addition_component.dart';
import 'package:khetmti/shared/widgets/khetmti_header.dart';
import 'package:khetmti/shared/widgets/motion.dart';
import 'package:khetmti/l10n/l10n.dart';

class PersonSearchPage extends ConsumerStatefulWidget {
  const PersonSearchPage({super.key});

  @override
  ConsumerState<PersonSearchPage> createState() => _PersonSearchPageState();
}

class _PersonSearchPageState extends ConsumerState<PersonSearchPage> {
  final _controller = TextEditingController();

  /// The submitted search; typing alone does not query the database.
  String _query = '';

  /// Runs a friendship action; the buttons follow the live friendship rows.
  Future<void> _act(Future<void> Function(SocialRepository repo) action) =>
      action(ref.read(socialRepositoryProvider));

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final query = _query;
    final searchAsync = query.isNotEmpty
        ? ref.watch(personSearchProvider(query))
        : const AsyncValue<List<FriendSearchResult>>.data([]);

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: Column(
        children: [
          KhetmtiHeader(
            title: tr.findFriend,
            showNotification: false,
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
                  tr.searchError,
                  style: TextStyle(fontFamily: AppTheme.font, fontSize: 18),
                ),
              ),
              data: (results) {
                if (query.isEmpty) {
                  return Center(
                    child: Text(
                      tr.searchStart,
                      style: TextStyle(fontFamily: AppTheme.font, fontSize: 18),
                    ),
                  );
                }

                if (results.isEmpty) {
                  return Center(
                    child: Text(
                      tr.noPersonFound,
                      style: TextStyle(fontFamily: AppTheme.font, fontSize: 18),
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.only(top: 6, bottom: 24),
                  itemCount: results.length,
                  itemBuilder: (context, index) {
                    final result = results[index];
                    return FadeSlideIn(
                      index: index,
                      child: FriendAdditionComponent(
                        username: result.username,
                        subtitle: tr.levelN('${result.level}'),
                        status: result.status.name,
                        onAdd: () =>
                            _act((r) => r.sendFriendRequest(result.uid)),
                        onRemove: () =>
                            _act((r) => r.cancelFriendRequest(result.uid)),
                        onAccept: () => _act(
                            (r) => r.acceptFriendRequest(result.requestId!)),
                        onDecline: () => _act(
                            (r) => r.declineFriendRequest(result.requestId!)),
                      ),
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
        textInputAction: TextInputAction.search,
        onChanged: (_) => setState(() {}),
        onSubmitted: (val) => setState(() => _query = val.trim()),
        style: TextStyle(fontFamily: AppTheme.font, fontSize: 18),
        decoration: InputDecoration(
          hintText: tr.searchUsernameHint,
          hintStyle: TextStyle(fontFamily: AppTheme.font, color: Colors.grey),
          prefixIcon: const Icon(Icons.search, color: AppTheme.primaryColor),
          suffixIcon: _controller.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _controller.clear();
                    setState(() => _query = '');
                  },
                )
              : null,
          border: InputBorder.none,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        ),
      ),
    );
  }
}
