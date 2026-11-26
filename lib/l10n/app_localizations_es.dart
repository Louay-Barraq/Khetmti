// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'Khetmti';

  @override
  String get appName => 'Khetmti';

  @override
  String get cancel => 'Cancelar';

  @override
  String get save => 'Guardar';

  @override
  String get delete => 'Eliminar';

  @override
  String get remove => 'Quitar';

  @override
  String get undo => 'Deshacer';

  @override
  String get ok => 'Aceptar';

  @override
  String get retry => 'Reintentar';

  @override
  String get genericError => 'Algo salió mal';

  @override
  String get tryAgainError => 'Algo salió mal, inténtalo de nuevo';

  @override
  String get noData => 'Sin datos';

  @override
  String get loadDataError => 'No se pudieron cargar los datos';

  @override
  String get loading => 'Cargando…';

  @override
  String get unknown => 'Desconocido';

  @override
  String get participant => 'un miembro';

  @override
  String surahName(String name) {
    return 'Sura $name';
  }

  @override
  String levelN(String level) {
    return 'Nivel $level';
  }

  @override
  String levelColon(String level) {
    return 'Nivel $level';
  }

  @override
  String levelShort(String level) {
    return 'Nivel $level';
  }

  @override
  String juzN(String n) {
    return 'Yuz $n';
  }

  @override
  String get surah => 'sura';

  @override
  String get juz => 'yuz';

  @override
  String get surahs => 'Suras';

  @override
  String get juzs => 'Yuz';

  @override
  String get language => 'Idioma';

  @override
  String get invalidEmail => 'Correo electrónico no válido';

  @override
  String passwordTooShort(int min) {
    return 'La contraseña debe tener al menos $min caracteres';
  }

  @override
  String usernameTooShort(int min) {
    return 'El nombre debe tener al menos $min caracteres';
  }

  @override
  String nameTooShort(int min) {
    return 'El nombre debe tener al menos $min caracteres';
  }

  @override
  String minChars(int min) {
    return 'Al menos $min caracteres';
  }

  @override
  String get enterPassword => 'Introduce tu contraseña';

  @override
  String get fillAllFields => 'Rellena todos los campos';

  @override
  String get fullName => 'Nombre completo';

  @override
  String get fullNameHint => 'Como lo verán tus amigos';

  @override
  String get email => 'Correo electrónico';

  @override
  String get password => 'Contraseña';

  @override
  String get showPassword => 'Mostrar contraseña';

  @override
  String get hidePassword => 'Ocultar contraseña';

  @override
  String get accountCreated => '¡Cuenta creada!';

  @override
  String get signedIn => '¡Sesión iniciada!';

  @override
  String get signedOut => 'Sesión cerrada';

  @override
  String get signOutError => 'No se pudo cerrar la sesión. Inténtalo de nuevo.';

  @override
  String get wrongCredentials => 'Correo o contraseña incorrectos.';

  @override
  String get emailInUse => 'Este correo ya lo usa otra cuenta.';

  @override
  String get registerTitle => 'Cuenta nueva';

  @override
  String get registerSubtitle =>
      'Crea tu cuenta y completa el Corán con tus amigos';

  @override
  String get haveAccount => '¿Ya tienes cuenta?';

  @override
  String get signInLink => 'Inicia sesión';

  @override
  String get createAccount => 'Crear cuenta';

  @override
  String get loginTitle => 'Bienvenido de nuevo';

  @override
  String get loginSubtitle => 'Inicia sesión para seguir tus khatmas';

  @override
  String get noAccount => '¿No tienes cuenta?';

  @override
  String get createNewAccount => 'Crea una';

  @override
  String get forgotPassword => '¿Olvidaste tu contraseña?';

  @override
  String get signIn => 'Iniciar sesión';

  @override
  String get resetLinkSent =>
      'Te enviamos un enlace para restablecer tu contraseña';

  @override
  String get resetLinkFailed =>
      'No se pudo enviar el enlace, inténtalo en un momento';

  @override
  String get recoverPassword => 'Restablecer contraseña';

  @override
  String get recoverPasswordBody =>
      'Te enviaremos un enlace que abre la app para que elijas una nueva contraseña.';

  @override
  String get sendLink => 'Enviar enlace';

  @override
  String get passwordsDontMatch => 'Las contraseñas no coinciden';

  @override
  String get passwordChanged => 'Contraseña cambiada';

  @override
  String get linkExpired => 'El enlace ha caducado, solicita uno nuevo';

  @override
  String get newPasswordTitle => 'Nueva contraseña';

  @override
  String get newPasswordSubtitle => 'Elige una nueva contraseña para tu cuenta';

  @override
  String get newPassword => 'Nueva contraseña';

  @override
  String get confirmPassword => 'Confirmar contraseña';

  @override
  String get savePassword => 'Guardar contraseña';

  @override
  String get settings => 'Ajustes';

  @override
  String get editableSettings => 'Tu cuenta';

  @override
  String get changeUsername => 'Cambiar nombre';

  @override
  String get changeEmail => 'Cambiar correo';

  @override
  String get changePassword => 'Cambiar contraseña';

  @override
  String get reminders => 'Recordatorios';

  @override
  String get appearance => 'Apariencia (oscuro/claro)';

  @override
  String get signOut => 'Cerrar sesión';

  @override
  String get deleteAccount => 'Eliminar cuenta';

  @override
  String get supportSection => 'Ayuda y soporte';

  @override
  String get helpCenter => 'Centro de ayuda';

  @override
  String get aboutKhetmti => 'Acerca de Khetmti';

  @override
  String get accountDeleted =>
      'Tu cuenta se ha eliminado. Que Allah te lo acepte.';

  @override
  String get deleteAccountFailed =>
      'No se pudo eliminar la cuenta, inténtalo de nuevo';

  @override
  String get deleteAccountTitle => 'Eliminar la cuenta definitivamente';

  @override
  String get deleteAccountBody =>
      'Se eliminarán tu cuenta, tus amigos y tus puntos, y se liberarán las partes que no hayas terminado. Las khatmas que creaste pasan a su miembro más antiguo, o se eliminan si eres el único. No se puede deshacer.';

  @override
  String get deleteMyAccount => 'Eliminar mi cuenta';

  @override
  String get usernameChanged => 'Nombre cambiado';

  @override
  String get sameUsername => 'Ese ya es tu nombre';

  @override
  String get changeNameTitle => 'Cambiar nombre';

  @override
  String get changeNameBody =>
      'Tus amigos y los miembros de tus khatmas ven este nombre.';

  @override
  String get sameEmail => 'Ese ya es tu correo';

  @override
  String get emailConfirmSent =>
      'Te enviamos un enlace de confirmación, ábrelo para terminar el cambio de correo';

  @override
  String get changeEmailError => 'No se pudo cambiar el correo';

  @override
  String get changeEmailTitle => 'Cambiar correo';

  @override
  String changeEmailBody(String current) {
    return 'Tu correo actual: $current\nTe enviaremos un enlace de confirmación; el correo de acceso cambia al abrirlo.';
  }

  @override
  String get sendConfirmLink => 'Enviar enlace de confirmación';

  @override
  String get newEmail => 'Nuevo correo';

  @override
  String get samePassword => 'La nueva contraseña es igual a la anterior';

  @override
  String get wrongCurrentPassword => 'La contraseña actual es incorrecta';

  @override
  String get currentPassword => 'Contraseña actual';

  @override
  String get supportEmailSubject => 'Soporte de la app Khetmti';

  @override
  String get helpTitle => 'Ayuda y soporte';

  @override
  String get contactUs => 'Contáctanos';

  @override
  String get byEmail => 'Por correo';

  @override
  String get faq => 'Preguntas frecuentes';

  @override
  String get faqCreateQ => '¿Cómo creo una nueva khatma?';

  @override
  String get faqCreateA =>
      'Desde el inicio, toca el botón «+» y elige cómo dividirla (por yuz o por sura) y cuántos miembros pueden unirse.';

  @override
  String get faqJoinQ => '¿Cómo me uno a una khatma existente?';

  @override
  String get faqJoinA =>
      'Pide el código a quien la creó, elige «Unirse a una khatma» en el inicio e introduce el código.';

  @override
  String get faqReserveQ => '¿Cómo reservo una parte para leer?';

  @override
  String get faqReserveA =>
      'Abre la khatma para ver sus yuz o suras y toca Reservar junto a una parte libre para quedártela.';

  @override
  String get faqReadQ => '¿Puedo leer el Corán dentro de la app?';

  @override
  String get faqReadA =>
      '¡Sí! Abre cualquier sura o yuz desde una khatma o tu perfil y la app abre el mushaf al instante.';

  @override
  String get faqOfflineQ => '¿Puedo leer sin conexión?';

  @override
  String get faqOfflineA =>
      'La app necesita conexión la primera vez que abres una página; la lectura sin conexión llegará pronto.';

  @override
  String get faqStatsQ => '¿Cómo veo mis estadísticas de lectura?';

  @override
  String get faqStatsA =>
      'En tu perfil (Cuenta), la pestaña «Estadísticas» muestra cuántos yuz y suras has leído.';

  @override
  String get aboutTitle => 'Acerca de la app';

  @override
  String get aboutAppName => 'Khetmti (ختمتي)';

  @override
  String get aboutBody =>
      'Khetmti se creó para facilitar la lectura del Sagrado Corán y organizar khatmas en grupo o individuales. Que Allah acepte nuestras buenas obras y las vuestras, y lo haga una caridad continua (sadaqa yariya).';

  @override
  String get developer => 'Desarrollador';

  @override
  String get developerName => 'Louay Barraq';

  @override
  String get developerRole => 'Desarrollador de apps móviles';

  @override
  String get saveProgress => 'Guardar tu progreso';

  @override
  String get saveProgressBody =>
      'Toca una aleya para guardarla como punto de parada. La próxima vez que abras esta parte desde la khatma, la app irá directamente a ella.';

  @override
  String get fetchError => 'Lo sentimos, no se pudo cargar el texto';

  @override
  String get findFriend => 'Buscar un amigo';

  @override
  String get searchError => 'La búsqueda falló';

  @override
  String get searchStart => 'Empieza buscando el nombre de tu amigo';

  @override
  String get noPersonFound => 'No hay nadie con ese nombre';

  @override
  String get searchUsernameHint => 'Buscar por nombre…';

  @override
  String get requestSent => '¡Solicitud de amistad enviada!';

  @override
  String get requestExists => 'Ya hay una solicitud entre vosotros';

  @override
  String get sendRequestError => 'No se pudo enviar la solicitud';

  @override
  String get requestCancelled => 'Solicitud de amistad cancelada';

  @override
  String get cancelRequestError => 'No se pudo cancelar la solicitud';

  @override
  String get requestAccepted => 'Solicitud de amistad aceptada';

  @override
  String get acceptError => 'No se pudo aceptar la solicitud';

  @override
  String get requestDeclined => 'Solicitud de amistad rechazada';

  @override
  String get declineError => 'No se pudo rechazar la solicitud';

  @override
  String get removeFriendError => 'No se pudo eliminar a este amigo';

  @override
  String get friendRequests => 'Solicitudes de amistad';

  @override
  String get loadRequestsError => 'No se pudieron cargar las solicitudes';

  @override
  String get decline => 'Rechazar';

  @override
  String get accept => 'Aceptar';

  @override
  String get noRequests => 'No hay solicitudes de amistad por ahora';

  @override
  String get friendsBadge => 'Amigos';

  @override
  String get cancelRequest => 'Cancelar solicitud';

  @override
  String get add => 'Añadir';

  @override
  String get onlineNow => 'En línea';

  @override
  String minutesAgo(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: 'hace $n minutos',
      one: 'hace 1 minuto',
    );
    return '$_temp0';
  }

  @override
  String hoursAgo(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: 'hace $n horas',
      one: 'hace 1 hora',
    );
    return '$_temp0';
  }

  @override
  String daysAgo(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: 'hace $n días',
      one: 'hace 1 día',
    );
    return '$_temp0';
  }

  @override
  String lastSeen(String when) {
    return 'Última vez: $when';
  }

  @override
  String get leaderboard => 'Clasificación';

  @override
  String get today => 'Hoy';

  @override
  String get thisWeek => 'Semana';

  @override
  String get allTime => 'Todo';

  @override
  String get global => 'Global';

  @override
  String get friends => 'Amigos';

  @override
  String get me => 'Yo';

  @override
  String get unfriendTitle => 'Eliminar amigo';

  @override
  String get unfriendBody => '¿Seguro que quieres eliminar a este amigo?';

  @override
  String get quranOrder => 'Orden del Corán';

  @override
  String get juzOrder => 'Orden de los yuz';

  @override
  String get mostRead => 'Más leídos';

  @override
  String get leastRead => 'Menos leídos';

  @override
  String get friendsList => 'Lista de amigos';

  @override
  String get activeKhatmas => 'Tus khatmas activas';

  @override
  String get completedKhatmas => 'Tus khatmas completadas';

  @override
  String get surahStats => 'Estadísticas de suras';

  @override
  String get juzStats => 'Estadísticas de yuz';

  @override
  String get addFriend => 'Añadir amigo';

  @override
  String get loadFriendsError => 'No se pudieron cargar los amigos';

  @override
  String get noFriends => 'Aún no tienes amigos';

  @override
  String get loadKhatmasError => 'No se pudieron cargar las khatmas';

  @override
  String get noActiveKhatmas => 'No hay khatmas activas';

  @override
  String get noStats => 'Aún no hay estadísticas';

  @override
  String timesCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count veces',
      one: '1 vez',
    );
    return '$_temp0';
  }

  @override
  String get account => 'Cuenta';

  @override
  String get active => 'Activo';

  @override
  String get rankStudent => 'Estudiante';

  @override
  String get rankReader => 'Lector';

  @override
  String get rankReciter => 'Recitador';

  @override
  String get rankMujawwid => 'Mujawwid';

  @override
  String get rankHafiz => 'Hafiz';

  @override
  String get rankMaster => 'Maestro';

  @override
  String get rankFaqih => 'Faqih';

  @override
  String get rankScholar => 'Sabio';

  @override
  String get rankImam => 'Imán';

  @override
  String get yourFriends => 'Amigos';

  @override
  String get yourKhatmas => 'Khatmas';

  @override
  String get stats => 'Estadísticas';

  @override
  String get mustSignIn => 'Primero inicia sesión';

  @override
  String get khatmaNotFound => 'Khatma no encontrada';

  @override
  String get alreadyJoined => 'Ya te has unido a esta khatma';

  @override
  String get khatmaFull => 'Lo sentimos, esta khatma está completa';

  @override
  String get mustJoinFirst => 'Primero únete a la khatma';

  @override
  String get partUnavailable => 'Esta parte ya no está disponible';

  @override
  String get menu => 'Menú';

  @override
  String get khatmas => 'Khatmas';

  @override
  String get createNewKhatma => 'Crear una nueva khatma';

  @override
  String get createNewKhatmaDesc =>
      'Empieza un nuevo camino de recitación y compártelo con tus seres queridos';

  @override
  String get joinExisting => 'Unirse a una khatma existente';

  @override
  String get joinExistingDesc => 'Encuentra grupos de recitación y únete';

  @override
  String get searchPerson => 'Buscar a alguien';

  @override
  String get searchPersonDesc => 'Conecta con tus amigos y sigue su progreso';

  @override
  String get friendRequestsDesc => 'Mira quién quiere ser tu amigo';

  @override
  String get tipTitle => '¿Un consejo?';

  @override
  String get tipBody =>
      'Leer dos páginas al día te ayuda a completar el Corán en un año.';

  @override
  String get khatmaForRequired => 'Escribe para quién es esta khatma';

  @override
  String get khatmaCreated => 'Khatma creada';

  @override
  String get createKhatmaError => 'No se pudo crear la khatma';

  @override
  String get createKhatmaTitle => 'Crear una khatma';

  @override
  String get khatmaFor => 'Khatma por';

  @override
  String get khatmaForHint => 'p. ej.: mi difunto abuelo';

  @override
  String get createKhatmaButton => 'Crear khatma';

  @override
  String get maxParticipants => 'Máximo de miembros';

  @override
  String get includingYou => 'Incluyéndote';

  @override
  String get splitKhatma => 'Dividir la khatma';

  @override
  String get splitKhatmaDesc => 'Cada miembro reserva lo que leerá';

  @override
  String get bySurah => 'Por sura';

  @override
  String get surahCount => '114 suras';

  @override
  String get byJuz => 'Por yuz';

  @override
  String get juzCount => '30 yuz';

  @override
  String get wrongCode => 'Código incorrecto o la khatma ya no existe';

  @override
  String get joined => '¡Te has unido!';

  @override
  String get enter5Digits => 'Introduce un código de 5 dígitos';

  @override
  String get joinKhatmaTitle => 'Unirse a una khatma';

  @override
  String get byCode => 'Por código';

  @override
  String get byName => 'Por nombre';

  @override
  String get enterJoinCode => 'Introduce el código';

  @override
  String get joinCodeHelp =>
      'Un código de 5 dígitos que cualquier miembro ve en la página de la khatma';

  @override
  String get joinNow => 'Unirme ahora';

  @override
  String get khatmaName => 'Nombre de la khatma';

  @override
  String get noKhatmaByName => 'No hay ninguna khatma con ese nombre';

  @override
  String khatmaForName(String name) {
    return 'Khatma por $name';
  }

  @override
  String khatmaSearchMeta(int current, int max, String unit, int percent) {
    return '$current/$max miembros · $unit · $percent %';
  }

  @override
  String get full => 'Completa';

  @override
  String get join => 'Unirse';

  @override
  String get loadKhatmasHomeError =>
      'No se pudieron cargar las khatmas, revisa tu conexión';

  @override
  String get noCompletedYet => 'Aún no hay khatmas completadas';

  @override
  String get emptyActiveHint =>
      'Crea una khatma o únete a la de tus amigos con su código';

  @override
  String get emptyCompletedHint => 'Las khatmas completadas aparecerán aquí';

  @override
  String get notifications => 'Notificaciones';

  @override
  String get noNotifications => 'No hay notificaciones por ahora';

  @override
  String get partAvailable => 'Libre para reservar';

  @override
  String get partReservedForYou => 'Reservada para ti';

  @override
  String partReservedBy(String name) {
    return 'Reservada por $name';
  }

  @override
  String get partFinishedByYou => 'La terminaste';

  @override
  String partReadBy(String name) {
    return 'Leída por $name';
  }

  @override
  String get reserve => 'Reservar';

  @override
  String get cancelReservation => 'Liberar';

  @override
  String get finishedButton => 'Hecho';

  @override
  String congratsFinished(String part) {
    return '¡Que Allah te bendiga! Terminaste $part';
  }

  @override
  String get undoFinishTitle => 'Deshacer terminado';

  @override
  String undoFinishBody(String part) {
    return '«$part» volverá a estar reservada para ti y se restarán los puntos que ganaste.';
  }

  @override
  String get deleteKhatmaTitle => 'Eliminar khatma';

  @override
  String get deleteKhatmaBody =>
      '¿Seguro que quieres eliminar esta khatma? Se eliminará para todos los miembros y no se puede deshacer.';

  @override
  String get khatmaDeleted => 'Khatma eliminada';

  @override
  String get deleteKhatmaError => 'No se pudo eliminar la khatma';

  @override
  String ayahCount(int count, String countText) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$countText aleyas',
      one: '1 aleya',
    );
    return '$_temp0';
  }

  @override
  String get tabContent => 'Partes';

  @override
  String get tabParticipants => 'Miembros';

  @override
  String get tabLog => 'Actividad';

  @override
  String participantsOf(int current, int max) {
    return '$current / $max miembros';
  }

  @override
  String participantsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count miembros',
      one: '1 miembro',
    );
    return '$_temp0';
  }

  @override
  String get codeCopied => 'Código copiado';

  @override
  String get joinCode => 'Código para unirse';

  @override
  String get filterAll => 'Todo';

  @override
  String get filterAvailable => 'Libres';

  @override
  String get filterMine => 'Mías';

  @override
  String get filterDone => 'Terminadas';

  @override
  String get emptyAvailable => 'No queda nada por reservar';

  @override
  String get emptyMine => 'Aún no has reservado nada, elige una parte libre';

  @override
  String get emptyDone => 'Aún no se ha terminado nada';

  @override
  String get loadParticipantsError => 'No se pudieron cargar los miembros';

  @override
  String get creator => 'Creador';

  @override
  String finishedN(int done, String unit) {
    return 'Terminó $done $unit';
  }

  @override
  String readingN(int count) {
    return 'Leyendo $count';
  }

  @override
  String get logReserved => 'reservó';

  @override
  String get logFinished => 'terminó de leer';

  @override
  String get logReleased => 'liberó';

  @override
  String get logUndone => 'deshizo';

  @override
  String get noActivity => 'Aún no hay actividad';

  @override
  String get finishedVerb => 'terminó';

  @override
  String get khatmaGoneBody =>
      'Parece que esta khatma se eliminó o ya no está disponible.';

  @override
  String get activeTab => 'Activas';

  @override
  String get completedTab => 'Completadas';

  @override
  String get completedOn => 'Completada: ';

  @override
  String get startedOn => 'Iniciada: ';

  @override
  String get navHome => 'Inicio';

  @override
  String get skip => 'Omitir';

  @override
  String get startNow => 'Empezar';

  @override
  String get onb1Title => 'Crea una nueva khatma';

  @override
  String get onb1Body =>
      'Empieza tu khatma fácilmente: escribe para quién es, cuántos miembros habrá y si se divide por sura o por yuz.';

  @override
  String get onb2Title => 'Sigue el progreso';

  @override
  String get onb2Body =>
      'Reserva lo que leerás, márcalo como hecho con un toque y sigue el progreso y quién lee qué hasta completar la khatma.';

  @override
  String get onb3Title => 'Todas tus khatmas en un solo lugar';

  @override
  String get onb3Body =>
      'Tus khatmas activas y completadas a la vista, actualizadas al instante cada vez que alguien lee.';

  @override
  String get onb4Title => 'Tus amigos contigo';

  @override
  String get onb4Body =>
      'Sigue a tus amigos y sus niveles, y competid en el bien en la clasificación.';

  @override
  String get onb5Title => 'Encuentra personas';

  @override
  String get onb5Body =>
      'Busca a tus amigos por nombre y envía o acepta solicitudes para compartir khatmas.';

  @override
  String get onb6Title => 'Adelante, que Allah te ayude';

  @override
  String get onb6Body =>
      'Prepárate para tu viaje con el Corán. Ya sea que empieces una khatma o te unas a otra, completa tu porción diaria por la gracia de Allah.';
}
