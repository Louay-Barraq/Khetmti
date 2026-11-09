import 'package:flutter/material.dart';
import 'dart:ui';

/// Attached to [MaterialApp] so toasts can be shown without a BuildContext
/// (e.g. from repositories).
final scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

void _showToast(String msg, Color color, Duration duration) {
  final messenger = scaffoldMessengerKey.currentState;
  if (messenger == null) return;
  messenger
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        content: Text(
          msg,
          textAlign: TextAlign.center,
          style: const TextStyle(color: Colors.white, fontSize: 17),
        ),
        backgroundColor: color,
        duration: duration,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.fromLTRB(24, 0, 24, 48),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        elevation: 2,
      ),
    );
}

void showSuccessToast(String msg) =>
    _showToast(msg, Colors.green, const Duration(milliseconds: 3500));

void showErrorToast(String msg) =>
    _showToast(msg, Colors.redAccent, const Duration(milliseconds: 3500));

void showWarningToast(String msg) =>
    _showToast(msg, Colors.orange, const Duration(seconds: 2));

void showLoadingDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierDismissible: false,
    barrierColor: Colors.black.withValues(alpha: 0.05),
    builder: (BuildContext context) {
      return BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: Center(
          child: Container(
            padding: const EdgeInsets.all(30),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
            ),
          ),
        ),
      );
    },
  );
}

void dismissLoadingDialog(BuildContext context) {
  Navigator.of(context).pop();
}

/// Shortest username allowed at sign-up and when renaming.
const minUsernameLength = 3;

/// Shortest password allowed at sign-up, reset and change (Supabase's
/// default minimum).
const minPasswordLength = 6;

bool isValidEmail(String email) {
  final RegExp emailRegex = RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
  );
  return emailRegex.hasMatch(email);
}

/// 123 → ١٢٣
String toArabicDigits(int number) {
  const digits = '٠١٢٣٤٥٦٧٨٩';
  return number
      .toString()
      .split('')
      .map((d) => digits[int.parse(d)])
      .join();
}
