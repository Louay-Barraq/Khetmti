import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:khetmti/core/theme/app_theme.dart';
import 'package:khetmti/shared/widgets/khetmti_header.dart';
import 'package:khetmti/shared/widgets/possible_action_component.dart';

class MenuPage extends StatelessWidget {
  const MenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: Column(
        children: [
          KhetmtiHeader(
            title: 'القائمة',
            showProfile: true,
            showNotification: true,
            onNotificationTap: () => context.push('/notifications'),
            onProfileTap: () => context.push('/profile'),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Column(
                children: [
                  const Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        'الختمات',
                        style: TextStyle(
                          fontFamily: 'Amiri',
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.textPrimary,
                        ),
                      ),
                    ),
                  ),
                  PossibleActionComponent(
                    actionText: "إنشاء ختمة جديدة",
                    subtitle: "ابدأ رحلة تلاوة جديدة وشاركها مع من تحب",
                    icon: Icons.add_circle_outline,
                    onTap: () => context.push('/khetma/create'),
                  ),
                  PossibleActionComponent(
                    actionText: "الإنضمام لختمة موجودة",
                    subtitle: "ابحث عن مجموعات تلاوة وانضم إليهم",
                    icon: Icons.search,
                    onTap: () => context.push('/khetma/join'),
                  ),
                  const SizedBox(height: 20),
                  const Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        'الأصدقاء',
                        style: TextStyle(
                          fontFamily: 'Amiri',
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.textPrimary,
                        ),
                      ),
                    ),
                  ),
                  PossibleActionComponent(
                    actionText: "البحث عن شخص",
                    subtitle: "تواصل مع أصدقائك وتابع تقدمهم",
                    icon: Icons.person_add_outlined,
                    onTap: () => context.push('/friends/search'),
                  ),
                  PossibleActionComponent(
                    actionText: "طلبات الصداقة",
                    subtitle: "شاهد من يريد أن يكون صديقك",
                    icon: Icons.people_outline,
                    onTap: () => context.push('/friends/requests'),
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

  Widget _buildAdviceCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFECFDF5),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
            color: AppTheme.primaryColor.withValues(alpha: 0.2)),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: const BoxDecoration(
              color: AppTheme.primaryColor,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.menu_book,
                color: Colors.white, size: 30),
          ),
          const SizedBox(height: 15),
          const Text(
            'هل تريد نصيحة؟',
            style: TextStyle(
              fontFamily: 'Amiri',
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            'قراءة صفحتين يومياً تعينك على ختم القرآن في عام واحد.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Amiri',
              fontSize: 16,
              color: AppTheme.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
