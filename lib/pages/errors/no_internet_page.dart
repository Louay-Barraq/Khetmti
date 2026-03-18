import 'package:flutter/material.dart';
import 'package:khetmti/themes/main_theme.dart';

class NoInternetPage extends StatelessWidget {
  final VoidCallback? onRetry;
  
  const NoInternetPage({super.key, this.onRetry});

  Future<void> _handleRefresh() async {
    onRetry?.call();
    // Give connectivity check time to complete
    await Future.delayed(const Duration(seconds: 1));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _handleRefresh,
          color: MainTheme.primaryColor,
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TweenAnimationBuilder<double>(
                          tween: Tween(begin: 0.0, end: 1.0),
                          duration: const Duration(milliseconds: 600),
                          curve: Curves.easeOutBack,
                          builder: (context, value, child) {
                            return Transform.scale(
                              scale: value,
                              child: Opacity(opacity: value, child: child),
                            );
                          },
                          child: Container(
                            height: 200,
                            width: 200,
                            decoration: BoxDecoration(
                              color: MainTheme.greyishColor,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.wifi_off_rounded,
                              size: 100,
                              color: MainTheme.primaryColor,
                            ),
                          ),
                        ),
                        const SizedBox(height: 40),
                        TweenAnimationBuilder<double>(
                          tween: Tween(begin: 0.0, end: 1.0),
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.easeOut,
                          builder: (context, value, child) {
                            return Opacity(
                              opacity: value,
                              child: Transform.translate(
                                offset: Offset(0, 20 * (1 - value)),
                                child: child,
                              ),
                            );
                          },
                          child: Column(
                            children: [
                              const Text(
                                'عذراً، لا يوجد اتصال بالإنترنت',
                                style: TextStyle(
                                  fontFamily: 'Amiri',
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: MainTheme.textPrimary,
                                ),
                                textAlign: TextAlign.center,
                                textDirection: TextDirection.rtl,
                              ),
                              const SizedBox(height: 10),
                              const Text(
                                'يرجى التأكد من اتصالك بالإنترنت والمحاولة مرة أخرى للوصول إلى ختماتك.',
                                style: TextStyle(
                                  fontFamily: 'Amiri',
                                  fontSize: 16,
                                  color: MainTheme.textSecondary,
                                ),
                                textAlign: TextAlign.center,
                                textDirection: TextDirection.rtl,
                              ),
                              const SizedBox(height: 10),
                              Text(
                                'اسحب للأسفل لإعادة المحاولة',
                                style: TextStyle(
                                  fontFamily: 'Amiri',
                                  fontSize: 14,
                                  color: MainTheme.textSecondary.withOpacity(0.6),
                                ),
                                textAlign: TextAlign.center,
                                textDirection: TextDirection.rtl,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 40),
                        TweenAnimationBuilder<double>(
                          tween: Tween(begin: 0.0, end: 1.0),
                          duration: const Duration(milliseconds: 600),
                          curve: Curves.easeOut,
                          builder: (context, value, child) {
                            return Opacity(
                              opacity: value,
                              child: Transform.translate(
                                offset: Offset(0, 30 * (1 - value)),
                                child: child,
                              ),
                            );
                          },
                          child: ElevatedButton(
                            onPressed: onRetry,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: MainTheme.primaryColor,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                            child: const Text(
                              'إعادة المحاولة',
                              style: TextStyle(
                                fontFamily: 'Amiri',
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
