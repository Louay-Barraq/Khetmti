import 'package:flutter/material.dart';
import 'package:khetmti/components/khetmti_header.dart';
import 'package:khetmti/pages/actions/khetma_creation_page.dart';
import '../../components/possible_action_component.dart';
import 'package:khetmti/pages/main/profile_page.dart';
import 'package:khetmti/pages/main/settings_page.dart';
import 'package:khetmti/pages/actions/notifications_page.dart';
import 'package:khetmti/pages/actions/join_khatma_page.dart';
import 'package:khetmti/pages/actions/person_search_page.dart';
import 'package:khetmti/pages/actions/friend_requests_page.dart';
import '../../themes/main_theme.dart';

class MenuPage extends StatelessWidget {
  const MenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MainTheme.backgroundColor,
      body: Column(
        children: [
          KhetmtiHeader(
            title: 'القائمة',
            showProfile: true,
            showNotification: true,
            onNotificationTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => NotificationsPage())),
            onProfileTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ProfilePage())),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Column(
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        'الختمات',
                        style: TextStyle(
                          fontFamily: 'Amiri',
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: MainTheme.textPrimary,
                        ),
                      ),
                    ),
                  ),
                  _buildAction(
                    context,
                    title: "إنشاء ختمة جديدة",
                    subtitle: "ابدأ رحلة تلاوة جديدة وشاركها مع من تحب",
                    icon: Icons.add_circle_outline,
                    page: const KhetmaCreationPage(),
                  ),
                  _buildAction(
                    context,
                    title: "الإنضمام لختمة موجودة",
                    subtitle: "ابحث عن مجموعات تلاوة وانضم إليهم",
                    icon: Icons.search,
                    page: const JoinKhatmaPage(),
                  ),
                  const SizedBox(height: 20),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        'الأصدقاء',
                        style: TextStyle(
                          fontFamily: 'Amiri',
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: MainTheme.textPrimary,
                        ),
                      ),
                    ),
                  ),
                  _buildAction(
                    context,
                    title: "البحث عن شخص",
                    subtitle: "تواصل مع أصدقائك وتابع تقدمهم",
                    icon: Icons.person_add_outlined,
                    page: const PersonSearchPage(),
                  ),
                  _buildAction(
                    context,
                    title: "طلبات الصداقة",
                    subtitle: "شاهد من يريد أن يكون صديقك",
                    icon: Icons.people_outline,
                    page: const FriendRequestsPage(),
                  ),
                  const SizedBox(height: 30),
                  _buildAdviceCard(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAction(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required Widget page,
  }) {
    return PossibleActionComponent(
      actionText: title,
      subtitle: subtitle,
      icon: icon,
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => page),
        );
      },
    );
  }

  Widget _buildAdviceCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFECFDF5),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: MainTheme.primaryColor.withOpacity(0.2)),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: const BoxDecoration(
              color: MainTheme.primaryColor,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.menu_book, color: Colors.white, size: 30),
          ),
          const SizedBox(height: 15),
          const Text(
            'هل تريد نصيحة؟',
            style: TextStyle(
              fontFamily: 'Amiri',
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: MainTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            'قراءة صفحتين يومياً تعينك على ختم القرآن في عام واحد.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Amiri',
              fontSize: 16,
              color: MainTheme.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
