import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:khetmti/core/theme/app_theme.dart';
import 'package:khetmti/features/auth/models/app_user.dart';
import 'package:khetmti/features/auth/providers/auth_provider.dart';
import 'package:khetmti/features/khetma/providers/khetma_provider.dart';
import 'package:khetmti/features/quran/models/quran_data.dart';
import 'package:khetmti/features/social/providers/social_provider.dart';
import 'package:khetmti/shared/widgets/friend_tile.dart';
import 'package:khetmti/shared/widgets/khetma_card.dart';
import 'package:khetmti/shared/widgets/khetmti_header.dart';
import 'package:khetmti/shared/widgets/profile_state_switch.dart';
import 'package:khetmti/shared/widgets/statistics_toggle.dart';

class ProfilePage extends ConsumerStatefulWidget {
  const ProfilePage({super.key});

  @override
  ConsumerState<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage> {
  String _currentView = 'Your Friends';
  String _statsView = 'Surahs';
  String _statsSortOrder = 'Normal Order';

  List<Map<String, dynamic>> _buildStatsFromUser(
      Map<String, int>? readingStats) {
    if (readingStats == null) return [];
    final list = <Map<String, dynamic>>[];
    if (_statsView == 'Surahs') {
      for (final key in sourasWithAyahs.keys) {
        list.add({'name': key, 'count': readingStats[key] ?? 0});
      }
    } else {
      for (final key in juzusList) {
        list.add({'name': key, 'count': readingStats[key] ?? 0});
      }
    }
    return _applySorting(list);
  }

  List<Map<String, dynamic>> _applySorting(List<Map<String, dynamic>> rawData) {
    final list = List<Map<String, dynamic>>.from(rawData);
    if (_statsSortOrder == 'Frequency (Desc)') {
      list.sort((a, b) => b['count'].compareTo(a['count']));
    } else if (_statsSortOrder == 'Frequency (Asc)') {
      list.sort((a, b) => a['count'].compareTo(b['count']));
    }
    return list;
  }

  void _showUnfriendDialog(String friendUid) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('إلغاء الصداقة', textAlign: TextAlign.right),
        content: const Text('هل أنت متأكد من إزالة هذا الصديق؟',
            textAlign: TextAlign.right),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('إلغاء')),
          TextButton(
            onPressed: () {
              ref.read(socialRepositoryProvider).unfriend(friendUid);
              Navigator.pop(ctx);
            },
            child: const Text('إزالة', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = ref.watch(currentUserProvider);
    final friendsAsync = ref.watch(friendsProvider);
    final inProgressKhetmas = ref.watch(userKhetmasProvider(false));

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildHeader(currentUser),
            const SizedBox(height: 20),
            ProfileStateSwitch(
              onSwitchChanged: (value) {
                setState(() {
                  _currentView = value;
                });
              },
            ),
            const SizedBox(height: 20),
            if (_currentView == 'Statistics') ...[
              StatisticsToggle(
                onValuesChanged: (value) {
                  setState(() {
                    _statsView = value;
                  });
                },
              ),
              const SizedBox(height: 15),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 400),
                transitionBuilder:
                    (Widget child, Animation<double> animation) {
                  return FadeTransition(
                    opacity: animation,
                    child: SizeTransition(
                      sizeFactor: animation,
                      axis: Axis.vertical,
                      child: child,
                    ),
                  );
                },
                child: Padding(
                  key: ValueKey(_statsView),
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    textDirection: TextDirection.rtl,
                    children: [
                      _buildSortChip(
                        _statsView == 'Surahs'
                            ? 'ترتيب القرآن'
                            : 'ترتيب الأجزاء',
                        'Normal Order',
                      ),
                      const SizedBox(width: 8),
                      _buildSortChip('الأكثر قراءة', 'Frequency (Desc)'),
                      const SizedBox(width: 8),
                      _buildSortChip('الأقل قراءة', 'Frequency (Asc)'),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                textDirection: TextDirection.rtl,
                children: [
                  Text(
                    _currentView == 'Your Friends'
                        ? 'قائمة الأصدقاء'
                        : _currentView == 'Your Khatms'
                            ? 'ختماتك النشطة'
                            : _statsView == 'Surahs'
                                ? 'إحصائيات السور'
                                : 'إحصائيات الأجزاء',
                    style: const TextStyle(
                      fontFamily: 'Amiri',
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  if (_currentView == 'Your Friends')
                    TextButton.icon(
                      onPressed: () => context.push('/friends/search'),
                      icon:
                          const Icon(Icons.person_add_outlined, size: 18),
                      label: const Text('إضافة صديق'),
                      style: TextButton.styleFrom(
                        foregroundColor: AppTheme.primaryColor,
                        textStyle: const TextStyle(
                            fontFamily: 'Amiri',
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 400),
              transitionBuilder:
                  (Widget child, Animation<double> animation) {
                return FadeTransition(
                  opacity: animation,
                  child: SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(0.0, 0.05),
                      end: Offset.zero,
                    ).animate(animation),
                    child: child,
                  ),
                );
              },
              child: _buildCurrentView(
                  currentUser, friendsAsync, inProgressKhetmas),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCurrentView(
    AsyncValue currentUser,
    AsyncValue friendsAsync,
    AsyncValue inProgressKhetmas,
  ) {
    if (_currentView == 'Your Friends') {
      return _buildFriendsList(friendsAsync);
    } else if (_currentView == 'Your Khatms') {
      return _buildKhatmsList(inProgressKhetmas);
    } else {
      final readingStats =
          currentUser.valueOrNull?.readingStats;
      return _buildStatsList(readingStats);
    }
  }

  Widget _buildFriendsList(AsyncValue friendsAsync) {
    return friendsAsync.when(
      loading: () => const Center(
          key: ValueKey('FriendsLoading'),
          child: CircularProgressIndicator()),
      error: (_, __) => const Center(
          key: ValueKey('FriendsError'),
          child: Text('خطأ في تحميل الأصدقاء')),
      data: (friends) {
        if (friends.isEmpty) {
          return const Padding(
            key: ValueKey('FriendsEmpty'),
            padding: EdgeInsets.only(top: 50),
            child: Text('ليس لديك أصدقاء حاليا',
                style: TextStyle(
                    fontFamily: 'Amiri',
                    fontSize: 18,
                    color: AppTheme.textSecondary)),
          );
        }
        return ListView.builder(
          key: const ValueKey('FriendsList'),
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.only(bottom: 30),
          itemCount: friends.length,
          itemBuilder: (context, index) {
            final friend = friends[index];
            return _buildAnimatedListItem(
              index: index,
              child: FriendComponent(
                username: friend.username,
                level: friend.level,
                lastSeen: friend.lastSeen,
                trailing: IconButton(
                  icon: const Icon(Icons.person_remove_outlined,
                      color: Colors.red, size: 22),
                  onPressed: () => _showUnfriendDialog(friend.uid),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildKhatmsList(AsyncValue inProgressKhetmas) {
    return inProgressKhetmas.when(
      loading: () => const Center(
          key: ValueKey('KhatmsLoading'),
          child: CircularProgressIndicator()),
      error: (_, __) => const Center(
          key: ValueKey('KhatmsError'),
          child: Text('خطأ في تحميل الختمات')),
      data: (khetmas) {
        if (khetmas.isEmpty) {
          return const Padding(
            key: ValueKey('KhatmsEmpty'),
            padding: EdgeInsets.only(top: 50),
            child: Text('لا توجد ختمات نشطة',
                style: TextStyle(
                    fontFamily: 'Amiri',
                    fontSize: 18,
                    color: AppTheme.textSecondary)),
          );
        }
        return ListView.builder(
          key: const ValueKey('KhatmsList'),
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.only(bottom: 30),
          itemCount: khetmas.length,
          itemBuilder: (context, index) {
            final khetma = khetmas[index];
            return _buildAnimatedListItem(
              index: index,
              child: GestureDetector(
                onTap: () =>
                    context.push('/khetma/${khetma.khetmaId}'),
                child: KhetmaComponent(
                  title: khetma.name,
                  progress: khetma.completionPercent,
                  participantsCount:
                      khetma.currentParticipantsNumber,
                  createdAt: khetma.createdAt,
                  updatedAt: khetma.updatedAt,
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildStatsList(Map<String, int>? readingStats) {
    final data = _buildStatsFromUser(readingStats);

    if (readingStats == null) {
      return const Center(
        key: ValueKey('StatsLoading'),
        child: CircularProgressIndicator(),
      );
    }

    if (data.isEmpty) {
      return const Padding(
        key: ValueKey('StatsEmpty'),
        padding: EdgeInsets.only(top: 50),
        child: Text('لا توجد إحصائيات',
            style: TextStyle(
                fontFamily: 'Amiri',
                fontSize: 18,
                color: AppTheme.textSecondary)),
      );
    }

    return ListView.builder(
      key: ValueKey('StatsList-$_statsView-$_statsSortOrder'),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.only(bottom: 30),
      itemCount: data.length,
      itemBuilder: (context, index) {
        final item = data[index];
        return _buildAnimatedListItem(
          index: index,
          child: GestureDetector(
            onTap: () {
              int id = _statsView == 'Surahs'
                  ? sourasWithAyahs.keys
                          .toList()
                          .indexOf(item['name']) +
                      1
                  : juzusList.indexOf(item['name']) + 1;
              final type = _statsView == 'Surahs' ? 'sura' : 'juzu';
              context.push('/quran/$type/$id',
                  extra: {'title': item['name']});
            },
            child: Container(
              margin:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
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
                    padding: const EdgeInsets.all(12),
                    decoration: const BoxDecoration(
                      color: AppTheme.greyishColor,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.menu_book,
                        color: AppTheme.primaryColor),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: Text(
                      item['name'],
                      style: const TextStyle(
                        fontFamily: 'Amiri',
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.textPrimary,
                      ),
                      textDirection: TextDirection.rtl,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15, vertical: 8),
                    decoration: BoxDecoration(
                      color:
                          AppTheme.primaryColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Text(
                      "${item['count']} مرة",
                      textDirection: TextDirection.ltr,
                      style: const TextStyle(
                        fontFamily: 'Amiri',
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.primaryColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildAnimatedListItem(
      {required int index, required Widget child}) {
    return TweenAnimationBuilder<double>(
      key: ValueKey('anim-$index'),
      tween: Tween(begin: 0.0, end: 1.0),
      duration:
          Duration(milliseconds: 300 + (index * 50).clamp(0, 500)),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, 20 * (1 - value)),
            child: child,
          ),
        );
      },
      child: child,
    );
  }

  Widget _buildHeader(AsyncValue currentUser) {
    final userData = currentUser.valueOrNull;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 60, 20, 40),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppTheme.primaryColor.withValues(alpha: 0.5),
            AppTheme.primaryColor,
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(16),
          bottomRight: Radius.circular(16),
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            textDirection: TextDirection.rtl,
            children: [
              Row(
                textDirection: TextDirection.rtl,
                children: [
                  if (Navigator.of(context).canPop())
                    KhetmtiHeader.buildHeaderIcon(
                      Icons.arrow_forward_ios,
                      onTap: () => context.pop(),
                    ),
                  if (Navigator.of(context).canPop())
                    const SizedBox(width: 8),
                  KhetmtiHeader.buildHeaderIcon(
                    Icons.settings,
                    onTap: () => context.push('/settings'),
                  ),
                ],
              ),
              const Text(
                'الحساب',
                style: TextStyle(
                  fontFamily: 'Amiri',
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              KhetmtiHeader.buildHeaderIcon(
                Icons.notifications_none,
                onTap: () => context.push('/notifications'),
              ),
            ],
          ),
          const SizedBox(height: 30),
          Row(
            textDirection: TextDirection.rtl,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      userData?.username ?? 'جاري التحميل...',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontFamily: 'Amiri',
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: const Color(0xFFC0FAD9),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            "المستوى: ${userData?.level ?? 1}",
                            style: const TextStyle(
                              fontFamily: 'Amiri',
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF065F46),
                              fontSize: 14,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                                color: Colors.white
                                    .withValues(alpha: 0.5)),
                          ),
                          child: Text(
                            _getRankName(userData?.level ?? 1),
                            style: const TextStyle(
                              fontFamily: 'Amiri',
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Padding(
                      padding:
                          const EdgeInsets.symmetric(horizontal: 40),
                      child: Builder(
                        builder: (context) {
                          int totalXP = userData?.totalXP ?? 0;
                          int currentLevel = userData?.level ?? 1;
                          final minXP = xpForLevel(currentLevel);
                          final maxXP = xpForLevel(currentLevel + 1);
                          double progress =
                              (totalXP - minXP) / (maxXP - minXP);
                          if (progress < 0) progress = 0;
                          if (progress > 1) progress = 1;

                          return Column(
                            children: [
                              ClipRRect(
                                borderRadius:
                                    BorderRadius.circular(10),
                                child: LinearProgressIndicator(
                                  value: progress,
                                  backgroundColor: Colors.white
                                      .withValues(alpha: 0.3),
                                  color: Colors.white,
                                  minHeight: 8,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                "${totalXP - minXP} / ${maxXP - minXP} XP",
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 8),
                  ],
                ),
              ),
              const SizedBox(width: 40),
              Stack(
                children: [
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 10,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: CircleAvatar(
                      radius: 45,
                      backgroundColor: const Color(0xFFF1F5F9),
                      child: Text(
                        (userData?.username ?? "U")[0].toUpperCase(),
                        style: const TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.primaryColor,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryColor,
                        borderRadius: BorderRadius.circular(10),
                        border:
                            Border.all(color: Colors.white, width: 2),
                      ),
                      child: const Text(
                        'نشط',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 9,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSortChip(String label, String order) {
    bool isSelected = _statsSortOrder == order;
    return GestureDetector(
      onTap: () {
        setState(() {
          _statsSortOrder = order;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.primaryColor : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? AppTheme.primaryColor
                : AppTheme.greyishColor,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppTheme.primaryColor
                        .withValues(alpha: 0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  )
                ]
              : [],
        ),
        child: Text(
          label,
          style: TextStyle(
            fontFamily: 'Amiri',
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: isSelected
                ? Colors.white
                : AppTheme.secondaryColor,
          ),
        ),
      ),
    );
  }

  String _getRankName(int level) {
    if (level <= 5) return "طالب";
    if (level <= 10) return "قارئ";
    if (level <= 15) return "مرتل";
    if (level <= 25) return "مجود";
    if (level <= 40) return "حافظ";
    if (level <= 60) return "متقن";
    if (level <= 80) return "فقيه";
    if (level <= 100) return "عالم";
    return "إمام";
  }
}
