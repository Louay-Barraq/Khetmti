import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:khetmti/core/theme/app_theme.dart';
import 'package:khetmti/shared/widgets/khetmti_header.dart';
import 'package:khetmti/shared/widgets/possible_action_component.dart';
import 'package:khetmti/l10n/l10n.dart';

class MenuPage extends StatelessWidget {
  const MenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: Column(
        children: [
          KhetmtiHeader(
            title: tr.menu,
            showProfile: true,
            showNotification: true,
            onNotificationTap: () => context.push('/notifications'),
            onProfileTap: () => context.go('/profile'),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Column(
                children: [
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: Align(
                      alignment: AlignmentDirectional.centerStart,
                      child: Text(
                        tr.khatmas,
                        style: TextStyle(
                          fontFamily: AppTheme.font,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.textPrimary,
                        ),
                      ),
                    ),
                  ),
                  PossibleActionComponent(
                    actionText: tr.createNewKhatma,
                    subtitle: tr.createNewKhatmaDesc,
                    icon: Icons.add_circle_outline,
                    onTap: () => context.push('/khetma/create'),
                  ),
                  PossibleActionComponent(
                    actionText: tr.joinExisting,
                    subtitle: tr.joinExistingDesc,
                    icon: Icons.search,
                    onTap: () => context.push('/khetma/join'),
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: Align(
                      alignment: AlignmentDirectional.centerStart,
                      child: Text(
                        tr.friends,
                        style: TextStyle(
                          fontFamily: AppTheme.font,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.textPrimary,
                        ),
                      ),
                    ),
                  ),
                  PossibleActionComponent(
                    actionText: tr.searchPerson,
                    subtitle: tr.searchPersonDesc,
                    icon: Icons.person_add_outlined,
                    onTap: () => context.push('/friends/search'),
                  ),
                  PossibleActionComponent(
                    actionText: tr.friendRequests,
                    subtitle: tr.friendRequestsDesc,
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
          Text(
            tr.tipTitle,
            style: TextStyle(
              fontFamily: AppTheme.font,
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            tr.tipBody,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: AppTheme.font,
              fontSize: 16,
              color: AppTheme.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
