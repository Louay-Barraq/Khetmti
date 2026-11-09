import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:khetmti/core/providers/supabase_providers.dart';
import 'package:khetmti/core/theme/app_theme.dart';
import 'package:khetmti/features/auth/presentation/login_page.dart';
import 'package:khetmti/features/auth/presentation/register_page.dart';
import 'package:khetmti/features/auth/presentation/reset_password_page.dart';
import 'package:khetmti/features/khetma/presentation/home_page.dart';
import 'package:khetmti/features/khetma/presentation/menu_page.dart';
import 'package:khetmti/features/khetma/presentation/khetma_detail_page.dart';
import 'package:khetmti/features/khetma/presentation/khetma_creation_page.dart';
import 'package:khetmti/features/khetma/presentation/join_khetma_page.dart';
import 'package:khetmti/features/quran/presentation/quran_view_page.dart';
import 'package:khetmti/features/social/presentation/person_search_page.dart';
import 'package:khetmti/features/social/presentation/friend_requests_page.dart';
import 'package:khetmti/features/profile/presentation/profile_page.dart';
import 'package:khetmti/features/profile/presentation/rankings_page.dart';
import 'package:khetmti/features/settings/presentation/settings_page.dart';
import 'package:khetmti/features/settings/presentation/change_username_page.dart';
import 'package:khetmti/features/settings/presentation/change_email_page.dart';
import 'package:khetmti/features/settings/presentation/change_password_page.dart';
import 'package:khetmti/features/settings/presentation/help_page.dart';
import 'package:khetmti/features/settings/presentation/about_page.dart';
import 'package:khetmti/features/notifications/presentation/notifications_page.dart';
import 'package:khetmti/features/onboarding/presentation/splash_screen.dart';
import 'package:khetmti/features/onboarding/presentation/onboarding_page.dart';
import 'package:khetmti/features/auth/providers/auth_provider.dart';
import 'package:khetmti/shared/widgets/bottom_nav_bar.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();

const _authRoutes = {'/login', '/register'};
const _openRoutes = {'/splash', '/onboarding'};

/// Where to send the user, or null to stay. Kept free of Flutter types so
/// it can be unit tested.
String? authRedirect({
  required String location,
  required bool authLoading,
  required bool loggedIn,
}) {
  if (_openRoutes.contains(location) || authLoading) return null;
  final onAuthRoute = _authRoutes.contains(location);
  if (!loggedIn) return onAuthRoute ? null : '/login';
  if (onAuthRoute) return '/home';
  return null;
}

/// Built once. Auth changes re-run [GoRouter.redirect] through
/// `refreshListenable` instead of rebuilding the router, which would reset
/// navigation to /splash (e.g. after changing the username).
final routerProvider = Provider<GoRouter>((ref) {
  final authChanged = ValueNotifier(0);
  // Not on token refreshes: only when loading ends or the user changes.
  ref.listen(
    authStateProvider.select((s) => (s.isLoading, s.valueOrNull?.id)),
    (_, __) => authChanged.value++,
  );
  ref.onDispose(authChanged.dispose);

  final router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/splash',
    refreshListenable: authChanged,
    redirect: (context, state) {
      final auth = ref.read(authStateProvider);
      return authRedirect(
        location: state.matchedLocation,
        authLoading: auth.isLoading,
        loggedIn: auth.valueOrNull != null,
      );
    },
    routes: [
      GoRoute(path: '/splash', builder: (_, __) => const SplashScreen()),
      GoRoute(path: '/onboarding', builder: (_, __) => const OnboardingPage()),
      GoRoute(path: '/login', builder: (_, __) => const LoginPage()),
      GoRoute(path: '/register', builder: (_, __) => const RegisterPage()),
      GoRoute(
        path: '/reset-password',
        builder: (_, __) => const ResetPasswordPage(),
      ),
      StatefulShellRoute(
        builder: (_, __, shell) => IndexShell(shell: shell),
        navigatorContainerBuilder: (_, shell, children) =>
            _FadingBranches(index: shell.currentIndex, children: children),
        branches: [
          _branch('/home', const HomePage()),
          _branch('/menu', const MenuPage()),
          _branch('/settings', const SettingsPage()),
          _branch('/profile', const ProfilePage()),
        ],
      ),
      GoRoute(
        path: '/khetma/create',
        builder: (_, __) => const KhetmaCreationPage(),
      ),
      GoRoute(
        path: '/khetma/join',
        builder: (_, __) => const JoinKhetmaPage(),
      ),
      GoRoute(
        path: '/khetma/:id',
        builder: (_, state) => KhetmaDetailPage(
          khetmaId: state.pathParameters['id']!,
        ),
      ),
      GoRoute(
        path: '/quran/:type/:id',
        builder: (_, state) {
          final isSurah = state.pathParameters['type'] == 'surah';
          final id = int.parse(state.pathParameters['id']!);
          final title = state.uri.queryParameters['title'] ?? '';
          final khatmaId = state.uri.queryParameters['khatmaId'];
          return QuranViewPage(
            id: id,
            isSurah: isSurah,
            title: title,
            khatmaId: khatmaId,
          );
        },
      ),
      GoRoute(
        path: '/friends/search',
        builder: (_, __) => const PersonSearchPage(),
      ),
      GoRoute(
        path: '/friends/requests',
        builder: (_, __) => const FriendRequestsPage(),
      ),
      GoRoute(path: '/rankings', builder: (_, __) => const RankingsPage()),
      GoRoute(
        path: '/settings/username',
        builder: (_, __) => const ChangeUsernamePage(),
      ),
      GoRoute(
        path: '/settings/email',
        builder: (_, __) => const ChangeEmailPage(),
      ),
      GoRoute(
        path: '/settings/password',
        builder: (_, __) => const ChangePasswordPage(),
      ),
      GoRoute(
        path: '/notifications',
        builder: (_, __) => const NotificationsPage(),
      ),
      GoRoute(path: '/help', builder: (_, __) => const HelpPage()),
      GoRoute(path: '/about', builder: (_, __) => const AboutPage()),
    ],
  );

  // The reset-password email link signs the user in with a recovery
  // session; send them to the page that sets the new password.
  final StreamSubscription<AuthState> recovery = ref
      .watch(supabaseClientProvider)
      .auth
      .onAuthStateChange
      .where((s) => s.event == AuthChangeEvent.passwordRecovery)
      .listen((_) => router.go('/reset-password'));
  ref.onDispose(recovery.cancel);

  return router;
});

StatefulShellBranch _branch(String path, Widget page) => StatefulShellBranch(
      routes: [GoRoute(path: path, builder: (_, __) => page)],
    );

/// Keeps every visited tab alive (scroll position, loaded data) and
/// cross-fades between them.
class _FadingBranches extends StatelessWidget {
  final int index;
  final List<Widget> children;

  const _FadingBranches({required this.index, required this.children});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        for (var i = 0; i < children.length; i++)
          IgnorePointer(
            ignoring: i != index,
            child: TickerMode(
              enabled: i == index,
              child: AnimatedOpacity(
                opacity: i == index ? 1 : 0,
                duration: AppTheme.fast,
                curve: Curves.easeOut,
                child: AnimatedSlide(
                  offset: i == index ? Offset.zero : const Offset(0, 0.015),
                  duration: AppTheme.medium,
                  curve: AppTheme.curve,
                  child: children[i],
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class IndexShell extends StatelessWidget {
  final StatefulNavigationShell shell;
  const IndexShell({super.key, required this.shell});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: shell,
      bottomNavigationBar: CustomBottomNavigationBar(
        selectedIndex: shell.currentIndex,
        // Tapping the current tab again returns it to its first page.
        onItemTapped: (i) =>
            shell.goBranch(i, initialLocation: i == shell.currentIndex),
      ),
    );
  }
}
