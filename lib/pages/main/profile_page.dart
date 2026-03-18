import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:khetmti/components/friend_component.dart';
import 'package:khetmti/components/khetma_component.dart';
import 'package:khetmti/components/profile_state_switch.dart';
import 'package:khetmti/components/khetmti_header.dart';
import 'package:khetmti/pages/main/settings_page.dart';
import 'package:khetmti/themes/main_theme.dart';
import '../../utils/helpers.dart';
import '../Khetma/Khetma_page.dart';
import 'package:khetmti/pages/actions/notifications_page.dart';
import 'package:khetmti/pages/actions/person_search_page.dart';
import 'package:khetmti/components/statistics_toggle.dart';
import 'package:khetmti/data/quran_data.dart';
import 'package:khetmti/pages/main/quran_view_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String _currentView = 'Your Friends';
  String _statsView = 'Surahs';
  String _statsSortOrder = 'Normal Order';
  Stream<Map<String, dynamic>>? _profileTopDataStream;
  Stream<List<Map<String, dynamic>>>? _friendsStream;
  Stream<List<Map<String, dynamic>>>? _khatmsStream;

  // In-memory caches
  Map<String, int>? _rawReadingStats;
  List<Map<String, dynamic>>? _cachedFriends;
  List<Map<String, dynamic>>? _cachedKhatms;

  @override
  void initState() {
    super.initState();
    _profileTopDataStream = _fetchProfileTopDataStream();
    _friendsStream = _fetchFriendsStream();
    _khatmsStream = _fetchKhatmsStream();
    _listenToStatistics();
  }

  Stream<Map<String, dynamic>> _fetchProfileTopDataStream() {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .snapshots()
        .map((doc) => doc.data() as Map<String, dynamic>);
  }


  Stream<List<Map<String, dynamic>>> _fetchFriendsStream() {
    final userId = FirebaseAuth.instance.currentUser?.uid;

    return FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .snapshots()
        .asyncMap((snapshot) async {
      List<dynamic> friendsUids = snapshot.data()?['friends'] ?? [];
      if (friendsUids.isEmpty) return [];

      final friendsQuerySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where(FieldPath.documentId, whereIn: friendsUids)
          .get();

      return friendsQuerySnapshot.docs.map((doc) => doc.data()).toList();
    });
  }

  Future<void> _unfriend(String friendUid) async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) return;

    try {
      await FirebaseFirestore.instance.collection('users').doc(userId).update({
        'friends': FieldValue.arrayRemove([friendUid]),
      });
      await FirebaseFirestore.instance.collection('users').doc(friendUid).update({
        'friends': FieldValue.arrayRemove([userId]),
      });
    } catch (e) {
      debugPrint("Error unfriending: $e");
    }
  }

  Stream<List<Map<String, dynamic>>> _fetchKhatmsStream() {
    return FirebaseFirestore.instance
        .collection('khatms')
        .where('participants', arrayContains: FirebaseAuth.instance.currentUser!.uid)
        .where('completionPercent', isLessThan: 1.0)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => doc.data()).toList());
  }

  void _listenToStatistics() {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .snapshots()
        .listen((snapshot) {
      final data = snapshot.data();
      if (data != null && mounted) {
        setState(() {
          _rawReadingStats = Map<String, int>.from(data['readingStats'] ?? {});
        });
      }
    });
  }

  List<Map<String, dynamic>> _buildStatsFromCache() {
    if (_rawReadingStats == null) return [];
    final stats = _rawReadingStats!;
    final list = <Map<String, dynamic>>[];
    if (_statsView == 'Surahs') {
      for (final key in sourasWithAyahs.keys) {
        list.add({'name': key, 'count': stats[key] ?? 0});
      }
    } else {
      for (final key in juzusList) {
        list.add({'name': key, 'count': stats[key] ?? 0});
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
      builder: (context) => AlertDialog(
        title: const Text('إلغاء الصداقة', textAlign: TextAlign.right),
        content: const Text('هل أنت متأكد من إزالة هذا الصديق؟', textAlign: TextAlign.right),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('إلغاء')),
          TextButton(
            onPressed: () {
              _unfriend(friendUid);
              Navigator.pop(context);
            },
            child: const Text('إزالة', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MainTheme.backgroundColor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Modern Profile Header with Gradient
            _buildHeader(),
            const SizedBox(height: 20),
            // Toggle
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
                transitionBuilder: (Widget child, Animation<double> animation) {
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
                        _statsView == 'Surahs' ? 'ترتيب القرآن' : 'ترتيب الأجزاء',
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
            // Section Header
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
                      color: MainTheme.textPrimary,
                    ),
                  ),
                  if (_currentView == 'Your Friends')
                    TextButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const PersonSearchPage(),
                          ),
                        );
                      },
                      icon: const Icon(Icons.person_add_outlined, size: 18),
                      label: const Text('إضافة صديق'),
                      style: TextButton.styleFrom(
                        foregroundColor: MainTheme.primaryColor,
                        textStyle: const TextStyle(fontFamily: 'Amiri', fontWeight: FontWeight.bold),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 400),
              transitionBuilder: (Widget child, Animation<double> animation) {
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
              child: _buildCurrentView(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCurrentView() {
    if (_currentView == 'Your Friends') {
      return _buildFriendsList();
    } else if (_currentView == 'Your Khatms') {
      return _buildKhatmsList();
    } else {
      return _buildStatsList();
    }
  }

  Widget _buildFriendsList() {
    return StreamBuilder<List<Map<String, dynamic>>>(
      key: const ValueKey('FriendsList'),
      stream: _friendsStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) _cachedFriends = snapshot.data;
        final data = _cachedFriends;
        if (data == null) {
          return const Center(child: CircularProgressIndicator());
        }
        if (data.isEmpty) {
          return const Padding(
            padding: EdgeInsets.only(top: 50),
            child: Text('ليس لديك أصدقاء حاليا', style: TextStyle(fontFamily: 'Amiri', fontSize: 18, color: MainTheme.textSecondary)),
          );
        }
        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.only(bottom: 30),
          itemCount: data.length,
          itemBuilder: (context, index) {
            return _buildAnimatedListItem(
              index: index,
              child: FriendComponent(
                username: data[index]['username'] ?? 'Unknown',
                level: data[index]['level'] ?? 1,
                lastSeen: data[index]['lastSeen'] as Timestamp?,
                trailing: IconButton(
                  icon: const Icon(Icons.person_remove_outlined, color: Colors.red, size: 22),
                  onPressed: () => _showUnfriendDialog(data[index]['uid'] ?? ''),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildKhatmsList() {
    return StreamBuilder<List<Map<String, dynamic>>>(
      key: const ValueKey('KhatmsList'),
      stream: _khatmsStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) _cachedKhatms = snapshot.data;
        final data = _cachedKhatms;
        if (data == null) {
          return const Center(child: CircularProgressIndicator());
        }
        if (data.isEmpty) {
          return const Padding(
            padding: EdgeInsets.only(top: 50),
            child: Text('لا توجد ختمات نشطة', style: TextStyle(fontFamily: 'Amiri', fontSize: 18, color: MainTheme.textSecondary)),
          );
        }
        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.only(bottom: 30),
          itemCount: data.length,
          itemBuilder: (context, index) {
            return _buildAnimatedListItem(
              index: index,
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => KhetmaPage(
                        khetmaUid: data[index]['khetmaId']?.toString() ?? '',
                      ),
                    ),
                  );
                },
                child: KhetmaComponent(
                  title: data[index]['name'] ?? 'Unknown',
                  progress: (data[index]['completionPercent'] as num?)?.toDouble() ?? 0.0,
                  participantsCount: data[index]['currentParticipantsNumber'] ?? 0,
                  createdAt: data[index]['createdAt'] as Timestamp?,
                  updatedAt: data[index]['updatedAt'] as Timestamp?,
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildStatsList() {
    final data = _buildStatsFromCache();

    if (_rawReadingStats == null) {
      return const Center(
        key: ValueKey('StatsLoading'),
        child: CircularProgressIndicator(),
      );
    }

    if (data.isEmpty) {
      return const Padding(
        key: ValueKey('StatsEmpty'),
        padding: EdgeInsets.only(top: 50),
        child: Text('لا توجد إحصائيات', style: TextStyle(fontFamily: 'Amiri', fontSize: 18, color: MainTheme.textSecondary)),
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
                  ? sourasWithAyahs.keys.toList().indexOf(item['name']) + 1 
                  : juzusList.indexOf(item['name']) + 1;
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => QuranViewPage(
                    id: id,
                    isSurah: _statsView == 'Surahs',
                    title: item['name'],
                  ),
                ),
              );
            },
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.03),
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
                    decoration: BoxDecoration(
                      color: MainTheme.greyishColor,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.menu_book, color: MainTheme.primaryColor),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: Text(
                      item['name'],
                      style: const TextStyle(
                        fontFamily: 'Amiri',
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: MainTheme.textPrimary,
                      ),
                      textDirection: TextDirection.rtl,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                    decoration: BoxDecoration(
                      color: MainTheme.primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Text(
                      "${item['count']} مرة",
                      textDirection: TextDirection.ltr,
                      style: const TextStyle(
                        fontFamily: 'Amiri',
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: MainTheme.primaryColor,
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

  Widget _buildAnimatedListItem({required int index, required Widget child}) {
    return TweenAnimationBuilder<double>(
      key: ValueKey('anim-$index'),
      tween: Tween(begin: 0.0, end: 1.0),
      duration: Duration(milliseconds: 300 + (index * 50).clamp(0, 500)),
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

  Widget _buildHeader() {
    return StreamBuilder<Map<String, dynamic>>(
      stream: _profileTopDataStream,
      builder: (context, snapshot) {
        final userData = snapshot.data;
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(20, 60, 20, 40),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                MainTheme.primaryColor.withOpacity(0.5),
                MainTheme.primaryColor.withOpacity(1.0),
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
              // Top Buttons
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
                          onTap: () => Navigator.pop(context),
                        ),
                      if (Navigator.of(context).canPop()) const SizedBox(width: 8),
                      KhetmtiHeader.buildHeaderIcon(
                        Icons.settings,
                        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const SettingsPage(showBackButton: true))),
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
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const NotificationsPage()),
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(height: 30),
              // Profile Info Row (Avatar Left, Text Column Right in RTL)
              Row(
                textDirection: TextDirection.rtl,
                children: [
                  // Text Column (Right side in RTL, now centered in available space)
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center, // Centered text
                      children: [
                        Text(
                          userData?['username'] ?? 'جاري التحميل...',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontFamily: 'Amiri',
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: MainTheme.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 12),
                        // Level & Rank
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: const Color(0xFFC0FAD9),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                "المستوى: ${userData?['level'] ?? 1}",
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
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Colors.white.withOpacity(0.5)),
                              ),
                              child: Text(
                                _getRankName(userData?['level'] ?? 1),
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
                        // XP Progress Bar
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 40),
                          child: Builder(
                            builder: (context) {
                              int totalXP = userData?['totalXP'] ?? 0;
                              int currentLevel = userData?['level'] ?? 1;
                              double minXP = 5000 * (math.pow(1.2, currentLevel - 1) - 1);
                              double maxXP = 5000 * (math.pow(1.2, currentLevel) - 1);
                              double progress = (totalXP - minXP) / (maxXP - minXP);
                              if (progress < 0) progress = 0;
                              if (progress > 1) progress = 1;

                              return Column(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: LinearProgressIndicator(
                                      value: progress,
                                      backgroundColor: Colors.white.withOpacity(0.3),
                                      color: Colors.white,
                                      minHeight: 8,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    "${(totalXP - minXP).toInt()} / ${(maxXP - minXP).toInt()} XP",
                                    style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 8),
                        /*const Text(
                          'عضو منذ 2024',
                          style: TextStyle(
                            fontFamily: 'Amiri',
                            color: Colors.white,
                            fontSize: 14,
                          ),
                        ),*/
                      ],
                    ),
                  ),
                  const SizedBox(width: 40), // Increased left margin for avatar (in RTL, this is to the left of the avatar)
                  // Avatar Section (Left side in RTL)
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
                            (userData?['username'] ?? "U")[0].toUpperCase(),
                            style: const TextStyle(
                              fontSize: 36,
                              fontWeight: FontWeight.bold,
                              color: MainTheme.primaryColor,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: MainTheme.primaryColor,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.white, width: 2),
                          ),
                          child: const Text(
                            'نشط',
                            style: TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold),
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
      },
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
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? MainTheme.primaryColor : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? MainTheme.primaryColor : MainTheme.greyishColor,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: MainTheme.primaryColor.withOpacity(0.3),
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
            color: isSelected ? Colors.white : MainTheme.secondaryColor,
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
