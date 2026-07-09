import '../../core/spaced_repetition/sm2_scheduler.dart';

/// Persisted spaced-repetition state for one (user, card) pair, where a
/// "card" is either a [Question] id or a [Flashcard] id — both share the
/// same SM-2 schedule so a single review queue can mix quiz questions and
/// flashcards.
class SrsState {
  final String cardId;
  final SrsCardState schedule;
  final int totalReviews;
  final int correctReviews;

  const SrsState({
    required this.cardId,
    required this.schedule,
    required this.totalReviews,
    required this.correctReviews,
  });

  factory SrsState.initial(String cardId, {DateTime? now}) => SrsState(
        cardId: cardId,
        schedule: SrsCardState.initial(now: now),
        totalReviews: 0,
        correctReviews: 0,
      );

  double get accuracy => totalReviews == 0 ? 0 : correctReviews / totalReviews;

  SrsState withReview(SrsCardState newSchedule, {required bool wasCorrect}) {
    return SrsState(
      cardId: cardId,
      schedule: newSchedule,
      totalReviews: totalReviews + 1,
      correctReviews: correctReviews + (wasCorrect ? 1 : 0),
    );
  }
}
