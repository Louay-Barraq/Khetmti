import 'dart:math';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:khetmti/features/khetma/models/khetma.dart';
import 'package:khetmti/features/quran/models/quran_data.dart';
import 'package:khetmti/core/utils/helpers.dart';

class KhetmaRepository {
  final SupabaseClient _supabase;

  KhetmaRepository(this._supabase);

  String? get _currentUserId => _supabase.auth.currentUser?.id;

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

  Stream<List<Khetma>> userKhetmasStream({required bool completed}) {
    final userId = _currentUserId;
    if (userId == null) return Stream.value([]);

    return _supabase
        .from('users')
        .stream(primaryKey: ['doc_id'])
        .eq('doc_id', userId)
        .asyncMap((rows) async {
      if (rows.isEmpty) return <Khetma>[];

      final khatmsJoined =
          List<String>.from(rows.first['khatmsJoined'] ?? []);
      if (khatmsJoined.isEmpty) return <Khetma>[];

      final khatmRows = await _supabase
          .from('khatms')
          .select()
          .inFilter('doc_id', khatmsJoined);

      return khatmRows
          .map((row) => Khetma.fromSupabase(row))
          .where((k) => completed ? k.isCompleted : !k.isCompleted)
          .toList();
    });
  }

  // --- Create ---

  Future<String> createKhetma({
    required String name,
    required String splitType,
    required int maxParticipants,
  }) async {
    final userId = _currentUserId!;
    final uniqueCode = await _generateUniqueCode();

    final items =
        splitType == 'sura' ? sourasWithAyahs.keys.toList() : juzusList;

    final partsMap = getEmptyPartsMap(items);

    final khetmaId = _generateDocId();

    await _supabase.from('khatms').insert({
      'doc_id': khetmaId,
      'name': name,
      'code': uniqueCode,
      'creatorId': userId,
      'splitType': splitType,
      'currentParticipantsNumber': 1,
      'maxParticipantsNumber': maxParticipants,
      'parts': partsMap,
      'completionPercent': 0.0,
      'finishedParts': 0,
      'totalParts': items.length,
      'logs': [],
      'status': 'active',
      'createdAt': DateTime.now().toIso8601String(),
      'updatedAt': DateTime.now().toIso8601String(),
    });

    // Add to khatm_participants join table
    await _supabase.from('khatm_participants').insert({
      'khatm_id': khetmaId,
      'user_id': userId,
      'progress': 0.0,
    });

    // Update user's khatmsJoined array
    final profile = await _supabase
        .from('users')
        .select('khatmsJoined')
        .eq('doc_id', userId)
        .single();
    final khatmsJoined = List<String>.from(profile['khatmsJoined'] ?? []);
    if (!khatmsJoined.contains(khetmaId)) {
      khatmsJoined.add(khetmaId);
      await _supabase.from('users').update({
        'khatmsJoined': khatmsJoined,
      }).eq('doc_id', userId);
    }

    return khetmaId;
  }

  // --- Join ---

  Future<void> joinKhetma(String khetmaId) async {
    final userId = _currentUserId;
    if (userId == null) throw Exception("يجب تسجيل الدخول أولاً");

    final row = await _supabase
        .from('khatms')
        .select()
        .eq('doc_id', khetmaId)
        .maybeSingle();

    if (row == null) throw Exception("الختمة غير موجودة");

    // Check if already a participant via join table
    final existing = await _supabase
        .from('khatm_participants')
        .select()
        .eq('khatm_id', khetmaId)
        .eq('user_id', userId)
        .maybeSingle();

    if (existing != null) {
      showWarningToast("أنت منضم بالفعل لهذه الختمة");
      return;
    }

    final int current = row['currentParticipantsNumber'] ?? 0;
    final int maxP = row['maxParticipantsNumber'] ?? 999;

    if (current >= maxP) {
      throw Exception("عذراً، هذه الختمة مكتملة العدد");
    }

    // Add to join table
    await _supabase.from('khatm_participants').insert({
      'khatm_id': khetmaId,
      'user_id': userId,
      'progress': 0.0,
    });

    // Update participant count on khatms
    await _supabase.from('khatms').update({
      'currentParticipantsNumber': current + 1,
    }).eq('doc_id', khetmaId);

    // Update user's khatmsJoined
    final profile = await _supabase
        .from('users')
        .select('khatmsJoined')
        .eq('doc_id', userId)
        .single();
    final khatmsJoined = List<String>.from(profile['khatmsJoined'] ?? []);
    if (!khatmsJoined.contains(khetmaId)) {
      khatmsJoined.add(khetmaId);
      await _supabase.from('users').update({
        'khatmsJoined': khatmsJoined,
      }).eq('doc_id', userId);
    }
  }

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

  Future<void> deleteKhetma(String khetmaId) async {
    await _supabase
        .from('khatm_participants')
        .delete()
        .eq('khatm_id', khetmaId);
    await _supabase.from('khatms').delete().eq('doc_id', khetmaId);
  }

  // --- Update Part Status ---

  Future<void> updatePartStatus({
    required String khetmaId,
    required String partName,
    required String newStatus,
  }) async {
    final userId = _currentUserId!;
    final user = _supabase.auth.currentUser!;
    final username =
        user.userMetadata?['username'] as String? ??
        user.userMetadata?['name'] as String? ??
        'Unknown';

    final khetmaRow = await _supabase
        .from('khatms')
        .select()
        .eq('doc_id', khetmaId)
        .single();

    final userRow = await _supabase
        .from('users')
        .select()
        .eq('doc_id', userId)
        .single();

    final parts = Map<String, dynamic>.from(khetmaRow['parts'] ?? {});

    // If the part doesn't exist in the DB yet, initialize it as available
    if (!parts.containsKey(partName)) {
      parts[partName] = {'status': 'available', 'uid': null, 'username': null};
    }

    final part = Map<String, dynamic>.from(parts[partName]);
    final oldStatus = part['status'] ?? 'available';
    final partUid = part['uid'] as String?;

    if (!_isValidTransition(oldStatus, newStatus, partUid, userId)) return;

    part['status'] = newStatus;
    part['uid'] = newStatus == 'available' ? null : userId;
    part['username'] = newStatus == 'available' ? null : username;
    parts[partName] = part;

    int finishedParts = khetmaRow['finishedParts'] ?? 0;
    if (newStatus == 'finished' && oldStatus != 'finished') finishedParts++;
    if (oldStatus == 'finished' && newStatus != 'finished') finishedParts--;

    final totalParts = khetmaRow['totalParts'] ?? 1;
    final completionPercent = finishedParts / totalParts;

    String actionText = '';
    if (newStatus == 'reserved' && oldStatus == 'available') {
      actionText = 'حجز';
    } else if (newStatus == 'finished') {
      actionText = 'أتم القراءة';
    } else if (newStatus == 'available') {
      actionText = 'ألغى الحجز';
    } else if (newStatus == 'reserved' && oldStatus == 'finished') {
      actionText = 'تراجع عن القراءة';
    }

    final logs = List<Map<String, dynamic>>.from(khetmaRow['logs'] ?? []);
    logs.add({
      'username': username,
      'uid': userId,
      'part': partName,
      'action': actionText,
      'timestamp': DateTime.now().toIso8601String(),
    });

    await _supabase.from('khatms').update({
      'parts': parts,
      'finishedParts': finishedParts,
      'completionPercent': completionPercent,
      'updatedAt': DateTime.now().toIso8601String(),
      'logs': logs,
    }).eq('doc_id', khetmaId);

    // XP + level update on user profile
    final xpReward = _calculateXpReward(
      oldStatus: oldStatus,
      newStatus: newStatus,
      splitType: khetmaRow['splitType'] ?? 'sura',
      partName: partName,
    );

    int currentXP = userRow['totalXP'] ?? 0;
    final newTotalXP = max(0, currentXP + xpReward);
    final newLevel = (log(newTotalXP / 5000 + 1) / log(1.2)).floor() + 1;

    final readingStats =
        Map<String, dynamic>.from(userRow['readingStats'] ?? {});
    if (newStatus == 'finished' && oldStatus != 'finished') {
      readingStats[partName] = ((readingStats[partName] ?? 0) as num).toInt() + 1;
    } else if (oldStatus == 'finished' && newStatus != 'finished') {
      readingStats[partName] = max(0, ((readingStats[partName] ?? 0) as num).toInt() - 1);
    }

    final khatmsJoined = List<String>.from(userRow['khatmsJoined'] ?? []);
    if (!khatmsJoined.contains(khetmaId)) {
      khatmsJoined.add(khetmaId);
    }

    await _supabase.from('users').update({
      'totalXP': newTotalXP,
      'level': newLevel,
      'readingStats': readingStats,
      'khatmsJoined': khatmsJoined,
    }).eq('doc_id', userId);

    // Record XP history
    if (xpReward != 0) {
      await _supabase.from('xp_history').insert({
        'user_id': userId,
        'amount': xpReward,
        'reason': '$actionText $partName',
      });
    }
  }

  // --- Private Helpers ---

  bool _isValidTransition(
      String oldStatus, String newStatus, String? partUid, String userId) {
    if (newStatus == 'reserved' && oldStatus == 'available') {
      return true;
    }
    if (newStatus == 'available' &&
        oldStatus == 'reserved' &&
        partUid == userId) {
      return true;
    }
    if (newStatus == 'finished' &&
        oldStatus == 'reserved' &&
        partUid == userId) {
      return true;
    }
    if (newStatus == 'reserved' &&
        oldStatus == 'finished' &&
        partUid == userId) {
      return true;
    }
    return false;
  }

  int _calculateXpReward({
    required String oldStatus,
    required String newStatus,
    required String splitType,
    required String partName,
  }) {
    if (oldStatus == 'available' && newStatus == 'reserved') return 10;
    if (oldStatus == 'reserved' && newStatus == 'available') return -10;
    if (oldStatus == 'reserved' && newStatus == 'finished') {
      if (splitType == 'sura') {
        final ayahs = sourasWithAyahs[partName] ?? 0;
        return 50 + (ayahs * 2);
      }
      return 500;
    }
    if (oldStatus == 'finished' && newStatus == 'reserved') {
      if (splitType == 'sura') {
        final ayahs = sourasWithAyahs[partName] ?? 0;
        return -(50 + (ayahs * 2));
      }
      return -500;
    }
    return 0;
  }

  String _generateDocId() {
    const chars = 'abcdefghijklmnopqrstuvwxyz0123456789';
    final random = Random();
    return List.generate(20, (_) => chars[random.nextInt(chars.length)]).join();
  }

  Future<String> _generateUniqueCode() async {
    final random = Random();
    String code = '';
    bool codeExists = true;

    while (codeExists) {
      code = (random.nextInt(90000) + 10000).toString();
      final existing = await _supabase
          .from('khatms')
          .select('doc_id')
          .eq('code', code)
          .maybeSingle();
      if (existing == null) codeExists = false;
    }

    return code;
  }
}
