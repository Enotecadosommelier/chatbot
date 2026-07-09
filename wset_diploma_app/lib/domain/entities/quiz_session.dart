import 'question.dart';

class QuizAnswer {
  final String questionId;
  final List<int> selectedOptionIndexes;
  final String freeTextAnswer;
  final bool wasCorrect;
  final Duration timeTaken;

  const QuizAnswer({
    required this.questionId,
    required this.wasCorrect,
    required this.timeTaken,
    this.selectedOptionIndexes = const [],
    this.freeTextAnswer = '',
  });
}

enum QuizSessionMode {
  adaptivePractice,
  topicDrill,
  mockExam,
  missedQuestionsReview
}

class QuizSession {
  final String id;
  final QuizSessionMode mode;
  final List<Question> questions;
  final List<QuizAnswer> answers;
  final DateTime startedAt;
  final DateTime? finishedAt;

  const QuizSession({
    required this.id,
    required this.mode,
    required this.questions,
    required this.answers,
    required this.startedAt,
    this.finishedAt,
  });

  int get correctCount => answers.where((a) => a.wasCorrect).length;
  double get scoreRatio =>
      questions.isEmpty ? 0 : correctCount / questions.length;
  bool get isComplete => answers.length == questions.length;
  Question? get currentQuestion =>
      isComplete ? null : questions[answers.length];
}
