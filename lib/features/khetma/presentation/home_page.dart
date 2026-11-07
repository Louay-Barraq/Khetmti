import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:khetmti/core/theme/app_theme.dart';
import 'package:khetmti/features/khetma/models/khetma.dart';
import 'package:khetmti/features/khetma/providers/khetma_provider.dart';
import 'package:khetmti/shared/widgets/khetma_card.dart';
import 'package:khetmti/shared/widgets/khetmti_header.dart';
import 'package:khetmti/shared/widgets/state_switch.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  String _currentView = 'In Progress';

  @override
  Widget build(BuildContext context) {
    final inProgressAsync = ref.watch(userKhetmasProvider(false));
    final completedAsync = ref.watch(userKhetmasProvider(true));

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: Stack(
        children: [
          Column(
            children: [
              KhetmtiHeader(
                title: 'ختمـتي',
                showProfile: true,
                showBackButton: false,
                icon: Icons.emoji_events,
                onNotificationTap: () => context.push('/notifications'),
                onProfileTap: () => context.push('/rankings'),
                bottom: StateSwitch(
                  onSwitchChanged: (value) {
                    setState(() {
                      _currentView = value;
                    });
                  },
                ),
              ),
              const SizedBox(height: 10),
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
                          color: AppTheme.textPrimary,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () {},
                      child: const Text(
                        'عرض الكل',
                        style: TextStyle(
                          fontFamily: 'Amiri',
                          color: AppTheme.primaryColor,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 400),
                  child: _buildKhatmsList(
                    _currentView == 'In Progress' ? inProgressAsync : completedAsync,
                  ),
                ),
              ),
            ],
          ),
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

  Widget _buildKhatmsList(AsyncValue<List<Khetma>> asyncKhetmas) {
    return asyncKhetmas.when(
      loading: () => const Center(
        key: ValueKey('loading'),
        child: CircularProgressIndicator(),
      ),
      error: (_, __) => const Center(
        key: ValueKey('error'),
        child: Text("Error loading data"),
      ),
      data: (khetmas) {
        if (khetmas.isEmpty) {
          return Center(
            key: ValueKey('empty-$_currentView'),
            child: Text(
              _currentView == 'In Progress' ? 'لا توجد ختمات نشطة' : 'لا توجد ختمات مكتملة',
              style: const TextStyle(
                fontFamily: 'Amiri',
                fontSize: 18,
                color: AppTheme.textSecondary,
              ),
            ),
          );
        }
        return ListView.builder(
          key: ValueKey('list-$_currentView'),
          padding: const EdgeInsets.only(bottom: 100),
          itemCount: khetmas.length,
          itemBuilder: (context, index) {
            final khetma = khetmas[index];
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
                title: khetma.name,
                progress: khetma.completionPercent,
                participantsCount: khetma.currentParticipantsNumber,
                createdAt: khetma.createdAt,
                updatedAt: khetma.updatedAt,
                onTap: () {
                  context.push('/khetma/${khetma.khetmaId}');
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
        color: AppTheme.primaryColor,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryColor.withValues(alpha: 0.4),
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
            context.push('/khetma/create');
          },
          child: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              textDirection: TextDirection.rtl,
              children: [
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
