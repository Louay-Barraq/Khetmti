import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:khetmti/core/theme/app_theme.dart';
import 'package:khetmti/features/auth/providers/auth_provider.dart';
import 'package:khetmti/features/profile/providers/profile_provider.dart';
import 'package:khetmti/features/social/providers/social_provider.dart';
import 'package:khetmti/shared/widgets/khetmti_header.dart';

class RankingsPage extends ConsumerStatefulWidget {
  const RankingsPage({super.key});

  @override
  ConsumerState<RankingsPage> createState() => _RankingsPageState();
}

class _RankingsPageState extends ConsumerState<RankingsPage> {
  int _timeframeIndex = 1;
  bool _isGlobal = true;

  @override
  Widget build(BuildContext context) {
    final rankingsAsync = ref.watch(rankingsProvider);
    final currentUserId = ref.watch(authStateProvider).valueOrNull?.id;

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: Column(
        children: [
          KhetmtiHeader(
            title: 'لوحة المتصدرين',
            showProfile: false,
            showBackButton: true,
            onBackTap: () => context.pop(),
            bottom: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Container(
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        _buildTab('اليوم', 0, isTimeframe: true),
                        _buildTab('الأسبوع', 1, isTimeframe: true),
                        _buildTab('الكل', 2, isTimeframe: true),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Center(
                  child: Container(
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _buildTab('العالمي', 0, isTimeframe: false),
                        const SizedBox(width: 8),
                        _buildTab('الأصدقاء', 1, isTimeframe: false),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: rankingsAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (_, __) =>
                  const Center(child: Text('خطأ في تحميل البيانات')),
              data: (users) {
                if (users.isEmpty) {
                  return const Center(
                      child: Text('لا توجد بيانات',
                          style: TextStyle(fontFamily: 'Amiri')));
                }
                return RefreshIndicator(
                  onRefresh: () => refreshPeople(ref),
                  child: ListView.builder(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
                    itemCount: users.length,
                    itemBuilder: (context, index) {
                      final user = users[index];
                      final isMe = user.uid == currentUserId;
                      if (index == 0) {
                        return Column(
                          children: [
                            const SizedBox(height: 10),
                            _buildRankingRow(
                              name: user.username,
                              xp: user.totalXP,
                              rank: index + 1,
                              isMe: isMe,
                            ),
                          ],
                        );
                      }
                      return _buildRankingRow(
                        name: user.username,
                        xp: user.totalXP,
                        rank: index + 1,
                        isMe: isMe,
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTab(String label, int index, {required bool isTimeframe}) {
    bool isSelected =
        isTimeframe ? (_timeframeIndex == index) : (_isGlobal == (index == 0));

    return isTimeframe
        ? Expanded(
            child: _buildTabButton(label, isSelected,
                () => setState(() => _timeframeIndex = index)))
        : _buildTabButton(
            label, isSelected, () => setState(() => _isGlobal = (index == 0)),
            horizontalPadding: 25);
  }

  Widget _buildTabButton(String label, bool isSelected, VoidCallback onTap,
      {double horizontalPadding = 0}) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding:
            EdgeInsets.symmetric(vertical: 8, horizontal: horizontalPadding),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(15),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  )
                ]
              : null,
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: 'Amiri',
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: isSelected
                ? AppTheme.primaryColor
                : Colors.white.withValues(alpha: 0.8),
          ),
        ),
      ),
    );
  }

  Widget _buildRankingRow({
    required String name,
    required int xp,
    required int rank,
    required bool isMe,
  }) {
    Color rankColor = Colors.grey[600]!;
    if (rank == 1) rankColor = const Color(0xFFFFD700);
    if (rank == 2) rankColor = const Color(0xFFC0C0C0);
    if (rank == 3) rankColor = const Color(0xFFCD7F32);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color:
            isMe ? AppTheme.primaryColor.withValues(alpha: 0.05) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: isMe
            ? Border.all(
                color: AppTheme.primaryColor.withValues(alpha: 0.3), width: 1.5)
            : null,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        textDirection: TextDirection.rtl,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: rank <= 3
                  ? rankColor.withValues(alpha: 0.15)
                  : AppTheme.greyishColor.withValues(alpha: 0.5),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: rank <= 3
                  ? Icon(Icons.emoji_events, color: rankColor, size: 18)
                  : Text(
                      rank.toString(),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[600],
                        fontSize: 14,
                      ),
                    ),
            ),
          ),
          const SizedBox(width: 12),
          CircleAvatar(
            radius: 20,
            backgroundColor: AppTheme.greyishColor,
            child: const Icon(Icons.person, color: Colors.white, size: 24),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  textDirection: TextDirection.rtl,
                  children: [
                    Text(
                      name,
                      style: TextStyle(
                        fontFamily: 'Amiri',
                        fontSize: 16,
                        fontWeight: isMe ? FontWeight.bold : FontWeight.w600,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                    if (isMe) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppTheme.primaryColor,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Text(
                          'أنا',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '$xp',
                style: const TextStyle(
                  fontWeight: FontWeight.w900,
                  color: AppTheme.primaryColor,
                  fontSize: 18,
                ),
              ),
              const Text(
                'XP',
                style: TextStyle(
                  fontSize: 10,
                  color: Colors.grey,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
