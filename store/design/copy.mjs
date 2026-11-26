// Store screenshot copy. Each slide: headline (2 lines, the 2nd in the accent), sub, chips, and the raw
// screens shown in the phones (store/raw/<lang>/<name>.png).
export const slides = [
  { id: '01', screens: ['01_home', '02_khatma_juz'], chips: ['group', 'book', 'bolt'] },
  { id: '02', screens: ['06_create', '03_khatma_sura'], chips: ['split', 'group', 'key'] },
  { id: '03', screens: ['03_khatma_sura'], chips: ['check', 'bolt', 'filter'], single: true },
  { id: '04', screens: ['07_join', '04_members'], chips: ['key', 'search', 'group'] },
  { id: '05', screens: ['05_activity', '04_members'], chips: ['bolt', 'history', 'group'] },
  { id: '06', screens: ['13_reader_saved', '14_reader_info'], chips: ['book', 'bookmark', 'bolt'] },
  { id: '07', screens: ['12_profile_stats', '11_profile_khatmas'], chips: ['star', 'chart', 'book'] },
  { id: '08', screens: ['10_rankings', '09_profile_friends'], chips: ['trophy', 'star', 'group'] },
];

export const copy = {
  ar: {
    brand: 'ختمتي',
    s: {
      '01': ['اختموا القرآن', 'معاً، بكل سهولة', 'ختمة جماعية مع العائلة والأصدقاء وأهل المسجد', ['ختمات جماعية', 'مصحف مدمج', 'تقدّم مباشر']],
      '02': ['أنشئ ختمة', 'في ثوانٍ', 'لفائدة من تحب، بالسور أو بالأجزاء، وحدّد عدد المشاركين', ['114 سورة أو 30 جزءاً', 'حتى 999 مشاركاً', 'رمز من 5 أرقام']],
      '03': ['احجز جزءك', 'وأتمّه بلمسة', 'كل جزء يُظهر حالته: متاح، محجوز لك، أو مكتمل', ['حجز وإتمام', 'تراجع متى شئت', 'تصفية سريعة']],
      '04': ['شارك الرمز', 'وانضموا معاً', 'انضم بالرمز أو ابحث عن الختمة باسمها', ['رمز الانضمام', 'البحث بالاسم', 'قائمة المشاركين']],
      '05': ['تقدّم مباشر', 'يراه الجميع', 'من أتمّ ماذا، ومن يقرأ الآن، وسجل كامل للنشاط', ['تحديث فوري', 'سجل النشاط', 'المشاركون']],
      '06': ['اقرأ في المصحف', 'واحفظ موضع وقوفك', 'المس الآية لحفظها، ويعيدك التطبيق إليها في المرة القادمة', ['المصحف كاملاً', 'علامة توقف', 'يعمل فوراً']],
      '07': ['نقاط ومستويات', 'وإحصائيات قراءتك', 'كم مرة قرأت كل سورة وكل جزء، وختماتك في مكان واحد', ['نقاط الخبرة', 'إحصائيات السور', 'ختماتك']],
      '08': ['تنافسوا', 'في الخير', 'لوحة المتصدرين حسب النقاط: اليوم، الأسبوع، الكل', ['لوحة المتصدرين', 'المستويات', 'الأصدقاء']],
    },
    feature: ['اختموا القرآن', 'معاً، بكل سهولة', 'أنشئ ختمة، شارك رمزها، احجز جزءك وتابع التقدم مباشرة', ['ختمات جماعية', 'مصحف مدمج', 'نقاط ومستويات', '4 لغات'], 'مجاني • بدون إعلانات • صدقة جارية'],
  },
  en: {
    brand: 'Khetmti',
    s: {
      '01': ['Finish the Quran', 'together, easily', 'Group khatmas with family, friends and your mosque', ['Group khatmas', 'Built-in mushaf', 'Live progress']],
      '02': ['Create a khatma', 'in seconds', 'Dedicate it to a loved one, split by surah or juz, set the members', ['114 surahs or 30 juz', 'Up to 999 members', '5-digit code']],
      '03': ['Reserve your part,', 'finish with a tap', 'Every part shows its state: free, yours, or done', ['Reserve & finish', 'Undo anytime', 'Quick filters']],
      '04': ['Share a code,', 'join together', 'Join with the code or find the khatma by name', ['Join code', 'Search by name', 'Members list']],
      '05': ['Live progress', 'for everyone', 'Who finished what, who is reading now, full activity log', ['Instant updates', 'Activity log', 'Members']],
      '06': ['Read the Quran,', 'save your place', 'Tap an ayah to bookmark it, the app brings you back next time', ['Full mushaf', 'Stopping point', 'Opens instantly']],
      '07': ['Points, levels', 'and your stats', 'How many times you read each surah and juz, all your khatmas', ['XP points', 'Surah stats', 'Your khatmas']],
      '08': ['Compete', 'in goodness', 'Leaderboard ranked by XP: today, this week, all time', ['Leaderboard', 'Levels & ranks', 'Friends']],
    },
    feature: ['Finish the Quran', 'together.', 'Create a khatma, share its code, reserve your part and follow the progress live.', ['Group khatmas', 'Built-in mushaf', 'Points & levels', '4 languages'], 'Free • No ads • Sadaqa jariya'],
  },
  fr: {
    brand: 'Khetmti',
    s: {
      '01': ['Terminez le Coran', 'ensemble, facilement', 'Des khatmas en groupe, en famille, entre amis ou à la mosquée', ['Khatmas en groupe', 'Mushaf intégré', 'Progression en direct']],
      '02': ['Créez une khatma', 'en quelques secondes', 'Dédiée à un proche, par sourate ou par juz, avec vos membres', ['114 sourates ou 30 juz', "Jusqu'à 999 membres", 'Code à 5 chiffres']],
      '03': ['Réservez votre partie,', "validez-la d'un geste", 'Chaque partie affiche son état : libre, à vous, terminée', ['Réserver & valider', 'Revenir à tout moment', 'Filtres rapides']],
      '04': ['Partagez le code,', 'rejoignez-vous', 'Rejoignez avec le code ou cherchez la khatma par son nom', ['Code pour rejoindre', 'Recherche par nom', 'Liste des membres']],
      '05': ['Une progression', 'en direct pour tous', "Qui a terminé quoi, qui lit maintenant, et tout l'historique", ['Mise à jour instantanée', "Journal d'activité", 'Membres']],
      '06': ['Lisez le Coran,', 'gardez votre page', "Touchez un verset pour le marquer, l'app vous y ramène", ['Mushaf complet', "Point d'arrêt", 'Ouverture immédiate']],
      '07': ['Points, niveaux', 'et statistiques', 'Combien de fois vous avez lu chaque sourate et chaque juz', ['Points XP', 'Stats des sourates', 'Vos khatmas']],
      '08': ['Rivalisez', 'dans le bien', 'Classement par points : aujourd’hui, semaine, depuis toujours', ['Classement', 'Niveaux & rangs', 'Amis']],
    },
    feature: ['Terminez le Coran', 'ensemble.', 'Créez une khatma, partagez son code, réservez votre partie et suivez la progression en direct.', ['Khatmas en groupe', 'Mushaf intégré', 'Points & niveaux', '4 langues'], 'Gratuit • Sans pub • Sadaqa jariya'],
  },
  es: {
    brand: 'Khetmti',
    s: {
      '01': ['Completa el Corán', 'juntos, fácilmente', 'Khatmas en grupo con tu familia, amigos o mezquita', ['Khatmas en grupo', 'Mushaf integrado', 'Progreso en directo']],
      '02': ['Crea una khatma', 'en segundos', 'Dedícala a un ser querido, por sura o por yuz, elige los miembros', ['114 suras o 30 yuz', 'Hasta 999 miembros', 'Código de 5 dígitos']],
      '03': ['Reserva tu parte,', 'termínala con un toque', 'Cada parte muestra su estado: libre, tuya o terminada', ['Reservar y terminar', 'Deshacer cuando quieras', 'Filtros rápidos']],
      '04': ['Comparte el código,', 'uníos juntos', 'Únete con el código o busca la khatma por su nombre', ['Código para unirse', 'Buscar por nombre', 'Lista de miembros']],
      '05': ['Progreso en directo', 'para todos', 'Quién terminó qué, quién está leyendo y todo el historial', ['Al instante', 'Registro de actividad', 'Miembros']],
      '06': ['Lee el Corán,', 'guarda tu lugar', 'Toca una aleya para marcarla, la app te lleva a ella', ['Mushaf completo', 'Punto de parada', 'Abre al instante']],
      '07': ['Puntos, niveles', 'y estadísticas', 'Cuántas veces leíste cada sura y cada yuz, y tus khatmas', ['Puntos XP', 'Estadísticas de suras', 'Tus khatmas']],
      '08': ['Compite', 'en el bien', 'Clasificación por puntos: hoy, esta semana, de siempre', ['Clasificación', 'Niveles y rangos', 'Amigos']],
    },
    feature: ['Completa el Corán', 'juntos.', 'Crea una khatma, comparte su código, reserva tu parte y sigue el progreso en directo.', ['Khatmas en grupo', 'Mushaf integrado', 'Puntos y niveles', '4 idiomas'], 'Gratis • Sin anuncios • Sadaqa yariya'],
  },
};
