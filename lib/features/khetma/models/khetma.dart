import 'package:khetmti/features/khetma/models/khetma_part.dart';
import 'package:khetmti/features/khetma/models/khetma_log.dart';

class Khetma {
  final String khetmaId;
  final String name;
  final String code;
  final String creatorId;
  final String splitType;
  final int currentParticipantsNumber;
  final int maxParticipantsNumber;
  final Map<String, KhetmaPart> parts;
  final double completionPercent;
  final int finishedParts;
  final int totalParts;
  final List<KhetmaLog> logs;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String status;

  const Khetma({
    required this.khetmaId,
    required this.name,
    required this.code,
    required this.creatorId,
    this.splitType = 'sura',
    this.currentParticipantsNumber = 0,
    this.maxParticipantsNumber = 999,
    this.parts = const {},
    this.completionPercent = 0.0,
    this.finishedParts = 0,
    this.totalParts = 0,
    this.logs = const [],
    this.createdAt,
    this.updatedAt,
    this.status = 'active',
  });

  factory Khetma.fromSupabase(Map<String, dynamic> data) {
    final rawParts = data['parts'] as Map<String, dynamic>? ?? {};
    final parsedParts = rawParts.map(
      (key, value) => MapEntry(
        key,
        KhetmaPart.fromMap(Map<String, dynamic>.from(value)),
      ),
    );

    final rawLogs = data['logs'] as List<dynamic>? ?? [];
    final parsedLogs = rawLogs
        .map((e) => KhetmaLog.fromMap(Map<String, dynamic>.from(e)))
        .toList();

    return Khetma(
      khetmaId: data['doc_id'] ?? '',
      name: data['name'] ?? '',
      code: data['code'] ?? '',
      creatorId: data['creatorId'] ?? '',
      splitType: data['splitType'] ?? 'sura',
      currentParticipantsNumber: data['currentParticipantsNumber'] ?? 0,
      maxParticipantsNumber: data['maxParticipantsNumber'] ?? 999,
      parts: parsedParts,
      completionPercent: (data['completionPercent'] as num?)?.toDouble() ?? 0.0,
      finishedParts: data['finishedParts'] ?? 0,
      totalParts: data['totalParts'] ?? 0,
      logs: parsedLogs,
      createdAt: DateTime.tryParse('${data['createdAt'] ?? ''}'),
      updatedAt: DateTime.tryParse('${data['updatedAt'] ?? ''}'),
      status: data['status'] ?? 'active',
    );
  }

  bool get isCompleted => completionPercent >= 1.0;
}
