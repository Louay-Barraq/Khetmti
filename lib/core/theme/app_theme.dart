import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AppTheme {
  static const Color primaryColor = Color(0xFF00C853);
  static const Color secondaryColor = Color(0xFF101D2D);
  static const Color tertiaryColor = Color(0xFF9DB2CE);
  static const Color backgroundColor = Color(0xFFF8F9FA);
  static const Color cardColor = Colors.white;
  static const Color textPrimary = Color(0xFF101D2D);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color textMuted = Color(0xFF94A3B8);
  static const Color borderColor = Color(0xFFE2E8F0);
  static const Color blackishColor = Color(0xFF253237);
  static const Color greyishColor = Color(0xFFD9D9D9);
  static const Color redishColor = Color(0xFFFA5252);
  static const Color softGreen = Color(0xFFE8F5E9);

  /// Part states in a khatma.
  static const Color availableColor = Color(0xFF64748B);
  static const Color reservedColor = Color(0xFF2563EB);
  static const Color takenColor = Color(0xFFD97706);
  static const Color finishedColor = Color(0xFF16A34A);

  static const LinearGradient headerGradient = LinearGradient(
    colors: [Color(0xFF00E676), Color(0xFF00C853)],
    begin: Alignment.topRight,
    end: Alignment.bottomLeft,
  );

  /// The soft shadow under white cards.
  static List<BoxShadow> cardShadow = [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.05),
      offset: const Offset(0, 4),
      blurRadius: 10,
    ),
  ];

  /// Standard motion: short enough to feel instant, long enough to be seen.
  static const Duration fast = Duration(milliseconds: 180);
  static const Duration medium = Duration(milliseconds: 320);
  static const Curve curve = Curves.easeOutCubic;

  static ThemeData get theme {
    final scheme = ColorScheme.fromSeed(
      seedColor: primaryColor,
      primary: primaryColor,
      surface: Colors.white,
    );
    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      fontFamily: 'Amiri',
      scaffoldBackgroundColor: backgroundColor,
      splashFactory: InkSparkle.splashFactory,
      progressIndicatorTheme: const ProgressIndicatorThemeData(color: primaryColor),
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: primaryColor,
        selectionColor: primaryColor.withValues(alpha: 0.25),
        selectionHandleColor: primaryColor,
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        titleTextStyle: const TextStyle(
          fontFamily: 'Amiri',
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: textPrimary,
        ),
        contentTextStyle: const TextStyle(
          fontFamily: 'Amiri',
          fontSize: 17,
          height: 1.5,
          color: textSecondary,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          textStyle: const TextStyle(
            fontFamily: 'Amiri',
            fontSize: 17,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: FadeForwardsPageTransitionsBuilder(),
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
        },
      ),
    );
  }
}
