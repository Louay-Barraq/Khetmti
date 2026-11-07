import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:khetmti/core/utils/helpers.dart';
import 'package:khetmti/router/app_router.dart';

class KhetmtiApp extends ConsumerWidget {
  const KhetmtiApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Khetmti',
      theme: ThemeData(
        useMaterial3: true,
        pageTransitionsTheme: const PageTransitionsTheme(
          builders: {
            TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
            TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
          },
        ),
      ),
      scaffoldMessengerKey: scaffoldMessengerKey,
      routerConfig: router,
    );
  }
}
