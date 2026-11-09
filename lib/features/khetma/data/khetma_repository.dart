import 'dart:math';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:khetmti/core/cache/local_cache.dart';
import 'package:khetmti/features/auth/models/app_user.dart';

import 'package:khetmti/features/khetma/models/khetma.dart';
import 'package:khetmti/features/quran/models/quran_data.dart';

/// Arabic messages for the errors raised by the `join_khatm` and
/// `update_part_status` database functions.
const _rpcErrors = {
  'not_authenticated': 'يجب تسجيل الدخول أولاً',
  'khatm_not_found': 'الختمة غير موجودة',
  'already_joined': 'أنت منضم بالفعل لهذه الختمة',
  'khatm_full': 'عذراً، هذه الختمة مكتملة العدد',
  'not_a_participant': 'يجب الانضمام إلى الختمة أولاً',
  'invalid_transition': 'لم يعد هذا الجزء متاحاً',
};

class KhetmaRepository {
  final SupabaseClient _supabase;

  KhetmaRepository(this._supabase);

  // --- Streams ---

  /// One khatma, live. Used for khatmas the user has not joined (yet).
  Stream<Khetma> khetmaStream(String khetmaId) {
    return _supabase
        .from('khatms')
        .stream(primaryKey: ['doc_id'])
        .eq('doc_id', khetmaId)
        .map((rows) {
          if (rows.isEmpty) throw Exception('Khetma not found');
          return Khetma.fromSupabase(rows.first);
        });
  }

  /// IDs of the khatmas [userId] takes part in, live.
  Stream<List<String>> joinedKhetmaIdsStream(String userId) {
    return _supabase
        .from('khatm_participants')
        .stream(primaryKey: ['khatm_id', 'user_id'])
        .eq('user_id', userId)
        .map((rows) => [for (final r in rows) r['khatm_id'] as String]);
  }

  /// Rows of the khatmas with these [ids], live: progress made by any
  /// participant shows up straight away.
  Stream<List<DbRow>> khetmaRows(List<String> ids) {
    return _supabase
        .from('khatms')
        .stream(primaryKey: ['doc_id'])
        .inFilter('doc_id', ids);
  }

  /// Everyone who joined [khetmaId], in joining order, with their profile.
  Future<List<AppUser>> participants(String khetmaId) async {
    final rows = await _supabase
        .from('khatm_participants')
        .select('users(doc_id, username, "totalXP", "createdAt", "lastSeen")')
        .eq('khatm_id', khetmaId)
        .order('joinedAt', ascending: true);
    return [
      for (final r in rows)
        if (r['users'] case final Map<String, dynamic> user)
          AppUser.fromSupabase(user),
    ];
  }

  // --- Create ---

  /// Creates a khatma; the database adds the creator as its first participant.
  Future<String> createKhetma({
    required String name,
    required String splitType,
    required int maxParticipants,
  }) async {
    final items =
        splitType == 'sura' ? sourasWithAyahs.keys.toList() : juzusList;

    // The code is unique in the database; on the rare clash, draw another.
    for (var attempt = 0;; attempt++) {
      try {
        final row = await _supabase
            .from('khatms')
            .insert({
              'name': name,
              'code': _randomCode(),
              'creatorId': _supabase.auth.currentUser!.id,
              'splitType': splitType,
              'maxParticipantsNumber': maxParticipants,
              'parts': getEmptyPartsMap(items),
              'totalParts': items.length,
            })
            .select('doc_id')
            .single();
        return row['doc_id'] as String;
      } on PostgrestException catch (e) {
        if (e.code != '23505' || attempt == 4) rethrow;
      }
    }
  }

  // --- Join ---

  Future<void> joinKhetma(String khetmaId) =>
      _rpc('join_khatm', {'p_khatm_id': khetmaId});

  Future<String?> joinByCode(String code) async {
    final row = await _supabase
        .from('khatms')
        .select('doc_id')
        .eq('code', code)
        .maybeSingle();

    if (row == null) return null;

    final khetmaId = row['doc_id'] as String;
    await joinKhetma(khetmaId);
    return khetmaId;
  }

  /// Only the columns the result list shows: not the 114 parts or the log.
  Future<List<Khetma>> searchByName(String name) async {
    final pattern = name.replaceAll(r'\', r'\\').replaceAll('%', r'\%').replaceAll('_', r'\_');
    final rows = await _supabase
        .from('khatms')
        .select('doc_id, name, "splitType", "currentParticipantsNumber", '
            '"maxParticipantsNumber", "completionPercent"')
        .ilike('name', '%$pattern%')
        .limit(20);

    return rows.map((row) => Khetma.fromSupabase(row)).toList();
  }

  // --- Delete ---

  /// Only the creator may delete; participants are removed by the database.
  Future<void> deleteKhetma(String khetmaId) async {
    await _supabase.from('khatms').delete().eq('doc_id', khetmaId);
  }

  // --- Update Part Status ---

  /// Reserve, release, finish or un-finish a part. The database checks the
  /// move, updates the khatma and gives the XP in one transaction.
  Future<void> updatePartStatus({
    required String khetmaId,
    required String partName,
    required String newStatus,
  }) =>
      _rpc('update_part_status', {
        'p_khatm_id': khetmaId,
        'p_part': partName,
        'p_new_status': newStatus,
      });

  // --- Private Helpers ---

  /// Calls a database function and turns its error codes into Arabic messages.
  Future<void> _rpc(String fn, Map<String, dynamic> params) async {
    try {
      await _supabase.rpc(fn, params: params);
    } on PostgrestException catch (e) {
      throw Exception(_rpcErrors[e.message] ?? 'حدث خطأ، يرجى المحاولة مرة أخرى');
    }
  }

  static final _random = Random();

  static String _randomCode() => (_random.nextInt(90000) + 10000).toString();
}
