class OnboardingInfo {
  final String title;
  final String descriptions;
  final String image;

  OnboardingInfo(
      {required this.title, required this.descriptions, required this.image});
}

class OnboardingItems {
  List<OnboardingInfo> items = [
    OnboardingInfo(
        title: "إنشـــاء خـــتمة جـــديدة",
        descriptions:
            "ابدأ ختمتك الخاصة بكل سهولة. قم بتحديد عدد المشاركين وتقسيم الأجزاء بين الأصدقاء أو المشاركين لإنجاز قراءة القرآن معًا",
        image: "assets/onboarding/Khetma Creation.jpg"),
    OnboardingInfo(
        title: "الإطــلاع عـــلى مـــعطيات الختمة",
        descriptions:
            "راقب تقدم الختمة، تابع نسبة الإنجاز وتفاصيل المشاركين والأجزاء التي تمت قراءتها لضمان إتمام الختمة بنجاح",
        image: "assets/onboarding/Khetma Page - Cropped.jpg"),
    OnboardingInfo(
        title: "الإطــلاع عـــلى قـــائمة الأصـــدقاء",
        descriptions:
            "تعرف على أصدقائك الذين يشاركون معك في ختماتك. يمكنك دعوة أصدقاء جدد أو متابعة طلبات الصداقة وقبولها",
        image: "assets/onboarding/Displaying Friends.jpg"),
    OnboardingInfo(
        title: "الإطــلاع عـــلى قـــائمة الختمـــات",
        descriptions:
            "اكتشف ختمات متعددة يمكنك الانضمام إليها، واستعرض الختمات التي بدأت بها لتتابع إنجازك وتشارك في المزيد",
        image: "assets/onboarding/Displaying Khetmet.jpg"),
    OnboardingInfo(
        title: "البحـــث عــن الأشخـــاص",
        descriptions:
            "ابحث عن أصدقائك أو أفراد جدد يمكنهم المشاركة معك في ختمة جديدة، وأرسل طلبات الصداقة أو انضم إلى ختمات مشتركة",
        image: "assets/onboarding/Friends Search Page - Cropped.jpg"),
    OnboardingInfo(
        title: "اِنــطلق و ليكــن اللّه في عــونك",
        descriptions:
            "استعد للانطلاق في رحلتك الروحية مع تطبيق ختمتي. سواء كنت تبدأ ختمة أو تشارك في أخرى، قم بإتمام مهمتك بفضل الله",
        image: "assets/onboarding/Friends Search Page - Cropped.jpg"),
  ];
}
