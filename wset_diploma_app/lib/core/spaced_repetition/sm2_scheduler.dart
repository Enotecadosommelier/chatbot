/// SuperMemo-2 (SM-2) spaced repetition scheduler.
///
/// This is the same core algorithm used by the production app at
/// lib/core/spaced_repetition/sm2_scheduler.dart. Kept dependency-free so it
/// can be verified with plain `dart test` (no Flutter SDK required).
library sm2_scheduler;

/// Recall quality reported by the learner after reviewing a card, mirroring
/// the classic SM-2 0-5 scale collapsed to the 4 grades a quiz UI actually
/// needs.
enum RecallGrade { again, hard, good, easy }

extension RecallGradeQuality on RecallGrade {
  /// Maps a UI-friendly grade to the 0-5 quality value SM-2 expects.
  int get quality => switch (this) {
        RecallGrade.again => 1,
        RecallGrade.hard => 3,
        RecallGrade.good => 4,
        RecallGrade.easy => 5,
      };
}

/// Immutable scheduling state for a single flashcard/question in a user's
/// spaced-repetition deck.
class SrsCardState {
  final double easinessFactor;
  final int repetitions;
  final int intervalDays;
  final DateTime dueAt;

  const SrsCardState({
    required this.easinessFactor,
    required this.repetitions,
    required this.intervalDays,
    required this.dueAt,
  });

  factory SrsCardState.initial({DateTime? now}) => SrsCardState(
        easinessFactor: 2.5,
        repetitions: 0,
        intervalDays: 0,
        dueAt: now ?? DateTime.now(),
      );

  SrsCardState copyWith({
    double? easinessFactor,
    int? repetitions,
    int? intervalDays,
    DateTime? dueAt,
  }) {
    return SrsCardState(
      easinessFactor: easinessFactor ?? this.easinessFactor,
      repetitions: repetitions ?? this.repetitions,
      intervalDays: intervalDays ?? this.intervalDays,
      dueAt: dueAt ?? this.dueAt,
    );
  }
}

class Sm2Scheduler {
  static const double _minEasiness = 1.3;

  /// Returns the next scheduling state after the learner reviews a card and
  /// self-reports [grade].
  SrsCardState schedule(
    SrsCardState current,
    RecallGrade grade, {
    DateTime? now,
  }) {
    final reviewTime = now ?? DateTime.now();
    final quality = grade.quality;

    if (quality < 3) {
      // Lapse: restart the learning steps but keep the (slightly penalised)
      // easiness factor so the card doesn't re-graduate at full speed.
      final newEasiness =
          _clampEasiness(_updateEasiness(current.easinessFactor, quality));
      return SrsCardState(
        easinessFactor: newEasiness,
        repetitions: 0,
        intervalDays: 1,
        dueAt: reviewTime.add(const Duration(days: 1)),
      );
    }

    final newRepetitions = current.repetitions + 1;
    final int newInterval;
    if (newRepetitions == 1) {
      newInterval = 1;
    } else if (newRepetitions == 2) {
      newInterval = 6;
    } else {
      newInterval = (current.intervalDays * current.easinessFactor).round();
    }

    final newEasiness =
        _clampEasiness(_updateEasiness(current.easinessFactor, quality));

    return SrsCardState(
      easinessFactor: newEasiness,
      repetitions: newRepetitions,
      intervalDays: newInterval,
      dueAt: reviewTime.add(Duration(days: newInterval)),
    );
  }

  double _updateEasiness(double ef, int quality) {
    final delta = 0.1 - (5 - quality) * (0.08 + (5 - quality) * 0.02);
    return ef + delta;
  }

  double _clampEasiness(double ef) => ef < _minEasiness ? _minEasiness : ef;
}
