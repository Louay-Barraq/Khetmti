// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appTitle => 'ختمـتي';

  @override
  String get appName => 'ختمتي';

  @override
  String get cancel => 'إلغاء';

  @override
  String get save => 'حفظ';

  @override
  String get delete => 'حذف';

  @override
  String get remove => 'إزالة';

  @override
  String get undo => 'تراجع';

  @override
  String get ok => 'حسناً';

  @override
  String get retry => 'إعادة المحاولة';

  @override
  String get genericError => 'حدث خطأ أثناء العملية';

  @override
  String get tryAgainError => 'حدث خطأ، يرجى المحاولة مرة أخرى';

  @override
  String get noData => 'لا توجد بيانات';

  @override
  String get loadDataError => 'خطأ في تحميل البيانات';

  @override
  String get loading => 'جاري التحميل...';

  @override
  String get unknown => 'غير معروف';

  @override
  String get participant => 'مشارك';

  @override
  String surahName(String name) {
    return 'سورة $name';
  }

  @override
  String levelN(String level) {
    return 'المستوى $level';
  }

  @override
  String levelColon(String level) {
    return 'المستوى: $level';
  }

  @override
  String levelShort(String level) {
    return 'مستوى $level';
  }

  @override
  String juzN(String n) {
    return 'الجزء $n';
  }

  @override
  String get surah => 'سورة';

  @override
  String get juz => 'جزء';

  @override
  String get surahs => 'السور';

  @override
  String get juzs => 'الأجزاء';

  @override
  String get language => 'اللغة';

  @override
  String get invalidEmail => 'عنوان البريد الإلكتروني غير صالح';

  @override
  String passwordTooShort(int min) {
    return 'يجب أن تتكون كلمة السر من $min أحرف على الأقل';
  }

  @override
  String usernameTooShort(int min) {
    return 'يجب أن يتكون اسم المستخدم من $min أحرف على الأقل';
  }

  @override
  String nameTooShort(int min) {
    return 'يجب أن يتكون الاسم من $min أحرف على الأقل';
  }

  @override
  String minChars(int min) {
    return '$min أحرف على الأقل';
  }

  @override
  String get enterPassword => 'يرجى إدخال كلمة السر';

  @override
  String get fillAllFields => 'يرجى ملء جميع الحقول';

  @override
  String get fullName => 'الاسم واللقب';

  @override
  String get fullNameHint => 'بالعربية، كما سيراه أصدقاؤك';

  @override
  String get email => 'البريد الإلكتروني';

  @override
  String get password => 'كلمة السر';

  @override
  String get showPassword => 'إظهار كلمة السر';

  @override
  String get hidePassword => 'إخفاء كلمة السر';

  @override
  String get accountCreated => 'تم إنشاء الحساب بنجاح!';

  @override
  String get signedIn => 'تم تسجيل الدخول بنجاح!';

  @override
  String get signedOut => 'تم تسجيل الخروج بنجاح!';

  @override
  String get signOutError =>
      'حدث خطأ أثناء تسجيل الخروج. يرجى المحاولة مرة أخرى.';

  @override
  String get wrongCredentials => 'البريد الإلكتروني أو كلمة السر غير صحيحة.';

  @override
  String get emailInUse =>
      'عنوان البريد الإلكتروني قيد الاستخدام بالفعل بواسطة حساب آخر.';

  @override
  String get registerTitle => 'حساب جديد';

  @override
  String get registerSubtitle => 'أنشئ حسابك وشارك أصدقاءك في ختم القرآن';

  @override
  String get haveAccount => 'لديك حساب؟';

  @override
  String get signInLink => 'سجّل الدخول';

  @override
  String get createAccount => 'إنشاء الحساب';

  @override
  String get loginTitle => 'أهلاً بعودتك';

  @override
  String get loginSubtitle => 'سجّل دخولك لمتابعة ختماتك';

  @override
  String get noAccount => 'ليس لديك حساب؟';

  @override
  String get createNewAccount => 'أنشئ حساباً جديداً';

  @override
  String get forgotPassword => 'نسيت كلمة السر؟';

  @override
  String get signIn => 'تسجيل الدخول';

  @override
  String get resetLinkSent => 'أرسلنا رابط إعادة تعيين كلمة السر إلى بريدك';

  @override
  String get resetLinkFailed => 'تعذّر إرسال الرابط، حاول مرة أخرى بعد قليل';

  @override
  String get recoverPassword => 'استعادة كلمة السر';

  @override
  String get recoverPasswordBody =>
      'سنرسل إلى بريدك رابطاً يفتح التطبيق لتختار كلمة سر جديدة.';

  @override
  String get sendLink => 'إرسال الرابط';

  @override
  String get passwordsDontMatch => 'كلمتا السر غير متطابقتين';

  @override
  String get passwordChanged => 'تم تغيير كلمة السر بنجاح';

  @override
  String get linkExpired => 'انتهت صلاحية الرابط، اطلب رابطاً جديداً';

  @override
  String get newPasswordTitle => 'كلمة سر جديدة';

  @override
  String get newPasswordSubtitle => 'اختر كلمة سر جديدة لحسابك';

  @override
  String get newPassword => 'كلمة السر الجديدة';

  @override
  String get confirmPassword => 'تأكيد كلمة السر';

  @override
  String get savePassword => 'حفظ كلمة السر';

  @override
  String get settings => 'الإعدادات';

  @override
  String get editableSettings => 'الإعدادات القابلة للتغيير';

  @override
  String get changeUsername => 'تغيير إسم المستخدم';

  @override
  String get changeEmail => 'تغيير البريد الإلكتروني';

  @override
  String get changePassword => 'تغيير كلمة السر';

  @override
  String get reminders => 'إشعارات التذكير';

  @override
  String get appearance => 'المظهر (داكن/فاتح)';

  @override
  String get signOut => 'تسجيل الخروج';

  @override
  String get deleteAccount => 'حذف الحساب';

  @override
  String get supportSection => 'الدعم والمساعدة';

  @override
  String get helpCenter => 'مركز المساعدة';

  @override
  String get aboutKhetmti => 'عن تطبيق ختمتي';

  @override
  String get accountDeleted => 'تم حذف حسابك. نسأل الله أن يتقبل منك';

  @override
  String get deleteAccountFailed => 'تعذّر حذف الحساب، حاول مرة أخرى';

  @override
  String get deleteAccountTitle => 'حذف الحساب نهائياً';

  @override
  String get deleteAccountBody =>
      'سيُحذف حسابك وأصدقاؤك ونقاطك، وتُلغى حجوزاتك التي لم تتمها. الختمات التي أنشأتها تنتقل إلى أقدم مشارك فيها، أو تُحذف إن لم يكن فيها غيرك. لا يمكن التراجع عن هذا.';

  @override
  String get deleteMyAccount => 'احذف حسابي';

  @override
  String get usernameChanged => 'تم تـــغيير إسم المستخــدم بنجـــاح';

  @override
  String get sameUsername => 'هذا هو اسمك الحالي';

  @override
  String get changeNameTitle => 'تغيير الاسم';

  @override
  String get changeNameBody => 'هذا الاسم يراه أصدقاؤك والمشاركون في ختماتك.';

  @override
  String get sameEmail => 'هذا هو بريدك الحالي';

  @override
  String get emailConfirmSent => 'أرسلنا رابط تأكيد، افتحه لإتمام تغيير البريد';

  @override
  String get changeEmailError => 'حدث خطأ أثناء تغيير البريد الإلكتروني';

  @override
  String get changeEmailTitle => 'تغيير البريد';

  @override
  String changeEmailBody(String current) {
    return 'بريدك الحالي: $current\nسنرسل رابط تأكيد، ويتغير بريد الدخول بعد فتحه.';
  }

  @override
  String get sendConfirmLink => 'إرسال رابط التأكيد';

  @override
  String get newEmail => 'البريد الإلكتروني الجديد';

  @override
  String get samePassword => 'كلمة السر الجديدة مطابقة للقديمة';

  @override
  String get wrongCurrentPassword => 'كلمة السر الحالية غير صحيحة';

  @override
  String get currentPassword => 'كلمة السر الحالية';

  @override
  String get supportEmailSubject => 'دعم تطبيق ختمتي';

  @override
  String get helpTitle => 'المساعدة والدعم';

  @override
  String get contactUs => 'تواصل معنا';

  @override
  String get byEmail => 'عبر البريد الإلكتروني';

  @override
  String get faq => 'الأسئلة الشائعة';

  @override
  String get faqCreateQ => 'كيف يمكنني إنشاء ختمة جديدة؟';

  @override
  String get faqCreateA =>
      'يمكنك إنشاء ختمة جديدة من خلال الصفحة الرئيسية بالضغط على زر \'+\'، ثم تحديد نوع التقسيم (أجزاء أو سور) وعدد المشاركين المطلوب.';

  @override
  String get faqJoinQ => 'كيف أنضم لختمة موجودة؟';

  @override
  String get faqJoinA =>
      'اطلب رمز الانضمام من منشئ الختمة، ثم من الصفحة الرئيسية اختر \'الانضمام لختمة\' وأدخل الرمز.';

  @override
  String get faqReserveQ => 'كيف يمكنني حجز جزء للقراءة؟';

  @override
  String get faqReserveA =>
      'بعد الدخول إلى الختمة، ستجد قائمة بالأجزاء أو السور، اضغط على زر الحجز بجانب الجزء المتاح (غير المحجوز) ليصبح باسمك.';

  @override
  String get faqReadQ => 'هل يمكنني قراءة القرآن داخل التطبيق؟';

  @override
  String get faqReadA =>
      'نعم! عند دخولك لأي سورة أو جزء في الختمة أو من ملفك الشخصي، سيفتح لك التطبيق المصحف لقراءته مباشرة.';

  @override
  String get faqOfflineQ => 'هل يمكنني القراءة بدون إنترنت؟';

  @override
  String get faqOfflineA =>
      'يحتاج التطبيق لاتصال بالإنترنت عند فتح الصفحة لأول مرة، لكننا نعمل على توفير ميزة الحفظ التلقائي للقراءة دون إنترنت قريباً.';

  @override
  String get faqStatsQ => 'كيف يمكن معرفة إحصائيات قراءتي؟';

  @override
  String get faqStatsA =>
      'من خلال صفحة الملف الشخصي (الحساب)، ستجد تبويب \'الإحصائيات\' الذي يعرض لك عدد الأجزاء والسور التي قرأتها.';

  @override
  String get aboutTitle => 'عن التطبيق';

  @override
  String get aboutAppName => 'ختمتي (Khetmti)';

  @override
  String get aboutBody =>
      'تطبيق ختمتي أُنشئ بهدف تسهيل وتشجيع قراءة القرآن الكريم وتنظيم الختمات الجماعية والفردية. نسأل الله أن يتقبل منا ومنكم صالح الأعمال وأن يجعله صدقة جارية.';

  @override
  String get developer => 'المطور';

  @override
  String get developerName => 'لؤي البراق';

  @override
  String get developerRole => 'مطور تطبيقات محمول';

  @override
  String get saveProgress => 'حفظ التقدم';

  @override
  String get saveProgressBody =>
      'عند النقر على الآية، يتم حفظها كعلامة توقف. في المرة القادمة التي تدخل فيها إلى هذا الجزء من خلال الختمة، سينتقل التطبيق تلقائياً إلى آخر آية قمت بحفظها لإكمال القراءة بكل سهولة.';

  @override
  String get fetchError => 'عذراً، حدث خطأ أثناء جلب البيانات';

  @override
  String get findFriend => 'البحث عن صديق';

  @override
  String get searchError => 'حدث خطأ أثناء البحث';

  @override
  String get searchStart => 'ابدأ بالبحث عن اسم صديقك';

  @override
  String get noPersonFound => 'لا يوجد شخص بهذا الاسم';

  @override
  String get searchUsernameHint => 'ابحث عن اسم المستخدم...';

  @override
  String get requestSent => 'تم إرسال طلب الصداقة!';

  @override
  String get requestExists => 'يوجد طلب صداقة بينكما بالفعل';

  @override
  String get sendRequestError => 'حدث خطأ أثناء إرسال الطلب';

  @override
  String get requestCancelled => 'تم إلغاء طلب الصداقة!';

  @override
  String get cancelRequestError => 'حدث خطأ أثناء إلغاء الطلب';

  @override
  String get requestAccepted => 'تم قبول طلب الصداقة بنجاح';

  @override
  String get acceptError => 'حدث خطأ أثناء قبول الطلب';

  @override
  String get requestDeclined => 'تم رفض طلب الصداقة';

  @override
  String get declineError => 'حدث خطأ أثناء رفض الطلب';

  @override
  String get removeFriendError => 'حدث خطأ أثناء إزالة الصديق';

  @override
  String get friendRequests => 'طلبات الصداقة';

  @override
  String get loadRequestsError => 'حدث خطأ أثناء تحميل الطلبات';

  @override
  String get decline => 'رفض';

  @override
  String get accept => 'قبول';

  @override
  String get noRequests => 'لا توجد طلبات صداقة حالياً';

  @override
  String get friendsBadge => 'أصدقاء';

  @override
  String get cancelRequest => 'إلغاء الطلب';

  @override
  String get add => 'إضافة';

  @override
  String get onlineNow => 'متصل الآن';

  @override
  String minutesAgo(int n) {
    return 'منذ $n دقيقة';
  }

  @override
  String hoursAgo(int n) {
    return 'منذ $n ساعة';
  }

  @override
  String daysAgo(int n) {
    return 'منذ $n أيام';
  }

  @override
  String lastSeen(String when) {
    return 'آخر ظهور: $when';
  }

  @override
  String get leaderboard => 'لوحة المتصدرين';

  @override
  String get today => 'اليوم';

  @override
  String get thisWeek => 'الأسبوع';

  @override
  String get allTime => 'الكل';

  @override
  String get global => 'العالمي';

  @override
  String get friends => 'الأصدقاء';

  @override
  String get me => 'أنا';

  @override
  String get unfriendTitle => 'إلغاء الصداقة';

  @override
  String get unfriendBody => 'هل أنت متأكد من إزالة هذا الصديق؟';

  @override
  String get quranOrder => 'ترتيب القرآن';

  @override
  String get juzOrder => 'ترتيب الأجزاء';

  @override
  String get mostRead => 'الأكثر قراءة';

  @override
  String get leastRead => 'الأقل قراءة';

  @override
  String get friendsList => 'قائمة الأصدقاء';

  @override
  String get activeKhatmas => 'ختماتك النشطة';

  @override
  String get completedKhatmas => 'ختماتك المكتملة';

  @override
  String get surahStats => 'إحصائيات السور';

  @override
  String get juzStats => 'إحصائيات الأجزاء';

  @override
  String get addFriend => 'إضافة صديق';

  @override
  String get loadFriendsError => 'خطأ في تحميل الأصدقاء';

  @override
  String get noFriends => 'ليس لديك أصدقاء حاليا';

  @override
  String get loadKhatmasError => 'خطأ في تحميل الختمات';

  @override
  String get noActiveKhatmas => 'لا توجد ختمات نشطة';

  @override
  String get noStats => 'لا توجد إحصائيات';

  @override
  String timesCount(int count) {
    return '$count مرة';
  }

  @override
  String get account => 'الحساب';

  @override
  String get active => 'نشط';

  @override
  String get rankStudent => 'طالب';

  @override
  String get rankReader => 'قارئ';

  @override
  String get rankReciter => 'مرتل';

  @override
  String get rankMujawwid => 'مجود';

  @override
  String get rankHafiz => 'حافظ';

  @override
  String get rankMaster => 'متقن';

  @override
  String get rankFaqih => 'فقيه';

  @override
  String get rankScholar => 'عالم';

  @override
  String get rankImam => 'إمام';

  @override
  String get yourFriends => 'أصدقائك';

  @override
  String get yourKhatmas => 'ختماتك';

  @override
  String get stats => 'الإحصائيات';

  @override
  String get mustSignIn => 'يجب تسجيل الدخول أولاً';

  @override
  String get khatmaNotFound => 'الختمة غير موجودة';

  @override
  String get alreadyJoined => 'أنت منضم بالفعل لهذه الختمة';

  @override
  String get khatmaFull => 'عذراً، هذه الختمة مكتملة العدد';

  @override
  String get mustJoinFirst => 'يجب الانضمام إلى الختمة أولاً';

  @override
  String get partUnavailable => 'لم يعد هذا الجزء متاحاً';

  @override
  String get menu => 'القائمة';

  @override
  String get khatmas => 'الختمات';

  @override
  String get createNewKhatma => 'إنشاء ختمة جديدة';

  @override
  String get createNewKhatmaDesc => 'ابدأ رحلة تلاوة جديدة وشاركها مع من تحب';

  @override
  String get joinExisting => 'الإنضمام لختمة موجودة';

  @override
  String get joinExistingDesc => 'ابحث عن مجموعات تلاوة وانضم إليهم';

  @override
  String get searchPerson => 'البحث عن شخص';

  @override
  String get searchPersonDesc => 'تواصل مع أصدقائك وتابع تقدمهم';

  @override
  String get friendRequestsDesc => 'شاهد من يريد أن يكون صديقك';

  @override
  String get tipTitle => 'هل تريد نصيحة؟';

  @override
  String get tipBody => 'قراءة صفحتين يومياً تعينك على ختم القرآن في عام واحد.';

  @override
  String get khatmaForRequired => 'اكتب لمن هذه الختمة';

  @override
  String get khatmaCreated => 'تم إنشاء الختمة بنجاح';

  @override
  String get createKhatmaError => 'حدث خطأ أثناء إنشاء الختمة';

  @override
  String get createKhatmaTitle => 'إنشاء ختمة';

  @override
  String get khatmaFor => 'ختمة لفائدة';

  @override
  String get khatmaForHint => 'مثال: جدي رحمه الله';

  @override
  String get createKhatmaButton => 'إنشاء الختمة';

  @override
  String get maxParticipants => 'العدد الأقصى للمشاركين';

  @override
  String get includingYou => 'بمن فيهم أنت';

  @override
  String get splitKhatma => 'تقسيم الختمة';

  @override
  String get splitKhatmaDesc => 'كل مشارك يحجز ما سيقرؤه';

  @override
  String get bySurah => 'بالسور';

  @override
  String get surahCount => '114 سورة';

  @override
  String get byJuz => 'بالأجزاء';

  @override
  String get juzCount => '30 جزءاً';

  @override
  String get wrongCode => 'الرمز غير صحيح أو الختمة غير موجودة';

  @override
  String get joined => 'تم الانضمام بنجاح!';

  @override
  String get enter5Digits => 'يرجى إدخال رمز مكون من 5 أرقام';

  @override
  String get joinKhatmaTitle => 'الانضمام لختمة';

  @override
  String get byCode => 'بالرمز';

  @override
  String get byName => 'بالاسم';

  @override
  String get enterJoinCode => 'أدخل رمز الانضمام';

  @override
  String get joinCodeHelp => 'رمز من 5 أرقام تجده في صفحة الختمة لدى أي مشارك';

  @override
  String get joinNow => 'انضم الآن';

  @override
  String get khatmaName => 'اسم الختمة';

  @override
  String get noKhatmaByName => 'لا توجد ختمة بهذا الاسم';

  @override
  String khatmaForName(String name) {
    return 'ختمة لفائدة $name';
  }

  @override
  String khatmaSearchMeta(int current, int max, String unit, int percent) {
    return '$current/$max مشاركين · $unit · $percent%';
  }

  @override
  String get full => 'مكتملة العدد';

  @override
  String get join => 'انضمام';

  @override
  String get loadKhatmasHomeError => 'تعذّر تحميل الختمات، تحقق من اتصالك';

  @override
  String get noCompletedYet => 'لا توجد ختمات مكتملة بعد';

  @override
  String get emptyActiveHint =>
      'أنشئ ختمة جديدة أو انضم إلى ختمة أصدقائك برمزها';

  @override
  String get emptyCompletedHint => 'ستظهر هنا الختمات التي يتم إتمامها';

  @override
  String get notifications => 'الإشعارات';

  @override
  String get noNotifications => 'لا توجد إشعارات حالياً';

  @override
  String get partAvailable => 'متاحة للحجز';

  @override
  String get partReservedForYou => 'محجوزة لك';

  @override
  String partReservedBy(String name) {
    return 'محجوزة لـ $name';
  }

  @override
  String get partFinishedByYou => 'أتممتَ قراءتها';

  @override
  String partReadBy(String name) {
    return 'قرأها $name';
  }

  @override
  String get reserve => 'احجز';

  @override
  String get cancelReservation => 'إلغاء الحجز';

  @override
  String get finishedButton => 'أتممت';

  @override
  String congratsFinished(String part) {
    return 'بارك الله فيك! أتممت قراءة $part';
  }

  @override
  String get undoFinishTitle => 'التراجع عن الإتمام';

  @override
  String undoFinishBody(String part) {
    return 'ستعود \"$part\" محجوزة لك، وتُخصم النقاط التي حصلت عليها عند إتمامها.';
  }

  @override
  String get deleteKhatmaTitle => 'حذف الختمة';

  @override
  String get deleteKhatmaBody =>
      'هل أنت متأكد من حذف هذه الختمة؟ سيتم حذفها لجميع المشاركين ولا يمكن التراجع.';

  @override
  String get khatmaDeleted => 'تم حذف الختمة بنجاح';

  @override
  String get deleteKhatmaError => 'حدث خطأ أثناء حذف الختمة';

  @override
  String ayahCount(int count, String countText) {
    return '$countText آية';
  }

  @override
  String get tabContent => 'المحتوى';

  @override
  String get tabParticipants => 'المشاركون';

  @override
  String get tabLog => 'السجل';

  @override
  String participantsOf(int current, int max) {
    return '$current / $max مشاركين';
  }

  @override
  String participantsCount(int count) {
    return '$count مشاركين';
  }

  @override
  String get codeCopied => 'تم نسخ رمز الانضمام';

  @override
  String get joinCode => 'رمز الانضمام';

  @override
  String get filterAll => 'الكل';

  @override
  String get filterAvailable => 'المتاحة';

  @override
  String get filterMine => 'محجوزاتي';

  @override
  String get filterDone => 'المكتملة';

  @override
  String get emptyAvailable => 'لم يبق شيء متاح للحجز';

  @override
  String get emptyMine => 'لم تحجز شيئاً بعد، اختر من المتاحة';

  @override
  String get emptyDone => 'لم يكتمل شيء بعد';

  @override
  String get loadParticipantsError => 'تعذّر تحميل المشاركين';

  @override
  String get creator => 'المنشئ';

  @override
  String finishedN(int done, String unit) {
    return 'أتمّ $done $unit';
  }

  @override
  String readingN(int count) {
    return 'يقرأ $count';
  }

  @override
  String get logReserved => 'حجز';

  @override
  String get logFinished => 'أتم القراءة';

  @override
  String get logReleased => 'ألغى الحجز';

  @override
  String get logUndone => 'تراجع عن القراءة';

  @override
  String get noActivity => 'لا توجد نشاطات مسجلة بعد';

  @override
  String get finishedVerb => 'أتم';

  @override
  String get khatmaGoneBody => 'يبدو أن هذه الختمة قد حُذفت أو لم تعد متوفرة.';

  @override
  String get activeTab => 'النشطة';

  @override
  String get completedTab => 'المكتملة';

  @override
  String get completedOn => 'تاريخ الإكمال: ';

  @override
  String get startedOn => 'تاريخ البدء: ';

  @override
  String get navHome => 'الرئيسية';

  @override
  String get skip => 'تخطي';

  @override
  String get startNow => 'ابدأ الآن';

  @override
  String get onb1Title => 'أنشئ ختمة جديدة';

  @override
  String get onb1Body =>
      'ابدأ ختمتك بسهولة: اكتب لمن هي، وحدّد عدد المشاركين وطريقة التقسيم بالسور أو بالأجزاء.';

  @override
  String get onb2Title => 'تابع تقدّم الختمة';

  @override
  String get onb2Body =>
      'احجز ما ستقرؤه، وأتمّه بلمسة، وتابع نسبة الإنجاز ومن يقرأ ماذا حتى تكتمل الختمة.';

  @override
  String get onb3Title => 'كل ختماتك في مكان واحد';

  @override
  String get onb3Body =>
      'ختماتك النشطة والمكتملة أمامك، يتحدّث تقدّمها مباشرة كلما قرأ أحد المشاركين.';

  @override
  String get onb4Title => 'أصدقاؤك معك';

  @override
  String get onb4Body =>
      'تابع أصدقاءك ومستوياتهم، وتنافسوا في الخير في لوحة المتصدرين.';

  @override
  String get onb5Title => 'ابحث عن الأشخاص';

  @override
  String get onb5Body =>
      'ابحث عن أصدقائك بالاسم، وأرسل طلبات الصداقة أو اقبلها لتشاركوا الختمات معاً.';

  @override
  String get onb6Title => 'انطلق، والله في عونك';

  @override
  String get onb6Body =>
      'استعد لرحلتك مع القرآن. سواء بدأت ختمة أو شاركت في أخرى، أتمّ وردك بفضل الله.';
}
