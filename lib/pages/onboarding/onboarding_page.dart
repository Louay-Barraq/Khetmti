// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:khetmti/auth/auth_page.dart';
import 'package:khetmti/themes/main_theme.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'onboarding_items.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final controller = OnboardingItems();
  final pageController = PageController();
  bool isLastPage = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomSheet: Container(
        child: isLastPage
            ? getStarted()
            : Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () =>
                        pageController.jumpToPage(controller.items.length - 1),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Text(
                        "تـــخطي",
                        style: TextStyle(
                            color: MainTheme.primaryColor,
                            fontFamily: 'Amiri',
                            fontWeight: FontWeight.bold,
                            fontSize: 20),
                      ),
                    ),
                  ),
                  SmoothPageIndicator(
                    controller: pageController,
                    count: controller.items.length,
                    onDotClicked: (index) => pageController.animateToPage(index,
                        duration: const Duration(milliseconds: 600),
                        curve: Curves.easeIn),
                    effect: WormEffect(
                      dotHeight: 12,
                      dotWidth: 12,
                      activeDotColor: MainTheme.primaryColor,
                    ),
                  ),
                  TextButton(
                    onPressed: () => pageController.nextPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeIn),
                    child: Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: Text(
                        "التـــالي",
                        style: TextStyle(
                            color: MainTheme.primaryColor,
                            fontFamily: 'Amiri',
                            fontWeight: FontWeight.bold,
                            fontSize: 20),
                      ),
                    ),
                  ),
                ],
              ),
      ),
      body: PageView.builder(
        onPageChanged: (index) =>
            setState(() => isLastPage = controller.items.length - 1 == index),
        itemCount: controller.items.length,
        controller: pageController,
        itemBuilder: (context, index) {
          return SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    const SizedBox(height: 50),
                    Image.asset(
                      controller.items[index].image,
                      height: 350,
                      width: MediaQuery.of(context).size.width - 20,
                    ),
                    const SizedBox(height: 40),
                    Text(
                      controller.items[index].title,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Amiri',
                      ),
                    ),
                    const SizedBox(height: 25),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Text(
                        controller.items[index].descriptions,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 19,
                          fontFamily: 'Amiri',
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget getStarted() {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: MainTheme.primaryColor),
      width: MediaQuery.of(context).size.width * .9,
      height: 55,
      child: TextButton(
          onPressed: () async {
            final pres = await SharedPreferences.getInstance();
            pres.setBool("onboarding", true);

            if (!mounted) return;
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => AuthPage()));
          },
          child: const Text(
            "البدء",
            style: TextStyle(
                color: Colors.white,
                fontFamily: 'Amiri',
                fontWeight: FontWeight.bold,
                fontSize: 30),
          )),
    );
  }
}
