import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en'),
    Locale('es'),
    Locale('fr')
  ];

  /// No description provided for @appTitle.
  ///
  /// In ar, this message translates to:
  /// **'ختمـتي'**
  String get appTitle;

  /// No description provided for @appName.
  ///
  /// In ar, this message translates to:
  /// **'ختمتي'**
  String get appName;

  /// No description provided for @cancel.
  ///
  /// In ar, this message translates to:
  /// **'إلغاء'**
  String get cancel;

  /// No description provided for @save.
  ///
  /// In ar, this message translates to:
  /// **'حفظ'**
  String get save;

  /// No description provided for @delete.
  ///
  /// In ar, this message translates to:
  /// **'حذف'**
  String get delete;

  /// No description provided for @remove.
  ///
  /// In ar, this message translates to:
  /// **'إزالة'**
  String get remove;

  /// No description provided for @undo.
  ///
  /// In ar, this message translates to:
  /// **'تراجع'**
  String get undo;

  /// No description provided for @ok.
  ///
  /// In ar, this message translates to:
  /// **'حسناً'**
  String get ok;

  /// No description provided for @retry.
  ///
  /// In ar, this message translates to:
  /// **'إعادة المحاولة'**
  String get retry;

  /// No description provided for @genericError.
  ///
  /// In ar, this message translates to:
  /// **'حدث خطأ أثناء العملية'**
  String get genericError;

  /// No description provided for @tryAgainError.
  ///
  /// In ar, this message translates to:
  /// **'حدث خطأ، يرجى المحاولة مرة أخرى'**
  String get tryAgainError;

  /// No description provided for @noData.
  ///
  /// In ar, this message translates to:
  /// **'لا توجد بيانات'**
  String get noData;

  /// No description provided for @loadDataError.
  ///
  /// In ar, this message translates to:
  /// **'خطأ في تحميل البيانات'**
  String get loadDataError;

  /// No description provided for @loading.
  ///
  /// In ar, this message translates to:
  /// **'جاري التحميل...'**
  String get loading;

  /// No description provided for @unknown.
  ///
  /// In ar, this message translates to:
  /// **'غير معروف'**
  String get unknown;

  /// No description provided for @participant.
  ///
  /// In ar, this message translates to:
  /// **'مشارك'**
  String get participant;

  /// No description provided for @surahName.
  ///
  /// In ar, this message translates to:
  /// **'سورة {name}'**
  String surahName(String name);

  /// No description provided for @levelN.
  ///
  /// In ar, this message translates to:
  /// **'المستوى {level}'**
  String levelN(String level);

  /// No description provided for @levelColon.
  ///
  /// In ar, this message translates to:
  /// **'المستوى: {level}'**
  String levelColon(String level);

  /// No description provided for @levelShort.
  ///
  /// In ar, this message translates to:
  /// **'مستوى {level}'**
  String levelShort(String level);

  /// No description provided for @juzN.
  ///
  /// In ar, this message translates to:
  /// **'الجزء {n}'**
  String juzN(String n);

  /// No description provided for @surah.
  ///
  /// In ar, this message translates to:
  /// **'سورة'**
  String get surah;

  /// No description provided for @juz.
  ///
  /// In ar, this message translates to:
  /// **'جزء'**
  String get juz;

  /// No description provided for @surahs.
  ///
  /// In ar, this message translates to:
  /// **'السور'**
  String get surahs;

  /// No description provided for @juzs.
  ///
  /// In ar, this message translates to:
  /// **'الأجزاء'**
  String get juzs;

  /// No description provided for @language.
  ///
  /// In ar, this message translates to:
  /// **'اللغة'**
  String get language;

  /// No description provided for @invalidEmail.
  ///
  /// In ar, this message translates to:
  /// **'عنوان البريد الإلكتروني غير صالح'**
  String get invalidEmail;

  /// No description provided for @passwordTooShort.
  ///
  /// In ar, this message translates to:
  /// **'يجب أن تتكون كلمة السر من {min} أحرف على الأقل'**
  String passwordTooShort(int min);

  /// No description provided for @usernameTooShort.
  ///
  /// In ar, this message translates to:
  /// **'يجب أن يتكون اسم المستخدم من {min} أحرف على الأقل'**
  String usernameTooShort(int min);

  /// No description provided for @nameTooShort.
  ///
  /// In ar, this message translates to:
  /// **'يجب أن يتكون الاسم من {min} أحرف على الأقل'**
  String nameTooShort(int min);

  /// No description provided for @minChars.
  ///
  /// In ar, this message translates to:
  /// **'{min} أحرف على الأقل'**
  String minChars(int min);

  /// No description provided for @enterPassword.
  ///
  /// In ar, this message translates to:
  /// **'يرجى إدخال كلمة السر'**
  String get enterPassword;

  /// No description provided for @fillAllFields.
  ///
  /// In ar, this message translates to:
  /// **'يرجى ملء جميع الحقول'**
  String get fillAllFields;

  /// No description provided for @fullName.
  ///
  /// In ar, this message translates to:
  /// **'الاسم واللقب'**
  String get fullName;

  /// No description provided for @fullNameHint.
  ///
  /// In ar, this message translates to:
  /// **'بالعربية، كما سيراه أصدقاؤك'**
  String get fullNameHint;

  /// No description provided for @email.
  ///
  /// In ar, this message translates to:
  /// **'البريد الإلكتروني'**
  String get email;

  /// No description provided for @password.
  ///
  /// In ar, this message translates to:
  /// **'كلمة السر'**
  String get password;

  /// No description provided for @showPassword.
  ///
  /// In ar, this message translates to:
  /// **'إظهار كلمة السر'**
  String get showPassword;

  /// No description provided for @hidePassword.
  ///
  /// In ar, this message translates to:
  /// **'إخفاء كلمة السر'**
  String get hidePassword;

  /// No description provided for @accountCreated.
  ///
  /// In ar, this message translates to:
  /// **'تم إنشاء الحساب بنجاح!'**
  String get accountCreated;

  /// No description provided for @signedIn.
  ///
  /// In ar, this message translates to:
  /// **'تم تسجيل الدخول بنجاح!'**
  String get signedIn;

  /// No description provided for @signedOut.
  ///
  /// In ar, this message translates to:
  /// **'تم تسجيل الخروج بنجاح!'**
  String get signedOut;

  /// No description provided for @signOutError.
  ///
  /// In ar, this message translates to:
  /// **'حدث خطأ أثناء تسجيل الخروج. يرجى المحاولة مرة أخرى.'**
  String get signOutError;

  /// No description provided for @wrongCredentials.
  ///
  /// In ar, this message translates to:
  /// **'البريد الإلكتروني أو كلمة السر غير صحيحة.'**
  String get wrongCredentials;

  /// No description provided for @emailInUse.
  ///
  /// In ar, this message translates to:
  /// **'عنوان البريد الإلكتروني قيد الاستخدام بالفعل بواسطة حساب آخر.'**
  String get emailInUse;

  /// No description provided for @registerTitle.
  ///
  /// In ar, this message translates to:
  /// **'حساب جديد'**
  String get registerTitle;

  /// No description provided for @registerSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'أنشئ حسابك وشارك أصدقاءك في ختم القرآن'**
  String get registerSubtitle;

  /// No description provided for @haveAccount.
  ///
  /// In ar, this message translates to:
  /// **'لديك حساب؟'**
  String get haveAccount;

  /// No description provided for @signInLink.
  ///
  /// In ar, this message translates to:
  /// **'سجّل الدخول'**
  String get signInLink;

  /// No description provided for @createAccount.
  ///
  /// In ar, this message translates to:
  /// **'إنشاء الحساب'**
  String get createAccount;

  /// No description provided for @loginTitle.
  ///
  /// In ar, this message translates to:
  /// **'أهلاً بعودتك'**
  String get loginTitle;

  /// No description provided for @loginSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'سجّل دخولك لمتابعة ختماتك'**
  String get loginSubtitle;

  /// No description provided for @noAccount.
  ///
  /// In ar, this message translates to:
  /// **'ليس لديك حساب؟'**
  String get noAccount;

  /// No description provided for @createNewAccount.
  ///
  /// In ar, this message translates to:
  /// **'أنشئ حساباً جديداً'**
  String get createNewAccount;

  /// No description provided for @forgotPassword.
  ///
  /// In ar, this message translates to:
  /// **'نسيت كلمة السر؟'**
  String get forgotPassword;

  /// No description provided for @signIn.
  ///
  /// In ar, this message translates to:
  /// **'تسجيل الدخول'**
  String get signIn;

  /// No description provided for @resetLinkSent.
  ///
  /// In ar, this message translates to:
  /// **'أرسلنا رابط إعادة تعيين كلمة السر إلى بريدك'**
  String get resetLinkSent;

  /// No description provided for @resetLinkFailed.
  ///
  /// In ar, this message translates to:
  /// **'تعذّر إرسال الرابط، حاول مرة أخرى بعد قليل'**
  String get resetLinkFailed;

  /// No description provided for @recoverPassword.
  ///
  /// In ar, this message translates to:
  /// **'استعادة كلمة السر'**
  String get recoverPassword;

  /// No description provided for @recoverPasswordBody.
  ///
  /// In ar, this message translates to:
  /// **'سنرسل إلى بريدك رابطاً يفتح التطبيق لتختار كلمة سر جديدة.'**
  String get recoverPasswordBody;

  /// No description provided for @sendLink.
  ///
  /// In ar, this message translates to:
  /// **'إرسال الرابط'**
  String get sendLink;

  /// No description provided for @passwordsDontMatch.
  ///
  /// In ar, this message translates to:
  /// **'كلمتا السر غير متطابقتين'**
  String get passwordsDontMatch;

  /// No description provided for @passwordChanged.
  ///
  /// In ar, this message translates to:
  /// **'تم تغيير كلمة السر بنجاح'**
  String get passwordChanged;

  /// No description provided for @linkExpired.
  ///
  /// In ar, this message translates to:
  /// **'انتهت صلاحية الرابط، اطلب رابطاً جديداً'**
  String get linkExpired;

  /// No description provided for @newPasswordTitle.
  ///
  /// In ar, this message translates to:
  /// **'كلمة سر جديدة'**
  String get newPasswordTitle;

  /// No description provided for @newPasswordSubtitle.
  ///
  /// In ar, this message translates to:
  /// **'اختر كلمة سر جديدة لحسابك'**
  String get newPasswordSubtitle;

  /// No description provided for @newPassword.
  ///
  /// In ar, this message translates to:
  /// **'كلمة السر الجديدة'**
  String get newPassword;

  /// No description provided for @confirmPassword.
  ///
  /// In ar, this message translates to:
  /// **'تأكيد كلمة السر'**
  String get confirmPassword;

  /// No description provided for @savePassword.
  ///
  /// In ar, this message translates to:
  /// **'حفظ كلمة السر'**
  String get savePassword;

  /// No description provided for @settings.
  ///
  /// In ar, this message translates to:
  /// **'الإعدادات'**
  String get settings;

  /// No description provided for @editableSettings.
  ///
  /// In ar, this message translates to:
  /// **'الإعدادات القابلة للتغيير'**
  String get editableSettings;

  /// No description provided for @changeUsername.
  ///
  /// In ar, this message translates to:
  /// **'تغيير إسم المستخدم'**
  String get changeUsername;

  /// No description provided for @changeEmail.
  ///
  /// In ar, this message translates to:
  /// **'تغيير البريد الإلكتروني'**
  String get changeEmail;

  /// No description provided for @changePassword.
  ///
  /// In ar, this message translates to:
  /// **'تغيير كلمة السر'**
  String get changePassword;

  /// No description provided for @reminders.
  ///
  /// In ar, this message translates to:
  /// **'إشعارات التذكير'**
  String get reminders;

  /// No description provided for @appearance.
  ///
  /// In ar, this message translates to:
  /// **'المظهر (داكن/فاتح)'**
  String get appearance;

  /// No description provided for @signOut.
  ///
  /// In ar, this message translates to:
  /// **'تسجيل الخروج'**
  String get signOut;

  /// No description provided for @deleteAccount.
  ///
  /// In ar, this message translates to:
  /// **'حذف الحساب'**
  String get deleteAccount;

  /// No description provided for @supportSection.
  ///
  /// In ar, this message translates to:
  /// **'الدعم والمساعدة'**
  String get supportSection;

  /// No description provided for @helpCenter.
  ///
  /// In ar, this message translates to:
  /// **'مركز المساعدة'**
  String get helpCenter;

  /// No description provided for @aboutKhetmti.
  ///
  /// In ar, this message translates to:
  /// **'عن تطبيق ختمتي'**
  String get aboutKhetmti;

  /// No description provided for @accountDeleted.
  ///
  /// In ar, this message translates to:
  /// **'تم حذف حسابك. نسأل الله أن يتقبل منك'**
  String get accountDeleted;

  /// No description provided for @deleteAccountFailed.
  ///
  /// In ar, this message translates to:
  /// **'تعذّر حذف الحساب، حاول مرة أخرى'**
  String get deleteAccountFailed;

  /// No description provided for @deleteAccountTitle.
  ///
  /// In ar, this message translates to:
  /// **'حذف الحساب نهائياً'**
  String get deleteAccountTitle;

  /// No description provided for @deleteAccountBody.
  ///
  /// In ar, this message translates to:
  /// **'سيُحذف حسابك وأصدقاؤك ونقاطك، وتُلغى حجوزاتك التي لم تتمها. الختمات التي أنشأتها تنتقل إلى أقدم مشارك فيها، أو تُحذف إن لم يكن فيها غيرك. لا يمكن التراجع عن هذا.'**
  String get deleteAccountBody;

  /// No description provided for @deleteMyAccount.
  ///
  /// In ar, this message translates to:
  /// **'احذف حسابي'**
  String get deleteMyAccount;

  /// No description provided for @usernameChanged.
  ///
  /// In ar, this message translates to:
  /// **'تم تـــغيير إسم المستخــدم بنجـــاح'**
  String get usernameChanged;

  /// No description provided for @sameUsername.
  ///
  /// In ar, this message translates to:
  /// **'هذا هو اسمك الحالي'**
  String get sameUsername;

  /// No description provided for @changeNameTitle.
  ///
  /// In ar, this message translates to:
  /// **'تغيير الاسم'**
  String get changeNameTitle;

  /// No description provided for @changeNameBody.
  ///
  /// In ar, this message translates to:
  /// **'هذا الاسم يراه أصدقاؤك والمشاركون في ختماتك.'**
  String get changeNameBody;

  /// No description provided for @sameEmail.
  ///
  /// In ar, this message translates to:
  /// **'هذا هو بريدك الحالي'**
  String get sameEmail;

  /// No description provided for @emailConfirmSent.
  ///
  /// In ar, this message translates to:
  /// **'أرسلنا رابط تأكيد، افتحه لإتمام تغيير البريد'**
  String get emailConfirmSent;

  /// No description provided for @changeEmailError.
  ///
  /// In ar, this message translates to:
  /// **'حدث خطأ أثناء تغيير البريد الإلكتروني'**
  String get changeEmailError;

  /// No description provided for @changeEmailTitle.
  ///
  /// In ar, this message translates to:
  /// **'تغيير البريد'**
  String get changeEmailTitle;

  /// No description provided for @changeEmailBody.
  ///
  /// In ar, this message translates to:
  /// **'بريدك الحالي: {current}\nسنرسل رابط تأكيد، ويتغير بريد الدخول بعد فتحه.'**
  String changeEmailBody(String current);

  /// No description provided for @sendConfirmLink.
  ///
  /// In ar, this message translates to:
  /// **'إرسال رابط التأكيد'**
  String get sendConfirmLink;

  /// No description provided for @newEmail.
  ///
  /// In ar, this message translates to:
  /// **'البريد الإلكتروني الجديد'**
  String get newEmail;

  /// No description provided for @samePassword.
  ///
  /// In ar, this message translates to:
  /// **'كلمة السر الجديدة مطابقة للقديمة'**
  String get samePassword;

  /// No description provided for @wrongCurrentPassword.
  ///
  /// In ar, this message translates to:
  /// **'كلمة السر الحالية غير صحيحة'**
  String get wrongCurrentPassword;

  /// No description provided for @currentPassword.
  ///
  /// In ar, this message translates to:
  /// **'كلمة السر الحالية'**
  String get currentPassword;

  /// No description provided for @supportEmailSubject.
  ///
  /// In ar, this message translates to:
  /// **'دعم تطبيق ختمتي'**
  String get supportEmailSubject;

  /// No description provided for @helpTitle.
  ///
  /// In ar, this message translates to:
  /// **'المساعدة والدعم'**
  String get helpTitle;

  /// No description provided for @contactUs.
  ///
  /// In ar, this message translates to:
  /// **'تواصل معنا'**
  String get contactUs;

  /// No description provided for @byEmail.
  ///
  /// In ar, this message translates to:
  /// **'عبر البريد الإلكتروني'**
  String get byEmail;

  /// No description provided for @faq.
  ///
  /// In ar, this message translates to:
  /// **'الأسئلة الشائعة'**
  String get faq;

  /// No description provided for @faqCreateQ.
  ///
  /// In ar, this message translates to:
  /// **'كيف يمكنني إنشاء ختمة جديدة؟'**
  String get faqCreateQ;

  /// No description provided for @faqCreateA.
  ///
  /// In ar, this message translates to:
  /// **'يمكنك إنشاء ختمة جديدة من خلال الصفحة الرئيسية بالضغط على زر \'+\'، ثم تحديد نوع التقسيم (أجزاء أو سور) وعدد المشاركين المطلوب.'**
  String get faqCreateA;

  /// No description provided for @faqJoinQ.
  ///
  /// In ar, this message translates to:
  /// **'كيف أنضم لختمة موجودة؟'**
  String get faqJoinQ;

  /// No description provided for @faqJoinA.
  ///
  /// In ar, this message translates to:
  /// **'اطلب رمز الانضمام من منشئ الختمة، ثم من الصفحة الرئيسية اختر \'الانضمام لختمة\' وأدخل الرمز.'**
  String get faqJoinA;

  /// No description provided for @faqReserveQ.
  ///
  /// In ar, this message translates to:
  /// **'كيف يمكنني حجز جزء للقراءة؟'**
  String get faqReserveQ;

  /// No description provided for @faqReserveA.
  ///
  /// In ar, this message translates to:
  /// **'بعد الدخول إلى الختمة، ستجد قائمة بالأجزاء أو السور، اضغط على زر الحجز بجانب الجزء المتاح (غير المحجوز) ليصبح باسمك.'**
  String get faqReserveA;

  /// No description provided for @faqReadQ.
  ///
  /// In ar, this message translates to:
  /// **'هل يمكنني قراءة القرآن داخل التطبيق؟'**
  String get faqReadQ;

  /// No description provided for @faqReadA.
  ///
  /// In ar, this message translates to:
  /// **'نعم! عند دخولك لأي سورة أو جزء في الختمة أو من ملفك الشخصي، سيفتح لك التطبيق المصحف لقراءته مباشرة.'**
  String get faqReadA;

  /// No description provided for @faqOfflineQ.
  ///
  /// In ar, this message translates to:
  /// **'هل يمكنني القراءة بدون إنترنت؟'**
  String get faqOfflineQ;

  /// No description provided for @faqOfflineA.
  ///
  /// In ar, this message translates to:
  /// **'يحتاج التطبيق لاتصال بالإنترنت عند فتح الصفحة لأول مرة، لكننا نعمل على توفير ميزة الحفظ التلقائي للقراءة دون إنترنت قريباً.'**
  String get faqOfflineA;

  /// No description provided for @faqStatsQ.
  ///
  /// In ar, this message translates to:
  /// **'كيف يمكن معرفة إحصائيات قراءتي؟'**
  String get faqStatsQ;

  /// No description provided for @faqStatsA.
  ///
  /// In ar, this message translates to:
  /// **'من خلال صفحة الملف الشخصي (الحساب)، ستجد تبويب \'الإحصائيات\' الذي يعرض لك عدد الأجزاء والسور التي قرأتها.'**
  String get faqStatsA;

  /// No description provided for @aboutTitle.
  ///
  /// In ar, this message translates to:
  /// **'عن التطبيق'**
  String get aboutTitle;

  /// No description provided for @aboutAppName.
  ///
  /// In ar, this message translates to:
  /// **'ختمتي (Khetmti)'**
  String get aboutAppName;

  /// No description provided for @aboutBody.
  ///
  /// In ar, this message translates to:
  /// **'تطبيق ختمتي أُنشئ بهدف تسهيل وتشجيع قراءة القرآن الكريم وتنظيم الختمات الجماعية والفردية. نسأل الله أن يتقبل منا ومنكم صالح الأعمال وأن يجعله صدقة جارية.'**
  String get aboutBody;

  /// No description provided for @developer.
  ///
  /// In ar, this message translates to:
  /// **'المطور'**
  String get developer;

  /// No description provided for @developerName.
  ///
  /// In ar, this message translates to:
  /// **'لؤي البراق'**
  String get developerName;

  /// No description provided for @developerRole.
  ///
  /// In ar, this message translates to:
  /// **'مطور تطبيقات محمول'**
  String get developerRole;

  /// No description provided for @saveProgress.
  ///
  /// In ar, this message translates to:
  /// **'حفظ التقدم'**
  String get saveProgress;

  /// No description provided for @saveProgressBody.
  ///
  /// In ar, this message translates to:
  /// **'عند النقر على الآية، يتم حفظها كعلامة توقف. في المرة القادمة التي تدخل فيها إلى هذا الجزء من خلال الختمة، سينتقل التطبيق تلقائياً إلى آخر آية قمت بحفظها لإكمال القراءة بكل سهولة.'**
  String get saveProgressBody;

  /// No description provided for @fetchError.
  ///
  /// In ar, this message translates to:
  /// **'عذراً، حدث خطأ أثناء جلب البيانات'**
  String get fetchError;

  /// No description provided for @findFriend.
  ///
  /// In ar, this message translates to:
  /// **'البحث عن صديق'**
  String get findFriend;

  /// No description provided for @searchError.
  ///
  /// In ar, this message translates to:
  /// **'حدث خطأ أثناء البحث'**
  String get searchError;

  /// No description provided for @searchStart.
  ///
  /// In ar, this message translates to:
  /// **'ابدأ بالبحث عن اسم صديقك'**
  String get searchStart;

  /// No description provided for @noPersonFound.
  ///
  /// In ar, this message translates to:
  /// **'لا يوجد شخص بهذا الاسم'**
  String get noPersonFound;

  /// No description provided for @searchUsernameHint.
  ///
  /// In ar, this message translates to:
  /// **'ابحث عن اسم المستخدم...'**
  String get searchUsernameHint;

  /// No description provided for @requestSent.
  ///
  /// In ar, this message translates to:
  /// **'تم إرسال طلب الصداقة!'**
  String get requestSent;

  /// No description provided for @requestExists.
  ///
  /// In ar, this message translates to:
  /// **'يوجد طلب صداقة بينكما بالفعل'**
  String get requestExists;

  /// No description provided for @sendRequestError.
  ///
  /// In ar, this message translates to:
  /// **'حدث خطأ أثناء إرسال الطلب'**
  String get sendRequestError;

  /// No description provided for @requestCancelled.
  ///
  /// In ar, this message translates to:
  /// **'تم إلغاء طلب الصداقة!'**
  String get requestCancelled;

  /// No description provided for @cancelRequestError.
  ///
  /// In ar, this message translates to:
  /// **'حدث خطأ أثناء إلغاء الطلب'**
  String get cancelRequestError;

  /// No description provided for @requestAccepted.
  ///
  /// In ar, this message translates to:
  /// **'تم قبول طلب الصداقة بنجاح'**
  String get requestAccepted;

  /// No description provided for @acceptError.
  ///
  /// In ar, this message translates to:
  /// **'حدث خطأ أثناء قبول الطلب'**
  String get acceptError;

  /// No description provided for @requestDeclined.
  ///
  /// In ar, this message translates to:
  /// **'تم رفض طلب الصداقة'**
  String get requestDeclined;

  /// No description provided for @declineError.
  ///
  /// In ar, this message translates to:
  /// **'حدث خطأ أثناء رفض الطلب'**
  String get declineError;

  /// No description provided for @removeFriendError.
  ///
  /// In ar, this message translates to:
  /// **'حدث خطأ أثناء إزالة الصديق'**
  String get removeFriendError;

  /// No description provided for @friendRequests.
  ///
  /// In ar, this message translates to:
  /// **'طلبات الصداقة'**
  String get friendRequests;

  /// No description provided for @loadRequestsError.
  ///
  /// In ar, this message translates to:
  /// **'حدث خطأ أثناء تحميل الطلبات'**
  String get loadRequestsError;

  /// No description provided for @decline.
  ///
  /// In ar, this message translates to:
  /// **'رفض'**
  String get decline;

  /// No description provided for @accept.
  ///
  /// In ar, this message translates to:
  /// **'قبول'**
  String get accept;

  /// No description provided for @noRequests.
  ///
  /// In ar, this message translates to:
  /// **'لا توجد طلبات صداقة حالياً'**
  String get noRequests;

  /// No description provided for @friendsBadge.
  ///
  /// In ar, this message translates to:
  /// **'أصدقاء'**
  String get friendsBadge;

  /// No description provided for @cancelRequest.
  ///
  /// In ar, this message translates to:
  /// **'إلغاء الطلب'**
  String get cancelRequest;

  /// No description provided for @add.
  ///
  /// In ar, this message translates to:
  /// **'إضافة'**
  String get add;

  /// No description provided for @onlineNow.
  ///
  /// In ar, this message translates to:
  /// **'متصل الآن'**
  String get onlineNow;

  /// No description provided for @minutesAgo.
  ///
  /// In ar, this message translates to:
  /// **'منذ {n} دقيقة'**
  String minutesAgo(int n);

  /// No description provided for @hoursAgo.
  ///
  /// In ar, this message translates to:
  /// **'منذ {n} ساعة'**
  String hoursAgo(int n);

  /// No description provided for @daysAgo.
  ///
  /// In ar, this message translates to:
  /// **'منذ {n} أيام'**
  String daysAgo(int n);

  /// No description provided for @lastSeen.
  ///
  /// In ar, this message translates to:
  /// **'آخر ظهور: {when}'**
  String lastSeen(String when);

  /// No description provided for @leaderboard.
  ///
  /// In ar, this message translates to:
  /// **'لوحة المتصدرين'**
  String get leaderboard;

  /// No description provided for @today.
  ///
  /// In ar, this message translates to:
  /// **'اليوم'**
  String get today;

  /// No description provided for @thisWeek.
  ///
  /// In ar, this message translates to:
  /// **'الأسبوع'**
  String get thisWeek;

  /// No description provided for @allTime.
  ///
  /// In ar, this message translates to:
  /// **'الكل'**
  String get allTime;

  /// No description provided for @global.
  ///
  /// In ar, this message translates to:
  /// **'العالمي'**
  String get global;

  /// No description provided for @friends.
  ///
  /// In ar, this message translates to:
  /// **'الأصدقاء'**
  String get friends;

  /// No description provided for @me.
  ///
  /// In ar, this message translates to:
  /// **'أنا'**
  String get me;

  /// No description provided for @unfriendTitle.
  ///
  /// In ar, this message translates to:
  /// **'إلغاء الصداقة'**
  String get unfriendTitle;

  /// No description provided for @unfriendBody.
  ///
  /// In ar, this message translates to:
  /// **'هل أنت متأكد من إزالة هذا الصديق؟'**
  String get unfriendBody;

  /// No description provided for @quranOrder.
  ///
  /// In ar, this message translates to:
  /// **'ترتيب القرآن'**
  String get quranOrder;

  /// No description provided for @juzOrder.
  ///
  /// In ar, this message translates to:
  /// **'ترتيب الأجزاء'**
  String get juzOrder;

  /// No description provided for @mostRead.
  ///
  /// In ar, this message translates to:
  /// **'الأكثر قراءة'**
  String get mostRead;

  /// No description provided for @leastRead.
  ///
  /// In ar, this message translates to:
  /// **'الأقل قراءة'**
  String get leastRead;

  /// No description provided for @friendsList.
  ///
  /// In ar, this message translates to:
  /// **'قائمة الأصدقاء'**
  String get friendsList;

  /// No description provided for @activeKhatmas.
  ///
  /// In ar, this message translates to:
  /// **'ختماتك النشطة'**
  String get activeKhatmas;

  /// No description provided for @completedKhatmas.
  ///
  /// In ar, this message translates to:
  /// **'ختماتك المكتملة'**
  String get completedKhatmas;

  /// No description provided for @surahStats.
  ///
  /// In ar, this message translates to:
  /// **'إحصائيات السور'**
  String get surahStats;

  /// No description provided for @juzStats.
  ///
  /// In ar, this message translates to:
  /// **'إحصائيات الأجزاء'**
  String get juzStats;

  /// No description provided for @addFriend.
  ///
  /// In ar, this message translates to:
  /// **'إضافة صديق'**
  String get addFriend;

  /// No description provided for @loadFriendsError.
  ///
  /// In ar, this message translates to:
  /// **'خطأ في تحميل الأصدقاء'**
  String get loadFriendsError;

  /// No description provided for @noFriends.
  ///
  /// In ar, this message translates to:
  /// **'ليس لديك أصدقاء حاليا'**
  String get noFriends;

  /// No description provided for @loadKhatmasError.
  ///
  /// In ar, this message translates to:
  /// **'خطأ في تحميل الختمات'**
  String get loadKhatmasError;

  /// No description provided for @noActiveKhatmas.
  ///
  /// In ar, this message translates to:
  /// **'لا توجد ختمات نشطة'**
  String get noActiveKhatmas;

  /// No description provided for @noStats.
  ///
  /// In ar, this message translates to:
  /// **'لا توجد إحصائيات'**
  String get noStats;

  /// No description provided for @timesCount.
  ///
  /// In ar, this message translates to:
  /// **'{count} مرة'**
  String timesCount(int count);

  /// No description provided for @account.
  ///
  /// In ar, this message translates to:
  /// **'الحساب'**
  String get account;

  /// No description provided for @active.
  ///
  /// In ar, this message translates to:
  /// **'نشط'**
  String get active;

  /// No description provided for @rankStudent.
  ///
  /// In ar, this message translates to:
  /// **'طالب'**
  String get rankStudent;

  /// No description provided for @rankReader.
  ///
  /// In ar, this message translates to:
  /// **'قارئ'**
  String get rankReader;

  /// No description provided for @rankReciter.
  ///
  /// In ar, this message translates to:
  /// **'مرتل'**
  String get rankReciter;

  /// No description provided for @rankMujawwid.
  ///
  /// In ar, this message translates to:
  /// **'مجود'**
  String get rankMujawwid;

  /// No description provided for @rankHafiz.
  ///
  /// In ar, this message translates to:
  /// **'حافظ'**
  String get rankHafiz;

  /// No description provided for @rankMaster.
  ///
  /// In ar, this message translates to:
  /// **'متقن'**
  String get rankMaster;

  /// No description provided for @rankFaqih.
  ///
  /// In ar, this message translates to:
  /// **'فقيه'**
  String get rankFaqih;

  /// No description provided for @rankScholar.
  ///
  /// In ar, this message translates to:
  /// **'عالم'**
  String get rankScholar;

  /// No description provided for @rankImam.
  ///
  /// In ar, this message translates to:
  /// **'إمام'**
  String get rankImam;

  /// No description provided for @yourFriends.
  ///
  /// In ar, this message translates to:
  /// **'أصدقائك'**
  String get yourFriends;

  /// No description provided for @yourKhatmas.
  ///
  /// In ar, this message translates to:
  /// **'ختماتك'**
  String get yourKhatmas;

  /// No description provided for @stats.
  ///
  /// In ar, this message translates to:
  /// **'الإحصائيات'**
  String get stats;

  /// No description provided for @mustSignIn.
  ///
  /// In ar, this message translates to:
  /// **'يجب تسجيل الدخول أولاً'**
  String get mustSignIn;

  /// No description provided for @khatmaNotFound.
  ///
  /// In ar, this message translates to:
  /// **'الختمة غير موجودة'**
  String get khatmaNotFound;

  /// No description provided for @alreadyJoined.
  ///
  /// In ar, this message translates to:
  /// **'أنت منضم بالفعل لهذه الختمة'**
  String get alreadyJoined;

  /// No description provided for @khatmaFull.
  ///
  /// In ar, this message translates to:
  /// **'عذراً، هذه الختمة مكتملة العدد'**
  String get khatmaFull;

  /// No description provided for @mustJoinFirst.
  ///
  /// In ar, this message translates to:
  /// **'يجب الانضمام إلى الختمة أولاً'**
  String get mustJoinFirst;

  /// No description provided for @partUnavailable.
  ///
  /// In ar, this message translates to:
  /// **'لم يعد هذا الجزء متاحاً'**
  String get partUnavailable;

  /// No description provided for @menu.
  ///
  /// In ar, this message translates to:
  /// **'القائمة'**
  String get menu;

  /// No description provided for @khatmas.
  ///
  /// In ar, this message translates to:
  /// **'الختمات'**
  String get khatmas;

  /// No description provided for @createNewKhatma.
  ///
  /// In ar, this message translates to:
  /// **'إنشاء ختمة جديدة'**
  String get createNewKhatma;

  /// No description provided for @createNewKhatmaDesc.
  ///
  /// In ar, this message translates to:
  /// **'ابدأ رحلة تلاوة جديدة وشاركها مع من تحب'**
  String get createNewKhatmaDesc;

  /// No description provided for @joinExisting.
  ///
  /// In ar, this message translates to:
  /// **'الإنضمام لختمة موجودة'**
  String get joinExisting;

  /// No description provided for @joinExistingDesc.
  ///
  /// In ar, this message translates to:
  /// **'ابحث عن مجموعات تلاوة وانضم إليهم'**
  String get joinExistingDesc;

  /// No description provided for @searchPerson.
  ///
  /// In ar, this message translates to:
  /// **'البحث عن شخص'**
  String get searchPerson;

  /// No description provided for @searchPersonDesc.
  ///
  /// In ar, this message translates to:
  /// **'تواصل مع أصدقائك وتابع تقدمهم'**
  String get searchPersonDesc;

  /// No description provided for @friendRequestsDesc.
  ///
  /// In ar, this message translates to:
  /// **'شاهد من يريد أن يكون صديقك'**
  String get friendRequestsDesc;

  /// No description provided for @tipTitle.
  ///
  /// In ar, this message translates to:
  /// **'هل تريد نصيحة؟'**
  String get tipTitle;

  /// No description provided for @tipBody.
  ///
  /// In ar, this message translates to:
  /// **'قراءة صفحتين يومياً تعينك على ختم القرآن في عام واحد.'**
  String get tipBody;

  /// No description provided for @khatmaForRequired.
  ///
  /// In ar, this message translates to:
  /// **'اكتب لمن هذه الختمة'**
  String get khatmaForRequired;

  /// No description provided for @khatmaCreated.
  ///
  /// In ar, this message translates to:
  /// **'تم إنشاء الختمة بنجاح'**
  String get khatmaCreated;

  /// No description provided for @createKhatmaError.
  ///
  /// In ar, this message translates to:
  /// **'حدث خطأ أثناء إنشاء الختمة'**
  String get createKhatmaError;

  /// No description provided for @createKhatmaTitle.
  ///
  /// In ar, this message translates to:
  /// **'إنشاء ختمة'**
  String get createKhatmaTitle;

  /// No description provided for @khatmaFor.
  ///
  /// In ar, this message translates to:
  /// **'ختمة لفائدة'**
  String get khatmaFor;

  /// No description provided for @khatmaForHint.
  ///
  /// In ar, this message translates to:
  /// **'مثال: جدي رحمه الله'**
  String get khatmaForHint;

  /// No description provided for @createKhatmaButton.
  ///
  /// In ar, this message translates to:
  /// **'إنشاء الختمة'**
  String get createKhatmaButton;

  /// No description provided for @maxParticipants.
  ///
  /// In ar, this message translates to:
  /// **'العدد الأقصى للمشاركين'**
  String get maxParticipants;

  /// No description provided for @includingYou.
  ///
  /// In ar, this message translates to:
  /// **'بمن فيهم أنت'**
  String get includingYou;

  /// No description provided for @splitKhatma.
  ///
  /// In ar, this message translates to:
  /// **'تقسيم الختمة'**
  String get splitKhatma;

  /// No description provided for @splitKhatmaDesc.
  ///
  /// In ar, this message translates to:
  /// **'كل مشارك يحجز ما سيقرؤه'**
  String get splitKhatmaDesc;

  /// No description provided for @bySurah.
  ///
  /// In ar, this message translates to:
  /// **'بالسور'**
  String get bySurah;

  /// No description provided for @surahCount.
  ///
  /// In ar, this message translates to:
  /// **'114 سورة'**
  String get surahCount;

  /// No description provided for @byJuz.
  ///
  /// In ar, this message translates to:
  /// **'بالأجزاء'**
  String get byJuz;

  /// No description provided for @juzCount.
  ///
  /// In ar, this message translates to:
  /// **'30 جزءاً'**
  String get juzCount;

  /// No description provided for @wrongCode.
  ///
  /// In ar, this message translates to:
  /// **'الرمز غير صحيح أو الختمة غير موجودة'**
  String get wrongCode;

  /// No description provided for @joined.
  ///
  /// In ar, this message translates to:
  /// **'تم الانضمام بنجاح!'**
  String get joined;

  /// No description provided for @enter5Digits.
  ///
  /// In ar, this message translates to:
  /// **'يرجى إدخال رمز مكون من 5 أرقام'**
  String get enter5Digits;

  /// No description provided for @joinKhatmaTitle.
  ///
  /// In ar, this message translates to:
  /// **'الانضمام لختمة'**
  String get joinKhatmaTitle;

  /// No description provided for @byCode.
  ///
  /// In ar, this message translates to:
  /// **'بالرمز'**
  String get byCode;

  /// No description provided for @byName.
  ///
  /// In ar, this message translates to:
  /// **'بالاسم'**
  String get byName;

  /// No description provided for @enterJoinCode.
  ///
  /// In ar, this message translates to:
  /// **'أدخل رمز الانضمام'**
  String get enterJoinCode;

  /// No description provided for @joinCodeHelp.
  ///
  /// In ar, this message translates to:
  /// **'رمز من 5 أرقام تجده في صفحة الختمة لدى أي مشارك'**
  String get joinCodeHelp;

  /// No description provided for @joinNow.
  ///
  /// In ar, this message translates to:
  /// **'انضم الآن'**
  String get joinNow;

  /// No description provided for @khatmaName.
  ///
  /// In ar, this message translates to:
  /// **'اسم الختمة'**
  String get khatmaName;

  /// No description provided for @noKhatmaByName.
  ///
  /// In ar, this message translates to:
  /// **'لا توجد ختمة بهذا الاسم'**
  String get noKhatmaByName;

  /// No description provided for @khatmaForName.
  ///
  /// In ar, this message translates to:
  /// **'ختمة لفائدة {name}'**
  String khatmaForName(String name);

  /// No description provided for @khatmaSearchMeta.
  ///
  /// In ar, this message translates to:
  /// **'{current}/{max} مشاركين · {unit} · {percent}%'**
  String khatmaSearchMeta(int current, int max, String unit, int percent);

  /// No description provided for @full.
  ///
  /// In ar, this message translates to:
  /// **'مكتملة العدد'**
  String get full;

  /// No description provided for @join.
  ///
  /// In ar, this message translates to:
  /// **'انضمام'**
  String get join;

  /// No description provided for @loadKhatmasHomeError.
  ///
  /// In ar, this message translates to:
  /// **'تعذّر تحميل الختمات، تحقق من اتصالك'**
  String get loadKhatmasHomeError;

  /// No description provided for @noCompletedYet.
  ///
  /// In ar, this message translates to:
  /// **'لا توجد ختمات مكتملة بعد'**
  String get noCompletedYet;

  /// No description provided for @emptyActiveHint.
  ///
  /// In ar, this message translates to:
  /// **'أنشئ ختمة جديدة أو انضم إلى ختمة أصدقائك برمزها'**
  String get emptyActiveHint;

  /// No description provided for @emptyCompletedHint.
  ///
  /// In ar, this message translates to:
  /// **'ستظهر هنا الختمات التي يتم إتمامها'**
  String get emptyCompletedHint;

  /// No description provided for @notifications.
  ///
  /// In ar, this message translates to:
  /// **'الإشعارات'**
  String get notifications;

  /// No description provided for @noNotifications.
  ///
  /// In ar, this message translates to:
  /// **'لا توجد إشعارات حالياً'**
  String get noNotifications;

  /// No description provided for @partAvailable.
  ///
  /// In ar, this message translates to:
  /// **'متاحة للحجز'**
  String get partAvailable;

  /// No description provided for @partReservedForYou.
  ///
  /// In ar, this message translates to:
  /// **'محجوزة لك'**
  String get partReservedForYou;

  /// No description provided for @partReservedBy.
  ///
  /// In ar, this message translates to:
  /// **'محجوزة لـ {name}'**
  String partReservedBy(String name);

  /// No description provided for @partFinishedByYou.
  ///
  /// In ar, this message translates to:
  /// **'أتممتَ قراءتها'**
  String get partFinishedByYou;

  /// No description provided for @partReadBy.
  ///
  /// In ar, this message translates to:
  /// **'قرأها {name}'**
  String partReadBy(String name);

  /// No description provided for @reserve.
  ///
  /// In ar, this message translates to:
  /// **'احجز'**
  String get reserve;

  /// No description provided for @cancelReservation.
  ///
  /// In ar, this message translates to:
  /// **'إلغاء الحجز'**
  String get cancelReservation;

  /// No description provided for @finishedButton.
  ///
  /// In ar, this message translates to:
  /// **'أتممت'**
  String get finishedButton;

  /// No description provided for @congratsFinished.
  ///
  /// In ar, this message translates to:
  /// **'بارك الله فيك! أتممت قراءة {part}'**
  String congratsFinished(String part);

  /// No description provided for @undoFinishTitle.
  ///
  /// In ar, this message translates to:
  /// **'التراجع عن الإتمام'**
  String get undoFinishTitle;

  /// No description provided for @undoFinishBody.
  ///
  /// In ar, this message translates to:
  /// **'ستعود \"{part}\" محجوزة لك، وتُخصم النقاط التي حصلت عليها عند إتمامها.'**
  String undoFinishBody(String part);

  /// No description provided for @deleteKhatmaTitle.
  ///
  /// In ar, this message translates to:
  /// **'حذف الختمة'**
  String get deleteKhatmaTitle;

  /// No description provided for @deleteKhatmaBody.
  ///
  /// In ar, this message translates to:
  /// **'هل أنت متأكد من حذف هذه الختمة؟ سيتم حذفها لجميع المشاركين ولا يمكن التراجع.'**
  String get deleteKhatmaBody;

  /// No description provided for @khatmaDeleted.
  ///
  /// In ar, this message translates to:
  /// **'تم حذف الختمة بنجاح'**
  String get khatmaDeleted;

  /// No description provided for @deleteKhatmaError.
  ///
  /// In ar, this message translates to:
  /// **'حدث خطأ أثناء حذف الختمة'**
  String get deleteKhatmaError;

  /// No description provided for @ayahCount.
  ///
  /// In ar, this message translates to:
  /// **'{countText} آية'**
  String ayahCount(int count, String countText);

  /// No description provided for @tabContent.
  ///
  /// In ar, this message translates to:
  /// **'المحتوى'**
  String get tabContent;

  /// No description provided for @tabParticipants.
  ///
  /// In ar, this message translates to:
  /// **'المشاركون'**
  String get tabParticipants;

  /// No description provided for @tabLog.
  ///
  /// In ar, this message translates to:
  /// **'السجل'**
  String get tabLog;

  /// No description provided for @participantsOf.
  ///
  /// In ar, this message translates to:
  /// **'{current} / {max} مشاركين'**
  String participantsOf(int current, int max);

  /// No description provided for @participantsCount.
  ///
  /// In ar, this message translates to:
  /// **'{count} مشاركين'**
  String participantsCount(int count);

  /// No description provided for @codeCopied.
  ///
  /// In ar, this message translates to:
  /// **'تم نسخ رمز الانضمام'**
  String get codeCopied;

  /// No description provided for @joinCode.
  ///
  /// In ar, this message translates to:
  /// **'رمز الانضمام'**
  String get joinCode;

  /// No description provided for @filterAll.
  ///
  /// In ar, this message translates to:
  /// **'الكل'**
  String get filterAll;

  /// No description provided for @filterAvailable.
  ///
  /// In ar, this message translates to:
  /// **'المتاحة'**
  String get filterAvailable;

  /// No description provided for @filterMine.
  ///
  /// In ar, this message translates to:
  /// **'محجوزاتي'**
  String get filterMine;

  /// No description provided for @filterDone.
  ///
  /// In ar, this message translates to:
  /// **'المكتملة'**
  String get filterDone;

  /// No description provided for @emptyAvailable.
  ///
  /// In ar, this message translates to:
  /// **'لم يبق شيء متاح للحجز'**
  String get emptyAvailable;

  /// No description provided for @emptyMine.
  ///
  /// In ar, this message translates to:
  /// **'لم تحجز شيئاً بعد، اختر من المتاحة'**
  String get emptyMine;

  /// No description provided for @emptyDone.
  ///
  /// In ar, this message translates to:
  /// **'لم يكتمل شيء بعد'**
  String get emptyDone;

  /// No description provided for @loadParticipantsError.
  ///
  /// In ar, this message translates to:
  /// **'تعذّر تحميل المشاركين'**
  String get loadParticipantsError;

  /// No description provided for @creator.
  ///
  /// In ar, this message translates to:
  /// **'المنشئ'**
  String get creator;

  /// No description provided for @finishedN.
  ///
  /// In ar, this message translates to:
  /// **'أتمّ {done} {unit}'**
  String finishedN(int done, String unit);

  /// No description provided for @readingN.
  ///
  /// In ar, this message translates to:
  /// **'يقرأ {count}'**
  String readingN(int count);

  /// No description provided for @logReserved.
  ///
  /// In ar, this message translates to:
  /// **'حجز'**
  String get logReserved;

  /// No description provided for @logFinished.
  ///
  /// In ar, this message translates to:
  /// **'أتم القراءة'**
  String get logFinished;

  /// No description provided for @logReleased.
  ///
  /// In ar, this message translates to:
  /// **'ألغى الحجز'**
  String get logReleased;

  /// No description provided for @logUndone.
  ///
  /// In ar, this message translates to:
  /// **'تراجع عن القراءة'**
  String get logUndone;

  /// No description provided for @noActivity.
  ///
  /// In ar, this message translates to:
  /// **'لا توجد نشاطات مسجلة بعد'**
  String get noActivity;

  /// No description provided for @finishedVerb.
  ///
  /// In ar, this message translates to:
  /// **'أتم'**
  String get finishedVerb;

  /// No description provided for @khatmaGoneBody.
  ///
  /// In ar, this message translates to:
  /// **'يبدو أن هذه الختمة قد حُذفت أو لم تعد متوفرة.'**
  String get khatmaGoneBody;

  /// No description provided for @activeTab.
  ///
  /// In ar, this message translates to:
  /// **'النشطة'**
  String get activeTab;

  /// No description provided for @completedTab.
  ///
  /// In ar, this message translates to:
  /// **'المكتملة'**
  String get completedTab;

  /// No description provided for @completedOn.
  ///
  /// In ar, this message translates to:
  /// **'تاريخ الإكمال: '**
  String get completedOn;

  /// No description provided for @startedOn.
  ///
  /// In ar, this message translates to:
  /// **'تاريخ البدء: '**
  String get startedOn;

  /// No description provided for @navHome.
  ///
  /// In ar, this message translates to:
  /// **'الرئيسية'**
  String get navHome;

  /// No description provided for @skip.
  ///
  /// In ar, this message translates to:
  /// **'تخطي'**
  String get skip;

  /// No description provided for @startNow.
  ///
  /// In ar, this message translates to:
  /// **'ابدأ الآن'**
  String get startNow;

  /// No description provided for @onb1Title.
  ///
  /// In ar, this message translates to:
  /// **'أنشئ ختمة جديدة'**
  String get onb1Title;

  /// No description provided for @onb1Body.
  ///
  /// In ar, this message translates to:
  /// **'ابدأ ختمتك بسهولة: اكتب لمن هي، وحدّد عدد المشاركين وطريقة التقسيم بالسور أو بالأجزاء.'**
  String get onb1Body;

  /// No description provided for @onb2Title.
  ///
  /// In ar, this message translates to:
  /// **'تابع تقدّم الختمة'**
  String get onb2Title;

  /// No description provided for @onb2Body.
  ///
  /// In ar, this message translates to:
  /// **'احجز ما ستقرؤه، وأتمّه بلمسة، وتابع نسبة الإنجاز ومن يقرأ ماذا حتى تكتمل الختمة.'**
  String get onb2Body;

  /// No description provided for @onb3Title.
  ///
  /// In ar, this message translates to:
  /// **'كل ختماتك في مكان واحد'**
  String get onb3Title;

  /// No description provided for @onb3Body.
  ///
  /// In ar, this message translates to:
  /// **'ختماتك النشطة والمكتملة أمامك، يتحدّث تقدّمها مباشرة كلما قرأ أحد المشاركين.'**
  String get onb3Body;

  /// No description provided for @onb4Title.
  ///
  /// In ar, this message translates to:
  /// **'أصدقاؤك معك'**
  String get onb4Title;

  /// No description provided for @onb4Body.
  ///
  /// In ar, this message translates to:
  /// **'تابع أصدقاءك ومستوياتهم، وتنافسوا في الخير في لوحة المتصدرين.'**
  String get onb4Body;

  /// No description provided for @onb5Title.
  ///
  /// In ar, this message translates to:
  /// **'ابحث عن الأشخاص'**
  String get onb5Title;

  /// No description provided for @onb5Body.
  ///
  /// In ar, this message translates to:
  /// **'ابحث عن أصدقائك بالاسم، وأرسل طلبات الصداقة أو اقبلها لتشاركوا الختمات معاً.'**
  String get onb5Body;

  /// No description provided for @onb6Title.
  ///
  /// In ar, this message translates to:
  /// **'انطلق، والله في عونك'**
  String get onb6Title;

  /// No description provided for @onb6Body.
  ///
  /// In ar, this message translates to:
  /// **'استعد لرحلتك مع القرآن. سواء بدأت ختمة أو شاركت في أخرى، أتمّ وردك بفضل الله.'**
  String get onb6Body;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en', 'es', 'fr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'fr':
      return AppLocalizationsFr();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
