import '../../core/spaced_repetition/sm2_scheduler.dart';
import '../entities/question.dart';
import '../entities/quiz_session.dart';
import '../repositories/progress_repository.dart';

class SubmitQuizAnswerResult {
  final QuizAnswer answer;
  final int xpEarned;

  const SubmitQuizAnswerResult({required this.answer, required this.xpEarned});
}

/// Grades a single quiz answer, updates the learner's spaced-repetition
/// schedule for that question, and awards XP.
///
/// XP rewards scale with question difficulty so harder D3-D5 exam-style
/// questions are worth more than D1 foundation questions, encouraging
/// learners to keep attempting difficult material instead of farming easy
/// questions for score.
class SubmitQuizAnswerUseCase {
  final ProgressRepository progressRepository;

  SubmitQuizAnswerUseCase({required this.progressRepository});

  static const int _baseXp = 10;

  Future<SubmitQuizAnswerResult> call({
    required String userId,
    required Question question,
    required List<int> selectedOptionIndexes,
    required Duration timeTaken,
  }) async {
    final wasCorrect = question.isCorrect(selectedOptionIndexes);

    final grade = wasCorrect
        ? (timeTaken.inSeconds < 15 ? RecallGrade.easy : RecallGrade.good)
        : RecallGrade.again;

    await progressRepository.gradeReview(
      cardId: question.id,
      grade: grade,
      wasCorrect: wasCorrect,
    );

    final xpEarned = wasCorrect ? _baseXp * question.difficulty : 0;

    for (final topicId in question.topicIds) {
      await progressRepository.recordAnswer(
        userId: userId,
        topicId: topicId,
        wasCorrect: wasCorrect,
        xpEarned: xpEarned,
      );
    }

    return SubmitQuizAnswerResult(
      answer: QuizAnswer(
        questionId: question.id,
        selectedOptionIndexes: selectedOptionIndexes,
        wasCorrect: wasCorrect,
        timeTaken: timeTaken,
      ),
      xpEarned: xpEarned,
    );
  }
}
