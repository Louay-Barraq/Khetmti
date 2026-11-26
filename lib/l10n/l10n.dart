import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app_localizations.dart';

export 'app_localizations.dart';

/// App language. Arabic is the main language and the default; the user can
/// switch in Settings and the choice is kept on the device.
class L10n {
  static const supported = [Locale('ar'), Locale('en'), Locale('fr'), Locale('es')];
  static const _prefsKey = 'app_locale';

  static Locale locale = const Locale('ar');
  static AppLocalizations current = lookupAppLocalizations(locale);

  static bool get isArabic => locale.languageCode == 'ar';

  /// Reads the saved language before the first frame.
  static Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    _apply(prefs.getString(_prefsKey) ?? 'ar');
  }

  static Future<void> save(String code) async {
    _apply(code);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_prefsKey, code);
  }

  static void _apply(String code) {
    locale = supported.firstWhere((l) => l.languageCode == code, orElse: () => supported.first);
    current = lookupAppLocalizations(locale);
  }
}

/// Current app language for the widget tree; [setAppLanguage] changes it.
final localeProvider = StateProvider<Locale>((ref) => L10n.locale);

/// Saves the language and rebuilds the app in it.
Future<void> setAppLanguage(WidgetRef ref, String code) async {
  await L10n.save(code);
  ref.read(localeProvider.notifier).state = L10n.locale;
  // Widgets that read `tr` don't depend on Localizations, and pages kept alive by the
  // router's navigators would otherwise keep the old strings: rebuild everything once.
  WidgetsBinding.instance.addPostFrameCallback((_) {
    void mark(Element e) {
      e.markNeedsBuild();
      e.visitChildren(mark);
    }

    WidgetsBinding.instance.rootElement?.visitChildren(mark);
  });
}

/// Native names for the language picker.
const languageNames = {'ar': 'العربية', 'en': 'English', 'fr': 'Français', 'es': 'Español'};

/// Strings in the current language. Usable without a BuildContext (repositories,
/// toasts); the whole widget tree is rebuilt when the language changes.
AppLocalizations get tr => L10n.current;
