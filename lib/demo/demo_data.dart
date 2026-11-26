// Demo data for store screenshots (lib/main_screenshots.dart only; never used by the real app).
// Names and khatma dedications follow the app language.
import 'package:khetmti/features/auth/models/app_user.dart';
import 'package:khetmti/features/khetma/models/khetma.dart';
import 'package:khetmti/features/khetma/models/khetma_log.dart';
import 'package:khetmti/features/khetma/models/khetma_part.dart';
import 'package:khetmti/features/quran/models/quran_data.dart';
import 'package:khetmti/features/social/models/friendship.dart';
import 'package:khetmti/l10n/l10n.dart';

const demoUserId = 'u_me';

String _pick(Map<String, String> byLang) => byLang[L10n.locale.languageCode] ?? byLang['en']!;

final _now = DateTime.now();

class _P {
  final String id, ar, latin;
  final int xp;
  final int lastSeenMin;
  const _P(this.id, this.ar, this.latin, this.xp, this.lastSeenMin);
}

const _people = [
  _P('u_rania', 'رانية بن خليفة', 'Rania Ben Khalifa', 14200, 3),
  _P('u_ali', 'علي بن جمعة', 'Ali Ben Jemaa', 11800, 0),
  _P(demoUserId, 'محمد بن أمين', 'Mohamed Amine', 10400, 0),
  _P('u_sara', 'سارة المنصوري', 'Sara Mansouri', 8700, 45),
  _P('u_youssef', 'يوسف الحداد', 'Youssef Haddad', 6100, 180),
  _P('u_fatma', 'فاطمة الزهراء', 'Fatma Zahra', 4300, 1440),
];

String _name(_P p) => L10n.isArabic ? p.ar : p.latin;
_P _p(String id) => _people.firstWhere((p) => p.id == id);

Map<String, int> _stats() {
  final s = <String, int>{};
  final suras = sourasWithAyahs.keys.toList();
  for (var i = 0; i < suras.length; i++) {
    s[suras[i]] = const [5, 3, 2, 2, 1, 1, 2, 1, 1, 1][i % 10] + (i < 3 ? 4 : 0) + (i > 100 ? 6 : 0);
  }
  for (var i = 0; i < juzusList.length; i++) {
    s[juzusList[i]] = const [4, 2, 3, 1, 2, 1][i % 6] + (i == 29 ? 5 : 0);
  }
  return s;
}

AppUser _user(_P p) => AppUser(
      uid: p.id,
      username: _name(p),
      totalXP: p.xp,
      readingStats: p.id == demoUserId ? _stats() : const {},
      createdAt: DateTime(2026, 3, 1),
      lastSeen: _now.subtract(Duration(minutes: p.lastSeenMin)),
    );

AppUser get demoMe => _user(_p(demoUserId));
List<AppUser> get demoFriends => [for (final p in _people) if (p.id != demoUserId) _user(p)];

List<FriendRequest> get demoRequests => [
      FriendRequest(requestId: 'r1', senderId: 'u_omar', username: L10n.isArabic ? 'عمر الشريف' : 'Omar Cherif', level: 6),
      FriendRequest(requestId: 'r2', senderId: 'u_maryam', username: L10n.isArabic ? 'مريم العلوي' : 'Maryam Alaoui', level: 4),
    ];

/// part status per member: (uid, status)
Khetma _khetma({
  required String id,
  required String name,
  required String code,
  required String split,
  required int members,
  required int max,
  required Map<int, (String, String)> taken,
  required DateTime created,
}) {
  final names = split == 'sura' ? sourasWithAyahs.keys.toList() : juzusList;
  final parts = <String, KhetmaPart>{};
  for (var i = 0; i < names.length; i++) {
    final t = taken[i];
    parts[names[i]] = t == null
        ? const KhetmaPart()
        : KhetmaPart(status: t.$2, uid: t.$1, username: _name(_p(t.$1)));
  }
  final finished = parts.values.where((p) => p.isFinished).length;
  final logs = <KhetmaLog>[
    for (final e in taken.entries.toList().reversed.take(12))
      KhetmaLog(
        username: _name(_p(e.value.$1)),
        uid: e.value.$1,
        part: names[e.key],
        action: e.value.$2 == 'finished' ? 'أتم القراءة' : 'حجز',
        timestamp: _now.subtract(Duration(minutes: 17 * (e.key + 1))),
      ),
  ];
  return Khetma(
    khetmaId: id,
    name: name,
    code: code,
    creatorId: demoUserId,
    splitType: split,
    currentParticipantsNumber: members,
    maxParticipantsNumber: max,
    parts: parts,
    finishedParts: finished,
    totalParts: names.length,
    completionPercent: finished / names.length,
    logs: logs,
    createdAt: created,
    updatedAt: _now,
  );
}

const _ids = ['u_me', 'u_rania', 'u_ali', 'u_sara', 'u_youssef', 'u_fatma'];

List<Khetma> get demoKhetmas {
  // 30 juz, 16 finished, a few being read: 53 %
  final juz = <int, (String, String)>{};
  for (var i = 0; i < 16; i++) {
    juz[i] = (_ids[i % 6], 'finished');
  }
  juz[16] = (demoUserId, 'reserved');
  juz[17] = ('u_rania', 'reserved');
  juz[18] = ('u_ali', 'reserved');
  juz[20] = ('u_sara', 'reserved');

  // 114 surahs, Al-Fatiha reserved by me (shows the Done button), 12 %
  final sura = <int, (String, String)>{0: (demoUserId, 'reserved'), 1: ('u_rania', 'reserved'), 2: ('u_ali', 'reserved')};
  for (var i = 3; i < 17; i++) {
    sura[i] = (_ids[(i + 1) % 6], 'finished');
  }
  sura[17] = ('u_youssef', 'reserved');

  final done = <int, (String, String)>{for (var i = 0; i < 30; i++) i: (_ids[i % 6], 'finished')};

  return [
    _khetma(
      id: 'k1',
      name: _pick({'ar': 'جدي رحمه الله', 'en': 'my late grandfather', 'fr': 'mon grand-père, paix à son âme', 'es': 'mi difunto abuelo'}),
      code: '73905', split: 'juzu', members: 6, max: 10, taken: juz, created: DateTime(2026, 11, 8)),
    _khetma(
      id: 'k2',
      name: _pick({'ar': 'شعب فلسطين', 'en': 'the people of Palestine', 'fr': 'le peuple de Palestine', 'es': 'el pueblo de Palestina'}),
      code: '48213', split: 'sura', members: 5, max: 10, taken: sura, created: DateTime(2026, 11, 15)),
    _khetma(
      id: 'k3',
      name: _pick({'ar': 'أمي حفظها الله', 'en': 'my mother, may Allah protect her', 'fr': "ma mère, qu'Allah la protège", 'es': 'mi madre, que Allah la proteja'}),
      code: '61427', split: 'juzu', members: 6, max: 6, taken: done, created: DateTime(2026, 10, 2)),
  ];
}

List<AppUser> demoParticipants(String khetmaId) => [demoMe, ...demoFriends.take(khetmaId == 'k2' ? 4 : 5)];
