import 'package:flutter/material.dart';
import 'package:khetmti/core/theme/app_theme.dart';
import 'package:khetmti/shared/widgets/motion.dart';

/// Layout shared by the login, sign-up and new-password pages: the green
/// header of the app with the logo, and the form in a white card that
/// overlaps it.
class AuthScaffold extends StatelessWidget {
  final String title;
  final String subtitle;
  final List<Widget> children;
  final Widget? footer;
  final VoidCallback? onBack;

  const AuthScaffold({
    super.key,
    required this.title,
    required this.subtitle,
    required this.children,
    this.footer,
    this.onBack,
  });

  static const _headerHeight = 300.0;
  static const _overlap = 64.0;

  @override
  Widget build(BuildContext context) {
    final top = MediaQuery.paddingOf(context).top;

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: SingleChildScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        child: Column(
          children: [
            Stack(
              children: [
                _header(top),
                Padding(
                  padding: EdgeInsets.fromLTRB(
                      20, top + _headerHeight - _overlap, 20, 0),
                  child: FadeSlideIn(
                    index: 1,
                    child: Container(
                      padding: const EdgeInsets.fromLTRB(22, 26, 22, 26),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(28),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.07),
                            offset: const Offset(0, 10),
                            blurRadius: 30,
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: children,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            if (footer != null)
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 18, 20, 32),
                child: FadeSlideIn(index: 3, child: footer!),
              ),
          ],
        ),
      ),
    );
  }

  Widget _header(double top) {
    return Container(
      height: top + _headerHeight,
      width: double.infinity,
      padding: EdgeInsets.only(top: top),
      decoration: const BoxDecoration(
        color: AppTheme.primaryColor,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(32),
          bottomRight: Radius.circular(32),
        ),
      ),
      child: Stack(
        children: [
          // Soft circles give the flat green some depth.
          Positioned(
            top: -40,
            left: -50,
            child: _bubble(180, 0.10),
          ),
          Positioned(
            top: 90,
            right: -30,
            child: _bubble(120, 0.08),
          ),
          if (onBack != null)
            Positioned(
              top: 12,
              right: 16,
              child: Material(
                color: Colors.white.withValues(alpha: 0.2),
                shape: const CircleBorder(),
                child: IconButton(
                  onPressed: onBack,
                  icon: const Icon(Icons.arrow_forward_ios_rounded,
                      color: Colors.white, size: 20),
                ),
              ),
            ),
          Align(
            alignment: const Alignment(0, -0.35),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                FadeSlideIn(
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.15),
                          blurRadius: 18,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Image.asset(
                      'assets/images/Khetmti - App Logo.png',
                      width: 84,
                      height: 84,
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                Text(
                  title,
                  style: const TextStyle(
                    fontFamily: 'Amiri',
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Text(
                  subtitle,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Amiri',
                    fontSize: 16,
                    color: Colors.white.withValues(alpha: 0.9),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _bubble(double size, double alpha) => Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white.withValues(alpha: alpha),
        ),
      );
}

/// "Question? Action" line under the auth card.
class AuthFooterLink extends StatelessWidget {
  final String question;
  final String action;
  final VoidCallback onTap;

  const AuthFooterLink({
    super.key,
    required this.question,
    required this.action,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Pressable(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: '$question ',
                  style: const TextStyle(color: AppTheme.textSecondary),
                ),
                TextSpan(
                  text: action,
                  style: const TextStyle(
                    color: AppTheme.primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            textDirection: TextDirection.rtl,
            style: const TextStyle(fontFamily: 'Amiri', fontSize: 17),
          ),
        ),
      ),
    );
  }
}
