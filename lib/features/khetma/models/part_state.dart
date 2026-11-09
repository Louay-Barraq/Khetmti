import 'package:khetmti/features/khetma/models/khetma_part.dart';

/// A part of a khatma as the current user sees it, which decides its color,
/// its label and the actions offered.
enum PartState {
  /// Nobody reserved it: the user can reserve it.
  available,

  /// Reserved by the user: they can mark it finished or release it.
  mine,

  /// Reserved by someone else: nothing to do.
  taken,

  /// Finished by the user: they can undo it.
  finishedByMe,

  /// Finished by someone else.
  finished;

  static PartState of(KhetmaPart part, String? userId) {
    final isMine = userId != null && part.uid == userId;
    return switch (part.status) {
      'reserved' => isMine ? mine : taken,
      'finished' => isMine ? finishedByMe : finished,
      _ => available,
    };
  }

  bool get isFinished => this == finishedByMe || this == finished;
}
