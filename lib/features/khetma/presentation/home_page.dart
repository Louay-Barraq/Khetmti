import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:khetmti/core/theme/app_theme.dart';
import 'package:khetmti/features/khetma/models/khetma.dart';
import 'package:khetmti/features/khetma/providers/khetma_provider.dart';
import 'package:khetmti/shared/widgets/khetma_card.dart';
import 'package:khetmti/shared/widgets/khetmti_header.dart';
import 'package:khetmti/shared/widgets/motion.dart';
import 'package:khetmti/shared/widgets/state_switch.dart';
import 'package:khetmti/l10n/l10n.dart';

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
                title: tr.appTitle,
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
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 6),
                child: Row(
                  children: [
                    Expanded(
                      child: SmoothSwitcher(
                        duration: AppTheme.fast,
                        child: Align(
                          key: ValueKey(_currentView),
                          alignment: AlignmentDirectional.centerStart,
                          child: Text(
                            _currentView == 'In Progress'
                                ? tr.activeKhatmas
                                : tr.completedKhatmas,
                            style: TextStyle(
                              fontFamily: AppTheme.font,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.textPrimary,
                            ),
                          ),
                        ),
                      ),
                    ),
                    TextButton.icon(
                      onPressed: () => context.push('/khetma/join'),
                      icon: const Icon(Icons.group_add_outlined, size: 20),
                      label: Text(tr.join),
                      style: TextButton.styleFrom(
                        foregroundColor: AppTheme.primaryColor,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: SmoothSwitcher(
                  child: _buildKhatmsList(
                    _currentView == 'In Progress'
                        ? inProgressAsync
                        : completedAsync,
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
      skipLoadingOnReload: true,
      loading: () => const Center(
        key: ValueKey('loading'),
        child: CircularProgressIndicator(),
      ),
      error: (_, __) => Center(
        key: ValueKey('error'),
        child: Text(
          tr.loadKhatmasHomeError,
          style: TextStyle(fontSize: 17, color: AppTheme.textSecondary),
        ),
      ),
      data: (khetmas) {
        if (khetmas.isEmpty) {
          return _EmptyHome(
            key: ValueKey('empty-$_currentView'),
            active: _currentView == 'In Progress',
          );
        }
        return ListView.builder(
          key: ValueKey('list-$_currentView'),
          padding: const EdgeInsets.only(bottom: 110),
          itemCount: khetmas.length,
          itemBuilder: (context, index) {
            final khetma = khetmas[index];
            return FadeSlideIn(
              key: ValueKey(khetma.khetmaId),
              index: index,
              child: KhetmaComponent(
                title: khetma.name,
                progress: khetma.completionPercent,
                participantsCount: khetma.currentParticipantsNumber,
                createdAt: khetma.createdAt,
                updatedAt: khetma.updatedAt,
                onTap: () => context.push('/khetma/${khetma.khetmaId}'),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildCreateButton() {
    return Pressable(
      onTap: () => context.push('/khetma/create'),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
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
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.add, color: Colors.white),
            SizedBox(width: 10),
            Text(
              tr.createNewKhatma,
              style: TextStyle(
                fontFamily: AppTheme.font,
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyHome extends StatelessWidget {
  final bool active;
  const _EmptyHome({super.key, required this.active});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(40, 0, 40, 100),
        child: FadeSlideIn(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(22),
                decoration: const BoxDecoration(
                  color: AppTheme.softGreen,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  active
                      ? Icons.menu_book_rounded
                      : Icons.emoji_events_outlined,
                  size: 44,
                  color: AppTheme.primaryColor,
                ),
              ),
              const SizedBox(height: 18),
              Text(
                active ? tr.noActiveKhatmas : tr.noCompletedYet,
                style: TextStyle(
                  fontFamily: AppTheme.font,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textPrimary,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                active
                    ? tr.emptyActiveHint
                    : tr.emptyCompletedHint,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: AppTheme.font,
                  fontSize: 16,
                  color: AppTheme.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
