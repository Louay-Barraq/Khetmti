import 'dart:math';
import 'package:supabase_flutter/supabase_flutter.dart';

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

  /// The khatmas with these [ids], live: progress made by any participant
  /// shows up straight away.
  Stream<List<Khetma>> khetmasStream(List<String> ids) {
    return _supabase
        .from('khatms')
        .stream(primaryKey: ['doc_id'])
        .inFilter('doc_id', ids)
        .map((rows) => rows.map(Khetma.fromSupabase).toList());
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

    final row = await _supabase
        .from('khatms')
        .insert({
          'name': name,
          'code': await _generateUniqueCode(),
          'creatorId': _supabase.auth.currentUser!.id,
          'splitType': splitType,
          'maxParticipantsNumber': maxParticipants,
          'parts': getEmptyPartsMap(items),
          'totalParts': items.length,
        })
        .select('doc_id')
        .single();

    return row['doc_id'] as String;
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

  Future<List<Khetma>> searchByName(String name) async {
    final rows = await _supabase
        .from('khatms')
        .select()
        .ilike('name', '%$name%')
        .limit(10);

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

  Future<String> _generateUniqueCode() async {
    final random = Random();
    while (true) {
      final code = (random.nextInt(90000) + 10000).toString();
      final existing = await _supabase
          .from('khatms')
          .select('doc_id')
          .eq('code', code)
          .maybeSingle();
      if (existing == null) return code;
    }
  }
}
