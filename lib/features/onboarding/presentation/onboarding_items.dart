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

const onboardingItems = [
  OnboardingInfo(
    title: 'أنشئ ختمة جديدة',
    description:
        'ابدأ ختمتك بسهولة: اكتب لمن هي، وحدّد عدد المشاركين وطريقة التقسيم بالسور أو بالأجزاء.',
    image: 'assets/onboarding/create.jpg',
  ),
  OnboardingInfo(
    title: 'تابع تقدّم الختمة',
    description:
        'احجز ما ستقرؤه، وأتمّه بلمسة، وتابع نسبة الإنجاز ومن يقرأ ماذا حتى تكتمل الختمة.',
    image: 'assets/onboarding/khatma.jpg',
  ),
  OnboardingInfo(
    title: 'كل ختماتك في مكان واحد',
    description:
        'ختماتك النشطة والمكتملة أمامك، يتحدّث تقدّمها مباشرة كلما قرأ أحد المشاركين.',
    image: 'assets/onboarding/home.jpg',
  ),
  OnboardingInfo(
    title: 'أصدقاؤك معك',
    description:
        'تابع أصدقاءك ومستوياتهم، وتنافسوا في الخير في لوحة المتصدرين.',
    image: 'assets/onboarding/friends.jpg',
  ),
  OnboardingInfo(
    title: 'ابحث عن الأشخاص',
    description:
        'ابحث عن أصدقائك بالاسم، وأرسل طلبات الصداقة أو اقبلها لتشاركوا الختمات معاً.',
    image: 'assets/onboarding/search.jpg',
  ),
  OnboardingInfo(
    title: 'انطلق، والله في عونك',
    description:
        'استعد لرحلتك مع القرآن. سواء بدأت ختمة أو شاركت في أخرى، أتمّ وردك بفضل الله.',
  ),
];
