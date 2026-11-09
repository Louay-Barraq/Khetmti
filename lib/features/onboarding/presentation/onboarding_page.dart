import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:khetmti/core/theme/app_theme.dart';
import 'package:khetmti/features/onboarding/presentation/onboarding_items.dart';
import 'package:khetmti/shared/widgets/motion.dart';
import 'package:khetmti/shared/widgets/primary_button.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final _controller = PageController();
  int _page = 0;

  bool get _isLast => _page == onboardingItems.length - 1;

  Future<void> _finish() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboarding', true);
    if (mounted) context.go('/login');
  }

  void _next() => _controller.nextPage(
        duration: AppTheme.medium,
        curve: AppTheme.curve,
      );

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    for (final item in onboardingItems) {
      if (item.image != null) precacheImage(AssetImage(item.image!), context);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(
              height: 52,
              child: Align(
                alignment: Alignment.centerLeft,
                child: AnimatedOpacity(
                  opacity: _isLast ? 0 : 1,
                  duration: AppTheme.fast,
                  child: TextButton(
                    onPressed: _isLast ? null : _finish,
                    child: const Text(
                      'تخطي',
                      style: TextStyle(color: AppTheme.textSecondary),
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: PageView.builder(
                controller: _controller,
                reverse: true, // Arabic: the next page comes from the left.
                itemCount: onboardingItems.length,
                onPageChanged: (i) => setState(() => _page = i),
                itemBuilder: (context, i) => AnimatedBuilder(
                  animation: _controller,
                  builder: (context, child) {
                    // 0 when centered, 1 when a full page away.
                    final page = _controller.hasClients &&
                            _controller.position.haveDimensions
                        ? _controller.page ?? 0
                        : 0.0;
                    final distance = (page - i).abs().clamp(0.0, 1.0);
                    return _OnboardingSlide(
                      item: onboardingItems[i],
                      distance: distance,
                    );
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 8, 24, 20),
              child: SizedBox(
                height: 56,
                child: SmoothSwitcher(
                  duration: AppTheme.fast,
                  child: _isLast
                      ? PrimaryButton(
                          key: const ValueKey('start'),
                          label: 'ابدأ الآن',
                          icon: Icons.arrow_back_rounded,
                          onPressed: _finish,
                        )
                      : Row(
                          key: const ValueKey('nav'),
                          children: [
                            Pressable(
                              onTap: _next,
                              child: Container(
                                width: 56,
                                height: 56,
                                decoration: BoxDecoration(
                                  color: AppTheme.primaryColor,
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppTheme.primaryColor
                                          .withValues(alpha: 0.35),
                                      blurRadius: 14,
                                      offset: const Offset(0, 6),
                                    ),
                                  ],
                                ),
                                child: const Icon(Icons.arrow_back_rounded,
                                    color: Colors.white),
                              ),
                            ),
                            const Spacer(),
                            Directionality(
                              textDirection: TextDirection.rtl,
                              child: SmoothPageIndicator(
                                controller: _controller,
                                count: onboardingItems.length,
                                onDotClicked: (i) => _controller.animateToPage(
                                  i,
                                  duration: AppTheme.medium,
                                  curve: AppTheme.curve,
                                ),
                                effect: const ExpandingDotsEffect(
                                  dotHeight: 8,
                                  dotWidth: 8,
                                  expansionFactor: 3.5,
                                  spacing: 6,
                                  activeDotColor: AppTheme.primaryColor,
                                  dotColor: AppTheme.borderColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OnboardingSlide extends StatelessWidget {
  final OnboardingInfo item;
  final double distance;

  const _OnboardingSlide({required this.item, required this.distance});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 28),
      child: Column(
        children: [
          Expanded(
            child: Transform.scale(
              scale: 1 - 0.12 * distance,
              child: Opacity(
                opacity: 1 - 0.6 * distance,
                child: item.image == null
                    ? const _LogoArt()
                    : _ScreenshotFrame(image: item.image!),
              ),
            ),
          ),
          const SizedBox(height: 24),
          Transform.translate(
            offset: Offset(0, 30 * distance),
            child: Opacity(
              opacity: 1 - distance,
              child: Column(
                children: [
                  Text(
                    item.title,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontFamily: 'Amiri',
                      fontSize: 27,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    item.description,
                    textAlign: TextAlign.center,
                    textDirection: TextDirection.rtl,
                    style: const TextStyle(
                      fontFamily: 'Amiri',
                      fontSize: 17,
                      height: 1.6,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}

/// A screenshot of the app in a rounded "device" card on a soft green
/// backdrop; its lower edge fades into the page.
class _ScreenshotFrame extends StatelessWidget {
  final String image;
  const _ScreenshotFrame({required this.image});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        FractionallySizedBox(
          widthFactor: 1,
          heightFactor: 0.82,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: AppTheme.softGreen,
              borderRadius: BorderRadius.circular(40),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 4),
          child: ShaderMask(
            blendMode: BlendMode.dstIn,
            shaderCallback: (rect) => const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.black, Colors.black, Colors.transparent],
              stops: [0, 0.8, 1],
            ).createShader(rect),
            child: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: AppTheme.secondaryColor,
                borderRadius: BorderRadius.circular(32),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(26),
                child: Image.asset(image, fit: BoxFit.contain),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _LogoArt extends StatelessWidget {
  const _LogoArt();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(28),
        decoration: const BoxDecoration(
          color: AppTheme.softGreen,
          shape: BoxShape.circle,
        ),
        child: Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: AppTheme.primaryColor.withValues(alpha: 0.3),
                blurRadius: 30,
                offset: const Offset(0, 12),
              ),
            ],
          ),
          child: Image.asset('assets/images/Khetmti - App Logo.png', width: 150),
        ),
      ),
    );
  }
}
