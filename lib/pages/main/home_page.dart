import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:khetmti/components/khetma_component.dart';
import 'package:khetmti/components/khetmti_header.dart';
import 'package:khetmti/components/state_switch.dart';
import 'package:khetmti/pages/Khetma/Khetma_page.dart';
import 'package:khetmti/pages/actions/khetma_creation_page.dart';
import 'package:khetmti/pages/actions/notifications_page.dart';
import 'package:khetmti/pages/main/rankings_page.dart';
import '../../themes/main_theme.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _currentView = 'In Progress';
  Stream<List<Map<String, dynamic>>>? _inProgressStream;
  Stream<List<Map<String, dynamic>>>? _completedStream;

  @override
  void initState() {
    super.initState();
    _inProgressStream = _buildKhatmsStream('In Progress');
    _completedStream = _buildKhatmsStream('Completed');
  }

  Stream<List<Map<String, dynamic>>> _buildKhatmsStream(String view) {
    final userId = FirebaseAuth.instance.currentUser?.uid;

    if (view == 'In Progress') {
      return FirebaseFirestore.instance
          .collection('khatms')
          .where('participants', arrayContains: userId)
          .where('completionPercent', isLessThan: 1.0)
          .snapshots()
          .map((snapshot) => snapshot.docs.map((doc) => doc.data()).toList());
    } else {
      return FirebaseFirestore.instance
          .collection('khatms')
          .where('participants', arrayContains: userId)
          .where('completionPercent', isEqualTo: 1.0)
          .snapshots()
          .map((snapshot) => snapshot.docs.map((doc) => doc.data()).toList());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MainTheme.backgroundColor,
      body: Stack(
        children: [
          Column(
            children: [
              // Standardized Header
              KhetmtiHeader(
                title: 'ختمـتي',
                showProfile: true,
                showBackButton: false,
                icon: Icons.emoji_events,
                onNotificationTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => NotificationsPage())),
                onProfileTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const RankingsPage())),
                bottom: StateSwitch(
                  onSwitchChanged: (value) {
                    setState(() {
                      _currentView = value;
                    });
                  },
                ),
              ),
              const SizedBox(height: 10),
              // Section Title
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  textDirection: TextDirection.rtl,
                  children: [
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      child: Text(
                        _currentView == 'In Progress' ? 'ختماتك النشطة' : 'ختماتك المكتملة',
                        key: ValueKey(_currentView),
                        style: const TextStyle(
                          fontFamily: 'Amiri',
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: MainTheme.textPrimary,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () {},
                      child: const Text(
                        'عرض الكل',
                        style: TextStyle(
                          fontFamily: 'Amiri',
                          color: MainTheme.primaryColor,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Khatmas List
              Expanded(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 400),
                  child: _buildKhatmsList(),
                ),
              ),
            ],
          ),
          // Floating Bottom Button
          Positioned(
            bottom: 30,
            left: 0,
            right: 0,
            child: Center(
              child: _buildCreateButton(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildKhatmsList() {
    final stream = _currentView == 'In Progress' ? _inProgressStream : _completedStream;
    return StreamBuilder<List<Map<String, dynamic>>>(
      key: ValueKey(_currentView),
      stream: stream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting && !snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return const Center(child: Text("Error loading data"));
        }
        final data = snapshot.data ?? [];
        if (data.isEmpty) {
          return Center(
            child: Text(
              _currentView == 'In Progress' ? 'لا توجد ختمات نشطة' : 'لا توجد ختمات مكتملة',
              style: const TextStyle(
                fontFamily: 'Amiri',
                fontSize: 18,
                color: MainTheme.textSecondary,
              ),
            ),
          );
        }
        return ListView.builder(
          padding: const EdgeInsets.only(bottom: 100),
          itemCount: data.length,
          itemBuilder: (context, index) {
            return TweenAnimationBuilder<double>(
              key: ValueKey('home-anim-$index'),
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
              child: KhetmaComponent(
                title: data[index]['name'] ?? 'Unknown',
                progress: (data[index]['completionPercent'] as num?)?.toDouble() ?? 0.0,
                participantsCount: data[index]['currentParticipantsNumber'] ?? 0,
                createdAt: data[index]['createdAt'] as Timestamp?,
                updatedAt: data[index]['updatedAt'] as Timestamp?,
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
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildCreateButton() {
    return Container(
      decoration: BoxDecoration(
        color: MainTheme.primaryColor,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: MainTheme.primaryColor.withValues(alpha: 0.4),
            offset: const Offset(0, 8),
            blurRadius: 15,
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(30),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const KhetmaCreationPage()),
            );
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              textDirection: TextDirection.rtl,
              children: const [
                Icon(Icons.add, color: Colors.white),
                SizedBox(width: 10),
                Text(
                  'إنشاء ختمة جديدة',
                  style: TextStyle(
                    fontFamily: 'Amiri',
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
