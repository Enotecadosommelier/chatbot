import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wset_diploma_app/core/constants/wset_modules.dart';
import 'package:wset_diploma_app/core/spaced_repetition/sm2_scheduler.dart';
import 'package:wset_diploma_app/domain/entities/question.dart';
import 'package:wset_diploma_app/domain/repositories/progress_repository.dart';
import 'package:wset_diploma_app/domain/usecases/submit_quiz_answer_usecase.dart';

class _MockProgressRepository extends Mock implements ProgressRepository {}

void main() {
  late _MockProgressRepository progressRepository;
  late SubmitQuizAnswerUseCase useCase;

  const question = Question(
    id: 'q1',
    module: WsetModule.d1,
    topicIds: ['d1.fermentation', 'd1.yeast'],
    type: QuestionType.singleChoice,
    difficulty: 3,
    prompt: 'Sample',
    options: ['A', 'B'],
    correctOptionIndexes: [1],
    explanation: 'B is correct.',
  );

  setUpAll(() {
    registerFallbackValue(RecallGrade.good);
  });

  setUp(() {
    progressRepository = _MockProgressRepository();
    useCase = SubmitQuizAnswerUseCase(progressRepository: progressRepository);

    when(
      () => progressRepository.gradeReview(
        cardId: any(named: 'cardId'),
        grade: any(named: 'grade'),
        wasCorrect: any(named: 'wasCorrect'),
      ),
    ).thenAnswer((_) async {});
    when(
      () => progressRepository.recordAnswer(
        userId: any(named: 'userId'),
        topicId: any(named: 'topicId'),
        wasCorrect: any(named: 'wasCorrect'),
        xpEarned: any(named: 'xpEarned'),
      ),
    ).thenAnswer((_) async {});
  });

  test(
      'correct answer awards XP scaled by difficulty and grades "good" or "easy"',
      () async {
    final result = await useCase.call(
      userId: 'user-1',
      question: question,
      selectedOptionIndexes: [1],
      timeTaken: const Duration(seconds: 20),
    );

    expect(result.answer.wasCorrect, isTrue);
    expect(result.xpEarned, 30); // base 10 * difficulty 3

    verify(
      () => progressRepository.gradeReview(
        cardId: 'q1',
        grade: RecallGrade.good,
        wasCorrect: true,
      ),
    ).called(1);

    // Recorded once per topic tag on the question.
    verify(
      () => progressRepository.recordAnswer(
        userId: 'user-1',
        topicId: 'd1.fermentation',
        wasCorrect: true,
        xpEarned: 30,
      ),
    ).called(1);
    verify(
      () => progressRepository.recordAnswer(
        userId: 'user-1',
        topicId: 'd1.yeast',
        wasCorrect: true,
        xpEarned: 30,
      ),
    ).called(1);
  });

  test('a fast correct answer is graded "easy"', () async {
    await useCase.call(
      userId: 'user-1',
      question: question,
      selectedOptionIndexes: [1],
      timeTaken: const Duration(seconds: 5),
    );

    verify(
      () => progressRepository.gradeReview(
        cardId: 'q1',
        grade: RecallGrade.easy,
        wasCorrect: true,
      ),
    ).called(1);
  });

  test('incorrect answer awards no XP and grades "again"', () async {
    final result = await useCase.call(
      userId: 'user-1',
      question: question,
      selectedOptionIndexes: [0],
      timeTaken: const Duration(seconds: 8),
    );

    expect(result.answer.wasCorrect, isFalse);
    expect(result.xpEarned, 0);

    verify(
      () => progressRepository.gradeReview(
        cardId: 'q1',
        grade: RecallGrade.again,
        wasCorrect: false,
      ),
    ).called(1);
  });
}
