// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'Khetmti';

  @override
  String get appName => 'Khetmti';

  @override
  String get cancel => 'Annuler';

  @override
  String get save => 'Enregistrer';

  @override
  String get delete => 'Supprimer';

  @override
  String get remove => 'Retirer';

  @override
  String get undo => 'Revenir';

  @override
  String get ok => 'OK';

  @override
  String get retry => 'Réessayer';

  @override
  String get genericError => 'Une erreur est survenue';

  @override
  String get tryAgainError => 'Une erreur est survenue, veuillez réessayer';

  @override
  String get noData => 'Aucune donnée';

  @override
  String get loadDataError => 'Impossible de charger les données';

  @override
  String get loading => 'Chargement…';

  @override
  String get unknown => 'Inconnu';

  @override
  String get participant => 'un membre';

  @override
  String surahName(String name) {
    return 'Sourate $name';
  }

  @override
  String levelN(String level) {
    return 'Niveau $level';
  }

  @override
  String levelColon(String level) {
    return 'Niveau $level';
  }

  @override
  String levelShort(String level) {
    return 'Niveau $level';
  }

  @override
  String juzN(String n) {
    return 'Juz $n';
  }

  @override
  String get surah => 'sourate';

  @override
  String get juz => 'juz';

  @override
  String get surahs => 'Sourates';

  @override
  String get juzs => 'Juz';

  @override
  String get language => 'Langue';

  @override
  String get invalidEmail => 'Adresse e-mail invalide';

  @override
  String passwordTooShort(int min) {
    return 'Le mot de passe doit contenir au moins $min caractères';
  }

  @override
  String usernameTooShort(int min) {
    return 'Le nom doit contenir au moins $min caractères';
  }

  @override
  String nameTooShort(int min) {
    return 'Le nom doit contenir au moins $min caractères';
  }

  @override
  String minChars(int min) {
    return 'Au moins $min caractères';
  }

  @override
  String get enterPassword => 'Veuillez saisir votre mot de passe';

  @override
  String get fillAllFields => 'Veuillez remplir tous les champs';

  @override
  String get fullName => 'Nom complet';

  @override
  String get fullNameHint => 'Tel que vos amis le verront';

  @override
  String get email => 'E-mail';

  @override
  String get password => 'Mot de passe';

  @override
  String get showPassword => 'Afficher le mot de passe';

  @override
  String get hidePassword => 'Masquer le mot de passe';

  @override
  String get accountCreated => 'Compte créé !';

  @override
  String get signedIn => 'Vous êtes connecté !';

  @override
  String get signedOut => 'Vous êtes déconnecté';

  @override
  String get signOutError =>
      'Impossible de se déconnecter. Veuillez réessayer.';

  @override
  String get wrongCredentials => 'E-mail ou mot de passe incorrect.';

  @override
  String get emailInUse =>
      'Cette adresse e-mail est déjà utilisée par un autre compte.';

  @override
  String get registerTitle => 'Nouveau compte';

  @override
  String get registerSubtitle =>
      'Créez votre compte et terminez le Coran avec vos amis';

  @override
  String get haveAccount => 'Vous avez déjà un compte ?';

  @override
  String get signInLink => 'Se connecter';

  @override
  String get createAccount => 'Créer le compte';

  @override
  String get loginTitle => 'Bon retour';

  @override
  String get loginSubtitle => 'Connectez-vous pour suivre vos khatmas';

  @override
  String get noAccount => 'Pas encore de compte ?';

  @override
  String get createNewAccount => 'Créer un compte';

  @override
  String get forgotPassword => 'Mot de passe oublié ?';

  @override
  String get signIn => 'Se connecter';

  @override
  String get resetLinkSent =>
      'Nous avons envoyé un lien de réinitialisation à votre adresse e-mail';

  @override
  String get resetLinkFailed =>
      'Impossible d\'envoyer le lien, réessayez dans un instant';

  @override
  String get recoverPassword => 'Réinitialiser le mot de passe';

  @override
  String get recoverPasswordBody =>
      'Nous vous enverrons un lien qui ouvre l\'application pour choisir un nouveau mot de passe.';

  @override
  String get sendLink => 'Envoyer le lien';

  @override
  String get passwordsDontMatch => 'Les mots de passe ne correspondent pas';

  @override
  String get passwordChanged => 'Mot de passe modifié';

  @override
  String get linkExpired => 'Ce lien a expiré, demandez-en un nouveau';

  @override
  String get newPasswordTitle => 'Nouveau mot de passe';

  @override
  String get newPasswordSubtitle =>
      'Choisissez un nouveau mot de passe pour votre compte';

  @override
  String get newPassword => 'Nouveau mot de passe';

  @override
  String get confirmPassword => 'Confirmer le mot de passe';

  @override
  String get savePassword => 'Enregistrer le mot de passe';

  @override
  String get settings => 'Paramètres';

  @override
  String get editableSettings => 'Votre compte';

  @override
  String get changeUsername => 'Modifier le nom';

  @override
  String get changeEmail => 'Modifier l\'e-mail';

  @override
  String get changePassword => 'Modifier le mot de passe';

  @override
  String get reminders => 'Rappels';

  @override
  String get appearance => 'Apparence (sombre/clair)';

  @override
  String get signOut => 'Se déconnecter';

  @override
  String get deleteAccount => 'Supprimer le compte';

  @override
  String get supportSection => 'Aide et assistance';

  @override
  String get helpCenter => 'Centre d\'aide';

  @override
  String get aboutKhetmti => 'À propos de Khetmti';

  @override
  String get accountDeleted =>
      'Votre compte a été supprimé. Qu\'Allah accepte de vous.';

  @override
  String get deleteAccountFailed =>
      'Impossible de supprimer le compte, réessayez';

  @override
  String get deleteAccountTitle => 'Supprimer définitivement le compte';

  @override
  String get deleteAccountBody =>
      'Votre compte, vos amis et vos points seront supprimés, et les parties non terminées seront libérées. Les khatmas que vous avez créées passent à leur plus ancien membre, ou sont supprimées si vous êtes seul. Cette action est irréversible.';

  @override
  String get deleteMyAccount => 'Supprimer mon compte';

  @override
  String get usernameChanged => 'Nom modifié';

  @override
  String get sameUsername => 'C\'est déjà votre nom';

  @override
  String get changeNameTitle => 'Modifier le nom';

  @override
  String get changeNameBody =>
      'Vos amis et les membres de vos khatmas voient ce nom.';

  @override
  String get sameEmail => 'C\'est déjà votre e-mail';

  @override
  String get emailConfirmSent =>
      'Nous avons envoyé un lien de confirmation, ouvrez-le pour terminer le changement d\'e-mail';

  @override
  String get changeEmailError => 'Impossible de modifier l\'e-mail';

  @override
  String get changeEmailTitle => 'Modifier l\'e-mail';

  @override
  String changeEmailBody(String current) {
    return 'Votre e-mail actuel : $current\nNous enverrons un lien de confirmation ; l\'e-mail de connexion change une fois le lien ouvert.';
  }

  @override
  String get sendConfirmLink => 'Envoyer le lien de confirmation';

  @override
  String get newEmail => 'Nouvel e-mail';

  @override
  String get samePassword =>
      'Le nouveau mot de passe est identique à l\'ancien';

  @override
  String get wrongCurrentPassword => 'Le mot de passe actuel est incorrect';

  @override
  String get currentPassword => 'Mot de passe actuel';

  @override
  String get supportEmailSubject => 'Support de l\'application Khetmti';

  @override
  String get helpTitle => 'Aide et assistance';

  @override
  String get contactUs => 'Nous contacter';

  @override
  String get byEmail => 'Par e-mail';

  @override
  String get faq => 'Questions fréquentes';

  @override
  String get faqCreateQ => 'Comment créer une nouvelle khatma ?';

  @override
  String get faqCreateA =>
      'Depuis l\'accueil, appuyez sur le bouton « + », puis choisissez le découpage (par juz ou par sourate) et le nombre de membres.';

  @override
  String get faqJoinQ => 'Comment rejoindre une khatma existante ?';

  @override
  String get faqJoinA =>
      'Demandez le code à son créateur, puis choisissez « Rejoindre une khatma » sur l\'accueil et saisissez le code.';

  @override
  String get faqReserveQ => 'Comment réserver une partie à lire ?';

  @override
  String get faqReserveA =>
      'Ouvrez la khatma pour voir ses juz ou sourates, puis appuyez sur Réserver à côté d’une partie libre pour la prendre.';

  @override
  String get faqReadQ => 'Puis-je lire le Coran dans l\'application ?';

  @override
  String get faqReadA =>
      'Oui ! Ouvrez une sourate ou un juz depuis une khatma ou votre profil, et l\'application ouvre le mushaf directement.';

  @override
  String get faqOfflineQ => 'Puis-je lire hors ligne ?';

  @override
  String get faqOfflineA =>
      'L\'application a besoin d\'une connexion la première fois qu\'une page s\'ouvre ; la lecture hors ligne arrive bientôt.';

  @override
  String get faqStatsQ => 'Comment voir mes statistiques de lecture ?';

  @override
  String get faqStatsA =>
      'Sur votre profil (Compte), l\'onglet « Statistiques » indique combien de juz et de sourates vous avez lus.';

  @override
  String get aboutTitle => 'À propos de l\'application';

  @override
  String get aboutAppName => 'Khetmti (ختمتي)';

  @override
  String get aboutBody =>
      'Khetmti a été créée pour faciliter la lecture du Saint Coran et organiser des khatmas en groupe ou en solo. Qu\'Allah accepte nos bonnes œuvres et les vôtres, et en fasse une aumône continue (sadaqa jariya).';

  @override
  String get developer => 'Développeur';

  @override
  String get developerName => 'Louay Barraq';

  @override
  String get developerRole => 'Développeur d\'applications mobiles';

  @override
  String get saveProgress => 'Enregistrer votre progression';

  @override
  String get saveProgressBody =>
      'Appuyez sur un verset pour l\'enregistrer comme point d\'arrêt. La prochaine fois que vous ouvrirez cette partie depuis la khatma, l\'application y retournera directement.';

  @override
  String get fetchError => 'Désolé, impossible de charger le texte';

  @override
  String get findFriend => 'Trouver un ami';

  @override
  String get searchError => 'La recherche a échoué';

  @override
  String get searchStart => 'Commencez par chercher le nom de votre ami';

  @override
  String get noPersonFound => 'Personne ne porte ce nom';

  @override
  String get searchUsernameHint => 'Rechercher un nom…';

  @override
  String get requestSent => 'Demande d\'ami envoyée !';

  @override
  String get requestExists => 'Une demande existe déjà entre vous';

  @override
  String get sendRequestError => 'Impossible d\'envoyer la demande';

  @override
  String get requestCancelled => 'Demande d\'ami annulée';

  @override
  String get cancelRequestError => 'Impossible d\'annuler la demande';

  @override
  String get requestAccepted => 'Demande d\'ami acceptée';

  @override
  String get acceptError => 'Impossible d\'accepter la demande';

  @override
  String get requestDeclined => 'Demande d\'ami refusée';

  @override
  String get declineError => 'Impossible de refuser la demande';

  @override
  String get removeFriendError => 'Impossible de retirer cet ami';

  @override
  String get friendRequests => 'Demandes d\'ami';

  @override
  String get loadRequestsError => 'Impossible de charger les demandes';

  @override
  String get decline => 'Refuser';

  @override
  String get accept => 'Accepter';

  @override
  String get noRequests => 'Aucune demande d\'ami pour le moment';

  @override
  String get friendsBadge => 'Amis';

  @override
  String get cancelRequest => 'Annuler la demande';

  @override
  String get add => 'Ajouter';

  @override
  String get onlineNow => 'En ligne';

  @override
  String minutesAgo(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: 'il y a $n minutes',
      one: 'il y a 1 minute',
    );
    return '$_temp0';
  }

  @override
  String hoursAgo(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: 'il y a $n heures',
      one: 'il y a 1 heure',
    );
    return '$_temp0';
  }

  @override
  String daysAgo(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: 'il y a $n jours',
      one: 'il y a 1 jour',
    );
    return '$_temp0';
  }

  @override
  String lastSeen(String when) {
    return 'Vu : $when';
  }

  @override
  String get leaderboard => 'Classement';

  @override
  String get today => 'Aujourd\'hui';

  @override
  String get thisWeek => 'Semaine';

  @override
  String get allTime => 'Tout';

  @override
  String get global => 'Mondial';

  @override
  String get friends => 'Amis';

  @override
  String get me => 'Moi';

  @override
  String get unfriendTitle => 'Retirer cet ami';

  @override
  String get unfriendBody => 'Voulez-vous vraiment retirer cet ami ?';

  @override
  String get quranOrder => 'Ordre du Coran';

  @override
  String get juzOrder => 'Ordre des juz';

  @override
  String get mostRead => 'Les plus lus';

  @override
  String get leastRead => 'Les moins lus';

  @override
  String get friendsList => 'Liste d\'amis';

  @override
  String get activeKhatmas => 'Vos khatmas en cours';

  @override
  String get completedKhatmas => 'Vos khatmas terminées';

  @override
  String get surahStats => 'Statistiques des sourates';

  @override
  String get juzStats => 'Statistiques des juz';

  @override
  String get addFriend => 'Ajouter un ami';

  @override
  String get loadFriendsError => 'Impossible de charger les amis';

  @override
  String get noFriends => 'Vous n\'avez pas encore d\'amis';

  @override
  String get loadKhatmasError => 'Impossible de charger les khatmas';

  @override
  String get noActiveKhatmas => 'Aucune khatma en cours';

  @override
  String get noStats => 'Pas encore de statistiques';

  @override
  String timesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count fois',
      one: '1 fois',
    );
    return '$_temp0';
  }

  @override
  String get account => 'Compte';

  @override
  String get active => 'Actif';

  @override
  String get rankStudent => 'Étudiant';

  @override
  String get rankReader => 'Lecteur';

  @override
  String get rankReciter => 'Récitant';

  @override
  String get rankMujawwid => 'Mujawwid';

  @override
  String get rankHafiz => 'Hafiz';

  @override
  String get rankMaster => 'Maître';

  @override
  String get rankFaqih => 'Faqih';

  @override
  String get rankScholar => 'Savant';

  @override
  String get rankImam => 'Imam';

  @override
  String get yourFriends => 'Amis';

  @override
  String get yourKhatmas => 'Khatmas';

  @override
  String get stats => 'Statistiques';

  @override
  String get mustSignIn => 'Veuillez d\'abord vous connecter';

  @override
  String get khatmaNotFound => 'Khatma introuvable';

  @override
  String get alreadyJoined => 'Vous avez déjà rejoint cette khatma';

  @override
  String get khatmaFull => 'Désolé, cette khatma est complète';

  @override
  String get mustJoinFirst => 'Rejoignez d\'abord la khatma';

  @override
  String get partUnavailable => 'Cette partie n\'est plus disponible';

  @override
  String get menu => 'Menu';

  @override
  String get khatmas => 'Khatmas';

  @override
  String get createNewKhatma => 'Créer une nouvelle khatma';

  @override
  String get createNewKhatmaDesc =>
      'Commencez un nouveau parcours de récitation et partagez-le avec vos proches';

  @override
  String get joinExisting => 'Rejoindre une khatma existante';

  @override
  String get joinExistingDesc =>
      'Trouvez des groupes de récitation et rejoignez-les';

  @override
  String get searchPerson => 'Trouver quelqu’un';

  @override
  String get searchPersonDesc =>
      'Retrouvez vos amis et suivez leur progression';

  @override
  String get friendRequestsDesc => 'Voyez qui veut devenir votre ami';

  @override
  String get tipTitle => 'Un conseil ?';

  @override
  String get tipBody =>
      'Lire deux pages par jour vous aide à terminer le Coran en un an.';

  @override
  String get khatmaForRequired => 'Indiquez pour qui est cette khatma';

  @override
  String get khatmaCreated => 'Khatma créée';

  @override
  String get createKhatmaError => 'Impossible de créer la khatma';

  @override
  String get createKhatmaTitle => 'Créer une khatma';

  @override
  String get khatmaFor => 'Khatma pour';

  @override
  String get khatmaForHint => 'ex. : mon grand-père, paix à son âme';

  @override
  String get createKhatmaButton => 'Créer la khatma';

  @override
  String get maxParticipants => 'Nombre maximum de membres';

  @override
  String get includingYou => 'Vous compris';

  @override
  String get splitKhatma => 'Découpage de la khatma';

  @override
  String get splitKhatmaDesc => 'Chaque membre réserve ce qu’il va lire';

  @override
  String get bySurah => 'Par sourate';

  @override
  String get surahCount => '114 sourates';

  @override
  String get byJuz => 'Par juz';

  @override
  String get juzCount => '30 juz';

  @override
  String get wrongCode => 'Code incorrect, ou la khatma n\'existe plus';

  @override
  String get joined => 'Vous avez rejoint la khatma !';

  @override
  String get enter5Digits => 'Veuillez saisir un code à 5 chiffres';

  @override
  String get joinKhatmaTitle => 'Rejoindre une khatma';

  @override
  String get byCode => 'Par code';

  @override
  String get byName => 'Par nom';

  @override
  String get enterJoinCode => 'Saisissez le code';

  @override
  String get joinCodeHelp =>
      'Un code à 5 chiffres visible par tout membre sur la page de la khatma';

  @override
  String get joinNow => 'Rejoindre';

  @override
  String get khatmaName => 'Nom de la khatma';

  @override
  String get noKhatmaByName => 'Aucune khatma à ce nom';

  @override
  String khatmaForName(String name) {
    return 'Khatma pour $name';
  }

  @override
  String khatmaSearchMeta(int current, int max, String unit, int percent) {
    return '$current/$max membres · $unit · $percent %';
  }

  @override
  String get full => 'Complète';

  @override
  String get join => 'Rejoindre';

  @override
  String get loadKhatmasHomeError =>
      'Impossible de charger les khatmas, vérifiez votre connexion';

  @override
  String get noCompletedYet => 'Aucune khatma terminée pour le moment';

  @override
  String get emptyActiveHint =>
      'Créez une khatma ou rejoignez celle de vos amis avec son code';

  @override
  String get emptyCompletedHint => 'Les khatmas terminées apparaîtront ici';

  @override
  String get notifications => 'Notifications';

  @override
  String get noNotifications => 'Aucune notification pour le moment';

  @override
  String get partAvailable => 'Libre';

  @override
  String get partReservedForYou => 'Réservée pour vous';

  @override
  String partReservedBy(String name) {
    return 'Réservée par $name';
  }

  @override
  String get partFinishedByYou => 'Vous l\'avez terminée';

  @override
  String partReadBy(String name) {
    return 'Lue par $name';
  }

  @override
  String get reserve => 'Réserver';

  @override
  String get cancelReservation => 'Libérer';

  @override
  String get finishedButton => 'Terminé';

  @override
  String congratsFinished(String part) {
    return 'Qu\'Allah vous bénisse ! Vous avez terminé $part';
  }

  @override
  String get undoFinishTitle => 'Annuler la validation';

  @override
  String undoFinishBody(String part) {
    return '« $part » vous sera de nouveau réservée, et les points gagnés seront retirés.';
  }

  @override
  String get deleteKhatmaTitle => 'Supprimer la khatma';

  @override
  String get deleteKhatmaBody =>
      'Voulez-vous vraiment supprimer cette khatma ? Elle sera supprimée pour tous les membres, sans retour possible.';

  @override
  String get khatmaDeleted => 'Khatma supprimée';

  @override
  String get deleteKhatmaError => 'Impossible de supprimer la khatma';

  @override
  String ayahCount(int count, String countText) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countText versets',
      one: '1 verset',
    );
    return '$_temp0';
  }

  @override
  String get tabContent => 'Parties';

  @override
  String get tabParticipants => 'Membres';

  @override
  String get tabLog => 'Activité';

  @override
  String participantsOf(int current, int max) {
    return '$current / $max membres';
  }

  @override
  String participantsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count membres',
      one: '1 membre',
    );
    return '$_temp0';
  }

  @override
  String get codeCopied => 'Code copié';

  @override
  String get joinCode => 'Code pour rejoindre';

  @override
  String get filterAll => 'Tout';

  @override
  String get filterAvailable => 'Libres';

  @override
  String get filterMine => 'Les miennes';

  @override
  String get filterDone => 'Terminées';

  @override
  String get emptyAvailable => 'Plus rien à réserver';

  @override
  String get emptyMine =>
      'Vous n\'avez encore rien réservé, choisissez une partie libre';

  @override
  String get emptyDone => 'Rien de terminé pour le moment';

  @override
  String get loadParticipantsError => 'Impossible de charger les membres';

  @override
  String get creator => 'Créateur';

  @override
  String finishedN(int done, String unit) {
    return 'A terminé $done $unit';
  }

  @override
  String readingN(int count) {
    return 'En lit $count';
  }

  @override
  String get logReserved => 'a réservé';

  @override
  String get logFinished => 'a terminé la lecture de';

  @override
  String get logReleased => 'a libéré';

  @override
  String get logUndone => 'a annulé';

  @override
  String get noActivity => 'Pas encore d\'activité';

  @override
  String get finishedVerb => 'a terminé';

  @override
  String get khatmaGoneBody =>
      'Cette khatma semble avoir été supprimée ou n’est plus disponible.';

  @override
  String get activeTab => 'En cours';

  @override
  String get completedTab => 'Terminées';

  @override
  String get completedOn => 'Terminée le : ';

  @override
  String get startedOn => 'Commencée le : ';

  @override
  String get navHome => 'Accueil';

  @override
  String get skip => 'Passer';

  @override
  String get startNow => 'Commencer';

  @override
  String get onb1Title => 'Créez une nouvelle khatma';

  @override
  String get onb1Body =>
      'Lancez votre khatma facilement : indiquez pour qui elle est, le nombre de membres et le découpage par sourate ou par juz.';

  @override
  String get onb2Title => 'Suivez la progression';

  @override
  String get onb2Body =>
      'Réservez ce que vous lirez, validez-le d\'un geste, et suivez l\'avancement et qui lit quoi jusqu\'à la fin de la khatma.';

  @override
  String get onb3Title => 'Toutes vos khatmas au même endroit';

  @override
  String get onb3Body =>
      'Vos khatmas en cours et terminées sous vos yeux, mises à jour en direct dès qu\'un membre lit.';

  @override
  String get onb4Title => 'Vos amis avec vous';

  @override
  String get onb4Body =>
      'Suivez vos amis et leurs niveaux, et rivalisez dans le bien au classement.';

  @override
  String get onb5Title => 'Trouvez des personnes';

  @override
  String get onb5Body =>
      'Cherchez vos amis par leur nom, envoyez ou acceptez des demandes d\'ami pour partager vos khatmas.';

  @override
  String get onb6Title => 'Lancez-vous, qu\'Allah vous aide';

  @override
  String get onb6Body =>
      'Préparez-vous à votre voyage avec le Coran. Que vous lanciez une khatma ou en rejoigniez une, accomplissez votre wird par la grâce d\'Allah.';
}
