import '../../core/spaced_repetition/sm2_scheduler.dart';
import '../repositories/progress_repository.dart';

/// Applies a self-graded flashcard review to the SM-2 schedule. Flashcards
/// share the same SRS store as quiz questions (keyed by card id) so the
/// "due today" queue is a single unified list.
class ReviewFlashcardUseCase {
  final ProgressRepository progressRepository;

  ReviewFlashcardUseCase({required this.progressRepository});

  Future<void> call({
    required String flashcardId,
    required RecallGrade grade,
  }) {
    return progressRepository.gradeReview(
      cardId: flashcardId,
      grade: grade,
      wasCorrect: grade != RecallGrade.again,
    );
  }
}
