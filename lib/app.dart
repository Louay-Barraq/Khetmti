import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:khetmti/core/theme/app_theme.dart';
import 'package:khetmti/core/utils/helpers.dart';
import 'package:khetmti/l10n/l10n.dart';
import 'package:khetmti/router/app_router.dart';

class KhetmtiApp extends ConsumerWidget {
  const KhetmtiApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    final locale = ref.watch(localeProvider);

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Khetmti',
      locale: locale,
      supportedLocales: L10n.supported,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      theme: AppTheme.theme,
      scaffoldMessengerKey: scaffoldMessengerKey,
      routerConfig: router,
      // Tapping outside a text field closes the keyboard, on every page.
      builder: (context, child) => GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: ResponsiveFrame(child: child!),
      ),
    );
  }
}

/// Keeps the layout readable everywhere: very large system font sizes are
/// capped so text does not overflow the cards, and on tablets and wide
/// windows the app keeps a phone-like column in the middle of the screen
/// instead of stretching every card edge to edge.
class ResponsiveFrame extends StatelessWidget {
  final Widget child;
  const ResponsiveFrame({super.key, required this.child});

  static const maxContentWidth = 560.0;

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final base = media.textScaler.clamp(maxScaleFactor: 1.3);
    final capped = media.copyWith(
      // Poppins runs larger than Amiri at the same size: Latin languages are set 10% smaller.
      textScaler: L10n.isArabic ? base : _ScaledText(base, 0.9),
    );
    final width = media.size.width;

    if (width <= maxContentWidth + 80) {
      return MediaQuery(data: capped, child: child);
    }

    return ColoredBox(
      color: const Color(0xFFE9EEF2),
      child: Center(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(media.size.height > 900 ? 28 : 0),
          child: SizedBox(
            width: maxContentWidth,
            child: MediaQuery(
              data: capped.copyWith(size: Size(maxContentWidth, media.size.height)),
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}

class _ScaledText extends TextScaler {
  final TextScaler base;
  final double factor;
  const _ScaledText(this.base, this.factor);

  @override
  double scale(double fontSize) => base.scale(fontSize) * factor;

  @override
  // ignore: deprecated_member_use
  double get textScaleFactor => base.textScaleFactor * factor;

  @override
  bool operator ==(Object other) => other is _ScaledText && other.base == base && other.factor == factor;

  @override
  int get hashCode => Object.hash(base, factor);
}
