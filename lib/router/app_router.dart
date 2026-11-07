import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:khetmti/features/auth/presentation/login_page.dart';
import 'package:khetmti/features/auth/presentation/register_page.dart';
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

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

/// Built once. Auth changes re-run [GoRouter.redirect] through
/// `refreshListenable` instead of rebuilding the router, which would reset
/// navigation to /splash (e.g. after changing the username).
final routerProvider = Provider<GoRouter>((ref) {
  final authChanged = ValueNotifier(0);
  ref.listen(authStateProvider, (_, __) => authChanged.value++);
  ref.onDispose(authChanged.dispose);

  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/splash',
    refreshListenable: authChanged,
    redirect: (context, state) {
      final authState = ref.read(authStateProvider);
      final isLoading = authState.isLoading;
      final isLoggedIn = authState.valueOrNull != null;
      final isAuthRoute = state.matchedLocation == '/login' ||
          state.matchedLocation == '/register';
      final isSplash = state.matchedLocation == '/splash';
      final isOnboarding = state.matchedLocation == '/onboarding';

      if (isSplash || isOnboarding) return null;

      // While auth state is loading, don't redirect — stay on current route
      if (isLoading) return null;

      if (!isLoggedIn && !isAuthRoute) return '/login';
      if (isLoggedIn && isAuthRoute) return '/home';

      return null;
    },
    routes: [
      GoRoute(
        path: '/splash',
        builder: (_, __) => const SplashScreen(),
      ),
      GoRoute(
        path: '/onboarding',
        builder: (_, __) => const OnboardingPage(),
      ),
      GoRoute(
        path: '/login',
        builder: (_, __) => const LoginPage(),
      ),
      GoRoute(
        path: '/register',
        builder: (_, __) => const RegisterPage(),
      ),
      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        builder: (_, state, child) => IndexShell(child: child),
        routes: [
          GoRoute(
            path: '/home',
            pageBuilder: (_, __) => const NoTransitionPage(
              child: HomePage(),
            ),
          ),
          GoRoute(
            path: '/menu',
            pageBuilder: (_, __) => const NoTransitionPage(
              child: MenuPage(),
            ),
          ),
          GoRoute(
            path: '/settings',
            pageBuilder: (_, __) => const NoTransitionPage(
              child: SettingsPage(),
            ),
          ),
          GoRoute(
            path: '/profile',
            pageBuilder: (_, __) => const NoTransitionPage(
              child: ProfilePage(),
            ),
          ),
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
      GoRoute(
        path: '/rankings',
        builder: (_, __) => const RankingsPage(),
      ),
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
      GoRoute(
        path: '/help',
        builder: (_, __) => const HelpPage(),
      ),
      GoRoute(
        path: '/about',
        builder: (_, __) => const AboutPage(),
      ),
    ],
  );
});

class IndexShell extends StatefulWidget {
  final Widget child;
  const IndexShell({super.key, required this.child});

  @override
  State<IndexShell> createState() => _IndexShellState();
}

class _IndexShellState extends State<IndexShell> {
  int _selectedIndex = 0;

  static const _routes = ['/home', '/menu', '/settings', '/profile'];

  void _onItemTapped(int index) {
    if (index != _selectedIndex) {
      setState(() => _selectedIndex = index);
      context.go(_routes[index]);
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final location = GoRouterState.of(context).matchedLocation;
    final idx = _routes.indexOf(location);
    if (idx != -1 && idx != _selectedIndex) {
      setState(() => _selectedIndex = idx);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.child,
      bottomNavigationBar: CustomBottomNavigationBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}
