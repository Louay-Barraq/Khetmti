import 'package:khetmti/l10n/l10n.dart';
class OnboardingInfo {
  final String title;
  final String description;

  /// A screenshot of the app, or null for the closing page (shows the logo).
  final String? image;

  const OnboardingInfo({
    required this.title,
    required this.description,
    this.image,
  });
}

List<OnboardingInfo> get onboardingItems => [
  OnboardingInfo(
    title: tr.onb1Title,
    description:
        tr.onb1Body,
    image: 'assets/onboarding/create.jpg',
  ),
  OnboardingInfo(
    title: tr.onb2Title,
    description:
        tr.onb2Body,
    image: 'assets/onboarding/khatma.jpg',
  ),
  OnboardingInfo(
    title: tr.onb3Title,
    description:
        tr.onb3Body,
    image: 'assets/onboarding/home.jpg',
  ),
  OnboardingInfo(
    title: tr.onb4Title,
    description:
        tr.onb4Body,
    image: 'assets/onboarding/friends.jpg',
  ),
  OnboardingInfo(
    title: tr.onb5Title,
    description:
        tr.onb5Body,
    image: 'assets/onboarding/search.jpg',
  ),
  OnboardingInfo(
    title: tr.onb6Title,
    description:
        tr.onb6Body,
  ),
];
