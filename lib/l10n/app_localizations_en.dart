// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Khetmti';

  @override
  String get appName => 'Khetmti';

  @override
  String get cancel => 'Cancel';

  @override
  String get save => 'Save';

  @override
  String get delete => 'Delete';

  @override
  String get remove => 'Remove';

  @override
  String get undo => 'Undo';

  @override
  String get ok => 'OK';

  @override
  String get retry => 'Try again';

  @override
  String get genericError => 'Something went wrong';

  @override
  String get tryAgainError => 'Something went wrong, please try again';

  @override
  String get noData => 'No data yet';

  @override
  String get loadDataError => 'Couldn\'t load the data';

  @override
  String get loading => 'Loading…';

  @override
  String get unknown => 'Unknown';

  @override
  String get participant => 'a member';

  @override
  String surahName(String name) {
    return 'Surah $name';
  }

  @override
  String levelN(String level) {
    return 'Level $level';
  }

  @override
  String levelColon(String level) {
    return 'Level $level';
  }

  @override
  String levelShort(String level) {
    return 'Level $level';
  }

  @override
  String juzN(String n) {
    return 'Juz $n';
  }

  @override
  String get surah => 'surah';

  @override
  String get juz => 'juz';

  @override
  String get surahs => 'Surahs';

  @override
  String get juzs => 'Juz';

  @override
  String get language => 'Language';

  @override
  String get invalidEmail => 'Invalid email address';

  @override
  String passwordTooShort(int min) {
    return 'Password must be at least $min characters';
  }

  @override
  String usernameTooShort(int min) {
    return 'Name must be at least $min characters';
  }

  @override
  String nameTooShort(int min) {
    return 'Name must be at least $min characters';
  }

  @override
  String minChars(int min) {
    return 'At least $min characters';
  }

  @override
  String get enterPassword => 'Please enter your password';

  @override
  String get fillAllFields => 'Please fill in all fields';

  @override
  String get fullName => 'Full name';

  @override
  String get fullNameHint => 'As your friends will see it';

  @override
  String get email => 'Email';

  @override
  String get password => 'Password';

  @override
  String get showPassword => 'Show password';

  @override
  String get hidePassword => 'Hide password';

  @override
  String get accountCreated => 'Account created!';

  @override
  String get signedIn => 'Signed in!';

  @override
  String get signedOut => 'Signed out';

  @override
  String get signOutError => 'Couldn\'t sign out. Please try again.';

  @override
  String get wrongCredentials => 'Incorrect email or password.';

  @override
  String get emailInUse => 'This email is already used by another account.';

  @override
  String get registerTitle => 'New account';

  @override
  String get registerSubtitle =>
      'Create your account and complete the Quran with your friends';

  @override
  String get haveAccount => 'Already have an account?';

  @override
  String get signInLink => 'Sign in';

  @override
  String get createAccount => 'Create account';

  @override
  String get loginTitle => 'Welcome back';

  @override
  String get loginSubtitle => 'Sign in to follow your khatmas';

  @override
  String get noAccount => 'Don\'t have an account?';

  @override
  String get createNewAccount => 'Create one';

  @override
  String get forgotPassword => 'Forgot password?';

  @override
  String get signIn => 'Sign in';

  @override
  String get resetLinkSent => 'We sent a password reset link to your email';

  @override
  String get resetLinkFailed =>
      'Couldn\'t send the link, try again in a moment';

  @override
  String get recoverPassword => 'Reset password';

  @override
  String get recoverPasswordBody =>
      'We\'ll email you a link that opens the app so you can choose a new password.';

  @override
  String get sendLink => 'Send link';

  @override
  String get passwordsDontMatch => 'Passwords don\'t match';

  @override
  String get passwordChanged => 'Password changed';

  @override
  String get linkExpired => 'This link has expired, request a new one';

  @override
  String get newPasswordTitle => 'New password';

  @override
  String get newPasswordSubtitle => 'Choose a new password for your account';

  @override
  String get newPassword => 'New password';

  @override
  String get confirmPassword => 'Confirm password';

  @override
  String get savePassword => 'Save password';

  @override
  String get settings => 'Settings';

  @override
  String get editableSettings => 'Your account';

  @override
  String get changeUsername => 'Change name';

  @override
  String get changeEmail => 'Change email';

  @override
  String get changePassword => 'Change password';

  @override
  String get reminders => 'Reminders';

  @override
  String get appearance => 'Appearance (dark/light)';

  @override
  String get signOut => 'Sign out';

  @override
  String get deleteAccount => 'Delete account';

  @override
  String get supportSection => 'Help & support';

  @override
  String get helpCenter => 'Help center';

  @override
  String get aboutKhetmti => 'About Khetmti';

  @override
  String get accountDeleted =>
      'Your account was deleted. May Allah accept from you.';

  @override
  String get deleteAccountFailed => 'Couldn\'t delete your account, try again';

  @override
  String get deleteAccountTitle => 'Delete account permanently';

  @override
  String get deleteAccountBody =>
      'Your account, friends and points will be deleted, and parts you haven\'t finished will be released. Khatmas you created pass to their oldest member, or are deleted if you\'re the only one. This can\'t be undone.';

  @override
  String get deleteMyAccount => 'Delete my account';

  @override
  String get usernameChanged => 'Name changed';

  @override
  String get sameUsername => 'That\'s already your name';

  @override
  String get changeNameTitle => 'Change name';

  @override
  String get changeNameBody => 'Your friends and khatma members see this name.';

  @override
  String get sameEmail => 'That\'s already your email';

  @override
  String get emailConfirmSent =>
      'We sent a confirmation link, open it to finish changing your email';

  @override
  String get changeEmailError => 'Couldn\'t change your email';

  @override
  String get changeEmailTitle => 'Change email';

  @override
  String changeEmailBody(String current) {
    return 'Your current email: $current\nWe\'ll send a confirmation link; your sign-in email changes once you open it.';
  }

  @override
  String get sendConfirmLink => 'Send confirmation link';

  @override
  String get newEmail => 'New email';

  @override
  String get samePassword => 'The new password is the same as the old one';

  @override
  String get wrongCurrentPassword => 'Your current password is incorrect';

  @override
  String get currentPassword => 'Current password';

  @override
  String get supportEmailSubject => 'Khetmti app support';

  @override
  String get helpTitle => 'Help & support';

  @override
  String get contactUs => 'Contact us';

  @override
  String get byEmail => 'By email';

  @override
  String get faq => 'Frequently asked questions';

  @override
  String get faqCreateQ => 'How do I create a new khatma?';

  @override
  String get faqCreateA =>
      'From the home page, tap the \'+\' button, then choose how to split it (by juz or by surah) and how many members can join.';

  @override
  String get faqJoinQ => 'How do I join an existing khatma?';

  @override
  String get faqJoinA =>
      'Ask the khatma\'s creator for its join code, then choose \'Join a khatma\' on the home page and enter the code.';

  @override
  String get faqReserveQ => 'How do I reserve a part to read?';

  @override
  String get faqReserveA =>
      'Open the khatma to see its juz or surahs, then tap Reserve next to any free part and it becomes yours.';

  @override
  String get faqReadQ => 'Can I read the Quran inside the app?';

  @override
  String get faqReadA =>
      'Yes! Open any surah or juz from a khatma or from your profile and the app opens the mushaf right there.';

  @override
  String get faqOfflineQ => 'Can I read offline?';

  @override
  String get faqOfflineA =>
      'The app needs a connection the first time you open a page; offline reading is coming soon.';

  @override
  String get faqStatsQ => 'How can I see my reading statistics?';

  @override
  String get faqStatsA =>
      'On your profile (Account) page, the \'Statistics\' tab shows how many juz and surahs you have read.';

  @override
  String get aboutTitle => 'About the app';

  @override
  String get aboutAppName => 'Khetmti (ختمتي)';

  @override
  String get aboutBody =>
      'Khetmti was made to make reading the Holy Quran easier and to organise group and personal khatmas. May Allah accept our good deeds and yours, and make it an ongoing charity (sadaqa jariya).';

  @override
  String get developer => 'Developer';

  @override
  String get developerName => 'Louay Barraq';

  @override
  String get developerRole => 'Mobile app developer';

  @override
  String get saveProgress => 'Saving your place';

  @override
  String get saveProgressBody =>
      'Tap an ayah to save it as your stopping point. Next time you open this part from the khatma, the app jumps straight to that ayah so you can carry on.';

  @override
  String get fetchError => 'Sorry, we couldn\'t load the text';

  @override
  String get findFriend => 'Find a friend';

  @override
  String get searchError => 'Search failed';

  @override
  String get searchStart => 'Start by searching for your friend\'s name';

  @override
  String get noPersonFound => 'No one by that name';

  @override
  String get searchUsernameHint => 'Search by name…';

  @override
  String get requestSent => 'Friend request sent!';

  @override
  String get requestExists => 'There\'s already a request between you';

  @override
  String get sendRequestError => 'Couldn\'t send the request';

  @override
  String get requestCancelled => 'Friend request cancelled';

  @override
  String get cancelRequestError => 'Couldn\'t cancel the request';

  @override
  String get requestAccepted => 'Friend request accepted';

  @override
  String get acceptError => 'Couldn\'t accept the request';

  @override
  String get requestDeclined => 'Friend request declined';

  @override
  String get declineError => 'Couldn\'t decline the request';

  @override
  String get removeFriendError => 'Couldn\'t remove this friend';

  @override
  String get friendRequests => 'Friend requests';

  @override
  String get loadRequestsError => 'Couldn\'t load requests';

  @override
  String get decline => 'Decline';

  @override
  String get accept => 'Accept';

  @override
  String get noRequests => 'No friend requests right now';

  @override
  String get friendsBadge => 'Friends';

  @override
  String get cancelRequest => 'Cancel request';

  @override
  String get add => 'Add';

  @override
  String get onlineNow => 'Online now';

  @override
  String minutesAgo(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n minutes ago',
      one: '1 minute ago',
    );
    return '$_temp0';
  }

  @override
  String hoursAgo(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n hours ago',
      one: '1 hour ago',
    );
    return '$_temp0';
  }

  @override
  String daysAgo(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n days ago',
      one: '1 day ago',
    );
    return '$_temp0';
  }

  @override
  String lastSeen(String when) {
    return 'Last seen: $when';
  }

  @override
  String get leaderboard => 'Leaderboard';

  @override
  String get today => 'Today';

  @override
  String get thisWeek => 'Week';

  @override
  String get allTime => 'All time';

  @override
  String get global => 'Global';

  @override
  String get friends => 'Friends';

  @override
  String get me => 'Me';

  @override
  String get unfriendTitle => 'Remove friend';

  @override
  String get unfriendBody => 'Are you sure you want to remove this friend?';

  @override
  String get quranOrder => 'Quran order';

  @override
  String get juzOrder => 'Juz order';

  @override
  String get mostRead => 'Most read';

  @override
  String get leastRead => 'Least read';

  @override
  String get friendsList => 'Friends list';

  @override
  String get activeKhatmas => 'Your active khatmas';

  @override
  String get completedKhatmas => 'Your completed khatmas';

  @override
  String get surahStats => 'Surah statistics';

  @override
  String get juzStats => 'Juz statistics';

  @override
  String get addFriend => 'Add friend';

  @override
  String get loadFriendsError => 'Couldn\'t load friends';

  @override
  String get noFriends => 'You don\'t have any friends yet';

  @override
  String get loadKhatmasError => 'Couldn\'t load khatmas';

  @override
  String get noActiveKhatmas => 'No active khatmas';

  @override
  String get noStats => 'No statistics yet';

  @override
  String timesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count times',
      one: 'once',
    );
    return '$_temp0';
  }

  @override
  String get account => 'Account';

  @override
  String get active => 'Active';

  @override
  String get rankStudent => 'Student';

  @override
  String get rankReader => 'Reader';

  @override
  String get rankReciter => 'Reciter';

  @override
  String get rankMujawwid => 'Mujawwid';

  @override
  String get rankHafiz => 'Hafiz';

  @override
  String get rankMaster => 'Master';

  @override
  String get rankFaqih => 'Faqih';

  @override
  String get rankScholar => 'Scholar';

  @override
  String get rankImam => 'Imam';

  @override
  String get yourFriends => 'Friends';

  @override
  String get yourKhatmas => 'Khatmas';

  @override
  String get stats => 'Statistics';

  @override
  String get mustSignIn => 'Please sign in first';

  @override
  String get khatmaNotFound => 'Khatma not found';

  @override
  String get alreadyJoined => 'You\'ve already joined this khatma';

  @override
  String get khatmaFull => 'Sorry, this khatma is full';

  @override
  String get mustJoinFirst => 'Join the khatma first';

  @override
  String get partUnavailable => 'This part is no longer available';

  @override
  String get menu => 'Menu';

  @override
  String get khatmas => 'Khatmas';

  @override
  String get createNewKhatma => 'Create a new khatma';

  @override
  String get createNewKhatmaDesc =>
      'Start a new recitation journey and share it with your loved ones';

  @override
  String get joinExisting => 'Join an existing khatma';

  @override
  String get joinExistingDesc => 'Find recitation groups and join them';

  @override
  String get searchPerson => 'Find someone';

  @override
  String get searchPersonDesc =>
      'Connect with friends and follow their progress';

  @override
  String get friendRequestsDesc => 'See who wants to be your friend';

  @override
  String get tipTitle => 'Want a tip?';

  @override
  String get tipBody =>
      'Reading two pages a day helps you complete the Quran within a year.';

  @override
  String get khatmaForRequired => 'Write who this khatma is for';

  @override
  String get khatmaCreated => 'Khatma created';

  @override
  String get createKhatmaError => 'Couldn\'t create the khatma';

  @override
  String get createKhatmaTitle => 'Create a khatma';

  @override
  String get khatmaFor => 'Khatma for';

  @override
  String get khatmaForHint => 'e.g. my late grandfather';

  @override
  String get createKhatmaButton => 'Create khatma';

  @override
  String get maxParticipants => 'Maximum members';

  @override
  String get includingYou => 'Including you';

  @override
  String get splitKhatma => 'Split the khatma';

  @override
  String get splitKhatmaDesc => 'Each member reserves what they will read';

  @override
  String get bySurah => 'By surah';

  @override
  String get surahCount => '114 surahs';

  @override
  String get byJuz => 'By juz';

  @override
  String get juzCount => '30 juz';

  @override
  String get wrongCode => 'Wrong code, or the khatma no longer exists';

  @override
  String get joined => 'You joined!';

  @override
  String get enter5Digits => 'Please enter a 5-digit code';

  @override
  String get joinKhatmaTitle => 'Join a khatma';

  @override
  String get byCode => 'By code';

  @override
  String get byName => 'By name';

  @override
  String get enterJoinCode => 'Enter the join code';

  @override
  String get joinCodeHelp =>
      'A 5-digit code any member can find on the khatma page';

  @override
  String get joinNow => 'Join now';

  @override
  String get khatmaName => 'Khatma name';

  @override
  String get noKhatmaByName => 'No khatma by that name';

  @override
  String khatmaForName(String name) {
    return 'Khatma for $name';
  }

  @override
  String khatmaSearchMeta(int current, int max, String unit, int percent) {
    return '$current/$max members · $unit · $percent%';
  }

  @override
  String get full => 'Full';

  @override
  String get join => 'Join';

  @override
  String get loadKhatmasHomeError =>
      'Couldn\'t load khatmas, check your connection';

  @override
  String get noCompletedYet => 'No completed khatmas yet';

  @override
  String get emptyActiveHint =>
      'Create a new khatma or join your friends\' khatma with its code';

  @override
  String get emptyCompletedHint => 'Completed khatmas will appear here';

  @override
  String get notifications => 'Notifications';

  @override
  String get noNotifications => 'No notifications right now';

  @override
  String get partAvailable => 'Free to reserve';

  @override
  String get partReservedForYou => 'Reserved for you';

  @override
  String partReservedBy(String name) {
    return 'Reserved by $name';
  }

  @override
  String get partFinishedByYou => 'You finished it';

  @override
  String partReadBy(String name) {
    return 'Read by $name';
  }

  @override
  String get reserve => 'Reserve';

  @override
  String get cancelReservation => 'Release';

  @override
  String get finishedButton => 'Done';

  @override
  String congratsFinished(String part) {
    return 'May Allah bless you! You finished $part';
  }

  @override
  String get undoFinishTitle => 'Undo finishing';

  @override
  String undoFinishBody(String part) {
    return '\"$part\" will be reserved for you again, and the points you earned for it are removed.';
  }

  @override
  String get deleteKhatmaTitle => 'Delete khatma';

  @override
  String get deleteKhatmaBody =>
      'Are you sure you want to delete this khatma? It will be deleted for every member and cannot be undone.';

  @override
  String get khatmaDeleted => 'Khatma deleted';

  @override
  String get deleteKhatmaError => 'Couldn\'t delete the khatma';

  @override
  String ayahCount(int count, String countText) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countText ayahs',
      one: '1 ayah',
    );
    return '$_temp0';
  }

  @override
  String get tabContent => 'Parts';

  @override
  String get tabParticipants => 'Members';

  @override
  String get tabLog => 'Activity';

  @override
  String participantsOf(int current, int max) {
    return '$current / $max members';
  }

  @override
  String participantsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count members',
      one: '1 member',
    );
    return '$_temp0';
  }

  @override
  String get codeCopied => 'Join code copied';

  @override
  String get joinCode => 'Join code';

  @override
  String get filterAll => 'All';

  @override
  String get filterAvailable => 'Free';

  @override
  String get filterMine => 'Mine';

  @override
  String get filterDone => 'Done';

  @override
  String get emptyAvailable => 'Nothing left to reserve';

  @override
  String get emptyMine =>
      'You haven\'t reserved anything yet, pick a free part';

  @override
  String get emptyDone => 'Nothing finished yet';

  @override
  String get loadParticipantsError => 'Couldn\'t load members';

  @override
  String get creator => 'Creator';

  @override
  String finishedN(int done, String unit) {
    return 'Finished $done $unit';
  }

  @override
  String readingN(int count) {
    return 'Reading $count';
  }

  @override
  String get logReserved => 'reserved';

  @override
  String get logFinished => 'finished reading';

  @override
  String get logReleased => 'released';

  @override
  String get logUndone => 'undid';

  @override
  String get noActivity => 'No activity yet';

  @override
  String get finishedVerb => 'finished';

  @override
  String get khatmaGoneBody =>
      'This khatma seems to have been deleted or is no longer available.';

  @override
  String get activeTab => 'Active';

  @override
  String get completedTab => 'Completed';

  @override
  String get completedOn => 'Completed: ';

  @override
  String get startedOn => 'Started: ';

  @override
  String get navHome => 'Home';

  @override
  String get skip => 'Skip';

  @override
  String get startNow => 'Get started';

  @override
  String get onb1Title => 'Create a new khatma';

  @override
  String get onb1Body =>
      'Start your khatma in seconds: write who it is for, then choose how many members and whether to split it by surah or by juz.';

  @override
  String get onb2Title => 'Follow the progress';

  @override
  String get onb2Body =>
      'Reserve what you will read, mark it done with a tap, and see the progress and who reads what until the khatma is complete.';

  @override
  String get onb3Title => 'All your khatmas in one place';

  @override
  String get onb3Body =>
      'Your active and completed khatmas side by side, updating live whenever a member reads.';

  @override
  String get onb4Title => 'Your friends are with you';

  @override
  String get onb4Body =>
      'Follow your friends and their levels, and compete in goodness on the leaderboard.';

  @override
  String get onb5Title => 'Find people';

  @override
  String get onb5Body =>
      'Search for friends by name and send or accept friend requests to share khatmas together.';

  @override
  String get onb6Title => 'Go ahead, Allah is with you';

  @override
  String get onb6Body =>
      'Get ready for your journey with the Quran. Whether you start a khatma or join one, complete your daily portion by Allah\'s grace.';
}
