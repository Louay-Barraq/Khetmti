// Store-screenshot build: the real app on built-in demo data, no account needed and nothing
// written to the database. Not part of release builds (they use lib/main.dart).
//
//   flutter build ios --simulator -t lib/main_screenshots.dart \
//     --dart-define-from-file=config/env.json --dart-define=SHOT_LANG=en
import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:khetmti/app.dart';
import 'package:khetmti/core/config/env.dart';
import 'package:khetmti/demo/demo_data.dart';
import 'package:khetmti/features/auth/providers/auth_provider.dart';
import 'package:khetmti/features/khetma/providers/khetma_provider.dart';
import 'package:khetmti/features/quran/data/quran_api_service.dart';
import 'package:khetmti/features/social/providers/social_provider.dart';
import 'package:khetmti/l10n/l10n.dart';
import 'package:khetmti/router/app_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await L10n.save(const String.fromEnvironment('SHOT_LANG', defaultValue: 'ar'));
  (await SharedPreferences.getInstance()).setBool('onboarding', true);

  // Repositories expect an initialised client; the demo overrides keep every screen off the network.
  Env.ensureConfigured();
  await Supabase.initialize(url: Env.supabaseUrl, anonKey: Env.supabaseAnonKey);

  final user = User(
    id: demoUserId,
    appMetadata: const {},
    userMetadata: const {},
    aud: 'authenticated',
    createdAt: '2026-03-01T00:00:00Z',
  );
  final khetmas = demoKhetmas;

  final container = ProviderContainer(
    overrides: [
      authStateProvider.overrideWith((ref) => Stream.value(user)),
      currentUserProvider.overrideWith((ref) => Stream.value(demoMe)),
      userKhetmasProvider.overrideWith(
          (ref, completed) => AsyncData(khetmas.where((k) => k.isCompleted == completed).toList())),
      khetmaProvider.overrideWith((ref, id) => AsyncData(khetmas.firstWhere((k) => k.khetmaId == id))),
      khetmaParticipantsProvider.overrideWith((ref, id) async => demoParticipants(id)),
      friendshipsProvider.overrideWith((ref) => Stream.value(const [])),
      friendsProvider.overrideWith((ref) => AsyncData(demoFriends)),
      friendRequestsProvider.overrideWith((ref) => AsyncData(demoRequests)),
    ],
  );
  runApp(UncontrolledProviderScope(container: container, child: const KhetmtiApp()));

  // `xcrun simctl openurl booted khetmti://shot/khetma/k2` opens /khetma/k2 (and so on for any route).
  AppLinks().uriLinkStream.listen((uri) {
    if (uri.host != 'shot') return;
    final router = container.read(routerProvider);
    final path = uri.path.isEmpty ? '/home' : uri.path;
    const tabs = {'/home', '/menu', '/settings', '/profile'};
    tabs.contains(path) ? router.go(path) : router.push(path);
  });

  QuranApiService.warmUp().ignore();
}
